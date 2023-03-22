Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE366C3F7E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 02:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjCVBOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 21:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjCVBOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 21:14:47 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A184FABB
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:14:44 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-17671fb717cso18051612fac.8
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1679447684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BlSUN2wZYTEOgt9J14JNZCw4zLCT6q6O5ss5D6gIjf0=;
        b=HDZ2R5RP427bFYGVsGeYZEE/bYSq4q4pBEGo9athBCMKeOI0xlhP1ORNFxH30pDZPw
         VaMQGlxn1NwmyZvENCuYYtprYjm64Hol4xoPykXIQsul3QkhmhUyv21YW8fTs0/w1JQT
         q9DzJl//GQwL9aYbysI5jnyOPLKVRSer348QMfDvogjpO9VN4DAc+esGOQsTs4txesqp
         6hN0R80FyIiTqGIGZE/yl4wrLDgiepvWic6OHjMlBGx17FB9+LMOFlMnn3FRxKPVXT8p
         3c4Fi4p/ktJVYqjNzFrKoeRu61m+fE+PEGb4ZINCLEGn5b/ElglHfkRIA24PWsVUh1Ug
         V6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679447684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BlSUN2wZYTEOgt9J14JNZCw4zLCT6q6O5ss5D6gIjf0=;
        b=Srkl3MH2hlJ+mA4yZ2gzgCH62vhnSc/DTdXcxzZvCoonmY22sJ1rT15yzxJj4+QaXs
         S492oK9MCE7xhQbPSAE3bkLDN9NrCNI9YmO75dFkle5/xBWETjtbUTgRQwtwgP9VK2XS
         7Et15f6GH9FliG11gkUx6A1SeabWfvDCAY5sreEiC0FmVUHBKajiXKLKNWLPRPSLcAaK
         dHpWpM/IhIOraoANTf2sZ3I2jP1gHvB0ZQKLxYA7NyTN1t0TjFKiBXu2UYSi+gkirC45
         4/u2h71H/KSVuMrBVoLXQL8A/xYiLKLtximkaLF51lcsVF4Tw7tkrqmGm9D081nMyAeY
         pHYQ==
X-Gm-Message-State: AO0yUKXaQcMLYzfFJKc6a3TdxcVSgkuSPt6XW3s9G90GtT5BmhwyYcWW
        ch3Gy+V/vsFhMZyZB1fPdagUh9raCnUd/PpZBdB86w==
X-Google-Smtp-Source: AK7set8wF5RckXOZbDxt0S8uH8SUI2HOJmxyduS8hpsH1nJuMaMMQkDtO5febM76mSa13LquWxVpeQ==
X-Received: by 2002:a05:6870:17a8:b0:177:956c:36c3 with SMTP id r40-20020a05687017a800b00177956c36c3mr507922oae.36.1679447684178;
        Tue, 21 Mar 2023 18:14:44 -0700 (PDT)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id o9-20020a9d7649000000b00697be532609sm5688980otl.73.2023.03.21.18.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 18:14:43 -0700 (PDT)
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
Subject: [PATCH v7 0/4] Add WCN6855 Bluetooth support
Date:   Tue, 21 Mar 2023 20:14:38 -0500
Message-Id: <20230322011442.34475-1-steev@kali.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First things first, I do not have access to the specs nor the schematics, so a
lot of this was done via guess work, looking at the acpi tables, and looking at
how a similar device (wcn6750) was added.

The end result is that we do have a working device, using the firmware files
that are found in the linux-firmware git repository already.


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

There are a few things that I am not sure why they happen, and don't have the
knowledge level to figure out why they happen or debugging it.

I do not know why the Frame assembly failed, and modprobe -r hci_uart and then
modprobe hci_uart does not always show the same Frame assembly failed.

The BD Address also seems to be incorrect, and I'm not sure what is going on
there either.

Testing was done by connecting a Razer Orochi bluetooth mouse, and using it, as
well as connecting to and using an H2GO bluetooth speaker and playing audio out
via canberra-gtk-play as well as a couple of YouTube videos in a browser.
Additionally, a huddle was done in Slack on Chromium with a pair of Gen1 Apple
AirPods as well as a hangout in Discord on Firefox ESR.

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
steev@wintermute:~$ dmesg | grep AirPod
[  853.742619] input: Steev’s AirPods (AVRCP) as /devices/virtual/input/input14

v7 Addresses commit message review nits by Paul, as  well as dts
changes requested by Johan. Additionally, the dt bindings now rely on
https://lore.kernel.org/lkml/20230316105800.18751-1-johan+linaro@kernel.org/ for
the bias-bus-hold option on sc8280xp.

v6 can be found at https://lore.kernel.org/all/20230316034759.73489-1-steev@kali.org/

Bjorn Andersson (1):
  arm64: dts: qcom: sc8280xp: Define uart2

Steev Klimaszewski (3):
  dt-bindings: net: Add WCN6855 Bluetooth
  Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
  arm64: dts: qcom: sc8280xp-x13s: Add bluetooth

 .../net/bluetooth/qualcomm-bluetooth.yaml     | 17 ++++
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 78 +++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi        | 14 ++++
 drivers/bluetooth/btqca.c                     | 14 +++-
 drivers/bluetooth/btqca.h                     | 10 +++
 drivers/bluetooth/hci_qca.c                   | 57 ++++++++++----
 6 files changed, 175 insertions(+), 15 deletions(-)

-- 
2.39.2

