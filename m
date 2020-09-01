Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65695258CF6
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 12:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgIAKoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 06:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgIAKo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 06:44:26 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0CCC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 03:44:25 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y2so482673lfy.10
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 03:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t8OZFR7MHflvya1zMtvOTv8MIh46Z38uUiGfPt1SWIQ=;
        b=jSxHBdc5iXElQMT2v+rw2IN/RZ391GjX2xjb1hw+/RFZpvwtAhU2sOiIHojBdScvN4
         jaEmIeAnx4BHyjGfybHx6KkBAYJhEPP4qzr3rcU9ke3g84PjA++81O8op+/0BLi3SVKD
         OcxFwKWyp//L9q5ojRYyA7iAr6AkRBuvKryzYNdsEyTul8ukS2PP45RiGiFzfzWzV/hp
         tSeajZ/RH+CJSjMEB4ViP4+2ubmxX05piQWXyVgXN60u9tEh2QRkLd+KN9H1aUf7W3bl
         WdZORjVS3iwx+OLONNDLEQEvJzuFCiijelwM7+hanM02Pv2F0xLEs06ToNgS79/4IhR3
         xgQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t8OZFR7MHflvya1zMtvOTv8MIh46Z38uUiGfPt1SWIQ=;
        b=MpMV+QFLBLwxXHfHGPu+av9uywAUxAAaXY+M2z8dvLtgGv38w1W65YKMgop5YHMCXK
         HchnTubcP4xcrgHhRe1nseKMU66oxcjo2vQHQ/rJ21wvTg6zK3j2Vun4TZixCkuu6Pib
         p4pvbhAT0/7PIcali5tSiTmsVWZ5lvDOwjwUbnsK/lzmKMnKXHc+o/IkvRv8a712PgNk
         cLLs+lNJn5taS65/QiczwhVzEFScLDzCm218GQsuLqZcSAwdMzkvEubmfJtKjpcfcLrL
         r15KA65RobGakgLbSGpvCBXGoHHE4uk96s6WCNyZNzh1nNSEXf6cW2gKaIfwtyhG7gw2
         4b7Q==
X-Gm-Message-State: AOAM530ulOuf2xg+HmAu2T6vIc5CxmcWFm6s6bW7vxFKn75gS+x9OlK6
        wZEv5ET/9yOXJqurcISiX8m5u8a3EL30jU6GyEJNObecFCc=
X-Google-Smtp-Source: ABdhPJzN1a9AawLa8RzCnfcaSQ6Gi/sNzbrxIhPx+ISfEThCFonBL4ilXK9/1kzyCChCH/FHIAsn7sD8wR19BPiS6WE=
X-Received: by 2002:a19:5f5e:: with SMTP id a30mr298096lfj.64.1598957063824;
 Tue, 01 Sep 2020 03:44:23 -0700 (PDT)
MIME-Version: 1.0
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
 <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com> <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
 <1b4ebdb3-8840-810a-0d5e-74e2cf7693bf@gmail.com> <CANXY5yJeCeC_FaQHx0GPn88sQCog59k2vmu8o-h6yRrikSQ3vQ@mail.gmail.com>
 <deb7a653-a01b-da4f-c58e-15b6c0c51d75@gmail.com> <CANXY5yKNOkBWUTVjOCBBPfACTV_R89ydiOi=YiOZ92in_VEp4w@mail.gmail.com>
 <962617e5-9dec-6715-d550-4cf3ee414cf6@gmail.com> <CANXY5yKW=+e1CsoXCb0p_+6n8ZLz4eoOQz_5OkrrjYF6mpU9ZQ@mail.gmail.com>
 <CANXY5yLXpS+YYVeUPGok7R=4cm2AEAoM1zR_sd6YSKqCJPGLOg@mail.gmail.com>
In-Reply-To: <CANXY5yLXpS+YYVeUPGok7R=4cm2AEAoM1zR_sd6YSKqCJPGLOg@mail.gmail.com>
From:   mastertheknife <mastertheknife@gmail.com>
Date:   Tue, 1 Sep 2020 13:44:12 +0300
Message-ID: <CANXY5yJQ9Z6Brzt0KiStK-ZuSY_yzY3wM-B1w_iS1pfiYFKYgQ@mail.gmail.com>
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

A quick correction; The issue is not solved, it was a mistake in my
testing. The issue is still there.


Kfir

On Tue, Sep 1, 2020 at 1:40 PM mastertheknife <mastertheknife@gmail.com> wrote:
>
> Hello David.
>
> I was able to solve it while troubleshooting some fragmentation issue.
> The VTI interfaces had MTU of 1480 by default. I reduced to them to
> the real PMTUD (1366) and now its all working just fine.
> I am not sure how its related and why, but seems like it solved the issue.
>
> P.S: while reading the relevant code in the kernel, i think i spotted
> some mistake in net/ipv4/route.c, in function "update_or_create_fnhe".
> It looks like it loops over all the exceptions for the nexthop entry,
> but always overwriting the first (and only) entry, so effectively only
> 1 exception can exist per nexthop entry.
> Line 678:
> "if (fnhe) {"
> Should probably be:
> "if (fnhe && fnhe->fnhe_daddr == daddr) {"
>
>
> Thank you for your efforts,
> Kfir Itzhak
>
> On Fri, Aug 14, 2020 at 10:08 AM mastertheknife
> <mastertheknife@gmail.com> wrote:
> >
> > Hello David,
> >
> > It's on a production system, vmbr2 is a bridge with eth.X VLAN
> > interface inside for the connectivity on that 252.0/24 network. vmbr2
> > has address 192.168.252.5 in that case
> > 192.168.252.250 and 192.168.252.252 are CentOS8 LXCs on another host,
> > with libreswan inside for any/any IPSECs with VTi interfaces.
> >
> > Everything is kernel 5.4.44 LTS
> >
> > I wish i could fully reproduce all of it in a script, but i am not
> > sure how to create such hops that return this ICMP
> >
> > Thank you,
> > Kfir
> >
> >
> > On Wed, Aug 12, 2020 at 10:21 PM David Ahern <dsahern@gmail.com> wrote:
> > >
> > > On 8/12/20 6:37 AM, mastertheknife wrote:
> > > > Hello David,
> > > >
> > > > I tried and it seems i can reproduce it:
> > > >
> > > > # Create test NS
> > > > root@host:~# ip netns add testns
> > > > # Create veth pair, veth0 in host, veth1 in NS
> > > > root@host:~# ip link add veth0 type veth peer name veth1
> > > > root@host:~# ip link set veth1 netns testns
> > > > # Configure veth1 (NS)
> > > > root@host:~# ip netns exec testns ip addr add 192.168.252.209/24 dev veth1
> > > > root@host:~# ip netns exec testns ip link set dev veth1 up
> > > > root@host:~# ip netns exec testns ip route add default via 192.168.252.100
> > > > root@host:~# ip netns exec testns ip route add 192.168.249.0/24
> > > > nexthop via 192.168.252.250 nexthop via 192.168.252.252
> > > > # Configure veth0 (host)
> > > > root@host:~# brctl addif vmbr2 veth0
> > >
> > > vmbr2's config is not defined.
> > >
> > > ip li add vmbr2 type bridge
> > > ip li set veth0 master vmbr2
> > > ip link set veth0 up
> > >
> > > anything else? e.g., address for vmbr2? What holds 192.168.252.250 and
> > > 192.168.252.252
