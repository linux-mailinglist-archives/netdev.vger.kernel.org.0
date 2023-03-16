Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF496BC4DB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCPDsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjCPDsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:48:05 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0765B95BED
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:48:03 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id bj30so488553oib.6
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1678938482;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u56PSDBVBRdGmgzPnFNjq+MAakeLoiPcG+8JP+F1je8=;
        b=BWjCm+uHiJ/MLb750Pwv0bMKJWHLAkIxzYRojBUYK5bE2GZeb5+5gQRrf6sPblWTdG
         DEFcNHCm+4yNKvFoZWl3yATmgSFt4Lxw3rQBuTUTzg6sSE8OoqclLBXM7wDbSmPd+IWp
         uSPAhkYVypDJlFsaauE7tbUjIwwoW00rd0yrX/j9v2K8V4GZFu1bL5t1jc5ld5ok5o3A
         ldxO6i2dvU2njc07l65W/KwXGLC7/EmOowxNhYhRWzMjq4ZhCiWga5hzbqzt2OfQnPvT
         ND0kBeyMjWguIcPcQmfq/A199Y39XUwSEW48zVl7mXu42Y7EQyQPbXKMDL5T8zokO9TH
         h89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678938482;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u56PSDBVBRdGmgzPnFNjq+MAakeLoiPcG+8JP+F1je8=;
        b=zSvim7+Ip4pWxDeF24HVhSM/nxAqLCpPTj4vPXxSouchV2Q+Q4mskiZsTuKnjT+Zfh
         lSySLkeP/qeyj2Vg72vOP2exyGyN9hT+EtIo/PlbFFRH5eph4GZyxy8sH4bGLeLzJ3ab
         +cjO5aOvnr5i0uoStcWR2iuIvVyIJoCCSQ8U0Oj3HzS5JVBO8NMxc0G1Vi2w89GHaAXF
         WU8NAf6C9Mj4PrtTRWcj+hEikkG/UecqwiwjS4ISStmUcGReOtZo6kWf4tEdj5CiG398
         LrNT/SVWBtB6x45R2wSEUUPA4yMSZWG+DdL727vIROXbUwdK9kTjvpXNouW4r1jCIGPp
         IbHw==
X-Gm-Message-State: AO0yUKUPbpPRRGtqKVhyYBZvCJN8+/lnphvPm8YcGcscBBWAn6EZuO1i
        2bBPF5om+Z1AO1pcWyZjI47fvg==
X-Google-Smtp-Source: AK7set9INRbDX7OaeK+UUirQaFsWXxgs663ufS10ohEGq4s3votRB0Ode0K2oek+wsduN+W25TpMEQ==
X-Received: by 2002:a05:6808:2c3:b0:384:232:2a4f with SMTP id a3-20020a05680802c300b0038402322a4fmr2317395oid.4.1678938482324;
        Wed, 15 Mar 2023 20:48:02 -0700 (PDT)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id j6-20020a056870020600b001762d1bf6a9sm3003826oad.45.2023.03.15.20.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:48:01 -0700 (PDT)
From:   Steev Klimaszewski <steev@kali.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH v6 0/4] Add WCN6855 Bluetooth support
Date:   Wed, 15 Mar 2023 22:47:54 -0500
Message-Id: <20230316034759.73489-1-steev@kali.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First things first, I do not have access to the specs nor the schematics, so a
lot of this was done via guess work, looking at the acpi tables, and looking at
how a similar device (wcn6750) was added.

The 6th revision addresses comments from Johan to the driver itself, which
include adding poweroff support so we no longer splat when we modprobe -r or
power off the device.

The 5th revision can be found at
https://lore.kernel.org/all/20230209020916.6475-1-steev@kali.org/

The end result is that we do have a working device, but not entirely reliable.

There are a few things that I am not sure why they happen, and don't have the
knowledge level to figure out why they happen or debugging it.

Bluetooth: hci0: setting up wcn6855
Bluetooth: hci0: Frame reassembly failed (-84)
Bluetooth: hci0: QCA Product ID   :0x00000013
Bluetooth: hci0: QCA SOC Version  :0x400c0210
Bluetooth: hci0: QCA ROM Version  :0x00000201
Bluetooth: hci0: QCA Patch Version:0x000038e6
Bluetooth: hci0: QCA controller version 0x02100201
Bluetooth: hci0: QCA Downloading qca/hpbtfw21.tlv
Bluetooth: hci0: QCA Downloading qca/hpnv21.bin
Bluetooth: hci0: QCA setup on UART is completed

I do not know why the Frame assembly failed, and modprobe -r hci_uart and then
modprobe hci_uart does not show the same Frame assembly failed.

The BD Address also seems to be incorrect, and I'm not sure what is going on
there either.

Testing was done by connecting a Razer Orochi bluetooth mouse, and using it, as
well as connecting to and using an H2GO bluetooth speaker and playing audio out
via canberra-gtk-play as well as a couple of YouTube videos in a browser.

The mouse only seems to work when < 2 ft. from the laptop, and for the speaker, only
"A2DP Sink, codec SBC" would provide audio output, and while I could see that
data was being sent to the speaker, it wasn't always outputting, and going >
4ft. away, would often disconnect.

steev@wintermute:~$ hciconfig -a
hci0:   Type: Primary  Bus: UART
        BD Address: 00:00:00:00:5A:AD  ACL MTU: 1024:8  SCO MTU: 240:4
        UP RUNNING PSCAN
        RX bytes:1492 acl:0 sco:0 events:126 errors:0
        TX bytes:128743 acl:0 sco:0 commands:597 errors:0
        Features: 0xff 0xfe 0x8f 0xfe 0xd8 0x3f 0x5b 0x87
        Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
        Link policy: RSWITCH HOLD SNIFF
        Link mode: PERIPHERAL ACCEPT
        Name: 'wintermute'
        Class: 0x0c010c
        Service Classes: Rendering, Capturing
        Device Class: Computer, Laptop
        HCI Version:  (0xc)  Revision: 0x0
        LMP Version:  (0xc)  Subversion: 0x46f7
        Manufacturer: Qualcomm (29)

steev@wintermute:~$ dmesg | grep Razer
[ 3089.235440] input: Razer Orochi as /devices/virtual/misc/uhid/0005:1532:0056.0003/input/input11
[ 3089.238580] hid-generic 0005:1532:0056.0003: input,hidraw2: BLUETOOTH HID v0.01 Mouse [Razer Orochi] on 00:00:00:00:5a:ad
steev@wintermute:~$ dmesg | grep H2GO
[ 3140.959947] input: H2GO Speaker (AVRCP) as /devices/virtual/input/input12

Bjorn Andersson (1):
  arm64: dts: qcom: sc8280xp: Define uart2

Steev Klimaszewski (3):
  dt-bindings: net: Add WCN6855 Bluetooth
  Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
  arm64: dts: qcom: sc8280xp-x13s: Add bluetooth

 .../net/bluetooth/qualcomm-bluetooth.yaml     | 17 ++++
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 80 +++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi        | 14 ++++
 drivers/bluetooth/btqca.c                     | 14 +++-
 drivers/bluetooth/btqca.h                     | 10 +++
 drivers/bluetooth/hci_qca.c                   | 57 +++++++++----
 6 files changed, 177 insertions(+), 15 deletions(-)

-- 
2.39.2

