Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EC82EB6A7
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbhAFADl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbhAFADl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:03:41 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAA7C061574;
        Tue,  5 Jan 2021 16:03:01 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 68C064CE685B6;
        Tue,  5 Jan 2021 16:03:00 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:02:59 -0800 (PST)
Message-Id: <20210105.160259.377394842851693699.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Markus.Elring@web.de
Subject: Re: [PATCH v3 net-next] net: kcm: Replace fput with sockfd_put
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201230091809.942-1-zhengyongjun3@huawei.com>
References: <20201230091809.942-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:03:00 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Wed, 30 Dec 2020 17:18:09 +0800

> The function sockfd_lookup uses fget on the value that is stored in
> the file field of the returned structure, so fput should ultimately be
> applied to this value.  This can be done directly, but it seems better
> to use the specific macro sockfd_put, which does the same thing.
> 
> Perform a source code refactoring by using the following semantic patch.
> 
>     // <smpl>
>     @@
>     expression s;
>     @@
> 
>        s = sockfd_lookup(...)
>        ...
>     + sockfd_put(s);
>     - fput(s->file);
>     // </smpl>
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
