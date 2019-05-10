Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4009D1A511
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 00:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfEJWH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 18:07:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58538 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbfEJWH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 18:07:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A63D133E975E;
        Fri, 10 May 2019 15:07:26 -0700 (PDT)
Date:   Fri, 10 May 2019 15:07:26 -0700 (PDT)
Message-Id: <20190510.150726.885803501118103323.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dsa: tag_brcm: Fix build error without
 CONFIG_NET_DSA_TAG_BRCM_PREPEND
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190510030028.31564-1-yuehaibing@huawei.com>
References: <20190510030028.31564-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 May 2019 15:07:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 10 May 2019 11:00:28 +0800

> Fix gcc build error:
> 
> net/dsa/tag_brcm.c:211:16: error: brcm_prepend_netdev_ops undeclared here (not in a function); did you mean brcm_netdev_ops?
>  DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
>                 ^
> ./include/net/dsa.h:708:10: note: in definition of macro DSA_TAG_DRIVER
>   .ops = &__ops,       \
>           ^~~~~
> ./include/net/dsa.h:701:36: warning: dsa_tag_driver_brcm_prepend_netdev_ops defined but not used [-Wunused-variable]
>  #define DSA_TAG_DRIVER_NAME(__ops) dsa_tag_driver ## _ ## __ops
>                                     ^
> ./include/net/dsa.h:707:30: note: in expansion of macro DSA_TAG_DRIVER_NAME
>  static struct dsa_tag_driver DSA_TAG_DRIVER_NAME(__ops) = {  \
>                               ^~~~~~~~~~~~~~~~~~~
> net/dsa/tag_brcm.c:211:1: note: in expansion of macro DSA_TAG_DRIVER
>  DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
> 
> Like the CONFIG_NET_DSA_TAG_BRCM case,
> brcm_prepend_netdev_ops and DSA_TAG_PROTO_BRCM_PREPEND
> should be wrappeed by CONFIG_NET_DSA_TAG_BRCM_PREPEND.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: b74b70c44986 ("net: dsa: Support prepended Broadcom tag")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied and queued up for -stable.
