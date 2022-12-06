Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35688643A74
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 01:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiLFAvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 19:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiLFAu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 19:50:59 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF98A1B1D1
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 16:50:57 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id y2so4083930ily.5
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 16:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t7EllS7EycwJQKQ7E4+tjHuL0D77O7aeDFmbgKj4v/I=;
        b=EJHHbJiu3ulNrc8DJW8/qrbdCa4J7MJZMd/Wlf1oS4r/IF6DcNFguC+jw1hlPEuHSt
         1fOLkP0UpyyFpW4Q9rsWCBOlASujjlxifFP4fjd0u2AmzLWhQNCpmJupByUKqb5zod0I
         Qtbp43Ngn3R8VJj6ir32hJg1qc9AIYu/Xw60E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t7EllS7EycwJQKQ7E4+tjHuL0D77O7aeDFmbgKj4v/I=;
        b=PwAl05nq7WM2xvx6OM05nFV0HYds84gAwA4CYfqzrMKN+bGL7LcxlACwF1hcl2RPsX
         Gmy7F63rFdmUy3KFSDpwv7fxala4v4NZVN+ydU2Kb4U+Dkc1iYTqFaep9hfurzS02nB6
         /kas+xh+c866c+8CVRY3N1loCLQs5K4PN3dRZ9pcVVKJLJowy+51WnRdRWbysH5DJdaj
         H60ep6O5Be6zqRMltJmuKjMOLO63CmTog4llj2GnyLYRAbSwBZ7G/kdPvVcNMpivQ3qS
         k7RLHwrr3bYaUNQkwqpPVS7Ff+W4kD7U5I/QFeAySclaZNZXAAbXb2J4S/Bf6VzRitBd
         1HZQ==
X-Gm-Message-State: ANoB5pnbHW0pvX/ZhmEO3wax0NahLWR0r2ElBOe/juYm3V2wUq3q2BeA
        lR3gTwPHDUVFYEZXWlk/GrVS10Pvoi8efQBGp8FeJA==
X-Google-Smtp-Source: AA0mqf6xcsiga75ZuTjF0H61IWsLJpXbIrrZk8NtyASGXEnkKaFjtvYsf+OGcArSzU5Rc/FkigeEW6O9vU8MXXcRfxg=
X-Received: by 2002:a92:db42:0:b0:2fa:b6c0:80fd with SMTP id
 w2-20020a92db42000000b002fab6c080fdmr14932425ilq.164.1670287857252; Mon, 05
 Dec 2022 16:50:57 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org> <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
 <Y4T43Tc54vlKjTN0@cmpxchg.org> <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
