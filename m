Return-Path: <netdev+bounces-3155-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 872DA705CAB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 827C21C20C67
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41B717E0;
	Wed, 17 May 2023 01:52:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A53917D0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED856C433EF;
	Wed, 17 May 2023 01:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684288322;
	bh=NyO5buGlSkQeWw6wcFfVazzOCq+khLkllTWwBcczuR8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Cd4H2uJjhvHnNI8/FLEVHZwdawgRwR34IjVB57L8gwi59PL0ufdzlNJCjFkECd8Uy
	 dl3sWr69Wgler/i6VmaoZr5FxEem93ns549v4703hElD7c5DXlUjO+8xW/BjWE8pn/
	 8hTxSkBCPcDfHdrp74XLFkrH2f/iUaR27HnrotegtVMYo6tWtbE8we8enWbBWLvqUk
	 p57//C7BWylVWIAdwl/GzFmrOUVQIv8DITswg4vS4xxt5ION2TIFTj3cX8fK+MuHwD
	 eA7j4qohjKM+kpifs6faMzb4yy47CUtxZGibiOu+IbNhj96j+nKQMjwWWlzzwRlKcQ
	 yhryCGgr8/xPQ==
Date: Tue, 16 May 2023 18:52:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <ttoukan.linux@gmail.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
 drort@nvidia.com, samiram@nvidia.com, Gal Pressman <gal@nvidia.com>
Subject: Re: [RFC / RFT net 0/7] tls: rx: strp: fix inline crypto offload
Message-ID: <20230516185201.740afa55@kernel.org>
In-Reply-To: <939fd42c-d451-0927-abd8-877c867958bb@gmail.com>
References: <20230511012034.902782-1-kuba@kernel.org>
	<271c4388-cbb2-7d4f-22dd-9c73a4becf09@nvidia.com>
	<939fd42c-d451-0927-abd8-877c867958bb@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 15:27:51 +0300 Tariq Toukan wrote:
> Here's an updated testing status:
> 
> 1. Reported issue is resolved.
> 2. All device-offload TLS RX/TX tests passed, except for the one issue 
> below.
> 
> Nothing indicates that this issue is new or related directly to your 
> fixes series. It might have been there for some time, hiding behind the 
> existing bugs.
> 
> Issue description:
> TlsDecryptError / TlsEncryptError increase when simultaneously creating 
> a bond interface.
> It doesn't happen each and every time. It reproduced several times in 
> different runs.
> The strange part is that the bond is created and attached to a different 
> interface, not the one running the TLS traffic!

Hm, that's pretty odd / scary. LMK if you hit a dead end, I hope 
it's not a memory corruption :S

> I think we should progress with the fixes:
> Tested-by: Shai Amiram <samiram@nvidia.com>

Thanks!

