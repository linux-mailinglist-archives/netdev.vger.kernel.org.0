Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B4621D3F6
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 12:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgGMKve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 06:51:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36634 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728883AbgGMKvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 06:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594637491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tIrmA9ODmGUc0gxUf6VLfX2wjwXbFJUVZ2WEdL0TDZ8=;
        b=bL6GcjBZajCQiTLi2amQ4IQMdDSvo4+UAPg7iWru8K92hxwjeOPxbScQo7GvzSWGEuAwKy
        4UGsbhVixGssONUPMnXay6O4iePmC/Rtpf6KFNzHmQ5pW7M9LG0PR9YiK6ityqVVOMwGhN
        F3CGvGov/jBuGArd2I5/gZf0oayf30k=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-_ubbpNtUOoa_sNDlDXMp7w-1; Mon, 13 Jul 2020 06:51:27 -0400
X-MC-Unique: _ubbpNtUOoa_sNDlDXMp7w-1
Received: by mail-ej1-f71.google.com with SMTP id yw17so18736719ejb.12
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 03:51:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tIrmA9ODmGUc0gxUf6VLfX2wjwXbFJUVZ2WEdL0TDZ8=;
        b=Ar1TbsvSKCnQcE4CeKb3Kuy2ycM7TOyXpjY3IrRI0Im0m7ooe+1+qjla/Wdv0rQ1Gt
         UXZVHEoJXURpMOu4TCyYeNqfzw3YCzM0e9SiI2que+/gONZ1I6WgY10cWmQtWoWvN6Y5
         ykJrt3/8r3R1aKApdebEZY7O154U0U3aa96BoWQTKj2JwQ1XUz+cp0Fk89JZZnGtBdPI
         zybVltlNxj7SJ4lHYiN1vSGJsntL5OUWJ57BVUYBMwqQVKzxVP3LvNkjOnGr6nWzGZqU
         nsGu2u46j+O8izm5sWpyjw9aOgcQnzKit0G1Phq5X27N30iL5m29MnfVaxTHSMusM6QX
         Q/pQ==
X-Gm-Message-State: AOAM532NMGdP34i0ZvG5QexDTSPGg2zqiB1Cbt73to0Nk2J7lGOQL5Pn
        ifSsr/Kf8vtoRT1ap14WWtQt41pbboL0/Jip9sA5jO2TsRuV50q5whls9feBwfn7dWquvMWZl69
        1dR21RUN//GNfnUYPblD7yFmtOiiNTbGL
X-Received: by 2002:a05:6402:1d18:: with SMTP id dg24mr91835448edb.33.1594637486630;
        Mon, 13 Jul 2020 03:51:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznWIbrj+X5EmCOY0ydttxH1p6w3mWL+E8vgsJmtlpyxQ+tRWW2F3vp+FCSwMuTuOBQFwB3xZns12v0UiFMCmM=
X-Received: by 2002:a05:6402:1d18:: with SMTP id dg24mr91835426edb.33.1594637486232;
 Mon, 13 Jul 2020 03:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200712200705.9796-1-fw@strlen.de> <20200712200705.9796-2-fw@strlen.de>
 <20200713003813.01f2d5d3@elisabeth> <20200713080413.GL32005@breakpoint.cc> <20200713120158.665a6677@elisabeth>
In-Reply-To: <20200713120158.665a6677@elisabeth>
From:   Numan Siddique <nusiddiq@redhat.com>
Date:   Mon, 13 Jul 2020 16:21:15 +0530
Message-ID: <CAH=CPzopMgQ=RU2jCSqDxM3ghtTMGZLBiPoh+3k4wXnGEeC+fw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev <netdev@vger.kernel.org>,
        Aaron Conole <aconole@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 3:34 PM Stefano Brivio <sbrivio@redhat.com> wrote:
