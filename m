Return-Path: <netdev+bounces-235-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 295186F6304
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 04:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3CA9280CF3
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 02:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90AA0EA9;
	Thu,  4 May 2023 02:51:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFA87C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 02:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EA1C433EF;
	Thu,  4 May 2023 02:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683168673;
	bh=TnwMlGv6Qw2TzF5oaBzqcI3VQa7c6Ci9g+LKwc22PKg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=V8Lmbda9AfkZ0KlL+FdWfPA1FP2Ipp6+s3IsSIuhu4hAC24QEKQYlLz4ZVyFdzABO
	 iTtf+78F5Oa9urKcAhpk5w8vAkoXL756HfqkE7xF4ttaQIwd8e0lSx3Szx22rbBhIh
	 MYTCGDrpJyZ9oT7jTiBB0NkoVtx6IfrQOff52YR7OOEWbV2Q/ZbPdyfojyjxJNpvmX
	 Ar28BGOAcKpQYRByZJIpqqWNkjD6iaukMiP06ez8fkI5U/Rpy0imxdQvIs+RLZ0UVg
	 H26JNLiVMpLOP31n3zLQ42+A6BvQRMeU1nPoNjJauXxEfLQgmaX1mO+/8gFXSaYfG3
	 VALpMaU07L9Wg==
Date: Wed, 3 May 2023 19:51:12 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Martin Wetterwald <martin@wetterwald.eu>
Cc: davem@davemloft.net, dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ipconfig: Allow DNS to be overwritten by DHCPACK
Message-ID: <20230503195112.23adbe7b@kernel.org>
In-Reply-To: <CAFERDQ1yq=jBGu8e2qJeoNFYmKt4jeB835efsYMxGLbLf4cfbQ@mail.gmail.com>
References: <CAFERDQ1yq=jBGu8e2qJeoNFYmKt4jeB835efsYMxGLbLf4cfbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 May 2023 12:06:53 +0200 Martin Wetterwald wrote:
> Because DNS servers were only specified in the DHCPACK and not in the
> DHCPOFFER, Linux will not catch the correct DNS servers: in the first
> BOOTP reply (DHCPOFFER), it sees that there is no DNS, and sets as
> fallback the IP of the DHCP server itself. When the second BOOTP reply
> comes (DHCPACK), it's already too late: the kernel will not overwrite
> the fallback setting it has set previously.

Could we not remember that the address present is a fallback and let
the DHCPACK overwrite it?

