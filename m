Return-Path: <netdev+bounces-1304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C28C6FD3D3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 04:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAB0A281316
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 02:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E9C398;
	Wed, 10 May 2023 02:27:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC14D362
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CDFC433D2;
	Wed, 10 May 2023 02:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683685620;
	bh=cN0Zpp3nHcYA73LBWkAJJmQrp5R/ZueRrOEoHH93crM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AH4HBOXQ4c+QTwsy5Y4zsYIv19Q+xSPT0PKhTBTMtf3h3PPP9aq17NdyydL0rWU26
	 HF/BFdbhbayZ3XUNDZWfYAwCVDBgYRP2tc+6UUUz0VRs1C15TSRIK6d9D/7eA9qEU8
	 6rR0NdvH9z49wQa315z/xKDYkctlC1bP0kPdTUcnMF7arKdknTsrnfID+sx/JxlAwT
	 cnIB+8puquAWZTRerX//0yJuI8yji27y3DfyiMoA8alAER76soB4PqUVs/lZdt/dDd
	 uoyFwQyO/UqZaESqXRJaF1e9TJEhzdoT+OGnj1H3FuX30Bhp3kohpxQjuvFCrrpJsa
	 72KQaPjUp0VGA==
Date: Tue, 9 May 2023 19:26:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Abel Vesa <abel.vesa@linaro.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, David Miller
 <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Anirudh
 Venkataramanan <anirudh.venkataramanan@intel.com>, Jeff Kirsher
 <jeffrey.t.kirsher@intel.com>, Bjorn Andersson <andersson@kernel.org>
Subject: Re: linux-next: build failure after merge of the mmc tree
Message-ID: <20230509192658.56cfb27b@kernel.org>
In-Reply-To: <20230510111833.17810885@canb.auug.org.au>
References: <20230510111833.17810885@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 May 2023 11:18:33 +1000 Stephen Rothwell wrote:
> Hi all,
> 
> After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> error: the following would cause module name conflict:
>   drivers/soc/qcom/ice.ko
>   drivers/net/ethernet/intel/ice/ice.ko
> 
> Exposed by commit
> 
>   31dd43d5032a ("mmc: sdhci-msm: Switch to the new ICE API")
> 
> I have used the mmc tree from next-20230509 for today.

Looks like the driver itself came from:

commit 2afbf43a4aec6e31dac7835e65d52c867f2be400
Author: Abel Vesa <abel.vesa@linaro.org>
Date:   Fri Apr 7 13:50:26 2023 +0300

    soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver

? The Intel Ethernet driver is 5 years old:

commit 837f08fdecbe4b2ffc7725624342e73b886665a8
Author: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Date:   Tue Mar 20 07:58:05 2018 -0700

    ice: Add basic driver framework for Intel(R) E800 Series

so AFAIU the MMC driver needs a new name?

