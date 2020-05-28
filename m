Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03121E6F47
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437238AbgE1WkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437076AbgE1WkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:40:09 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83099C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:40:09 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 205so561346qkg.3
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S9CqFafwc5lg2XwZBV7yES+6VQEqLG/Xrf08+GVg1OA=;
        b=CzlNsmBPYSzlsn2NAfKWi786aiUFumCY0JgRPVNtOCoDTNysd6XfiSz5iYJ4BoKrLA
         g4ffpUL2j/zyTcgdZpeK3OfiZlulaZY+cw+ooBInMpFEmeTBoCDd8IhCE8mowpPDhQFL
         g23zcktn3sww8V+Y2FbGEAye2JF2Wk/wbi7P9bEUgWe1rHHAcHXcYvYOOQWmBSo8z06R
         AAcXjRFJTqHSIV/mh4FBPfQl8nfS/wVZQULZA52MwwGn0wSdHsrF1PM1/BYI0FteXAVE
         MET+z8/B9WzOD1GswaXvsmr/7HMsBd08y0fZTawqUeX7lgDadSXfnGxioWckwp/2KmBn
         DQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S9CqFafwc5lg2XwZBV7yES+6VQEqLG/Xrf08+GVg1OA=;
        b=sNG1ybaJZfSb/fKPEIKgJK6JD75wKOwG0ye1fGw1SBEqaq/RYZkqJsmdcj+ADgYxoO
         um+BtB9W+Weossdr0FLJRRBcpU5qIGipHwAHlOamJTPHyWPHfm+uWirJ0ZhnKnJGvCYr
         6/5lOyGCjK7OMVt4M/O7x478lbeVYhjg/3F03mICDcdoEZ2HpvwzDCxNUosgxULeKr8I
         +Md73OZZRdNj8z0Z896n9rp3bcL1ZZtK3u2p2m1poY57nw7Qu0spnzPyFAIUV27q39sK
         /Z/wiWEDKCXQkkwvX86k7zc5jmbBPFjEZQ8IlqnMrAcfna2sl4+wd6te8AJ6PoCKsezm
         CNWQ==
X-Gm-Message-State: AOAM532nNMdheOzMZjnI/dU0kfvHdW5LreXoM8pUAUxDUh5SAfhorttZ
        teOpnanqq515dsiX69Zz+aQ=
X-Google-Smtp-Source: ABdhPJxLfeHWbvi99276LzN590PkWpmyXYhjRTH1Wswe3UxESfYI84G8ccWT58STWaRvLFqD4mGR8Q==
X-Received: by 2002:a37:4c48:: with SMTP id z69mr5283798qka.138.1590705608197;
        Thu, 28 May 2020 15:40:08 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2840:9137:669d:d1e7? ([2601:282:803:7700:2840:9137:669d:d1e7])
        by smtp.googlemail.com with ESMTPSA id d56sm6709267qtb.54.2020.05.28.15.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 15:40:07 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 2/5] bpf: Add support to attach bpf program to
 a devmap entry
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200528001423.58575-1-dsahern@kernel.org>
 <20200528001423.58575-3-dsahern@kernel.org>
 <CAEf4BzYZSPdGH+RXp+kHfWnGGLRuiP=ho9oMsSf7RsYWyeNk0g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <191ba79f-3aeb-718c-644e-bd2cc539dc60@gmail.com>
Date:   Thu, 28 May 2020 16:40:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYZSPdGH+RXp+kHfWnGGLRuiP=ho9oMsSf7RsYWyeNk0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/20 1:01 AM, Andrii Nakryiko wrote:
> 
> Please cc bpf@vger.kernel.org in the future for patches related to BPF
> in general.

added to my script

> 
>>  include/linux/bpf.h            |  5 +++
>>  include/uapi/linux/bpf.h       |  5 +++
>>  kernel/bpf/devmap.c            | 79 +++++++++++++++++++++++++++++++++-
>>  net/core/dev.c                 | 18 ++++++++
>>  tools/include/uapi/linux/bpf.h |  5 +++
>>  5 files changed, 110 insertions(+), 2 deletions(-)
>>
> 
> [...]
> 
>>
>> +static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
>> +                                        struct xdp_buff *xdp,
>> +                                        struct bpf_prog *xdp_prog)
>> +{
>> +       u32 act;
>> +
>> +       act = bpf_prog_run_xdp(xdp_prog, xdp);
>> +       switch (act) {
>> +       case XDP_DROP:
>> +               fallthrough;
> 
> nit: I don't think fallthrough is necessary for cases like:
> 
> case XDP_DROP:
> case XDP_PASS:
>     /* do something */
> 
>> +       case XDP_PASS:
>> +               break;
>> +       default:
>> +               bpf_warn_invalid_xdp_action(act);
>> +               fallthrough;
>> +       case XDP_ABORTED:
>> +               trace_xdp_exception(dev, xdp_prog, act);
>> +               act = XDP_DROP;
>> +               break;
>> +       }
>> +
>> +       if (act == XDP_DROP) {
>> +               xdp_return_buff(xdp);
>> +               xdp = NULL;
> 
> hm.. if you move XDP_DROP case to after XDP_ABORTED and do fallthrough
> from XDP_ABORTED, you won't even need to override act and it will just
> handle all the cases, no?
> 
> switch (act) {
> case XDP_PASS:
>     return xdp;
> default:
>     bpf_warn_invalid_xdp_action(act);
>     fallthrough;
> case XDP_ABORTED:
>     trace_xdp_exception(dev, xdp_prog, act);
>     fallthrough;
> case XDP_DROP:
>     xdp_return_buff(xdp);
>     return NULL;
> }
> 
> Wouldn't this be simpler?
> 

Switched it to this which captures your intent with a more traditional
return location.

        act = bpf_prog_run_xdp(xdp_prog, xdp);
        switch (act) {
        case XDP_PASS:
                return xdp;
        case XDP_DROP:
                break;
        default:
                bpf_warn_invalid_xdp_action(act);
                fallthrough;
        case XDP_ABORTED:
                trace_xdp_exception(dev, xdp_prog, act);
                break;
        }

        xdp_return_buff(xdp);
        return NULL;
