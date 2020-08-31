Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B485258486
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 01:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgHaXu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 19:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgHaXu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 19:50:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B1742073A;
        Mon, 31 Aug 2020 23:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598917856;
        bh=mhmg0IjPwIKWwA+kb9fTvUqFHbUvs/LWmMpQikVv0AU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F7NCfdbiU+qTlzwFaIs+PiwoogeOMJaNtoO7njPs4pu4FWxLbSWws4VLeStKGxCpY
         WxzeW0BgfqO4n853fdXuMjAuRt3a4+PN95oNA50Tzz/bv/5xl3uNcB2nrzUtD0vGVn
         8lGCeboGQiJggo2u1gFkt37bHPp3Og+dICwXDFcI=
Date:   Mon, 31 Aug 2020 16:50:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 2/5] ionic: smaller coalesce default
Message-ID: <20200831165054.6d16f0dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200831233558.71417-3-snelson@pensando.io>
References: <20200831233558.71417-1-snelson@pensando.io>
        <20200831233558.71417-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Aug 2020 16:35:55 -0700 Shannon Nelson wrote:
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> index 9e2ac2b8a082..2b2eb5f2a0e5 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> @@ -16,7 +16,7 @@
>  #define IONIC_DEF_TXRX_DESC		4096
>  #define IONIC_LIFS_MAX			1024
>  #define IONIC_WATCHDOG_SECS		5
> -#define IONIC_ITR_COAL_USEC_DEFAULT	64
> +#define IONIC_ITR_COAL_USEC_DEFAULT	8

8 us interrupt coalescing does not hurt general operations?! No way.

It's your customers who'll get hurt here, so your call, but I seriously
doubt this. Unless the unit is not usec?
