Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99634253991
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 23:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHZVOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 17:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgHZVOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 17:14:52 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7C56207CD;
        Wed, 26 Aug 2020 21:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598476492;
        bh=lpvMPzePcF4uV3s7lnt1kPiXrbaIXLnDLXWyvpMdrew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l+NIoy2y6jioQ7Th8yHhfOJSiQd1n/cQbPT0i7TB5ASsFKVwIoLe1PnaAHsRBO/2K
         +vAoNF/BvGXzbzbUeo1xiVGlZt8ocIRoSwc1OeJlUDr7FJzUqi/W0mYbo7D0VKH6cO
         LPRmE4xdxy+og3w9Z4D1Tr/NlL495yHAYdv23RPs=
Date:   Wed, 26 Aug 2020 14:14:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 11/12] ionic: change queue count with no reset
Message-ID: <20200826141450.532ee89a@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200826164214.31792-12-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
        <20200826164214.31792-12-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Aug 2020 09:42:13 -0700 Shannon Nelson wrote:
> +	if (qparam->nxqs != lif->nxqs) {
> +		err = netif_set_real_num_tx_queues(lif->netdev, lif->nxqs);
> +		if (err)
> +			goto err_out;
> +		err = netif_set_real_num_rx_queues(lif->netdev, lif->nxqs);
> +		if (err)
> +			goto err_out;

does error handling reset real_num_tx_queues to previous value?

> +	}
