Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB31F6ADA05
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCGJQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjCGJQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:16:18 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC05618B6
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 01:16:16 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cw28so49542775edb.5
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 01:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678180575;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pg/NFvmwJGvoKSIhDeKGsWuEVzhl71PHzrq4hemdODk=;
        b=qo5jNn5ub4hP0aHduQg86cN5mwCrkH/oE+KpFRdGD/yrZJhQymzbRi3FYqnFDgvIH6
         GKCVtMYvtGQu8cBBSHJTMu+3aI/g0OaH0CMufkXa3JWOj3xYYpHOJkq4UuTgrH7ZdBOD
         +hB68hMKURdQCvWTZ8o/c5fdXE0JNu77IRQZztqZf9MIbMcZ9iK+npTO7FJCfNFpD6K7
         s4cBK6KdBWbR3+OS53kalSm8r/HhnjHHOJM2jyv5Ak7hOiMMGV+7xLp2oeU48tiQYLSR
         fJf/C1OsR066V9QcorDU0D4cBsXkI/PWt58eC1rXOTmniJHvwDeSyVrZ6ICegUtGTs2g
         xgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678180575;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pg/NFvmwJGvoKSIhDeKGsWuEVzhl71PHzrq4hemdODk=;
        b=wXqUhjdLAk/WFxlS2zn037AxNguMlUZsSLrbV2h0ecTv1zGCOUwvq0iMtEBPSw1fmQ
         +/DvGqDyY9WviR5dzfps/pz3UeitKguM+CqWfFxCWwpgDrCDutMY1ZV2O0FGQUynavDK
         9da9FZuzHUpeSGPrSI+v1VmmjFyCwCKu0zx5A06FKWEEPR+LzofHV5uf7BfrQ2jhcwCf
         pkD7a3lt9bko7WXH04Wd2boKbHkAw/U+r8grvE2ZjJRzSjj9Y/jji+Ha8glj1PuikTzC
         DLS1bfwsuK+TkEJlYwizzd8bLA1iMNT3zCPeshdGVSHsD+sUlji5eIsYrAf8uOVg3B6N
         yn6g==
X-Gm-Message-State: AO0yUKUJHqOttzgjcWmJ9KWk0G89XdvecT6C7jpqyyAqkbyRanoAmSbx
        lhs1+sJjBGF+2Rkfeuhg7fQQhQ==
X-Google-Smtp-Source: AK7set8h9Zt06qvXMQvgPQLYEpMeuYJ69g8TVgOaXmqcWvreNh0u21lHS1Dt94lY5DD4PGIC6mmAWg==
X-Received: by 2002:a17:907:b60a:b0:8e9:afb1:65c6 with SMTP id vl10-20020a170907b60a00b008e9afb165c6mr19865407ejc.13.1678180574894;
        Tue, 07 Mar 2023 01:16:14 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id e22-20020a170906081600b008d1693c212csm5728014ejd.8.2023.03.07.01.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 01:16:14 -0800 (PST)
Message-ID: <4a8e8bd0-e5a0-b416-c0c9-1543d67d709f@blackwall.org>
Date:   Tue, 7 Mar 2023 11:16:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH nf-next 1/6] netfilter: bridge: call pskb_may_pull in
 br_nf_check_hbh_len
To:     Xin Long <lucien.xin@gmail.com>, netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
 <4c156bee64fa58bacb808cead7a7f43d531fd587.1677888566.git.lucien.xin@gmail.com>
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <4c156bee64fa58bacb808cead7a7f43d531fd587.1677888566.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/03/2023 02:12, Xin Long wrote:
> When checking Hop-by-hop option header, if the option data is in
> nonlinear area, it should do pskb_may_pull instead of discarding
> the skb as a bad IPv6 packet.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/bridge/br_netfilter_ipv6.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

