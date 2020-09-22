Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF087274D8B
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 01:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgIVXya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 19:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgIVXya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 19:54:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A972C061755;
        Tue, 22 Sep 2020 16:54:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A5EBF13C049CE;
        Tue, 22 Sep 2020 16:37:42 -0700 (PDT)
Date:   Tue, 22 Sep 2020 16:54:28 -0700 (PDT)
Message-Id: <20200922.165428.1054729586492392023.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: microchip: Make `lan743x_pm_suspend`
 function return right value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921120818.31182-1-zhengyongjun3@huawei.com>
References: <20200921120818.31182-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 22 Sep 2020 16:37:42 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Mon, 21 Sep 2020 20:08:18 +0800

> @@ -3053,7 +3053,7 @@ static int lan743x_pm_suspend(struct device *dev)
>  	/* Host sets PME_En, put D3hot */
>  	ret = pci_prepare_to_sleep(pdev);
>  
> -	return 0;
> +	return ret;
>  }

Instead please do:

	return pci_preprare_to_sleep(pdev);

And if 'ret' is then completely unused as a result, remove it.
