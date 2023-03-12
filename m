Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F40B6B65E0
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 13:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCLMMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 08:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjCLMLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 08:11:49 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49FB2FCF5
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 05:11:47 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id d36so12319016lfv.8
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 05:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112; t=1678623105;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XfNBJcVEPJkrjokqp7kCQpvGotNJ/9oVi2jWMayBqz4=;
        b=b26AJmldFTg8C+ZisbvKOJ94efflvig6EjGoOV+H/ZhJ9YQP6nruk4RdeWYMf7M6Ok
         CJ+vktL6XkrKcYdnGXovVMrYbdl7Bzuoo+vzc1Ru8vl8WNhe1/N9VQ4KT2VZJnUC1ggd
         B8j6mDBrGNoetipid+Fhwq1iWmnqHG1ghsxzh/0eU00U2DRPsWtI5byNSrsduBa6xsz6
         dDNEm0c1w0s5H7DkJfVtZ9Lkal+r1C92+Yw0kmnzyBWmWDGSd0LeiJsjf1340ALGu53R
         rLMbVAZqU3PfYHuqVk2TQjGn1DWUfHjqU/O0myf8iMbdil9mg1QpKx/oV5CPfM8XFO26
         egDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678623105;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:to:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XfNBJcVEPJkrjokqp7kCQpvGotNJ/9oVi2jWMayBqz4=;
        b=tnGDoS3dz35M2Y+JaxeZ5tP1+rCMjDaDUQgNpQFT5WDARl8midFKDhvi2QvOBw9qVp
         OOPz11aWhqz3zhr5wabjYT+YZr/+9tZLcRG723KZa6w02uO8AWcHZFdrHnVVN2YN3jHi
         Gc6hGGfdO8rEpPDLN5iwxQ2me1J6gg8DzaXE/Yq1YlAkItydcO0NZMFPS9nqnmfVXjug
         b78OgDE9b6/nsjP3eU2M4rwA4+zr6kxvlELU2N2+Yzlk1bN+pbrczTRxIGE6ng8SAVBQ
         UKBAEIqp+wAA1sEwBt8bprXDvtgs9MHlctxkyatuCucJ/7FIXipkdfseF+ghpUIGR5Yb
         Zz3g==
X-Gm-Message-State: AO0yUKVG9IdHAkWTGDL2urVzcTF9SOYtJ2v7jS3DdzQkOJWtrnTNT8hy
        Rl0qbxp0xkRBGBLpe6fArsxMpCZcN+Vr8znLFLE=
X-Google-Smtp-Source: AK7set+zkqnBAxgQ4qgMA+fq4mRmVyJrirTxwTrClwV6ZR2DQW6dDjqZhTSwgtjb9jNEeOok0+RwLw==
X-Received: by 2002:a19:c208:0:b0:4df:9ce8:300 with SMTP id l8-20020a19c208000000b004df9ce80300mr8951097lfc.52.1678623105349;
        Sun, 12 Mar 2023 05:11:45 -0700 (PDT)
Received: from wkz-x13 (h-98-128-229-186.NA.cust.bahnhof.se. [98.128.229.186])
        by smtp.gmail.com with ESMTPSA id q2-20020ac25a02000000b004b6f00832cesm633816lfn.166.2023.03.12.05.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 05:11:44 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Etienne Champetier <champetier.etienne@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: mv88e6xxx / MV88E6176 + VLAN-aware unusable in 5.15.98 (ok in
 5.10.168) (resend)
In-Reply-To: <cd306c78-14a6-bebb-e174-2917734b4799@gmail.com>
References: <cd306c78-14a6-bebb-e174-2917734b4799@gmail.com>
Date:   Sun, 12 Mar 2023 13:11:43 +0100
Message-ID: <87edpudv9c.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On s=C3=B6n, mar 12, 2023 at 00:41, Etienne Champetier <champetier.etienne@=
gmail.com> wrote:
> (properly formatted this time)
>
> Hello Vladimir, Tobias,
>
> Sending this email to both of you as reverting some of your patches 'fix'=
 the issues I'm seeing.
> I'm slowly investigating a regression in OpenWrt going from 22.03 (5.10.1=
68 + some backports)
> to current master (5.15.98 + some backports). Using my Turris Omnia (MV88=
E6176) with the following network config:
>
> # bridge vlan
> port              vlan-id
> lan0              6 PVID Egress Untagged
> lan1              5 PVID Egress Untagged
> lan2              4 PVID Egress Untagged
> lan3              3 PVID Egress Untagged
> lan4              2 PVID Egress Untagged
> br-lan            2
>                    3
>                    4
>                    5
>                    6
> wlan1             3 PVID Egress Untagged
> wlan1-1           5 PVID Egress Untagged
> wlan1-2           6 PVID Egress Untagged
> wlan0             2 PVID Egress Untagged
>
> I get tagged frame with VID 3 on lan4 (at least some multicast & broadcas=
t), but lan4 is not a member of VLAN 3

Are these packets being sent to the CPU with a FORWARD tag or TO_CPU? If
it is the latter, what is the CPU_CODE set to? Better yet, could you
post some output from `tcpdump -Q in -evnli <YOUR-DSA-INTERFACE>`?

> Also unicast frames from wifi to lan4 exit tagged with VID 2, broadcast f=
rames are fine (verifed with scapy)

If you're capturing on the lan4 interface, this is to be expected.

