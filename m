Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446A768FCD7
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjBICJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjBICJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:09:20 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52261869F
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 18:09:19 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id k28so486880qve.5
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 18:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PfrikUd+XUup+Artqyjmr54eQrRIayQAdMP5Tb1/fWY=;
        b=Xz7caW+4a1O/FfoQ5MN4jY+ZIjmH3vAvknchwWVMotFYFqKBV01rEajjCw+O6YYKLt
         JYCrYSV6K+oIc7O/z4fG0YG5uOeQWX+REJzz3u/FWiE+E3W59Sr7KOmbcsRjgbI9i7V4
         wbLnRljqTWurc+7ozn94S8FkvE/hJgndMmO6RXn2cpjAZ/rJPmUa/YfLVDhAHv4MKwig
         7NSQ2//HKKO81G8xGWNIhoJ86GbKHthZ9pR/XE4uP+1x4SMhS8lZpdNTXyC5PeEMd+qr
         KJYyCAU9QXRjyzDcMF5DrZrK5CHwv6iBIqBWVCWSNegRZ/xy6CsSmI+M7M5o3KnpGQdb
         Txdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfrikUd+XUup+Artqyjmr54eQrRIayQAdMP5Tb1/fWY=;
        b=kqfD1uYfbh47OLZVhf9T6wCNlP5jEUUBLMYy+gjDoYv2IoUMB+ws4rL26WmhL2jFhu
         uqo8H+EAAcrN0qLBnqiFN/GJpIkXduIUJiPKzZBNtJw72q+aJc68/4m5cHzqvmmZbDOx
         NzrWfC2nuKWv+Kk9PzziyeMp+PJA1cF4Xbdba/X98DD5qbGpDh/gnj5nXq8sfZiyCcOo
         n5MRbizJjOtTEJNC68S900v+DSRc3e356LdXnDk2mWPyaDerlgS6oNTLBtY/rirB9RmO
         zOxf2uvfMooXzJSpb8AJFu2vZjnK5sLrY5Ejqp4JIoNu00DqQ1J3NXKY5vUV8+leGd38
         GLow==
X-Gm-Message-State: AO0yUKX1J55epPMaqWQKdiEF/bdIIIFVuSoKPqECG2bc3daVoVztGz3m
        arxAot3QXSvwxh+pCtyraXfDbg==
X-Google-Smtp-Source: AK7set+G0Qx0yIb6EdssWmf0zBa3rG90zjvl3q8fwDUA3sDHH4EGrIVb0pOgS6vDq5RwZJg577NVxw==
X-Received: by 2002:a05:6214:c49:b0:537:6e29:e9e9 with SMTP id r9-20020a0562140c4900b005376e29e9e9mr16893936qvj.21.1675908558457;
        Wed, 08 Feb 2023 18:09:18 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id v127-20020a372f85000000b006fa43e139b5sm386582qkh.59.2023.02.08.18.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 18:09:17 -0800 (PST)
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
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: [PATCH v5 0/4] Add WCN6855 Bluetooth support
Date:   Wed,  8 Feb 2023 20:09:12 -0600
Message-Id: <20230209020916.6475-1-steev@kali.org>
X-Mailer: git-send-email 2.39.1
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

The 5th revision addresses comments from Luiz about the Bluetooth driver, as
well as Konrad's comments on the dts file.

The end result is that we do have a working device, but not entirely reliable.

Hopefully by getting this out there, people who do have access to the specs or
schematics can see where the improvements or fixes need to come.

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
  arm64: dts: qcom: thinkpad-x13s: Add bluetooth

 .../net/bluetooth/qualcomm-bluetooth.yaml     | 17 +++++
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 76 +++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi        | 14 ++++
 drivers/bluetooth/btqca.c                     |  9 ++-
 drivers/bluetooth/btqca.h                     | 10 +++
 drivers/bluetooth/hci_qca.c                   | 50 +++++++++---
 6 files changed, 163 insertions(+), 13 deletions(-)


base-commit: 4fafd96910add124586b549ad005dcd179de8a18
-- 
2.39.1

