Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1645A6B635F
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 06:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCLFlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 00:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCLFlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 00:41:36 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82E25C101
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 21:41:34 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id cf14so10140415qtb.10
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 21:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678599694;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHkHjtpa1dte9e5s2DF92iQamRtTNVGyILA/iw2j5L4=;
        b=eUbzxm0znkmPQpUFXAMzDxxtyzU2ga/3Zgt9DYZrVNd8izg0etzMy5f/5rW0BowLsF
         b3m1CIsMOTFIpBWNdAj63cGTKgUd8c4J0a5zT90IgafP+jwchMi5JU3PmsyquEjsDicN
         AATY8vdmpE99lNWhjiw1+tthOTnTLnpv+y36cRafPc/8Zg45cVpUDqcHJTtqdNC84OZ7
         QI/B2KfNFp0biRnvEoHGmBXgH6YuCRwDn8GBIyeCOC/Mg5gl8RdlShLbQfHYlY3EpGgM
         hNN5nYY3mUxJCKEEmNImGUB9GsR4OWp8R3ev8kSiip0d3UoygygYVM8YVW5VtLZC9374
         PQqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678599694;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zHkHjtpa1dte9e5s2DF92iQamRtTNVGyILA/iw2j5L4=;
        b=0e6wHBXFEkPECyKmUgC6O0m1e59K6GmqF98zojma+N4Fr07qXw7ITTMnSyLxVhdY9d
         IORGONZfKG3/PSjRc5W1LdfiC8bwLO3ZrP6fnvMND7StPlkG3pQJyCsVrS08dSEZ8ytP
         CaUw6kfhjl1KnK+oek+M7PyxvQxX2Q+rswB8pn56iij32jhmYrcZ/DG9hWKkn8KbWsnm
         C8YlcD5OCGKv1Lxp+7AqSSk2t9Fexzbxnz9OTYtQfeNAaHGamA8aJ34SIEUTMaSTUfuS
         xK3WmbsyisNC2fMcVEh+0vjMAmnx4OoKlV90fBv8j35VhARP0d9Y0v50HzsLnCG/WDVf
         LRCA==
X-Gm-Message-State: AO0yUKU71k9ZxZw1WX9xmI/oz0VkOEiO8RsHVfYJKlbQ613U7bRA6kuC
        IoatYMFf9NJhVClLNm2dOhw=
X-Google-Smtp-Source: AK7set/P/xh67sBZ3IMS5H0MXz75ZRlxZ0K3FrtU7VCi56sBAHm4mf0HAlLoYJldhTwLwaVSWVYX/Q==
X-Received: by 2002:a05:622a:15c6:b0:3bf:e39f:a9aa with SMTP id d6-20020a05622a15c600b003bfe39fa9aamr58099826qty.27.1678599693752;
        Sat, 11 Mar 2023 21:41:33 -0800 (PST)
Received: from ?IPV6:2607:fea8:1b9f:c5b0::349? ([2607:fea8:1b9f:c5b0::349])
        by smtp.gmail.com with ESMTPSA id fp5-20020a05622a508500b003b0b903720esm3091281qtb.13.2023.03.11.21.41.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 21:41:33 -0800 (PST)
Message-ID: <cd306c78-14a6-bebb-e174-2917734b4799@gmail.com>
Date:   Sun, 12 Mar 2023 00:41:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Etienne Champetier <champetier.etienne@gmail.com>
Subject: mv88e6xxx / MV88E6176 + VLAN-aware unusable in 5.15.98 (ok in
 5.10.168) (resend)
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Language: en-US, fr-FR
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(properly formatted this time)

Hello Vladimir, Tobias,

Sending this email to both of you as reverting some of your patches 'fix' the issues I'm seeing.
I'm slowly investigating a regression in OpenWrt going from 22.03 (5.10.168 + some backports)
to current master (5.15.98 + some backports). Using my Turris Omnia (MV88E6176) with the following network config:

# bridge vlan
port              vlan-id
lan0              6 PVID Egress Untagged
lan1              5 PVID Egress Untagged
lan2              4 PVID Egress Untagged
lan3              3 PVID Egress Untagged
lan4              2 PVID Egress Untagged
br-lan            2
                   3
                   4
                   5
                   6
wlan1             3 PVID Egress Untagged
wlan1-1           5 PVID Egress Untagged
wlan1-2           6 PVID Egress Untagged
wlan0             2 PVID Egress Untagged

I get tagged frame with VID 3 on lan4 (at least some multicast & broadcast), but lan4 is not a member of VLAN 3
Also unicast frames from wifi to lan4 exit tagged with VID 2, broadcast frames are fine (verifed with scapy)
Reverting
5bded8259ee3 "net: dsa: mv88e6xxx: isolate the ATU databases of standalone and bridged ports" from Vladimir
and
b80dc51b72e2 "net: dsa: mv88e6xxx: Only allow LAG offload on supported hardware"
57e661aae6a8 "net: dsa: mv88e6xxx: Link aggregation support"
from Tobias allow me to get back to 5.10 behavior / working system.

