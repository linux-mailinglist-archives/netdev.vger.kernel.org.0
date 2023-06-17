Return-Path: <netdev+bounces-11691-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 139F9733EE8
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:55:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43EF328186A
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B5E53B2;
	Sat, 17 Jun 2023 06:55:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1BC33FD
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC314C433C8;
	Sat, 17 Jun 2023 06:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686984902;
	bh=Mzcf7CgMf4fIiAMSQeWVVahK1qYg3YKOpZwTkm43pb8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SEPiP07stLTefcPzLGSIaV5BEWOQqm1QBVNrdpCnaYqarVYPw6zJmuR6buSvV8JFk
	 fSGT86VdaTS1yRCWrjV3Uapkyjiw0LjDINH72Icp+z6njDfqgfgKOitUGSkcFvRFfM
	 EqYbMWIHnvHGZ+2Pp/0iTw1DnbREFHVlYpqjifuiacJZxUNLR6w8FyVtus1QtXwHMa
	 vPl/z2JTM/Jye2Ad3CZkTKGBlg1MJXUwYf6ETWElmF2+rt1eUz6POhrv3vEc/GxJxw
	 RFwy/4Vhk+OQtKu+7ERT75+KSjhaeXEY4zX+fu4Ntriif75imfQPYIu0+tF4ANr8jl
	 s1dob1m1Y8NGA==
Date: Fri, 16 Jun 2023 23:55:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, Alan Brady <alan.brady@intel.com>,
 pavan.kumar.linga@intel.com, emil.s.tantilov@intel.com,
 jesse.brandeburg@intel.com, sridhar.samudrala@intel.com,
 shiraz.saleem@intel.com, sindhu.devale@intel.com, willemb@google.com,
 decot@google.com, andrew@lunn.ch, leon@kernel.org, mst@redhat.com,
 simon.horman@corigine.com, shannon.nelson@amd.com,
 stephen@networkplumber.org, Joshua Hay <joshua.a.hay@intel.com>, Madhu
 Chittim <madhu.chittim@intel.com>, Phani Burra <phani.r.burra@intel.com>
Subject: Re: [PATCH net-next v2 12/15] idpf: add RX splitq napi poll support
Message-ID: <20230616235500.2806449d@kernel.org>
In-Reply-To: <20230614171428.1504179-13-anthony.l.nguyen@intel.com>
References: <20230614171428.1504179-1-anthony.l.nguyen@intel.com>
	<20230614171428.1504179-13-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 10:14:25 -0700 Tony Nguyen wrote:
> +	skb = __napi_alloc_skb(&rxq->q_vector->napi, IDPF_RX_HDR_SIZE,
> +			       GFP_ATOMIC | __GFP_NOWARN);

Why are you trying to pass __GFP_NOWARN in?

