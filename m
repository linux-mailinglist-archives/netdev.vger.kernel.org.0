Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9953A64934C
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 10:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiLKJ0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 04:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiLKJ0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 04:26:08 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BDED118
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 01:26:06 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ud5so21141302ejc.4
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 01:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gVdahFE3VCsg1gB9d5/Q9u5eE8BPZK+mrYotqg2hIQI=;
        b=WkJ0nrMo5rkcmbC0jEiEUWoe+lpYz8LMT2g3ETIXKai3ipMja/7APKVLpqDQ5mlCgl
         HbexCGvC3+l/2WAvq+hJGNVrlSU4kAEDjh0deqWj++gGyme0xfljRvk1lWnXDqu4UZ0T
         963d3O8QHVnzwC8G75/oReE1enUiEwJl3vWuZ3MIKv06V4uNRc8FsnW9gRyG1B6vg41I
         36NAbQgBKtUJIpzlX1latn1u/kEmjiQu8w+5mZW0sLZGKIPUCX1VxYil6UgtLMsFhaCM
         2r60v+u0HaNUdGNFyCnzGnBuDKzVS9viPwSCAuKKbVsH5d0GiV2G0HiQgPu8nnLRSf0U
         Dn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gVdahFE3VCsg1gB9d5/Q9u5eE8BPZK+mrYotqg2hIQI=;
        b=U4LLFEyarBz1cCM+P6YL6aQP3W4Sxt7MCvtCfSNBFsBbHxGf92xBCBR3WAOUZqFwJP
         Nb9iZiwsWxJW8I9NQ9Y+422V4GYqx5B7ZO05q2LW7ERYre34tGl0Gbz49SckMmJENRxk
         N2VzDAwlNnEv+44HkTWvPzS7ll+OHaHKikkIlwTu8ko55gYMUFNC4pCrvuScaUAySa7M
         tKcc/xmDvLB8HEVKyIAPdvffda63MSajZXBi3pL4IcCFuJ5EgQiVEScZ6D/xP/CQhXSV
         viQ0AdBdTtyZXXLNB5Jpu3G1Q/EieVVTOIJ8vJB/3W3x1uhxz3acJuhTOdUYKZLxfmmn
         vR6g==
X-Gm-Message-State: ANoB5pnQ/f1mS43wW/3Pr2+vSNHCEVLvAWSuN/xSU/RH03DwwzqnHO+P
        AIaCtnZnSkEhAKII7TYLjW8Wcw==
X-Google-Smtp-Source: AA0mqf4QXZSjWDGz+Kl+7wOpCymcZnKpCnewBJSQ2/IG7stzl3vTV/T0TqdkYkqkFLmtYTqc5RnYQg==
X-Received: by 2002:a17:907:2dab:b0:7c0:eba9:cf0f with SMTP id gt43-20020a1709072dab00b007c0eba9cf0fmr14222739ejc.30.1670750764415;
        Sun, 11 Dec 2022 01:26:04 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id 23-20020a170906329700b00770812e2394sm1884703ejw.160.2022.12.11.01.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Dec 2022 01:26:03 -0800 (PST)
Message-ID: <90216c45-ce6d-8502-9158-636fbe247ebe@blackwall.org>
Date:   Sun, 11 Dec 2022 11:26:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v2 12/14] bridge: mcast: Support replacement of
 MDB port group entries
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221210145633.1328511-1-idosch@nvidia.com>
 <20221210145633.1328511-13-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221210145633.1328511-13-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/2022 16:56, Ido Schimmel wrote:
> Now that user space can specify additional attributes of port group
> entries such as filter mode and source list, it makes sense to allow
> user space to atomically modify these attributes by replacing entries
> instead of forcing user space to delete the entries and add them back.
> 
> Replace MDB port group entries when the 'NLM_F_REPLACE' flag is
> specified in the netlink message header.
> 
> When a (*, G) entry is replaced, update the following attributes: Source
> list, state, filter mode, protocol and flags. If the entry is temporary
> and in EXCLUDE mode, reset the group timer to the group membership
> interval. If the entry is temporary and in INCLUDE mode, reset the
> source timers of associated sources to the group membership interval.
> 
> Examples:
> 
>  # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent source_list 192.0.2.1,192.0.2.2 filter_mode include
>  # bridge -d -s mdb show
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.2 permanent filter_mode include proto static     0.00
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto static     0.00
>  dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode include source_list 192.0.2.2/0.00,192.0.2.1/0.00 proto static     0.00
> 
>  # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent source_list 192.0.2.1,192.0.2.3 filter_mode exclude proto zebra
>  # bridge -d -s mdb show
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 permanent filter_mode include proto zebra  blocked    0.00
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto zebra  blocked    0.00
>  dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude source_list 192.0.2.3/0.00,192.0.2.1/0.00 proto zebra     0.00
> 
>  # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 temp source_list 192.0.2.4,192.0.2.3 filter_mode include proto bgp
>  # bridge -d -s mdb show
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.4 temp filter_mode include proto bgp     0.00
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 temp filter_mode include proto bgp     0.00
>  dev br0 port dummy10 grp 239.1.1.1 temp filter_mode include source_list 192.0.2.4/259.44,192.0.2.3/259.44 proto bgp     0.00
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * Remove extack from br_mdb_replace_group_sg().
>     * Change 'nlflags' to u16 and move it after 'filter_mode' to pack the
>       structure.
> 
>  net/bridge/br_mdb.c     | 102 ++++++++++++++++++++++++++++++++++++++--
>  net/bridge/br_private.h |   1 +
>  2 files changed, 98 insertions(+), 5 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


