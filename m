Return-Path: <netdev+bounces-1074-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43EB46FC164
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 565E31C20B15
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3C317AC5;
	Tue,  9 May 2023 08:11:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC9C17AD3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04613C433EF;
	Tue,  9 May 2023 08:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683619858;
	bh=WXMC7u/DQzxADg0YM9i8LeJYiu5SJNEj74paM0J7l50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kj5o24cUk7Fa6tWkPQ+fy3OzF18n7Rb3TJ3AknPltp0rmPFfRqJ0DZsguxTC1cZtb
	 ir8aVE+Miud7+m014RyDeZeQFlsx1u9ddcOTB1rMprGWG02iQf8RgcJPujrpbAwJvz
	 9ONuXZtFnKT9NtoKpbzt8c6/AW0RiUNadhQVfg2U9UqSZoMlvKXLGegWtIBdBjTBqm
	 11k8jlRXmdgDQD0v2dsmAw1u1gcT0LoyiwwmW41d51MPriwGHVqkbMaGRjuHjc1jTG
	 1+3EB47ENNLW4fJkSzXHutMml0UCCrKg/aXyFg2REz5YJgW99/3BkmMhZ8l+X7lYGW
	 LuCAHd1Z19YlQ==
Date: Tue, 9 May 2023 11:10:54 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: skbuff: remove special handling for SLOB
Message-ID: <20230509081054.GH38143@unreal>
References: <20230509071207.28942-1-lukas.bulwahn@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509071207.28942-1-lukas.bulwahn@gmail.com>

On Tue, May 09, 2023 at 09:12:07AM +0200, Lukas Bulwahn wrote:
> Commit c9929f0e344a ("mm/slob: remove CONFIG_SLOB") removes CONFIG_SLOB.
> Now, we can also remove special handling for socket buffers with the SLOB
> allocator. The code with HAVE_SKB_SMALL_HEAD_CACHE=1 is now the default
> behavior for all allocators.
> 
> Remove an unnecessary distinction between SLOB and SLAB/SLUB allocator
> after the SLOB allocator is gone.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  net/core/skbuff.c | 17 -----------------
>  1 file changed, 17 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

