Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC078C62
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbfG2NMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:12:47 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39010 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbfG2NMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 09:12:47 -0400
Received: by mail-ot1-f66.google.com with SMTP id r21so56436382otq.6
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 06:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Otyiv4i04nNGMwEl0wta5frm7MOqJnH0WdFK0RicSI=;
        b=Fb+4oGNdNf5Jh0Cnv+swQG6D5Mv9zY6Kvf2ziNu8Yc5Kz1nLGC3693vIzyhasvEY/X
         qcYyme13bzhHacipXfJO3b0v6oSLOUcdu4nNMZCZXhby08FmR21NpwPIKynE+sFg1z65
         /iV8V8Xum5AE9hRydD0lTl728H47an7YwLOQIeqhEX8w9lxfbTB6EWHuPJ3MHRhTdVlS
         HvUAuwoJSIbG+9TAKb0G1VoWbEIkghx31INldiFLRK5oi2TBpCCj8vacoqjrt6M5A7XS
         l0+7yYP1FjiVCv2ozE4ZrVbTha0KRnabHafi1sXeo9SPRdHRTfSPxty2isDm3szvnYRL
         qWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Otyiv4i04nNGMwEl0wta5frm7MOqJnH0WdFK0RicSI=;
        b=o9OCA4bOlw7d8bWpIs1U9Imj2WDpmGK3lG1jZ7LMEK9OoD1MAttchQ6da2glMKFXJ+
         jGTeShokzTB21yKCAxF4gHWJSAfsnNCZnzMhQjPi5jcwF8nLZ4FADPiFKF9WUXMuKESg
         NE4hql85zHPXx1fvj9eTDxPcC9NjAIAmz4bZlYJPkn3f7L0DDkjEofUJTy20Te5+F0eq
         0+CO46AQL3GSAFs+UPb1SUPX3DREZCAvNv4/Lcf0+Q6293tBFJoYgASRUY0BlZ3Ts8/S
         y/aXz4H76oS/DBhDwNtKrnRlIL6DDbdhNfXf2q1JPdEuRUQ6I+bhIoCfhAwWc+Rz4Vfb
         9zQA==
X-Gm-Message-State: APjAAAUd4Gu21tuDewfT6gCzuwZHR3p+ZEDCHjh+hY1g+FQIG9XglLvz
        c6DQVHc43SRa+5HdFi8iKaqANX/JArCu/xUK5K2uDb/QIiJ4Vg==
X-Google-Smtp-Source: APXvYqyYJpQpwha0guK/OPkatiOUcJoEJ8uolxt1Q/zGT+hUvhSvI3qdZD2PkB54mNBACKL/URdF0EHH4FmmywdseNI=
X-Received: by 2002:a9d:6742:: with SMTP id w2mr28137684otm.371.1564405965669;
 Mon, 29 Jul 2019 06:12:45 -0700 (PDT)
MIME-Version: 1.0
References: <1564194225-14342-1-git-send-email-johunt@akamai.com>
 <CANn89iJtw_XrU-F0-frE=P6egH99kF0W0kTzReK701LmigcJ4Q@mail.gmail.com>
 <a9ec9cfd-c381-c02e-7d67-e24373c693d6@akamai.com> <CANn89iLqeixzZkop8tqOQka_9ZiKurZL9Vj05bgU99M5Pbenqw@mail.gmail.com>
 <5a054ca5-4077-5e91-69d5-f1add8dc8bfa@akamai.com>
