Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2099C222FBD
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgGQALM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgGQALM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:11:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92C9C206F4;
        Fri, 17 Jul 2020 00:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594944671;
        bh=ici20k2Lk0/c6YyqQG9OpMyDulqPoPaPXf+ytG/xjJg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YjPfd31Q1lKH+eV0YirMsdkapQMyMqYSfP15SIrGEbq/+iuRI5wICBhpZTvs42RdT
         Mq9uiwqY+QJ1XEEYveCUYh3NEuKtFnjoXI96XyVZ037uQY7zAqQ7ae2S8jMrYelvrd
         5h9OckiHQJIDHju7K/DHdBDpDLx0j2u0x23+kxFU=
Date:   Thu, 16 Jul 2020 17:11:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <sgoutham@marvell.com>,
        Aleksey Makarov <amakarov@marvell.com>
Subject: Re: [PATCH v4 net-next 3/3] octeontx2-pf: Add support for PTP clock
Message-ID: <20200716171109.7d8c6d17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594816689-5935-4-git-send-email-sbhatta@marvell.com>
References: <1594816689-5935-1-git-send-email-sbhatta@marvell.com>
        <1594816689-5935-4-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 18:08:09 +0530 Subbaraya Sundeep wrote:
> @@ -1730,10 +1745,149 @@ static void otx2_reset_task(struct work_struct *work)
>  	if (!netif_running(pf->netdev))
>  		return;
>  
> +	rtnl_lock();
>  	otx2_stop(pf->netdev);
>  	pf->reset_count++;
>  	otx2_open(pf->netdev);
>  	netif_trans_update(pf->netdev);
> +	rtnl_unlock();
> +}
> +

This looks unrelated, otherwise for the patches:

Acked-by: Jakub Kicinski <kuba@kernel.org>
