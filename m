Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0736B721C1
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbfGWVki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:40:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfGWVki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:40:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A483B153C23F2;
        Tue, 23 Jul 2019 14:40:37 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:40:37 -0700 (PDT)
Message-Id: <20190723.144037.1902813339837548393.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 18/19] ionic: Add coalesce and other
 features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722214023.9513-19-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
        <20190722214023.9513-19-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:40:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 22 Jul 2019 14:40:22 -0700

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> index 742d7d47f4d8..e6b579a40b70 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> @@ -377,6 +377,75 @@ static int ionic_get_coalesce(struct net_device *netdev,
>  	return 0;
>  }
>  
> +static int ionic_set_coalesce(struct net_device *netdev,
> +			      struct ethtool_coalesce *coalesce)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct identity *ident = &lif->ionic->ident;
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	u32 tx_coal, rx_coal;
> +	struct qcq *qcq;
> +	unsigned int i;

Reverse christmas tree please.

