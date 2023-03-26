Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64206C98BF
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 01:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjCZXiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 19:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjCZXiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 19:38:17 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD784EC4
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 16:38:15 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 61-20020a9d02c3000000b0069fe8de3139so3707993otl.1
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 16:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1679873894;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rD/4jqknT+2SfkmCPcdlb88a5ABGC34ExHbgNfTm8GY=;
        b=k0lfLbGWXDEOwiywNv2JuXcotcGCpmb0zO7bHJsyT1/SFrC4mtmICd8TrIiVsS2ev8
         n48L4HlRzGN+FEo5hL4UKaXC1NfU5ZlXw6vpgFANLP87+P3X2HB7OSHHsrQTsWexcH5e
         e/7wzQ8eolc4nZVRK3QfofFJUu5qsAM8cSCloKG28HXdOHyEMHag1Xmofb/FeSdI0EPo
         cYh077vAmvg0Ae0FUHBylrAwlQdSSRvoSd7g3Hxy/kYs5tD3bubOmMI0ndNcbVPTx0d9
         rbyQ+TJnvZclxZFI7EjKuc6+pehsmWMKiTinqHPqZTMM2L3v9U3G7KunzRrCjrJuU43r
         EZ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679873894;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rD/4jqknT+2SfkmCPcdlb88a5ABGC34ExHbgNfTm8GY=;
        b=PPrnxqy7wSg+HyOn/sEgxpg+AWNzSHEUs4QMNt/TF1g7X2g1as0jHQVQmd/SlhVRdM
         3ZPPoefeeo823g51RhCquFd5CnsUl8F3G43jEL7EbTwn6b2trmdQ4FT+w1BlIcKj6BUT
         qhjK/DxD/NujsP27jof5Oq2CwGUzKqjCZcyjMz61u+NlgtXibTn/rTGmjesG5Id+ZS57
         UB7k0/T23mY7lNpTMeVBs2nOCjjDDwULLHuWLoXuL/5IJ5L4rQpvLZiITwGjuSjc/sk5
         3fJJusviLzqvcTnYUQvKjX6O4OiJnmrg0f7Glt1ngy/NCQY3hqliHV7ckkI+/TNJ1xXv
         8rng==
X-Gm-Message-State: AAQBX9c0W5fPi1qfyyfjT80snzF7mPUQ4VDcW89uTEqzXKwBxgyKv20E
        ejjF7mlUcVCWbQMtVghtZzngpg==
X-Google-Smtp-Source: AKy350agDeXz+t/l3M9eFwvJa5NwWBwm5Y8uqyR9+NypJltaTSL4Dw714LoHxmGJ0pISV3W6/SOdxQ==
X-Received: by 2002:a05:6830:3892:b0:6a1:2a17:16f2 with SMTP id bq18-20020a056830389200b006a12a1716f2mr2999700otb.1.1679873894386;
        Sun, 26 Mar 2023 16:38:14 -0700 (PDT)
Received: from localhost ([2600:1700:eb1:c450::35])
        by smtp.gmail.com with ESMTPSA id m18-20020a9d7ad2000000b006a120f50a6fsm2044585otn.61.2023.03.26.16.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 16:38:13 -0700 (PDT)
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
Subject: [PATCH v8 0/4] Add WCN6855 Bluetooth support
Date:   Sun, 26 Mar 2023 18:38:08 -0500
Message-Id: <20230326233812.28058-1-steev@kali.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First things first, I do not have access to the specs nor the schematics, so a
lot of this was done via guess work, looking at the acpi tables, and looking at
how a similar device (wcn6750) was added.

This patchset has 2 patchsets that it depends on, for the bindings so that they
pass dtbs_check, as well as adding in the needed regulators to make bluetooth
work.

https://lore.kernel.org/lkml/20230316105800.18751-1-johan+linaro@kernel.org/
and
https://lore.kernel.org/lkml/20230322113318.17908-1-johan+linaro@kernel.org/

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

v8 Adds a dependency on another patchset from Johan, which can be found at
https://lore.kernel.org/lkml/20230322113318.17908-1-johan+linaro@kernel.org/
which I believe has already been accepted upstream, and removes the regulator
from the dts in my patchset, additionally, fix the alphabetization.

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

 .../net/bluetooth/qualcomm-bluetooth.yaml     | 17 +++++
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 70 +++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi        | 14 ++++
 drivers/bluetooth/btqca.c                     | 14 +++-
 drivers/bluetooth/btqca.h                     | 10 +++
 drivers/bluetooth/hci_qca.c                   | 57 +++++++++++----
 6 files changed, 167 insertions(+), 15 deletions(-)

-- 
2.39.2

