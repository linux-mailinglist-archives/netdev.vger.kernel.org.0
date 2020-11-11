Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100DF2AFB76
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbgKKWhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbgKKWfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 17:35:01 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0773221534;
        Wed, 11 Nov 2020 22:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605134101;
        bh=PzHXq0dk37CJkJTmVeJPMe390nr6FA3QQTW3WYA7MlQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XYq8nRtbu7l7ofzW+Ae9wzWF38qAJXNzuEcW5bvsg0eMMLG5Q2IzC4ay8upAVqAlV
         VH5me6YRMrud2ojZlky+J1+jol2wKZSb6LBnMyNPuUNSPe0xhSrB0N0aptjejD+b2q
         KtzcwfHHqhqwDyI5jsTZ5XyCtWAaesMShb6iTcaE=
Date:   Wed, 11 Nov 2020 14:34:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com
Subject: Re: [PATCH net-next v4 10/15] net/smc: Introduce SMCR get link
 command
Message-ID: <20201111143459.29aead6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109151814.15040-11-kgraul@linux.ibm.com>
References: <20201109151814.15040-1-kgraul@linux.ibm.com>
        <20201109151814.15040-11-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 16:18:09 +0100 Karsten Graul wrote:
> @@ -129,6 +131,12 @@ struct smc_diag_linkinfo {
>  	__u8 ibport;			/* RDMA device port number */
>  	__u8 gid[40];			/* local GID */
>  	__u8 peer_gid[40];		/* peer GID */
> +	/* Fields above used by legacy v1 code */
> +	__u32 conn_cnt;
> +	__u8 netdev[IFNAMSIZ];		/* ethernet device name */

Why report the name? Interfaces are generally identified by ifindex.

> +	__u8 link_uid[4];		/* unique link id */
> +	__u8 peer_link_uid[4];		/* unique peer link id */
> +	__u32 link_state;		/* link state */
>  };