When forwarding offloading is enabled. In order for the tag driver to
generate the correct DSA tag, we need to know to which VLAN the packet
belongs (there could be more than one VLAN configured to egress
untagged). Since a FORWARD tag is (should be) generated, the switch will
handle the stripping of the VLAN tag for untagged members.

If you tcpdump at the DSA interface, are the packet sent to the switch
with a FORWARD tag or FROM_CPU?

> Reverting
> 5bded8259ee3 "net: dsa: mv88e6xxx: isolate the ATU databases of standalon=
e and bridged ports" from Vladimir
> and
> b80dc51b72e2 "net: dsa: mv88e6xxx: Only allow LAG offload on supported ha=
rdware"
> 57e661aae6a8 "net: dsa: mv88e6xxx: Link aggregation support"
> from Tobias allow me to get back to 5.10 behavior / working system.
>
> On the OpenWrt side, 5.15 is the latest supported kernel, so I was not ab=
le to try more recent for now.
>
> I'm happy to try to backport any patches that can help fix or narrow down=
 the issue, or provide more infos / tests results.
>
> These issues affect other devices using mv88e6xxx: https://github.com/ope=
nwrt/openwrt/issues/11877
> In the Github issue the reporter note that first packet is not tagged and=
 the following are.
>
> Here a diff of "mv88e6xxx_dump --vtu --ports --global1 --global2" between=
 5.10 and 5.15 (without revert)
>
> @@ -9,18 +9,18 @@
>   05 Port control 1         0000 0000 0000 0000 0000 0000 0000
>   06 Port base VLAN map     007e 007d 007b 0077 006f 005f 003f
>   07 Def VLAN ID & Prio     0006 0005 0004 0003 0002 0000 0000
> -08 Port control 2         0c80 0c80 0c80 0c80 0c80 1080 2080
> +08 Port control 2         0c80 0c80 0c80 0c80 0c80 1080 1080
>   09 Egress rate control    0001 0001 0001 0001 0001 0001 0001
>   0a Egress rate control 2  0000 0000 0000 0000 0000 0000 0000
> -0b Port association vec   1001 1002 1004 1008 1010 1000 1000
> +0b Port association vec   1001 1002 1004 1008 1010 1020 1040
>   0c Port ATU control       0000 0000 0000 0000 0000 0000 0000
>   0d Override               0000 0000 0000 0000 0000 0000 0000
>   0e Policy control         0000 0000 0000 0000 0000 0000 0000
>   0f Port ether type        9100 9100 9100 9100 9100 dada dada
>   10 In discard low         0000 0000 0000 0000 0000 0000 0000
>   11 In discard high        0000 0000 0000 0000 0000 0000 0000
> -12 In filtered            0000 0000 0000 0000 0000 0000 0000
> -13 RX frame count         0000 0000 0000 008c 0000 021a 0000
> +12 In filtered            0000 0000 0000 0003 0000 0000 0000
> +13 RX frame count         0000 0000 0000 008e 0000 04dd 0000
>   14 Reserved               0000 0000 0000 0000 0000 0000 0000
>   15 Reserved               0000 0000 0000 0000 0000 0000 0000
>   16 LED control            0000 0000 0000 0000 0000 0000 0000
> @@ -39,22 +39,23 @@
>   	T - a member, egress tagged
>   	X - not a member, Ingress frames with VID discarded
>   P  VID 0123456  FID  SID QPrio FPrio VidPolicy
> -0    1 XXXXXVV    1    0     -     -     0
> -0    2 XXXXUVV    6    0     -     -     0
> -0    3 XXXUXVV    5    0     -     -     0
> -0    4 XXUXXVV    4    0     -     -     0
> -0    5 XUXXXVV    3    0     -     -     0
> -0    6 UXXXXVV    2    0     -     -     0
> +0    1 XXXXXVV    2    0     -     -     0
> +0    2 XXXXUVV    7    0     -     -     0
> +0    3 XXXUXVV    6    0     -     -     0
> +0    4 XXUXXVV    5    0     -     -     0
> +0    5 XUXXXVV    4    0     -     -     0
> +0    6 UXXXXVV    3    0     -     -     0
> +0 4095 UUUUUVV    1    0     -     -     0
>   Global1:
>   00 Global status                    c814
> -01 ATU FID                          0006
> -02 VTU FID                          0002
> +01 ATU FID                          0007
> +02 VTU FID                          0001
>   03 VTU SID                          0000
>   04 Global control                   40a8
> -05 VTU operations                   4000
> -06 VTU VID                          0fff
> -07 VTU/STU Data 0-3                 3331
> -08 VTU/STU Data 4-6                 0303
> +05 VTU operations                   4043
> +06 VTU VID                          1fff
> +07 VTU/STU Data 0-3                 1111
> +08 VTU/STU Data 4-6                 0111
>   09 Reserved                         0000
>   0a ATU control                      0149
>   0b ATU operations                   4000
> @@ -90,10 +91,10 @@
>   08 Trunk mapping                    7800
>   09 Ingress rate command             1600
>   0a Ingress rate data                0000
> -0b Cross chip port VLAN addr        31ff
> -0c Cross chip port VLAN data        0000
> -0d Switch MAC/WoL/WoF               05c5
> -0e ATU Stats                        000f
> +0b Cross chip port VLAN addr        3010
> +0c Cross chip port VLAN data        007f
> +0d Switch MAC/WoL/WoF               05fe
> +0e ATU Stats                        001f
>   0f Priority override table          0f00
>   10 Reserved                         0000
>   11 Reserved                         0000
>
> Thanks in advance
> Etienne
