Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCF521F236
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgGNNPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbgGNNPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:15:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BDFC061794
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:15:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g75so5646389wme.5
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PCjcGLeWxMEylzBxwOcSQmoCFLwBY4GeEPrQDHmN/hY=;
        b=geA+GGrTz3JLPWFWmv855lCH2TrzOQtleq9xQCcvZYkx8Pcwg47lgdJNzni68Cp64p
         Wla75b8GIDQiTGQtNmilmCu/SWFZa58Tacicf6TlInFN+RkF1bCcln+Tdt+bu3SDMlMW
         LESiqBsNlzgULNDuM3ANCXWzxQMUvBJh35yOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PCjcGLeWxMEylzBxwOcSQmoCFLwBY4GeEPrQDHmN/hY=;
        b=DgoDc08mU0LEKEs1OQfDqcZoae9ZbfydxytgzOoHpbeDqMtEoOkhPvxGgz9gseuyjJ
         2rP3NCUtdJejTez42LtSSGX4sJ6XJzWSWuvyQ/iWihjj4XqKVdLxCHUupaVUNtw3a7ed
         M0Brwmzj7gxGqkng8z7FOCSR4yp/Ii5Elp9SW9oLRCquo3NXie3Q7n1p7N4bJajmB224
         ZbGXkpOyPDG2aNJQYBZeM8LK9EhI8LnJrsmWHgJKu1AbnoPjJYhlXXbncSbJp2SS298N
         86Tjc1GW6kX3t2mr8WBMO6/USHaiUPSAhVXKXY9CEMiQziMgnv7kZaf+Qw3/KY/8RmQN
         ZLEw==
X-Gm-Message-State: AOAM533GUF4puy3gpc4o9nbkWK9KNBrpFhmnOgJVWA6n36goN6TxtKQd
        KFeqjrDuY2DyXQiBUp0YaoeysA==
X-Google-Smtp-Source: ABdhPJyEe1ow3LNk8kioPrAZ9Q992uWvxW6P8mLOO0Q3aUY9OtPFWs/c9le3UPglodIrcMaHX3khYA==
X-Received: by 2002:a1c:98c1:: with SMTP id a184mr4550304wme.116.1594732523087;
        Tue, 14 Jul 2020 06:15:23 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a22sm4072894wmb.4.2020.07.14.06.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 06:15:22 -0700 (PDT)
Subject: Re: [PATCH net-next v4 04/12] bridge: mrp: Extend br_mrp for MRP
 interconnect
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        jiri@resnulli.us, ivecera@redhat.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
 <20200714073458.1939574-5-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <6267e42e-4f40-db44-e132-98fb29889830@cumulusnetworks.com>
Date:   Tue, 14 Jul 2020 16:15:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200714073458.1939574-5-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 10:34, Horatiu Vultur wrote:
> This patch extends the 'struct br_mrp' to contain information regarding
> the MRP interconnect. It contains the following:
> - the interconnect port 'i_port', which is NULL if the node doesn't have
>   a interconnect role
> - the interconnect id, which is similar with the ring id, but this field
>   is also part of the MRP_InTest frames.
> - the interconnect role, which can be MIM or MIC.
> - the interconnect state, which can be open or closed.
> - the interconnect delayed_work for sending MRP_InTest frames and check
>   for lost of continuity.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_private_mrp.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
> index 315eb37d89f0f..8841ba847fb29 100644
> --- a/net/bridge/br_private_mrp.h
> +++ b/net/bridge/br_private_mrp.h
> @@ -12,8 +12,10 @@ struct br_mrp {
>  
>  	struct net_bridge_port __rcu	*p_port;
>  	struct net_bridge_port __rcu	*s_port;
> +	struct net_bridge_port __rcu	*i_port;
>  
>  	u32				ring_id;
> +	u16				in_id;
>  	u16				prio;
>  
>  	enum br_mrp_ring_role_type	ring_role;
> @@ -21,6 +23,11 @@ struct br_mrp {
>  	enum br_mrp_ring_state_type	ring_state;
>  	u32				ring_transitions;
>  
> +	enum br_mrp_in_role_type	in_role;
> +	u8				in_role_offloaded;
> +	enum br_mrp_in_state_type	in_state;
> +	u32				in_transitions;
> +
>  	struct delayed_work		test_work;
>  	u32				test_interval;
>  	unsigned long			test_end;
> @@ -28,6 +35,12 @@ struct br_mrp {
>  	u32				test_max_miss;
>  	bool				test_monitor;
>  
> +	struct delayed_work		in_test_work;
> +	u32				in_test_interval;
> +	unsigned long			in_test_end;
> +	u32				in_test_count_miss;
> +	u32				in_test_max_miss;
> +
>  	u32				seq_id;
>  
>  	struct rcu_head			rcu;
> 

