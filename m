Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E6C3909B4
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 21:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhEYThC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 15:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhEYThC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 15:37:02 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1105C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 12:35:31 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id u33so16632995qvf.9
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 12:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gSsCLDJJZUmBzGQdFGlj6TWUswdWupQSF2qzwB+7rvE=;
        b=gk8/zRDkAvonTnslqlEVJsOYbm2rGBaIF8/kNSgA+4hqYMBhe1zyxBK3MA3LH5MY30
         9adDbV84t6bYBeb6Ml+boBLPd+GhRJs/lVjYnyz+Av2YrZ2FedfOnt83wdyJe32kLsKS
         B/G7a2UzCAsjsQo8sr8X1BkrsCTbUGEAcZydkAG42r+wP0a4Ti9m09SDZSw8x2+it3qj
         noDMtQS9HPe6D0wvaVXbs2H7tVgwwW25UkWt1+ufAtZswsA+z1KbS0rlxWClUX3lGpMJ
         nAPnR/C65auwiSUquzF6xI5sSAVThTDHdyqng441Z/5BF+oe9h0KXM1h5s7J/zf+MOgB
         /fmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gSsCLDJJZUmBzGQdFGlj6TWUswdWupQSF2qzwB+7rvE=;
        b=R4RsRfw3ijL1C7V2XGXtLrkyB/VkGOy86hxoMObl3AKDsb7Khsj1Ta0DQp9hFgjyWB
         zqsk/9IRAEA/OIFEh0DrRdYd06pnKHnQAcWIggmzpLnh74vtW5DNinRAz8Q38SRfUR7t
         vP/2/M0VJq8g829KO1tcG+8um2l7Wrk0LM0x82gCtb4DnzGuxgOrlLCQOAgn0mg8bbJh
         rbbJM2WjoURR0yZ36FXAHdOv8lUzUMaBi5f7xgTbTzPZPyYtAiWyprgI+PT1Td3Bauta
         RGRweJcOgqc/85dIrfaQIP2QmQiiDXces4sX+ttfRO/89VJJAG9qXmnfbyy9bUlLkBOM
         u/fg==
X-Gm-Message-State: AOAM532vlHs6odeo8/tiPklZ3cfwtxuOW0RRKX2smOUPDdzLJcFBCyMd
        tRGcsN039Yu8J/9O9XcyIdt/XA==
X-Google-Smtp-Source: ABdhPJwLuLVTRFoNUscNyLkGhi5cZfQo7AQgtGXDnzSRxYCsqP+uNP7gL+BVxz4ENvZZsPPs2n0xgg==
X-Received: by 2002:ad4:5343:: with SMTP id v3mr39071570qvs.45.1621971331234;
        Tue, 25 May 2021 12:35:31 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-28-184-148-47-211.dsl.bell.ca. [184.148.47.211])
        by smtp.googlemail.com with ESMTPSA id p11sm72483qtl.82.2021.05.25.12.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 12:35:30 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <bcbf76c3-34d4-d550-1648-02eda587ccd7@mojatatu.com>
Date:   Tue, 25 May 2021 15:35:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-25 2:21 p.m., Alexei Starovoitov wrote:
> On Mon, May 24, 2021 at 9:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:


[..]
> In general the garbage collection in any form doesn't scale.
> The conntrack logic doesn't need it. The cillium conntrack is a great
> example of how to implement a conntrack without GC.

For our use case, we need to collect info on all the flows
for various reasons (one of which is accounting of every byte and
packet).
So as a consequence - built-in GC (such as imposed by LRU)
cant interfere without our consent.

cheers,
jamal
