Return-Path: <netdev+bounces-8237-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E70F723398
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B47011C20D95
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D68428C01;
	Mon,  5 Jun 2023 23:15:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D825256
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 23:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECDDC433EF;
	Mon,  5 Jun 2023 23:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686006908;
	bh=LfZT+W2zd/wtCkYMnlQXnDXsSDnir+aiPBuZHZd/lFY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ptA7arO3swekA7BEROfhfCfRgtCWh5FVD8w7uCY0qyuwjUzb1py0ysqnaaQgjuNTV
	 6o8xxliOCGw4pr6FfL2RKCYQOdUuSDrxAVtUH/1tuavA4JR/3ufiOO5Y5Ehl3EtsNC
	 E9X2yU20H1abfjsyR6ozTErsMJ0zcoTLzAYwgaJR9RyPqGPNE9dg0La7ETPkm+7Lqg
	 L7NZz/L4Zk+oKN9YPbwEKoM0ZMBAvTiQGKZDz/my5E9MiZUjmXk/m8CZSFAIG8fnWj
	 aWJW87+Q2n6SkHMkdWF6ESF17ztmxWmvVlJmvgu0+XAdckZOetpPlTyW09v8ZZquBh
	 pM80L9oPKUoqA==
Date: Mon, 5 Jun 2023 16:15:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Asmaa Mnebhi <asmaa@nvidia.com>
Cc: <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
 <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
 <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>, David Thompson
 <davthompson@nvidia.com>
Subject: Re: [PATCH net-next v1 1/1] mlxbf_gige: Fix kernel panic at
 shutdown
Message-ID: <20230605161507.654a3c1b@kernel.org>
In-Reply-To: <20230602182443.25514-1-asmaa@nvidia.com>
References: <20230602182443.25514-1-asmaa@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Jun 2023 14:24:43 -0400 Asmaa Mnebhi wrote:
> There is a race condition happening during shutdown due to pending napi transactions.
> Since mlxbf_gige_poll is still running, it tries to access a NULL pointer and as a
> result causes a kernel panic.
> To fix this during shutdown, invoke mlxbf_gige_remove to disable and dequeue napi.
> 
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>

Judging by the Fixes tag the problem can happen on 6.4-rc5 already,
right? So the tree in the [PATCH ] tag should have been net rather
than net-next?

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#git-trees-and-patch-flow

No need to repost confirmation is enough.

