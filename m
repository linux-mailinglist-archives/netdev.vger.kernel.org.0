Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95C31407C4
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 11:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgAQKUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 05:20:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48872 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgAQKUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 05:20:34 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A6279155CAC73;
        Fri, 17 Jan 2020 02:20:32 -0800 (PST)
Date:   Fri, 17 Jan 2020 02:20:30 -0800 (PST)
Message-Id: <20200117.022030.458227945074641961.davem@davemloft.net>
To:     liuyonglong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net] net: hns: fix soft lockup when there is not enough
 memory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579160477-31030-1-git-send-email-liuyonglong@huawei.com>
References: <1579160477-31030-1-git-send-email-liuyonglong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jan 2020 02:20:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>
Date: Thu, 16 Jan 2020 15:41:17 +0800

> When there is not enough memory and napi_alloc_skb() return NULL,
> the HNS driver will print error message, and than try again, if
> the memory is not enough for a while, huge error message and the
> retry operation will cause soft lockup.
> 
> When napi_alloc_skb() return NULL because of no memory, we can
> get a warn_alloc() call trace, so this patch deletes the error
> message. We already use polling mode to handle irq, but the
> retry operation will render the polling weight inactive, this
> patch just return budget when the rx is not completed to avoid
> dead loop.
> 
> Fixes: 36eedfde1a36 ("net: hns: Optimize hns_nic_common_poll for better performance")
> Fixes: b5996f11ea54 ("net: add Hisilicon Network Subsystem basic ethernet support")
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>

Applied and queued up for -stable.
