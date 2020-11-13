Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1042B16B1
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 08:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgKMHrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 02:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgKMHq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 02:46:59 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773A4C0613D6;
        Thu, 12 Nov 2020 23:46:58 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id y17so6313595ejh.11;
        Thu, 12 Nov 2020 23:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=7ArUtVEP6mH/0212zhITA5CWAlaYP+gUpK58Tfsw8Rg=;
        b=Aef1hoF3OZjRI1EyFrCMiqe6PeCO8u4S3ocmj7J7Al78F7+CptXpWFIJqegfWtMjSL
         uEGT4bGqlR/p7rzL92pY9q2RAfKcc+LM5ykNm2pVy+r+FAJ/csCvKtTEeTOUs1oCnkIR
         Mm/3ocqGWe0m6naEzDOiDOk/cW7JR6Ys1XDMhyOFqhDLqhPxONPS4EZWyhsTiy75AP5G
         TBvACUTrH5tqRnVBkB1XPnjszRn1HZqF0QgV5XNCpbzD2LrCt79SRZVOm+rh9iydBCUz
         jOUOhPqtYXBA7yAEiZ8BNqo1u+Eup+JBBNn+CWAFCHMPnQ/43KVqKbChGg22rGwm8/A5
         iCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=7ArUtVEP6mH/0212zhITA5CWAlaYP+gUpK58Tfsw8Rg=;
        b=ENj0KZCHfozUvbHzr7VUYtd7DaeBDB4BZsfj0Up8FoLM6hZyv7sYsO/T5aR78Knx+A
         Ewv0e/rKMLmH6+9L4/q419YesVNYkoWISfO2OXpZjLRH47A+4AFyG1cTY0l6tuJNqUBI
         9KU1ldBFvSZ3ThRQ1fXADb8koizRvyqR6TAzn1xubtuBwAPDp6nIYpje4s7UC/3d/oVp
         O5u998XGfeitxM1SzA0Zjz3253xUZ9nYLH/BUxB15cCsG44kgI/kysag/JtVWQQiMuif
         G2d/jDZljolXQyrIajblSEsJMYz0I1q8yhZHyJKyynbiAy1ewJxmHq5f2rtFOqI5R01F
         nUUQ==
X-Gm-Message-State: AOAM531wVbOeNEaX63c1/lLgPbuOz+jIjdxXERYk0RJIBYUbj3mdeTlP
        yH3WdfQlzeVfOVwjFe6nB6k=
X-Google-Smtp-Source: ABdhPJxUTI3Izgzl563ouqY1bntHlNqDEvlZuNB8h+OBvKvgIwmmw/LHak4pmNnWWe6ymDWvfPw/Zg==
X-Received: by 2002:a17:906:ae52:: with SMTP id lf18mr807273ejb.9.1605253617103;
        Thu, 12 Nov 2020 23:46:57 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:e113:5d8d:7b96:ca98? (p200300ea8f232800e1135d8d7b96ca98.dip0.t-ipconnect.de. [2003:ea:8f23:2800:e113:5d8d:7b96:ca98])
        by smtp.googlemail.com with ESMTPSA id m27sm3051455eji.64.2020.11.12.23.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 23:46:56 -0800 (PST)
Subject: Re: [PATCH 2/3] net: openvswitch: use core API for updating TX stats
To:     Lev Stipakov <lstipakov@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Cc:     Lev Stipakov <lev@openvpn.net>
References: <20201112111150.34361-1-lev@openvpn.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <598c779c-fb0b-a9a6-43be-3a7cd5b38946@gmail.com>
Date:   Fri, 13 Nov 2020 08:40:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201112111150.34361-1-lev@openvpn.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 12.11.2020 um 12:11 schrieb Lev Stipakov:
> Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
> function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
> stats.
> 
> Use this function instead of own code. While on it, replace
> "len" variable with "skb->len".
> 
Using dev_sw_netstats_tx_add() is fine, however you have to keep
variable len, see remark in the code.

In addition you can replace internal_get_stats() with dev_get_tstats64().

> Signed-off-by: Lev Stipakov <lev@openvpn.net>
> ---
>  net/openvswitch/vport-internal_dev.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
> index 1e30d8df3ba5..116738d36e02 100644
> --- a/net/openvswitch/vport-internal_dev.c
> +++ b/net/openvswitch/vport-internal_dev.c
> @@ -33,23 +33,17 @@ static struct internal_dev *internal_dev_priv(struct net_device *netdev)
>  static netdev_tx_t
>  internal_dev_xmit(struct sk_buff *skb, struct net_device *netdev)
>  {
> -	int len, err;
> +	int err;
>  
> -	len = skb->len;
>  	rcu_read_lock();
>  	err = ovs_vport_receive(internal_dev_priv(netdev)->vport, skb, NULL);

We would have a well-hidden problem here. ovs_vport_receive() calls function
ovs_dp_process_packet() that frees the skb under certain circumstances.
Note that the skb can be freed even if ovs_vport_receive() returns OK.
Using skb->len after calling ovs_vport_receive() could result in a
use-after-free therefore. So you have to keep variable len.

>  	rcu_read_unlock();
>  
> -	if (likely(!err)) {
> -		struct pcpu_sw_netstats *tstats = this_cpu_ptr(netdev->tstats);
> -
> -		u64_stats_update_begin(&tstats->syncp);
> -		tstats->tx_bytes += len;
> -		tstats->tx_packets++;
> -		u64_stats_update_end(&tstats->syncp);
> -	} else {
> +	if (likely(!err))
> +		dev_sw_netstats_tx_add(netdev, 1, skb->len);
> +	else
>  		netdev->stats.tx_errors++;
> -	}
> +
>  	return NETDEV_TX_OK;
>  }
>  
> 

