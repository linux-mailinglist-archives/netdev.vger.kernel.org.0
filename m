Return-Path: <netdev+bounces-7016-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2DEC719322
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47E611C20FCB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9355BA4A;
	Thu,  1 Jun 2023 06:23:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13C7BA45
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434D7C433EF;
	Thu,  1 Jun 2023 06:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685600618;
	bh=PPcAs7Y/fk8Z5gsKwhV3B8y0Oiih+7Ad7ik33I0QhUo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NJ3CQOw1J43jrX3Gg6qUelNMAVVRo3ck8EqNBSO2EXfe3QnB7MRQDEOEoOAu6ho7L
	 fvTfrfm8LOFS68216tbQTi2jjqey9rAdcaesjtTdHf26+iTVl0I3c3raeQiIlTp60b
	 UvaHNiFqygIdi3eYSGIenihiW1BiiqdMzH9Tm25nzj1OLtbMmcDn/msP5lOQi/A1xd
	 8FjZn0r7u7oW9EPm9Fh3o5hmNgtaUif4zs6F8ZCsBxJa3f+WIxlhGj7MM0/1aeK5nc
	 eJ3k2kVh4vWrXvB4pZn70I3oonWP9DBZyewlGgTtrGU0vFthr5uDxjPmkm/fqEY2mV
	 qEeX/+LcrbrRg==
Date: Wed, 31 May 2023 23:23:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, Joshua Hay <joshua.a.hay@intel.com>,
 pavan.kumar.linga@intel.com, emil.s.tantilov@intel.com,
 jesse.brandeburg@intel.com, sridhar.samudrala@intel.com,
 shiraz.saleem@intel.com, sindhu.devale@intel.com, willemb@google.com,
 decot@google.com, andrew@lunn.ch, leon@kernel.org, mst@redhat.com,
 simon.horman@corigine.com, shannon.nelson@amd.com,
 stephen@networkplumber.org, linux-doc@vger.kernel.org, Alan Brady
 <alan.brady@intel.com>, Madhu Chittim <madhu.chittim@intel.com>, Phani
 Burra <phani.r.burra@intel.com>, Krishneil Singh
 <krishneil.k.singh@intel.com>
Subject: Re: [PATCH net-next 15/15] idpf: configure SRIOV and add other
 ndo_ops
Message-ID: <20230531232336.3dffb14b@kernel.org>
In-Reply-To: <20230530234501.2680230-16-anthony.l.nguyen@intel.com>
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
	<20230530234501.2680230-16-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 16:45:01 -0700 Tony Nguyen wrote:
> +	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
> +
> +	if (!vport)
> +		return;
> +
> +	*stats = vport->netstats;

How is this atomic vs the update path.

