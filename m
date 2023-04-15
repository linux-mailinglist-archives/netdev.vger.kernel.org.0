Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131FE6F1CF1
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346379AbjD1QxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjD1QxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:53:20 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551914EE2;
        Fri, 28 Apr 2023 09:53:15 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b60365f53so289170b3a.0;
        Fri, 28 Apr 2023 09:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682700794; x=1685292794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+QxcQwmg1pmTbHSBnT1S2CE2e3/rXWNKIsYLDVewC9E=;
        b=Wiutx5Gpr7taZmNu+Ji2c8cnLN8GhPjQkgf+V6KmoCZG2yIF0DS6vfXgZLBYdpk3wS
         lvSnITCY9ViuWNNROFqRNZ3P0dqMLWXia7ISHt8jZzeaDag6oQxCWJjSXjEk7tbODPmJ
         2ZYdfrW2ban6rmdFfsrMAoqFPJdjFAybT+lm3IOjmEayaCQbomW08SWtE7fZjLZB1hEH
         YvLcU00s5qUVpTt8RNdN549h8nBEldgnawWPC3X+PDyPn+b/6zxy6aZJ6ItH3QNMVzLL
         wk4ipQwefzsGXkk7pRFCiwDefZn2lsvGSKTgearOcNVFQU/QUtrUyrtA9B60Ar6gYV+Q
         7qxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682700794; x=1685292794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QxcQwmg1pmTbHSBnT1S2CE2e3/rXWNKIsYLDVewC9E=;
        b=VSvQBptH1MoVw/aag6KVtoTsegLmAvNzFho5mO2cFZ29m11lCfURhZtUZWHHvHrgfp
         VGiphmthUoKWC7fAeuVsKZOY0cNmChJFlok8nLJEcAyZ+klDMYqQHX8kxcB3cSvLwVMh
         Ol4T+WGep3d6kD1w8/Fc9Hpu/AVSd177MqYa4VMbFgxINEUyB2uqm4dv/tiSNAKgat+J
         VN5Ms6id3u0okR2cdqYrBKzpms2KEDbSlSZTKVRVGXVHluHvIdQIWZkgI0eFssiFgeVe
         ApNYKyBc7xUPdG3HDcGYZ4aouCHxlfnokvB0tbz6kLLiuvrfFUSm3zDCXlCfryi56yFb
         mRkA==
X-Gm-Message-State: AC+VfDw8peAOlaHyC20aaRQIrR7MIL4doNqqhLkCYVi0SttHDsqj3/A8
        4GgjUNBGR26jIk2BwFP8Gl0=
X-Google-Smtp-Source: ACHHUZ5xW1hI0KanevVm2aPZoOfGyAC5BsDffd4bfkw4RrbQn5BHotv4Ve9RRw1/sZwpWyqWIYQcdA==
X-Received: by 2002:a05:6a20:2d0a:b0:f5:607f:b78 with SMTP id g10-20020a056a202d0a00b000f5607f0b78mr6332078pzl.27.1682700794236;
        Fri, 28 Apr 2023 09:53:14 -0700 (PDT)
Received: from localhost (c-73-25-35-85.hsd1.wa.comcast.net. [73.25.35.85])
        by smtp.gmail.com with ESMTPSA id l21-20020a63ea55000000b005287a0560c9sm5581217pgk.1.2023.04.28.09.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 09:53:13 -0700 (PDT)
Date:   Sat, 15 Apr 2023 15:55:05 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Vishnu Dasa <vdasa@vmware.com>, virtio-dev@lists.oasis-open.org,
        linux-hyperv@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        netdev@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Bryan Tan <bryantan@vmware.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next v2 0/4] virtio/vsock: support datagrams
Message-ID: <ZDrI2bBhiamYBKUB@bullseye>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
 <ZDk2kOVnUvyLMLKE@bullseye>
 <r6oxanmhwlonb7lcrrowpitlgobivzp7pcwk7snqvfnzudi6pb@4rnio5wef3qu>
 <ZDpOq0ACuMYIUbb1@bullseye>
 <yeu57zqwzcx33sylp565xgw7yv72qyczohkmukyex27rcdh6mr@w4x6t4enx6iu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yeu57zqwzcx33sylp565xgw7yv72qyczohkmukyex27rcdh6mr@w4x6t4enx6iu>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 12:43:09PM +0200, Stefano Garzarella wrote:
