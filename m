Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F31346535
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhCWQal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbhCWQaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:30:10 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694A5C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:30:10 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x26so14832540pfn.0
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N0SAKrOLDA5omu55RuuXvwIoWmQ6yix+aBndRRr+Ro0=;
        b=gu7bBfc9q6AsfqQhT7RGSwOsq6TnqcxDr3Ct+CseaCK8loL091PZ7vKvFx3YPfkjH4
         srYnYWVyH93IjfKbIKlSzO4vxTMXt6WUgHAxTG7KD9QBRdkgweDJPdKuJWttchAPXO2H
         AfO7Exa6tPn4Ej4d/2lskFfJ4lCrVhxJLzGUwoSR1y49LAyLPVPbOkZGWV1yw7vC+d//
         tpHEuCD1NiEkhZ91pIQmCUf2TQvO71bz9kwVCC+CX7wXLYP7ulfgQGPi/RbTQZTflvyX
         XHq7raOu0WVhWPq6zsINvgnfth623/6fiACyx5iKSsfyEYoQ1o1RVQountHnZRILMamb
         EOQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N0SAKrOLDA5omu55RuuXvwIoWmQ6yix+aBndRRr+Ro0=;
        b=E+yHxvzdmCpn/n/crwAxmknuKBqVfBl6n82uS19qKPzJINydd7RSDcShNxYS7M4v25
         BP6lPvLIi5E1zbjm7tndwsc1FfyT5xA1GkuwyuKBwW+KUF78LvlxEl3jn5H5DAlEVaIE
         TPi4BipTAQ8bOB2f3y9axWNsCWcsrnOSKJPFNVwxTZ8tTVlcwqALOZcKcwU6+ih9kpdN
         Gd6QFCzLsf+xpgg1CORvqej4J6xpL1meoSYq4Lg562sxLf3ZAjLiiS9xknIaQWp9cFEs
         mSGIQUmHT1kerReCjYvm3YCE/dZwo147oIOSenYh7f7gh7fx+srANeCtGFB/uS1+3O9P
         n7jA==
X-Gm-Message-State: AOAM530YMe/67HdWJCgWbdJ1VCwSvkbjyIk8k/Br1nZjp9lugGhMgo4o
        9DqR/Uy+Fr3Cvx6atErBUK5sNan+aY8=
X-Google-Smtp-Source: ABdhPJxs4AP9F/WhENVB0YBdjRS35d2Lne/Oewe9XqZvZXOR9OH4fZyso5UcOV9q0i1yKtEjTAW5Pw==
X-Received: by 2002:a17:902:74c1:b029:e6:ef44:51ee with SMTP id f1-20020a17090274c1b02900e6ef4451eemr5598259plt.14.1616517009253;
        Tue, 23 Mar 2021 09:30:09 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f6sm18544560pfk.11.2021.03.23.09.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 09:30:08 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <20210323113522.coidmitlt6e44jjq@skbuf> <87blbalycs.fsf@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7c14ff72-95d5-2e97-4ff5-8e41fcfab2c6@gmail.com>
