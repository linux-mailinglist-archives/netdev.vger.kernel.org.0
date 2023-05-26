Return-Path: <netdev+bounces-5589-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D897B71230B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 929F1281767
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFBB2107BB;
	Fri, 26 May 2023 09:08:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C588510791
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:08:26 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1D3119;
	Fri, 26 May 2023 02:08:24 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-3f6e4554453so3497665e9.3;
        Fri, 26 May 2023 02:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685092103; x=1687684103;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hnjdta2dE7cZUbShKCPALgc1x0BwY8fg4ZbOYZFxvDQ=;
        b=ABUg+EIe8KVmD2x8ux8xk4yeF8I8pbtyhNrkkuqu+VkfVkeoXQca7o1E0GvjQzMgW1
         8lM8y57VqWfjx/GxPL0l/14BM/Ru8bG2Bpe2CQn0kbt15Y6oWWgUuLr5NmhD1mCeGLtX
         cW4LU5Z8cUlkwedS8PEGuUd8I1avdniZzrzI/AxijVQEG3Qki3h5iuyULm1CDIYUZmGA
         U2GRVPxcMtUYYmhlUkn3iZoIXe5IL7EPpLml/WgQwUxG1wWchJf9zeXfBSey/yD8qpO2
         QdCl/VMTlppn0UzIzeSWgXq0STqvdHVdqxqIwpReJilL706bnd1KmewMI/bi/BbB+2Lt
         082A==
X-Gm-Message-State: AC+VfDyelqBLPGKtndmF6D7bx8E871E8EB/HtsTc1w1KlMhMzpgIxXN6
	kYqZxOjgYEh9FIXZb+lj3Vw=
X-Google-Smtp-Source: ACHHUZ4p/3nG8JacOu4lntf8PDsfNQAKdvHffpyYEWND/ODkY+3Ld0CZ7UeCriq3kid1vvZt5c+H3A==
X-Received: by 2002:a1c:7c19:0:b0:3f6:3e9:e2dd with SMTP id x25-20020a1c7c19000000b003f603e9e2ddmr866855wmc.3.1685092103333;
        Fri, 26 May 2023 02:08:23 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-116.fbsv.net. [2a03:2880:31ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id e2-20020adffc42000000b002ff2c39d072sm4399743wrs.104.2023.05.26.02.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 02:08:22 -0700 (PDT)
Date: Fri, 26 May 2023 02:08:20 -0700
From: Breno Leitao <leitao@debian.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: David Ahern <dsahern@kernel.org>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, leit@fb.com, axboe@kernel.dk,
	asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, dccp@vger.kernel.org,
	linux-wpan@vger.kernel.org, mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Message-ID: <ZHB3BNopbx+5AnIa@gmail.com>
References: <20230525125503.400797-1-leitao@debian.org>
 <CAF=yD-LHQNkgPb-R==53-2auVxkP9r=xqrz2A8oe61vkoDdWjg@mail.gmail.com>
 <a1074987-c3ce-56cd-3005-beb5a3c55ef9@kernel.org>
 <CAF=yD-LXcufhJBpkEcUuphFpR1TA4=QwUXw4sKFsSiEL_mwG4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF=yD-LXcufhJBpkEcUuphFpR1TA4=QwUXw4sKFsSiEL_mwG4Q@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 12:06:00PM -0400, Willem de Bruijn wrote:
> On Thu, May 25, 2023 at 11:34 AM David Ahern <dsahern@kernel.org> wrote:
> > On 5/25/23 9:05 AM, Willem de Bruijn wrote:
> > > I don't understand what this buys us vs testing the sk_family,
> > > sk_protocol and cmd here.
> >
> > To keep protocol specific code out of core files is the reason I
> > suggested it.
> 
> I guess you object to demultiplexing based on per-family
> protocol and ioctl cmd constants directly in this file?
> 
> That only requires including the smaller uapi headers.
> 
> But now net/core/sock.h now still has to add includes
> linux/mroute.h, linux/mroute6.h and net/phonet/phonet.h.
> 
> Aside on phonet_is_sk, if we're keeping this: this should be
> sk_is_phonet? Analogous to sk_is_tcp and such. And, it should suffice
> to  demultiplex based on the protocol family, without testing the
> type or protocol. The family is defined in protocol-independent header
> linux/socket.h. The differences between
> PN_PROTO_PHONET and PN_PROTO_PIPE should be handled inside the family
> code. So I think it is cleaner just to open-coded as `if
> (sk->sk_family == PF_PHONET)`

Should we do the same for ipmr as well? Currently I am checking it
using:

	return sk->sk_type == SOCK_RAW && inet_sk(sk)->inet_num == IPPROTO_ICMPV6;

This is what ip{6}mr functions[1] are use to check if `sk` is using ip{6}mr.
If we just use `sk->family`, then I suppose that `sk_is_ip6mr` would be
something as coded below. Is this correct?

	static inline int sk_is_ip6mr(struct sock *sk)
	{
		return sk->sk_family == PF_INET6;
	}

Anyway, should we continue with the current (V3) approach, where we keep
the protocol code out of core files, or, should I come back to the
previous (V2) approach, where the protocol checks is coded directly in
the core file?

Thanks for the review!
[1] Link: https://github.com/torvalds/linux/blob/0d85b27b0cc6b5cf54567c5ad913a247a71583ce/net/ipv6/ip6mr.c#L1666

