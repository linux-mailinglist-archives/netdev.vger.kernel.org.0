Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741E06E02EB
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 02:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjDMACi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 20:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDMACh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 20:02:37 -0400
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A5F3C39;
        Wed, 12 Apr 2023 17:02:35 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id he13so12508322wmb.2;
        Wed, 12 Apr 2023 17:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681344154; x=1683936154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wnTbuQLS+s98EOJFfwv3Ba/ON2eWwogZsizkDywlsTM=;
        b=OMwFMYP3LfY8f7wHmrhuQJi5aW3SHZc5GyBrnDvO+6BOvZUXJO0OlSExdkfBcW4xnu
         YPzMrXVNVPWMwwmLvpecsN6nPtLUE+3udGDBTdjSoHYYmtwt5BzwCNf2jT4QdA8cNfLS
         P/YNvyrsqDCoFvCwXu8iIATpkHdO+O5QBotAyXGHDLNMDwN/X6RRlSOVYlSZNhHZRexd
         YBt3RfLtZtBJ/taYkARuugh4k8V7O1S3+WFV8MTCGqBpsmp6fXhm0U9pNo4kEYRXQjeQ
         X+JOJVfBPY74Ynz1xAilMJmvis5cR0MJexG/ptnvYqku6XqRRwMzuBn5dQ5gHjQqLpRF
         134g==
X-Gm-Message-State: AAQBX9ddofw0oQixioxOp21XLlcRQSX8eNz6aOjoj43ET1J+d4W4sXSs
        YFbGSylzAYsh4WNv23Zl3y3dvse6zS+CNQ==
X-Google-Smtp-Source: AKy350bg7BOELuRvy/75oi6gDnbsLIrWQAvVymztmZ8D7/qU45W4+GLiVPq3yXBM3QmSWtXbHnGuXA==
X-Received: by 2002:a1c:6a14:0:b0:3e1:f8af:8772 with SMTP id f20-20020a1c6a14000000b003e1f8af8772mr322031wmc.9.1681344153925;
        Wed, 12 Apr 2023 17:02:33 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-031.fbsv.net. [2a03:2880:31ff:1f::face:b00c])
        by smtp.gmail.com with ESMTPSA id g5-20020a7bc4c5000000b003ee10fb56ebsm323679wmk.9.2023.04.12.17.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 17:02:33 -0700 (PDT)
Date:   Wed, 12 Apr 2023 17:02:31 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        asml.silence@gmail.com, leit@fb.com, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, dccp@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        matthieu.baerts@tessares.net, marcelo.leitner@gmail.com
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Message-ID: <ZDdGl/JGDoRDL8ja@gmail.com>
References: <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
 <643573df81e20_11117c2942@willemb.c.googlers.com.notmuch>
 <036c80e5-4844-5c84-304c-7e553fe17a9b@kernel.dk>
 <64357608c396d_113ebd294ba@willemb.c.googlers.com.notmuch>
 <19c69021-dce3-1a4a-00eb-920d1f404cfc@kernel.dk>
 <64357bb97fb19_114b22294c4@willemb.c.googlers.com.notmuch>
 <20cb4641-c765-e5ef-41cb-252be7721ce5@kernel.dk>
 <ZDa32u9RNI4NQ7Ko@gmail.com>
 <6436c01979c9b_163b6294b4@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6436c01979c9b_163b6294b4@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 10:28:41AM -0400, Willem de Bruijn wrote:
