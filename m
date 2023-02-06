Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F5268B30B
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 01:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjBFANe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 19:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjBFANd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 19:13:33 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BCA1ADE5
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 16:13:26 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id 5so1301359qtp.9
        for <netdev@vger.kernel.org>; Sun, 05 Feb 2023 16:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MmeAe5uno9wGc5xLwGkJf0jMDPKBNskya1KsnB3Qcn8=;
        b=WevXsNaV17F5m0//FDGunyGk4JMhe3+jEFZ/RrqrYl3Yoaj5I7Do7vr2dl9yXwm/5r
         gCDmqR5ktL44Z9SHBO33I3jODB2vS2nralihRBqwymZ9RwlAtjnGavgUMRGnJTboGFIu
         wf5FZzee6YCgu3V61dnzqGayLJJc7g5ZEvzlOis8rOJLlc9Z97dkILg2YDgXZHqh3oMO
         ivMydusYX1u3VMgmJriIUTKh88VoNVZ9X9/Loaxl8pslkllXOwZ4LtI1J9byBstD6nB7
         OyDkqny4e0FQh+08oaeAQAgrZRY8aEQPrCeLQqFvrnZRHFJqN5fJRYyEVmTs1Re3xj4g
         HDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MmeAe5uno9wGc5xLwGkJf0jMDPKBNskya1KsnB3Qcn8=;
        b=fBclMqxZmcEUXyebu5dl+zot2nlKetxseRlj4H/9avWHLjRJGi5EbgqwzoLuORpmM+
         7CrT2ogduCoExyWx4P9Qoyqu08KgTUw0EoDwP8wkd67OfPLTatrsG3wvUJwthuZqPP5Z
         uEFLRr5Mu6OSeuzn0XJFWrCeeM4KBLfxZQYFuLYjgF1qKU+HsldPPHltulRfo1SV02Fj
         cox+Ox7KDnoG/LmK0/myyg8ga9FIkkiELdr4WMlU0egFcWIc0+RqWKzoYj5ZuvjmJteG
         ulcZkZ224xW+Cbkx0arqBU7eauHQS00D2o/esDUYb6K5hsHZHHOUzT/yZtoFGdFSPYq+
         lOMQ==
X-Gm-Message-State: AO0yUKWyzVt8dFOM0v0S80Ig4Zb1xBuvcvLpMG39bE8123vEoDbXV2I3
        RguW4q++1FKWwmDTstG3iqYNVQ==
X-Google-Smtp-Source: AK7set8BJRNvbZw5UsDww2zQ2b3xNBVHvDL+phKNASwdNnWujugsUHYTuY15uIuJoGM1rKVTZN1HnA==
X-Received: by 2002:ac8:5f88:0:b0:3b9:b497:109e with SMTP id j8-20020ac85f88000000b003b9b497109emr18259071qta.18.1675642405870;
        Sun, 05 Feb 2023 16:13:25 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id fz14-20020a05622a5a8e00b003b9e1d3a502sm6177249qtb.54.2023.02.05.16.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Feb 2023 16:13:25 -0800 (PST)
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
Subject: [PATCH v3 0/4] Attempt at adding WCN6855 BT support
Date:   Sun,  5 Feb 2023 18:13:19 -0600
Message-Id: <20230206001323.2466-1-steev@kali.org>
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

This v3 of the patchset is somewhat of an RFC/RFT, and also just something to
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

Changes since v2:
 - Drop unnecessary commit info from patch 2
 - Remove dead code in patch 4, add TODO note.
 - Make dtbs_check happy with the pin definitions

Bjorn Andersson (1):
  arm64: dts: qcom: sc8280xp: Define uart2

Steev Klimaszewski (3):
  dt-bindings: net: Add WCN6855 Bluetooth
  Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
  arm64: dts: qcom: thinkpad-x13s: Add bluetooth

 .../net/bluetooth/qualcomm-bluetooth.yaml     |  2 +
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 63 +++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi        | 14 +++++
 drivers/bluetooth/btqca.c                     | 24 ++++++-
 drivers/bluetooth/btqca.h                     | 10 +++
 drivers/bluetooth/hci_qca.c                   | 59 +++++++++++++----
 6 files changed, 157 insertions(+), 15 deletions(-)


base-commit: 4fafd96910add124586b549ad005dcd179de8a18
-- 
2.39.0