> On Sat, Apr 15, 2023 at 07:13:47AM +0000, Bobby Eshleman wrote:
> > CC'ing virtio-dev@lists.oasis-open.org because this thread is starting
> > to touch the spec.
> > 
> > On Wed, Apr 19, 2023 at 12:00:17PM +0200, Stefano Garzarella wrote:
> > > Hi Bobby,
> > > 
> > > On Fri, Apr 14, 2023 at 11:18:40AM +0000, Bobby Eshleman wrote:
> > > > CC'ing Cong.
> > > >
> > > > On Fri, Apr 14, 2023 at 12:25:56AM +0000, Bobby Eshleman wrote:
> > > > > Hey all!
> > > > >
> > > > > This series introduces support for datagrams to virtio/vsock.
> > > 
> > > Great! Thanks for restarting this work!
> > > 
> > 
> > No problem!
> > 
> > > > >
> > > > > It is a spin-off (and smaller version) of this series from the summer:
> > > > >   https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
> > > > >
> > > > > Please note that this is an RFC and should not be merged until
> > > > > associated changes are made to the virtio specification, which will
> > > > > follow after discussion from this series.
> > > > >
> > > > > This series first supports datagrams in a basic form for virtio, and
> > > > > then optimizes the sendpath for all transports.
> > > > >
> > > > > The result is a very fast datagram communication protocol that
> > > > > outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
> > > > > of multi-threaded workload samples.
> > > > >
> > > > > For those that are curious, some summary data comparing UDP and VSOCK
> > > > > DGRAM (N=5):
> > > > >
> > > > > 	vCPUS: 16
> > > > > 	virtio-net queues: 16
> > > > > 	payload size: 4KB
> > > > > 	Setup: bare metal + vm (non-nested)
> > > > >
> > > > > 	UDP: 287.59 MB/s
> > > > > 	VSOCK DGRAM: 509.2 MB/s
> > > > >
> > > > > Some notes about the implementation...
> > > > >
> > > > > This datagram implementation forces datagrams to self-throttle according
> > > > > to the threshold set by sk_sndbuf. It behaves similar to the credits
> > > > > used by streams in its effect on throughput and memory consumption, but
> > > > > it is not influenced by the receiving socket as credits are.
> > > 
> > > So, sk_sndbuf influece the sender and sk_rcvbuf the receiver, right?
> > > 
> > 
> > Correct.
> > 
> > > We should check if VMCI behaves the same.
> > > 
> > > > >
> > > > > The device drops packets silently. There is room for improvement by
> > > > > building into the device and driver some intelligence around how to
> > > > > reduce frequency of kicking the virtqueue when packet loss is high. I
> > > > > think there is a good discussion to be had on this.
> > > 
> > > Can you elaborate a bit here?
> > > 
> > > Do you mean some mechanism to report to the sender that a destination
> > > (cid, port) is full so the packet will be dropped?
> > > 
> > 
> > Correct. There is also the case of there being no receiver at all for
> > this address since this case isn't rejected upon connect(). Ideally,
> > such a socket (which will have 100% packet loss) will be throttled
> > aggressively.
> > 
> > Before we go down too far on this path, I also want to clarify that
> > using UDP over vhost/virtio-net also has this property... this can be
> > observed by using tcpdump to dump the UDP packets on the bridge network
> > your VM is using. UDP packets sent to a garbage address can be seen on
> > the host bridge (this is the nature of UDP, how is the host supposed to
> > know the address eventually goes nowhere). I mention the above because I
> > think it is possible for vsock to avoid this cost, given that it
> > benefits from being point-to-point and g2h/h2g.
> > 
> > If we're okay with vsock being on par, then the current series does
> > that. I propose something below that can be added later and maybe
> > negotiated as a feature bit too.
> 
> I see and I agree on that, let's do it step by step.
> If we can do it in the first phase is great, but I think is fine to add
> this feature later.
> 
> > 
> > > Can we adapt the credit mechanism?
> > > 
> > 
> > I've thought about this a lot because the attraction of the approach for
> > me would be that we could get the wait/buffer-limiting logic for free
> > and without big changes to the protocol, but the problem is that the
> > unreliable nature of datagrams means that the source's free-running
> > tx_cnt will become out-of-sync with the destination's fwd_cnt upon
> > packet loss.
> 
> We need to understand where the packet can be lost.
> If the packet always reaches the destination (vsock driver or device),
> we can discard it, but also update the counters.
> 
> > 
> > Imagine a source that initializes and starts sending packets before a
> > destination socket even is created, the source's self-throttling will be
> > dysfunctional because its tx_cnt will always far exceed the
> > destination's fwd_cnt.
> 
> Right, the other problem I see is that the socket aren't connected, so
> we have 1-N relationship.
> 

Oh yeah, good point.

