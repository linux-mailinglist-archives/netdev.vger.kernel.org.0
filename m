Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D8667A1B5
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbjAXSsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjAXSsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:48:52 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB32B2BF13
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 10:48:51 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u15-20020a170902a60f00b00194d7d89168so8337304plq.10
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 10:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eJ9fHNI2bifYxES5qUmgRME8xH96EaZ2Dunhd4XnTao=;
        b=L/7Y+NwB+jJPHXW7xEgDH/Jnx/MMVgmCXk/1P/mNUcDV+MVS2Ti397L/3gJlxNpUV1
         zLhNmwaIj898y7EZpCGYPq/wplH5vF9TQV6qRHtvBG+93NwGzbnv+V97vMYKHdHJdRj6
         hzDeAI3USTaASuj7uVRQomJh2kLMoqUVlavtAgmQqiX7TzJnJfcvklm0KShAQNvOJynT
         Mzylywa+t+nrsm3OC+9fueASjKE+nK6knZU2Fp/yboLaISEZZZMTlCCMHgTHQfw81jh3
         UNCKAHFRSmhi/X42/23Qx2ZnJE4WI9KZRrOcydNTv1wuOvqPWXjlSe6OSS3JvJsKudRe
         5EBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eJ9fHNI2bifYxES5qUmgRME8xH96EaZ2Dunhd4XnTao=;
        b=pFK+J58GWh8DJRB7asFZHwpFvtY7pVZJTRCbUK3fc2TcllWuNNAzMVv+Ex+8y/t39m
         4KHbR+ZB96SViphX8794M3ZKYSrYGfeUbUBh62p/u0yHAJ43Rpp7oz3i+x5emtsLvEKk
         zuwqicAspOWMKeUQi+DqmPRu1I8SK9kK4PSbPlO54biY7YBY+ykB9/lYuLaxW56jSPZd
         8s23TqJhjdC5wgZ2JKIKg7rTIUanpxxZlDvO1CP1MCDDSu54aY9ziL1QH8BVrQpb6ZhQ
         xiATb0lx/jEdgTY63n5KbIsgxZV3nyjBopesJyef6na6KzikWmyOJrPI9wVy57qIkkPD
         AHwQ==
X-Gm-Message-State: AFqh2kpo3EIoJ011qweNPCd7W05UJv+f03iCxFyRU8di+6iEgv+4O9P/
        CkSNe4YbYUBnbR7IFgGwiJm7KJE=
X-Google-Smtp-Source: AMrXdXvYdye/snDN4tbW6TMN6VSZTjwGnXWqimnUH2dO5ZcGbE2uRqspfWjPkihUQB7DWrCIQhLF9/0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:9a41:b0:195:eb15:6ee1 with SMTP id
 x1-20020a1709029a4100b00195eb156ee1mr1794642plv.23.1674586131050; Tue, 24 Jan
 2023 10:48:51 -0800 (PST)
Date:   Tue, 24 Jan 2023 10:48:49 -0800
In-Reply-To: <CAKH8qBvK-tJxQwBsUvQZ39KyhyAbd76H1xhdzmzeKbbN5Hzq7Q@mail.gmail.com>
Mime-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com> <20230119221536.3349901-18-sdf@google.com>
 <71be95ee-b522-b3db-105a-0f25d8dc52cb@redhat.com> <CAKH8qBvK-tJxQwBsUvQZ39KyhyAbd76H1xhdzmzeKbbN5Hzq7Q@mail.gmail.com>
Message-ID: <Y9AoEcjb+MET41NB@google.com>
Subject: Re: [PATCH bpf-next v8 17/17] selftests/bpf: Simple program to dump
 XDP RX metadata
From:   sdf@google.com
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
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
        "Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?=" <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/24, Stanislav Fomichev wrote:
> On Tue, Jan 24, 2023 at 7:26 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
> >
> >
> > Testing this on mlx5 and I'm not getting the RX-timestamp.
> > See command details below.

> CC'ed Toke since I've never tested mlx5 myself.
> I was pretty close to getting the setup late last week, let me try to
> see whether it's ready or not.

