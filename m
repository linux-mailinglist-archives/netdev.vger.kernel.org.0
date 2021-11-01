Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F46441C9B
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhKAOaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhKAOal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 10:30:41 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A291C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 07:28:08 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id y17so18621440ilb.9
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 07:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=edUuJZFTNuaLy0fr6ZPjhwkCOd8kPZE6F724He9EJJQ=;
        b=LsJSQciuZuF6pt86wp2GkIZEaAuxN7jY+x1oTbEsOu+nWA+wuxditwYV/aletelk5Y
         QyaPmmni9DVHPVmx0vHabIfQjevm07EyptoWxrLD339vxa9k42971nNTzSF9R58AuqWp
         mI8W6tcg30/isYotTSqVdrWXPMb+LElmj8AdaeXNZLBeuUdDUAMShQn7J7xvxgUTRrkm
         f+VRXuQVQWNBisBP2TU1X9nIl9/A/64nwMflwB84UQYvDHi/4txNSqAN3vN+t7RAmF/0
         f3wRwdHCBHlLL4gCEcXKRBKx+sk45X7bGkS7+TFabsfiq3joEkr+yyZrTAfUHyKxdtBu
         Hrnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=edUuJZFTNuaLy0fr6ZPjhwkCOd8kPZE6F724He9EJJQ=;
        b=uao57YQBs1jc8QL+u26l74ZHctVSSPTOqTLuHEnnmOF4zbEj6ylzQmZ0mjakxwvqKd
         i+YNxIJ/vwi8x0c92ycnwNUtMyXeO5jLj1aYKUowrEgUdUDRvaaoIgdAU1Iz/AHBul7U
         6E0/UlhyRcDlXnH1TB5G/eEADXFriWb9eennTxLBLuxdeWowp3Xc1yRr40xiZA6BixMb
         /UgcluyFS8QuXW+8flSXyPAd6hlCagcLf1GydbvlKx6X0AnsxvqThWWhH+3WxpXOFPE6
         UsGarr7wYK1StmeyZYA25XMMNF6CtXHkyjpO9RzuE+MLVZRpJTiW7/itYyjabVCE3DaR
         6CjA==
X-Gm-Message-State: AOAM532Z5BOmp/eZ4pzY6xdujpGwsqrYxlOQrwEzo0ueEYFlPdb2fpHZ
        Cu68x6JCI7K0pGC1ieaHuKdimqBT3LELvqGCzP8=
X-Google-Smtp-Source: ABdhPJyNfOfJ5eP4HThicpJ9lmr44XDeFdPCp8GjweUJ6HJoMMxboiHipW1YP5xkXyxgsMNUiZjKjVxBUN5U9ZVhFfc=
X-Received: by 2002:a05:6e02:2149:: with SMTP id d9mr7590790ilv.221.1635776887044;
 Mon, 01 Nov 2021 07:28:07 -0700 (PDT)
MIME-Version: 1.0
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com> <CAA93jw4VphJ17yoV1S6aDRg2=W7hg=02Yr3XcX_aEBTzAt0ezw@mail.gmail.com>
 <4247ecd8-e4ca-0c35-5c0f-1124a043080f@mojatatu.com>
In-Reply-To: <4247ecd8-e4ca-0c35-5c0f-1124a043080f@mojatatu.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 1 Nov 2021 07:27:50 -0700
Message-ID: <CAA93jw5Ou+d7j6jeFz6oJqcuh=WM8URPoY-v-9U4evGB_V=mvg@mail.gmail.com>
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Oz Shlomo <ozsh@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 7:14 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2021-10-31 08:03, Dave Taht wrote:
> [..]
>
> >
> > Just as an on-going grump: It has been my hope that policing as a
> > technique would have died a horrible death by now. Seeing it come back
> > as an "easy to offload" operation here - fresh from the 1990s! does
> > not mean it's a good idea, and I'd rather like it if we were finding
> > ways to
> > offload newer things that work better, such as modern aqm, fair
> > queuing, and shaping technologies that are in pie, fq_codel, and cake.
> >
> > policing leads to bursty loss, especially at higher rates, BBR has a
> > specific mode designed to defeat it, and I ripped it out of
> > wondershaper
> > long ago for very good reasons:
> > https://www.bufferbloat.net/projects/bloat/wiki/Wondershaper_Must_Die/
> >
> > I did a long time ago start working on a better policing idea based on
> > some good aqm ideas like AFD, but dropped it figuring that policing
> > was going to vanish
> > from the planet. It's baaaaaack.
>
> A lot of enthusiasm for fq_codel in that link ;->

