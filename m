Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B452C495A
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgKYUwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:52:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730178AbgKYUwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 15:52:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D17BE206F9;
        Wed, 25 Nov 2020 20:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606337562;
        bh=WKEJzBYVd+8PMx+UMVm1oTSljUZKPowNrgF/4VceGHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i6fmyj81KoJJUbDx4jXaFL5jL5PJxHvNfNrg92ckZi8c+qhgZt1eCv3LWopndGYom
         YYSPS3E7TOAw6SWDmCdUALUr3DpMTvVoLIjgf99UmIEx8EnHG2jZfN46DCdRodmfvr
         eqP6wOL9N3sYoppBCCzma/0LjTCSiWEwxB+GhcM8=
Date:   Wed, 25 Nov 2020 12:52:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: Re: [PATCH net v2 3/9] ibmvnic: avoid memset null scrq msgs
Message-ID: <20201125125240.59e29a4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123235757.6466-4-drt@linux.ibm.com>
References: <20201123235757.6466-1-drt@linux.ibm.com>
        <20201123235757.6466-4-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 18:57:51 -0500 Dany Madden wrote:
> scrq->msgs could be NULL during device reset, causing Linux to crash.
> So, check before memset scrq->msgs.
> 
> Fixes: c8b2ad0a4a901 ("ibmvnic: Sanitize entire SCRQ buffer on reset")
> 
> Signed-off-by: Dany Madden <drt@linux.ibm.com>

Thanks for the Fixes tags! Please remove the empty lines between the
Fixes tags and sign-offs, and make sure the Fixes lines are not wrapped
(e.g. in patch 9).

> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index d5a927bb4954..e84255c2fc72 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2844,16 +2844,26 @@ static int reset_one_sub_crq_queue(struct ibmvnic_adapter *adapter,
>  				   struct ibmvnic_sub_crq_queue *scrq)
>  {
>  	int rc;
> +	if (!scrq) {

Looks like a missing new line between variable declaration and code.

Not sure why checkpatch doesn't catch this.
