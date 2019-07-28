Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993FE77D30
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 04:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfG1CDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 22:03:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42408 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725262AbfG1CDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 22:03:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2609012659668;
        Sat, 27 Jul 2019 19:03:36 -0700 (PDT)
Date:   Sat, 27 Jul 2019 19:03:33 -0700 (PDT)
Message-Id: <20190727.190333.249806415176311786.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, saeedm@mellanox.com, liuyonglong@huawei.com,
        lipeng321@huawei.com
Subject: Re: [PATCH V3 net-next 06/10] net: hns3: add debug messages to
 identify eth down cause
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564206372-42467-7-git-send-email-tanhuazhong@huawei.com>
References: <1564206372-42467-1-git-send-email-tanhuazhong@huawei.com>
        <1564206372-42467-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 19:03:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Sat, 27 Jul 2019 13:46:08 +0800

> From: Yonglong Liu <liuyonglong@huawei.com>
> 
> Some times just see the eth interface have been down/up via
> dmesg, but can not know why the eth down. So adds some debug
> messages to identify the cause for this.
> 
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
> Signed-off-by: Peng Li <lipeng321@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       | 18 ++++++++++++++++++
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c    | 19 +++++++++++++++++++
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c    | 11 +++++++++++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index 4d58c53..973c57b 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -459,6 +459,9 @@ static int hns3_nic_net_open(struct net_device *netdev)
>  		h->ae_algo->ops->set_timer_task(priv->ae_handle, true);
>  
>  	hns3_config_xps(priv);
> +
> +	netif_info(h, drv, netdev, "net open\n");

These will pollute everyone's kernel logs for normal operations.

This is not reasonable at all, sorry.

Furthermore, even if it was appropriate, "netif_info()" is not "debug".

