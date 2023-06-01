Return-Path: <netdev+bounces-7047-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6FB97196E6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:27:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C81E281700
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA25A1641D;
	Thu,  1 Jun 2023 09:27:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1B479DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2E9C433EF;
	Thu,  1 Jun 2023 09:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685611636;
	bh=F71V0LqFvJaV2Dh0oD8DhGsDszrCckaBPOEhZorcm1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tKtcfVQYOggy9UmUERLxPqYbXoYAVO62e6tciqk8bQfUD9g9DsX6CeQzsTHnYHHWN
	 R2xyBP+dPyeT/OPUJVDwUMVQNjVCeCeVMBPbS+enDc9j/zBifPwcO28qN3fCXvnFkX
	 j+szQYX8g+2CJLy7wH3nFl+CqazYnAfFfSedTtUug9WXQzRizLAnp0pahsdjUXBthu
	 /X3DPx2ctwAqmJ24mfV0liEwtRTFGKnWFxN4CWgb6HS/0urFc5XHHOo/OpAhnPVC+K
	 Om1gF8C8GVY6pNLvNvzUu0jRrr6oErLt1lOvxMa6H3m0WlbWp1qo+TQ6JPs82Uh5OC
	 grnybOg/2o/fw==
Date: Thu, 1 Jun 2023 05:27:15 -0400
From: Sasha Levin <sashal@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.14 20/20] mdio_bus: unhide mdio_bus_init
 prototype
Message-ID: <ZHhkcwyiRKuKE4js@sashalap>
References: <20230525184520.2004878-1-sashal@kernel.org>
 <20230525184520.2004878-20-sashal@kernel.org>
 <7f46f5c0-a5cb-4e4f-9201-2fd06e92e1ef@app.fastmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7f46f5c0-a5cb-4e4f-9201-2fd06e92e1ef@app.fastmail.com>

On Thu, May 25, 2023 at 10:05:01PM +0200, Arnd Bergmann wrote:
>On Thu, May 25, 2023, at 20:45, Sasha Levin wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> [ Upstream commit 2e9f8ab68f42b059e80db71266c1675c07c664bd ]
>>
>> mdio_bus_init() is either used as a local module_init() entry,
>> or it gets called in phy_device.c. In the former case, there
>> is no declaration, which causes a warning:
>>
>> drivers/net/phy/mdio_bus.c:1371:12: error: no previous prototype for
>> 'mdio_bus_init' [-Werror=missing-prototypes]
>>
>> Remove the #ifdef around the declaration to avoid the warning..
>
>Hi Sasha,
>
>While there is nothing wrong with backporting the -Wmissing-prototypes
>warning fixes I sent, there is also really no point unless you
>want to backport all 140 of them and then also turn on that warning
>during testing.
>
>The option is only enabled at the W=1 level or when using sparse (C=1).
>I hope to get these all done in 6.5 for the most common architectures,
>but I wouldn't bother putting them into stable kernels.

I'll go drop it. In general, we've been trying to avoid W=1 fixes but
sometimes they end up sneaking in, which is also okay...

-- 
Thanks,
Sasha

