Return-Path: <netdev+bounces-10477-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DEF072EADA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:24:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D7681C2087D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9BEB3D38A;
	Tue, 13 Jun 2023 18:24:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A3E38CA4
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 18:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6ADC433D9;
	Tue, 13 Jun 2023 18:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686680677;
	bh=A005nyPSR9jUxTXYuLs+acV5N0eBgSvqxWNwQk/+X+s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pPYkCBz6dfGob5Odf1vnwK7Fvz8kgt3dGA/BrjEJZU0hVWQvfLEm5yVHc7b9DuQWl
	 igVUgkwfDV52ZKOoQ1qrVXhLN0LkUUMtbS/GfUm4ANYJaZaEKxsW9jJUP8Qs/LxS3H
	 C284kHAhdYN5RqH5fKzonoM2hMYe//DuZho3O6vOlaq+kiT+wmsWl2yyKlhbT2EEMA
	 t/TFLizi9ZzbAkH6EUsgqU05/4dbs8oBeJ7w4ki1ffl5rTDLQAZwHDH2yqySE3UySW
	 EPcbcKse1V9S3aHSyDHi3IsRit7unQyMLqGetOFJ+XN0iL854AjKUUNQwGZEoQm/TU
	 DQk4mBpK4Yb6g==
Date: Tue, 13 Jun 2023 11:24:35 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 <netdev@vger.kernel.org>, <pmenzel@molgen.mpg.de>,
 <simon.horman@corigine.com>, <anthony.l.nguyen@intel.com>,
 <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 3/3] ice: remove
 unnecessary check for old MAC == new MAC
Message-ID: <20230613112435.18dc8130@kernel.org>
In-Reply-To: <9ea8a985-923d-62ec-5a34-ef7eeb056f05@intel.com>
References: <20230613122420.855486-1-piotrx.gardocki@intel.com>
	<20230613122420.855486-4-piotrx.gardocki@intel.com>
	<4db2d627-782c-90c2-4826-76b9779149ce@intel.com>
	<c9f819da-61a6-ea8f-5e16-d9aad6634127@intel.com>
	<837ccaeb-a77d-5570-1363-e5e344528f97@intel.com>
	<08b11944-984f-eeeb-4b03-777faaa3ce01@intel.com>
	<9ea8a985-923d-62ec-5a34-ef7eeb056f05@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Jun 2023 17:32:50 +0200 Piotr Gardocki wrote:
> > there is ether_addr_equal() call in iavf_set_mac(), even if not
> > exactly before eth_hw_addr_set(), it still should be removed ;)
> > 
> > Anyway, I would fix all 3 drivers with one patch.  
> 
> I guess you're looking at old version of dev-queue branch on Tony's
> tree :) Regarding ice and i40e I made two patches to have different
> prefixes in titles. I don't mind merging them, but I'll wait for
> someone else speaking up about this.

I think the series is good enough, FWIW. We're already at -rc6, seems
more important to give syzbot and testers time to exercise the core
change than fishing out more drivers.

