Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BF82711C7
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgITChJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITChI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:37:08 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A01C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:37:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x18so5083642pll.6
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gf2hVMYb3AT5OhowMDOII62ZGavHzxMtZb7DFeqKLTk=;
        b=d5AUUGLIqz6rZyaVBGEHdcRt9v2ICGBfzGKaMvP39cyf2C5mqYCO0r5wIvOzYRCwPw
         tbIg6zmPBf3B+wyG4Cc19lRFYXttCx/9TjF9ItqRF+eAaU29SzHkuxRFWAN1xapxrOa9
         c5ZQk6WvFjFa3rDqn9QWvyvNlaToTWIwUuEkfePYRlv+xKl+CdlhdBFCQ+rMsySvxMJr
         XxvDIaqNO9SMzRfj9hiGLLfoILRkAtKNlolio9Er74dZzI4zIOnAc5CIvepE+KpDfCpA
         r14whHGVthX+uVQTCoNkIIKpdhvEeazGrl8KjEJ8VmMMCPLLWuJXdvxgNDAecqFoXSPT
         +4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gf2hVMYb3AT5OhowMDOII62ZGavHzxMtZb7DFeqKLTk=;
        b=S4JXdMxEmvmhaL474jtGDbR80TanLNTgUP+a5zycSUnQI5dEoR3Oxbb7KOOUIcdjiQ
         NtX+iTEt8v6FOBX2cdRBi+G4uBmVbjH+ZuPgT4XJFxMeB3HvyFK1Y1ATWS87AYLS3I9Z
         dPlQLDoYdml2H9XnNrZDWzPZ91a67W9eZ9Q3eGiCNX1GiOV26Aestb4cYeaIqL0qTXJP
         oy+p7evYEIzefPIDkGQrDSsceP4ZWdZEam3PGniWb0SFORJX9GGq89mWYdkeSqNbHfOt
         hg1Mqv57RNm+bKspIAsg5Gc8d1GFl7L5NMXvCFppxOdSuleMpfrQlOqPJ0tsCoYzZq1+
         j2rg==
X-Gm-Message-State: AOAM531p6ZQeMnWlrqZ5PnSruBLsMN3x7Iz6nq8wVC3GJSE3PDBJ+Has
        DceRlMKe8/Iu32A37GHKqrDz4xljKeEQTA==
X-Google-Smtp-Source: ABdhPJzt24+30pATDLyd626LrlU89K9oAmvgFo1la/6tLoIZmKvbc1Vq3VqCK0n2Kgq642MAZY6quQ==
X-Received: by 2002:a17:90a:d914:: with SMTP id c20mr19990719pjv.34.1600569427983;
        Sat, 19 Sep 2020 19:37:07 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v10sm6722495pjf.34.2020.09.19.19.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 19:37:07 -0700 (PDT)
Subject: Re: [RFC PATCH 4/9] net: dsa: convert denying bridge VLAN with
 existing 8021q upper to PRECHANGEUPPER
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, idosch@idosch.org,
        jiri@resnulli.us, kurt.kanzenbach@linutronix.de, kuba@kernel.org
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
 <20200920014727.2754928-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a4f3e459-06a0-da91-08be-02022bbcadf5@gmail.com>
Date:   Sat, 19 Sep 2020 19:37:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920014727.2754928-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/2020 6:47 PM, Vladimir Oltean wrote:
> This is checking for the following order of operations, and makes sure
> to deny that configuration:
> 
> ip link add link swp2 name swp2.100 type vlan id 100
> ip link add br0 type bridge vlan_filtering 1
> ip link set swp2 master br0
> bridge vlan add dev swp2 vid 100
> 
> Instead of using vlan_for_each(), which looks at the VLAN filters
> installed with vlan_vid_add(), just track the 8021q uppers. This has the
> advantage of freeing up the vlan_vid_add() call for actual VLAN
> filtering.
> 
> There is another change in this patch. The check is moved in slave.c,
> from switch.c. I don't think it makes sense to have this 8021q upper
> check for each switch port that gets notified of that VLAN addition
> (these include DSA links and CPU ports, we know those can't have 8021q
> uppers because they don't have a net_device registered for them), so
> just do it in slave.c, for that one slave interface.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>   net/dsa/slave.c  | 33 +++++++++++++++++++++++++++++++++
>   net/dsa/switch.c | 41 -----------------------------------------
>   2 files changed, 33 insertions(+), 41 deletions(-)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 1940c2458f0f..b88a31a79e2f 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -303,6 +303,28 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
>   	return ret;
>   }
>   
> +/* Must be called under rcu_read_lock() */
> +static int
> +dsa_slave_vlan_check_for_8021q_uppers(struct net_device *slave,
> +				      const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct net_device *upper_dev;
> +	struct list_head *iter;
> +
> +	netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
> +		u16 vid;
> +
> +		if (!is_vlan_dev(upper_dev))
> +			continue;
> +
> +		vid = vlan_dev_vlan_id(upper_dev);
> +		if (vlan->vid_begin <= vid && vlan->vid_end >= vid)
> +			return -EBUSY;

I would find:
		if (vid >= vlan->vid_begin && vid <= vlan->vid_end)

more natural but this works too.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
