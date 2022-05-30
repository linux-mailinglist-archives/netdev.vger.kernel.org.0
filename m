Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A359A53753C
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiE3FlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 01:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiE3FlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 01:41:11 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B7860BA8
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 22:41:09 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x143so9647217pfc.11
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 22:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ELuVDV1A8XBW3tErXX/RnWxsBEQcFEA9JAxVl+EVb1o=;
        b=TPj/TsWokjYUplMZgpVoR3cKw8Vm+rCQCppTCvod/urMHGvUjsI/QFGY7kb2aFqCjl
         72erXofLbLRniYsw6w0CpoUUyMcQ6ElvK4LW6h75k9BFxKJ6rem4N4tpRb5v0QMo6kVh
         sIBQBgy84EUStfqaYiEnNzARMq7D8SYotmamF0YFDnhWZ4R2YgCwnCDAj9wc7yKPrZWJ
         qEU1oD9u09iHSSPshFVKx7UDmuLbgxDsxqvyTVeCBAxnKh/+ZpgBksC93aGnotjWRubc
         WK7r/s4qEMc5az9lUXFlGGfRJwHT+BbarNsJ3G6KxLXOOQnxUovYOnDubC2nLIroK8nS
         IOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ELuVDV1A8XBW3tErXX/RnWxsBEQcFEA9JAxVl+EVb1o=;
        b=oSBsGcodIhsuyTm6TXayV0A+9Akyxp/LQxqQkhBk7d/5MzyRvizDKXiStp+oESPPx+
         WFGonVBxmYpgpdAaJWYEtSIkAMLpWzbjCYIW8SWCV2QAQWYsPhG5JZtQcq+AYJ58JJQ3
         QLiGvjJlF/Rwr2scd2Lga8lunpa2Kc4rA9quXef8tddfNvr+neviLSlO3kMHUzm9DKF1
         Jr1ai0RkRjXEP6EaMapPApCQxaHE3RRxv2KglPtbT68WmQCzcddHr0qPZEcO0xMkHEZI
         qVGRhjMT14m4MPW7q6W/UOmpki2Ds1UrNfXSGwZ60ANxjGY7a89fhKf/oJBBzy+vZ8N1
         GR0A==
X-Gm-Message-State: AOAM5316k5dEgCkWGTlLHZYsx35cUCRPjKcux0T34fOi0IC3v9ImHxsy
        FlujqwSYRA0xwG/kRRa7GF0=
X-Google-Smtp-Source: ABdhPJy4fIJ3HWvu/40KUhzZt/rjIAGFi0eLDFs7w2a7X/sKhqtyZvdgrM4um5w60LRq3UB4RSRY/A==
X-Received: by 2002:a63:ea4f:0:b0:3c6:6534:d8f2 with SMTP id l15-20020a63ea4f000000b003c66534d8f2mr46889280pgk.187.1653889269055;
        Sun, 29 May 2022 22:41:09 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902f54600b0016170bb6528sm8186051plf.113.2022.05.29.22.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 22:41:08 -0700 (PDT)
Date:   Mon, 30 May 2022 13:41:00 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] bonding: show NS IPv6 targets in proc master info
Message-ID: <YpRY7NNPNwvRb05M@Laptop-X1>
References: <20220527064419.1837522-1-liuhangbin@gmail.com>
 <e09cd8cf-4779-273e-a354-c1cfba120305@redhat.com>
 <18039.1653693705@famine>
 <YpQzd8BqidUc4IsT@Laptop-X1>
 <734fdf5d-2647-274c-92b5-dab81abe4cbb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <734fdf5d-2647-274c-92b5-dab81abe4cbb@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 29, 2022 at 11:35:21PM -0400, Jonathan Toppins wrote:
> > Yes, I didn't protect the code if if could be build without CONFIG_IPV6.
> > e.g. function bond_get_targets_ip6(). Do you think if I should also
> > add the condition for bond_get_targets_ip6() and ns_targets in struct
> > bond_params?
> 
> Yes, if the code that will use the entries in `struct bonding` and `struct
> bond_params` is going to be compiled out these entries should be compiled
> out as well.

OK, I will fix it.
> 
> Also, I was looking over the code in bond_options.c:bond_opts, and the entry
> `BOND_OPT_NS_TARGETS` is the only bonding option that will be left
> uninitialized if IPv6 is disabled. Does the bonding options infra handle
> this correctly or do you need a dummy set of values when IPv6 is disabled?
> 

The only entry to set ns_target is via netlink, which has protected by
CONFIG_IPV6. So I think it's safe now. To make it more safer. I will add
a dummy set.

Thanks
Hangbin
