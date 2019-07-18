Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF28B6C980
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 08:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388694AbfGRGxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 02:53:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2677 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbfGRGxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 02:53:18 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A8A62B24A39F3EB1B51D;
        Thu, 18 Jul 2019 14:53:14 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 18 Jul 2019
 14:53:13 +0800
Subject: Re: [PATCH] net: dsa: sja1105: Release lock in error case
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190718022110.GA19222@hari-Inspiron-1545>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <8962909e-94a6-8005-bd4c-05c556ac4242@huawei.com>
Date:   Thu, 18 Jul 2019 14:53:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190718022110.GA19222@hari-Inspiron-1545>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

https://patchwork.ozlabs.org/patch/1133135/

This has been fixed.

On 2019/7/18 10:21, Hariprasad Kelam wrote:
> This patch adds release of unlock in fail case.
> 
> Issue identified by coccicheck
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> ---
>  net/dsa/tag_sja1105.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
> index 1d96c9d..26363d7 100644
> --- a/net/dsa/tag_sja1105.c
> +++ b/net/dsa/tag_sja1105.c
> @@ -216,6 +216,7 @@ static struct sk_buff
>  		if (!skb) {
>  			dev_err_ratelimited(dp->ds->dev,
>  					    "Failed to copy stampable skb\n");
> +			spin_unlock(&sp->data->meta_lock);
>  			return NULL;
>  		}
>  		sja1105_transfer_meta(skb, meta);
> 

