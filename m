Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E126CAFA2A
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 12:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfIKKRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 06:17:01 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44669 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfIKKRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 06:17:01 -0400
Received: by mail-lf1-f65.google.com with SMTP id q11so1043455lfc.11
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 03:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a2Y/6nQhmbjCYM6INFKB83UDY8cfiNqLZZ65oB1VAN8=;
        b=EJ0U3t+QcOcSKiPM6djC6Fs1w7rmDTqEIqiCs2Fb5RYK/ti+qyPKe8K9hqCx2Qx9VK
         amN8HRc3FOkCPNpTOnAMjUimmaB7c9cl3Bpr7joltgtKR/nXvSllc9cYncRN69fNRY8g
         PRBiLF6XYsZUcvFucSz7TLtQ3sI+e/E95uZVg1s5EN9aDhFHlePXCpr8UDEPx2PjO/lE
         BUp4wsrrJRFkbV5iAxkc7YWe/Y3onxxuETh5MIgVMOGet/0q2fMXBv3NLfwMJuaIeL4a
         23uSowgv/iHEd+2yhG6jIRWeBvu7oXLIQ4gdOHlSBc4u7PrdR1o+jiNkuXHjBIhHH+f2
         D2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a2Y/6nQhmbjCYM6INFKB83UDY8cfiNqLZZ65oB1VAN8=;
        b=fb63TnovF9vntQDCjOLipqNv7Rx2HlSO0YU1jzV2+m1Y8jCZB8yZa3/2UUGvRW9I5G
         9EEl46P+ufGJ/QiYG2xHcFZYfPvKRNPr7jfK/RYFHsCVgESHKSOTLg/Z5uPn2gdjmNYo
         85bT9NvJYSqOx4c7ZgnmfyeQDLMWvoUBEeZTvKawqIQK5W+YbGEwG4041IRrMSEcAA2s
         YJzit15fDfqnegYevV5fmXXAxJiE0z7lGut5pI0Pu5uABWYwRUX36hUeBILZYINWSCaa
         WT1I0OybuzRNj11n5g0oGzkSMFVZlkmskyhv9A34gNOKidxbJtZbH0pYtE4KjOxpQlcA
         vVwQ==
X-Gm-Message-State: APjAAAXpBatsUxqNjRrhzcQQfAC0inuUFQGRv9ILEG0T5JrRdGW5e6Vu
        wpleCUPE7hcyalV7a654XTeThw==
X-Google-Smtp-Source: APXvYqz+Md79E0HPoC6Of1z/8S0vb5X0xR7NuEQx2fmlklAsDJKb6cezcxADEwx7B+c/EKr25xMc5g==
X-Received: by 2002:ac2:5633:: with SMTP id b19mr23451254lff.103.1568197018465;
        Wed, 11 Sep 2019 03:16:58 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:8e6:86de:79c0:860e:c175:7d39? ([2a00:1fa0:8e6:86de:79c0:860e:c175:7d39])
        by smtp.gmail.com with ESMTPSA id l9sm4610655ljg.79.2019.09.11.03.16.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 03:16:57 -0700 (PDT)
Subject: Re: [PATCH V2 net-next 4/7] net: hns3: fix port setting handle for
 fibre port
To:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
References: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
 <1568169639-43658-5-git-send-email-tanhuazhong@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <7f914173-a2fc-08d8-e2b1-48fa3da4e29c@cogentembedded.com>
Date:   Wed, 11 Sep 2019 13:16:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1568169639-43658-5-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 11.09.2019 5:40, Huazhong Tan wrote:

> From: Guangbin Huang <huangguangbin2@huawei.com>
> 
> For hardware doesn't support use specified speed and duplex

    Can't pasre that. "For hardware that does not support using", perhaps?

> to negotiate, it's unnecessary to check and modify the port
> speed and duplex for fibre port when autoneg is on.
> 
> Fixes: 22f48e24a23d ("net: hns3: add autoneg and change speed support for fibre port")
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>   drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> index f5a681d..680c350 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> @@ -726,6 +726,12 @@ static int hns3_check_ksettings_param(const struct net_device *netdev,
>   	u8 duplex;
>   	int ret;
>   
> +	/* hw doesn't support use specified speed and duplex to negotiate,

    I can't parse that, did you mean "using"?

> +	 * unnecessary to check them when autoneg on.
> +	 */
> +	if (cmd->base.autoneg)
> +		return 0;
> +
>   	if (ops->get_ksettings_an_result) {
>   		ops->get_ksettings_an_result(handle, &autoneg, &speed, &duplex);
>   		if (cmd->base.autoneg == autoneg && cmd->base.speed == speed &&
> @@ -787,6 +793,15 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
>   			return ret;
>   	}
>   
> +	/* hw doesn't support use specified speed and duplex to negotiate,

    Here too...

> +	 * ignore them when autoneg on.
> +	 */
> +	if (cmd->base.autoneg) {
> +		netdev_info(netdev,
> +			    "autoneg is on, ignore the speed and duplex\n");
> +		return 0;
> +	}
> +
>   	if (ops->cfg_mac_speed_dup_h)
>   		ret = ops->cfg_mac_speed_dup_h(handle, cmd->base.speed,
>   					       cmd->base.duplex);

MBR, Sergei
