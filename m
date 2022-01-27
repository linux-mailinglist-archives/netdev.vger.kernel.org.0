Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC1B49E3E7
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbiA0Nx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiA0Nx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 08:53:26 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D164DC061714;
        Thu, 27 Jan 2022 05:53:25 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id j2so6020794ejk.6;
        Thu, 27 Jan 2022 05:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4pBdb6D0daP2qnvL0qQ826/MiGsIBaizvdm2ms6Tt/I=;
        b=q6re+DCs3ZPrM5z8ejNF3OvYq89TT8hUqFMciLwyGTeq9p8DEdTBIAn1XRdNBbGRlF
         tbxnRr8dLKIdmCpJ7TY7Q+fBRFom1KhkofUt1dGOoFdxs9raCKodl395SUeXVtckovwJ
         hbPSGEjynYdW/EhWo10mwkONNuXPCeMt5ARxiYCKbtMfYBDSS/tUJuQeX6CaN5xYVPFl
         sNbQtuX6jwPdCqkJIf3KLHYoZWOVgyc/65+duznUquDe3ZyEX5ioZhi2YTfFGgaTBwZW
         z564FALU4WfV7aYaSOyXqbCULnO3b4BX9a+f4JATqsqZiRhtxvCJ6rDM0bmSMtgnhIxK
         6aVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4pBdb6D0daP2qnvL0qQ826/MiGsIBaizvdm2ms6Tt/I=;
        b=EoiV91s1YhMkTOp+C/opyMhgdM3tHxxYZmgTeIy+BkK36N6jLDY5z8kXz1csf0lTix
         duD1Dxi8T6PvweSbSawLhZW0sWyy/V7exra9FlsXhffUtTcw/VOSNvxipGl6IPQalOUd
         eHk0qMKOtZODIceSgbt5om28Ufxh5J/jZsHA1v8iIMR9UTQbvI87iipQerpCxjdWBurs
         napLtF4iUhZNrJMK5fhp26lKON8jfH9o8K8/Ali9yJTRJvpAtnNG0wQOxQzOwo/hWqpn
         EXqag+dyytstJJuNs0wImxZdSp/72ilA2LtT/+84LTsRoY5ExTm9PdsvdY61WOvErTGo
         BRqA==
X-Gm-Message-State: AOAM531bDnQo2plCcwwq54t77H3vmFrZTmd6Rf1NewqhFubXfRHId6gs
        IOPo3HYrR6u97CBKNuGdV34=
X-Google-Smtp-Source: ABdhPJxdH0FAutV6NuZIOOZwdCQ4yJsiw3KoLuHdyvZG/BqZadKeJ3ogTVXiDYbvXxoMdP5C84TfKQ==
X-Received: by 2002:a17:907:1c0f:: with SMTP id nc15mr2956133ejc.673.1643291604282;
        Thu, 27 Jan 2022 05:53:24 -0800 (PST)
Received: from [192.168.8.198] ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id z6sm8803250ejd.96.2022.01.27.05.53.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 05:53:23 -0800 (PST)
Message-ID: <12d6b267-7c1b-1f2b-2ab1-8d24433f16ea@gmail.com>
Date:   Thu, 27 Jan 2022 13:53:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH for-next v4] cgroup/bpf: fast path skb BPF filtering
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
References: <94e36de3cc2b579e45f95c189a6f5378bf1480ac.1643156174.git.asml.silence@gmail.com>
 <20220126203055.3xre2m276g2q2tkx@kafai-mbp.dhcp.thefacebook.com>
 <fbc8acbe-4c12-9c68-0418-51e97457d30b@gmail.com>
 <CAADnVQ+p0B-2_b8hYHEW4UGJ7-T0RMfnZ8cZ4NgpvjMiTo6YKA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQ+p0B-2_b8hYHEW4UGJ7-T0RMfnZ8cZ4NgpvjMiTo6YKA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 05:08, Alexei Starovoitov wrote:
> On Wed, Jan 26, 2022 at 1:29 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 1/26/22 20:30, Martin KaFai Lau wrote:
>>> On Wed, Jan 26, 2022 at 12:22:13AM +0000, Pavel Begunkov wrote:
>>>>    #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)                        \
>>>>    ({                                                                       \
>>>>       int __ret = 0;                                                        \
>>>> -    if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))                  \
>>>> +    if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&                  \
>>>   From reading sk_filter_trim_cap() where this will be called, sk cannot be NULL.
>>> If yes, the new sk test is not needed.
>>
>> Well, there is no sane way to verify how it's used considering
>>
>> EXPORT_SYMBOL(__cgroup_bpf_run_filter_skb);
> 
> BPF_CGROUP_RUN_PROG_INET_INGRESS() is used in one place.
> Are you folks saying that you want to remove !sk check
> from __cgroup_bpf_run_filter_skb()?
> Seems like micro optimization, but sure why not.
> 
> EXPORT_SYMBOL() is there because of "ipv6 as a module" mess.
> So it's not a concern.

Ok. I'd usually assume symbols for internal use only to be GPL.


> Pls tag the subj of the patch with [PATCH bpf-next]
> instead of "for-next".

-- 
Pavel Begunkov
