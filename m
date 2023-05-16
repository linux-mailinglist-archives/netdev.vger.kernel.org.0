Return-Path: <netdev+bounces-2914-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68A64704802
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6136E1C20DEA
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541862C723;
	Tue, 16 May 2023 08:38:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435912C722
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:38:19 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE7A40DE
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:38:14 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-965d2749e2eso2098302066b.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684226293; x=1686818293;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qoPnstjPrS2tzxEaPLFxVKxPj2WD+daPAFjbj9WTzeA=;
        b=x+AYYlvmcvoPE6XEGFZ+zXR1dy97/Gjk9/JFLJgq598TT4S2KgCmm7js1PYCuIu2aa
         BgK6e/PbU25N55S47oUFbt8DQ4RJSpuOYyYOf1QTi3BuRFdSSSrcJnkgzDDzV3lX7Uo4
         ZuCRK7bEeBkio/9mz3kpnivYgynTlowWBwmnd6Z0jR2frjS+euEznXRhH7wr1/TJ6QLq
         VDdyZKJttmdjpHvDAzqdFAroThW0zhwWEcLH4NRdbcEGY1FbzjnHSzc8Rm9Lp/A+flMK
         2enzAg2BLSXp1asCYWGYxX6zQ2eupJXgV0c/Xooa8maBNLaUOO0FajLMXLjLcnXgTGpl
         o7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684226293; x=1686818293;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qoPnstjPrS2tzxEaPLFxVKxPj2WD+daPAFjbj9WTzeA=;
        b=DQxM4yFe1jCEnnupFxuvEuAO9YiGzrQBUQiHMCcdSv3tpqKi8CYxqc76oHss92ADpg
         t75dFPWYAFctr2H3vzJ6Dpmolarc2rk+CqA+7gMpyP8marfNc00hqHu9EGa61FtlSk/6
         EsTkGl0irQ268W5/1T2w2g6IG+pDY6bQV9e2mIVMlr3xly57O/oHptc8GKdQov/meVuf
         Bce6VUBEeF1cy+yBvTt0nCkROr1c9naifJ3PM/rYvfSohq3269hVBAr38QBTnkac/Jtg
         9u3575pVoH+VIfo9u6JshKqds0sR5gq/0oIp7LOXtkATGMNJ47WA58ex6xVJICW1Cv6f
         OHIw==
X-Gm-Message-State: AC+VfDzD4JhCEk1Xmr7pPeKrDcExYxvGWB8dcbO61++cdUaUtJqZaPSI
	4O2QM2mBvH8pZfgurRjSu8FDFg==
X-Google-Smtp-Source: ACHHUZ6Q+QdDd2QgHb7UBFSvM9CUZLslb7mOVHq9gxwNwTBL5U4Ajwc98dA6zarZLWptkeY381IbrA==
X-Received: by 2002:a17:907:168d:b0:969:f677:11b9 with SMTP id hc13-20020a170907168d00b00969f67711b9mr27436435ejc.54.1684226293002;
        Tue, 16 May 2023 01:38:13 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id tk13-20020a170907c28d00b0094f185d82dcsm10506975ejc.21.2023.05.16.01.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 01:38:12 -0700 (PDT)
Message-ID: <a1d13117-a0c5-d06e-86b7-eacf4811102f@blackwall.org>
Date: Tue, 16 May 2023 11:38:11 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] bridge: Add a limit on FDB entries
Content-Language: en-US
To: Johannes Nixdorf <jnixdorf-oss@avm.de>, netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230515085046.4457-1-jnixdorf-oss@avm.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15/05/2023 11:50, Johannes Nixdorf wrote:
> A malicious actor behind one bridge port may spam the kernel with packets
> with a random source MAC address, each of which will create an FDB entry,
> each of which is a dynamic allocation in the kernel.
> 
> There are roughly 2^48 different MAC addresses, further limited by the
> rhashtable they are stored in to 2^31. Each entry is of the type struct
> net_bridge_fdb_entry, which is currently 128 bytes big. This means the
> maximum amount of memory allocated for FDB entries is 2^31 * 128B =
> 256GiB, which is too much for most computers.
> 
> Mitigate this by adding a bridge netlink setting IFLA_BR_FDB_MAX_ENTRIES,
> which, if nonzero, limits the amount of entries to a user specified
> maximum.
> 
> For backwards compatibility the default setting of 0 disables the limit.
> 
> All changes to fdb_n_entries are under br->hash_lock, which means we do
> not need additional locking. The call paths are (✓ denotes that
> br->hash_lock is taken around the next call):
> 
>  - fdb_delete <-+- fdb_delete_local <-+- br_fdb_changeaddr ✓
>                 |                     +- br_fdb_change_mac_address ✓
>                 |                     +- br_fdb_delete_by_port ✓
>                 +- br_fdb_find_delete_local ✓
>                 +- fdb_add_local <-+- br_fdb_changeaddr ✓
>                 |                  +- br_fdb_change_mac_address ✓
>                 |                  +- br_fdb_add_local ✓
>                 +- br_fdb_cleanup ✓
>                 +- br_fdb_flush ✓
>                 +- br_fdb_delete_by_port ✓
>                 +- fdb_delete_by_addr_and_port <--- __br_fdb_delete ✓
>                 +- br_fdb_external_learn_del ✓
>  - fdb_create <-+- fdb_add_local <-+- br_fdb_changeaddr ✓
>                 |                  +- br_fdb_change_mac_address ✓
>                 |                  +- br_fdb_add_local ✓
>                 +- br_fdb_update ✓
>                 +- fdb_add_entry <--- __br_fdb_add ✓
>                 +- br_fdb_external_learn_add ✓
> 
> Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
> ---
>  include/uapi/linux/if_link.h | 1 +
>  net/bridge/br_device.c       | 2 ++
>  net/bridge/br_fdb.c          | 6 ++++++
>  net/bridge/br_netlink.c      | 9 ++++++++-
>  net/bridge/br_private.h      | 2 ++
>  5 files changed, 19 insertions(+), 1 deletion(-)
> 

I completely missed the fact that you don't deal with the situation where you already have fdbs created
and a limit is set later, then it would be useless because it will start counting from 0 even though
there are already entries. Also another issue that came to mind is that you don't deal with fdb_create()
for "special" entries, i.e. when adding a port. Currently it will print an error, but you should revisit
all callers and see where it might be a problem.




