Return-Path: <netdev+bounces-7742-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D700721599
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 10:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33E101C20B0C
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 08:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8022915C1;
	Sun,  4 Jun 2023 08:32:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757B923A8
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 08:32:24 +0000 (UTC)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0F4CF;
	Sun,  4 Jun 2023 01:32:22 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-3f6dfc4e01fso37681345e9.0;
        Sun, 04 Jun 2023 01:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685867541; x=1688459541;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tmjbEwC+EvHpQJk1Twlv6P50KkxdTvbJYvHxD52w32Q=;
        b=N1iEs2yZcbJ7foA1E6fJk8/1eHV0Jagxm5o46OYb1wxjSmzM0ht1D8bsqG0fWFFq2a
         M5IP2sKuKSMMpwwA6HjzkUhLxoQ3Mn7brLO7YYbjOq3Q5jKqxRN8rHJHaXnMzg9dtiP2
         Gr0RF7vyxh3/sUMe3PDBzcUHPCrTMdghMiV1Mdcz7Q79AkuC+z48kdWeJ/ZxAqN/y7oW
         0yv6h3Glqiq68h7D4zKrDBuSgqMMdyhficLEfzX8LeThrBXlPlABCrb4A4Xfvp0sw8a0
         PaSq6j3bGosD8+DNkgZJXe+yUQKo41gmBHhDZKi5Xw+ssvcWxm3ftJVdwXGMe/NHj4cp
         sfmA==
X-Gm-Message-State: AC+VfDy/0xt51xcTpz1b2ReeKvd4OpWG+FwDXAaY2TO3s2VBKtjxdhMK
	ZAWgSZNW55ECHs8jhMexCUI=
X-Google-Smtp-Source: ACHHUZ6+cxwT0hZDrAH8rQs4fsyRjVuc4sEaQ/pR2fTzJOb+wpcfcWkPwMFwZcGbbSj+lt0x8UeDRA==
X-Received: by 2002:a7b:c40a:0:b0:3f5:ce4:6c3f with SMTP id k10-20020a7bc40a000000b003f50ce46c3fmr5311256wmi.7.1685867540788;
        Sun, 04 Jun 2023 01:32:20 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-003.fbsv.net. [2a03:2880:31ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id w11-20020a1cf60b000000b003f423f5b659sm7172057wmc.10.2023.06.04.01.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 01:32:20 -0700 (PDT)
Date: Sun, 4 Jun 2023 01:32:18 -0700
From: Breno Leitao <leitao@debian.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Remi Denis-Courmont <courmisch@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	David Ahern <dsahern@kernel.org>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, axboe@kernel.dk,
	asml.silence@gmail.com, leit@fb.com, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, dccp@vger.kernel.org,
	linux-wpan@vger.kernel.org, mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next v5] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Message-ID: <ZHxMErkF/Yi/OD8z@gmail.com>
References: <20230602163044.1820619-1-leitao@debian.org>
 <CAF=yD-Kk9mVWPZN50NUu8uGwEbySNS-WzvJ=1HTTcVsA6OOuvA@mail.gmail.com>
 <ZHxEX0TlXX7VV9kX@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZHxEX0TlXX7VV9kX@gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 12:59:27AM -0700, Breno Leitao wrote:
> Hello Willem 
> 
> On Sat, Jun 03, 2023 at 10:21:50AM +0200, Willem de Bruijn wrote:
> > On Fri, Jun 2, 2023 at 6:31 PM Breno Leitao <leitao@debian.org> wrote:
> > > Signed-off-by: Breno Leitao <leitao@debian.org>
> > 
> > Please check the checkpatch output
> > 
> > https://patchwork.hopto.org/static/nipa/753609/13265673/checkpatch/stdout
> 
> I am checking my current checkpatch before sending the patch, but I am
> not seeing the problems above.
> 
> My tree is at 44c026a73be8038 ("Linux 6.4-rc3"), and I am not able to
> reproduce the problems above.
> 
> 	$ scripts/checkpatch.pl v5/v5-0001-net-ioctl-Use-kernel-memory-on-protocol-ioctl-cal.patch
> 	total: 0 errors, 0 warnings, 0 checks, 806 lines checked
> 	v5/v5-0001-net-ioctl-Use-kernel-memory-on-protocol-ioctl-cal.patch has no obvious style problems and is ready for submission.
> 
> Let me investigate what options I am missing when running checkpatch.

Investigating these issues, I see 4 of the following messages:

	WARNING: line length of 84 exceeds 80 columns

This implies that checkpatch.pl is being called with
`--max-line-length=80` parameter, or, the system is using an older
version, before bdc48fa11e46f ("checkpatch/coding-style: deprecate
80-column warning").

Since I am not familiar with patchwork.hopto.org, I am not sure what is
the case. Do you know how can I find out?

Thanks!

