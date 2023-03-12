Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD216B6358
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 06:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCLFcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 00:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCLFcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 00:32:48 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F01C42BF6
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 21:32:47 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id u15so3249271qkk.4
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 21:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678599166;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHjfSA31J1JvshI31VUHUzrLF8fbrhtBXfjHQF/7i4Q=;
        b=JZXgBqVgxE1kxhkXIDHQOUOeZ3pCX1K1GvX+xEAYbjSu0ywE8NZzmTC7oOF0LvD0sK
         Y9RwT6tCaAnzWEixKULZ4yvwZIv36Vu4Wk3OES9NA1HJGBLOv0seqT9+G5E1Yu+t+NFs
         fayV437ssLp/x7xGnBklOWNilDlaRxsKcqIPUekg4z9Pkt1rJb9Q6C9ULl4zaG8SNEV9
         4dtrsouTHO4Qy56ncZ4+/h6K707kAIXdhGafl1Q1FAF8D0GHCh1CClQEW3BRyaxRE61R
         esKqFU7jZP7RvgYkbXBpkrRbKC6YvfTahmBvBv8ml+k0/NLaDgDfVBmjyEZVEe1M19dJ
         NbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678599166;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHjfSA31J1JvshI31VUHUzrLF8fbrhtBXfjHQF/7i4Q=;
        b=ZmiVYWgrHIbVLbwnCm12UEXwosElZ04ayp+BhqPsZNvWDVEvKDt70eMDZlffcyLkRI
         0Lu3WAT3VCdVUE1H9C6Rmi54aNdULYyBnQQ7sqTF6lAWAn6VdS+AqKoTcYvzeeJGD9uO
         ay4Y+MoOaZW80VjfAvRDlcxbXjM9MEyK8fhyfBKKJKYe1ti5nf3WQw9yucKIvtqSdR8M
         gzi0XfxfJYCDjgH/U9vUZ9Y2ZcqoRVygbgY6xXLYZZL3M+0PGB3ayWLIXngSxKsiPjZ4
         HVS5ut0XdYKgi13PEr45CI5AUMhKJ+0uanViEZCom0vt8GYaPriDrneetYPrK9yrNzX+
         5pJg==
X-Gm-Message-State: AO0yUKWPCJ72pQf5bpdtV14Fhxa60MxYUa20o93MglY13fr20emUUpH4
        JSh0uPoyel2+3pyDj8J3gj1MoF7mbp5dq/29YKgKdi+c
X-Google-Smtp-Source: AK7set+G04XH5ieyzElzgipSj5m5UQOLdPrtMlDbe+4uo/MkUyGWlDyBqCAQz2Px6P/V7aYRtepsOTzpNrBo91obWG0=
X-Received: by 2002:a05:620a:148a:b0:742:69a6:8c1b with SMTP id
 w10-20020a05620a148a00b0074269a68c1bmr2143352qkj.11.1678599166084; Sat, 11
 Mar 2023 21:32:46 -0800 (PST)
MIME-Version: 1.0
References: <ff97fbb2-4c89-bbc2-3134-b085c6279a5f@gmail.com>
In-Reply-To: <ff97fbb2-4c89-bbc2-3134-b085c6279a5f@gmail.com>
From:   Etienne Champetier <champetier.etienne@gmail.com>
Date:   Sun, 12 Mar 2023 00:32:09 -0500
Message-ID: <CAOdf3goFaWqN_QYphmLhmwi6oeBrE=cX5Q4xAfZGcKovji=K3Q@mail.gmail.com>
Subject: Re: mv88e6xxx / MV88E6176 + VLAN-aware unusable in 5.15.98 (ok in 5.10.168)
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry about that, apparently I can't use thunderbird ...