> > 
> > We could play tricks with the meaning of the CREDIT_UPDATE message and
> > fwd_cnt/buf_alloc fields, but I don't think we want to go down that
> > path.
> > 
> > I think that the best and simplest approach introduces a congestion
> > notification (VIRTIO_VSOCK_OP_CN?). When a packet is dropped, the
> > destination sends this notification. At a given repeated time period T,
> > the source can check if it has received any notifications in the last T.
> > If so, it halves its buffer allocation. If not, it doubles its buffer
> > allocation unless it is already at its max or original value.
> > 
> > An "invalid" socket which never has any receiver will converge towards a
> > rate limit of one packet per time T * log2(average pkt size). That is, a
> > socket with 100% packet loss will only be able to send 16 bytes every
> > 4T. A default send buffer of MAX_UINT32 and T=5ms would hit zero within
> > 160ms given at least one packet sent per 5ms. I have no idea if that is
> > a reasonable default T for vsock, I just pulled it out of a hat for the
> > sake of the example.
> > 
> > "Normal" sockets will be responsive to high loss and rebalance during
> > low loss. The source is trying to guess and converge on the actual
> > buffer state of the destination.
> > 
> > This would reuse the already-existing throttling mechanisms that
> > throttle based upon buffer allocation. The usage of sk_sndbuf would have
> > to be re-worked. The application using sendmsg() will see EAGAIN when
> > throttled, or just sleep if !MSG_DONTWAIT.
> 
> I see, it looks interesting, but I think we need to share that
> information between multiple sockets, since the same destination
> (cid, port), can be reached by multiple sockets.
> 

Good point, that is true.

> Another approach could be to have both congestion notification and
> decongestion, but maybe it produces double traffic.
> 

I think this could simplify things and could reduce noise. It is also
probably sufficient for the source to simply halt upon congestion
notification and resume upon decongestion notification, instead of
scaling up and down like I suggested above. It also avoids the
burstiness that would occur with a "congestion notification"-only
approach where the source guesses when to resume and guesses wrong.

The congestion notification may want to have an expiration period after
which the sender can resume without receiving a decongestion
notification? If it receives congestion again, then it can halt again.

> > 
> > I looked at alternative schemes (like the Datagram Congestion Control
> > Protocol), but I do not think the added complexity is necessary in the
> > case of vsock (DCCP requires congestion windows, sequence numbers, batch
> > acknowledgements, etc...). I also looked at UDP-based application
> > protocols like TFTP, DHCP, and SIP over UDP which use a delay-based
> > backoff mechanism, but seem to require acknowledgement for those packet
> > types, which trigger the retries and backoffs. I think we can get away
> > with the simpler approach and not have to potentially kill performance
> > with per-packet acknowledgements.
> 
> Yep I agree. I think our advantage is that the channel (virtqueues),
> can't lose packets.
> 

Exactly.

> > 
> > > > >
> > > > > In this series I am also proposing that fairness be reexamined as an
> > > > > issue separate from datagrams, which differs from my previous series
> > > > > that coupled these issues. After further testing and reflection on the
> > > > > design, I do not believe that these need to be coupled and I do not
> > > > > believe this implementation introduces additional unfairness or
> > > > > exacerbates pre-existing unfairness.
> > > 
> > > I see.
> > > 
> > > > >
> > > > > I attempted to characterize vsock fairness by using a pool of processes
> > > > > to stress test the shared resources while measuring the performance of a
> > > > > lone stream socket. Given unfair preference for datagrams, we would
> > > > > assume that a lone stream socket would degrade much more when a pool of
> > > > > datagram sockets was stressing the system than when a pool of stream
> > > > > sockets are stressing the system. The result, however, showed no
> > > > > significant difference between the degradation of throughput of the lone
> > > > > stream socket when using a pool of datagrams to stress the queue over
> > > > > using a pool of streams. The absolute difference in throughput actually
> > > > > favored datagrams as interfering least as the mean difference was +16%
> > > > > compared to using streams to stress test (N=7), but it was not
> > > > > statistically significant. Workloads were matched for payload size and
> > > > > buffer size (to approximate memory consumption) and process count, and
> > > > > stress workloads were configured to start before and last long after the
> > > > > lifetime of the "lone" stream socket flow to ensure that competing flows
> > > > > were continuously hot.
> > > > >
> > > > > Given the above data, I propose that vsock fairness be addressed
> > > > > independent of datagrams and to defer its implementation to a future
> > > > > series.
> > > 
> > > Makes sense to me.
> > > 
> > > I left some preliminary comments, anyway now it seems reasonable to use
> > > the same virtqueues, so we can go head with the spec proposal.
> > > 
> > > Thanks,
> > > Stefano
> > > 
> > 
> > Thanks for the review!
> 
> You're welcome!
> 
> Stefano
> 

Best,
Bobby
