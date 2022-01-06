Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1911B48677E
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241083AbiAFQQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241052AbiAFQQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 11:16:36 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9074C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 08:16:35 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id y17so2737537qtx.9
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 08:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=00F7Va0+axkg851USF6r00e3fal8pJY/Z4pOMOonELk=;
        b=mqa2RrgZikoG7GkeWYQyZyIHKllZfT8J6jeszPGIVsp0Mr2IJr7dXUdhlfLUQiuDy+
         uT+2UUO03kjoDbp+vEdsGpLOJl34xZtrgzs4AXmSDiTxikPJ2P9AmVB0poZ2hPhLACN1
         7FNM3LzwJ9+rwhHT4dcxD0/O/7JQ85YuyhDsA30pdDvtROKRJ9f60+1l9Vhe41gTVGlY
         jZSRfIhex/nyFnyCl9RVlL6kHwlw6IRU3KoY9Yo2W+igF6s2qmIVVPyys88PNhm320OB
         buUNDkbDE9IbwyRwVuq19JYyt3OhmJXXte/K+KghqLm4U4N5nXMW28pzM1PFP2p0RuTo
         it5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=00F7Va0+axkg851USF6r00e3fal8pJY/Z4pOMOonELk=;
        b=rp3tolVnZlgASrQWWIIvhSRj5mkVZeOyYPBaujSccyl/jkv0/dDV5ToLOrviCjHqb9
         5ogW2+xLR05f7Z8/pZ5MAAqxF8Ij83j+w7GFRS29puQT6mGhdbG6Numl/MfvAOiCWu2v
         Rc85X853C6K5S86hK2gxTptm8JdWH7faKQbijGMdRxLTs7m5mxGRrEGNmMGXm+e88aVo
         GiA0MgifR8Hil62r4FFBC9Sxi2X59G210zJM8aQplgiMSg343SL28CyYtvtSJSCOUSfB
         gMJ6ToY5Ef2P6nelQOUqzc7mSPnZT8Nr5/CLZ9GzfGD58K2JNrGL7jb+x+mBOGnAPpP0
         IDzA==
X-Gm-Message-State: AOAM532qkbPS+xECKpEF28vvSn+eliHnl9B3K4YIPSoIiky7RMjrKrbG
        zcOi+Y5RFm/XTSvX27dSFSJzbbfmm7S1lS7J5m8rcSIlhPc=
X-Google-Smtp-Source: ABdhPJwYEzAOSEGfWN/Z7On+0efMeTTJM5o5J0RstKYGVoVbMSg1ufrw41Lvh/LgZR7XBxaN6PuoRzy83IakntqOj7I=
X-Received: by 2002:a05:622a:93:: with SMTP id o19mr53690535qtw.602.1641485794586;
 Thu, 06 Jan 2022 08:16:34 -0800 (PST)
MIME-Version: 1.0
References: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
 <CADVnQyn97m5ybVZ3FdWAw85gOMLAvPSHiR8_NC_nGFyBdRySqQ@mail.gmail.com> <b3e53863-e80e-704f-81a2-905f80f3171d@candelatech.com>
