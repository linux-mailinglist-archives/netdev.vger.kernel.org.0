Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51ED06801E3
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 22:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbjA2Vvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 16:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbjA2Vvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 16:51:41 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B4F199FC
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 13:51:38 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id p185so8635320oif.2
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 13:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zFiSJsxbVNP6iSln86409bsy54CkshWpdq97AEc134M=;
        b=E94+MPEpN/TNYg3BdBZ5EFjP5Yautut+jtwYkZvz2oMLpUiI9Yrles+AUblQ4bPboY
         EsVgf1k0JYvmBannURtMUw96aEgju921qStOkHoYWZskNasd02kGOFHT20/h4Bj3k4bu
         SeFj0NFFfiiyl3ZPzSGdNtPM8ILTPmqLcwbVWH1WLR4KSTuROICFs8sfzgZOxSrEtFwZ
         rYjc21gMXHYl5s0exgKzKbiVUH/vKHhoeLL3Nn8997ko+BwbTb1P7n1rK6EvP1OXH/ga
         s6pfYI5O2XYvzBinAb4+NdyHFv0yhl2VVp1IV8H4wRNp9LQpMb+RG1Z33todyfrlF12k
         K3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zFiSJsxbVNP6iSln86409bsy54CkshWpdq97AEc134M=;
        b=15ebk3FDENguAyVLsb+Dsaebhub9sn1H15UZJCSGghm+9S4mgP5UnG39/SF0r5W6Bq
         33doTw7u3q/UFNS5B8ueAMhABg/zc+0QeZaofiPiWzKBbMYA35q2Ql/9XAUIwIjFMz+h
         PusVSs38OrXr2TgPRM67eUlIBx08jtTwQlDYTciuQoKgS9uvTsQLW2uTmW8C2ehObNnF
         2vKdZ30CSQZcMGcdR0i5833IvOFg9geG3ow4Y2nbvJURFNYKC1yYYYUFTOMzZw8fZS9d
         F15kU3atjNSWqLg1FEHEIPDRfFZNiDKnbK6sF1qbrJXt5hqoun/N+epNlBKo+vOKf9Ml
         IHyg==
X-Gm-Message-State: AFqh2kq2ZMn6RdxK7xJQAIGn8wV/musyiRxlJv+RXT83d1N52TvOC/T/
        xXq4GdOtWmNG2SjXGiwqDMQmww==
X-Google-Smtp-Source: AMrXdXsOzuRHTVu/dKRYKIffFpHK3+YqjNy/Qee5C9BkP0mcJqEfueB2r2Xo3WoZEODLX6Zn+RbirA==
X-Received: by 2002:a05:6808:1982:b0:35e:bd7e:c89a with SMTP id bj2-20020a056808198200b0035ebd7ec89amr31944819oib.16.1675029098237;
        Sun, 29 Jan 2023 13:51:38 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id de5-20020a056808608500b00377ee54431asm2847836oib.57.2023.01.29.13.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 13:51:37 -0800 (PST)
From:   Steev Klimaszewski <steev@kali.org>
To:     steev@kali.org
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
        Sven Peter <sven@svenpeter.dev>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH 0/4] Attempt at adding WCN6855 BT support
Date:   Sun, 29 Jan 2023 15:51:26 -0600
Message-Id: <20230129215136.5557-1-steev@kali.org>
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

This patchset is somewhat of an RFC/RFT, and also just something to get this out
there.

First things first, I do not have access to the specs nor the schematics, so a
lot of this was done via guess work, looking at the acpi tables, and looking at
how a similar device (wcn6750) was added.

There are definitely checkpatch warnings, and I do apologize to those who won't
review things until there are no warnings for wasting your time.

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
  arm64: dts: qcom: sc8280xp: Enable BT

Steev Klimaszewski (3):
  dt-bindings: net: Add WCN6855 Bluetooth bindings
  Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
  arm64: dts: qcom: thinkpad-x13s: Add bluetooth

 .../net/bluetooth/qualcomm-bluetooth.yaml     |  2 +
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 68 +++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi        | 14 ++++
 drivers/bluetooth/btqca.c                     | 24 ++++++-
 drivers/bluetooth/btqca.h                     | 10 +++
 drivers/bluetooth/hci_qca.c                   | 59 ++++++++++++----
 6 files changed, 162 insertions(+), 15 deletions(-)


base-commit: e2f86c02fdc96ca29ced53221a3cbf50aa6f8b49
-- 
2.39.0

