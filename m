Return-Path: <netdev+bounces-5225-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E8071052D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBB5D2814A1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC88A5C98;
	Thu, 25 May 2023 05:12:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2121FDA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54B4C433EF;
	Thu, 25 May 2023 05:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684991569;
	bh=gx6rfY8zkLlGyaW9DzoBbw69iftNsi3UHSSsrPAeD1o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CZGzlNOxbgpVc1jwE5hJ9N25DOVM2hHKBkE10Fx8i/mMokENlE+s1WXgpJlAIP2zE
	 AV3a6r5qQWo1+V2e+WUPc5i0JqACbO3iVpEWbm6EOsInBQitUVTlPrO5nkzBtpp3gm
	 EMwHARxeNvvDR8FNYkJkxr56fJgaElTTt+cm1ejbnGGXiM8kTprHe20/b0zVsZKlrq
	 RUBI1LwUpsT7Iqt4cOryXHpZ9RHE0kTOb++OAPVdO9AWLkCtmpnXrb1ogiY76AAX3y
	 P5AZwPFdO++llcitqp9a9zDseEXr54y31KCae+z1boirxvyIHacGuk1mjY9kQsuNSg
	 +Ad/B5k5e3UWg==
Date: Wed, 24 May 2023 22:12:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
 xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Subject: Re: [PATCH] xen/netback: Pass (void *) to virt_to_page()
Message-ID: <20230524221247.1dc731a8@kernel.org>
In-Reply-To: <20230524221147.5791ba3a@kernel.org>
References: <20230523140342.2672713-1-linus.walleij@linaro.org>
	<20230524221147.5791ba3a@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 22:11:47 -0700 Jakub Kicinski wrote:
> On Tue, 23 May 2023 16:03:42 +0200 Linus Walleij wrote:
> > virt_to_page() takes a virtual address as argument but
> > the driver passes an unsigned long, which works because
> > the target platform(s) uses polymorphic macros to calculate
> > the page.
> > 
> > Since many architectures implement virt_to_pfn() as
> > a macro, this function becomes polymorphic and accepts both a
> > (unsigned long) and a (void *).
> > 
> > Fix this up by an explicit (void *) cast.  
> 
> Paul, Wei, looks like netdev may be the usual path for this patch 
> to flow thru, although I'm never 100% sure with Xen.
> Please ack or LUK if you prefer to direct the patch elsewhere?

Ugh, Wei already acked this, sorry for the noise.

