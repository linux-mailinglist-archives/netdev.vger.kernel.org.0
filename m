Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976BB69240A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbjBJRIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbjBJRIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:08:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D715661D24;
        Fri, 10 Feb 2023 09:07:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DFAD61E3E;
        Fri, 10 Feb 2023 17:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707F2C4339E;
        Fri, 10 Feb 2023 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676048869;
        bh=d+NdOA9/0tO3K8kBzBxjygHIYoB+DElDtix6qSenTjE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O6g5VXeAAsrz08mTl6VK6RK2jBcANxBltL8iEu5JDUxOrNZfgAGvCEDmnj5wk+j35
         oHFpn4HN/mMffegb98/IR6gtoyxSXpZyUU0XqQW/BFSeInWV21ttgf0GbH6t+H/nRx
         EwcQoT2a5juaO4VBx3tY1lQXvMCWaLQtaFluHO59eC/woyCiFwQf/zEdwGcmBg8XwL
         mhJK//ZkwIoOIWtc/GBgTmTsWeTbD/dHFYoyEO64qDUWmRZu0BTNWyylcXq4oITJot
         xrN/C0mVvGlb1zXeZKGfwg9VF94F5USQ+cmYokoqaZjSNi/j/C0+GIXN/wx9b43+AO
         p3jIRr4gwaphg==
Date:   Fri, 10 Feb 2023 09:09:58 -0800
From:   Bjorn Andersson <andersson@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: Re: [PATCH v5 0/4] Add WCN6855 Bluetooth support
Message-ID: <20230210170958.qpzvcrkum7eehdcx@ripper>
References: <20230209020916.6475-1-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209020916.6475-1-steev@kali.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 08:09:12PM -0600, Steev Klimaszewski wrote:
> First things first, I do not have access to the specs nor the schematics, so a
> lot of this was done via guess work, looking at the acpi tables, and looking at
> how a similar device (wcn6750) was added.
> 
> The 5th revision addresses comments from Luiz about the Bluetooth driver, as
> well as Konrad's comments on the dts file.
> 
> The end result is that we do have a working device, but not entirely reliable.
> 

Except for the one warning/error about frame assembly I've not seen any
reliability issues with this series.

> Hopefully by getting this out there, people who do have access to the specs or
> schematics can see where the improvements or fixes need to come.
> 
> There are a few things that I am not sure why they happen, and don't have the
> knowledge level to figure out why they happen or debugging it.
> 
> Bluetooth: hci0: setting up wcn6855
> Bluetooth: hci0: Frame reassembly failed (-84)
> Bluetooth: hci0: QCA Product ID   :0x00000013
> Bluetooth: hci0: QCA SOC Version  :0x400c0210
> Bluetooth: hci0: QCA ROM Version  :0x00000201
> Bluetooth: hci0: QCA Patch Version:0x000038e6
> Bluetooth: hci0: QCA controller version 0x02100201
> Bluetooth: hci0: QCA Downloading qca/hpbtfw21.tlv
> Bluetooth: hci0: QCA Downloading qca/hpnv21.bin
> Bluetooth: hci0: QCA setup on UART is completed
> 
> I do not know why the Frame assembly failed, and modprobe -r hci_uart and then
> modprobe hci_uart does not show the same Frame assembly failed.
> 
> The BD Address also seems to be incorrect, and I'm not sure what is going on
> there either.
> 

Changing the public-addr after the fact works...

> Testing was done by connecting a Razer Orochi bluetooth mouse, and using it, as
> well as connecting to and using an H2GO bluetooth speaker and playing audio out
> via canberra-gtk-play as well as a couple of YouTube videos in a browser.
> 
> The mouse only seems to work when < 2 ft. from the laptop, and for the speaker, only
> "A2DP Sink, codec SBC" would provide audio output, and while I could see that
> data was being sent to the speaker, it wasn't always outputting, and going >
> 4ft. away, would often disconnect.
> 

With the interference from WiFi removed I have very positive results
with this, been listening to music using this for a week now without any
concerns.

Tested-by: Bjorn Andersson <andersson@kernel.org>

Regards,
Bjorn

> steev@wintermute:~$ hciconfig -a
> hci0:   Type: Primary  Bus: UART
>         BD Address: 00:00:00:00:5A:AD  ACL MTU: 1024:8  SCO MTU: 240:4
>         UP RUNNING PSCAN
>         RX bytes:1492 acl:0 sco:0 events:126 errors:0
>         TX bytes:128743 acl:0 sco:0 commands:597 errors:0
>         Features: 0xff 0xfe 0x8f 0xfe 0xd8 0x3f 0x5b 0x87
>         Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
>         Link policy: RSWITCH HOLD SNIFF
>         Link mode: PERIPHERAL ACCEPT
>         Name: 'wintermute'
>         Class: 0x0c010c
>         Service Classes: Rendering, Capturing
>         Device Class: Computer, Laptop
>         HCI Version:  (0xc)  Revision: 0x0
>         LMP Version:  (0xc)  Subversion: 0x46f7
>         Manufacturer: Qualcomm (29)
> 
> steev@wintermute:~$ dmesg | grep Razer
> [ 3089.235440] input: Razer Orochi as /devices/virtual/misc/uhid/0005:1532:0056.0003/input/input11
> [ 3089.238580] hid-generic 0005:1532:0056.0003: input,hidraw2: BLUETOOTH HID v0.01 Mouse [Razer Orochi] on 00:00:00:00:5a:ad
> steev@wintermute:~$ dmesg | grep H2GO
> [ 3140.959947] input: H2GO Speaker (AVRCP) as /devices/virtual/input/input12
> 
> Bjorn Andersson (1):
>   arm64: dts: qcom: sc8280xp: Define uart2
> 
> Steev Klimaszewski (3):
>   dt-bindings: net: Add WCN6855 Bluetooth
>   Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
>   arm64: dts: qcom: thinkpad-x13s: Add bluetooth
> 
>  .../net/bluetooth/qualcomm-bluetooth.yaml     | 17 +++++
>  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 76 +++++++++++++++++++
>  arch/arm64/boot/dts/qcom/sc8280xp.dtsi        | 14 ++++
>  drivers/bluetooth/btqca.c                     |  9 ++-
>  drivers/bluetooth/btqca.h                     | 10 +++
>  drivers/bluetooth/hci_qca.c                   | 50 +++++++++---
>  6 files changed, 163 insertions(+), 13 deletions(-)
> 
> 
> base-commit: 4fafd96910add124586b549ad005dcd179de8a18
> -- 
> 2.39.1
> 
