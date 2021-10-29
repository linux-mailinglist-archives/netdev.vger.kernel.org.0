Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC5943FF9A
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhJ2Pc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhJ2Pc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 11:32:56 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C06C061570;
        Fri, 29 Oct 2021 08:30:28 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso359372pjo.3;
        Fri, 29 Oct 2021 08:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NIak2Y5FQ2Wjf4P7X8gzcJU94dOFnB5agLKanXkb2MU=;
        b=VonLltqQY+CqzFXaC7fWfjDqD+2Lersu0M8vMPoboW+ryJRlLf5OsDfV3K/HH3PppW
         xYqGwX7TpJgUu8VMh89eLXsVvcJSogw35ArfPy37oqH4goNQ1J+nku6J4K/D1vBpR/9W
         VMbLVFo59Z09TuF+NQtd1QmuDGxRWD8dSY4wIqXqg/7SKUYsXkEkRqfRKqj+XNBAi2qc
         8jtdDU5CW2jnmdvkeupKSMcvj1NibXpyBM59oWwAmDsU67RW1ZMXdU+sRdIAxavtyTms
         x2bVFWBlmcpwqpbV9RKrezg6vZYCo0QEdgRpZfOBg95QaC44DYEDytav2DfXAyw0FWQ3
         7hXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NIak2Y5FQ2Wjf4P7X8gzcJU94dOFnB5agLKanXkb2MU=;
        b=owm9+l+NwDN1GhQP36Yivpo3Q5QzBJkzkts9kJWGXg8MaFEeDmkhgxrJBMAPPvFpAB
         Nq717yZLMQsLDQ3AhJXmxilIsQhQseu4VfbF5dyzVBclpgHOkKB2ACrBs44XZQ6hjtuV
         HnAOw1vtEQN/aLG4Tugts6aVhpAMkZRE2WaNYcEORjqFWvwLknoxk7+URd+APOJLPxjz
         08sdDVJGDK0FBlhURm0ET4tBed+u7a+2VUgE0a8V6uChI6p9IpOrSF+wLxSO50vODMaM
         +8LcpTqq3vTJYvTafNOQsdoAdScrLzJSWfkAOEtMmHbxNnicDX26wLxiZbPJmn3WzNHY
         CC6g==
X-Gm-Message-State: AOAM533Aq8ZB6e8vPT4AblwO1cC/xjckzhJOQd/0Jy8Xi1ppVSjZtUs0
        yvCKc5bxgSPMcrT3fR6nD7irKlfX9pY=
X-Google-Smtp-Source: ABdhPJyR8O6TcJoaRx+rHzlWxtjHT7cyn8u68xf4QLnyURRfv5wQj7opPBt0X9by/uz16wGcPgryvQ==
X-Received: by 2002:a17:90b:4d8f:: with SMTP id oj15mr4512687pjb.6.1635521427708;
        Fri, 29 Oct 2021 08:30:27 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id v12sm6339671pjs.0.2021.10.29.08.30.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 08:30:27 -0700 (PDT)
Subject: Re: [PATCH] wireguard: queueing: Fix implicit type conversion
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, jiasheng@iscas.ac.cn
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <1635469664-1708957-1-git-send-email-jiasheng@iscas.ac.cn>
 <CAHmME9p9EA0qCw2ha_X9HR7NWSt1Zam4+srYHCs=-U4LvQiJdA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <99a32425-ca42-8d99-1276-efb889300cce@gmail.com>
Date:   Fri, 29 Oct 2021 08:30:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAHmME9p9EA0qCw2ha_X9HR7NWSt1Zam4+srYHCs=-U4LvQiJdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/21 7:27 AM, Jason A. Donenfeld wrote:
> On Fri, Oct 29, 2021 at 3:08 AM Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:
>> It is universally accepted that the implicit type conversion is
>> terrible.
> 
> I'm not so sure about this, but either way, I think this needs a bit
> more justification and analysis to merge. cpumask_weight returns an
> unsigned, for example, and is used as a modulo operand later in the
> function. It looks like nr_cpumask_bits is also unsigned. And so on.
> So you're really trading one implicit type conversion package for
> another. If you're swapping these around, why? It can't be because,
> "it is universally accepted that the implicit type conversion is
> terrible," since you're adding more of it in a different form. Is your
> set of implicit type conversions semantically more proper? If so,
> please describe that. Alternatively, is there a way to harmonize
> everything into one type? Is there a minimal set of casts that enables
> that?
>

I agree with you.

Even standard iterators play/mix with signed/unsigned in plain sight.

extern unsigned int nr_cpu_ids;

unsigned int cpumask_next(int n, const struct cpumask *srcp);

int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap);

#define for_each_cpu(cpu, mask)				\
	for ((cpu) = -1;				\
		(cpu) = cpumask_next((cpu), (mask)),	\
		(cpu) < nr_cpu_ids;)

