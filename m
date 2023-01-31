Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28276682361
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 05:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjAaEjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 23:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjAaEi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 23:38:57 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC013C291
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 20:38:19 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id k91-20020a9d19e4000000b0068bca1294aaso2028446otk.8
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 20:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QJ0/xhaPKfH2Cca60pE6TWrTG0mtzLgrVF2qyKPFbpg=;
        b=WlNsctbWgszBVDSa31eYVUcKBkTha+aPKciVsSkkfNJrLyugJvrClllNhEJpOPqKmj
         urVajDaEhBnXOosH6TVL6jCExSfgb3lqFPhHUIV0ZMxUETx/geBHwc47RYQHvYq1MHPi
         RW5l9JuTVa6zDdyRdi+txkAzuBhzT7D3iiiYtLEP68GPJJywOfDDtgYGFwrJ+P5hzFE8
         xX2d+ZFz8wkNHe/dZLFQKHEGSwR5da8if3sPvG/V5M8rxjsxEL57sGVY4HEtC0o2Vr5O
         xkjuITMbL2wmFaszsf349bW6tbBkhuvHPkvIMfFnF4UiHtbyB8RPVTK8cGs1B1dfoiu1
         1eSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QJ0/xhaPKfH2Cca60pE6TWrTG0mtzLgrVF2qyKPFbpg=;
        b=cP7r0x//6oFZ30vGu6Kc/O/tmYg0JB0jCO+LQl019JgP7AJRvxj9JgSUT/58EKMd0f
         8ywOrL1K1OwhBnO4KWL/TIogX6YJmt8F3mnw1YYlo/9EWSXm29EKbcQuw3bH9Wcj39nZ
         Yr75Ffi3VtvFn3hrBvrhEuE9pezws+CD8EPDzGgFvhb11EOez+xw3djx+O83liluuiw4
         OZg8koizpKBGMXAPWyq6tia2pPZgZy95zQTuKNe+GsxK30rwy6Jk2NtmHewPRKD/vGMh
         hxLZ9M6vV4unz75Zsfj+ydwuNZREZHmq6A0W7EGF4DffCYONAnKEilAscLCE2ANqSBl6
         +SGg==
X-Gm-Message-State: AO0yUKUdd2Taal8IE0h88gq9mwVuETL8TtHaLQSJzGBT00xHZc0UILrc
        +sk+DFemD3XYiSEsxO2EkfcaWA==
X-Google-Smtp-Source: AK7set8mqgpo6LDyA44nF65Bocpb54FWrJD5HkLb7CaloqZ7a2Ml9jiEFXTqnkcxm1PGEiGuYpwY1A==
X-Received: by 2002:a05:6830:6989:b0:68a:443c:8c9e with SMTP id cy9-20020a056830698900b0068a443c8c9emr7863229otb.4.1675139898324;
        Mon, 30 Jan 2023 20:38:18 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id c14-20020a9d614e000000b0068bd04b4292sm2174018otk.31.2023.01.30.20.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 20:38:17 -0800 (PST)
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
Subject: [PATCH v2 0/4] Attempt at adding WCN6855 BT support
Date:   Mon, 30 Jan 2023 22:38:12 -0600
Message-Id: <20230131043816.4525-1-steev@kali.org>
X-Mailer: git-send-email 2.39.0
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

This v2 of the patchset is somewhat of an RFC/RFT, and also just something to
get this out there.

First things first, I do not have access to the specs nor the schematics, so a
lot of this was done via guess work, looking at the acpi tables, and looking at
how a similar device (wcn6750) was added.

There are possibly checkpatch warnings, and I do apologize to those who won't
review things until there are no warnings for wasting your time, I did try to
correct the ones I came across and seemed to be needed.

One example is that I have the vregs commented out, the dt-bindings say that
they are required since it's based on the wcn6750 work but also like the 6750,
I've added defaults into the driver, and those seem to work, at least for the
initial testing.

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

Additionally, I've tried with an additional patch that I'm not including that is
based on commit 059924fdf6c1 ("Bluetooth: btqca: Use NVM files based on SoC ID
for WCN3991") to try using the hpnv21g.bin or hpnv21.bin, and the firmware acted
the same regardless, so I am assuming I don't truly need the "g" firmware on my
Thinkpad X13s.

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

 .../net/bluetooth/qualcomm-bluetooth.yaml     |  2 +
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 68 +++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi        | 14 ++++
 drivers/bluetooth/btqca.c                     | 24 ++++++-
 drivers/bluetooth/btqca.h                     | 10 +++
 drivers/bluetooth/hci_qca.c                   | 59 ++++++++++++----
 6 files changed, 162 insertions(+), 15 deletions(-)

-- 
2.39.0