Date:   Tue, 23 Mar 2021 09:30:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87blbalycs.fsf@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/23/2021 7:48 AM, Tobias Waldekranz wrote:
> On Tue, Mar 23, 2021 at 13:35, Vladimir Oltean <olteanv@gmail.com> wrote:
>> On Tue, Mar 23, 2021 at 11:23:26AM +0100, Tobias Waldekranz wrote:
>>> All devices are capable of using regular DSA tags. Support for
>>> Ethertyped DSA tags sort into three categories:
>>>
>>> 1. No support. Older chips fall into this category.
>>>
>>> 2. Full support. Datasheet explicitly supports configuring the CPU
>>>    port to receive FORWARDs with a DSA tag.
>>>
>>> 3. Undocumented support. Datasheet lists the configuration from
>>>    category 2 as "reserved for future use", but does empirically
>>>    behave like a category 2 device.
>>>
>>> Because there are ethernet controllers that do not handle regular DSA
>>> tags in all cases, it is sometimes preferable to rely on the
>>> undocumented behavior, as the alternative is a very crippled
>>> system. But, in those cases, make sure to log the fact that an
>>> undocumented feature has been enabled.
>>>
>>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>>> ---
>>>
>>> In a system using an NXP T1023 SoC connected to a 6390X switch, we
>>> noticed that TO_CPU frames where not reaching the CPU. This only
>>> happened on hardware port 8. Looking at the DSA master interface
>>> (dpaa-ethernet) we could see that an Rx error counter was bumped at
>>> the same rate. The logs indicated a parser error.
>>>
>>> It just so happens that a TO_CPU coming in on device 0, port 8, will
>>> result in the first two bytes of the DSA tag being one of:
>>>
>>> 00 40
>>> 00 44
>>> 00 46
>>>
>>> My guess is that since these values look like 802.3 length fields, the
>>> controller's parser will signal an error if the frame length does not
>>> match what is in the header.
>>
>> Interesting assumption.
>> Could you please try this patch out, just for my amusement? It is only
>> compile-tested.
>>
>> -----------------------------[ cut here ]-----------------------------
>> From ab75b63d1bfeccc3032060e6e6dbd2ea8f1d31ed Mon Sep 17 00:00:00 2001
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Date: Tue, 23 Mar 2021 13:03:34 +0200
>> Subject: [PATCH] fsl/fman: ignore RX parse errors on ports that are DSA
>>  masters
>>
>> Tobias reports that when an FMan port receives a Marvell DSA tagged
>> frame (normal/legacy tag, not EtherType tag) which is a TO_CPU frame
>> coming in from device 0, port 8, that frame will be dropped.
>>
>> It appears that the first two bytes of this particular DSA tag (which
>> overlap with what the FMan parser interprets as an EtherType/Length
>> field) look like one of the possible values below:
>>
>> 00 40
>> 00 44
>> 00 46
>>
>> Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> ---
>>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 65 ++++++++++---------
>>  .../net/ethernet/freescale/fman/fman_port.c   |  8 ++-
>>  .../net/ethernet/freescale/fman/fman_port.h   |  2 +-
>>  3 files changed, 42 insertions(+), 33 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> index 720dc99bd1fc..069d38cd63c5 100644
>> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> @@ -55,6 +55,7 @@
>>  #include <linux/phy_fixed.h>
>>  #include <linux/bpf.h>
>>  #include <linux/bpf_trace.h>
>> +#include <net/dsa.h>
>>  #include <soc/fsl/bman.h>
>>  #include <soc/fsl/qman.h>
>>  #include "fman.h"
>> @@ -2447,34 +2448,6 @@ static inline int dpaa_eth_napi_schedule(struct dpaa_percpu_priv *percpu_priv,
>>  	return 0;
>>  }
>>  
>> -static enum qman_cb_dqrr_result rx_error_dqrr(struct qman_portal *portal,
>> -					      struct qman_fq *fq,
>> -					      const struct qm_dqrr_entry *dq,
>> -					      bool sched_napi)
>> -{
>> -	struct dpaa_fq *dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
>> -	struct dpaa_percpu_priv *percpu_priv;
>> -	struct net_device *net_dev;
>> -	struct dpaa_bp *dpaa_bp;
>> -	struct dpaa_priv *priv;
>> -
>> -	net_dev = dpaa_fq->net_dev;
>> -	priv = netdev_priv(net_dev);
>> -	dpaa_bp = dpaa_bpid2pool(dq->fd.bpid);
>> -	if (!dpaa_bp)
>> -		return qman_cb_dqrr_consume;
>> -
>> -	percpu_priv = this_cpu_ptr(priv->percpu_priv);
>> -
>> -	if (dpaa_eth_napi_schedule(percpu_priv, portal, sched_napi))
>> -		return qman_cb_dqrr_stop;
>> -
>> -	dpaa_eth_refill_bpools(priv);
>> -	dpaa_rx_error(net_dev, priv, percpu_priv, &dq->fd, fq->fqid);
>> -
>> -	return qman_cb_dqrr_consume;
>> -}
>> -
>>  static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
>>  			       struct xdp_frame *xdpf)
>>  {
>> @@ -2699,7 +2672,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
>>  		return qman_cb_dqrr_consume;
>>  	}
>>  
>> -	if (unlikely(fd_status & FM_FD_STAT_RX_ERRORS) != 0) {
>> +	if (!netdev_uses_dsa(net_dev) && unlikely(fd_status & FM_FD_STAT_RX_ERRORS) != 0) {
>>  		if (net_ratelimit())
>>  			netif_warn(priv, hw, net_dev, "FD status = 0x%08x\n",
>>  				   fd_status & FM_FD_STAT_RX_ERRORS);
>> @@ -2802,6 +2775,37 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
>>  	return qman_cb_dqrr_consume;
>>  }
>>  
>> +static enum qman_cb_dqrr_result rx_error_dqrr(struct qman_portal *portal,
>> +					      struct qman_fq *fq,
>> +					      const struct qm_dqrr_entry *dq,
>> +					      bool sched_napi)
>> +{
>> +	struct dpaa_fq *dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
>> +	struct dpaa_percpu_priv *percpu_priv;
>> +	struct net_device *net_dev;
>> +	struct dpaa_bp *dpaa_bp;
>> +	struct dpaa_priv *priv;
>> +
>> +	net_dev = dpaa_fq->net_dev;
>> +	if (netdev_uses_dsa(net_dev))
>> +		return rx_default_dqrr(portal, fq, dq, sched_napi);
>> +
>> +	priv = netdev_priv(net_dev);
>> +	dpaa_bp = dpaa_bpid2pool(dq->fd.bpid);
>> +	if (!dpaa_bp)
>> +		return qman_cb_dqrr_consume;
>> +
>> +	percpu_priv = this_cpu_ptr(priv->percpu_priv);
>> +
>> +	if (dpaa_eth_napi_schedule(percpu_priv, portal, sched_napi))
>> +		return qman_cb_dqrr_stop;
>> +
>> +	dpaa_eth_refill_bpools(priv);
>> +	dpaa_rx_error(net_dev, priv, percpu_priv, &dq->fd, fq->fqid);
>> +
>> +	return qman_cb_dqrr_consume;
>> +}
>> +
>>  static enum qman_cb_dqrr_result conf_error_dqrr(struct qman_portal *portal,
>>  						struct qman_fq *fq,
>>  						const struct qm_dqrr_entry *dq,
>> @@ -2955,6 +2959,7 @@ static int dpaa_phy_init(struct net_device *net_dev)
>>  
>>  static int dpaa_open(struct net_device *net_dev)
>>  {
>> +	bool ignore_errors = netdev_uses_dsa(net_dev);
>>  	struct mac_device *mac_dev;
>>  	struct dpaa_priv *priv;
>>  	int err, i;
>> @@ -2968,7 +2973,7 @@ static int dpaa_open(struct net_device *net_dev)
>>  		goto phy_init_failed;
>>  
>>  	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
>> -		err = fman_port_enable(mac_dev->port[i]);
>> +		err = fman_port_enable(mac_dev->port[i], ignore_errors);
>>  		if (err)
>>  			goto mac_start_failed;
>>  	}
>> diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
>> index d9baac0dbc7d..763faec11f5c 100644
>> --- a/drivers/net/ethernet/freescale/fman/fman_port.c
>> +++ b/drivers/net/ethernet/freescale/fman/fman_port.c
>> @@ -106,6 +106,7 @@
>>  #define BMI_EBD_EN				0x80000000
>>  
>>  #define BMI_PORT_CFG_EN				0x80000000
>> +#define BMI_PORT_CFG_FDOVR			0x02000000
>>  
>>  #define BMI_PORT_STATUS_BSY			0x80000000
>>  
>> @@ -1629,7 +1630,7 @@ int fman_port_disable(struct fman_port *port)
>>  	}
>>  
>>  	/* Disable BMI */
>> -	tmp = ioread32be(bmi_cfg_reg) & ~BMI_PORT_CFG_EN;
>> +	tmp = ioread32be(bmi_cfg_reg) & ~(BMI_PORT_CFG_EN | BMI_PORT_CFG_FDOVR);
>>  	iowrite32be(tmp, bmi_cfg_reg);
>>  
>>  	/* Wait for graceful stop end */
>> @@ -1655,6 +1656,7 @@ EXPORT_SYMBOL(fman_port_disable);
>>  /**
>>   * fman_port_enable
>>   * @port:	A pointer to a FM Port module.
>> + * @ignore_errors: If set, do not discard frames received with errors.
>>   *
>>   * A runtime routine provided to allow disable/enable of port.
>>   *
>> @@ -1662,7 +1664,7 @@ EXPORT_SYMBOL(fman_port_disable);
>>   *
>>   * Return: 0 on success; Error code otherwise.
>>   */
>> -int fman_port_enable(struct fman_port *port)
>> +int fman_port_enable(struct fman_port *port, bool ignore_errors)
>>  {
>>  	u32 __iomem *bmi_cfg_reg;
>>  	u32 tmp;
>> @@ -1692,6 +1694,8 @@ int fman_port_enable(struct fman_port *port)
>>  
>>  	/* Enable BMI */
>>  	tmp = ioread32be(bmi_cfg_reg) | BMI_PORT_CFG_EN;
>> +	if (ignore_errors)
>> +		tmp |= BMI_PORT_CFG_FDOVR;
>>  	iowrite32be(tmp, bmi_cfg_reg);
>>  
>>  	return 0;
>> diff --git a/drivers/net/ethernet/freescale/fman/fman_port.h b/drivers/net/ethernet/freescale/fman/fman_port.h
>> index 82f12661a46d..0928361b0e73 100644
>> --- a/drivers/net/ethernet/freescale/fman/fman_port.h
>> +++ b/drivers/net/ethernet/freescale/fman/fman_port.h
>> @@ -147,7 +147,7 @@ int fman_port_cfg_buf_prefix_content(struct fman_port *port,
>>  
>>  int fman_port_disable(struct fman_port *port);
>>  
>> -int fman_port_enable(struct fman_port *port);
>> +int fman_port_enable(struct fman_port *port, bool ignore_errors);
>>  
>>  u32 fman_port_get_qman_channel_id(struct fman_port *port);
>>  
>> -----------------------------[ cut here ]-----------------------------
>>
>> The netdev_uses_dsa thing is a bit trashy, I think that a more polished
>> version should rather set NETIF_F_RXALL for the DSA master, and have the
>> dpaa driver act upon that. But first I'm curious if it works.
> 
> It does work. Thank you!

This is unfortunately not new, the stmmac choked on me with Broadcom
tags as well:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8cad443eacf661796a740903a75cb8944c675b4e
-- 
Florian