Wrote that in 2013. It's not every day you solve tcp global synchronization=
,
achieve a queue depth of 5ms no matter the rate, develop something that
has zero latency for sparse packets, only shoots at the fat flows, drops fr=
om
head so there's always an immediate signal of congestion from the packet
just behind, makes opus's PLC and simpler forms of FEC "just work", and
requires near zero configuration.

The plots at the end made a very convincing case for abandoning policing.

> Root cause for burstiness is typically due to large transient queues
> (which are sometimes not under your admin control) and of course if
> you use a policer and dont have your double leaky buckets set properly
> to compensate for both short and long term rates you will have bursts
> of drops with the policer.

I would really like to see a good configuration guide for policing at
multiple real-world bandwidths and at real-world workloads.

> It would be the same with shaper as well
> if the packet burst shows up when the queue is full.

Queues are shock absorbers as Van always says. We do drop packets
still, on the rx ring. The default queue depth of codel is 32MB. It takes
a really really really large burst to overwhelm that.

I wonder where all the userspace wireguard vpns are dropping packets nowday=
s.

> Intuitively it would feel, for non-work conserving approaches,
> delaying a packet (as in shaping) is better than dropping (as in

It's shaping + flow queueing that's the win, if you are going to
queue. It gets all
the flows statistically multiplexed and in flow balance orders of
magnitude faster
than a policer could. (flow queuing is different from classic fair queuing)

The tiny flows pass through untouched at zero delay also.

At the time, I was considering applying a codel-like technique to policing =
-
I'd called it "bobbie", where once you exceed the rate, a virtual clock mov=
es
forward as to how long you would have delayed packet delivery if you were
queueing and then starts shooting at packets once your burst tolerance is
exceeded until

But inbound fq+shaping did wonders faster, and selfishly I didn't feel
like abandoning
floating point to work with in the kernel.

That said, it's taken breaking the qdisc lock and xpf to make inbound
shaping scale
decently (see: https://github.com/rchac/LibreQoS#how-do-cake-and-fq_codel-w=
ork )

> policing) - but i have not a study which scientifically proves it.
> Any pointers in that regard?

Neither do I. Matt Mathis has ranted about it, and certainly the workaround=
s
in BBRv1 to defeat others desperate attempts to control their bandwidth wit=
h
a policer is obvious from their data.

If there really is a resurgence of interest in policing, a good paper
would compare
a classic 3 color policer to bobbie, and to shaping vs a vs BBR and cubic.

I'm low on students at the moment...

> TCP would recover either way (either detecting sequence gaps or RTO).

Yes, it does. But policing is often devastating to voip and videoconferenci=
ng
traffic.

> In Linux kernel level i am not sure i see much difference in either
> since we actually feedback an indicator to TCP to indicate a local
> drop (as opposed to guessing when it is dropped in the network)
> and the TCP code is smart enough to utilize that knowledge.

There is an extremely long and difficult conversation I'd had over
the differences between sch_fq and fq_codel and the differences
between a server and a router, for real world applications over here:

https://github.com/systemd/systemd/issues/9725#issuecomment-413369212

> For hardware offload there is no such feedback for either of those
> two approaches (so no difference with drop in the blackhole).

Yes, now you've built a *router* and lost the local control loop.
TSQ, sch_fq's pacing, and other host optimizations no longer work.

I encourage more folk to regularly take packet
captures of the end results of offloads vs a vs network latency.

Look! MORE BANDWIDTH for a single flow! Wait! There's
600ms of latency and new flows can't even get started!

>
> As to "policer must die" - not possible i am afraid;-> I mean there
> has to be strong evidence that it is a bad idea and besides that
> _a lot of hardware_ supports it;-> Ergo, we have to support it as well.

I agree that supporting hardware features is good. I merely wish that
certain other software features were making it into modern hardware.

I'm encouraged by this work in p4, at least.

https://arxiv.org/pdf/2010.04528.pdf

> Note: RED for example has been proven almost impossible to configure
> properly but we still support it and there's a good set of hardware
> offload support for it. For RED - and i should say the policer as well -
> if you configure properly, _it works_.

I have no idea how often RED is used nowadays. The *only* requests
for offloading it Ive heard is for configuring it as a brick wall ecn marki=
ng
tool, which does indeed work for dctcp.

The hope was with pie, being similar in construction, would end up
implemented in hardware, however it's so far turned out that codel
was easier to implement in hw and more effective.
>
>
> BTW, Some mellanox NICs offload HTB. See for example:
> https://legacy.netdevconf.info/0x14/session.html?talk-hierarchical-QoS-ha=
rdware-offload

Yes. Too bad they then attach it to fifos. I'd so love to help a
hardware company
willing to do the work to put modern algorithms in hw...

> cheers,
> jamal

I note that although I've enjoyed ranting, I don't actually have any
objections to this
particular patch.
--
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
