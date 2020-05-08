Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50CE1CA16F
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 05:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgEHDQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 23:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbgEHDQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 23:16:55 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E1CC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 20:16:55 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id x1so134335ejd.8
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 20:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kqWpr1GXZNFnjNayAhdo+Jt+qtlRUzJbGqaz3WYxlwE=;
        b=eG6tGXCFGmrP/gB7pjmRUEYQAKMttJSgQUdbbviV90ip6Hlglyl2Q5MQkzYXBMJ8G+
         8GqUZjnxnDE25UAHnF5oTcNleIQAzlZlcI1LCfW8T8Iic75Ec6oiFxqh/K0qEGtIrK7k
         Uo5cLXk5c/hLeKNH4GWK+D1ZEACrec0eK7xPPdylhGt9ZiMdmtKHjJuZUq0+8+goWd8L
         K3i0O8Jk/7D4s/Q5UOiEzo8v/odBgG0HyT4YQDGCJQX5h0PJBEqfLrEl+kEWSh8zipFR
         ZEdOrfkcQWihu4QYIHJH5BAT8+Del0G0VsLABvzFbuHjhnVFROonT/W5RePVUYI+3igz
         Tasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kqWpr1GXZNFnjNayAhdo+Jt+qtlRUzJbGqaz3WYxlwE=;
        b=I4JNy61y0IBCzoVfGdgd1RTsD622FgPMAbawK4n1Szx1fiDmQ8YtFPXqpSs0J7cn6I
         Lk4qafzlyhoZW0cGOszjorTn3sltup91u8ZU4rLFLU5bc/L8P/FYa/y8QxxIonB9RW3l
         u52k/31fU3x5Bzqy4xD2JJqyIV/zRjm9dCxcoOKixlezo9D1C8TqPS6O+5xadMX2palm
         6/MWdhfygLdr6TGUWv1iqhYi0tGf9Fim39q7dpiadEXjyg9GHrW178xLhaoWdssWjfq5
         y2fbbqxm0LhD+Rr2xSZB2c+zRHmZ2ZTx3IxiHWoo9UNK8tj3wK1LwH63tvKNcUes7aaz
         85Vw==
X-Gm-Message-State: AGi0PuYptMr7lypROunMSBmGHpDTMEWoeLseWNuMrh2JdJ/d9aDaC5Eh
        YpC/8bK8n/U5aLLqlzKZyf1z9VEf
X-Google-Smtp-Source: APiQypIudXNSsnvY2f+1CILLaibz+A/j1XmnqbbaJwwvOiw+9mpdlc3fN+sWEgSJzaI++OYGRyGVbw==
X-Received: by 2002:a17:906:3b18:: with SMTP id g24mr166469ejf.65.1588907813937;
        Thu, 07 May 2020 20:16:53 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m5sm190871edq.71.2020.05.07.20.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 20:16:53 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: permit cross-chip bridging
 between all trees in the system
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, mingkai.hu@nxp.com
References: <20200503221228.10928-1-olteanv@gmail.com>
 <20200503221228.10928-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d4e0a8cf-a059-ff41-8e3e-0bd1fd7b0523@gmail.com>
