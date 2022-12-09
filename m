Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9196A647ECD
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiLIHyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLIHx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:53:59 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90101DA3
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:53:58 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id co23so4370178wrb.4
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DYM+UIuymwma5G6DYkw7/MsYdvWysx8+7uyf+N85amo=;
        b=uMUfs0YhOECmMRpcaDtjHP0b5MCQYz0N2jamvkr0m5+tMEmHdCAOTRPIdrqV+X0ad/
         kMYd0PKNMjmhPJoVj0+xI76eArlkMFfFR/HiwfOJxEc78IMQ9TXJuNqf/WHy2QNiJtPp
         jVOywPlD45qkPWzxa5aK+qvXB8/OfhqQeJXOz0gFq0jAcbzsMQMHldLz5yrQWAakxv2o
         GxoPM1SusHpUKNHgtI6ufT8l2vlEhk3mwuHR/+A7NOOf7hhaWu5YavN7cQxphZs5a+66
         BRWrrL3wX2Q/aTgVqo90FN5DLFIS/t68kTx3sTTrV4gTP0AgZ/cpuH2xYnLDDzKyczPB
         Sw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DYM+UIuymwma5G6DYkw7/MsYdvWysx8+7uyf+N85amo=;
        b=c+i+PWSfSyMdVnd/CVxvmPTdCmol1r7Gl8YaZ2C8rNxGHKjc+s1Caj82f0a9X96CEX
         g8C00e3B0qrPqXkpUnu/iuwOwdvW5x5yNsTjaaXlT6vui5fzfHAsygxuEJFMjEp7nrPe
         kOYmTU4BjT3TX1Dyyts46glCSujCkzl6Yvm2snmQFmXuruPzQ/ct/fIMZVI9HQuVMOyY
         iFfJADr8TamIZL1+abEiCwaMiPfpcATBFvp9HiFk8UAzX+NdYngntttN2Lkbu7huYCMt
         f+DE85P3FC9rJ1W8QOY/gmh703AWI8wsL4CTDb8mnSfCuo7bAPUMR2CwtROTpsalTQ2W
         hsUg==
X-Gm-Message-State: ANoB5pmXABOHXBjUQu6h57GlADJ3y5s3/sscnRQSZmIN4Vy8qK1NyZFt
        kfOizTCxImhPuXA+jZ550S5smg==
X-Google-Smtp-Source: AA0mqf6gj9OAClEPjKYJmCOrnMh0jFtlMDQWO8Mgo7y/sLRBAoPOZUaHYyYEenY5M2bTJefq+H/OMw==
X-Received: by 2002:adf:eccd:0:b0:242:102c:c571 with SMTP id s13-20020adfeccd000000b00242102cc571mr3126504wro.19.1670572437027;
        Thu, 08 Dec 2022 23:53:57 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id o11-20020a5d4a8b000000b002425be3c9e2sm682374wrq.60.2022.12.08.23.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:53:56 -0800 (PST)
Message-ID: <8cbaccf9-2ca3-b15e-dd1e-85e344a89561@blackwall.org>
Date:   Fri, 9 Dec 2022 09:53:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 11/14] bridge: mcast: Allow user space to specify
 MDB entry routing protocol
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-12-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-12-idosch@nvidia.com>
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
> Add the 'MDBE_ATTR_RTPORT' attribute to allow user space to specify the
> routing protocol of the MDB port group entry. Enforce a minimum value of
> 'RTPROT_STATIC' to prevent user space from using protocol values that
> should only be set by the kernel (e.g., 'RTPROT_KERNEL'). Maintain
> backward compatibility by defaulting to 'RTPROT_STATIC'.
> 
> The protocol is already visible to user space in RTM_NEWMDB responses
> and notifications via the 'MDBA_MDB_EATTR_RTPROT' attribute.
> 
> The routing protocol allows a routing daemon to distinguish between
> entries configured by it and those configured by the administrator. Once
> MDB flush is supported, the protocol can be used as a criterion
> according to which the flush is performed.
> 
> Examples:
> 
>  # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 permanent proto kernel
>  Error: integer out of range.
> 
>  # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 permanent proto static
> 
>  # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent proto zebra
> 
>  # bridge mdb add dev br0 port dummy10 grp 239.1.1.2 permanent source_list 198.51.100.1,198.51.100.2 filter_mode include proto 250
> 
>  # bridge -d mdb show
>  dev br0 port dummy10 grp 239.1.1.2 src 198.51.100.2 permanent filter_mode include proto 250
>  dev br0 port dummy10 grp 239.1.1.2 src 198.51.100.1 permanent filter_mode include proto 250
>  dev br0 port dummy10 grp 239.1.1.2 permanent filter_mode include source_list 198.51.100.2/0.00,198.51.100.1/0.00 proto 250
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto zebra
>  dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude proto static
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1:
>     * Reject protocol for host entries.
> 
>  include/uapi/linux/if_bridge.h |  1 +
>  net/bridge/br_mdb.c            | 15 +++++++++++++--
>  net/bridge/br_private.h        |  1 +
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


