Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C626B6351
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 06:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCLF2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 00:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCLF2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 00:28:52 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA59926CC8
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 21:28:50 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id cf14so10128346qtb.10
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 21:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678598930;
        h=content-transfer-encoding:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSZ9gil4SJpgPAgQDw4m1AekxSttSdGn6z7kzdyEQnc=;
        b=JYl0VRONoXlpdEZZOkh6dCNeNaaLGRQv6NyGM+0CMymjWWjVn1bKmEq6yXqiGgUp2D
         yQo8lH/OL5sCMUFh1HRQQZmnGT/LW31Mbef6MyADo2Li6PGNM5256j+JccXL22uExoba
         F2a5VI7sYfPGzpP1HwLNiLaeeZ6QV2PrlPIMUxfwxkgy14o7Pn0S6w6YYpiPtkhUQSW8
         eRrXajgqqTU/3Pybfd/kCgj5DKzXALe4DTSS+akNIGCNOhl7pRxp4TDTimQPDOK8e0Ue
         oBOjN8r9kUAnDPv5tOxkTrZis8GjjZIgYJNTS3jxAMhkTXkiDOKf10diPJax/iRVY1zP
         +sYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678598930;
        h=content-transfer-encoding:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OSZ9gil4SJpgPAgQDw4m1AekxSttSdGn6z7kzdyEQnc=;
        b=Zg13Af064/JUgXggOxuYOYp2vrMPPWAyqyRuhssr8i9u7lRTzhJ2J4YEXJZ4uxPQop
         cP40QdV6ToIIIvBcCYgyv6pnEey3m07ak9/n6A8TL+EkhlUsZqBO/KK/5gAIUgGbu2PH
         QrwRYlY70lUPL3f+JuFDefnq/1/1aHbPXPmrZxKlKbKbOTIcjcj67HqKgIekuGbcaMUO
         3HJLjTrCAlUGsL0oTZMDzqSH+1BVNB8o1HJ3XkFyQnzYoOQT0e4izHE5J7rIj0tqfhAr
         RNT+IVprmjYyVNYcGrIupHXVcTbFM276pgFCwCPrJvNEf5oXd0J68OSPyKoMc5hwbtle
         SguA==
X-Gm-Message-State: AO0yUKVi7bvZMCgK839iyXJNeQJty+j+ojsLjeic8FHwJ8/zj3dmZXJF
        ymjfZRqgyanWpFLNausiSd4=
X-Google-Smtp-Source: AK7set/0G9np5lErau2KjO9Y9cBg0IMapUQSxeD1Z9pRnoCp/K8GxIQ51nWi4NVpfNH4gSMVM9Yu5w==
X-Received: by 2002:a05:622a:24a:b0:3bf:d00e:9908 with SMTP id c10-20020a05622a024a00b003bfd00e9908mr55490266qtx.44.1678598929950;
        Sat, 11 Mar 2023 21:28:49 -0800 (PST)
Received: from ?IPV6:2607:fea8:1b9f:c5b0::349? ([2607:fea8:1b9f:c5b0::349])
        by smtp.gmail.com with ESMTPSA id v24-20020a05622a189800b003bfb0ea8094sm3139314qtc.83.2023.03.11.21.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 21:28:49 -0800 (PST)
Message-ID: <ff97fbb2-4c89-bbc2-3134-b085c6279a5f@gmail.com>
Date:   Sun, 12 Mar 2023 00:28:47 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US, fr-FR
From:   Etienne Champetier <champetier.etienne@gmail.com>
Subject: mv88e6xxx / MV88E6176 + VLAN-aware unusable in 5.15.98 (ok in
 5.10.168)
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vladimir, Tobias, Sending this email to both of you as reverting 
some of your patches 'fix' the issues I'm seeing. I'm slowly 
investigating a regression in OpenWrt going from 22.03 (5.10.168 + some 
backports) to current master (5.15.98 + some backports). Using my Turris 
Omnia (MV88E6176) with the following network config:

# bridge vlan port              vlan-id lan0              6 PVID Egress 
Untagged lan1              5 PVID Egress Untagged lan2              4 
PVID Egress Untagged lan3              3 PVID Egress Untagged 
lan4              2 PVID Egress Untagged br-lan            2 
                   3                   4                   5 
                   6 wlan1             3 PVID Egress Untagged 
wlan1-1           5 PVID Egress Untagged wlan1-2           6 PVID Egress 
Untagged wlan0             2 PVID Egress Untagged

