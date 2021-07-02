Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E543B9A1B
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 02:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhGBAea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 20:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhGBAe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 20:34:29 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46436C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 17:31:57 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id o5so13398425ejy.7
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 17:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jY4md3mqLHqztzu+evEzUfuOkWX+XTGArVYH6u63Kg4=;
        b=T10DDQ1Xik+8Y9hhpOldamAbvYgad+QOrl2OYn1mc8db60egX9skNM4GA5/Z8xLrYP
         tCfsRAe9THqjzvrJwthqKO39LRNyzD2K5lXsi0I9PzCnw1FK8eObgIm2HglFHrmfrNRk
         x5+8cGHfKAxa6bKc3kpHEP7pVwe/I1/mttBlaVFksfMvBSFP34+/+69Fe1o/FYpUaXSz
         45j3QrIYE54wR6txWFgbF36k6f4TqKWTJmTtS8e9w8MecHMR7kwcL6bTkAePX3XHS4Cv
         MDH6pJd20CmTkbyQsFLys5oyAiv7QxEkdxYhiimtH/2lBL/Bf2wKh8wrDluPR3bYWej9
         O38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jY4md3mqLHqztzu+evEzUfuOkWX+XTGArVYH6u63Kg4=;
        b=SITL2N/PBVotEoS/U6y2cTpivfeSqfXLDmwDK8gmj44TE5e00estFKFoiNEUL5Umlc
         OJEeGUXJ3kG/ZR0Jt2M9ZpgSNSHlwmkXcjiaO0jsc7o76SpLHFvNzRuujw5ZbupnKnN+
         8lPQFBF+pAmzEdxRGsnROsjf1CzN+xsrw9+xH7JKn8czn5S1mfUoyB1ZqGMnN/XlAmG3
         PO1Kisx9P/RHqUsOAke157Xj9YVA9+Z+9Ie9/anP8rLYOA7JSJ+/b6cjQVdJUViKIinT
         cD6D/KX9bp6HpU5+hTmPCA571d6rTzFNgxGRHtqien/Elp2ehnsKJ5F2SYhtOswx/Rq4
         1ujQ==
X-Gm-Message-State: AOAM5332vpIa5e1GFTHJDOtTBHrYhEV4m9Jxpdj9pW9F32z//V4JuAVh
        JZcsV/yDJFjY1cAyCdSK2Iyv3ZUXanA=
X-Google-Smtp-Source: ABdhPJxbAllmXdnAjCyFrGO/tsUWukGU5DFMI2JGJOpc+WZlArMPFtsGF94td+eRgdLTuuFIWCD6pg==
X-Received: by 2002:a17:906:f8da:: with SMTP id lh26mr2521241ejb.243.1625185915899;
        Thu, 01 Jul 2021 17:31:55 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id g23sm569525edp.74.2021.07.01.17.31.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 17:31:55 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id v5so10377871wrt.3
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 17:31:54 -0700 (PDT)
X-Received: by 2002:a5d:6502:: with SMTP id x2mr2440520wru.327.1625185914070;
 Thu, 01 Jul 2021 17:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de> <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
In-Reply-To: <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 1 Jul 2021 20:31:14 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
Message-ID: <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
Subject: Re: [regression] UDP recv data corruption
To:     David Ahern <dsahern@gmail.com>
Cc:     Matthias Treydte <mt@waldheinz.de>, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 11:39 AM David Ahern <dsahern@gmail.com> wrote:
>
> [ adding Paolo, author of 18f25dc39990 ]
>
> On 7/1/21 4:47 AM, Matthias Treydte wrote:
> > Hello,
> >
> > we recently upgraded the Linux kernel from 5.11.21 to 5.12.12 in our
> > video stream receiver appliance and noticed compression artifacts on
> > video streams that were previously looking fine. We are receiving UDP
> > multicast MPEG TS streams through an FFMpeg / libav layer which does the
> > socket and lower level protocol handling. For affected kernels it spills
> > the log with messages like
> >
> >> [mpegts @ 0x7fa130000900] Packet corrupt (stream = 0, dts = 6870802195).
> >> [mpegts @ 0x7fa11c000900] Packet corrupt (stream = 0, dts = 6870821068).
> >
> > Bisecting identified commit 18f25dc399901426dff61e676ba603ff52c666f7 as
> > the one introducing the problem in the mainline kernel. It was
> > backported to the 5.12 series in
> > 450687386cd16d081b58cd7a342acff370a96078. Some random observations which
> > may help to understand what's going on:
> >
> >    * the problem exists in Linux 5.13
> >    * reverting that commit on top of 5.13 makes the problem go away
> >    * Linux 5.10.45 is fine
> >    * no relevant output in dmesg
> >    * can be reproduced on different hardware (Intel, AMD, different
> > NICs, ...)
> >    * we do use the bonding driver on the systems (but I did not yet
> > verify that this is related)
> >    * we do not use vxlan (mentioned in the commit message)
> >    * the relevant code in FFMpeg identifying packet corruption is here:
> >
> > https://github.com/FFmpeg/FFmpeg/blob/master/libavformat/mpegts.c#L2758
> >
> > And the bonding configuration:
> >
> > # cat /proc/net/bonding/bond0
> > Ethernet Channel Bonding Driver: v5.10.45
> >
> > Bonding Mode: fault-tolerance (active-backup)
> > Primary Slave: None
> > Currently Active Slave: enp2s0
> > MII Status: up
> > MII Polling Interval (ms): 100
> > Up Delay (ms): 0
> > Down Delay (ms): 0
> > Peer Notification Delay (ms): 0
> >
> > Slave Interface: enp2s0
> > MII Status: up
> > Speed: 1000 Mbps
> > Duplex: full
> > Link Failure Count: 0
> > Permanent HW addr: 80:ee:73:XX:XX:XX
> > Slave queue ID: 0
> >
> > Slave Interface: enp3s0
> > MII Status: down
> > Speed: Unknown
> > Duplex: Unknown
> > Link Failure Count: 0
> > Permanent HW addr: 80:ee:73:XX:XX:XX
> > Slave queue ID: 0
> >
> >
> > If there is anything else I can do to help tracking this down please let
> > me know.

That library does not enable UDP_GRO. You do not have any UDP based
tunnel devices (besides vxlan) configured, either, right?

Then no socket lookup should take place, so sk is NULL.

It is also unlikely that the device has either of NETIF_F_GRO_FRAGLIST
or NETIF_F_GRO_UDP_FWD configured. This can be checked with `ethtool
-K $DEV`, shown as "rx-gro-list" and "rx-udp-gro-forwarding",
respectively.

Then udp_gro_receive_segment is not called.

So this should just return the packet without applying any GRO.

I'm referring to this block of code in udp_gro_receive:

        if (!sk || !udp_sk(sk)->gro_receive) {
                if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
                        NAPI_GRO_CB(skb)->is_flist = sk ?
!udp_sk(sk)->gro_enabled : 1;

                if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
                    (sk && udp_sk(sk)->gro_enabled) ||
NAPI_GRO_CB(skb)->is_flist)
                        pp = call_gro_receive(udp_gro_receive_segment,
head, skb);
                return pp;
        }

I don't see what could be up.

One possible short-term workaround is to disable GRO. If this commit
is implicated, that should fix it. At some obvious possible cycle
cost.
