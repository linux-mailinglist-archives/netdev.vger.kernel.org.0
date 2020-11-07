Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F012AA755
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgKGR5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgKGR5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 12:57:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B4020885;
        Sat,  7 Nov 2020 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604771854;
        bh=WR1wVkbuX5i/f2LVp2ly008pd0bOmAkxknK6KugSDYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cJEEbEZHZVz6RGmWkcHk0DAP69qXxcvI9Hbm4qMep6RIVPuCxXWZuK5/Vs3eZnJBr
         8ynfhNdZL6CzYl6XvYSH4I0xOWF8PovSVE+lp/sUOV7tZnvy2wDW5i3mO44gFbguaZ
         vOVb5P+OIcJkbLd9OSnNIqpeFzzRA5piuRsuycKQ=
Date:   Sat, 7 Nov 2020 09:57:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com
Subject: Re: [PATCH net-next v3 03/15] net/smc: Add connection counters for
 links
Message-ID: <20201107095733.7a381e84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107125958.16384-4-kgraul@linux.ibm.com>
References: <20201107125958.16384-1-kgraul@linux.ibm.com>
        <20201107125958.16384-4-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 13:59:46 +0100 Karsten Graul wrote:
> +static inline void smc_switch_link_and_count(struct smc_connection *conn,
> +					     struct smc_link *to_lnk)

Please avoid the use of static inline functions.

The compiler should inline this 3 instruction function anyway.

Please fix other instances in this submission as well.

> +{
> +	atomic_dec(&conn->lnk->conn_cnt);
> +	conn->lnk = to_lnk;
> +	atomic_inc(&conn->lnk->conn_cnt);
> +}
