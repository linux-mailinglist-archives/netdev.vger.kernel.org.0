Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FD624C2D1
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgHTQCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729565AbgHTQCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 12:02:06 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E399A206B5;
        Thu, 20 Aug 2020 16:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597939326;
        bh=EQZc2NGhM9AIYrv5sEnABCzt7TKEiRNC0wC6F93GafU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RFpEl/MEl/7jsU4fU72O22mmWZg7jEgYOmZymVmgc2BDhTT2M0TwQzX3Ts+w/GK68
         U+iUtm2xqNGlTL0TkyHRrrJRKJBDGKnA7vMMZf+jxHIafhz/WEmnzbCtRYnvx4P6yN
         CxOEv+EBIMmayyXjfVaEm8JBgZIuy3U5V3EfujaE=
Date:   Thu, 20 Aug 2020 09:02:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next] hinic: add debugfs support
Message-ID: <20200820090203.3f56024b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200820121432.23597-1-luobin9@huawei.com>
References: <20200820121432.23597-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 20:14:32 +0800 Luo bin wrote:
> +static int hinic_dbg_help(struct hinic_dev *nic_dev, const char *cmd_buf)
> +{
> +	netif_info(nic_dev, drv, nic_dev->netdev, "Available commands:\n");
> +	netif_info(nic_dev, drv, nic_dev->netdev, "sq info <queue id>\n");
> +	netif_info(nic_dev, drv, nic_dev->netdev, "sq wqe info <queue id> <wqe id>\n");
> +	netif_info(nic_dev, drv, nic_dev->netdev, "rq info <queue id>\n");
> +	netif_info(nic_dev, drv, nic_dev->netdev, "rq wqe info <queue id> <wqe id>\n");
> +	netif_info(nic_dev, drv, nic_dev->netdev, "sq ci table <queue id>\n");
> +	netif_info(nic_dev, drv, nic_dev->netdev, "rq cqe info <queue id> <cqe id>\n");
> +	netif_info(nic_dev, drv, nic_dev->netdev, "mac table\n");
> +	netif_info(nic_dev, drv, nic_dev->netdev, "global table\n");
> +	netif_info(nic_dev, drv, nic_dev->netdev, "func table\n");
> +	netif_info(nic_dev, drv, nic_dev->netdev, "port table\n");
> +	return 0;
> +}
> +
> +static const struct hinic_dbg_cmd_info g_hinic_dbg_cmd[] = {
> +	{"help", hinic_dbg_help},
> +	{"sq info", hinic_dbg_get_sq_info},
> +	{"sq wqe info", hinic_dbg_get_sq_wqe_info},
> +	{"rq info", hinic_dbg_get_rq_info},
> +	{"rq wqe info", hinic_dbg_get_rq_wqe_info},
> +	{"sq ci table", hinic_dbg_get_ci_table},
> +	{"rq cqe info", hinic_dbg_get_rq_cqe_info},
> +	{"mac table", hinic_dbg_get_mac_table},
> +	{"global table", hinic_dbg_get_global_table},
> +	{"func table", hinic_dbg_get_function_table},
> +	{"port table", hinic_dbg_get_port_table},
> +};

Please don't create command interfaces like this.

Instead create a read only file for objects you want to expose.

Split addition of each object into a separate patch and provide example
output in the commit message.
