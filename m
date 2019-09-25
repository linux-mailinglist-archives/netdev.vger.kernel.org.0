Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6802BBD8B7
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 09:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442452AbfIYHGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 03:06:36 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:58912 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442434AbfIYHGg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 03:06:36 -0400
Received: from [10.1.8.111] (unknown [10.1.8.111])
        by uho.ysoft.cz (Postfix) with ESMTP id 60D91A31B2;
        Wed, 25 Sep 2019 09:06:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1569395194;
        bh=dS5lPxtAdxU5y/gQ3JdHbXiblfvxxhhR3vW+A8OnSGM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OXLEKZqHr8iEg+GId40bcJ0xK3EKXFePb6+zZI/l+koXMnX1ASIBi5p3mvdJP6SF8
         9n84T0rjGlKG0oyNV7DdBZGJ1yCdpKoTEpgd0kaWg15C/t/q7ARsCUK/utuZjcavAN
         zKWdtaG9PnBk4vefjC8g2mz7dNhhSLMxgRTP1Edc=
Subject: Re: [PATCH net] net: dsa: qca8k: Fix port enable for CPU port
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20190925004707.1799-1-andrew@lunn.ch>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <2009a5fe-6c9c-4326-1161-b6c0b7cc586c@ysoft.com>
Date:   Wed, 25 Sep 2019 09:06:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925004707.1799-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25. 09. 19 2:47, Andrew Lunn wrote:
> The CPU port does not have a PHY connected to it. So calling
> phy_support_asym_pause() results in an Opps. As with other DSA
> drivers, add a guard that the port is a user port.
> 
> Reported-by: Michal Vokáč <michal.vokac@ysoft.com>

Thank you for the prompt fix Andrew!

Tested-by: Michal Vokáč <michal.vokac@ysoft.com>

> Fixes: 0394a63acfe2 ("net: dsa: enable and disable all ports")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>   drivers/net/dsa/qca8k.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 16f15c93a102..684aa51684db 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -936,6 +936,9 @@ qca8k_port_enable(struct dsa_switch *ds, int port,
>   {
>   	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
>   
> +	if (!dsa_is_user_port(ds, port))
> +		return 0;
> +
>   	qca8k_port_set_status(priv, port, 1);
>   	priv->port_sts[port].enabled = 1;
>   
> 

