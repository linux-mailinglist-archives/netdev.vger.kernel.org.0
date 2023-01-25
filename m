Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B46667B83E
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 18:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbjAYRQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 12:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbjAYRQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 12:16:42 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A716CDE2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 09:16:18 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso2742991pjj.1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 09:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0Lq2C2YrfDlMkcQ+NDzZ3mUNBnY3xsOWQI6Utpp56RM=;
        b=CMSzT6Pk1VlUHvHhjXb7MPoFHymAMQKTuNzUL3Zi+D8YDDZCT5laGiYqdTYTuFjmKK
         nda+bwD4ewrjXDHwmZv/5rpfhrOKsLqYnYv3B5Y2pyqAfcFsQhQsmtog3ZtKrK27Heea
         5xb6XNM3vu07tIw+/7txAlTu/NCiNE1IcjifGGuAXZH9FimahqgWeIChYNyVfnNzwr+9
         8xvIZnstIJlra4Q5bTbhQmgPi+vQS1PpcZ6S6FWa0ijI8Gg4++arG1J6QquYkyrHSfPO
         94oXH8vyjbDQHB7gKgMAA0KLLZII6MUgMUrmW9V0hqokU8zMKVZtQKvVDPu+rFnM2hrE
         KvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Lq2C2YrfDlMkcQ+NDzZ3mUNBnY3xsOWQI6Utpp56RM=;
        b=2xj14vd1xio9w4QJBo1nTb0v2beds0H5XcBQsngJSfZm++eG9XC1zSiuHBtE3a0dSl
         no47DCaL0Hyxc2uGi/8pKf0l52sXmc4gnoz+s800OJW/CUK8qiYkNqacu6nPoAl4L+bK
         Bg5n6bQK5GmRQiFVjZnP50CoGx1WyftzW50WBPvUE89PUZ90B6GuAt1N3850qA/cdFOx
         4LeJKQGmEkgzVS5G42wdocD9+umNhOo6ITAQOfeGR1WLpCLf0pgmock6o3jzxfNq9Qbq
         PvbC1rOwFogrEbc5yakIlkoefGfl+SmnUmhJddbPeE9enS7PtuSA1TjDLSpGBZ2NKlud
         aX8g==
X-Gm-Message-State: AFqh2krjP1c9Goud+2PLWVBAKJYzpLQk9HgN77fILHZy2//YZpSPLb5a
        XFdUeQW5xi/Qy9H227tThkKi5Xd5IEDA3Oaf2z98OQ==
X-Google-Smtp-Source: AMrXdXu5ADYmRcuqLK85IHrJSYNN0xe0wEEEr2bSFEt9Ag4oK2D1Ocpta3VCLRZ8qwZyHZdH/IpP8oYBB//KHzXqlnQ=
X-Received: by 2002:a17:90a:2c4d:b0:229:2410:ef30 with SMTP id
 p13-20020a17090a2c4d00b002292410ef30mr3776193pjm.66.1674666976443; Wed, 25
 Jan 2023 09:16:16 -0800 (PST)
MIME-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com> <20230119221536.3349901-18-sdf@google.com>
 <71be95ee-b522-b3db-105a-0f25d8dc52cb@redhat.com> <CAKH8qBvK-tJxQwBsUvQZ39KyhyAbd76H1xhdzmzeKbbN5Hzq7Q@mail.gmail.com>
 <Y9AoEcjb+MET41NB@google.com> <f3a116dc-1b14-3432-ad20-a36179ef0608@redhat.com>
