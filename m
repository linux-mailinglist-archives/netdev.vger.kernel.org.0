Return-Path: <netdev+bounces-12118-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7071E7363DC
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AEE3280E70
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 06:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF2F1FDC;
	Tue, 20 Jun 2023 06:56:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719EF1119
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:56:11 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED76E4D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:56:10 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-988c30a540aso213714966b.3
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1687244168; x=1689836168;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qURJBP/qdgAxM7ZVrKekMbXpVFwIY0w1rl0S98JqRrY=;
        b=pVTj1zp0/qrrmSSVqckn6CBxM+ggdMfq78nPOEWemBGEdrykXBI0XQ2kljMCagq+Vg
         RMvni/PxPuD77mR/DRMbO9fRTIVKirSfiVMekLPIVnnwr7XnyDHWokPxjnK+xs4VQURU
         FmX+jgJujhzW9VZb1h6oYENi7XasxDaHeICz7Emgf1EUbFcPpPP5HGeHzPAfssfx+dHy
         jreQhybyKOcFqVFQMIITHbBHTit45bw8tk/Xx2V7G/mU/3vTgzUXos68Mhl+kYwt/RZc
         DZFeV8EIClWcZzRaJ/gbgY6a/zyR+8uJNyeZ06zruiaIjtSpTBgJpxwcgkrqWbOKYn2M
         Kk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687244168; x=1689836168;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qURJBP/qdgAxM7ZVrKekMbXpVFwIY0w1rl0S98JqRrY=;
        b=A/wppQbMzaarN0jTxEInwWuwpcvA8GpQ7il0JKL8ScJ3G20fWUWXeFaL9jicOu7wUb
         zQYuQRnrQUMioVJe6J2j1X9QwAQLH8FSoXLIyRxQ0a+bhhfco0VKI5FEeShJXqyvucNH
         tcDxr/L7y30w32XoxdAdzoIDQlLXGZIwTT2dq1XPTc1WdvXQUfLq2B/u3hG7p0PiAObL
         yOA8gCfD9DR2CF8wrdtPks/CQMDKr+Cu/zckOz1fvg7oezjcvWLeWJy9gsuQWl3lZGol
         R76NGQvthc9SNlOacW6ODC3r18EtJD7wHBAY2KrJmsWMXrDCPmoNi8sUBQ+beHwb3SKE
         MrVg==
X-Gm-Message-State: AC+VfDzhYZtyAz++nR9rvwvHJnfIWCct+QxT/l6YXCBQf95qSAL+i6V3
	w6StWdAqA6pcLe6SyZbDHjI9OQ==
X-Google-Smtp-Source: ACHHUZ6T+UQkCne8j38UODWyu51fpIgrxO7cDkOq+q+esKt8D9DFBUhL4FlvIu8PyhIgbGfDEBRtAQ==
X-Received: by 2002:a17:907:6092:b0:94a:845c:3529 with SMTP id ht18-20020a170907609200b0094a845c3529mr11896530ejc.9.1687244168414;
        Mon, 19 Jun 2023 23:56:08 -0700 (PDT)
Received: from [192.168.8.136] ([37.63.21.25])
        by smtp.gmail.com with ESMTPSA id z14-20020a1709064e0e00b00987ac9cfb8esm782108eju.67.2023.06.19.23.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 23:56:08 -0700 (PDT)
Message-ID: <3fdb4091-3dc9-e1f2-26a6-561c021c9fae@blackwall.org>
Date: Tue, 20 Jun 2023 09:56:06 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v2 3/3] net: bridge: Add a configurable default
 FDB learning limit
Content-Language: en-US
To: Johannes Nixdorf <jnixdorf-oss@avm.de>, bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
 Vladimir Oltean <vladimir.oltean@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
References: <20230619071444.14625-1-jnixdorf-oss@avm.de>
 <20230619071444.14625-4-jnixdorf-oss@avm.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230619071444.14625-4-jnixdorf-oss@avm.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/19/23 10:14, Johannes Nixdorf wrote:
> This adds a Kconfig option to configure a default FDB learning limit
> system wide, so a distributor building a special purpose kernel can
> limit all created bridges by default.
> 
> The limit is only a soft default setting and overridable per bridge
> using netlink.
> 
> Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
> 
> ---
> 
> Changes since v1:
>   - Added a default limit in Kconfig. (deemed acceptable in review
>     comments)
> 
>   net/bridge/Kconfig     | 13 +++++++++++++
>   net/bridge/br_device.c |  2 ++
>   2 files changed, 15 insertions(+)
> 
> diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
> index 3c8ded7d3e84..c0d9c08088c4 100644
> --- a/net/bridge/Kconfig
> +++ b/net/bridge/Kconfig
> @@ -84,3 +84,16 @@ config BRIDGE_CFM
>   	  Say N to exclude this support and reduce the binary size.
>   
>   	  If unsure, say N.
> +
> +config BRIDGE_DEFAULT_FDB_MAX_LEARNED
> +	int "Default FDB learning limit"
> +	default 0
> +	depends on BRIDGE
> +	help
> +	  Sets a default limit on the number of learned FDB entries on
> +	  new bridges. This limit can be overwritten via netlink on a
> +	  per bridge basis.
> +
> +	  The default of 0 disables the limit.
> +
> +	  If unsure, say 0.
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 8eca8a5c80c6..93f081ce8195 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -530,6 +530,8 @@ void br_dev_setup(struct net_device *dev)
>   	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
>   	dev->max_mtu = ETH_MAX_MTU;
>   
> +	br->fdb_max_learned_entries = CONFIG_BRIDGE_DEFAULT_FDB_MAX_LEARNED;
> +
>   	br_netfilter_rtable_init(br);
>   	br_stp_timer_init(br);
>   	br_multicast_init(br);

IMO this is pointless, noone will set the kconfig option except very 
specific users. I prefer if we leave it to the distribution to set a 
maximum on bridge creation, i.e. make it a distro policy.