> Breno Leitao wrote:
> > On Tue, Apr 11, 2023 at 09:28:29AM -0600, Jens Axboe wrote:
> > > On 4/11/23 9:24?AM, Willem de Bruijn wrote:
> > > > Jens Axboe wrote:
> > > >> On 4/11/23 9:00?AM, Willem de Bruijn wrote:
> > > >> But that doesn't work, because sock->ops->ioctl() assumes the arg is
> > > >> memory in userspace. Or do you mean change all of the sock->ops->ioctl()
> > > >> to pass in on-stack memory (or similar) and have it work with a kernel
> > > >> address?
> > > > 
> > > > That was what I suggested indeed.
> > > > 
> > > > It's about as much code change as this patch series. But it avoids
> > > > the code duplication.
> > > 
> > > Breno, want to tackle that as a prep patch first? Should make the
> > > functional changes afterwards much more straightforward, and will allow
> > > support for anything really.
> > 
> > Absolutely. I just want to make sure that I got the proper approach that
> > we agreed here.
> > 
> > Let me explain what I understood taking TCP as an example:
> > 
> > 1) Rename tcp_ioctl() to something as _tcp_ioctl() where the 'arg'
> > argument is now just a kernel memory (located in the stack frame from the
> > callee).
> > 
> > 2) Recreate "tcp_ioctl()" that will basically allocate a 'arg' in the
> > stack and call _tcp_ioctl() passing that 'arg' argument. At the bottom of
> > this (tcp_ioctl() function) function, call `put_user(in_kernel_arg, userspace_arg)
> > 
> > 3) Repeat it for the 20 protocols that implement ioctl:
> > 
> > 	ag  "struct proto .* = {" -A 20 net/ | grep \.ioctl
> > 	net/dccp/ipv6.c 	.ioctl	= dccp_ioctl,
> > 	net/dccp/ipv4.c		.ioctl	= dccp_ioctl,
> > 	net/ieee802154/socket.c .ioctl	= dgram_ioctl,
> > 	net/ipv4/udplite.c	.ioctl	= udp_ioctl,
> > 	net/ipv4/raw.c 		.ioctl	= raw_ioctl,
> > 	net/ipv4/udp.c		.ioctl	= udp_ioctl,
> > 	net/ipv4/tcp_ipv4.c 	.ioctl	= tcp_ioctl,
> > 	net/ipv6/raw.c		.ioctl	= rawv6_ioctl,
> > 	net/ipv6/tcp_ipv6.c	.ioctl	= tcp_ioctl,
> > 	net/ipv6/udp.c	 	.ioctl	= udp_ioctl,
> > 	net/ipv6/udplite.c	.ioctl	= udp_ioctl,
> > 	net/l2tp/l2tp_ip6.c	.ioctl	= l2tp_ioctl,
> > 	net/l2tp/l2tp_ip.c	.ioctl	= l2tp_ioctl,
> > 	net/phonet/datagram.:	.ioctl	= pn_ioctl,
> > 	net/phonet/pep.c	.ioctl	= pep_ioctl,
> > 	net/rds/af_rds.c	.ioctl	=	rds_ioctl,
> > 	net/sctp/socket.c	.ioctl  =	sctp_ioctl,
> > 	net/sctp/socket.c	.ioctl	= sctp_ioctl,
> > 	net/xdp/xsk.c		.ioctl	= sock_no_ioctl,
> > 	net/mptcp/protocol.c	.ioctl	= mptcp_ioctl,
> > 
> > Am I missing something?
> 
> The suggestion is to convert all to take kernel memory and do the
> put_cmsg in the caller of .ioctl. Rather than create a wrapper for
> each individual instance and add a separate .iouring_cmd for each.
> 
> "change all of the sock->ops->ioctl() to pass in on-stack memory
> (or similar) and have it work with a kernel address"

is it possible to do it for cases where we don't know what is the size
of the buffer?

For instance the raw_ioctl()/rawv6_ioctl() case. The "arg" argument is
used in different ways (one for input and one for output):

  1) If cmd == SIOCOUTQ or SIOCINQ, then the return value will be
  returned to userspace:
  	put_user(amount, (int __user *)arg)

  2) For default cmd, ipmr_ioctl() is called, which reads from the `arg`
  parameter:
	copy_from_user(&vr, arg, sizeof(vr)

How to handle these contradictory behaviour ahead of time (at callee
time, where the buffers will be prepared)?

Thank you!
