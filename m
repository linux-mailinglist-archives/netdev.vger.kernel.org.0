Return-Path: <netdev+bounces-11147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5197731B9D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F6A91C20EBA
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1FD125B6;
	Thu, 15 Jun 2023 14:43:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC43C2F3
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:43:42 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DA3294E
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686840221; x=1718376221;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R7m6EwVSs6DhwY+ljeHN8KXcYvla1ddTVA4Uzy8YF9E=;
  b=mn2zEzZ/KDxDqHf8D0UIKgfMVJCRoGiVu0ZgZ4mjou9/9MbimiO0XeU3
   NfLc1q8WeNwtquQhBv7TyZBAtv3iU9YueYpgQSyHuZud/qjdniBxsMLdF
   UjtTV11bmNIf5DuSCdIs0BbRqM3M9j5Rk6CNeApQeuL7S6Pj6KgmQtsfp
   TGf0BjDKj/sn+jFprYsm+qrrsMQ/8MhmX5pLqTMwueTrY14w4osMTkR7n
   +vwaTFc13xHuESHWNNhtj+/oUtPKJ24B8jzW2Ga27cgS2Oe1qNslCqh7b
   sZ0VzDOkp8iFFdX5sfZPB8gnSvhYLiVY18c6Fej8QAlDAGBNL45VrXd6E
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="356425079"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="356425079"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 07:43:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="689797987"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="689797987"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 07:43:28 -0700
Date: Thu, 15 Jun 2023 16:43:24 +0200
From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	przemyslaw.kitszel@intel.com
Subject: Re: [Intel-wired-lan] [PATCH iwl-next v1 1/4] ice: implement
 num_msix field per VF
Message-ID: <ZIsjjGTAJK2/Bhw/@localhost.localdomain>
References: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
 <20230615123830.155927-2-michal.swiatkowski@linux.intel.com>
 <ZIseq7r5alm5DctL@boxer>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIseq7r5alm5DctL@boxer>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 04:22:35PM +0200, Maciej Fijalkowski wrote:
> On Thu, Jun 15, 2023 at 02:38:27PM +0200, Michal Swiatkowski wrote:
> > Store the amount of MSI-X per VF instead of storing it in pf struct. It
> > is used to calculate number of q_vectors (and queues) for VF VSI.
> > 
> > Calculate vector indexes based on this new field.
> 
> Can you explain why? From a standalone POV the reasoning is not clear.
> 

Maybe I should reword it. Previously we had pf->vf_msix - number of MSI-X
on each VF. The number of MSI-X was the same on all VFs. After this
changes user is allowed to change MSI-X per VF. We need new field in VF
struct to track it. Calculation of queues / vector/ indexes is the same
as it was, but the number can be different for each VF, so intead of
baseing calculation on per VF MSI-X we have to base it on real VF MSI-X.

Feel like I over complicated simple thing by this commit message.
Calculation remainis the same, we have per VF field to store MSI-X instead
of one field for all of the VFs.

