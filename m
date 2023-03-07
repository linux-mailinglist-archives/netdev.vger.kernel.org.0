Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84ACB6ADA3D
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCGJXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjCGJXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:23:16 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB00A248
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 01:22:59 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s11so49579000edy.8
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 01:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678180978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3CV4xGmtFYNdbzkwX5kek77zuPrwZB4wcvYg+ayNP3Y=;
        b=jZdzRjU5cs3942+Ravdkzabj4Ch6JzoIf8DTW/6MlmN+rfEIsAa6fN3c2tbnmKVRNv
         bIB/81x11eHutA1Mr9mhRvWlZO7j6i/qSL9BmDhH9VGU3nS1sy+MLxdI9M1bXgZe3owA
         HDzeMDg0ERapMID+RpOjz7+qDzL1HVGQTJpdjC9h2rLImx4ZitKzM2kQFefsj6mOU2VT
         rgyOOi96eAMnMrJjtkNQvi++i3hKnbo74rl/CjwL0E7bbKQva5/tU5U7w0WfLsUXAUi2
         SuuFC9FBDnuR65iB+vvYQqdXGbputvsKK4M0EgeEJ532zLkQrQj0jM8NY0YXQeCOYScC
         eEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678180978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3CV4xGmtFYNdbzkwX5kek77zuPrwZB4wcvYg+ayNP3Y=;
        b=aXlMoHPj6H5dCyeM07eofIrbGl2C+kDbtDrmRtlXqpjR6SUhAsa7X0UckbZ47RCHAS
         FpR+p+TCtIjT7U9U3/WxdXFqpKQBt+Vx0xO9woUTFUVUzvDSnjHNRxSw+qi9fE1x2eCg
         mA1UhhBkKEea/+7mVNSbCO00nQi0owZn6U9lZoDxK0RQZ8JXXVN2LUQyToMY2SASCfv/
         cVjR/IYJ9TTbw2tr6LsiAf08ZbVhadGhsDJH3jg/IZaaIfuverwaOb8eDEFPirX/ZDsw
         FUVIDTDgVsNX7qOGO4HoAlcx52zJ98eiJz65so1wifRQiJR60RTclIKTYPZn20b4J3qh
         9eNg==
X-Gm-Message-State: AO0yUKUZXQjM2IHoahMdXUrx8WMjRwCo0pz1a0lDhekFtuGFbSitPG0q
        e2c2vuAcswbMgjKQY42vNfHunw==
X-Google-Smtp-Source: AK7set/tU8PPk2hb1gUb+IEhj4sRgoHcRkW67/WECL7TIbGxSV6CVjQRlC81tOrn/c4fIVcBr7WwnA==
X-Received: by 2002:a17:906:4f94:b0:8ed:e8d6:42c4 with SMTP id o20-20020a1709064f9400b008ede8d642c4mr12671879eju.12.1678180977666;
        Tue, 07 Mar 2023 01:22:57 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id b4-20020a170906038400b008d4df095034sm5772613eja.195.2023.03.07.01.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 01:22:57 -0800 (PST)
Message-ID: <5fdfcb5d-dda8-6f51-6ab3-8160f5495312@blackwall.org>
Date:   Tue, 7 Mar 2023 11:22:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH nf-next 5/6] netfilter: use nf_ip6_check_hbh_len in
 nf_ct_skb_network_trim
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
 <5411027934a79f0430edb905ad4b434ec6b8396e.1677888566.git.lucien.xin@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <5411027934a79f0430edb905ad4b434ec6b8396e.1677888566.git.lucien.xin@gmail.com>
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
> For IPv6 Jumbo packets, the ipv6_hdr(skb)->payload_len is always 0,
> and its real payload_len ( > 65535) is saved in hbh exthdr. With 0
> length for the jumbo packets, all data and exthdr will be trimmed
> in nf_ct_skb_network_trim().
> 
> This patch is to call nf_ip6_check_hbh_len() to get real pkt_len
> of the IPv6 packet, similar to br_validate_ipv6().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/netfilter/nf_conntrack_ovs.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 

I'd also recommend to change the scope of "err" as Simon already pointed out.
Other than that looks good to me.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

