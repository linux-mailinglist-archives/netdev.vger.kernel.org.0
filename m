Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4831263DB15
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiK3QzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiK3QzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:55:00 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6A98DFD4;
        Wed, 30 Nov 2022 08:54:55 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id v8so24927598edi.3;
        Wed, 30 Nov 2022 08:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OcCrplZ/bxsidYbtcQlDIy3SLmzmFM7eevFHEhiI00E=;
        b=WaIwrUa82CLN0DKh4ow/BAkFb2+oV/a1LdGf1b7/Q5A/Y9SHx6cnT1PLo+I9qoRefH
         BNrhMF93pbjCUeZPqowWw0NYQkZkRaaYceBilPvyoRcEnIjud7mMsySNW2OW4L3/3Lq3
         I5ww9Q92SGyXYe0AZhaK48V9rVHUgNrLj9KLiAXRife9/9Gaf+1fg45PffvLO/zvnIIf
         NdJwVEi/Ud9tS/QltJBLK5M2s6pwt7u0oP7lI1YTcM/RZtt0uyOOZAM3l4im8pMrsU4H
         0Fn6zm3W+G9uUM1gKgwEljdPP+AINZNtvlL5umi4HByIhQe+/L5vqbArWeFQv+cy52wA
         lmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OcCrplZ/bxsidYbtcQlDIy3SLmzmFM7eevFHEhiI00E=;
        b=YQPOFqsZIkAKS9gPLKEZ9dx6E4110kvjAswN3sT57oc3TYUapSO168bkk5j4TLSf+h
         vPXT/uK16+JmqRDsZyK+qDCSEPwyv02l49wgrcipwRMTTfpHanRMkp0XS+f+V36XWZB/
         /R/HfCMSguW+UThEtc8O3fDgXR5aS8LcTfdyvo371VcKUeCv4DbsGRdL+OgBj9D8lc9U
         9JkaeI6via7GER02wg/lj1Y1gi3Jxu4tL6llIznfcnTcIUX8cZxeV96K3/ERFiISdAI5
         RW28zWdAJMLcqmYqZIeSg0SmSD52eq6oGS6n2lodud4fw/3ZLgKhHHB4DI+llSJcA14K
         xkEA==
X-Gm-Message-State: ANoB5pnIlwLDmmmwKz30VLwSXikeNx7XSNm2ZmCPM+TJoXBx6Qga40oa
        g4ZY1YMJkm/jBbtoHXwxyL8=
X-Google-Smtp-Source: AA0mqf6KZmMWnqLmKvd0uxHvRDnkLI1pUwtTHKVUmDAh1pMwhzYcLhLIJW2scrKmZl7m7L6YjYFuPA==
X-Received: by 2002:a05:6402:e9c:b0:458:d064:a8c2 with SMTP id h28-20020a0564020e9c00b00458d064a8c2mr56738852eda.346.1669827294319;
        Wed, 30 Nov 2022 08:54:54 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id m2-20020aa7d342000000b0046b25b93451sm802668edr.85.2022.11.30.08.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 08:54:53 -0800 (PST)
Date:   Wed, 30 Nov 2022 18:54:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221130165443.ewjwm3z7nbwmktcv@skbuf>
References: <20221130143525.934906-1-horatiu.vultur@microchip.com>
 <20221130143525.934906-1-horatiu.vultur@microchip.com>
 <20221130143525.934906-5-horatiu.vultur@microchip.com>
 <20221130143525.934906-5-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130143525.934906-5-horatiu.vultur@microchip.com>
 <20221130143525.934906-5-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Horatiu,

