Return-Path: <netdev+bounces-7809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A0F8721907
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 20:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1F57281197
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 18:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCD110948;
	Sun,  4 Jun 2023 18:02:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CE7883C
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 18:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AFCC433EF;
	Sun,  4 Jun 2023 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685901732;
	bh=tsgHg/5R2crKomKyj+7Pho6UFoS2AQKQ8Lkd87r9ko8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VPSCfy/0/VfmjnkJ26s0+N3hVhu4/HnrUCquzI2efOtUvDs/4Yi/JlPrsd6b8FGRP
	 TyJA63shtiLXlSp/yXjn24pXjiAID96auxASntrPNEF0UlR20gOlNB4B19siwHEReV
	 YXzZtRNHKcfkTKg5pZZ5yscqbcv2C/Cdn9lEK+oOgM8n5x0G0biqmaW1qSXevUP/64
	 VB8+4Sz9RdRD9EYH2/JGjHGVRbcSZyqYd/mWdQSJbck9euIo+KjHYtBIH+79oSfRrE
	 nIjjdTwBqhBroLQzxaKfpO5LPZ6XepshB3PXgabN5/RDVX1omJghFQYfI4eDAIRFVM
	 5NMZfTgqRNE4A==
Date: Sun, 4 Jun 2023 11:02:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: Luca Boccassi <bluca@debian.org>, Christian Brauner
 <brauner@kernel.org>, davem@davemloft.net, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Leon Romanovsky <leon@kernel.org>, David Ahern
 <dsahern@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook
 <keescook@chromium.org>, Kuniyuki Iwashima <kuniyu@amazon.com>, Lennart
 Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v6 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230604110211.3f6401c6@kernel.org>
In-Reply-To: <CAEivzxcTEghPqk=9hQMReSGzE=ruWnJyiuPhW5rGd7eUOEg12A@mail.gmail.com>
References: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
	<20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
	<20230522133409.5c6e839a@kernel.org>
	<20230523-flechten-ortsschild-e5724ecc4ed0@brauner>
	<CAMw=ZnS8GBTDV0rw+Dh6hPv3uLXJVwapRFQHLMYEYGZHNoLNOw@mail.gmail.com>
	<20230523140844.5895d645@kernel.org>
	<CAEivzxeS2J5i0RJDvFHq-U_RAU5bbKVF5ZbphYDGoPcMZTsE3Q@mail.gmail.com>
	<CAMw=ZnRmNaoRb2uceatrV8EAufJSKZzD2AsfT5PJE8NBBOrHCg@mail.gmail.com>
	<20230524081933.44dc8bea@kernel.org>
	<CAEivzxcTEghPqk=9hQMReSGzE=ruWnJyiuPhW5rGd7eUOEg12A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 17:45:25 +0200 Aleksandr Mikhalitsyn wrote:
> > How about you put the UNIX -> bool patch at the end of the series,
> > (making it a 4 patch series) and if there's a discussion about it
> > I'll just skip it and apply the first 3 patches?  
> 
> Sure, I will do that!

Hi Aleksandr! Did you disappear? Have I missed v7?

