Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08A85A30A0
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 22:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiHZUsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 16:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiHZUsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 16:48:12 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBF2CEB1E;
        Fri, 26 Aug 2022 13:48:11 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id sd33so5257065ejc.8;
        Fri, 26 Aug 2022 13:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=4qYVa5gkmIfp9UdswOaDQEBHPPp6j3YcVSB+u/dlh1g=;
        b=g5/VSsck6th7O2vR+jHRYc9yaHwJprFd7ILlPerpBOxHAX/ricKISbRbfUjOyWNZi4
         9FPMzjR1DTz97pLia7DOkpLSvg8KTWnb6mwFRAWsq0V3xlU4+X4Ha2w24jZml8lNOSTd
         GxzJChz6Tgt81DiIk5uHiMDxks01Bx00DXT5w5BZa7DF3Vj+jXqUs7lUcHr5cTv8k4na
         SpQ0xVnM7q+wirtPyGGv16+R9KViqPrUhpeSYfqBkWc+iduuUFS7n36Ev/AsDFePl5HF
         Ixk4Ju1q4/cUU2M03X08Kl8f4OqOWDF/ais3f4bsxh2vkffGYmVQA7PN8XLnanw6FGvo
         +rJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=4qYVa5gkmIfp9UdswOaDQEBHPPp6j3YcVSB+u/dlh1g=;
        b=PvmwjnwQ2LOKKBBgZKM5Sx7AKe4Xt8L8qYMmql/taN2NNsy6sDViEwvRn90BF9Qd36
         TWhhEGImojB/6hHJTzxjqRRjEGPdfVgtEIsKF9JpUcm8lFYsnCT+1R/3/EFft864hZyh
         BAup1V2yZ+rXppW1uDE34fm9f0gcpA1+swZVENbRMIaCPdAvoNlA8Y8J38+aDogqUDtb
         BqdqqZPOlCAMMSFAwTbf4pHVMeGDz8mq+m1P6UeDeGRg/q3t+9sfEQkzavqPSAq3o+XS
         43dxISHXpYxRfyg/VLlKELmToqDypk/VHI0TISJ/hu1H7CVbQjOgxMGX8dm0vJjbAD7m
         B7dA==
X-Gm-Message-State: ACgBeo3wRCyg18BQVBlZvrfV0W/tTbiMdTLMg+CUn6itUlJ3RwlKgPWf
        0fLYo4gtvKGww5zPOFTzL10//nRjSD4ZkviWPbA=
X-Google-Smtp-Source: AA6agR66Bso917h19XZvRgHShtjNzX0ajsmcZ1V5q0VIywERvJoCZRTryJBKEadFN4lgO3cf/S+R98xJJLRhvs9P2I4=
X-Received: by 2002:a17:907:2716:b0:73d:cdf9:b08a with SMTP id
 w22-20020a170907271600b0073dcdf9b08amr6113062ejk.463.1661546890310; Fri, 26
 Aug 2022 13:48:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com> <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
 <878rnehqnd.fsf@toke.dk> <CAJnrk1YYpcW2Z9XQ9sfq2U7Y6OYMc3CZk1Xgc2p1e7DVCq3kmw@mail.gmail.com>
 <CAP01T75isW8EtuL2AZBwYNzk-OPsMR=QS3YB_oiR8cOLhJzmUg@mail.gmail.com>
 <20220826063706.pufgtu4rff4urbzf@kafai-mbp.dhcp.thefacebook.com> <CAP01T74oMaGGtJNQ_hHWKzBwwGgwOmH=1Z-c3mauqC9U95UPvA@mail.gmail.com>
In-Reply-To: <CAP01T74oMaGGtJNQ_hHWKzBwwGgwOmH=1Z-c3mauqC9U95UPvA@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 26 Aug 2022 13:47:59 -0700
Message-ID: <CAJnrk1bpHQie+T5vuaQ8-3isLCMp77btLiZrbOwRcR-7dvoU9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        "brouer@redhat.com" <brouer@redhat.com>, lorenzo@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 12:09 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, 26 Aug 2022 at 08:37, Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Aug 25, 2022 at 01:04:16AM +0200, Kumar Kartikeya Dwivedi wrote:
> > > On Wed, 24 Aug 2022 at 20:11, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > > I'm more and more liking the idea of limiting xdp to match the
> > > > constraints of skb given that both you, Kumar, and Jakub have
> > > > mentioned that portability between xdp and skb would be useful for
> > > > users :)
> > > >
> > > > What are your thoughts on this API:
> > > >
> > > > 1) bpf_dynptr_data()
> > > >
> > > > Before:
> > > >   for skb-type progs:
> > > >       - data slices in fragments is not supported
> > > >
> > > >   for xdp-type progs:
> > > >       - data slices in fragments is supported as long as it is in a
> > > > contiguous frag (eg not across frags)
> > > >
> > > > Now:
> > > >   for skb + xdp type progs:
> > > >       - data slices in fragments is not supported
> > I don't think it is necessary (or help) to restrict xdp slice from getting
> > a fragment.  In any case, the xdp prog has to deal with the case
> > that bpf_dynptr_data(xdp_dynptr, offset, len) is across two fragments.
> > Although unlikely, it still need to handle it (dynptr_data returns NULL)
> > properly by using bpf_dynptr_read().  The same that the skb case
> > also needs to handle dynptr_data returning NULL.
> >
> > Something like Kumar's sample in [0] should work for both
> > xdp and skb dynptr but replace the helpers with
> > bpf_dynptr_{data,read,write}().
> >
> > [0]: https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@gmail.com/T/#mf082a11403bc76fa56fde4de79a25c660680285c
> >
> > > >
> > > >
> > > > 2)  bpf_dynptr_write()
> > > >
> > > > Before:
> > > >   for skb-type progs:
> > > >      - all data slices are invalidated after a write
> > > >
> > > >   for xdp-type progs:
> > > >      - nothing
> > > >
> > > > Now:
> > > >   for skb + xdp type progs:
> > > >      - all data slices are invalidated after a write
> > I wonder if the 'Before' behavior can be kept as is.
> >
> > The bpf prog that runs in both xdp and bpf should be
> > the one always expecting the data-slice will be invalidated and
> > it has to call the bpf_dynptr_data() again after writing.
> > Yes, it is unnecessary for xdp but the bpf prog needs to the
> > same anyway if the verifier was the one enforcing it for
> > both skb and xdp dynptr type.
> >
> > If the bpf prog is written for xdp alone, then it has
> > no need to re-get the bpf_dynptr_data() after writing.
> >
>
> Yeah, compared to the alternative, I guess it's better how it is right
> now. It doesn't seem possible to meaningfully hide the differences
> without penalizing either case. It also wouldn't be good to make it
> less useful for XDP, since the whole point of this and the previous
> effort was exposing bpf_xdp_pointer to the user.

I'll keep it as is for v5.