On Wed, Nov 30, 2022 at 03:35:25PM +0100, Horatiu Vultur wrote:
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> index e5a2bbe064f8f..1f6614ee83169 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> @@ -3,6 +3,8 @@
>  #include <linux/ptp_classify.h>
>  
>  #include "lan966x_main.h"
> +#include "vcap_api.h"
> +#include "vcap_api_client.h"
>  
>  #define LAN966X_MAX_PTP_ID	512
>  
> @@ -18,6 +20,17 @@
>  
>  #define TOD_ACC_PIN		0x7
>  
> +/* This represents the base rule ID for the PTP rules that are added in the
> + * VCAP to trap frames to CPU. This number needs to be bigger than the maximum
> + * number of entries that can exist in the VCAP.
> + */
> +#define LAN966X_VCAP_PTP_RULE_ID	1000000
> +#define LAN966X_VCAP_L2_PTP_TRAP	(LAN966X_VCAP_PTP_RULE_ID + 0)
> +#define LAN966X_VCAP_IPV4_EV_PTP_TRAP	(LAN966X_VCAP_PTP_RULE_ID + 1)
> +#define LAN966X_VCAP_IPV4_GEN_PTP_TRAP	(LAN966X_VCAP_PTP_RULE_ID + 2)
> +#define LAN966X_VCAP_IPV6_EV_PTP_TRAP	(LAN966X_VCAP_PTP_RULE_ID + 3)
> +#define LAN966X_VCAP_IPV6_GEN_PTP_TRAP	(LAN966X_VCAP_PTP_RULE_ID + 4)
> +
>  enum {
>  	PTP_PIN_ACTION_IDLE = 0,
>  	PTP_PIN_ACTION_LOAD,
> @@ -35,19 +48,229 @@ static u64 lan966x_ptp_get_nominal_value(void)
>  	return 0x304d4873ecade305;
>  }
>  
> +static int lan966x_ptp_add_trap(struct lan966x_port *port,
> +				int (*add_ptp_key)(struct vcap_rule *vrule,
> +						   struct lan966x_port*),
> +				u32 rule_id,
> +				u16 proto)
> +{
> +	struct lan966x *lan966x = port->lan966x;
> +	struct vcap_rule *vrule;
> +	int err;
> +
> +	vrule = vcap_get_rule(lan966x->vcap_ctrl, rule_id);
> +	if (vrule) {
> +		u32 value, mask;
> +
> +		/* Just modify the ingress port mask and exit */
> +		vcap_rule_get_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK,
> +				      &value, &mask);
> +		mask &= ~BIT(port->chip_port);
> +		vcap_rule_mod_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK,
> +				      value, mask);
> +
> +		err = vcap_mod_rule(vrule);
> +		goto free_rule;
> +	}
> +
> +	vrule = vcap_alloc_rule(lan966x->vcap_ctrl, port->dev,
> +				LAN966X_VCAP_CID_IS2_L0,
> +				VCAP_USER_PTP, 0, rule_id);
> +	if (!vrule)
> +		return -ENOMEM;
> +	if (IS_ERR(vrule))
> +		return PTR_ERR(vrule);
> +
> +	err = add_ptp_key(vrule, port);
> +	if (err)
> +		goto free_rule;
> +
> +	err = vcap_set_rule_set_actionset(vrule, VCAP_AFS_BASE_TYPE);
> +	err |= vcap_rule_add_action_bit(vrule, VCAP_AF_CPU_COPY_ENA, VCAP_BIT_1);
> +	err |= vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE, LAN966X_PMM_REPLACE);
> +	err |= vcap_val_rule(vrule, proto);
> +	if (err)
> +		goto free_rule;
> +
> +	err = vcap_add_rule(vrule);
> +
> +free_rule:
> +	/* Free the local copy of the rule */
> +	vcap_free_rule(vrule);
> +	return err;
> +}
> +
> +static int lan966x_ptp_del_trap(struct lan966x_port *port,
> +				u32 rule_id)
> +{
> +	struct lan966x *lan966x = port->lan966x;
> +	struct vcap_rule *vrule;
> +	u32 value, mask;
> +	int err;
> +
> +	vrule = vcap_get_rule(lan966x->vcap_ctrl, rule_id);
> +	if (!vrule)
> +		return -EEXIST;
> +
> +	vcap_rule_get_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK, &value, &mask);
> +	mask |= BIT(port->chip_port);

Does the VCAP API not abstract away the negative mask representation of
the IGR_PORT_MASK field? I guess someone will stumble upon this in the
future and introduce a bug. In ocelot, struct ocelot_vcap_filter ::
ingress_port_mask ended being used quite in a wide variety of places.
It would be quite messy, unintuitive and tiring to treat it like a
reverse port mask everywhere it is used. In ocelot_vcap.c, it is just
reversed in the vcap_key_set() call.

> +
> +	/* No other port requires this trap, so it is safe to remove it */
> +	if (mask == GENMASK(lan966x->num_phys_ports, 0)) {
> +		err = vcap_del_rule(lan966x->vcap_ctrl, port->dev, rule_id);
> +		goto free_rule;
> +	}
> +
> +	vcap_rule_mod_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK, value, mask);
> +	err = vcap_mod_rule(vrule);
> +
> +free_rule:
> +	vcap_free_rule(vrule);
> +	return err;
> +}
> +
> +static int lan966x_ptp_add_l2_key(struct vcap_rule *vrule,
> +				  struct lan966x_port *port)
> +{
> +	return vcap_rule_add_key_u32(vrule, VCAP_KF_ETYPE, ETH_P_1588, ~0);
> +}
> +
> +static int lan966x_ptp_add_ip_event_key(struct vcap_rule *vrule,
> +					struct lan966x_port *port)
> +{
> +	return vcap_rule_add_key_u32(vrule, VCAP_KF_L4_DPORT, 319, ~0) ||

s/319/PTP_EV_PORT/

> +	       vcap_rule_add_key_bit(vrule, VCAP_KF_TCP_IS, VCAP_BIT_0);
> +}
> +
> +static int lan966x_ptp_add_ip_general_key(struct vcap_rule *vrule,
> +					  struct lan966x_port *port)
> +{
> +	return vcap_rule_add_key_u32(vrule, VCAP_KF_L4_DPORT, 320, ~0) ||

s/320/PTP_GEN_PORT/

> +		vcap_rule_add_key_bit(vrule, VCAP_KF_TCP_IS, VCAP_BIT_0);
> +}
> +
> +static int lan966x_ptp_add_l2_rule(struct lan966x_port *port)
> +{
> +	return lan966x_ptp_add_trap(port, lan966x_ptp_add_l2_key,
> +				    LAN966X_VCAP_L2_PTP_TRAP, ETH_P_ALL);
> +}
> +
> +static int lan966x_ptp_add_ipv4_rules(struct lan966x_port *port)
> +{
> +	int err;
> +
> +	err = lan966x_ptp_add_trap(port, lan966x_ptp_add_ip_event_key,
> +				   LAN966X_VCAP_IPV4_EV_PTP_TRAP, ETH_P_IP);
> +	if (err)
> +		return err;
> +
> +	err = lan966x_ptp_add_trap(port, lan966x_ptp_add_ip_general_key,
> +				   LAN966X_VCAP_IPV4_GEN_PTP_TRAP, ETH_P_IP);
> +	if (err)
> +		lan966x_ptp_del_trap(port, LAN966X_VCAP_IPV4_EV_PTP_TRAP);
> +
> +	return err;
> +}

There's a comical amount of code duplication between this and ocelot_ptp.c,
save for the fact that it was written by different people. Is there any
possibility to reuse code with ocelot?