In-Reply-To: <b3e53863-e80e-704f-81a2-905f80f3171d@candelatech.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 6 Jan 2022 11:16:18 -0500
Message-ID: <CADVnQymJaF3HoxoWhTb=D2wuVTpe_fp45tL8g7kaA2jgDe+xcQ@mail.gmail.com>
Subject: Re: Debugging stuck tcp connection across localhost
To:     Ben Greear <greearb@candelatech.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 10:39 AM Ben Greear <greearb@candelatech.com> wrote:
>
> On 1/6/22 7:20 AM, Neal Cardwell wrote:
> > On Thu, Jan 6, 2022 at 10:06 AM Ben Greear <greearb@candelatech.com> wrote:
> >>
> >> Hello,
> >>
> >> I'm working on a strange problem, and could use some help if anyone has ideas.
> >>
> >> On a heavily loaded system (500+ wifi station devices, VRF device per 'real' netdev,
> >> traffic generation on the netdevs, etc), I see cases where two processes trying
> >> to communicate across localhost with TCP seem to get a stuck network
> >> connection:
> >>
> >> [greearb@bendt7 ben_debug]$ grep 4004 netstat.txt |grep 127.0.0.1
> >> tcp        0 7988926 127.0.0.1:4004          127.0.0.1:23184         ESTABLISHED
> >> tcp        0  59805 127.0.0.1:23184         127.0.0.1:4004          ESTABLISHED
> >>
> >> Both processes in question continue to execute, and as far as I can tell, they are properly
> >> attempting to read/write the socket, but they are reading/writing 0 bytes (these sockets
> >> are non blocking).  If one was stuck not reading, I would expect netstat
> >> to show bytes in the rcv buffer, but it is zero as you can see above.
> >>
> >> Kernel is 5.15.7+ local hacks.  I can only reproduce this in a big messy complicated
> >> test case, with my local ath10k-ct and other patches that enable virtual wifi stations,
> >> but my code can grab logs at time it sees the problem.  Is there anything
> >> more I can do to figure out why the TCP connection appears to be stuck?
> >
> > It could be very useful to get more information about the state of all
> > the stuck connections (sender and receiver side) with something like:
> >
> >    ss -tinmo 'sport = :4004 or sport = :4004'
> >
> > I would recommend downloading and building a recent version of the
> > 'ss' tool to maximize the information. Here is a recipe for doing
> > that:
> >
> >   https://github.com/google/bbr/blob/master/Documentation/bbr-faq.md#how-can-i-monitor-linux-tcp-bbr-connections
>
> Thanks for the suggestions!
>
> Here is output from a working system of same OS, the hand-compiled ss seems to give similar output,
> do you think it is still worth building ss manually on my system that shows the bugs?
>
> [root@ct523c-3b29 iproute2]# ss -tinmo 'sport = :4004 or sport = :4004'
> State             Recv-Q             Send-Q                         Local Address:Port                         Peer Address:Port
> ESTAB             0                  0                                  127.0.0.1:4004                            127.0.0.1:40902
>          skmem:(r0,rb87380,t0,tb2626560,f12288,w0,o0,bl0,d0) ts sack reno wscale:4,10 rto:201 rtt:0.009/0.004 ato:40 mss:65483 pmtu:65535 rcvmss:1196 advmss:65483
> cwnd:10 bytes_sent:654589126 bytes_acked:654589126 bytes_received:1687846 segs_out:61416 segs_in:72611 data_segs_out:61406 data_segs_in:11890 send
> 582071111111bps lastsnd:163 lastrcv:62910122 lastack:163 pacing_rate 1088548571424bps delivery_rate 261932000000bps delivered:61407 app_limited busy:42494ms
> rcv_rtt:1 rcv_space:43690 rcv_ssthresh:43690 minrtt:0.002
> [root@ct523c-3b29 iproute2]# ./misc/ss -tinmo 'sport = :4004 or sport = :4004'
> State          Recv-Q          Send-Q                    Local Address:Port                     Peer Address:Port           Process
> ESTAB          0               0                             127.0.0.1:4004                        127.0.0.1:40902
>          skmem:(r0,rb87380,t0,tb2626560,f0,w0,o0,bl0,d0) ts sack reno wscale:4,10 rto:201 rtt:0.009/0.003 ato:40 mss:65483 pmtu:65535 rcvmss:1196 advmss:65483 cwnd:10
> bytes_sent:654597556 bytes_acked:654597556 bytes_received:1687846 segs_out:61418 segs_in:72613 data_segs_out:61408 data_segs_in:11890 send 582071111111bps
> lastsnd:219 lastrcv:62916882 lastack:218 pacing_rate 1088548571424bps delivery_rate 261932000000bps delivered:61409 app_limited busy:42495ms rcv_rtt:1
> rcv_space:43690 rcv_ssthresh:43690 minrtt:0.002

Great. Yes, it looks like your system has a new enough ss.

> >
> > It could also be very useful to collect and share packet traces, as
> > long as taking traces does not consume an infeasible amount of space,
> > or perturb timing in a way that makes the buggy behavior disappear.
> > For example, as root:
> >
> >    tcpdump -w /tmp/trace.pcap -s 120 -c 100000000 -i any port 4004 &
>
> I guess this could be  -i lo ?

Yes, if the problem is always on the lo device then that should be fine.

> I sometimes see what is likely a similar problem to an external process, but easiest thing to
> reproduce is the localhost stuck connection, and my assumption is that it would be easiest
> to debug.
>
> I should have enough space for captures, I'll give that a try.

Great, thanks!

neal

> Thanks,
> Ben
>
> >
> > If space is an issue, you might start taking traces once things get
> > stuck to see what the retry behavior, if any, looks like.
> >
> > thanks,
> > neal
> >
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
