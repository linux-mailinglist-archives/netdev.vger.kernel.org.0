Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D7048BF29
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 08:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237490AbiALHmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 02:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiALHmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 02:42:07 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA94C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 23:42:07 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id g14so3930455ybs.8
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 23:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uMvYHIjXVL0qDiaqUGp12XBYVxw0DmgdCFT26HWxCg4=;
        b=U5Qhld6eKjQR96yLsfgsJrdq13xPsiGvuSFkIo97ypOwqRtQ+WatDOnpS6Y+Dx0wNS
         tf6xs70SujpaiyHH96UTKTwCmaGzusY6Yu9N38qpoU/aLAqXi0rci8Mn1tO4HYSmdokc
         Mcbh+oIhy9DzjSLqO3t9TkpMRbdg66REA0diA36zBied48UlDFLBVmidWqWRpNmKUjLK
         2iyAHtc6OnXVRomXY32EqpP+21UO522cyZgi+5EWM1lGN34rkrhHtbxDumykP4zi+ohx
         /SaYEntxPnU6nvrCpGeK+Xi/F9AZuZvMO9FW/yssllzW3PjtknksIxkUO6cypa4HP4td
         5Y5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uMvYHIjXVL0qDiaqUGp12XBYVxw0DmgdCFT26HWxCg4=;
        b=0Nz4dPKaAPkSl2g56MT+IH6sTU3tWIhYc7jJlT7OZnlenvEld1xHQecJCwnuIr8IC+
         M88AFN1M8EAWSAxqQouVjiF7Oz2pZ6uIwkJfw9ZOaVc0hm6e+6V5OcfmSKFk0EqHgS2B
         ZnSTQeIWFcr2/QfW11Bgy6xR2O9GCZWGJL/0CVvk3MmrbQ40AOm4M6v4tCaWUxDuz3z6
         Dv7400L1g/dKeBlQnFSb3cijmjtHyQp+lSL5hNbHiMpu9NxUCIsXs2hqXc3oLtnmqLPM
         yq3FHJFxrbba4VnJWKzF5Dkg9AmyJlODj6mzjp+/eOYd1GMO1axQ5KpwiRaoNb60X21Y
         Y9Bg==
X-Gm-Message-State: AOAM5314wUjtHQXncMhjMotmQG81mDN+7++pwKhNwjG7FhXONJ9+sJEm
        CbDn6qJfiHYGd0MSw3I2gtTteH+OIG7zA8kBeyUnbA==
X-Google-Smtp-Source: ABdhPJzPnO9WL4X2NNOW0PmPAK6Ifh18BGPNHP+QdVdvE9rYqlRi0e2I/JkE4kefXn7NcC8UgVGmZV0bhl/dXanASX8=
X-Received: by 2002:a05:6902:100a:: with SMTP id w10mr11166035ybt.156.1641973325784;
 Tue, 11 Jan 2022 23:42:05 -0800 (PST)
MIME-Version: 1.0
References: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
 <CADVnQyn97m5ybVZ3FdWAw85gOMLAvPSHiR8_NC_nGFyBdRySqQ@mail.gmail.com>
 <b3e53863-e80e-704f-81a2-905f80f3171d@candelatech.com> <CADVnQymJaF3HoxoWhTb=D2wuVTpe_fp45tL8g7kaA2jgDe+xcQ@mail.gmail.com>
 <a6ec30f5-9978-f55f-f34f-34485a09db97@candelatech.com> <CADVnQym9LTupiVCTWh95qLQWYTkiFAEESv9Htzrgij8UVqSHBQ@mail.gmail.com>
 <b60aab98-a95f-d392-4391-c0d5e2afb2cd@candelatech.com> <9330e1c7-f7a2-0f1e-0ede-c9e5353060e3@candelatech.com>
 <0b2b06a8-4c59-2a00-1fbc-b4734a93ad95@gmail.com> <c84d0877-43a1-9a52-0046-e26b614a5aa6@candelatech.com>
