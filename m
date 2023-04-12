Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496256DF7BD
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjDLNxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjDLNxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:53:37 -0400
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A5C269D;
        Wed, 12 Apr 2023 06:53:35 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id he13so11588055wmb.2;
        Wed, 12 Apr 2023 06:53:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681307613; x=1683899613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMUJR0ziXAKL97/Fc/1XtofHlhmh4dw/ld6x3YBdDJA=;
        b=c5MznV+FSP9GQAzDIL6X6/HEUkHgbTxoYZJJLSLa7kNIz6rQjxCusoEcnI2o4F16x0
         pK1ouAwgtZkTGMWiEbd/iuZuC7jNucujWU95hUNkGWnIjlmmqsHCGZy/w2WGGinHkVyP
         zWa2LL436y+y8u46Uw7UAgry6owUNKo/r1hN7mMXp/w9IiLamDP27IXESFTWin5PKcDE
         qoh6B+gPYHk77EjioF1tMS41pxjVSIk5tggZXTmSmDFVECZsOQSjqPZPaUns9yP6/OSd
         Pq/ZKPhP2tLmUpmMCMdV2/0YIShlgD7I20mx1ZhvXnEPZu1SSr85pVZIphIAanfPWFMk
         rjyw==
X-Gm-Message-State: AAQBX9cF7iP+isOo70nbHKm20K+lhRQfKHaHInTm2BbreG2iJ3naTCfl
        BFVGgXi4xe5fh3j4TfGaPFY=
X-Google-Smtp-Source: AKy350a7suuVGRUdrJzLxBrp2tG07AraETPQmB+GH8IgY+nxp+FZeY/RzoijoKarE9xMi9XKLFzzAw==
X-Received: by 2002:a05:600c:3658:b0:3ef:7594:48cc with SMTP id y24-20020a05600c365800b003ef759448ccmr9450881wmq.23.1681307613395;
        Wed, 12 Apr 2023 06:53:33 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-024.fbsv.net. [2a03:2880:31ff:18::face:b00c])
        by smtp.gmail.com with ESMTPSA id m2-20020a05600c3b0200b003f0652084b8sm2540633wms.20.2023.04.12.06.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:53:32 -0700 (PDT)
Date:   Wed, 12 Apr 2023 06:53:30 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        asml.silence@gmail.com, leit@fb.com, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, dccp@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        matthieu.baerts@tessares.net, marcelo.leitner@gmail.com
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Message-ID: <ZDa32u9RNI4NQ7Ko@gmail.com>
References: <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
 <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
 <643573df81e20_11117c2942@willemb.c.googlers.com.notmuch>
 <036c80e5-4844-5c84-304c-7e553fe17a9b@kernel.dk>
 <64357608c396d_113ebd294ba@willemb.c.googlers.com.notmuch>
 <19c69021-dce3-1a4a-00eb-920d1f404cfc@kernel.dk>
 <64357bb97fb19_114b22294c4@willemb.c.googlers.com.notmuch>
 <20cb4641-c765-e5ef-41cb-252be7721ce5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20cb4641-c765-e5ef-41cb-252be7721ce5@kernel.dk>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 09:28:29AM -0600, Jens Axboe wrote:
> On 4/11/23 9:24?AM, Willem de Bruijn wrote:
> > Jens Axboe wrote:
> >> On 4/11/23 9:00?AM, Willem de Bruijn wrote:
> >> But that doesn't work, because sock->ops->ioctl() assumes the arg is
> >> memory in userspace. Or do you mean change all of the sock->ops->ioctl()
> >> to pass in on-stack memory (or similar) and have it work with a kernel
> >> address?
> > 
> > That was what I suggested indeed.
> > 
> > It's about as much code change as this patch series. But it avoids
> > the code duplication.
> 
> Breno, want to tackle that as a prep patch first? Should make the
> functional changes afterwards much more straightforward, and will allow
> support for anything really.

Absolutely. I just want to make sure that I got the proper approach that
we agreed here.

Let me explain what I understood taking TCP as an example:

1) Rename tcp_ioctl() to something as _tcp_ioctl() where the 'arg'
argument is now just a kernel memory (located in the stack frame from the
callee).

2) Recreate "tcp_ioctl()" that will basically allocate a 'arg' in the
stack and call _tcp_ioctl() passing that 'arg' argument. At the bottom of
this (tcp_ioctl() function) function, call `put_user(in_kernel_arg, userspace_arg)

3) Repeat it for the 20 protocols that implement ioctl:

	ag  "struct proto .* = {" -A 20 net/ | grep \.ioctl
	net/dccp/ipv6.c 	.ioctl	= dccp_ioctl,
	net/dccp/ipv4.c		.ioctl	= dccp_ioctl,
	net/ieee802154/socket.c .ioctl	= dgram_ioctl,
	net/ipv4/udplite.c	.ioctl	= udp_ioctl,
	net/ipv4/raw.c 		.ioctl	= raw_ioctl,
	net/ipv4/udp.c		.ioctl	= udp_ioctl,
	net/ipv4/tcp_ipv4.c 	.ioctl	= tcp_ioctl,
	net/ipv6/raw.c		.ioctl	= rawv6_ioctl,
	net/ipv6/tcp_ipv6.c	.ioctl	= tcp_ioctl,
	net/ipv6/udp.c	 	.ioctl	= udp_ioctl,
	net/ipv6/udplite.c	.ioctl	= udp_ioctl,
	net/l2tp/l2tp_ip6.c	.ioctl	= l2tp_ioctl,
	net/l2tp/l2tp_ip.c	.ioctl	= l2tp_ioctl,
	net/phonet/datagram.:	.ioctl	= pn_ioctl,
	net/phonet/pep.c	.ioctl	= pep_ioctl,
	net/rds/af_rds.c	.ioctl	=	rds_ioctl,
	net/sctp/socket.c	.ioctl  =	sctp_ioctl,
	net/sctp/socket.c	.ioctl	= sctp_ioctl,
	net/xdp/xsk.c		.ioctl	= sock_no_ioctl,
	net/mptcp/protocol.c	.ioctl	= mptcp_ioctl,

Am I missing something?

Thanks!
