Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6BA30FF41
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBDVXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:23:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229511AbhBDVXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 16:23:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9873F64FA8;
        Thu,  4 Feb 2021 21:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612473789;
        bh=CFPI67+p7Xh8yb6wg8N8u522K+3YKdkHpQQmTmfPWmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A27XNu3YV3G9YEswLcKTQB5NxglLbx1vQGMKtq7Uov230arQlAUoHZdBY7xb+RnM+
         RQSIvie4ngyqp/bfGqOYNEMI9oMQ9ByiZuqLvN/bCAbQ2Jay7N3g8kXzNG8+nwYrKC
         07bzH7b9IDA6pPzxMtXZoCGlrgYOg2DKMpRdFKLebOk4+pYZRGEfa+RKMZHoyw1n9/
         hE3WZwfnpbEnXhf/7/kFt3LQi3javPz3HT43wvYEiYGaEnIcNudR54996cUfjoPNml
         8Qog/QJ16XGbXh3OwyOFvlVMD/CZRwgi8SVT/zypeKDBUBUnZd4/ofamR3qFno51cb
         Slooknd0RlCuQ==
Date:   Thu, 4 Feb 2021 14:23:06 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, Yufeng Mo <moyufeng@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: hns3: avoid -Wpointer-bool-conversion warning
Message-ID: <20210204212306.GB385551@localhost>
References: <20210204153813.1520736-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204153813.1520736-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 04:38:06PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang points out a redundant sanity check:
> 
> drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:497:28: error: address of array 'filp->f_path.dentry->d_iname' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]
> 
> This can never fail, so just remove the check.
> 
> Fixes: 04987ca1b9b6 ("net: hns3: add debugfs support for tm nodes, priority and qset info")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> index 6978304f1ac5..c5958754f939 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> @@ -494,9 +494,6 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
>  	ssize_t size = 0;
>  	int ret = 0;
>  
> -	if (!filp->f_path.dentry->d_iname)
> -		return -EINVAL;
> -
>  	read_buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
>  	if (!read_buf)
>  		return -ENOMEM;
> -- 
> 2.29.2
> 