In-Reply-To: <5a054ca5-4077-5e91-69d5-f1add8dc8bfa@akamai.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 29 Jul 2019 09:12:27 -0400
Message-ID: <CADVnQykOFxm5ms-z0KwxrjFLcOQvixSPosXXn7+4MC3Qee9gKQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: add new tcp_mtu_probe_floor sysctl
To:     Josh Hunt <johunt@akamai.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 28, 2019 at 5:14 PM Josh Hunt <johunt@akamai.com> wrote:
>
> On 7/28/19 6:54 AM, Eric Dumazet wrote:
> > On Sun, Jul 28, 2019 at 1:21 AM Josh Hunt <johunt@akamai.com> wrote:
> >>
> >> On 7/27/19 12:05 AM, Eric Dumazet wrote:
> >>> On Sat, Jul 27, 2019 at 4:23 AM Josh Hunt <johunt@akamai.com> wrote:
> >>>>
> >>>> The current implementation of TCP MTU probing can considerably
> >>>> underestimate the MTU on lossy connections allowing the MSS to get down to
> >>>> 48. We have found that in almost all of these cases on our networks these
> >>>> paths can handle much larger MTUs meaning the connections are being
> >>>> artificially limited. Even though TCP MTU probing can raise the MSS back up
> >>>> we have seen this not to be the case causing connections to be "stuck" with
> >>>> an MSS of 48 when heavy loss is present.
> >>>>
> >>>> Prior to pushing out this change we could not keep TCP MTU probing enabled
> >>>> b/c of the above reasons. Now with a reasonble floor set we've had it
> >>>> enabled for the past 6 months.
> >>>
> >>> And what reasonable value have you used ???
> >>
> >> Reasonable for some may not be reasonable for others hence the new
> >> sysctl :) We're currently running with a fairly high value based off of
> >> the v6 min MTU minus headers and options, etc. We went conservative with
> >> our setting initially as it seemed a reasonable first step when
> >> re-enabling TCP MTU probing since with no configurable floor we saw a #
> >> of cases where connections were using severely reduced mss b/c of loss
> >> and not b/c of actual path restriction. I plan to reevaluate the setting
> >> at some point, but since the probing method is still the same it means
> >> the same clients who got stuck with mss of 48 before will land at
> >> whatever floor we set. Looking forward we are interested in trying to
> >> improve TCP MTU probing so it does not penalize clients like this.
> >>
> >> A suggestion for a more reasonable floor default would be 512, which is
> >> the same as the min_pmtu. Given both mechanisms are trying to achieve
> >> the same goal it seems like they should have a similar min/floor.
> >>
> >>>
> >>>>
> >>>> The new sysctl will still default to TCP_MIN_SND_MSS (48), but gives
> >>>> administrators the ability to control the floor of MSS probing.
> >>>>
> >>>> Signed-off-by: Josh Hunt <johunt@akamai.com>
> >>>> ---
> >>>>    Documentation/networking/ip-sysctl.txt | 6 ++++++
> >>>>    include/net/netns/ipv4.h               | 1 +
> >>>>    net/ipv4/sysctl_net_ipv4.c             | 9 +++++++++
> >>>>    net/ipv4/tcp_ipv4.c                    | 1 +
> >>>>    net/ipv4/tcp_timer.c                   | 2 +-
> >>>>    5 files changed, 18 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> >>>> index df33674799b5..49e95f438ed7 100644
> >>>> --- a/Documentation/networking/ip-sysctl.txt
> >>>> +++ b/Documentation/networking/ip-sysctl.txt
> >>>> @@ -256,6 +256,12 @@ tcp_base_mss - INTEGER
> >>>>           Path MTU discovery (MTU probing).  If MTU probing is enabled,
> >>>>           this is the initial MSS used by the connection.
> >>>>
> >>>> +tcp_mtu_probe_floor - INTEGER
> >>>> +       If MTU probing is enabled this caps the minimum MSS used for search_low
> >>>> +       for the connection.
> >>>> +
> >>>> +       Default : 48
> >>>> +
> >>>>    tcp_min_snd_mss - INTEGER
> >>>>           TCP SYN and SYNACK messages usually advertise an ADVMSS option,
> >>>>           as described in RFC 1122 and RFC 6691.
> >>>> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> >>>> index bc24a8ec1ce5..c0c0791b1912 100644
> >>>> --- a/include/net/netns/ipv4.h
> >>>> +++ b/include/net/netns/ipv4.h
> >>>> @@ -116,6 +116,7 @@ struct netns_ipv4 {
> >>>>           int sysctl_tcp_l3mdev_accept;
> >>>>    #endif
> >>>>           int sysctl_tcp_mtu_probing;
> >>>> +       int sysctl_tcp_mtu_probe_floor;
> >>>>           int sysctl_tcp_base_mss;
> >>>>           int sysctl_tcp_min_snd_mss;
> >>>>           int sysctl_tcp_probe_threshold;
> >>>> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> >>>> index 0b980e841927..59ded25acd04 100644
> >>>> --- a/net/ipv4/sysctl_net_ipv4.c
> >>>> +++ b/net/ipv4/sysctl_net_ipv4.c
> >>>> @@ -820,6 +820,15 @@ static struct ctl_table ipv4_net_table[] = {
> >>>>                   .extra2         = &tcp_min_snd_mss_max,
> >>>>           },
> >>>>           {
> >>>> +               .procname       = "tcp_mtu_probe_floor",
> >>>> +               .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_floor,
> >>>> +               .maxlen         = sizeof(int),
> >>>> +               .mode           = 0644,
> >>>> +               .proc_handler   = proc_dointvec_minmax,
> >>>> +               .extra1         = &tcp_min_snd_mss_min,
> >>>> +               .extra2         = &tcp_min_snd_mss_max,
> >>>> +       },
> >>>> +       {
> >>>>                   .procname       = "tcp_probe_threshold",
> >>>>                   .data           = &init_net.ipv4.sysctl_tcp_probe_threshold,
> >>>>                   .maxlen         = sizeof(int),
> >>>> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> >>>> index d57641cb3477..e0a372676329 100644
> >>>> --- a/net/ipv4/tcp_ipv4.c
> >>>> +++ b/net/ipv4/tcp_ipv4.c
> >>>> @@ -2637,6 +2637,7 @@ static int __net_init tcp_sk_init(struct net *net)
> >>>>           net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
> >>>>           net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
> >>>>           net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
> >>>> +       net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
> >>>>
> >>>>           net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
> >>>>           net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
> >>>> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> >>>> index c801cd37cc2a..dbd9d2d0ee63 100644
> >>>> --- a/net/ipv4/tcp_timer.c
> >>>> +++ b/net/ipv4/tcp_timer.c
> >>>> @@ -154,7 +154,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
> >>>>           } else {
> >>>>                   mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
> >>>>                   mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
> >>>> -               mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
> >>>> +               mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
> >>>>                   mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
> >>>>                   icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
> >>>>           }
> >>>
> >>>
> >>> Existing sysctl should be enough ?
> >>
> >> I don't think so. Changing tcp_min_snd_mss could impact clients that
> >> really want/need a small mss. When you added the new sysctl I tried to
> >> analyze the mss values we're seeing to understand what we could possibly
> >> raise it to. While not a huge amount, we see more clients than I
> >> expected announcing mss values in the 180-512 range. Given that I would
> >> not feel comfortable setting tcp_min_snd_mss to say 512 as I suggested
> >> above.
> >
> > If these clients need mss values in 180-512 ranges, how MTU probing
> > would work for them,
> > if you set a floor to 512 ?
>
> First, we already seem to be fine with ignoring these paths with ICMP
> based PMTU discovery b/c of our min_pmtu default of 512 and that is
> configurable. Second by adding this sysctl we're giving administrators
> the choice to decide if they'd like to attempt to support these very
> very small # of paths which may be below 512 (MSS <= 512 does not mean
> MTU <= 512) or cover themselves by being able to raise the floor to not
> penalize clients who may be on very lossy networks.
>
> >
> > Are we sure the intent of tcp_base_mss was not to act as a floor ?
>
> My understanding is that tcp_base_mss is meant to be the initial value
> of search_low (as per Docs). Then in RFC 4821 [1] Sections 7.2, shows
> search_low should be configurable, and 7.7 we see that in response to
> successive black hole detection search_low should be halved. So I don't
> think it was meant to be a floor, but just the initial search_low param.

That matches my reading of the RFC and code as well. But in that case
IMHO an additional commit should fix this comment to reflect the fact
thatTCP_BASE_MSS is the initial value, rather than a floor:

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 42728239cdbe..05575ac70333 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -75,7 +75,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 /* Minimal accepted MSS. It is (60+60+8) - (20+20). */
 #define TCP_MIN_MSS            88U

-/* The least MTU to use for probing */
+/* The initial MTU to use for probing */
 #define TCP_BASE_MSS           1024

 /* probing interval, default to 10 minutes as per RFC4821 */

neal
