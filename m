Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B9322B906
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgGWV5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgGWV5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:57:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31DBC0619D3;
        Thu, 23 Jul 2020 14:57:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF90611E48C62;
        Thu, 23 Jul 2020 14:40:37 -0700 (PDT)
Date:   Thu, 23 Jul 2020 14:57:22 -0700 (PDT)
Message-Id: <20200723.145722.752878326752101646.davem@davemloft.net>
To:     andrea.righi@canonical.com
Cc:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, kuba@kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-netfront: fix potential deadlock in xennet_remove()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722065211.GA841369@xps-13>
References: <20200722065211.GA841369@xps-13>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 14:40:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Righi <andrea.righi@canonical.com>
Date: Wed, 22 Jul 2020 08:52:11 +0200

> +static int xennet_remove(struct xenbus_device *dev)
> +{
> +	struct netfront_info *info = dev_get_drvdata(&dev->dev);
> +
> +	dev_dbg(&dev->dev, "%s\n", dev->nodename);

These kinds of debugging messages provide zero context and are so much
less useful than simply using tracepoints which are more universally
available than printk debugging facilities.

Please remove all of the dev_dbg() calls from this patch.
