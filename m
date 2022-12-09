Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3044647E8A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiLIH2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiLIH1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:27:20 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9C940921
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:27:04 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h12so4288712wrv.10
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KSkxp9G2CF6S5rppPANiUey7SnfmSrWPD2ZRfSXSe9c=;
        b=wporLZhgoBS3JLFLF2lvV7ZmfJIVRMqul3s5HKG80kGORLsusrqamCFfWUi4gk//e7
         6sAo17PByF0+HJALTxuNovlahMVA+t+gx8r76/bqrEuPYySgzz5+6x0ZLVuFOJwnQZS+
         8Qejh6dBMku5x155Tx0Eosw3KFuIrnqjRcHX9LS62EZWDeM+8IU6q6plOSXvbtHJ+rIM
         UNmYQe87Nkz4Jn+LeUnB7vbjVb85ApvduXTFEpXWjifr+wxImEHBxVwLAQnVhv0ufpHS
         GpXBBcl6fu3s5B0D8W0ThrJH2hL3UZVtVwbJtqMuVKj2ukipe3nr9dyDqOIkbedwdL0t
         dfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSkxp9G2CF6S5rppPANiUey7SnfmSrWPD2ZRfSXSe9c=;
        b=Z4P9rLdMqiRuwGv9FJYnWPP8v+Ix1X25Jg5N1hUG73T2ekeJUllmIl0vz6wn/JI7Hz
         5F64gdfulQKg292ft2tRJwqZ5Rlj7ifW9BrmqXaVArfOXG829S9WrqRU6H10B4iwYcC5
         xs9RSSYbMkqYjPD6gGGePGCNoDFjYsJ//CHZoqKlVM9RgLtHM+Aq2XV+L2Z5T2J5GXrw
         +TxbjHy+g7pQEFEZg4a0AD4c9VxPutrYpqHHXt0WWKbF0a8EBHdxvgDEO+5nGYs87xkZ
         FZs+KEhvrN5Yoe3MOnGLua0+L3hdsjU9Jf7Hdu+82hbYn5CaqzGLuJiO90/FvgXHZNd7
         RrGw==
X-Gm-Message-State: ANoB5pkgxd8lCyETtAD12YQ3HOsNkOu9VXdQPnkaSZ8BTnKVZKKrM0/u
        kC4n1uFBnmwEdo8l/kr27Sr5NQ==
X-Google-Smtp-Source: AA0mqf55D9ni2lDtVr983PKyKzMmoHwLgw9rWJmy5wAILZnGl3Y4d2jpeaFjm06+4eyZL6iP/076Ow==
X-Received: by 2002:a05:6000:1c1d:b0:236:8cca:d3c9 with SMTP id ba29-20020a0560001c1d00b002368ccad3c9mr3415610wrb.53.1670570823189;
        Thu, 08 Dec 2022 23:27:03 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id j18-20020a5d5652000000b002427bfd17b6sm765297wrw.63.2022.12.08.23.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:27:02 -0800 (PST)
Message-ID: <6f71f4e4-9224-efa0-dbe2-e1b35b5526e2@blackwall.org>
Date:   Fri, 9 Dec 2022 09:27:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 01/14] bridge: mcast: Do not derive entry type
 from its filter mode
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-2-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-2-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2022 17:28, Ido Schimmel wrote:
> Currently, the filter mode (i.e., INCLUDE / EXCLUDE) of MDB entries
> cannot be set from user space. Instead, it is set by the kernel
> according to the entry type: (*, G) entries are treated as EXCLUDE and
> (S, G) entries are treated as INCLUDE. This allows the kernel to derive
> the entry type from its filter mode.
> 
> Subsequent patches will allow user space to set the filter mode of (*,
> G) entries, making the current assumption incorrect.
> 
> As a preparation, remove the current assumption and instead determine
> the entry type from its key, which is a more direct way.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index ae7d93c08880..2b6921dbdc02 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -857,17 +857,14 @@ static int br_mdb_add_group(const struct br_mdb_config *cfg,
>  	 * added to it for proper replication
>  	 */
>  	if (br_multicast_should_handle_mode(brmctx, group.proto)) {
> -		switch (filter_mode) {
> -		case MCAST_EXCLUDE:
> -			br_multicast_star_g_handle_mode(p, MCAST_EXCLUDE);
> -			break;
> -		case MCAST_INCLUDE:
> +		if (br_multicast_is_star_g(&group)) {
> +			br_multicast_star_g_handle_mode(p, filter_mode);
> +		} else {
>  			star_group = p->key.addr;
>  			memset(&star_group.src, 0, sizeof(star_group.src));
>  			star_mp = br_mdb_ip_get(br, &star_group);
>  			if (star_mp)
>  				br_multicast_sg_add_exclude_ports(star_mp, p);
> -			break;
>  		}
>  	}
>  

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

