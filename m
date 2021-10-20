Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A24E435634
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhJTW5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhJTW5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:57:47 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E601C06161C;
        Wed, 20 Oct 2021 15:55:32 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id l24-20020a9d1c98000000b00552a5c6b23cso10109066ota.9;
        Wed, 20 Oct 2021 15:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cPiacAHVzcrhdUz4ZTtN/fpqDLeX0mVZT75Tk2+KOqw=;
        b=L8asQJGAEwxHpeR4LQzteEVcYbiffD6v+eiSn0f+mFF+oaQty5UWPv9e0WUaLOznRD
         g8IUWWgrJy12oMlvets+kJj1BXVInfpNJHOJIXmgQEjDvTRvcMy4XBlUfX/R7FVw6Cl1
         C4fX7J7mWHMipTS47kt522zjhDC7dlFyMjM0x+tG9UchiImgcvlpcatBAVP8oT5/cK/F
         O7POA++sR2wSX21NsiDYktuLmgZ82DIVwjaz/TX/BNaHTdjWaA/0Hmgl6s0sb3PIuzvn
         n8V/UMKXfLB9sC51/L7ZXZ1Y8OJS4mrAEe6ZCt/Au+klp+sc/ArwoLWNnELGvFHS1sKD
         MDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cPiacAHVzcrhdUz4ZTtN/fpqDLeX0mVZT75Tk2+KOqw=;
        b=kTQKWTXUtWpfg40QxBDSWZm+dQyH76Ux/vaW3TTwUS1mmh2IbxtdLCWygE8VQULvR9
         TJ03CFI7+b2yK6jZ5Y1nu0eJBj5cQG0STBiBg7j58DQuMmqlzj++naIkYUhFh9G/XKqu
         9WZmDCUVXEU1nus59qnSfG1nw0KfS6lQsNvCiB/lYqqSZOiCrUNATIq7+2golEWhW3ku
         MKMm0++fZq5b/lGPdRbbZ8s65vv30OF1NOcNQq4Q8+v9aw74OlvDuNzBXB4I9m0VZ/4n
         xVXxU64uhI39HOg7rWcag0157sTPdnICFfZScX7mMfCJ7s4I0RIhE/snjEG+dTU8PXoD
         uMmw==
X-Gm-Message-State: AOAM532UTsC5VZ188HXBk20HpmhJzgLQz8Jpt2tzURlCOZzCW1tW7XGN
        uUnggXyWLMO0z+IG9scYocc=
X-Google-Smtp-Source: ABdhPJy9i16Y51nszpIvaloQtDYHYhAYpRTzu/gSXP6PUAwfskLa0IzCFihTwQ8uQEm0RIIgsuE4Dw==
X-Received: by 2002:a05:6830:31a8:: with SMTP id q8mr1708511ots.156.1634770531707;
        Wed, 20 Oct 2021 15:55:31 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id y4sm707047oix.23.2021.10.20.15.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 15:55:31 -0700 (PDT)
Message-ID: <cc00fa9d-3f18-f850-4cdc-eb81145bdc47@gmail.com>
Date:   Wed, 20 Oct 2021 16:55:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next 07/10] bpf: Add helpers to query conntrack info
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Florian Westphal <fw@strlen.de>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-8-maximmi@nvidia.com>
 <20211020035622.lgrxnrwfeak2e75a@apollo.localdomain>
 <20211020092844.GI28644@breakpoint.cc> <87h7dcf2n4.fsf@toke.dk>
 <20211020095815.GJ28644@breakpoint.cc> <875ytrga3p.fsf@toke.dk>
 <20211020124457.GA7604@breakpoint.cc> <87r1cfe7sx.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <87r1cfe7sx.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/21 2:54 PM, Toke Høiland-Jørgensen wrote:
>> Sure, but I'm not sure I understand the use case.
>>
>> Insertion at XDP layer turns off netfilters NAT capability, so its
>> incompatible with the classic forwarding path.
>>
>> If thats fine, why do you need to insert into the conntrack table to
>> begin with?  The entire infrastructure its designed for is disabled...
> One of the major selling points of XDP is that you can reuse the
> existing kernel infrastructure instead of having to roll your own. So
> sure, one could implement their own conntrack using BPF maps (as indeed,
> e.g., Cilium has done), but why do that when you can take advantage of
> the existing one in the kernel? Same reason we have the bpf_fib_lookup()
> helper...
> 

Exactly, and a key point is that it allows consistency between XDP fast
path and full stack slow path. e.g., the BPF program is removed or
defers a flow to full stack for some reason.