In-Reply-To: <f3a116dc-1b14-3432-ad20-a36179ef0608@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 25 Jan 2023 09:16:04 -0800
Message-ID: <CAKH8qBuDUhK2YLyYTbkVweZaVYLoeytMi+pZ5_sb=PzY36jL7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 17/17] selftests/bpf: Simple program to dump
 XDP RX metadata
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 7:10 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 24/01/2023 19.48, sdf@google.com wrote:
> > On 01/24, Stanislav Fomichev wrote:
> >> On Tue, Jan 24, 2023 at 7:26 AM Jesper Dangaard Brouer
> >> <jbrouer@redhat.com> wrote:
> >> >
> >> >
> >> > Testing this on mlx5 and I'm not getting the RX-timestamp.
> >> > See command details below.
> >
> >> CC'ed Toke since I've never tested mlx5 myself.
> >> I was pretty close to getting the setup late last week, let me try to
> >> see whether it's ready or not.
> >
> >> > On 19/01/2023 23.15, Stanislav Fomichev wrote:
> >> > > To be used for verification of driver implementations. Note that
> >> > > the skb path is gone from the series, but I'm still keeping the
> >> > > implementation for any possible future work.
> >> > >
> >> > > $ xdp_hw_metadata <ifname>
> >> >
> >> > sudo ./xdp_hw_metadata mlx5p1
> >> >
> >> > Output:
> >> > [...cut ...]
> >> > open bpf program...
> >> > load bpf program...
> >> > prepare skb endpoint...
> >> > XXX timestamping_enable(): setsockopt(SO_TIMESTAMPING) ret:0
> >> > prepare xsk map...
> >> > map[0] = 3
> >> > map[1] = 4
> >> > map[2] = 5
> >> > map[3] = 6
> >> > map[4] = 7
> >> > map[5] = 8
> >> > attach bpf program...
> >> > poll: 0 (0)
> >> > poll: 0 (0)
> >> > poll: 0 (0)
> >> > poll: 1 (0)
> >> > xsk_ring_cons__peek: 1
> >> > 0x1821788: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
> >> > rx_timestamp: 0
> >> > rx_hash: 2773355807
> >> > 0x1821788: complete idx=8 addr=8000
> >> > poll: 0 (0)
> >> >
> >> > The trace_pipe:
> >> >
> >> > $ sudo cat /sys/kernel/debug/tracing/trace_pipe
> >> >            <idle>-0       [005] ..s2.  2722.884762: bpf_trace_printk:
> >> > forwarding UDP:9091 to AF_XDP
> >> >            <idle>-0       [005] ..s2.  2722.884771: bpf_trace_printk:
> >> > populated rx_hash with 2773355807
> >> >
> >> >
> >> > > On the other machine:
> >> > >
> >> > > $ echo -n xdp | nc -u -q1 <target> 9091 # for AF_XDP
> >> >
> >> > Fixing the source-port to see if RX-hash remains the same.
> >> >
> >> >   $ echo xdp | nc --source-port=2000 --udp 198.18.1.1 9091
> >> >
> >> > > $ echo -n skb | nc -u -q1 <target> 9092 # for skb
> >> > >
> >> > > Sample output:
> >> > >
> >> > >    # xdp
> >> > >    xsk_ring_cons__peek: 1
> >> > >    0x19f9090: rx_desc[0]->addr=100000000008000 addr=8100
> >> comp_addr=8000
> >> > >    rx_timestamp_supported: 1
> >> > >    rx_timestamp: 1667850075063948829
> >> > >    0x19f9090: complete idx=8 addr=8000
> >> >
> >> > xsk_ring_cons__peek: 1
> >> > 0x1821788: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
> >> > rx_timestamp: 0
> >> > rx_hash: 2773355807
> >> > 0x1821788: complete idx=8 addr=8000
> >> >
> >> > It doesn't look like hardware RX-timestamps are getting enabled.
> >> >
> >> > [... cut to relevant code ...]
> >> >
> >> > > diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >> b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >> > > new file mode 100644
> >> > > index 000000000000..0008f0f239e8
> >> > > --- /dev/null
> >> > > +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >> > > @@ -0,0 +1,403 @@
> >> > [...]
> >> >
> >> > > +static void timestamping_enable(int fd, int val)
> >> > > +{
> >> > > +     int ret;
> >> > > +
> >> > > +     ret = setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val,
> >> sizeof(val));
> >> > > +     if (ret < 0)
> >> > > +             error(-1, errno, "setsockopt(SO_TIMESTAMPING)");
> >> > > +}
> >> > > +
> >> > > +int main(int argc, char *argv[])
> >> > > +{
> >> > [...]
> >> >
> >> > > +     printf("prepare skb endpoint...\n");
> >> > > +     server_fd = start_server(AF_INET6, SOCK_DGRAM, NULL, 9092,
> >> 1000);
> >> > > +     if (server_fd < 0)
> >> > > +             error(-1, errno, "start_server");
> >> > > +     timestamping_enable(server_fd,
> >> > > +                         SOF_TIMESTAMPING_SOFTWARE |
> >> > > +                         SOF_TIMESTAMPING_RAW_HARDWARE);
> >> > > +
> >> >
> >> > I don't think this timestamping_enable() with these flags are enough to
> >> > enable hardware timestamping.
> >
> > Yeah, agreed, looks like that's the issue. timestamping_enable() has
> > been used for the xdp->skb path that I've eventually removed from the
> > series, so it's mostly a noop here..
> >
> > Maybe you can try the following before I send a proper patch?
>
> Yes, below patch fixed the issue, thx.
>
> Now I get HW timestamps, plus I added some software CLOCK_TAI timestamps
> to compare against.
>
> Output is now:
>
>   poll: 1 (0)
>   xsk_ring_cons__peek: 1
>   0xf64788: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
>   rx_hash: 3697961069
>   rx_timestamp:  1674657672142214773 (sec:1674657672.1422)
>   XDP RX-time:   1674657709561774876 (sec:1674657709.5618) delta sec:37.4196
>   AF_XDP time:   1674657709561871034 (sec:1674657709.5619) delta
> sec:0.0001 (96.158 usec)
>   0xf64788: complete idx=8 addr=8000
>
> My NIC hardware clock is clearly not synced with system time, as above
> delta say 37.4 seconds between HW and XDP timestamps (using
> bpf_ktime_get_tai_ns()).
>
> Time between XDP and AF_XDP wakeup is reported to be 96 usec, which is
> also higher than I expected.  As explained in [1] this is caused by CPU
> sleep states.
>
> My /dev/cpu_dma_latency was set to 2000000000.  Applying tuned-adm
> profile latency-performance this value change to 2.
>
>   $ sudo hexdump --format '"%d\n"' /dev/cpu_dma_latency
>   2000000000
>   $ sudo hexdump --format '"%d\n"' /dev/cpu_dma_latency
>   2
>
> Now the time between XDP and AF_XDP wakeup is reduced to approx 12 usec.
>
>   rx_timestamp:  1674659206344977544 (sec:1674659206.3450)
>   XDP RX-time:   1674659243776087765 (sec:1674659243.7761) delta sec:37.4311
>   AF_XDP time:   1674659243776099841 (sec:1674659243.7761) delta
> sec:0.0000 (12.076 usec)
>
>
> [1]
> https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-interaction

Great, thank you for testing and investigating the clock discrepancy!
Will send it as a patch later today, will add your Tested-by (if you
don't mind).

> > diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > index 0008f0f239e8..dceddb17fbc9 100644
> > --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > @@ -24,6 +24,7 @@
> >   #include <linux/net_tstamp.h>
> >   #include <linux/udp.h>
> >   #include <linux/sockios.h>
> > +#include <linux/net_tstamp.h>
> >   #include <sys/mman.h>
> >   #include <net/if.h>
> >   #include <poll.h>
> > @@ -278,13 +279,37 @@ static int rxq_num(const char *ifname)
> >
> >       ret = ioctl(fd, SIOCETHTOOL, &ifr);
> >       if (ret < 0)
> > -        error(-1, errno, "socket");
> > +        error(-1, errno, "ioctl(SIOCETHTOOL)");
> >
> >       close(fd);
> >
> >       return ch.rx_count + ch.combined_count;
> >   }
> >
> > +static void hwtstamp_enable(const char *ifname)
> > +{
> > +    struct hwtstamp_config cfg = {
> > +        .rx_filter = HWTSTAMP_FILTER_ALL,
> > +
> > +    };
> > +
> > +    struct ifreq ifr = {
> > +        .ifr_data = (void *)&cfg,
> > +    };
> > +    strcpy(ifr.ifr_name, ifname);
> > +    int fd, ret;
> > +
> > +    fd = socket(AF_UNIX, SOCK_DGRAM, 0);
> > +    if (fd < 0)
> > +        error(-1, errno, "socket");
> > +
> > +    ret = ioctl(fd, SIOCSHWTSTAMP, &ifr);
> > +    if (ret < 0)
> > +        error(-1, errno, "ioctl(SIOCSHWTSTAMP)");
> > +
> > +    close(fd);
> > +}
> > +
> >   static void cleanup(void)
> >   {
> >       LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
> > @@ -341,6 +366,8 @@ int main(int argc, char *argv[])
> >
> >       printf("rxq: %d\n", rxq);
> >
> > +    hwtstamp_enable(ifname);
> > +
> >       rx_xsk = malloc(sizeof(struct xsk) * rxq);
> >       if (!rx_xsk)
> >           error(-1, ENOMEM, "malloc");
> >
> >
>