I get tagged frame with VID 3 on lan4 (at least some multicast & 
broadcast), but lan4 is not a member of VLAN 3 Also unicast frames from 
wifi to lan4 exit tagged with VID 2, broadcast frames are fine (verifed 
with scapy) Reverting 5bded8259ee3 "net: dsa: mv88e6xxx: isolate the ATU 
databases of standalone and bridged ports" from Vladimir and 
b80dc51b72e2 "net: dsa: mv88e6xxx: Only allow LAG offload on supported 
hardware" 57e661aae6a8 "net: dsa: mv88e6xxx: Link aggregation support" 
from Tobias allow me to get back to 5.10 behavior / working system. On 
the OpenWrt side, 5.15 is the latest supported kernel, so I was not able 
to try more recent for now. I'm happy to try to backport any patches 
that can help fix or narrow down the issue, or provide more infos / 
tests results. These issues affect other devices using mv88e6xxx: 
https://github.com/openwrt/openwrt/issues/11877 In the Github issue the 
reporter note that first packet is not tagged and the following are. 
Here a diff of "mv88e6xxx_dump --vtu --ports --global1 --global2" 
between 5.10 and 5.15 (without revert)

@@ -9,18 +9,18 @@  05 Port control 1         0000 0000 0000 0000 0000 
0000 0000  06 Port base VLAN map     007e 007d 007b 0077 006f 005f 003f 
  07 Def VLAN ID & Prio     0006 0005 0004 0003 0002 0000 0000 -08 Port 
control 2         0c80 0c80 0c80 0c80 0c80 1080 2080 +08 Port control 
2         0c80 0c80 0c80 0c80 0c80 1080 1080  09 Egress rate control    
0001 0001 0001 0001 0001 0001 0001  0a Egress rate control 2  0000 0000 
0000 0000 0000 0000 0000 -0b Port association vec   1001 1002 1004 1008 
1010 1000 1000 +0b Port association vec   1001 1002 1004 1008 1010 1020 
1040  0c Port ATU control       0000 0000 0000 0000 0000 0000 0000  0d 
Override               0000 0000 0000 0000 0000 0000 0000  0e Policy 
control         0000 0000 0000 0000 0000 0000 0000  0f Port ether 
type        9100 9100 9100 9100 9100 dada dada  10 In discard 
low         0000 0000 0000 0000 0000 0000 0000  11 In discard 
high        0000 0000 0000 0000 0000 0000 0000 -12 In 
filtered            0000 0000 0000 0000 0000 0000 0000 -13 RX frame 
count         0000 0000 0000 008c 0000 021a 0000 +12 In 
filtered            0000 0000 0000 0003 0000 0000 0000 +13 RX frame 
count         0000 0000 0000 008e 0000 04dd 0000  14 
Reserved               0000 0000 0000 0000 0000 0000 0000  15 
Reserved               0000 0000 0000 0000 0000 0000 0000  16 LED 
control            0000 0000 0000 0000 0000 0000 0000 @@ -39,22 +39,23 
@@      T - a member, egress tagged      X - not a member, Ingress 
frames with VID discarded  P  VID 0123456  FID  SID QPrio FPrio 
VidPolicy -0    1 XXXXXVV    1    0     -     -     0 -0    2 XXXXUVV    
6    0     -     -     0 -0    3 XXXUXVV    5    0     -     -     0 
-0    4 XXUXXVV    4    0     -     -     0 -0    5 XUXXXVV    3    
0     -     -     0 -0    6 UXXXXVV    2    0     -     -     0 +0    1 
XXXXXVV    2    0     -     -     0 +0    2 XXXXUVV    7    0     -     
-     0 +0    3 XXXUXVV    6    0     -     -     0 +0    4 XXUXXVV    
5    0     -     -     0 +0    5 XUXXXVV    4    0     -     -     0 
+0    6 UXXXXVV    3    0     -     -     0 +0 4095 UUUUUVV    1    
0     -     -     0  Global1:  00 Global status                    c814 
-01 ATU FID                          0006 -02 VTU 
FID                          0002 +01 ATU FID                          
0007 +02 VTU FID                          0001  03 VTU 
SID                          0000  04 Global control                   
40a8 -05 VTU operations                   4000 -06 VTU 
VID                          0fff -07 VTU/STU Data 0-3                 
3331 -08 VTU/STU Data 4-6                 0303 +05 VTU 
operations                   4043 +06 VTU VID                          
1fff +07 VTU/STU Data 0-3                 1111 +08 VTU/STU Data 
4-6                 0111  09 Reserved                         0000  0a 
ATU control                      0149  0b ATU 
operations                   4000 @@ -90,10 +91,10 @@  08 Trunk 
mapping                    7800  09 Ingress rate command             
1600  0a Ingress rate data                0000 -0b Cross chip port VLAN 
addr        31ff -0c Cross chip port VLAN data        0000 -0d Switch 
MAC/WoL/WoF               05c5 -0e ATU Stats                        000f 
+0b Cross chip port VLAN addr        3010 +0c Cross chip port VLAN 
data        007f +0d Switch MAC/WoL/WoF               05fe +0e ATU 
Stats                        001f  0f Priority override table          
0f00  10 Reserved                         0000  11 
Reserved                         0000 Thanks in advance Etienne