Le dim. 12 mars 2023 =C3=A0 00:28, Etienne Champetier
<champetier.etienne@gmail.com> a =C3=A9crit :
>
> Hello Vladimir, Tobias, Sending this email to both of you as reverting
> some of your patches 'fix' the issues I'm seeing. I'm slowly
> investigating a regression in OpenWrt going from 22.03 (5.10.168 + some
> backports) to current master (5.15.98 + some backports). Using my Turris
> Omnia (MV88E6176) with the following network config:
>
> # bridge vlan port              vlan-id lan0              6 PVID Egress
> Untagged lan1              5 PVID Egress Untagged lan2              4
> PVID Egress Untagged lan3              3 PVID Egress Untagged
> lan4              2 PVID Egress Untagged br-lan            2
>                    3                   4                   5
>                    6 wlan1             3 PVID Egress Untagged
> wlan1-1           5 PVID Egress Untagged wlan1-2           6 PVID Egress
> Untagged wlan0             2 PVID Egress Untagged
>
> I get tagged frame with VID 3 on lan4 (at least some multicast &
> broadcast), but lan4 is not a member of VLAN 3 Also unicast frames from
> wifi to lan4 exit tagged with VID 2, broadcast frames are fine (verifed
> with scapy) Reverting 5bded8259ee3 "net: dsa: mv88e6xxx: isolate the ATU
> databases of standalone and bridged ports" from Vladimir and
> b80dc51b72e2 "net: dsa: mv88e6xxx: Only allow LAG offload on supported
> hardware" 57e661aae6a8 "net: dsa: mv88e6xxx: Link aggregation support"
> from Tobias allow me to get back to 5.10 behavior / working system. On
> the OpenWrt side, 5.15 is the latest supported kernel, so I was not able
> to try more recent for now. I'm happy to try to backport any patches
> that can help fix or narrow down the issue, or provide more infos /
> tests results. These issues affect other devices using mv88e6xxx:
> https://github.com/openwrt/openwrt/issues/11877 In the Github issue the
> reporter note that first packet is not tagged and the following are.
> Here a diff of "mv88e6xxx_dump --vtu --ports --global1 --global2"
> between 5.10 and 5.15 (without revert)
>
> @@ -9,18 +9,18 @@  05 Port control 1         0000 0000 0000 0000 0000
> 0000 0000  06 Port base VLAN map     007e 007d 007b 0077 006f 005f 003f
>   07 Def VLAN ID & Prio     0006 0005 0004 0003 0002 0000 0000 -08 Port
> control 2         0c80 0c80 0c80 0c80 0c80 1080 2080 +08 Port control
> 2         0c80 0c80 0c80 0c80 0c80 1080 1080  09 Egress rate control
> 0001 0001 0001 0001 0001 0001 0001  0a Egress rate control 2  0000 0000
> 0000 0000 0000 0000 0000 -0b Port association vec   1001 1002 1004 1008
> 1010 1000 1000 +0b Port association vec   1001 1002 1004 1008 1010 1020
> 1040  0c Port ATU control       0000 0000 0000 0000 0000 0000 0000  0d
> Override               0000 0000 0000 0000 0000 0000 0000  0e Policy
> control         0000 0000 0000 0000 0000 0000 0000  0f Port ether
> type        9100 9100 9100 9100 9100 dada dada  10 In discard
> low         0000 0000 0000 0000 0000 0000 0000  11 In discard
> high        0000 0000 0000 0000 0000 0000 0000 -12 In
> filtered            0000 0000 0000 0000 0000 0000 0000 -13 RX frame
> count         0000 0000 0000 008c 0000 021a 0000 +12 In
> filtered            0000 0000 0000 0003 0000 0000 0000 +13 RX frame
> count         0000 0000 0000 008e 0000 04dd 0000  14
> Reserved               0000 0000 0000 0000 0000 0000 0000  15
> Reserved               0000 0000 0000 0000 0000 0000 0000  16 LED
> control            0000 0000 0000 0000 0000 0000 0000 @@ -39,22 +39,23
> @@      T - a member, egress tagged      X - not a member, Ingress
> frames with VID discarded  P  VID 0123456  FID  SID QPrio FPrio
> VidPolicy -0    1 XXXXXVV    1    0     -     -     0 -0    2 XXXXUVV
> 6    0     -     -     0 -0    3 XXXUXVV    5    0     -     -     0
> -0    4 XXUXXVV    4    0     -     -     0 -0    5 XUXXXVV    3
> 0     -     -     0 -0    6 UXXXXVV    2    0     -     -     0 +0    1
> XXXXXVV    2    0     -     -     0 +0    2 XXXXUVV    7    0     -
> -     0 +0    3 XXXUXVV    6    0     -     -     0 +0    4 XXUXXVV
> 5    0     -     -     0 +0    5 XUXXXVV    4    0     -     -     0
> +0    6 UXXXXVV    3    0     -     -     0 +0 4095 UUUUUVV    1
> 0     -     -     0  Global1:  00 Global status                    c814
> -01 ATU FID                          0006 -02 VTU
> FID                          0002 +01 ATU FID
> 0007 +02 VTU FID                          0001  03 VTU
> SID                          0000  04 Global control
> 40a8 -05 VTU operations                   4000 -06 VTU
> VID                          0fff -07 VTU/STU Data 0-3
> 3331 -08 VTU/STU Data 4-6                 0303 +05 VTU
> operations                   4043 +06 VTU VID
> 1fff +07 VTU/STU Data 0-3                 1111 +08 VTU/STU Data
> 4-6                 0111  09 Reserved                         0000  0a
> ATU control                      0149  0b ATU
> operations                   4000 @@ -90,10 +91,10 @@  08 Trunk
> mapping                    7800  09 Ingress rate command
> 1600  0a Ingress rate data                0000 -0b Cross chip port VLAN
> addr        31ff -0c Cross chip port VLAN data        0000 -0d Switch
> MAC/WoL/WoF               05c5 -0e ATU Stats                        000f
> +0b Cross chip port VLAN addr        3010 +0c Cross chip port VLAN
> data        007f +0d Switch MAC/WoL/WoF               05fe +0e ATU
> Stats                        001f  0f Priority override table
> 0f00  10 Reserved                         0000  11
> Reserved                         0000 Thanks in advance Etienne
>