On the OpenWrt side, 5.15 is the latest supported kernel, so I was not able to try more recent for now.

I'm happy to try to backport any patches that can help fix or narrow down the issue, or provide more infos / tests results.

These issues affect other devices using mv88e6xxx: https://github.com/openwrt/openwrt/issues/11877
In the Github issue the reporter note that first packet is not tagged and the following are.

Here a diff of "mv88e6xxx_dump --vtu --ports --global1 --global2" between 5.10 and 5.15 (without revert)

@@ -9,18 +9,18 @@
  05 Port control 1         0000 0000 0000 0000 0000 0000 0000
  06 Port base VLAN map     007e 007d 007b 0077 006f 005f 003f
  07 Def VLAN ID & Prio     0006 0005 0004 0003 0002 0000 0000
-08 Port control 2         0c80 0c80 0c80 0c80 0c80 1080 2080
+08 Port control 2         0c80 0c80 0c80 0c80 0c80 1080 1080
  09 Egress rate control    0001 0001 0001 0001 0001 0001 0001
  0a Egress rate control 2  0000 0000 0000 0000 0000 0000 0000
-0b Port association vec   1001 1002 1004 1008 1010 1000 1000
+0b Port association vec   1001 1002 1004 1008 1010 1020 1040
  0c Port ATU control       0000 0000 0000 0000 0000 0000 0000
  0d Override               0000 0000 0000 0000 0000 0000 0000
  0e Policy control         0000 0000 0000 0000 0000 0000 0000
  0f Port ether type        9100 9100 9100 9100 9100 dada dada
  10 In discard low         0000 0000 0000 0000 0000 0000 0000
  11 In discard high        0000 0000 0000 0000 0000 0000 0000
-12 In filtered            0000 0000 0000 0000 0000 0000 0000
-13 RX frame count         0000 0000 0000 008c 0000 021a 0000
+12 In filtered            0000 0000 0000 0003 0000 0000 0000
+13 RX frame count         0000 0000 0000 008e 0000 04dd 0000
  14 Reserved               0000 0000 0000 0000 0000 0000 0000
  15 Reserved               0000 0000 0000 0000 0000 0000 0000
  16 LED control            0000 0000 0000 0000 0000 0000 0000
@@ -39,22 +39,23 @@
  	T - a member, egress tagged
  	X - not a member, Ingress frames with VID discarded
  P  VID 0123456  FID  SID QPrio FPrio VidPolicy
-0    1 XXXXXVV    1    0     -     -     0
-0    2 XXXXUVV    6    0     -     -     0
-0    3 XXXUXVV    5    0     -     -     0
-0    4 XXUXXVV    4    0     -     -     0
-0    5 XUXXXVV    3    0     -     -     0
-0    6 UXXXXVV    2    0     -     -     0
+0    1 XXXXXVV    2    0     -     -     0
+0    2 XXXXUVV    7    0     -     -     0
+0    3 XXXUXVV    6    0     -     -     0
+0    4 XXUXXVV    5    0     -     -     0
+0    5 XUXXXVV    4    0     -     -     0
+0    6 UXXXXVV    3    0     -     -     0
+0 4095 UUUUUVV    1    0     -     -     0
  Global1:
  00 Global status                    c814
-01 ATU FID                          0006
-02 VTU FID                          0002
+01 ATU FID                          0007
+02 VTU FID                          0001
  03 VTU SID                          0000
  04 Global control                   40a8
-05 VTU operations                   4000
-06 VTU VID                          0fff
-07 VTU/STU Data 0-3                 3331
-08 VTU/STU Data 4-6                 0303
+05 VTU operations                   4043
+06 VTU VID                          1fff
+07 VTU/STU Data 0-3                 1111
+08 VTU/STU Data 4-6                 0111
  09 Reserved                         0000
  0a ATU control                      0149
  0b ATU operations                   4000
@@ -90,10 +91,10 @@
  08 Trunk mapping                    7800
  09 Ingress rate command             1600
  0a Ingress rate data                0000
-0b Cross chip port VLAN addr        31ff
-0c Cross chip port VLAN data        0000
-0d Switch MAC/WoL/WoF               05c5
-0e ATU Stats                        000f
+0b Cross chip port VLAN addr        3010
+0c Cross chip port VLAN data        007f
+0d Switch MAC/WoL/WoF               05fe
+0e ATU Stats                        001f
  0f Priority override table          0f00
  10 Reserved                         0000
  11 Reserved                         0000

Thanks in advance
Etienne

