Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EA366B10C
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 13:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjAOMlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 07:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjAOMl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 07:41:29 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E885783F0;
        Sun, 15 Jan 2023 04:41:28 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z11so37347515ede.1;
        Sun, 15 Jan 2023 04:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WofYiXhfhwxMxjjB+Ky8AqYxoy/L18oHKYylI+bwx9Y=;
        b=MWaaWt6ObFyIrYqqAO8mj8QZQ6/jxdtDk1S0u4HnxOEYkkoDV7NKli8DT/k0SprvN5
         cdRLgpRDoMiia4K7eCt6dhEs5AgMi3vI/Hq3Cq2K4e/LHQnKCSZrEIP9lRSWcrxPPc6W
         yC3+Cy+B4nst8LfwxAm1JAVDTAf5hoD3c9vx0VSc7eLja3PIOVsa7kAhHaVDNmmZNSHn
         e4Zr78cD/pb0TLZe2hhK1UJxbLtX6iMcQ/D2YRVdfTW2UUwubJY7uXK4Xur4cVlKXIya
         MZlYxAknvTfyBMlUEJ1OZeHCnyeS2jY63JnDKtT3X6j1/HUk+IwsSLbdNSvActM5UNr2
         XiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WofYiXhfhwxMxjjB+Ky8AqYxoy/L18oHKYylI+bwx9Y=;
        b=BEGG0o3ordKgVCABY9JJ9zkiocA5eybU65x1fBWPn+J3QyAbb/+5oMnwz1Ig5t7vri
         BZMe9Zvr4OLPdGj+cu8Xg0oGtHPsYWRzxZrtryB0JoGgpNRT9COa3YcEuLR9kk+uzXXA
         FxNgvAM86sKX/RiDkz6EkgsZn2/eBND/L4Sc4GH3WdJbF2nsCXkZNwUTFpJx49i8Opje
         HBK87QCyw4SNk47vgixAdw73Ozxnu30YtcLER/cdGS9KeYu4/wYcNcbVtMIIflvSG+tP
         Kh2JEQPKmdnXRWFHL3LitxT5KEc1z7rUR1SagQsfXaBWb+6uqvIkLYQBcQmzmd29gQHZ
         6Iug==
X-Gm-Message-State: AFqh2ko1fS8yRNCl7O8fl/KS5a+x4NNYZnrJo087DTMRzR3MU+cfQttv
        k4vQvx8KYIYzU8tqnHJSw6Q=
X-Google-Smtp-Source: AMrXdXve09EXRZrwP+wYPD8JZcQGoahGDlZ3Fd1lDA+2zPOXJSnI4+9z48HJGaz7zmRx11k6zmJHJw==
X-Received: by 2002:a05:6402:5407:b0:47e:d7ea:d980 with SMTP id ev7-20020a056402540700b0047ed7ead980mr71931440edb.14.1673786487377;
        Sun, 15 Jan 2023 04:41:27 -0800 (PST)
Received: from [192.168.0.103] ([77.126.105.148])
        by smtp.gmail.com with ESMTPSA id n3-20020a05640204c300b0046ab2bd784csm10228937edw.64.2023.01.15.04.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 04:41:26 -0800 (PST)
Message-ID: <0c7fff1b-8d32-3a9f-40d1-03dcbb2315c1@gmail.com>
Date:   Sun, 15 Jan 2023 14:41:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH bpf-next v7 0/3] Add skb + xdp dynptrs
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
References: <20221021011510.1890852-1-joannelkoong@gmail.com>
 <CAADnVQKhv2YBrUAQJq6UyqoZJ-FGNQbKenGoPySPNK+GaOjBOg@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <CAADnVQKhv2YBrUAQJq6UyqoZJ-FGNQbKenGoPySPNK+GaOjBOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm reviving this thread, following the discussion here:
https://lore.kernel.org/bpf/87fscjakba.fsf@toke.dk/

On 21/10/2022 4:19, Alexei Starovoitov wrote:
> On Thu, Oct 20, 2022 at 6:15 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>>
>> This patchset is the 2nd in the dynptr series. The 1st can be found here [0].
>>
>> This patchset adds skb and xdp type dynptrs, which have two main benefits for
>> packet parsing:
>>      * allowing operations on sizes that are not statically known at
>>        compile-time (eg variable-sized accesses).
>>      * more ergonomic and less brittle iteration through data (eg does not need
>>        manual if checking for being within bounds of data_end)
>>
>> When comparing the differences in runtime for packet parsing without dynptrs
>> vs. with dynptrs for the more simple cases, there is no noticeable difference.
>> For the more complex cases where lengths are non-statically known at compile
>> time, there can be a significant speed-up when using dynptrs (eg a 2x speed up
>> for cls redirection). Patch 3 contains more details as well as examples of how
>> to use skb and xdp dynptrs.
> 
> Before proceeding with this patchset I think we gotta resolve the
> issues with dynptr-s that Kumar found.

Just to make sure I'm following: The issues that are discussed here?
https://lore.kernel.org/all/CAP01T74icBDXOM=ckxYVPK90QLcU4n4VRBjON_+v74dQwJfZvw@mail.gmail.com/

What is the current status of dynptrs?
Any updates since October?
Do we have any agreement or a plan for this?

Regards,
Tariq
