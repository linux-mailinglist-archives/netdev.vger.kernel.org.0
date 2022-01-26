Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF4849C17E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbiAZC5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbiAZC5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 21:57:39 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A60DC06161C;
        Tue, 25 Jan 2022 18:57:39 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id s18so9591220ioa.12;
        Tue, 25 Jan 2022 18:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8Z9fTAosYWmdHhoiFaWzEwrQtgGbnjw3zgWYEIipPpM=;
        b=g+KG/tzcCiREoxfWhlNdap7yWt7kyEvlOWbxRYwBRD/mdWlKmoz0aFUGPDYoZlf+8T
         pWbvgLu5RabIfUcExNX5MlSpDwTtVX6rTg9+TChoEhrYqTPk67vWVPasTdzQoudJGZxc
         01paz+U7c4TV2NaI5NNE8XDgXGHYqiO5SHHafYAvEs9RjHJkT49f0nKmePBaToHsnpUx
         SlSXt+4hc1FXcAmYh75uZL0Bu7jBM2SwD8Vl7ms09oKB3bLmrd1uBiBnTZdmZqqHlxj8
         Z1tUQn+mRDiTNLWM78JI/dRZ0GRmvaxolxVl8/NbPvgDossiAgd5uR/EFbky+bHy+J9s
         ivkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8Z9fTAosYWmdHhoiFaWzEwrQtgGbnjw3zgWYEIipPpM=;
        b=6pKnNQnm6elhdYMn+CAhZtgzbgJ+eJ9Uwmj6F+z6Ia52XdFaRLtUwAMgmEwR9gpVBT
         6OxiiKskzo8tHdO+daw/CmleILLlkP0tThktmv35L5CExn4epVwvsJJM4VGY1SBo3nLd
         UWVObSqRCkanQdv0ssf0rgOIde1sctyaX2BhCFDn05m/8Ds8rD7OGvYfB/Y/xiG3oVHe
         um6vZhRvPI8HplhoLBPW7rcyXoqDwIHu07tvZKfQJB58CxnO70UgXJQxqvnLb4f4Q2fy
         c8B97KHhQSGL57/IDwfRn3nIAc/mMzKTzYOFaMOSbOcmluikTAfuSWHBcUvANB4z6WBt
         f5lw==
X-Gm-Message-State: AOAM531E17ISzJaharnM5Z4iMAjLor8o5s/UnYi9h9DAWKGKSXXcO9JV
        2/nUXh9QzTpIZWa8tkNRHrI=
X-Google-Smtp-Source: ABdhPJwmiriTEgZcrc9mAcrn/yOdBKltldtNNKijBVqgtIlwb9HWeIHNnCMYT2DsK2Am0SUX4g00zw==
X-Received: by 2002:a05:6638:388a:: with SMTP id b10mr4247334jav.55.1643165858141;
        Tue, 25 Jan 2022 18:57:38 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id c3sm9982223iow.28.2022.01.25.18.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 18:57:37 -0800 (PST)
Message-ID: <926e3d3d-1af0-7155-e0ac-aee7d804a645@gmail.com>
Date:   Tue, 25 Jan 2022 19:57:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 3/6] net: ipv4: use kfree_skb_reason() in
 ip_rcv_finish_core()
Content-Language: en-US
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Paolo Abeni <pabeni@redhat.com>,
        talalahmad@google.com, haokexin@gmail.com,
        Kees Cook <keescook@chromium.org>, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-4-imagedong@tencent.com>
 <5201dd8b-e84c-89a0-568f-47a2211b88cb@gmail.com>
 <CADxym3YpyWh59cjtUqxGXxpb2+2Ywb-n4Jpz1KJG3AYRf5cenA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CADxym3YpyWh59cjtUqxGXxpb2+2Ywb-n4Jpz1KJG3AYRf5cenA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/22 7:36 PM, Menglong Dong wrote:
> Is't it meaningful? I name it from the meaning of 'ip route lookup or validate
> failed in input path', can't it express this information?


ip_route_input_noref has many failures and not all of them are FIB
lookups. ip_route_input_slow has a bunch of EINVAL cases for example.

Returning a 'reason' as the code function name has no meaning to a user
and could actually be misleading in some cases. I would skip this one
for now.
