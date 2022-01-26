Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731EE49C232
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiAZDh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiAZDhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:37:55 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B10C06161C;
        Tue, 25 Jan 2022 19:37:55 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id e28so17092645pfj.5;
        Tue, 25 Jan 2022 19:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=R8sKbmelU/5Nq/hNaJjM9+nF8whK6mgWzXw+oSrXSRU=;
        b=IQZKDu56KgfX5aXIzJb4UO3I7iRnMRKVFxvb7dT9+zCE5Scw0MysacW8ig9p5Jcp2L
         6Dvb0laRVHwuXsqE660twfJWBibsfdDAVJpHGcO9IAVoucuaOGkKv3ErRI5/HlvHzeD3
         zXPxzlQCfnZu0Ke+W729w7PY+4Y7aKHTEgssafgeLpFa2YlA7pGQf8OzJghReCT8LbYW
         HYsid7KvITFWbmshD6ixm+zmDTPdLTu9VkULOEkXgbViQJsxKFabybbrDQxEL9HzeU36
         JiaSk6uatfis0SY3Z3JbBglibkob022bOs1tPvoKqVFGoCceZy/oi5r/UKq56JOQpniu
         bYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R8sKbmelU/5Nq/hNaJjM9+nF8whK6mgWzXw+oSrXSRU=;
        b=mM+blMsiZObd4Ou9NXZXE+tprfrfUBKGZUiFfBcwOdy/CIR8IA1H7dbljG7Hbs26CG
         UIID7EYhTtbSeK9pxLI9p6hGuylP9zOkXE3MJdL9S+vIFpqrbQJ/w3lge0oWKEGvTJxi
         FD6h67CbiporlDws7VWxAU5q7HfOpCLzvuwwAjU1GKf5GBjqKFsVb9Z4q8NfODVJ5r8K
         4gwD50ryn7LFnI8z597WNs5fG+pszrMHUTGzBJwXO4r1jmM0SkecWmkRF+cvO8v3rTI+
         jEghqJHIVaP18uYuRI00R7DuTMBk39AsrC4Feh8Q6xfFvqNwI7bwtkhTnF8/p83D5YSR
         Ta1g==
X-Gm-Message-State: AOAM533D4vyaqNVhyh3ijHls9w5L9gvDLAWKT68Qj+fqtJI/U8mUCeYE
        7T6cxporw7AmuNPSw/NUeFP7tmg2BhI=
X-Google-Smtp-Source: ABdhPJxK+X9UChip1UawEyExUKiUx62ht18cjCVtTPCwDuYoCdpwBoFGvufp66BsJXs54AOG43w40w==
X-Received: by 2002:a63:8f09:: with SMTP id n9mr17186985pgd.308.1643168274786;
        Tue, 25 Jan 2022 19:37:54 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u21sm432224pfi.149.2022.01.25.19.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:37:54 -0800 (PST)
Message-ID: <dcb0c749-8535-d7ef-5921-6af479f4a432@gmail.com>
Date:   Tue, 25 Jan 2022 19:37:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 09/16] net: dsa: qca8k: add tracking state of
 master port
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-10-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-10-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> MDIO/MIB Ethernet require the master port and the tagger availabale to
> correctly work. Use the new api master_state_change to track when master
> is operational or not and set a bool in qca8k_priv.
> We cache the first cached master available and we check if other cpu
> port are operational when the cached one goes down.
> This cached master will later be used by mdio read/write and mib request to
> correctly use the working function.
> 
> qca8k implementation for MDIO/MIB Ethernet is bad. CPU port0 is the only
> one that answers with the ack packet or sends MIB Ethernet packets. For
> this reason the master_state_change ignore CPU port6 and checkes only
> CPU port0 if it's operational and enables this mode.

s/checkes only/only checks/

> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   drivers/net/dsa/qca8k.c | 18 ++++++++++++++++++
>   drivers/net/dsa/qca8k.h |  1 +
>   2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 039694518788..4bc5064414b5 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -2383,6 +2383,23 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
>   	return qca8k_lag_refresh_portmap(ds, port, lag, true);
>   }
>   
> +static void
> +qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
> +		    bool operational)
> +{
> +	struct dsa_port *dp = master->dsa_ptr;
> +	struct qca8k_priv *priv = ds->priv;
> +
> +	/* Ethernet MIB/MDIO is only supported for CPU port 0 */
> +	if (dp->index != 0)

We sort of have a define for this: QCA8K_CPU_PORT0 even though that enum 
definition might be more accidental than on purpose.

> +		return;
> +
> +	if (operational)
> +		priv->mgmt_master = master;
> +	else
> +		priv->mgmt_master = NULL;

	priv->mgmt_master = operational ? master : NULL;

but this is really because the bike shed is blue. So in any case:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
