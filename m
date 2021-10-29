Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8B043FFD0
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhJ2PvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJ2PvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 11:51:08 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2B2C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 08:48:40 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t7so10262021pgl.9
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 08:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q8KwAsr2RDCx9jxh1KM0kTJT3ndZzJV1qdtrxrpQgLk=;
        b=Sv4ethXWKgp6BCDtFuS3cEEt7niOw2CI8PdBOO+ZmVfnT/EVdiJfDhFJbic053bUSD
         UUXxcn5SVEzIfwHaS9iVX0fhCwq19bB6SwNbLAh8dR4F/hrejc/zabnQzgkmf10UhLf9
         qt9LGvawygwjHiZUVu4uS+YECdV0oqSIRVb3Vu3ZSiIy6FlRUDy5XFLY+ISwPweJMAaJ
         X4RBqZWYOyX4uk/nCdQY6n4fquQP7Y/5OrH/drBrL1UFoPdApmib/GKgunEy8BRursCv
         dsVr3yuClcAcdXCZu6TCH7+nRUcs9C7aynLejHCDwfDWQIAXvIDi9/hvA1r3fPFmyi8e
         wlmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q8KwAsr2RDCx9jxh1KM0kTJT3ndZzJV1qdtrxrpQgLk=;
        b=SBgZEgwwbNyjOYRAKnHFAN1hS9EHdLfQPsDpi/A7Dd+CTlw41iaOGv+xT+Uy5xR9S1
         JBroq38si9VZAMTA/angLHRzEvEH3XAhk5w2UK9aZ0cVag4JJgrvma6yCuFeL1CL0DxN
         fYkxd3NdghlTECy4VzxXcHcj9OlYpn1RQ/993D6aVMbquzSzP0+jEyO28TuCggE4CrT8
         0SliYIjWVTo6m8GBXcgRvrlT0AECOaB9lgjq+3OGy0clE939PdXnCSQuNatpSeUjbX7a
         a5JMeICzP6vYveaUXIQqw/nxK/a9zHn/sO7Ox/0/yIxEzOQnHIdiR57UIs4AuQkmMtj5
         GwmQ==
X-Gm-Message-State: AOAM530qOM1aLz2FoUwmp1js3+ywnEAicUsNjDqtwU97DR/+naTuaqDk
        3wDgsfAhPWn8kJbmlvsPwru2elekh6o=
X-Google-Smtp-Source: ABdhPJzRNoOQXpCMwiS4sS0K+N/kW32RUjxkc8XA74+rxuuMZl56rWCADiNNLxHgrCjPyZZpOVgX9Q==
X-Received: by 2002:a62:178d:0:b0:47b:d2bc:e3b3 with SMTP id 135-20020a62178d000000b0047bd2bce3b3mr11447829pfx.18.1635522519230;
        Fri, 29 Oct 2021 08:48:39 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l14sm11112618pjq.13.2021.10.29.08.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 08:48:38 -0700 (PDT)
Subject: Re: [RFC] should we allow BPF to transmit empty skbs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <d732c167-4fbd-b60a-1e1b-8e0147fd9a78@gmail.com>
 <f91a8348-87ab-86dc-9a10-d934bce0aa87@iogearbox.net>
 <CAADnVQLqrokhdY_DQWOhBafaYe-tSpQ60seTxv8r5MQpH6RtHw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ead53f21-0649-1c5b-c157-6e1ec49d9458@gmail.com>
Date:   Fri, 29 Oct 2021 08:48:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQLqrokhdY_DQWOhBafaYe-tSpQ60seTxv8r5MQpH6RtHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/21 8:41 AM, Alexei Starovoitov wrote:
> On Fri, Oct 29, 2021 at 8:39 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> On 10/29/21 5:22 PM, Eric Dumazet wrote:
>>> Some layers in tx path do not expect skb being empty (skb->len == 0)
>>>
>>> syzbot reported a crash [1] in fq_codel.
>>>
>>> But I expect many drivers would also crash later.
>>>
>>> Sure the immediate fq_codel crash could be 'fixed', but I would rather
>>> add some sanity checks in net/core/filter.c
>>
>> Makes sense, we shouldn't have to add this to fq_codel fast path, but rather
>> a sanity check for bpf_clone_redirect().
>>
>> I wonder if it's only related to bpf_prog_test_run() infra or if it could also
>> have been generated via stack?
> 
> probably bpf_prog_test_run_skb only.
> I would only add size !=0 check there.
> 

We have a C repro, I will release the syzbot bug so that it can be shared with you.

Thanks.