>
> On Mon, 13 Jul 2020 10:04:13 +0200
> Florian Westphal <fw@strlen.de> wrote:
>
> > Stefano Brivio <sbrivio@redhat.com> wrote:
> > > Hi,
> > >
> > > On Sun, 12 Jul 2020 22:07:03 +0200
> > > Florian Westphal <fw@strlen.de> wrote:
> > >
> > > > vxlan and geneve take the to-be-transmitted skb, prepend the
> > > > encapsulation header and send the result.
> > > >
> > > > Neither vxlan nor geneve can do anything about a lowered path mtu
> > > > except notifying the peer/upper dst entry.
> > >
> > > It could, and I think it should, update its MTU, though. I didn't
> > > include this in the original implementation of PMTU discovery for UDP
> > > tunnels as it worked just fine for locally generated and routed
> > > traffic, but here we go.
> >
> > I don't think its a good idea to muck with network config in response
> > to untrusted entity.
>
> I agree that this (changing MTU on VXLAN) looks like a further step,
> but the practical effect is zero: we can't send those packets already
> today.
>
> PMTU discovery has security impacts, and they are mentioned in the
> RFCs. Also here, we wouldn't increase the MTU as a result, and if the
> entity is considered untrusted, considerations from RFC 8201 and RFC
> 4890 cover that.
>
> In practice, we might have broken networks, but at a practical level, I
> guess it's enough to not make the situation any worse.
>
> > > As PMTU discovery happens, we have a route exception on the lower
> > > layer for the given path, and we know that VXLAN will use that path,
> > > so we also know there's no point in having a higher MTU on the VXLAN
> > > device, it's really the maximum packet size we can use.
> >
> > No, in the setup that prompted this series the route exception is wrong.
> > The current "fix" is a shell script that flushes the exception as soon
> > as its added to keep the tunnel working...
>
> Oh, oops.
>
> Well, as I mentioned, if this is breaking setups and this series is the
> only way to fix things, I have nothing against it, we can still work on
> a more comprehensive solution (including the bridge) once we have it.
>
> > > > Some setups, however, will use vxlan as a bridge port (or openvs vport).
> > >
> > > And, on top of that, I think what we're missing on the bridge is to
> > > update the MTU when a port lowers its MTU. The MTU is changed only as
> > > interfaces are added, which feels like a bug. We could use the lower
> > > layer notifier to fix this.
> >
> > I will defer to someone who knows bridges better but I think that
> > in bridge case we 100% depend on a human to set everything.
>
> Not entirely, MTU is auto-adjusted when interfaces are added (unless
> the user set it explicitly), however:
>
> > bridge might be forwarding frames of non-ip protocol and I worry that
> > this is a self-induced DoS when we start to alter configuration behind
> > sysadmins back.
>
> ...yes, I agree that the matter with the bridge is different. And we
> don't know if that fixes anything else than the selftest I showed, so
> let's forget about the bridge for a moment.
>
> > > I tried to represent the issue you're hitting with a new test case in
> > > the pmtu.sh selftest, also included in the diff. Would that work for
> > > Open vSwitch?
> >
> > No idea, I don't understand how it can work at all, we can't 'chop
> > up'/mangle l2 frame in arbitrary fashion to somehow make them pass to
> > the output port.  We also can't influence MTU config of the links peer.
>
> Sorry I didn't expand right away.
>
> In the test case I showed, it works because at that point sending
> packets to the bridge will result in an error, and the (local) sender
> fragments. Let's set this aside together with the bridge affair, though.
>
> Back to VXLAN and OVS: OVS implements a "check_pkt_len" action, cf.
> commit 4d5ec89fc8d1 ("net: openvswitch: Add a new action
> check_pkt_len"), that should be used when packets exceed link MTUs:
>
>   With the help of this action, OVN will check the packet length
>   and if it is greater than the MTU size, it will generate an
>   ICMP packet (type 3, code 4) and includes the next hop mtu in it
>   so that the sender can fragment the packets.
>
> and my understanding is that this can only work if we reflect the
> effective MTU on the device itself (including VXLAN).
>

check_pkt_len is OVS datapath action and the corresponding OVS action
is  check_pkt_larger.

Logically It is expected to use this way in the OVS flows- >
    reg0[0] = check_pkt_larger(1500);
    if reg0[0[ == 1; then take some action.

In the case of OVN, if the register reg0[0] bit is set, then we
generate ICMP error packet (type 3, code 4).

I don't know the requirements or the issue this patch is trying to
address. But I think for OVS, there has to be
a controller (like OVN) which makes use of the check_pkt_larger action
and takes necessary action by adding
appropriate OF flows based on the result of check_pkt_larger.

Thanks
Numan

>
> Side note: I'm not fond of the idea behind that OVS action because I
> think it competes with the kernel (and with ICMP itself, or PLPMTUD if
> ICMP is not an option) to do PMTU discovery.
>
> However, if that already works for OVS (I really don't know. Aaron,
> Numan?), perhaps you could simply consider going with that solution...
>
> --
> Stefano
>