In-Reply-To: <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Mon, 5 Dec 2022 16:50:46 -0800
Message-ID: <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On Mon, Dec 5, 2022 at 3:57 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> On Mon, Nov 28, 2022 at 10:07 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Tue, Nov 22, 2022 at 05:28:24PM -0800, Ivan Babrou wrote:
> > > On Tue, Nov 22, 2022 at 2:11 PM Ivan Babrou <ivan@cloudflare.com> wrote:
> > > >
> > > > On Tue, Nov 22, 2022 at 12:05 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > > >
> > > > > On Mon, Nov 21, 2022 at 04:53:43PM -0800, Ivan Babrou wrote:
> > > > > > Hello,
> > > > > >
> > > > > > We have observed a negative TCP throughput behavior from the following commit:
> > > > > >
> > > > > > * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
> > > > > >
> > > > > > It landed back in 2016 in v4.5, so it's not exactly a new issue.
> > > > > >
> > > > > > The crux of the issue is that in some cases with swap present the
> > > > > > workload can be unfairly throttled in terms of TCP throughput.
> > > > >
> > > > > Thanks for the detailed analysis, Ivan.
> > > > >
> > > > > Originally, we pushed back on sockets only when regular page reclaim
> > > > > had completely failed and we were about to OOM. This patch was an
> > > > > attempt to be smarter about it and equalize pressure more smoothly
> > > > > between socket memory, file cache, anonymous pages.
> > > > >
> > > > > After a recent discussion with Shakeel, I'm no longer quite sure the
> > > > > kernel is the right place to attempt this sort of balancing. It kind
> > > > > of depends on the workload which type of memory is more imporant. And
> > > > > your report shows that vmpressure is a flawed mechanism to implement
> > > > > this, anyway.
> > > > >
> > > > > So I'm thinking we should delete the vmpressure thing, and go back to
> > > > > socket throttling only if an OOM is imminent. This is in line with
> > > > > what we do at the system level: sockets get throttled only after
> > > > > reclaim fails and we hit hard limits. It's then up to the users and
> > > > > sysadmin to allocate a reasonable amount of buffers given the overall
> > > > > memory budget.
> > > > >
> > > > > Cgroup accounting, limiting and OOM enforcement is still there for the
> > > > > socket buffers, so misbehaving groups will be contained either way.
> > > > >
> > > > > What do you think? Something like the below patch?
> > > >
> > > > The idea sounds very reasonable to me. I can't really speak for the
> > > > patch contents with any sort of authority, but it looks ok to my
> > > > non-expert eyes.
> > > >
> > > > There were some conflicts when cherry-picking this into v5.15. I think
> > > > the only real one was for the "!sc->proactive" condition not being
> > > > present there. For the rest I just accepted the incoming change.
> > > >
> > > > I'm going to be away from my work computer until December 5th, but
> > > > I'll try to expedite my backported patch to a production machine today
> > > > to confirm that it makes the difference. If I can get some approvals
> > > > on my internal PRs, I should be able to provide the results by EOD
> > > > tomorrow.
> > >
> > > I tried the patch and something isn't right here.
> >
> > Thanks for giving it a sping.
> >
> > > With the patch applied I'm capped at ~120MB/s, which is a symptom of a
> > > clamped window.
> > >
> > > I can't find any sockets with memcg->socket_pressure = 1, but at the
> > > same time I only see the following rcv_ssthresh assigned to sockets:
> >
> > Hm, I don't see how socket accounting would alter the network behavior
> > other than through socket_pressure=1.
> >
> > How do you look for that flag? If you haven't yet done something
> > comparable, can you try with tracing to rule out sampling errors?
>
> Apologies for a delayed reply, I took a week off away from computers.
>
> I looked with bpftrace (from my bash_history):
>
> $ sudo bpftrace -e 'kprobe:tcp_try_rmem_schedule { @sk[cpu] = arg0; }
> kretprobe:tcp_try_rmem_schedule { $arg = @sk[cpu]; if ($arg) { $sk =
> (struct sock *) $arg; $id = $sk->sk_memcg->css.cgroup->kn->id;
> $socket_pressure = $sk->sk_memcg->socket_pressure; if ($id == 21379) {
> printf("id = %d, socket_pressure = %d\n", $id, $socket_pressure); } }
> }'
>
> I tried your patch on top of v6.1-rc8 (where it produced no conflicts)
> in my vm and it still gave me low numbers and nothing in
> /sys/kernel/debug/tracing/trace. To be extra sure, I changed it from
> trace_printk to just printk and it still didn't show up in dmesg, even
> with constant low throughput:
>
> ivan@vm:~$ curl -o /dev/null https://sim.cfperf.net/cached-assets/zero-5g.bin
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
>  14 4768M   14  685M    0     0  12.9M      0  0:06:08  0:00:52  0:05:16 13.0M
>
> I still saw clamped rcv_ssthresh:
>
> $ sudo ss -tinm dport 443
> State                  Recv-Q                  Send-Q
>                  Local Address:Port
>   Peer Address:Port                  Process
> ESTAB                  0                       0
>                      10.2.0.15:35800
> 162.159.136.82:443
> skmem:(r0,rb2577228,t0,tb46080,f0,w0,o0,bl0,d0) cubic rto:201
> rtt:0.42/0.09 ato:40 mss:1460 pmtu:1500 rcvmss:1440 advmss:1460
> cwnd:10 bytes_sent:12948 bytes_acked:12949 bytes_received:2915062731
> segs_out:506592 segs_in:2025111 data_segs_out:351 data_segs_in:2024911
> send 278095238bps lastsnd:824 lastrcv:154 lastack:154 pacing_rate
> 556190472bps delivery_rate 47868848bps delivered:352 app_limited
> busy:147ms rcv_rtt:0.011 rcv_space:82199 rcv_ssthresh:5840
> minrtt:0.059 snd_wnd:65535 tcp-ulp-tls rxconf: none txconf: none
>
> I also tried with my detection program for ebpf_exporter (fexit based version):
>
> * https://github.com/cloudflare/ebpf_exporter/pull/172/files
>
> Which also showed signs of a clamped window:
>
> # HELP ebpf_exporter_tcp_window_clamps_total Number of times that TCP
> window was clamped to a low value
> # TYPE ebpf_exporter_tcp_window_clamps_total counter
> ebpf_exporter_tcp_window_clamps_total 53887
>
> In fact, I can replicate this with just curl to a public URL and fio running,

I sprinkled some more printk around to get to the bottom of this:

static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
{
        if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
memcg->socket_pressure) {
                printk("socket pressure[1]: %lu", memcg->socket_pressure);
                return true;
        }
        do {
                if (memcg->socket_pressure) {
                        printk("socket pressure[2]: %lu",
memcg->socket_pressure);
                        return true;
                }
        } while ((memcg = parent_mem_cgroup(memcg)));
        return false;
}

And now I can see plenty of this:

[  108.156707][ T5175] socket pressure[2]: 4294673429
[  108.157050][ T5175] socket pressure[2]: 4294673429
[  108.157301][ T5175] socket pressure[2]: 4294673429
[  108.157581][ T5175] socket pressure[2]: 4294673429
[  108.157874][ T5175] socket pressure[2]: 4294673429
[  108.158254][ T5175] socket pressure[2]: 4294673429

I think the first result below is to blame:

$ rg '.->socket_pressure' mm
mm/memcontrol.c
5280: memcg->socket_pressure = jiffies;
7198: memcg->socket_pressure = 0;
7201: memcg->socket_pressure = 1;
7211: memcg->socket_pressure = 0;
7215: memcg->socket_pressure = 1;

While we set socket_pressure to either zero or one in
mem_cgroup_charge_skmem, it is still initialized to jiffies on memcg
creation. Zero seems like a more appropriate starting point. With that
change I see it working as expected with no TCP speed bumps. My
ebpf_exporter program also looks happy and reports zero clamps in my
brief testing.

Since it's not "socket pressure[1]" in dmesg output, then it's
probably one of the parent cgroups that is not getting charged for
socket memory that is reporting memory pressure.

I also think we should downgrade socket_pressure from "unsigned long"
to "bool", as it only holds zero and one now.
