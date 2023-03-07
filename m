Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782076ADA27
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjCGJVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjCGJVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:21:38 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5DD53708
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 01:21:09 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id ec29so18745906edb.6
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 01:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678180868;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pmejKJhY8kS8le1iYDvgZAW/SVHpIgE1uUSZj/e2Qqs=;
        b=VfVM3Pdd3WVogZb/T7XK3ltSunZbHpkSP0HsLlvVw8jpAsJHXrhVsyKFd32Kv3XsI5
         uaKEW90fwJ6sSoE512CsoCtwYqnTvrWEFus3+ripLUGwXDNf+AxTX9qy6Phv9thwgP8q
         oyGoKTNP0adagIy5m2CoonApzy1z0utC23mk02nO0LIZHVnI1nV2BwrPB4QE/RkEzDaM
         0iFFOxUaKD/4gac+QK7cnlJcsYeGRD+pA/6A6m8fKY+AijnWBf6w30jmiQwPqsCSMZ72
         517mb3aghPDiGlq9/5VML06mOoMFrLBPBNst5CUaifKKcsvXq4+j4NMRsoxG3zIeAtFl
         vedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678180868;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pmejKJhY8kS8le1iYDvgZAW/SVHpIgE1uUSZj/e2Qqs=;
        b=L8A/VuVCqcjWlFD53D7Qon2oRMDochp3qycKCrmS6HhFDKKuJadksxBGTRknLv8evF
         s2O5TAPHDqAucdQZjdab0LU5CAk25AoYftvbjzdmiyGLa/MjYNyAW9r4+zIGz+YFmHhQ
         y6cWuIDcNPycJRU+kAE0uwDb51B+tPswDkNiAFeHnQQglgmP1maIrXmLVBcZlpME59nQ
         jIDHbeFaYqv3wmvkIwLUuHQszub/yyLuuGDLU2CGhedAgJSrbi8fTYfKHHjOz/qNzZjt
         F6+bZ1sG/F4u4snBYxNlvw73lVJuUfUknIe8PkjJiAQrMGRTmnv00ig+JLDahARETN7K
         XeJA==
X-Gm-Message-State: AO0yUKUGo9YbkqQhTEY11Yd5/2VETl8wLW7zPghJiUXzLPIHS8PdSA9d
        9C7Za0WFzR2fmYO54X5PiDoTgg==
X-Google-Smtp-Source: AK7set/GwyBiG98g/czRfMSUeCRSbkX/YyJjfGn1sHqj/fRULINCeYQDcSN7SGeWkYjFEaVBwM7lng==
X-Received: by 2002:a05:6402:5154:b0:4ad:7c30:2599 with SMTP id n20-20020a056402515400b004ad7c302599mr12942744edd.13.1678180868391;
        Tue, 07 Mar 2023 01:21:08 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id o26-20020a50c29a000000b004ac54d4da22sm6406095edf.71.2023.03.07.01.21.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 01:21:08 -0800 (PST)
Message-ID: <b4da4a94-4aa7-9653-0f51-a047a39bf4f2@blackwall.org>
Date:   Tue, 7 Mar 2023 11:21:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH nf-next 3/6] netfilter: bridge: move pskb_trim_rcsum out
 of br_nf_check_hbh_len
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
 <688b6037c640efeb6141d4646cc9dc1b657796e7.1677888566.git.lucien.xin@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <688b6037c640efeb6141d4646cc9dc1b657796e7.1677888566.git.lucien.xin@gmail.com>
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
> br_nf_check_hbh_len() is a function to check the Hop-by-hop option
> header, and shouldn't do pskb_trim_rcsum() there. This patch is to
> pass pkt_len out to br_validate_ipv6() and do pskb_trim_rcsum()
> after calling br_validate_ipv6() instead.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/bridge/br_netfilter_ipv6.c | 33 ++++++++++++++-------------------
>  1 file changed, 14 insertions(+), 19 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


