Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B52985DE
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 04:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421845AbgJZDRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 23:17:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2570 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1421836AbgJZDRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 23:17:22 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CKKl929fXzhZ6n;
        Mon, 26 Oct 2020 11:17:25 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Mon, 26 Oct 2020 11:17:09 +0800
Subject: Re: [PATCH net] net: hns3: clean up a return in hclge_tm_bp_setup()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
CC:     Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20201023112212.GA282278@mwanda>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3fbcbfbd-deea-162e-9281-29e65b90996b@huawei.com>
Date:   Mon, 26 Oct 2020 11:18:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20201023112212.GA282278@mwanda>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/10/23 19:22, Dan Carpenter wrote:
> Smatch complains that "ret" might be uninitialized if we don't enter
> the loop.  We do always enter the loop so it's a false positive, but
> it's cleaner to just return a literal zero and that silences the
> warning as well.

Thanks for the clean up. Minor comment below:
Perhap it makes sense to limit ret scope within the for loop after
returning zero.

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
> index 15f69fa86323..e8495f58a1a8 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
> @@ -1373,7 +1373,7 @@ static int hclge_tm_bp_setup(struct hclge_dev *hdev)
>  			return ret;
>  	}
>  
> -	return ret;
> +	return 0;
>  }
>  
>  int hclge_pause_setup_hw(struct hclge_dev *hdev, bool init)
> 
