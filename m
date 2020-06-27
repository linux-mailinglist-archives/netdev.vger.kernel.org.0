Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB17F20BE1A
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 06:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgF0ESr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 00:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgF0ESq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 00:18:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B1452080C;
        Sat, 27 Jun 2020 04:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593231526;
        bh=JU+3zPmrftVMnSLYPmd1KQTQyLAjhzd3TN8hipScclw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n6F1FhhXEr9iAV5KscVAXZyN8Di1xQAuMZ7nCnpvCOXfypU2qX5yGfCNBuVX1CnEf
         klX+X07nGmFJOUpvD4NpXVvVvSACVlYptj3TjQS7GXytkeBxnVa3k8sO3Zy2y8htb3
         STiwZRHtnHtnXnwUPhsws1cdDYzeyx+L9tXld4gs=
Date:   Fri, 26 Jun 2020 21:18:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 1/3] cxgb4: add mirror action to TC-MATCHALL
 offload
Message-ID: <20200626211844.40ed466c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9a8e0a8df764f44f6dce0c3fbb9dd56aa8d049ab.1593085107.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
        <9a8e0a8df764f44f6dce0c3fbb9dd56aa8d049ab.1593085107.git.rahul.lakkireddy@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 17:28:41 +0530 Rahul Lakkireddy wrote:
> +	if (refcount_read(&pi->vi_mirror_refcnt) > 1) {
> +		refcount_dec(&pi->vi_mirror_refcnt);
> +		return;
> +	}

FWIW this looks very dodgy. If you know nothing changes the count
between the read and the dec here, you probably don't need atomic
refcounts at all..
