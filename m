Return-Path: <netdev+bounces-10988-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F61730EF2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C4E71C20E16
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF838818;
	Thu, 15 Jun 2023 06:01:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5AF810
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E34C433C0;
	Thu, 15 Jun 2023 06:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686808889;
	bh=BbLWfzMuToidV1olsCdEhXwJZyAe6DRdZKAiDQJ2H8E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=APtdWpaKInSMXgvKpbNr2GFwNf4hAGNNFVD72sz11/9tReEpp71sDx3zppVs7Bt4h
	 4vd+AHHpgBYY5MRgHgaYqeqLZLFzdSDStRFZfqFXSpYdYLe87rYbTjQ8IwCZ3ZXJJW
	 YKnkrdzspLcK9qjrpRVZftxVIDgmYE3bxUVpKylXL0sUwILzAEoDS4QFK9BNIEcFBC
	 lZxnNeHK2yvRlptP6uck4YjqMJqnndPrserdSoVrFIsVI22xSAbHAztUGcUJycodaH
	 wxeVAfmF3AmS7OjMzZuL6ut114zeLo97s7MC4zdfH/IuuUVm0jq57LDPBz7Ca7nbqM
	 IqhFRwQ57owWg==
Date: Wed, 14 Jun 2023 23:01:28 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 aliceryhl@google.com, andrew@lunn.ch, miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <20230614230128.199724bd@kernel.org>
In-Reply-To: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Jun 2023 13:53:21 +0900 FUJITA Tomonori wrote:
> This patchset adds minimum Rust abstractions for network device
> drivers and an example of a Rust network device driver, a simpler
> version of drivers/net/dummy.c.
> 
> The dummy network device driver doesn't attach any bus such as PCI so
> the dependency is minimum. Hopefully, it would make reviewing easier.
> 
> Thanks a lot for reviewing on RFC patchset at rust-for-linux ml.
> Hopefully, I've addressed all the issues.

First things first, what are the current expectations for subsystems
accepting rust code?

I was hoping someone from the Rust side is going to review this.
We try to review stuff within 48h at netdev, and there's no review :S

My immediate instinct is that I'd rather not merge toy implementations
unless someone within the netdev community can vouch for the code.

>  rust/bindings/bindings_helper.h |   3 +
>  rust/helpers.c                  |  23 ++
>  rust/kernel/lib.rs              |   3 +
>  rust/kernel/net.rs              |   5 +
>  rust/kernel/net/dev.rs          | 697 ++++++++++++++++++++++++++++++++
>  samples/rust/Kconfig            |  12 +
>  samples/rust/Makefile           |   1 +
>  samples/rust/rust_net_dummy.rs  |  81 ++++
>  scripts/Makefile.build          |   2 +-

You seem to create a rust/net/ directory without adding anything 
to MAINTAINERS. Are we building a parallel directory structure?
Are the maintainers also different?
-- 
pw-bot: defer

