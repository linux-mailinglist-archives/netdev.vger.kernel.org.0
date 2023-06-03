Return-Path: <netdev+bounces-7633-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1133D720E30
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:47:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1714281B9A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B248BF8;
	Sat,  3 Jun 2023 06:47:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71BDEA0
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195D0C433D2;
	Sat,  3 Jun 2023 06:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685774829;
	bh=P/JQIwHw329RgcOGeyoZZW0mkz7Vp24lgSp92HOX3v4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ih1SdQ5lmcY7aNSlZFGNtGGdBuWnSVM+dzXCd8jJBpa+ljSaXksehpRL3jHdnYlX8
	 KVta2K+2xJvv4ez/XAcb3yIyiGnI8/MXZqbq3YXp79Hn1xGYIZYsoVo385bt+el+G1
	 ntJKSAzKhbLTX6CrDCOnWnsYpp8XQ/OdeIERVfZ875uSDJZ3u5BPbYsUYa5gutsdOs
	 VYdSnErpoPbdhJKXNM1S5Hv3Xdzq6QddFHAZ4O+mndvfns01/bibl+JBulqB0QsBqN
	 6Kfw9SSpSCXi8RSrJ8c3lDTNS4otz9Jv0zXArrKUSPOd/HxpBBw79rb3ViUqF+/uMf
	 XQlZQntkJyOUA==
Date: Fri, 2 Jun 2023 23:47:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: <netdev@vger.kernel.org>, <davem@davemloft.net>,
 <brett.creeley@amd.com>, <drivers@pensando.io>, Nitya Sunkad
 <nitya.sunkad@amd.com>
Subject: Re: [PATCH net-next] ionic: add support for ethtool extended stat
 link_down_count
Message-ID: <20230602234708.03fbb00e@kernel.org>
In-Reply-To: <20230602173252.35711-1-shannon.nelson@amd.com>
References: <20230602173252.35711-1-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Jun 2023 10:32:52 -0700 Shannon Nelson wrote:
> Following the example of 9a0f830f8026 ("ethtool: linkstate: add a statistic
> for PHY down events"), added support for link down events.
> 
> Added callback ionic_get_link_ext_stats to ionic_ethtool.c to support
> link_down_count, a property of netdev that gets incremented every time
> the device link goes down.

Hm, could you say more about motivation? The ethtool stat is supposed to
come from HW and represent PHY-level flap count. It's used primarily to
find bad cables in a datacenter. Is this also the use case for ionic?
It's unclear to me whether ionic interfaces are seeing an actual PHY or
just some virtual link state of the IPU and in the latter case it's not
really a match.

