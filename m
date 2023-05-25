Return-Path: <netdev+bounces-5224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A0671052B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:11:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2EF81C20D30
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C8A5250;
	Thu, 25 May 2023 05:11:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5596199
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20665C4339B;
	Thu, 25 May 2023 05:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684991508;
	bh=a0tzE9UDpxf2Gv03EAySk423E9WJbttajURADQK6RpY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E+prJKSG6S1YLfI14dLgGo1xJFb3uRkM/dPsvsquftreGTEc4mdpGqCTE7w1vcjIj
	 vXMGcd2WHPPBm1xLHJDAP249/W6Mjfg3E1wmwyNnriWw5w6b2O48gkDtDkdrifnm1o
	 dVEl9xgtqcSrvqF9PsN5b4phTeSzfIA8mVgdMgaaj9Ww8A1OtUxS2OZhLGE9GyqD9P
	 c/H04SuRMQyVKw3raKrejRwKGEX+ueVginsBjR+mXRD1JokoUZucIdWlb6z37Szt2f
	 we9Y9GD0a5ZcpY+bQ+CiF+F4ncxe/vM8aRqCaCPwGGjMNcIc6pNuAtIvQ5g91kxp2P
	 a4yZbJWlTgikA==
Date: Wed, 24 May 2023 22:11:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
 xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Subject: Re: [PATCH] xen/netback: Pass (void *) to virt_to_page()
Message-ID: <20230524221147.5791ba3a@kernel.org>
In-Reply-To: <20230523140342.2672713-1-linus.walleij@linaro.org>
References: <20230523140342.2672713-1-linus.walleij@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 16:03:42 +0200 Linus Walleij wrote:
> virt_to_page() takes a virtual address as argument but
> the driver passes an unsigned long, which works because
> the target platform(s) uses polymorphic macros to calculate
> the page.
> 
> Since many architectures implement virt_to_pfn() as
> a macro, this function becomes polymorphic and accepts both a
> (unsigned long) and a (void *).
> 
> Fix this up by an explicit (void *) cast.

Paul, Wei, looks like netdev may be the usual path for this patch 
to flow thru, although I'm never 100% sure with Xen.
Please ack or LUK if you prefer to direct the patch elsewhere?