In-Reply-To: <c84d0877-43a1-9a52-0046-e26b614a5aa6@candelatech.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 Jan 2022 23:41:54 -0800
Message-ID: <CANn89iL=690zdpCS7g1vpZdZCHsj0O1MrOjGkcg0GPLVhjr4RQ@mail.gmail.com>
Subject: Re: Debugging stuck tcp connection across localhost
To:     Ben Greear <greearb@candelatech.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 1:35 PM Ben Greear <greearb@candelatech.com> wrote:
>
> On 1/11/22 2:46 AM, Eric Dumazet wrote:
> >
> > On 1/10/22 10:10, Ben Greear wrote:
> >> On 1/6/22 2:26 PM, Ben Greear wrote:
> >>> On 1/6/22 12:04 PM, Neal Cardwell wrote:
> >>>> On Thu, Jan 6, 2022 at 2:05 PM Ben Greear <greearb@candelatech.com> wrote:
> >>>>>
> >>>>> On 1/6/22 8:16 AM, Neal Cardwell wrote:
> >>>>>> On Thu, Jan 6, 2022 at 10:39 AM Ben Greear <greearb@candelatech.com> wrote:
> >>>>>>>
> >>>>>>> On 1/6/22 7:20 AM, Neal Cardwell wrote:
> >>>>>>>> On Thu, Jan 6, 2022 at 10:06 AM Ben Greear <greearb@candelatech.com> wrote:
> >>>>>>>>>
> >>>>>>>>> Hello,
> >>>>>>>>>
> >>>>>>>>> I'm working on a strange problem, and could use some help if anyone has ideas.
> >>>>>>>>>
> >>>>>>>>> On a heavily loaded system (500+ wifi station devices, VRF device per 'real' netdev,
> >>>>>>>>> traffic generation on the netdevs, etc), I see cases where two processes trying
> >>>>>>>>> to communicate across localhost with TCP seem to get a stuck network
> >>>>>>>>> connection:
> >>>>>>>>>
> >>>>>>>>> [greearb@bendt7 ben_debug]$ grep 4004 netstat.txt |grep 127.0.0.1
> >>>>>>>>> tcp        0 7988926 127.0.0.1:4004 127.0.0.1:23184 ESTABLISHED
> >>>>>>>>> tcp        0  59805 127.0.0.1:23184 127.0.0.1:4004 ESTABLISHED
> >>>>>>>>>
> >>>>>>>>> Both processes in question continue to execute, and as far as I can tell, they are properly
> >>>>>>>>> attempting to read/write the socket, but they are reading/writing 0 bytes (these sockets
> >>>>>>>>> are non blocking).  If one was stuck not reading, I would expect netstat
> >>>>>>>>> to show bytes in the rcv buffer, but it is zero as you can see above.
> >>>>>>>>>
> >>>>>>>>> Kernel is 5.15.7+ local hacks.  I can only reproduce this in a big messy complicated
> >>>>>>>>> test case, with my local ath10k-ct and other patches that enable virtual wifi stations,
> >>>>>>>>> but my code can grab logs at time it sees the problem.  Is there anything
> >>>>>>>>> more I can do to figure out why the TCP connection appears to be stuck?
> >>>>>>>>
> >>>>>>>> It could be very useful to get more information about the state of all
> >>>>>>>> the stuck connections (sender and receiver side) with something like:
> >>>>>>>>
> >>>>>>>>      ss -tinmo 'sport = :4004 or sport = :4004'
> >>>>>>>>
> >>>>>>>> I would recommend downloading and building a recent version of the
> >>>>>>>> 'ss' tool to maximize the information. Here is a recipe for doing
> >>>>>>>> that:
> >>>>>>>>
> >>>>>>>> https://github.com/google/bbr/blob/master/Documentation/bbr-faq.md#how-can-i-monitor-linux-tcp-bbr-connections
> >>>>>
> >>>>> Hello Neal,
> >>>>>
> >>>>> Here is the ss output from when the problem was happening. I think you can ignore the non-127.0.0.1
> >>>>> connections, but I left them in just in case it is somehow helpful.
> >>>>>
> >>>>> In addition, the pcap capture file is uploaded here:
> >>>>>
> >>>>> http://www.candelatech.com/downloads/trace-lo-4004.pcap
> >>>>>
> >>>>> The problem was happening in this time frame:
> >>>>>
> >>>>> [root@ct523c-0bdd ~]# date
> >>>>> Thu 06 Jan 2022 10:14:49 AM PST
> >>>>> [root@ct523c-0bdd ~]# ss -tinmo 'dport = :4004 or sport = :4004'
> >>>>> State       Recv-Q       Send-Q               Local Address:Port                Peer Address:Port
> >>>>>
> >>>>> ESTAB       0            222024 127.0.0.1:57224 127.0.0.1:4004 timer:(persist,1min23sec,9)
> >>>>> skmem:(r0,rb2000000,t0,tb2000000,f2232,w227144,o0,bl0,d0) ts sack reno wscale:10,4 rto:201 backoff:9 rtt:0.866/0.944 ato:40 mss:65483 pmtu:65535 rcvmss:65483
> >>>>> advmss:65483 cwnd:10 bytes_sent:36810035 bytes_retrans:22025 bytes_acked:31729223 bytes_received:228063971 segs_out:20134 segs_in:17497 data_segs_out:11969
> >>>>> data_segs_in:16642 send 6049237875bps lastsnd:3266 lastrcv:125252 lastack:125263 pacing_rate 12093239064bps delivery_rate 130966000000bps delivered:11863
> >>>>> app_limited busy:275880ms rwnd_limited:21ms(0.0%) retrans:0/2 dsack_dups:2 rcv_rtt:0.671 rcv_space:1793073 rcv_ssthresh:934517 notsent:222024 minrtt:0.013
> >>>>> ESTAB       0            0 192.168.200.34:4004 192.168.200.34:16906
> >>>>>           skmem:(r0,rb19521831,t0,tb2626560,f0,w0,o0,bl0,d0) ts sack reno wscale:10,10 rto:201 rtt:0.483/0.64 ato:40 mss:22016 pmtu:65535 rcvmss:65483
> >>>>> advmss:65483
> >>>>> cwnd:5 ssthresh:5 bytes_sent:8175956 bytes_retrans:460 bytes_acked:8174668 bytes_received:20820708 segs_out:3635 segs_in:2491 data_segs_out:2377
> >>>>> data_segs_in:2330 send 1823271222bps lastsnd:125253 lastrcv:125250 lastack:125251 pacing_rate 2185097952bps delivery_rate 70451200000bps delivered:2372
> >>>>> busy:14988ms rwnd_limited:1ms(0.0%) retrans:0/5 rcv_rtt:1.216 rcv_space:779351 rcv_ssthresh:9759798 minrtt:0.003
> >>>>> ESTAB       0            139656 192.168.200.34:16908 192.168.200.34:4004 timer:(persist,1min52sec,2)
> >>>>> skmem:(r0,rb2000000,t0,tb2000000,f3960,w143496,o0,bl0,d0) ts sack reno wscale:10,10 rto:37397 backoff:2 rtt:4182.62/8303.35 ato:40 mss:65483 pmtu:65535
> >>>>> rcvmss:22016 advmss:65483 cwnd:10 bytes_sent:22351275 bytes_retrans:397320 bytes_acked:20703982 bytes_received:7815946 segs_out:2585 segs_in:3642
> >>>>> data_segs_out:2437 data_segs_in:2355 send 1252479bps lastsnd:7465 lastrcv:125250 lastack:125253 pacing_rate 2504952bps delivery_rate 15992bps delivered:2357
> >>>>> busy:271236ms retrans:0/19 rcv_rtt:0.004 rcv_space:288293 rcv_ssthresh:43690 notsent:139656 minrtt:0.004
> >>>>> ESTAB       0            460 192.168.200.34:4004 192.168.200.34:16908 timer:(on,1min23sec,9)
> >>>>> skmem:(r0,rb9433368,t0,tb2626560,f2356,w1740,o0,bl0,d0) ts sack reno wscale:10,10 rto:102912 backoff:9 rtt:0.741/1.167 ato:40 mss:22016 pmtu:65535
> >>>>> rcvmss:65483 advmss:65483 cwnd:1 ssthresh:2 bytes_sent:7850211 bytes_retrans:33437 bytes_acked:7815486 bytes_received:20703981 segs_out:3672 segs_in:2504
> >>>>> data_segs_out:2380 data_segs_in:2356 send 237689609bps lastsnd:19753 lastrcv:158000 lastack:125250 pacing_rate 854817384bps delivery_rate 115645432bps
> >>>>> delivered:2355 busy:200993ms unacked:1 retrans:0/24 lost:1 rcv_rtt:1.439 rcv_space:385874 rcv_ssthresh:4715943 minrtt:0.003
> >>>>> ESTAB       0            147205 192.168.200.34:16906 192.168.200.34:4004 timer:(persist,1min46sec,9)
> >>>>> skmem:(r0,rb2000000,t0,tb2000000,f507,w151045,o0,bl0,d0) ts sack reno wscale:10,10 rto:223 backoff:9 rtt:11.4/18.962 ato:40 mss:65483 pmtu:65535 rcvmss:22016
> >>>>> advmss:65483 cwnd:10 bytes_sent:23635760 bytes_retrans:220124 bytes_acked:20820709 bytes_received:8174668 segs_out:2570 segs_in:3625 data_segs_out:2409
> >>>>> data_segs_in:2371 send 459529825bps lastsnd:7465 lastrcv:125253 lastack:125250 pacing_rate 918999184bps delivery_rate 43655333328bps delivered:2331
> >>>>> app_limited
> >>>>> busy:185315ms retrans:0/14 rcv_rtt:0.005 rcv_space:220160 rcv_ssthresh:43690 notsent:147205 minrtt:0.003
> >>>>> ESTAB       0            3928980 127.0.0.1:4004 127.0.0.1:57224 timer:(persist,7.639ms,8)
> >>>>> skmem:(r0,rb50000000,t0,tb3939840,f108,w4005780,o0,bl0,d3) ts sack reno wscale:4,10 rto:251 backoff:8 rtt:13.281/25.84 ato:40 mss:65483 pmtu:65535
> >>>>> rcvmss:65483 advmss:65483 cwnd:10 ssthresh:10 bytes_sent:312422779 bytes_retrans:245567 bytes_acked:228063971 bytes_received:31729222 segs_out:18944
> >>>>> segs_in:20021 data_segs_out:18090 data_segs_in:11862 send 394446201bps lastsnd:56617 lastrcv:125271 lastack:125252 pacing_rate 709983112bps delivery_rate
> >>>>> 104772800000bps delivered:16643 app_limited busy:370468ms rwnd_limited:127ms(0.0%) retrans:0/26 rcv_rtt:7666.22 rcv_space:2279928 rcv_ssthresh:24999268
> >>>>> notsent:3928980 minrtt:0.003
> >>>>> [root@ct523c-0bdd ~]# date
> >>>>> Thu 06 Jan 2022 10:14:57 AM PST
> >>>>> [root@ct523c-0bdd ~]# ss -tinmo 'dport = :4004 or sport = :4004'
> >>>>> State       Recv-Q       Send-Q               Local Address:Port                Peer Address:Port
> >>>>>
> >>>>> ESTAB       0            222208 127.0.0.1:57224 127.0.0.1:4004 timer:(persist,1min11sec,9)
> >>>>> skmem:(r0,rb2000000,t0,tb2000000,f2048,w227328,o0,bl0,d0) ts sack reno wscale:10,4 rto:201 backoff:9 rtt:0.866/0.944 ato:40 mss:65483 pmtu:65535 rcvmss:65483
> >>>>> advmss:65483 cwnd:10 bytes_sent:36941001 bytes_retrans:22025 bytes_acked:31729223 bytes_received:228063971 segs_out:20136 segs_in:17497 data_segs_out:11971
> >>>>> data_segs_in:16642 send 6049237875bps lastsnd:2663 lastrcv:136933 lastack:136944 pacing_rate 12093239064bps delivery_rate 130966000000bps delivered:11863
> >>>>> app_limited busy:287561ms rwnd_limited:21ms(0.0%) retrans:0/2 dsack_dups:2 rcv_rtt:0.671 rcv_space:1793073 rcv_ssthresh:934517 notsent:222208 minrtt:0.013
> >>>>> ESTAB       0            0 192.168.200.34:4004 192.168.200.34:16906
> >>>>>           skmem:(r0,rb19521831,t0,tb2626560,f0,w0,o0,bl0,d0) ts sack reno wscale:10,10 rto:201 rtt:0.483/0.64 ato:40 mss:22016 pmtu:65535 rcvmss:65483
> >>>>> advmss:65483
> >>>>> cwnd:5 ssthresh:5 bytes_sent:8175956 bytes_retrans:460 bytes_acked:8174668 bytes_received:20820708 segs_out:3635 segs_in:2491 data_segs_out:2377
> >>>>> data_segs_in:2330 send 1823271222bps lastsnd:136934 lastrcv:136931 lastack:136932 pacing_rate 2185097952bps delivery_rate 70451200000bps delivered:2372
> >>>>> busy:14988ms rwnd_limited:1ms(0.0%) retrans:0/5 rcv_rtt:1.216 rcv_space:779351 rcv_ssthresh:9759798 minrtt:0.003
> >>>>> ESTAB       0            139656 192.168.200.34:16908 192.168.200.34:4004 timer:(persist,1min40sec,2)
> >>>>> skmem:(r0,rb2000000,t0,tb2000000,f3960,w143496,o0,bl0,d0) ts sack reno wscale:10,10 rto:37397 backoff:2 rtt:4182.62/8303.35 ato:40 mss:65483 pmtu:65535
> >>>>> rcvmss:22016 advmss:65483 cwnd:10 bytes_sent:22351275 bytes_retrans:397320 bytes_acked:20703982 bytes_received:7815946 segs_out:2585 segs_in:3642
> >>>>> data_segs_out:2437 data_segs_in:2355 send 1252479bps lastsnd:19146 lastrcv:136931 lastack:136934 pacing_rate 2504952bps delivery_rate 15992bps delivered:2357
> >>>>> busy:282917ms retrans:0/19 rcv_rtt:0.004 rcv_space:288293 rcv_ssthresh:43690 notsent:139656 minrtt:0.004
> >>>>> ESTAB       0            460 192.168.200.34:4004 192.168.200.34:16908 timer:(on,1min11sec,9)
> >>>>> skmem:(r0,rb9433368,t0,tb2626560,f2356,w1740,o0,bl0,d0) ts sack reno wscale:10,10 rto:102912 backoff:9 rtt:0.741/1.167 ato:40 mss:22016 pmtu:65535
> >>>>> rcvmss:65483 advmss:65483 cwnd:1 ssthresh:2 bytes_sent:7850211 bytes_retrans:33437 bytes_acked:7815486 bytes_received:20703981 segs_out:3672 segs_in:2504
> >>>>> data_segs_out:2380 data_segs_in:2356 send 237689609bps lastsnd:31434 lastrcv:169681 lastack:136931 pacing_rate 854817384bps delivery_rate 115645432bps
> >>>>> delivered:2355 busy:212674ms unacked:1 retrans:0/24 lost:1 rcv_rtt:1.439 rcv_space:385874 rcv_ssthresh:4715943 minrtt:0.003
> >>>>> ESTAB       0            147205 192.168.200.34:16906 192.168.200.34:4004 timer:(persist,1min35sec,9)
> >>>>> skmem:(r0,rb2000000,t0,tb2000000,f507,w151045,o0,bl0,d0) ts sack reno wscale:10,10 rto:223 backoff:9 rtt:11.4/18.962 ato:40 mss:65483 pmtu:65535 rcvmss:22016
> >>>>> advmss:65483 cwnd:10 bytes_sent:23635760 bytes_retrans:220124 bytes_acked:20820709 bytes_received:8174668 segs_out:2570 segs_in:3625 data_segs_out:2409
> >>>>> data_segs_in:2371 send 459529825bps lastsnd:19146 lastrcv:136934 lastack:136931 pacing_rate 918999184bps delivery_rate 43655333328bps delivered:2331
> >>>>> app_limited
> >>>>> busy:196996ms retrans:0/14 rcv_rtt:0.005 rcv_space:220160 rcv_ssthresh:43690 notsent:147205 minrtt:0.003
> >>>>> ESTAB       0            3928980 127.0.0.1:4004 127.0.0.1:57224 timer:(persist,1min57sec,9)
> >>>>> skmem:(r0,rb50000000,t0,tb3939840,f108,w4005780,o0,bl0,d3) ts sack reno wscale:4,10 rto:251 backoff:9 rtt:13.281/25.84 ato:40 mss:65483 pmtu:65535
> >>>>> rcvmss:65483 advmss:65483 cwnd:10 ssthresh:10 bytes_sent:312488262 bytes_retrans:245567 bytes_acked:228063971 bytes_received:31729222 segs_out:18945
> >>>>> segs_in:20021 data_segs_out:18091 data_segs_in:11862 send 394446201bps lastsnd:2762 lastrcv:136952 lastack:136933 pacing_rate 709983112bps delivery_rate
> >>>>> 104772800000bps delivered:16643 app_limited busy:382149ms rwnd_limited:127ms(0.0%) retrans:0/26 rcv_rtt:7666.22 rcv_space:2279928 rcv_ssthresh:24999268
> >>>>> notsent:3928980 minrtt:0.003
> >>>>> [root@ct523c-0bdd ~]#
> >>>>>
> >>>>>
> >>>>> We can reproduce this readily at current, and I'm happy to try patches and/or do more debugging.  We also tried with a 5.12 kernel,
> >>>>> and saw same problems, but in all cases, we have local patches applied, and there is no way for us to do this test without
> >>>>> at least a fair bit of local patches applied.
> >>>>
> >>>> Thanks for the ss traces and tcpdump output! The tcpdump traces are
> >>>> nice, in that they start before the connection starts, so capture the
> >>>> SYN and its critical options like wscale.
> >>>>
> >>>>  From the "timer:(persist" in the ss output, it seems the stalls (that
> >>>> are preventing the send buffers from being transmitted) are caused by
> >>>> a 0-byte receive window causing the senders to stop sending, and
> >>>> periodically fire the ICSK_TIME_PROBE0 timer to check for an open
> >>>> receive window. From "backoff:9" it seems this condition has lasted
> >>>> for a very long exponential backoff process.
> >>>>
> >>>> I don't see 0-byte receive window problems in the trace, but this is
> >>>> probably because the tcpdump traces only last through 10:12:47 PST,
> >>>> and the problem is showing up in ss at 10:14:49 AM PST and later.
> >>>>
> >>>> Is it possible to reproduce the problem again, and this time let the
> >>>> tcpdump traces run all the way through the period where the
> >>>> connections freeze and you grab the "ss" output?
> >>>>
> >>>> You may also have to explicitly kill the tcpdump. Perhaps the tail of
> >>>> the trace was buffered in tcpdump's output buffer and not flushed to
> >>>> disk. A "killall tcpdump" should do the trick to force it to cleanly
> >>>> flush everything.
> >>>
> >>> Here is another set of debugging, I made sure tcpdump ran the entire time,
> >>> as well as the ss monitoring script.
> >>>
> >>> http://www.candelatech.com/downloads/ss_log.txt
> >>> http://www.candelatech.com/downloads/trace-lo-4004-b.pcap
> >>>
> >>> In addition, here are logs from my tool with msec timestamps. It is detecting
> >>> communication failure and logging about it.  Interestingly, I think it recovered
> >>> after one long timeout, but in the end, it went past the 2-minute cutoff mark
> >>> where my program will close the TCP connection and restart things.
> >>>
> >>> 1641506767983:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 34458ms, sending req for update, read-isset: 0
> >>> 1641506773839:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 40314ms, sending req for update, read-isset: 0
> >>> 1641506780563:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 47038ms, sending req for update, read-isset: 0
> >>> 1641506786567:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 53041ms, sending req for update, read-isset: 0
> >>> 1641506823537:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 34949ms, sending req for update, read-isset: 0
> >>> 1641506829280:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 40692ms, sending req for update, read-isset: 0
> >>> 1641506834878:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 46289ms, sending req for update, read-isset: 0
> >>> 1641506840778:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 52189ms, sending req for update, read-isset: 0
> >>> 1641506846786:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 58198ms, sending req for update, read-isset: 0
> >>> 1641506852746:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 64158ms, sending req for update, read-isset: 0
> >>> 1641506858280:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 69692ms, sending req for update, read-isset: 0
> >>> 1641506864200:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 75612ms, sending req for update, read-isset: 0
> >>> 1641506870556:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 81968ms, sending req for update, read-isset: 0
> >>> 1641506876564:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 87976ms, sending req for update, read-isset: 0
> >>> 1641506882774:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 94185ms, sending req for update, read-isset: 0
> >>>
> >>> # Recovered between here and above it seems.
> >>>
> >>> 1641507005029:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 35840ms, sending req for update, read-isset: 0
> >>> 1641507035759:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 30164ms, sending req for update, read-isset: 0
> >>> 1641507042161:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 36565ms, sending req for update, read-isset: 0
> >>> 1641507048397:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 42802ms, sending req for update, read-isset: 0
> >>> 1641507054491:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 48896ms, sending req for update, read-isset: 0
> >>> 1641507060748:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 55153ms, sending req for update, read-isset: 0
> >>> 1641507067083:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 61488ms, sending req for update, read-isset: 0
> >>> 1641507073438:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 67842ms, sending req for update, read-isset: 0
> >>> 1641507079638:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 74042ms, sending req for update, read-isset: 0
> >>> 1641507085926:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 80330ms, sending req for update, read-isset: 0
> >>> 1641507091788:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 86192ms, sending req for update, read-isset: 0
> >>> 1641507098042:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 92447ms, sending req for update, read-isset: 0
> >>> 1641507104283:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 98687ms, sending req for update, read-isset: 0
> >>> 1641507110466:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 104871ms, sending req for update, read-isset: 0
> >>> 1641507116381:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 110786ms, sending req for update, read-isset: 0
> >>> 1641507123034:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 117439ms, sending req for update, read-isset: 0
> >>> 1641507128975:  Card.cc 801: WARNING:  Card: Shelf: 1, Card: 1 has not received communication in: 123379ms, sending req for update, read-isset: 0
> >>
> >> Hello Neal,
> >>
> >> Do the new captures help any?
> >>
> >> From my own looking at things, it seems that the sniffer fails to get frames near when the problem
> >> starts happening.  I am baffled as to how that can happen, especially since it seems to stop getting
> >> packets from multiple different TCP connections (the sniffer filter would pick up some other loop-back
> >> related connections to the same IP port).
> >>
> >> And, if I interpret the ss output properly, after the problem happens, the sockets still think they are
> >> sending data.  I didn't check closely enough to see if the peer side thought it received it.
> >>
> >> We are going to try to reproduce w/out wifi, but not sure we'll have any luck with that.
> >> We did test w/out VRF (using lots of ip rules instead), and similar problem was seen according to my
> >> test team (I did not debug it in detail).
> >>
> >> Do you have any suggestions for how to debug this further?  I am happy to hack stuff into the
> >> kernel if you have some suggested places to add debugging...
> >>
> >> Thanks,
> >> Ben
> >>
> > These 2 packets (or lack of packets between them) are suspicious.
> >
> > 14:06:28.294557 IP 127.0.0.1.4004 > 127.0.0.1.57234: Flags [.], seq 226598466:226663949, ack 31270804, win 24414, options [nop,nop,TS val 3325283657 ecr
> > 3325283657], length 65483
> >
> > 14:08:04.143548 IP 127.0.0.1.57234 > 127.0.0.1.4004: Flags [P.], seq 31270804:31336287, ack 226663949, win 58408, options [nop,nop,TS val 3325379506 ecr
> > 3325283657], length 65483
> >
> >
> > It looks like ACK for first packet is not sent, and packet is not retransmitted.
> >
> > This could be a bug in conntrack (dropping rtx packets over loopback so pcap do not show the attempts),
> >
> > or persistent memory allocation errors in __tcp_send_ack()
> >
> >
> > Or this could be that the missing ACK packet was dropped by tcpdump.
> >
> > Another suspicious sequence is:
> >
> > 14:09:29.159816 IP 127.0.0.1.57234 > 127.0.0.1.4004: Flags [P.], seq 32608288:32609208, ack 265640849, win 58408, options [nop,nop,TS val 3325464522 ecr
> > 3325464521], length 920
> >
> > 14:10:05.487756 IP 127.0.0.1.57234 > 127.0.0.1.4004: Flags [.], seq 32609208:32674691, ack 265640849, win 58408, options [nop,nop,TS val 3325500850 ecr
> > 3325464521], length 65483
> >
> > 14:10:05.487762 IP 127.0.0.1.4004 > 127.0.0.1.57234: Flags [P.], seq 265640849:265706332, ack 32674691, win 24382, options [nop,nop,TS val 3325500850 ecr
> > 3325500850], length 65483
> >
> > Same pattern here, missing ACK for 1st packet, and no retransmits.
>
> Thanks for your insight as well.
>
> I have not poked in the tcp stack much, certainly not recently.  Do you have any suggestions
> for checking if conntrack is at fault?  For instance, could I run a command that would clear
> all contrack entries and then see if it re-built them properly and recovered?
>
> Or something like the 'ss' tool that would show enough debug to find problematic conntrack
> entries?
>
> Or, if nothing else, I was planning to try to add printk in the packet tx path, trying to match only for
> frames to or from port 4004 and to/from 127.0.0.1.
>
> Two captures in a row showed that packet capture stopped near time of the problem starting, so
> I think it is probably not just some random packet-loss issue with the capture, but rather
> a real symptom of the problem.
>

Just to clarify:

Have you any qdisc on lo interface ?

Can you try:
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5079832af5c1090917a8fd5dfb1a3025e2d85ae0..81a26ce4d79fd48f870b5c1d076a9082950e2a57
100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2769,6 +2769,7 @@ bool tcp_schedule_loss_probe(struct sock *sk,
bool advancing_rto)
 static bool skb_still_in_host_queue(struct sock *sk,
                                    const struct sk_buff *skb)
 {
+#if 0
        if (unlikely(skb_fclone_busy(sk, skb))) {
                set_bit(TSQ_THROTTLED, &sk->sk_tsq_flags);
                smp_mb__after_atomic();
@@ -2778,6 +2779,7 @@ static bool skb_still_in_host_queue(struct sock *sk,
                        return true;
                }
        }
+#endif
        return false;
 }