Date:   Thu, 7 May 2020 20:16:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503221228.10928-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2020 3:12 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> One way of utilizing DSA is by cascading switches which do not all have
> compatible taggers. Consider the following real-life topology:
> 
>       +---------------------------------------------------------------+
>       | LS1028A                                                       |
>       |               +------------------------------+                |
>       |               |      DSA master for Felix    |                |
>       |               |(internal ENETC port 2: eno2))|                |
>       |  +------------+------------------------------+-------------+  |
>       |  | Felix embedded L2 switch                                |  |
>       |  |                                                         |  |
>       |  | +--------------+   +--------------+   +--------------+  |  |
>       |  | |DSA master for|   |DSA master for|   |DSA master for|  |  |
>       |  | |  SJA1105 1   |   |  SJA1105 2   |   |  SJA1105 3   |  |  |
>       |  | |(Felix port 1)|   |(Felix port 2)|   |(Felix port 3)|  |  |
>       +--+-+--------------+---+--------------+---+--------------+--+--+
> 
> +-----------------------+ +-----------------------+ +-----------------------+
> |   SJA1105 switch 1    | |   SJA1105 switch 2    | |   SJA1105 switch 3    |
> +-----+-----+-----+-----+ +-----+-----+-----+-----+ +-----+-----+-----+-----+
> |sw1p0|sw1p1|sw1p2|sw1p3| |sw2p0|sw2p1|sw2p2|sw2p3| |sw3p0|sw3p1|sw3p2|sw3p3|
> +-----+-----+-----+-----+ +-----+-----+-----+-----+ +-----+-----+-----+-----+
> 
> The above can be described in the device tree as follows (obviously not
> complete):
> 
> mscc_felix {
> 	dsa,member = <0 0>;
> 	ports {
> 		port@4 {
> 			ethernet = <&enetc_port2>;
> 		};
> 	};
> };
> 
> sja1105_switch1 {
> 	dsa,member = <1 1>;
> 	ports {
> 		port@4 {
> 			ethernet = <&mscc_felix_port1>;
> 		};
> 	};
> };
> 
> sja1105_switch2 {
> 	dsa,member = <2 2>;
> 	ports {
> 		port@4 {
> 			ethernet = <&mscc_felix_port2>;
> 		};
> 	};
> };
> 
> sja1105_switch3 {
> 	dsa,member = <3 3>;
> 	ports {
> 		port@4 {
> 			ethernet = <&mscc_felix_port3>;
> 		};
> 	};
> };
> 
> Basically we instantiate one DSA switch tree for every hardware switch
> in the system, but we still give them globally unique switch IDs (will
> come back to that later). Having 3 disjoint switch trees makes the
> tagger drivers "just work", because net devices are registered for the
> 3 Felix DSA master ports, and they are also DSA slave ports to the ENETC
> port. So packets received on the ENETC port are stripped of their
> stacked DSA tags one by one.
> 
> Currently, hardware bridging between ports on the same sja1105 chip is
> possible, but switching between sja1105 ports on different chips is
> handled by the software bridge. This is fine, but we can do better.
> 
> In fact, the dsa_8021q tag used by sja1105 is compatible with cascading.
> In other words, a sja1105 switch can correctly parse and route a packet
> containing a dsa_8021q tag. So if we could enable hardware bridging on
> the Felix DSA master ports, cross-chip bridging could be completely
> offloaded.
> 
> Such as system would be used as follows:
> 
> ip link add dev br0 type bridge && ip link set dev br0 up
> for port in sw0p0 sw0p1 sw0p2 sw0p3 \
> 	    sw1p0 sw1p1 sw1p2 sw1p3 \
> 	    sw2p0 sw2p1 sw2p2 sw2p3; do
> 	ip link set dev $port master br0
> done
> 
> The above makes switching between ports on the same row be performed in
> hardware, and between ports on different rows in software. Now assume
> the Felix switch ports are called swp0, swp1, swp2. By running the
> following extra commands:
> 
> ip link add dev br1 type bridge && ip link set dev br1 up
> for port in swp0 swp1 swp2; do
> 	ip link set dev $port master br1
> done
> 
> the CPU no longer sees packets which traverse sja1105 switch boundaries
> and can be forwarded directly by Felix. The br1 bridge would not be used
> for any sort of traffic termination.

Is there anything that prevents br1 from terminating traffic though
(just curious)?

> 
> For this to work, we need to give drivers an opportunity to listen for
> bridging events on DSA trees other than their own, and pass that other
> tree index as argument. I have made the assumption, for the moment, that
> the other existing DSA notifiers don't need to be broadcast to other
> trees. That assumption might turn out to be incorrect. But in the
> meantime, introduce a dsa_broadcast function, similar in purpose to
> dsa_port_notify, which is used only by the bridging notifiers.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
