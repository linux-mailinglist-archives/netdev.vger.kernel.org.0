Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715D6258CE8
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 12:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgIAKke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 06:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgIAKk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 06:40:29 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737D0C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 03:40:27 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id y4so890357ljk.8
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 03:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tSwLyEHrWwAG6w9IdRciKHg9LYv/Kbp7/VZ44uYvBT8=;
        b=fZKUzNXDqBPoOttIm1T9qcy/9dj3NaC7cqZxYnDF14y7+4NU1VORxLGXO/mRj6f8R8
         V68kMhpvG5gPXYQX/XNkkGk5Jb+cEo4bZ9FM3sOaoOFwKlu3hDPIGghGzd+MjseahM5Y
         CCkRIPKP1HPZPriv80QI3aKTNmHq04qwSmJFir5iug59SkogT0UeFjJcpMawBBgyV4LJ
         qVl2m3v2DHdduPaTyPwV0lF7OmNFqjLFI2jw5DuyUjWwJY/fBhonZe/Bj6UolbCkb1VP
         MZVkSMzLSdVAzD77f4RNdIy3G9nrE4tyDrZgJtb+eOqQCwKKzCIyYOmgAhFrDQHQQDIr
         6TpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tSwLyEHrWwAG6w9IdRciKHg9LYv/Kbp7/VZ44uYvBT8=;
        b=Rjzc1yXXnlMygSY8CwfGOlwKAbtkjPXv3N4vRFvnUfUi8jESZyDywgop9JHxUVdraB
         e/hRIY3WOVwvoMfNo2+jlzkAJgziYlGBimAyy+8eD20VrFA3xWMI0ykLUMVX87pPWb7h
         hypPaY9TpNGK3dOi/GEbGBv2AY+uKmQDOUNAW4o8tgpkcgJraiNeiIryouLYbBjkyTQs
         ONMP9U2am8P+4kb9AQvujq2bR20HTq+G00e1xohRDbKhdA6bBREmhXCyiMbLV56XYrMZ
         utHx+XlMqRf4LlRoCCOohe2tcIUQbk8Jsj9E0szjtkvqVIMmIBopdeld78FVAJXaBkPg
         9ipg==
X-Gm-Message-State: AOAM530iWHqGyeV5AcT0pfB27ugoFF94k/33NFEoIdYqoLwYz9t1S0Kj
        yZ//CIKgBGBvOQCwH+NkF3UeBXSXxxztgb0B4CaP0dR6Ajy/ZA==
X-Google-Smtp-Source: ABdhPJyL+7CL4SVB82dnDFPrDtDSVX46gOxWU3QoMSGFs+dbLoC0RPrASpM3PRfL0L64AaBw2Eh8E5rlx65C3KWGwHY=
X-Received: by 2002:a2e:6e12:: with SMTP id j18mr278217ljc.430.1598956825906;
 Tue, 01 Sep 2020 03:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
 <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com> <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
 <1b4ebdb3-8840-810a-0d5e-74e2cf7693bf@gmail.com> <CANXY5yJeCeC_FaQHx0GPn88sQCog59k2vmu8o-h6yRrikSQ3vQ@mail.gmail.com>
 <deb7a653-a01b-da4f-c58e-15b6c0c51d75@gmail.com> <CANXY5yKNOkBWUTVjOCBBPfACTV_R89ydiOi=YiOZ92in_VEp4w@mail.gmail.com>
 <962617e5-9dec-6715-d550-4cf3ee414cf6@gmail.com> <CANXY5yKW=+e1CsoXCb0p_+6n8ZLz4eoOQz_5OkrrjYF6mpU9ZQ@mail.gmail.com>
In-Reply-To: <CANXY5yKW=+e1CsoXCb0p_+6n8ZLz4eoOQz_5OkrrjYF6mpU9ZQ@mail.gmail.com>
From:   mastertheknife <mastertheknife@gmail.com>
Date:   Tue, 1 Sep 2020 13:40:14 +0300
Message-ID: <CANXY5yLXpS+YYVeUPGok7R=4cm2AEAoM1zR_sd6YSKqCJPGLOg@mail.gmail.com>
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David.

I was able to solve it while troubleshooting some fragmentation issue.
The VTI interfaces had MTU of 1480 by default. I reduced to them to
the real PMTUD (1366) and now its all working just fine.
I am not sure how its related and why, but seems like it solved the issue.

P.S: while reading the relevant code in the kernel, i think i spotted
some mistake in net/ipv4/route.c, in function "update_or_create_fnhe".
It looks like it loops over all the exceptions for the nexthop entry,
but always overwriting the first (and only) entry, so effectively only
1 exception can exist per nexthop entry.
Line 678:
"if (fnhe) {"
Should probably be:
"if (fnhe && fnhe->fnhe_daddr == daddr) {"


Thank you for your efforts,
Kfir Itzhak

On Fri, Aug 14, 2020 at 10:08 AM mastertheknife
<mastertheknife@gmail.com> wrote:
>
> Hello David,
>
> It's on a production system, vmbr2 is a bridge with eth.X VLAN
> interface inside for the connectivity on that 252.0/24 network. vmbr2
> has address 192.168.252.5 in that case
> 192.168.252.250 and 192.168.252.252 are CentOS8 LXCs on another host,
> with libreswan inside for any/any IPSECs with VTi interfaces.
>
> Everything is kernel 5.4.44 LTS
>
> I wish i could fully reproduce all of it in a script, but i am not
> sure how to create such hops that return this ICMP
>
> Thank you,
> Kfir
>
>
> On Wed, Aug 12, 2020 at 10:21 PM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 8/12/20 6:37 AM, mastertheknife wrote:
> > > Hello David,
> > >
> > > I tried and it seems i can reproduce it:
> > >
> > > # Create test NS
> > > root@host:~# ip netns add testns
> > > # Create veth pair, veth0 in host, veth1 in NS
> > > root@host:~# ip link add veth0 type veth peer name veth1
> > > root@host:~# ip link set veth1 netns testns
> > > # Configure veth1 (NS)
> > > root@host:~# ip netns exec testns ip addr add 192.168.252.209/24 dev veth1
> > > root@host:~# ip netns exec testns ip link set dev veth1 up
> > > root@host:~# ip netns exec testns ip route add default via 192.168.252.100
> > > root@host:~# ip netns exec testns ip route add 192.168.249.0/24
> > > nexthop via 192.168.252.250 nexthop via 192.168.252.252
> > > # Configure veth0 (host)
> > > root@host:~# brctl addif vmbr2 veth0
> >
> > vmbr2's config is not defined.
> >
> > ip li add vmbr2 type bridge
> > ip li set veth0 master vmbr2
> > ip link set veth0 up
> >
> > anything else? e.g., address for vmbr2? What holds 192.168.252.250 and
> > 192.168.252.252
