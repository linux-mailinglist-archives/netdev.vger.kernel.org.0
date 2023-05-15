Return-Path: <netdev+bounces-2505-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE26702466
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E945281093
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552984C9D;
	Mon, 15 May 2023 06:20:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4097F4C9B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:20:50 +0000 (UTC)
X-Greylist: delayed 530 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 May 2023 23:20:48 PDT
Received: from out-37.mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4E3E54
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 23:20:48 -0700 (PDT)
Date: Mon, 15 May 2023 02:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684131116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gQtZtkYSr01iPUQ02O9EobNAKFbxisOovLBX2ZmpB7g=;
	b=O9YpRD3DZPEXA9ewsr2sNqxtN7Vi/X8uluvLidZYd38LkD6FuRqZXWsgWVCxdOzOKNmXpD
	yAsKazwRFfkvObwLb+W6n0yNVX2ydTWdRJoYQPnW74kG3grbMjFO/L+6AV5QsviCIf3jwS
	JjU47Hg728g4OEulJNDfTCYZTiL6eek=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: FUJITA Tomonori <tomo@exabit.dev>
Cc: rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: Re: [PATCH 1/2] rust: add synchronous message digest support
Message-ID: <ZGHNKCY/2C5buW7O@moria.home.lan>
References: <20230515043353.2324288-1-tomo@exabit.dev>
 <010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 04:34:27AM +0000, FUJITA Tomonori wrote:
> From: FUJITA Tomonori <fujita.tomonori@gmail.com>
> 
> Adds abstractions for crypto shash.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> ---
>  rust/bindings/bindings_helper.h |   1 +
>  rust/helpers.c                  |  24 +++++++
>  rust/kernel/crypto.rs           | 108 ++++++++++++++++++++++++++++++++
>  rust/kernel/lib.rs              |   2 +

I think in the long run we're going to need Rust bindings located right
next to the .c files they're wrapping. Certainly modules will.

