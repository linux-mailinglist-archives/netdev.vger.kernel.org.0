Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539AA685C5F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 01:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjBAAqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 19:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjBAAqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 19:46:52 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBC74F87F;
        Tue, 31 Jan 2023 16:46:51 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id e8-20020a17090a9a8800b0022c387f0f93so389645pjp.3;
        Tue, 31 Jan 2023 16:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UN7olhjD9kAre4Oo48B311JGsl1nRIFV7M9eKOSjTso=;
        b=jO6ocSB+zEj2sIbMLJIDCHh681sd7m5xLLrY16fy8HDr+wv1ZgkkYDk7kH3XAqqQgL
         uT2eghsdb8kSRw0N9Cc1S7vbsEqa/9pWEKTTXmWhGpUjOUm+gayE8BlpHJQfPY0nzhDm
         p15nuhiR6E+CcMKxLTXT9tmNxwCxm2x1M/o75dRyNyf+NTVQ40DNci8uWmBwNBmu61Cs
         B6GL6lp2XDkDxAfhkezDXU/vGJPyE2cavJvud4H3Ev7nBNJpEd5YbuE+WD2/T3VRulse
         vCh6HqM1BPFiSuIsCHyqtuEqlQdkd3gG5QB2wyod6ckKvcfgsea0srCG/GMnhekEdYpN
         ic8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UN7olhjD9kAre4Oo48B311JGsl1nRIFV7M9eKOSjTso=;
        b=3uHdUo3C4Jk9cWTEr9fMlZv62VoDL8ueaph2j4o1KcuowQb591KHXcJSIanJqID5Da
         FQ6Ie67lEpbctPUY+o9zBq9zXpnik5Uj4NGdM9IMquIySViPUwbsluAL1l6sbjGSLZsQ
         bD0uilXF9z2tmDDZy4QnJwDV3sKYWktbBuFx9vmpicEs5/yrz6sBlHmQWd993JeKrjd1
         gDdrwW25R9bZBanc/x4n8GOIvS3v67BKlziWEJTAOERVIlGSs6B/pMmmnRX0tB3lwxxR
         Qie1MbtrUf7Yvu0s6iyhzMMQXvco6zTiNlc0urc7LCPbD2k6T9GW1jYv2SJd30x6Hl/n
         4aaA==
X-Gm-Message-State: AO0yUKVCf3Buw50Bsn56lYXmKs/LxyZLw9uWbWyHrhqEezmKdRaGhr0S
        0qBlIjtUb0XhHP8NouHD5sgc4q1Ghjo=
X-Google-Smtp-Source: AK7set+5Jb1qZ5b8gzsJa2tS5gewQ6UPja3Rh6GQWetSSuEF6woYiSHdzCRw4OHy7LgzVEu4cWRarg==
X-Received: by 2002:a17:902:e801:b0:196:89ba:349 with SMTP id u1-20020a170902e80100b0019689ba0349mr995842plg.64.1675212410709;
        Tue, 31 Jan 2023 16:46:50 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:a530])
        by smtp.gmail.com with ESMTPSA id f11-20020a170902ce8b00b00172cb8b97a8sm10426073plg.5.2023.01.31.16.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:46:50 -0800 (PST)
Date:   Tue, 31 Jan 2023 16:46:47 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, memxor@gmail.com,
        kernel-team@fb.com, bpf@vger.kernel.org
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
Message-ID: <20230201004647.jyesy2dqqx2a7ytb@macbook-pro-6.dhcp.thefacebook.com>
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com>
 <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev>
 <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
 <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
 <CAJnrk1bF+g_2SQ8HaNx0Fb+E42HBi3XJa3M=+y71=XHN1_wdrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1bF+g_2SQ8HaNx0Fb+E42HBi3XJa3M=+y71=XHN1_wdrg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 03:17:08PM -0800, Joanne Koong wrote:
> >
> > It's not clear how to deal with BPF_F_RECOMPUTE_CSUM though.
> > Expose __skb_postpull_rcsum/__skb_postpush_rcsum as kfuncs?
> > But that defeats Andrii's goal to use dynptr as a generic wrapper.
> > skb is quite special.
> 
> If it's the common case that skbs use the same flag across writes in
> their bpf prog, then we can have bpf_dynptr_from_skb take in
> BPF_F_RECOMPUTE_CSUM/BPF_F_INVALIDATE_HASH in its flags arg and then
> always apply this when the skb does a write to packet data.

Remembering these flags at creation of dynptr is an interesting idea,
but it doesn't help with direct write into ptr returned from bpf_dynptr_slice.
The __skb_postpull_rcsum needs to be done before the write and
__skb_postpush_rcsum after the write.

> >
> > Maybe something like:
> > void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len,
> >                        void *buffer, u32 buffer__sz)
> > {
> >   if (skb_cloned()) {
> >     skb_copy_bits(skb, offset, buffer, len);
> >     return buffer;
> >   }
> >   return skb_header_pointer(...);
> > }
> >
> > When prog is just parsing the packet it doesn't need to finalize with bpf_dynptr_write.
> > The prog can always write into the pointer followed by if (p == buf) bpf_dynptr_write.
> > No need for rdonly flag, but extra copy is there in case of cloned which
> > could have been avoided with extra rd_only flag.
> 
> We're able to track in the verifier whether the slice gets written to
> or not, so if it does get written to in the skb case, can't we just
> add in a call to bpf_try_make_writable() as a post-processing fixup
> that gets called before bpf_dynptr_slice? Then bpf_dynptr_slice() can
> just return a directly writable ptr and avoid the extra memcpy

It's doable, but bpf_try_make_writable can fail and it's much slower than memcpy.
I'm not sure what you're optimizing here.
