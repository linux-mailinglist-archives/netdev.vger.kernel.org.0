Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64446ADA20
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCGJUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjCGJUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:20:09 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF8C78C95
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 01:20:06 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id da10so49640391edb.3
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 01:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678180805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zu/hjvWXlUQhawKgHr39aKzFHFibVYuD00ads5+zLRQ=;
        b=bjzwJQ9uC4VEnNp28JY112LiyASziAeFsi32aKqEOWXqmCVe/3gPesr7t/pV4I/YPZ
         N457FtXlvI7xpy35IzsWxORDdm9GEPt0N+lo95LkfKh+6pHyntaLVExi3Uyr0D/9B01i
         l7d4yP7WK840gSbICf/o7YXHjnm955hxXJSa5tgUGsNwS5OgWhy5y6nYbvJnw0i2+9gD
         QMPreLlnDhnRSB98IuYM/X7ajry1j+7ow6ifM25oARzQEiju6bOYMXik6QvHxnh+gJz8
         BMBKSy+3Rsvdshd7gJgt5OVP5X4kHNRcqYLoCcgrsmnnPMpaKc/F8bUiSMAN61M3X0bK
         l36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678180805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zu/hjvWXlUQhawKgHr39aKzFHFibVYuD00ads5+zLRQ=;
        b=OLxdc+wMEyFwfHmDAIm7IWBfDFr+SeocfKR1CaPQvTOEG4NCk666A10+cIuyiyvUg8
         fDYqgcsQIxLcPVtwWIQhRNOPZv/5S8DpsZkGP0kGAFQO6ZOxvkBWoyTsPEEnFv2byDon
         pZIHZBssJpZyNmijiE1StAXyxEy/G5peQcwg7ZvmkEUDF3knB5z8pjeEHN3RilFCTKw0
         a3D+y6j9SXCJDJIaOOpeQELJuf7bcG+8nqKBu/zLXhZazx+LCf6/sX9gEfQtKBINWb+m
         RWsludjlHGHdC1I6i3IzRq6la1S84g8ygseQrehBtGILNQhYPs8hgLNJDYuo7b6l0kgS
         EHUQ==
X-Gm-Message-State: AO0yUKUeV3CWlLIIZXLhP8V5qhSOvteGqqtGY3WI+Kffx7F0CCUskLwo
        mjWKfnBRfMt92bAv7K8VX1o5Pg==
X-Google-Smtp-Source: AK7set+mFVAMIXdWzLWwuXV1apjF3mwxvpxsM8dKiUjZ4IFlSGeJznDezn05zLQCg/m97aIqs7WDKg==
X-Received: by 2002:a50:ee02:0:b0:4c3:6ac8:2aac with SMTP id g2-20020a50ee02000000b004c36ac82aacmr12044793eds.35.1678180805304;
        Tue, 07 Mar 2023 01:20:05 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id m26-20020a50999a000000b004af73333d6esm6439765edb.53.2023.03.07.01.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 01:20:05 -0800 (PST)
Message-ID: <583cc2c7-7883-57fe-6b48-25e5e43c3ec0@blackwall.org>
Date:   Tue, 7 Mar 2023 11:20:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH nf-next 2/6] netfilter: bridge: check len before accessing
 more nh data
Content-Language: en-US
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
 <e5ea0147b3314ad9db5140c7b307472efbd114bd.1677888566.git.lucien.xin@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <e5ea0147b3314ad9db5140c7b307472efbd114bd.1677888566.git.lucien.xin@gmail.com>
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
> In the while loop of br_nf_check_hbh_len(), similar to ip6_parse_tlv(),
> before accessing 'nh[off + 1]', it should add a check 'len < 2'; and
> before parsing IPV6_TLV_JUMBO, it should add a check 'optlen > len',
> in case of overflows.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/bridge/br_netfilter_ipv6.c | 47 ++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 25 deletions(-)


Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


