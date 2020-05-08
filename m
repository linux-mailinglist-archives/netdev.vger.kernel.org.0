Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9EE1CB869
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgEHTiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgEHTiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 15:38:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 295452184D;
        Fri,  8 May 2020 19:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588966704;
        bh=vDMmV532cu6IYoaHWWtZRzKoqJ0ehYiUfefn2GdxIik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gE5kEWnC9eaW4FnmtnaixrHhRL5fv4uXJQ31kvWbqwPkM+3zWp6n5sf5PJDkQr7Iz
         AicdHmXN0GFxgzSLkMiOwkg+etxlc7qtxTg1GVfWg7ZC4kwvRWnumu3UKlM9BgRjsV
         ttsvbed+P833oFVbJe6sMmHqcCHuWGlVhA9vtEjE=
Date:   Fri, 8 May 2020 12:38:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next v2] net: ethernet: ti: fix some return value
 check of cpsw_ale_create()
Message-ID: <20200508123822.5324b74f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <da50aa53-a967-83b7-0737-701ab30228e4@ti.com>
References: <20200508021059.172001-1-weiyongjun1@huawei.com>
        <20200508100649.1112-1-weiyongjun1@huawei.com>
        <da50aa53-a967-83b7-0737-701ab30228e4@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 14:26:27 +0300 Grygorii Strashko wrote:
> On 08/05/2020 13:06, Wei Yongjun wrote:
> > cpsw_ale_create() can return both NULL and PTR_ERR(), but all of
> > the caller only check NULL for error handling. This patch convert
> > it to only return PTR_ERR() in all error cases, all the caller using
> > IS_ERR() install of NULL test.
> > 
> > Also fix a return negative error code from the cpsw_ale_create()
> > error handling case instead of 0 in am65_cpsw_nuss_probe().
> > 
> > Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
> > Fixes: 4b41d3436796 ("net: ethernet: ti: cpsw: allow untagged traffic on host port")  
> 
> ^ I do not think it can be back-ported so far back.
> So, or drop second "Fixes: 4b41d3436796"
> or split am65-cpsw-nuss.c changes

Please also tag this commit with [net] not [net-next], 
AFAICS the problem is present in Linus's tree.
