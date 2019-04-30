Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878DFF5A4
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 13:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfD3LbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 07:31:06 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7148 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726202AbfD3LbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 07:31:06 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DA2534B59E40D685B94C;
        Tue, 30 Apr 2019 19:31:02 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 19:31:00 +0800
Subject: Re: [PATCH] appletalk: Set error code while register_snap_client
To:     <davem@davemloft.net>, <gregkh@linuxfoundation.org>
References: <20190430112840.43452-1-yuehaibing@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <b1fdc9c5-ec67-20af-15c6-7e966c2b65e1@huawei.com>
Date:   Tue, 30 Apr 2019 19:30:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190430112840.43452-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch title need fix, Pls ignore this.

On 2019/4/30 19:28, YueHaibing wrote:
> If register_snap_client fails in atalk_init,
> error code should be set, otherwise it will
> triggers NULL pointer dereference while unloading
> module.
> 
> Fixes: 9804501fa122 ("appletalk: Fix potential NULL pointer dereference in unregister_snap_client")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/appletalk/ddp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
> index 709d254..dbe8b19 100644
> --- a/net/appletalk/ddp.c
> +++ b/net/appletalk/ddp.c
> @@ -1920,6 +1920,7 @@ static int __init atalk_init(void)
>  	ddp_dl = register_snap_client(ddp_snap_id, atalk_rcv);
>  	if (!ddp_dl) {
>  		pr_crit("Unable to register DDP with SNAP.\n");
> +		rc = -ENOMEM;
>  		goto out_sock;
>  	}
>  
> 

