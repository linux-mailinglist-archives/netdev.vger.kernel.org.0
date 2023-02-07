Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9B468CEEA
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 06:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjBGF2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 00:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjBGF2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 00:28:34 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0590013534
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 21:28:32 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id k91-20020a9d19e4000000b0068bca1294aaso3884151otk.8
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 21:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=028twQfcsplClvNNc3RuH8Q5nGWJWletJfgBcjEP3NQ=;
        b=RfxgHjmYeXckjS1ROENzYGfG9Ik3cObOtGfDH70PTDEXuGWRnDYpHsubV/Vjhtat5n
         TIuUed6oErfKJBCSD8JFBj+wwueYbRLEkQ9nv3Kj0YnTbxoaqbkbC6a9kAfTJb6GKhlv
         hwVMik4pudhYfS/UhAlvRKXbpjTUdFEuZO0YbcY2QFIwsKwWV64ywM/C4Le1AEYCXzBn
         W5DuvLCE7jA2uiSrk0rA3iMBPehd6ApWV878WABfKm4yYofy0cX1V1VJ9mtgzqZi/edL
         44eJR7nsf7XcnTddhHdQ+jrp8ZRl1t+vkJQBAxzz9sFxIwb4fKu+HKscn/6IQnx8YpTT
         IdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=028twQfcsplClvNNc3RuH8Q5nGWJWletJfgBcjEP3NQ=;
        b=6fSYPLX/wNeZ2Jh25+6EDAh8ROVRTZwg8UXuXmG9vLxPJIP2IrsPKmLgyPMKY8Dmq3
         VomIln2D1VsqriwsqRQMCzvhkQ5YJCr6VZ8BszUjDbbWqB7gz0xs0//4XkrcQ/nrMEGQ
         XJZGk/cxNhBdbiOg2P81FoJBiDXR9pleFuYsLdROvVz2TA7a6bdWEyMc6Y3IOvdxbxkK
         zr+pQC+h8jp4761BiAJqEmd6fP45+kf6uaZTZ1EbC30wdQpVut3LybsLj7E1z29ET+zd
         1eCTqbt8T6CuNuAT4q20q+3E1uMwxmdjxHW6llTu/1g0OER33sODMYTAMVXl1rnEZOCf
         lX/g==
X-Gm-Message-State: AO0yUKV0IPiRsLYK56g1j5zIna26y4BInpXdkyyB9Pk+qtSwxVhOs4vm
        KTpHb9EZX1icrkrDgx8xwJ9nKA==
X-Google-Smtp-Source: AK7set/GW2JRPFAN4v2V3DrzNDL0f3V7xH20Km2bQyEmpyWVoqb/1RV5bXLKMrwOe1fa43pLVFwhcg==
X-Received: by 2002:a05:6830:601a:b0:684:e788:eca9 with SMTP id bx26-20020a056830601a00b00684e788eca9mr1324760otb.17.1675747711283;
        Mon, 06 Feb 2023 21:28:31 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id do20-20020a0568300e1400b0068bce6239a3sm1965887otb.38.2023.02.06.21.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 21:28:30 -0800 (PST)
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
        Mark Pearson <markpearson@lenovo.com>
Subject: [PATCH v4 0/4] Add WCN6855 Bluetooth support
Date:   Mon,  6 Feb 2023 23:28:25 -0600
Message-Id: <20230207052829.3996-1-steev@kali.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the 4th version of the patchset, which started out as a bit of an
RFC/RFT but has actually worked so, I think this 4th revision is in a pretty
decent spot, at least in terms of the code itself... that said...

First things first, I do not have access to the specs nor the schematics, so a
lot of this was done via guess work, looking at the acpi tables, and looking at
how a similar device (wcn6750) was added.

This 4th revision does have the regulators added, which were pulled from the
bsrc_bt.bin file from the Windows partition.

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
Bluetooth: hci0: unexpected event for opcode 0xfc48
Bluetooth: hci0: Sending QCA Patch config failed (-110)
Bluetooth: hci0: QCA Downloading qca/hpbtfw21.tlv
Bluetooth: hci0: QCA Downloading qca/hpnv21g.bin
Bluetooth: hci0: QCA setup on UART is completed

I do not know why the Frame assembly failed, nor the unexpected event.

Likewise, I'm not entirely sure why it says the patch config send times out, and
*then* seems to send it?

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
 drivers/bluetooth/btqca.c                     | 24 +++++-
 drivers/bluetooth/btqca.h                     | 10 +++
 drivers/bluetooth/hci_qca.c                   | 56 ++++++++++----
 6 files changed, 182 insertions(+), 15 deletions(-)


base-commit: 4fafd96910add124586b549ad005dcd179de8a18
-- 
2.39.0

