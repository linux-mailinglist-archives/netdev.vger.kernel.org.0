Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E592664047E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiLBKV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiLBKVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:21:40 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B2BCD9AF
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 02:21:31 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id o13so10526723ejm.1
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 02:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AE0TKJtwd9IQnencGJnEElxXNLiEn0+mC5tnxibpqHo=;
        b=rtMHpXJWNbX8FNiQYiXlZZ1aTT3z+0lAXZoPtFyvvv6RK0qE9FOpzpf9gVXKKq7Z4S
         yOXF5G0gGOKrnLXUcW10X88pQGq9PoekOIUB1ofEBf2dr8eNofCNIylr5C68CeEDoc+y
         /HZpMlmph7elZiY3qlGZWvwSC01UlEywBS6kRWzHHZKzwiSfPzAhXdCNT54Vn5q8cIsC
         CdX8qwi0zEsvE4bGvtDeuGt7+rPEmnXWPX4QBT/2ty765UqyTVTXHtJkQvw08ZigV6pr
         zWHVRNWfu2thBbau69LkPeF5L6qL8HsbDF002iXXb7OrG5zc1QQqVyzzzsODM/c6HFUU
         rt2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AE0TKJtwd9IQnencGJnEElxXNLiEn0+mC5tnxibpqHo=;
        b=ZUEWQ7UFSB0sSbc5RKA8k0o81OqZ7dTVrwYmd3/x8428CoSD+RBa4xojB1vKrE2CmS
         EvwQSQ4Uhozg58CBxDY3ZM+H2/Ze6hm9ZUOqV3xKtLDC6kkRmhDRMzZrhjGUPbfmwnay
         aZG/K/K+AlwHE8znpfcvOyUVJ+hbjQ9JyXlp/Az2DYLQbP7qillwLqDIQUHzk7OyUKhD
         5wBSeWdnMMGiNJp4bsgStbtRcyLvD7dHxJeakfTvIox3nFkxdpU8+IhQRbPyl8hDgdR3
         m9g4NRfzCu8c2djYaG4OFN0P7GmQLQW9xd9xzEIH5vXXeAV34ogf3PMVoqhMcXSJn/z5
         eGKg==
X-Gm-Message-State: ANoB5pnDSL2zU/yPX6zOeAGs5xP5TpsTcsOZMtkyz/XXWeNh1N+chrFP
        ybLO3IN344raCq6VCNRcmllEDeOPFSFtHwct
X-Google-Smtp-Source: AA0mqf7MI7nZc1kPglk3dKX6GSH2uZUr2yMATDRLWsHDsQp9h6wHZ+xIVL/0p36/B1+B6Cyx0WUN1A==
X-Received: by 2002:a17:906:99d6:b0:7c0:c91c:5d38 with SMTP id s22-20020a17090699d600b007c0c91c5d38mr1077498ejn.50.1669976490081;
        Fri, 02 Dec 2022 02:21:30 -0800 (PST)
Received: from [10.44.2.26] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id r2-20020aa7c142000000b0046182b3ad46sm2787117edp.20.2022.12.02.02.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 02:21:29 -0800 (PST)
Message-ID: <4a86bc13-9f87-bea8-e4f6-db3ea9eadd3e@tessares.net>
Date:   Fri, 2 Dec 2022 11:21:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 06/11] mptcp: add pm listener events
Content-Language: en-GB
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
 <20221130140637.409926-7-matthieu.baerts@tessares.net>
 <20221201200535.14e208ac@kernel.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20221201200535.14e208ac@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 02/12/2022 05:05, Jakub Kicinski wrote:
> On Wed, 30 Nov 2022 15:06:28 +0100 Matthieu Baerts wrote:
>> +	kfree_skb(skb);
> 
> nlmsg_free(), could you inspect the code and follow up?

Good catch, thank you for reporting that!

Geliang has already sent a follow up patch.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