> > On 19/01/2023 23.15, Stanislav Fomichev wrote:
> > > To be used for verification of driver implementations. Note that
> > > the skb path is gone from the series, but I'm still keeping the
> > > implementation for any possible future work.
> > >
> > > $ xdp_hw_metadata <ifname>
> >
> > sudo ./xdp_hw_metadata mlx5p1
> >
> > Output:
> > [...cut ...]
> > open bpf program...
> > load bpf program...
> > prepare skb endpoint...
> > XXX timestamping_enable(): setsockopt(SO_TIMESTAMPING) ret:0
> > prepare xsk map...
> > map[0] = 3
> > map[1] = 4
> > map[2] = 5
> > map[3] = 6
> > map[4] = 7
> > map[5] = 8
> > attach bpf program...
> > poll: 0 (0)
> > poll: 0 (0)
> > poll: 0 (0)
> > poll: 1 (0)
> > xsk_ring_cons__peek: 1
> > 0x1821788: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
> > rx_timestamp: 0
> > rx_hash: 2773355807
> > 0x1821788: complete idx=8 addr=8000
> > poll: 0 (0)
> >
> > The trace_pipe:
> >
> > $ sudo cat /sys/kernel/debug/tracing/trace_pipe
> >            <idle>-0       [005] ..s2.  2722.884762: bpf_trace_printk:
> > forwarding UDP:9091 to AF_XDP
> >            <idle>-0       [005] ..s2.  2722.884771: bpf_trace_printk:
> > populated rx_hash with 2773355807
> >
> >
> > > On the other machine:
> > >
> > > $ echo -n xdp | nc -u -q1 <target> 9091 # for AF_XDP
> >
> > Fixing the source-port to see if RX-hash remains the same.
> >
> >   $ echo xdp | nc --source-port=2000 --udp 198.18.1.1 9091
> >
> > > $ echo -n skb | nc -u -q1 <target> 9092 # for skb
> > >
> > > Sample output:
> > >
> > >    # xdp
> > >    xsk_ring_cons__peek: 1
> > >    0x19f9090: rx_desc[0]->addr=100000000008000 addr=8100  
> comp_addr=8000
> > >    rx_timestamp_supported: 1
> > >    rx_timestamp: 1667850075063948829
> > >    0x19f9090: complete idx=8 addr=8000
> >
> > xsk_ring_cons__peek: 1
> > 0x1821788: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
> > rx_timestamp: 0
> > rx_hash: 2773355807
> > 0x1821788: complete idx=8 addr=8000
> >
> > It doesn't look like hardware RX-timestamps are getting enabled.
> >
> > [... cut to relevant code ...]
> >
> > > diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c  
> b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > new file mode 100644
> > > index 000000000000..0008f0f239e8
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > > @@ -0,0 +1,403 @@
> > [...]
> >
> > > +static void timestamping_enable(int fd, int val)
> > > +{
> > > +     int ret;
> > > +
> > > +     ret = setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val,  
> sizeof(val));
> > > +     if (ret < 0)
> > > +             error(-1, errno, "setsockopt(SO_TIMESTAMPING)");
> > > +}
> > > +
> > > +int main(int argc, char *argv[])
> > > +{
> > [...]
> >
> > > +     printf("prepare skb endpoint...\n");
> > > +     server_fd = start_server(AF_INET6, SOCK_DGRAM, NULL, 9092,  
> 1000);
> > > +     if (server_fd < 0)
> > > +             error(-1, errno, "start_server");
> > > +     timestamping_enable(server_fd,
> > > +                         SOF_TIMESTAMPING_SOFTWARE |
> > > +                         SOF_TIMESTAMPING_RAW_HARDWARE);
> > > +
> >
> > I don't think this timestamping_enable() with these flags are enough to
> > enable hardware timestamping.

Yeah, agreed, looks like that's the issue. timestamping_enable() has
been used for the xdp->skb path that I've eventually removed from the
series, so it's mostly a noop here..

Maybe you can try the following before I send a proper patch?

diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c  
b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 0008f0f239e8..dceddb17fbc9 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -24,6 +24,7 @@
  #include <linux/net_tstamp.h>
  #include <linux/udp.h>
  #include <linux/sockios.h>
+#include <linux/net_tstamp.h>
  #include <sys/mman.h>
  #include <net/if.h>
  #include <poll.h>
@@ -278,13 +279,37 @@ static int rxq_num(const char *ifname)

  	ret = ioctl(fd, SIOCETHTOOL, &ifr);
  	if (ret < 0)
-		error(-1, errno, "socket");
+		error(-1, errno, "ioctl(SIOCETHTOOL)");

  	close(fd);

  	return ch.rx_count + ch.combined_count;
  }

+static void hwtstamp_enable(const char *ifname)
+{
+	struct hwtstamp_config cfg = {
+		.rx_filter = HWTSTAMP_FILTER_ALL,
+
+	};
+
+	struct ifreq ifr = {
+		.ifr_data = (void *)&cfg,
+	};
+	strcpy(ifr.ifr_name, ifname);
+	int fd, ret;
+
+	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
+	if (fd < 0)
+		error(-1, errno, "socket");
+
+	ret = ioctl(fd, SIOCSHWTSTAMP, &ifr);
+	if (ret < 0)
+		error(-1, errno, "ioctl(SIOCSHWTSTAMP)");
+
+	close(fd);
+}
+
  static void cleanup(void)
  {
  	LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
@@ -341,6 +366,8 @@ int main(int argc, char *argv[])

  	printf("rxq: %d\n", rxq);

+	hwtstamp_enable(ifname);
+
  	rx_xsk = malloc(sizeof(struct xsk) * rxq);
  	if (!rx_xsk)
  		error(-1, ENOMEM, "malloc");


> > --Jesper
> >
