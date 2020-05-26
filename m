Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B021D5705
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgEORH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726023AbgEORH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:07:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530D4C061A0C;
        Fri, 15 May 2020 10:07:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E89FD14B7F8A3;
        Fri, 15 May 2020 10:07:27 -0700 (PDT)
Date:   Fri, 15 May 2020 10:07:24 -0700 (PDT)
Message-Id: <20200515.100724.857120162566779862.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next] hinic: add set_channels ethtool_ops support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515003547.27359-1-luobin9@huawei.com>
References: <20200515003547.27359-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 10:07:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Fri, 15 May 2020 00:35:47 +0000

> +void hinic_update_num_qps(struct hinic_hwdev *hwdev, u16 num_qp)
> +{
> +	struct hinic_cap *nic_cap = &hwdev->nic_cap;
> +
> +	nic_cap->num_qps = num_qp;
> +}

It is excessive to have a helper function that assigns a single struct
member, the layout of which is visible to all callers.  All callers
are also in a single function.

Please remove this helper and just go "hwdev->nic_cap.num_qps = xxx;"
at the call sites.

Thank you.
