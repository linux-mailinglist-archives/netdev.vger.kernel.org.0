Return-Path: <netdev+bounces-486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 891276F7B62
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 05:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91BFA1C21622
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 03:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E837B1376;
	Fri,  5 May 2023 03:10:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D8615A0
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 03:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A12C4339B;
	Fri,  5 May 2023 03:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683256245;
	bh=gP3JbVoAhEnIdGZE2LS46LHhS04/ifjlGArPARUVVNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ibrg3YVuFtyXb4k16mgcJgSavi6YbYoby/Y8esJ9s7p7dj9sMAR8jeiyDopqB/eWv
	 eexn0n0n0VB0yzbKPKbRcnkHqwy9UUrPitBGcq1rpLIsS7PFL6E8Ey/bg7yJprCcWH
	 fUpmt9d/UZggxd8ZNvyDbpLRlMZXymVqeZEJXl8CGWHAq3nfiiCg5nCeDnwKI8OzLy
	 ZWyk887VLoGqh85tJgD5RGWntrg96PU6gVAHS6TwW+5rTA59hGK4edP847jlMzZYMX
	 zQ9r5RfEB9a/8gxPoDG+cePmPBk0UWsdfv3TCyeNd9Ya/B45VmjrOXHVKfIlmWfvXD
	 OkkX902W59t5Q==
Date: Thu, 4 May 2023 21:10:43 -0600
From: David Ahern <dsahern@kernel.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Aleksey Shumnik <ashumnik9@gmail.com>, netdev@vger.kernel.org,
	waltje@uwalt.nl.mugnet.org, Jakub Kicinski <kuba@kernel.org>,
	gw4pts@gw4pts.ampr.org, kuznet@ms2.inr.ac.ru,
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
	gnault@redhat.com
Subject: Re: [BUG] Dependence of routing cache entries on the ignore-df flag
Message-ID: <20230505031043.GA4009@u2004-local>
References: <CAJGXZLjLXrUzz4S9C7SqeyszMMyjR6RRu52y1fyh_d6gRqFHdA@mail.gmail.com>
 <20230503113528.315485f1@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503113528.315485f1@hermes.local>

On Wed, May 03, 2023 at 11:35:28AM -0700, Stephen Hemminger wrote:
> On Wed, 3 May 2023 18:01:03 +0300
> Aleksey Shumnik <ashumnik9@gmail.com> wrote:
> 
> > Might you answer the questions:
> > 1. How the ignore-df flag and adding entries to the routing cache is
> > connected? In which kernel files may I look to find this connection?
> > 2. Is this behavior wrong?
> > 3. Is there any way to completely disable the use of the routing
> > cache? (as far as I understand, it used to be possible to set the
> > rhash_entries parameter to 0, but now there is no such parameter)
> > 4. Why is an entry added to the routing cache if a suitable entry was
> > eventually found in the arp table (it is added directly, without being
> > temporarily added to the routing table)?
> 
> What kernel version. The route cache has been completely removed from
> the kernel for a long time.

These are exceptions (fib_nh_exception), not the legacy routing cache.


