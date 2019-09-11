Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E228AFA2C
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 12:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfIKKRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 06:17:08 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39671 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfIKKRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 06:17:08 -0400
Received: by mail-lj1-f196.google.com with SMTP id j16so19452854ljg.6
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 03:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HHRzzoV7NRJaC+wX9s9V5DTVizkcpByr53r0dhYAcVg=;
        b=zES1kZIBhS+m6Od2zZhR/Mlgf0dY5jo8KGsZEBvuEjAthjBQ7XUGs0GLBpD52SRwnA
         7X6S6ZwHKhD/0vQDlDzvAcq3/3XR3JYzJFp1IzjadZ+7Bjle6lgClvuuyLkWU5JJvw7t
         l8uGP8egnLL7qoQBh80zpWU074HQr/PsNg1y8iiONO/yujMGG9Pj46hnsnFuK867abQl
         Tek4xwVtLw4Kv+UFD58gUHF9DkL5ESiEN7+QXmZLjuVlCDb1j+szyTjg3cZbjAgV1UCo
         IKVktML2E6s/mQPCYHzPZGd5EzkDHzqjuPRNXkEQhTpV/BHyYcodekv/ZprVV3VVW80U
         pPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HHRzzoV7NRJaC+wX9s9V5DTVizkcpByr53r0dhYAcVg=;
        b=R/fvfkXIfFCxeqmv8rU+dHhSTd2sW8rXd7ibmW5quoaqJ4C6GsKLYfasjfw74UuQ3W
         QQCq7WpfL3UDGiI84SwkjQhLj02UwkIFCNzee/3etp8DOz8+rcruVOH/4IR06VyNfjdj
         a0u2/vmNv1kPjHSsG8B/YjR0ZL0TlQE6JrP3n65Ny+sYyRPbfqsQsfKhFnYorCIBYXt4
         0Ey9gbhKEWHAPLjQH/Xri1cOVGwa2JSVDi6n5JHJPNRpiVi2OzDzJ7LSwB6LeF30PNOW
         ZJdpFHJG7N9J63jlzbY2IoD/Db88jN24iwGYvu5W9ral55Tzr7vNoz+gC+caJG66n1uI
         0kFw==
X-Gm-Message-State: APjAAAUBoWkv1tGMhb/Bq0P6CHnfhi1DBK359mF2A/PhpuN/vkq7OBii
        L5d43a0ZBUdwcMPPBHv8x3zwow==
X-Google-Smtp-Source: APXvYqz0W9Akn44DPfRBMCBm6kmYIVFmDE5tpxWtOxVdc9UMk+fDn9oEq5xC5iLNSIul/dinpdxt4g==
X-Received: by 2002:a2e:91d9:: with SMTP id u25mr22758502ljg.85.1568197026734;
        Wed, 11 Sep 2019 03:17:06 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:8e6:86de:79c0:860e:c175:7d39? ([2a00:1fa0:8e6:86de:79c0:860e:c175:7d39])
        by smtp.gmail.com with ESMTPSA id h5sm4760682ljf.83.2019.09.11.03.17.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 03:17:06 -0700 (PDT)
Subject: Re: [PATCH V2 net-next 4/7] net: hns3: fix port setting handle for
 fibre port
To:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
References: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
 <1568169639-43658-5-git-send-email-tanhuazhong@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <011fc0e2-1116-37d5-f10b-cb9cbb1b41a2@cogentembedded.com>
Date:   Wed, 11 Sep 2019 13:17:01 +0300
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

    Can't parse that. "For hardware that does not support using", perhaps?

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
