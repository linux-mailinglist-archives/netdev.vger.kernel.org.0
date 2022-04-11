Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FB54FB6D9
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241133AbiDKJGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiDKJGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:06:12 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979B827FE9
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:03:59 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id u18so6814506eda.3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=b5wwbXc/MkE2BXw9wRrOvThE2qwMTK/x2Eay3+i8p8Y=;
        b=RuXx0L0svxgM1uUy8O5SR+KE9fQGnauKe/NAG+6BRPfBuD/FSYwu4ue2VpaKvbDF+S
         sx/ts5r6zWUBwb07fKFEpz2WczUL3+IJqiki1yp6dxLGxRr7JOLQL5YzWB9899umkoak
         Qc6lX54QI5mfFTeBmMrJYmU3N1d6eakuWywVC6UvOO+TFXsdpepc5VUr9WU4dL7ffkSp
         WUFmdZPABDS5XAjIAaFnQ/7ovVG5g1SNm9NHjoRKwhHHlt5nJaHq8O5sxt9yRmvIBhFB
         KvBevQtqQ3calc3NDma+2E1IFjLtWNwXzHlp1SwaZMAwAjPl+7PLk2ogNaX6tqzWMLrA
         l1Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b5wwbXc/MkE2BXw9wRrOvThE2qwMTK/x2Eay3+i8p8Y=;
        b=SIXPZkGEEPcU3L8+VVtHDudztCFXpAJphpfMnXeHVn+oGHqm6hzj3Bfug9AikWV0lw
         DLqdO0j2hM8vwbdVLRG1dA6hEFpB6UKGNWcwDria0wDLq7anqwKPVveuzyKVOUz8wDjq
         2cXa9q9VVkLHRG1DvxwtPceK5sRoEBjToS7QYE+m03v5hDt3qoMR2/8IuPggTzPgKC8v
         Lz6BpjyMJOTa94uHddbC4gXWYyVyI5yvw+e/M6h/yJfIugeRDwet1Cx1EQRBtjIbc5pZ
         LFm+qJdpnURQQs+U+ezhwN0qi0Q7q5l0KdA0QsGvevMCHr2wt40Bl5j7q90dF4Sc1nxE
         EW/w==
X-Gm-Message-State: AOAM5303FwcQ3B5PyYbmCb8pOaDXuA5Q0kklm8+bBWeJ5yW6cZVmIoAV
        tFK20VT0Beo++Ok6usnMTICekw==
X-Google-Smtp-Source: ABdhPJyzHuHW3cNV1xvb1igQYLrUkhhLP6uI1A5KIHPBfEWjrnGK2Dm60dUyzSFlcevD3bHHZP5QpA==
X-Received: by 2002:aa7:dacd:0:b0:41d:75df:62f with SMTP id x13-20020aa7dacd000000b0041d75df062fmr7182994eds.256.1649667838118;
        Mon, 11 Apr 2022 02:03:58 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id h9-20020aa7c949000000b0041b4d8ae50csm14726914edt.34.2022.04.11.02.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 02:03:57 -0700 (PDT)
Message-ID: <56d91af5-3a5b-be05-a45f-936e427fe746@blackwall.org>
Date:   Mon, 11 Apr 2022 12:03:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 5/6] net: bridge: fdb: add support for flush
 filtering based on ifindex
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20220409105857.803667-1-razor@blackwall.org>
 <20220409105857.803667-6-razor@blackwall.org> <YlPtg6eHuWaOEy/7@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <YlPtg6eHuWaOEy/7@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2022 11:57, Ido Schimmel wrote:
> On Sat, Apr 09, 2022 at 01:58:56PM +0300, Nikolay Aleksandrov wrote:
>> Add support for fdb flush filtering based on destination ifindex. The
>> ifindex must either match a port's device ifindex or the bridge's.
>>
>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>> ---
>>  include/uapi/linux/if_bridge.h | 1 +
>>  net/bridge/br_fdb.c            | 7 +++++++
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
>> index 4638d7e39f2a..67ee12586844 100644
>> --- a/include/uapi/linux/if_bridge.h
>> +++ b/include/uapi/linux/if_bridge.h
>> @@ -819,6 +819,7 @@ enum {
>>  	FDB_FLUSH_NDM_STATE_MASK,
>>  	FDB_FLUSH_NDM_FLAGS,
>>  	FDB_FLUSH_NDM_FLAGS_MASK,
>> +	FDB_FLUSH_PORT_IFINDEX,
>>  	__FDB_FLUSH_MAX
>>  };
>>  #define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>> index 340a2ace1d5e..53208adf7474 100644
>> --- a/net/bridge/br_fdb.c
>> +++ b/net/bridge/br_fdb.c
>> @@ -628,6 +628,7 @@ static const struct nla_policy br_fdb_flush_policy[FDB_FLUSH_MAX + 1] = {
>>  	[FDB_FLUSH_NDM_FLAGS]	= { .type = NLA_U16 },
>>  	[FDB_FLUSH_NDM_STATE_MASK]	= { .type = NLA_U16 },
>>  	[FDB_FLUSH_NDM_FLAGS_MASK]	= { .type = NLA_U16 },
>> +	[FDB_FLUSH_PORT_IFINDEX]	= { .type = NLA_S32 },
>>  };
>>  
>>  int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
>> @@ -664,6 +665,12 @@ int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
>>  		ndm_flags_mask = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_FLAGS_MASK]);
>>  		desc.flags_mask |= __ndm_flags_to_fdb_flags(ndm_flags_mask);
>>  	}
>> +	if (fdb_flush_tb[FDB_FLUSH_PORT_IFINDEX]) {
>> +		int port_ifidx;
>> +
>> +		port_ifidx = nla_get_u32(fdb_flush_tb[FDB_FLUSH_PORT_IFINDEX]);
>> +		desc.port_ifindex = port_ifidx;
> 
> Commit message says "ifindex must either match a port's device ifindex
> or the bridge's", but there is no validation. I realize such an
> operation won't flush anything, but it's cleaner to just reject it here.
> 

Sure, I can add a check for the device when specified.

>> +	}
>>  
>>  	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
>>  		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
>> -- 
>> 2.35.1
>>

