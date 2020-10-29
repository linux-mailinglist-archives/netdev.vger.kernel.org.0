Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640F229E2CE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbgJ2CWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgJ2CWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:22:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4119EC0613D1;
        Wed, 28 Oct 2020 19:22:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x13so1068995pfa.9;
        Wed, 28 Oct 2020 19:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V5JJRMZ/LialouktJyBf7mZSO4NBSF4FBTqd6F9Pi8k=;
        b=IeNhS+Gyv2qKdOjaHQtoBxqrLnpSOXonjzaxaepYpBINZK59SCw0bdEjnEM4KMfThQ
         1NLsKcLfwnF0h5XAT5EyI0DptSB7xjkMGW7KTr+7GkNK0vA3fXKPmX8nNnMwBz6yg4U3
         GxuWR+bTz0RQ5PD42Spt+7mBIHoj86PGpMnMIPbM9VWQkhHbFIoe8POPWSUX8jdAhY26
         wshSbIZ/4VbrXN8Kojs/cobPVgKKPm/bKeaa9clVvVIzZ/5sVK+6586aIeZhA3qQDgG9
         5JQZbCdyOyfjOA6JGQmzenokJUTxGxSijZkxB3S9qllNlLXKKh4tfq56G+z13IrdB+d8
         SwZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V5JJRMZ/LialouktJyBf7mZSO4NBSF4FBTqd6F9Pi8k=;
        b=Z/Xv6i9WHRWD8Qh0nfZSSac2+FKT+tHWiuJcG39ZaXkr5UZF9xN8YNbhbfntqcIyvq
         JnrCdm9XKonhAnxVJyQGdAgcWw3gT+BRwvqv6xNzM1LFvr7/qXU177Cj6Fx+QdUGhR/U
         bCpl4HDRkjeYuL22YkvibrjJPawklgOqAdbE//w8dhW1FaVvLR1uwDLHiAQcG2usa4co
         eZwLOnoQtdxKa2ejVLKNI+TEY23CKBLykSvx3K1sNp33L8fdL8fnBZBSauVTM4Piurrv
         f354fcu22mIZ2nFNUVsOM3tgZudZZnyyv4ORP2LJ8Sxc3BF3e8qP2vUFx6htGUCmF0iE
         HW2A==
X-Gm-Message-State: AOAM532U2nZfyauxFU911iYaFIga1C4xKB6cvzyB811y/f3IJKgeyVhR
        ZZ3sDDvZiOwcRxE4BEav7ok=
X-Google-Smtp-Source: ABdhPJxpJ+gXX35+waw2MH3TvaKILK3+9AoBbHuUkui20aiv9+lsITQX0TlCxdAARkoMff2+MPY+1A==
X-Received: by 2002:a63:4d0b:: with SMTP id a11mr1948937pgb.296.1603938154633;
        Wed, 28 Oct 2020 19:22:34 -0700 (PDT)
Received: from [10.230.28.251] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y3sm891152pfn.167.2020.10.28.19.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 19:22:33 -0700 (PDT)
Subject: Re: [PATCH net-next v7 2/8] net: dsa: Give drivers the chance to veto
 certain upper devices
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20201028074221.29326-1-kurt@linutronix.de>
 <20201028074221.29326-3-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <67c19828-6335-3003-b86b-18d72a961e05@gmail.com>
Date:   Wed, 28 Oct 2020 19:22:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201028074221.29326-3-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2020 12:42 AM, Kurt Kanzenbach wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some switches rely on unique pvids to ensure port separation in
> standalone mode, because they don't have a port forwarding matrix
> configurable in hardware. So, setups like a group of 2 uppers with the
> same VLAN, swp0.100 and swp1.100, will cause traffic tagged with VLAN
> 100 to be autonomously forwarded between these switch ports, in spite
> of there being no bridge between swp0 and swp1.
> 
> These drivers need to prevent this from happening. They need to have
> VLAN filtering enabled in standalone mode (so they'll drop frames tagged
> with unknown VLANs) and they can only accept an 8021q upper on a port as
> long as it isn't installed on any other port too. So give them the
> chance to veto bad user requests.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  include/net/dsa.h |  6 ++++++
>  net/dsa/slave.c   | 12 ++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 04e93bafb7bd..4e60d2610f20 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -536,6 +536,12 @@ struct dsa_switch_ops {
>  	void	(*get_regs)(struct dsa_switch *ds, int port,
>  			    struct ethtool_regs *regs, void *p);
>  
> +	/*
> +	 * Upper device tracking.
> +	 */
> +	int	(*port_prechangeupper)(struct dsa_switch *ds, int port,
> +				       struct netdev_notifier_changeupper_info *info);
> +
>  	/*
>  	 * Bridge integration
>  	 */
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 3bc5ca40c9fb..1919a025c06f 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1987,10 +1987,22 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
>  	switch (event) {
>  	case NETDEV_PRECHANGEUPPER: {
>  		struct netdev_notifier_changeupper_info *info = ptr;
> +		struct dsa_switch *ds;
> +		struct dsa_port *dp;
> +		int err;
>  
>  		if (!dsa_slave_dev_check(dev))
>  			return dsa_prevent_bridging_8021q_upper(dev, ptr);
>  
> +		dp = dsa_slave_to_port(dev);
> +		ds = dp->ds;
> +
> +		if (ds->ops->port_prechangeupper) {
> +			err = ds->ops->port_prechangeupper(ds, dp->index, ptr);

I would pass 'info' instead of 'ptr' here even if there is no functional
difference, this would be clearer. Not a reason to resubmit if
everything else is fine in this series:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
