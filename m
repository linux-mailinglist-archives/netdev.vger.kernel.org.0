Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B0E954EF
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 05:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbfHTDQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 23:16:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39898 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbfHTDQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 23:16:00 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so2436912pfn.6
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H5l5VwEVR6cm5AaAaDfXtZGzJutNcajFF9yF9r/A2oA=;
        b=pwrA5ykeNBzdeTBrQvzZe+dPqvUWP7bmppda5ZWBS6yiQLu5FwS/xjDDJcZ04ESCun
         aranXoAHfKCrcF4AlTUShTLQIeH7ytiGpOVQVteofxO65n7WvCUikhayl2tCbozIGsuj
         dWvxdhvXvjXoS4cx6WBMwvUuj6l8JMfx320ocddIPY6lZxGlBWbuItuj3huAeABwag+k
         BJ3qchSAzOSD7AZTqKqe5c9pgLNvs9jTVWE4yCnuIaffQGVCnyC0mUz5sBkIIzlSC4f1
         7s1zroq6IdYJZobp8YRcA0bysLQwlfM1YHLuwhkM7bnpAIdbqh/0WOLWa1z2lHcAlCwE
         gCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H5l5VwEVR6cm5AaAaDfXtZGzJutNcajFF9yF9r/A2oA=;
        b=WUcETIQUT7SuUHEMaKq7NiekD37CnIQA2dQlcU3Q4W56/t1dYcVQu/UINavkIt0H60
         t9DImpmlw4Nf4JbmXuvKQ3EFrEmSz05HROjGwUrc2VB8lEULGVJvjQ3dJbzMJsJCdtjT
         Waky/hrdNW7Y7akkRV0qXcvv2uSDezCldq3LZl0Na1MZ7mJhw0OHZ+3kbU7n+P4/uIeO
         UrOL/gZcvnDi7ZjbyAP7bqPnNUTat3n9n/rWN+21imwugUvRt7C6YH/FwrGmX0/aBbjs
         5qs9HRr1fuLxm7uQEiRTuyfcodreCsglz/ILWfsByTld6OlaPL9tZwfDYo5zxYoz05wS
         f2Qg==
X-Gm-Message-State: APjAAAVJiCSXSBlmRBA3s2+kBIBR343c99pfy7Rri20X9JrbivZm6Dau
        ldSnqXSN6jQ7zi3rPlITtWV8hF6L
X-Google-Smtp-Source: APXvYqwpvRjbsHtq6SfKq1lAZoWRdntUzjW+dLEq4JGc+XiKnRhVsT6fMd5jssBnI2pH00XcNIMcIQ==
X-Received: by 2002:a63:1765:: with SMTP id 37mr22985462pgx.447.1566270958844;
        Mon, 19 Aug 2019 20:15:58 -0700 (PDT)
Received: from [10.230.7.147] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id l25sm17630040pff.143.2019.08.19.20.15.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 20:15:58 -0700 (PDT)
Subject: Re: [PATCH net-next 4/6] net: dsa: Don't program the VLAN as pvid on
 the upstream port
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <19610afd-298a-e434-00ea-48eb5b143c1b@gmail.com>
Date:   Mon, 19 Aug 2019 20:15:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820000002.9776-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/2019 5:00 PM, Vladimir Oltean wrote:
> Commit b2f81d304cee ("net: dsa: add CPU and DSA ports as VLAN members")
> programs the VLAN from the bridge into the specified port as well as the
> upstream port, with the same set of flags.
> 
> Consider the typical case of installing pvid 1 on user port 1, pvid 2 on
> user port 2, etc. The upstream port would end up having a pvid equal to
> the last user port whose pvid was programmed from the bridge. Less than
> useful.
> 
> So just don't change the pvid of the upstream port and let it be
> whatever the driver set it internally to be.

This patch should allow removing the !dsa_is_cpu_port() checks from
b53_common.c:b53_vlan_add, about time :)

It seems to me that the fundamental issue here is that because we do not
have a user visible network device that 1:1 maps with the CPU (or DSA)
ports for that matter (and for valid reasons, they would represent two
ends of the same pipe), we do not have a good way to control the CPU
port VLAN attributes.

There was a prior attempt at allowing using the bridge master device to
program the CPU port's VLAN attributes, see [1], but I did not follow up
with that until [2] and then life caught me. If you can/want, that would
be great (not asking for TPS reports).

[1]:
https://lists.linuxfoundation.org/pipermail/bridge/2016-November/010112.html
[2]:
https://lore.kernel.org/lkml/20180624153339.13572-1-f.fainelli@gmail.com/T/

> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  net/dsa/switch.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 84ab2336131e..02ccc53f1926 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -239,17 +239,21 @@ dsa_switch_vlan_prepare_bitmap(struct dsa_switch *ds,
>  			       const struct switchdev_obj_port_vlan *vlan,
>  			       const unsigned long *bitmap)
>  {
> +	struct switchdev_obj_port_vlan v = *vlan;
>  	int port, err;
>  
>  	if (!ds->ops->port_vlan_prepare || !ds->ops->port_vlan_add)
>  		return -EOPNOTSUPP;
>  
>  	for_each_set_bit(port, bitmap, ds->num_ports) {
> -		err = dsa_port_vlan_check(ds, port, vlan);
> +		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> +			v.flags &= ~BRIDGE_VLAN_INFO_PVID;
> +
> +		err = dsa_port_vlan_check(ds, port, &v);
>  		if (err)
>  			return err;
>  
> -		err = ds->ops->port_vlan_prepare(ds, port, vlan);
> +		err = ds->ops->port_vlan_prepare(ds, port, &v);
>  		if (err)
>  			return err;
>  	}
> @@ -262,10 +266,14 @@ dsa_switch_vlan_add_bitmap(struct dsa_switch *ds,
>  			   const struct switchdev_obj_port_vlan *vlan,
>  			   const unsigned long *bitmap)
>  {
> +	struct switchdev_obj_port_vlan v = *vlan;
>  	int port;
>  
> -	for_each_set_bit(port, bitmap, ds->num_ports)
> -		ds->ops->port_vlan_add(ds, port, vlan);
> +	for_each_set_bit(port, bitmap, ds->num_ports) {
> +		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> +			v.flags &= ~BRIDGE_VLAN_INFO_PVID;
> +		ds->ops->port_vlan_add(ds, port, &v);
> +	}
>  }
>  
>  static int dsa_switch_vlan_add(struct dsa_switch *ds,
> 

-- 
Florian
