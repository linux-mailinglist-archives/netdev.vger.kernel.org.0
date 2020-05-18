Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12C81D6F63
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 05:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgERDke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 23:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgERDke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 23:40:34 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF99BC061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 20:40:32 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id s1so8827745qkf.9
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 20:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M65DOpRf+5y4QtRlmmeu6UEPb9j6/mdRmbnjg+ZOFAc=;
        b=jM27OTaML8y9dY3KWRHySm14eA+6jNh/+AdFfztK+fmSPA1YXk11/toKwSonprsUNG
         dBCKXVI/BsbHgkbL+BDAPj5BvBOAgbGHgEBsQyKvmPNjuKzA3So8YOxsCvd0R0UhYK0a
         9OhH8jwT8H4EBRFfuGXPbq04ms69+tHC4gsC82oMQ4j+utXmEbaa32KShjhRHteYHwF3
         MJG+do7MrqTsL+wJYEDyj4EAX9XiJc6WfX1IVGU83JdSDlDsMk6stcu35imN8MlNDrNO
         AcMlN6do2R/XpCPbNN6M80Sit97Vvq2cYzC0G+VtapQJsEqzBYPhu8rVS+MhCKr3hoDJ
         dWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M65DOpRf+5y4QtRlmmeu6UEPb9j6/mdRmbnjg+ZOFAc=;
        b=CBRtcUhxOWF39Rke5bzujSSQMym78Nbt7qIfrtJ7b3BlFs440Bv/Khij0hu/wap7RB
         MQuSoqlSygZDUCAPyvwnF7IP3jrTwdjEnhxOd6Jylwp5AvpttrONNUTIWMd56i1M5ulw
         39KfzFVOPSl0cRftZlWx1fj+Boi5oj37WZIX6kU2zAfTl3L8G2ndB/KA0lHtd+BOgvBy
         QlLqaE4aQ7Z0eTWlAxE+AJsoD2jt1VVr55mxFNE8ablUBB95p5oJIDx4n5RgjkqFfFjq
         NATdAZPD9C9kW9zBTVu21ucJcradJqwNXp8PgFME4dwwPBZM6QgP1M1H5po3omzUNxfS
         JRig==
X-Gm-Message-State: AOAM530QvnuAzD3IhJjZi5ZtuZNXNoMvc+7vybxPxKO5h4UYdr43EKlJ
        yhUyT/N8vzTv8Lh8hkRJysw=
X-Google-Smtp-Source: ABdhPJwM53JvUKn1MhDma23DpLAW6TMO8wbTq1mjz4C2N6YW5xJelq7aaXxziIGFQJeT0SOJgtP14Q==
X-Received: by 2002:a37:aa4e:: with SMTP id t75mr13578601qke.46.1589773231040;
        Sun, 17 May 2020 20:40:31 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f866:b23:9405:7c31? ([2601:282:803:7700:f866:b23:9405:7c31])
        by smtp.googlemail.com with ESMTPSA id z25sm8463945qtj.75.2020.05.17.20.40.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 20:40:30 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <5ebf1d9cdc146_141a2acf80de25b892@john-XPS-13-9370.notmuch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a35c0606-92d6-1b05-6292-af4a0aff5723@gmail.com>
Date:   Sun, 17 May 2020 21:40:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <5ebf1d9cdc146_141a2acf80de25b892@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am trying to understand the resistance here. There are ingress/egress
hooks for most of the layers - tc, netfilter, and even within bpf APIs.
Clearly there is a need for this kind of symmetry across the APIs, so
why the resistance or hesitation for XDP?

Stacking programs on the Rx side into the host was brought up 9
revisions ago when the first patches went out. It makes for an
unnecessarily complicated design and is antithetical to the whole
Unix/Linux philosophy of small focused programs linked together to
provide a solution.

Can you elaborate on your concerns?
