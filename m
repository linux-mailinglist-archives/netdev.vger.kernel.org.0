Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDE481003
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 03:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfHEBWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 21:22:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47398 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbfHEBWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 21:22:45 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B9173BF0B69C084A267B;
        Mon,  5 Aug 2019 09:22:43 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Mon, 5 Aug 2019
 09:22:41 +0800
Subject: Re: [PATCH net-next] net: can: Fix compiling warning
To:     <socketcan@hartkopp.net>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <20190805012254.59869-1-maowenan@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <23513a5a-e30b-bd2f-f0e9-2f5a7d18ae11@huawei.com>
Date:   Mon, 5 Aug 2019 09:22:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190805012254.59869-1-maowenan@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

please drop this mail.

On 2019/8/5 9:22, Mao Wenan wrote:
> There are two warnings in net/can, fix them by setting bcm_sock_no_ioctlcmd
> and raw_sock_no_ioctlcmd as static.
> 
> net/can/bcm.c:1683:5: warning: symbol 'bcm_sock_no_ioctlcmd' was not declared. Should it be static?
> net/can/raw.c:840:5: warning: symbol 'raw_sock_no_ioctlcmd' was not declared. Should it be static?
> 
> Fixes: 473d924d7d46 ("can: fix ioctl function removal")
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  v1->v2: change patch description typo error, 'warings' to 'warnings'.
>  net/can/bcm.c | 2 +-
>  net/can/raw.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/can/bcm.c b/net/can/bcm.c
> index bf1d0bbecec8..b8a32b4ac368 100644
> --- a/net/can/bcm.c
> +++ b/net/can/bcm.c
> @@ -1680,7 +1680,7 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>  	return size;
>  }
>  
> -int bcm_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
> +static int bcm_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
>  			 unsigned long arg)
>  {
>  	/* no ioctls for socket layer -> hand it down to NIC layer */
> diff --git a/net/can/raw.c b/net/can/raw.c
> index da386f1fa815..a01848ff9b12 100644
> --- a/net/can/raw.c
> +++ b/net/can/raw.c
> @@ -837,7 +837,7 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>  	return size;
>  }
>  
> -int raw_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
> +static int raw_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
>  			 unsigned long arg)
>  {
>  	/* no ioctls for socket layer -> hand it down to NIC layer */
> 

