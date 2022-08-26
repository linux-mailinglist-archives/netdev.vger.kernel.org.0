Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6925A2FB0
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 21:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245631AbiHZTKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 15:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345084AbiHZTJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 15:09:59 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C301D8B;
        Fri, 26 Aug 2022 12:09:52 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id h78so1878051iof.13;
        Fri, 26 Aug 2022 12:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=cNe7/LdZ1k5s4+t2GvksH0Kd21I+AeA6M+dWLUMiXp8=;
        b=ghTR7Vl8VXcQgwHOlzh20AYV/+pdOjtMSVCzW1b1kWcrLYkyJPlXA7FBFZWiwYAuLs
         ZLcBvuJA/gkN77bOABeNLZhOIQCioTfJNYd+shx3FUqXTyQM43tixfLdZgKGzBkjo+mX
         Oaov1HZ07YmV/QwdiGg78r3FdqF/ib9khGHo6iEljXwM5agHIijJQd7ZfGf/jfA4cHdq
         hulUAXa+G1MKmJ5VbNhilo7yFSA3fqu5vqj/gKMHuowP7woE/FHydodU5avD3b2DBLF9
         Hrho3yDi3RDKpJ3s5OOsip2pG86JLWBC99SYzWs9FagG39hICbwqTmSG96LL07wDYWqH
         xccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=cNe7/LdZ1k5s4+t2GvksH0Kd21I+AeA6M+dWLUMiXp8=;
        b=3G4seYxByBLi6YM6qGsixFXo4/RyMvhhHlrdxP4w2x1UqIXjC0bT+nmHbWpuU9jv+b
         DKi3RIpLC4c/tjHRb3pVI98t3sqIBMuJoHg8ZVALy/PxErNP96DEHaS4+G9ADhqUyYL7
         CjL1JmrpAXkdDAM//uV9EpdjhByrW35wf5f+zlNNkfQasTj4sSupgtH6ZwYUQFMy9XGo
         4ilsfAz8BXAjQJhlcGiq3A/kmY6fTAMVsbJyRFRYLdgRwAp3E9BxGSVhUh2Sb05V/+Oe
         aLe2uc7DmcO7e2bdUoVeHTmnO1mqqkGO1zFeaWEVuTJWTOQIKTihQszbRemDXkv3adWR
         dYQg==
X-Gm-Message-State: ACgBeo19Bficxoq0FWG/Jt9Cm6EFp30ALx+j1Lbi35S4w7m5ZKhg9UWJ
        0mkXGX9BKvmTtanrwb97s3W/eOMZLpu5Hs4NAEk=
X-Google-Smtp-Source: AA6agR5KmcaeD/ZAx7hyk/EVO0VjNRxj2+mY1Oqnq+QkYk2/KGrTWl17x+/UAXk89yVKvUz8Ga+hbMBVbUyKs93wrws=
X-Received: by 2002:a05:6638:2391:b0:34a:262:819d with SMTP id
 q17-20020a056638239100b0034a0262819dmr4532584jat.93.1661540991106; Fri, 26
 Aug 2022 12:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com> <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
 <878rnehqnd.fsf@toke.dk> <CAJnrk1YYpcW2Z9XQ9sfq2U7Y6OYMc3CZk1Xgc2p1e7DVCq3kmw@mail.gmail.com>
 <CAP01T75isW8EtuL2AZBwYNzk-OPsMR=QS3YB_oiR8cOLhJzmUg@mail.gmail.com> <20220826063706.pufgtu4rff4urbzf@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220826063706.pufgtu4rff4urbzf@kafai-mbp.dhcp.thefacebook.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 26 Aug 2022 21:09:15 +0200
Message-ID: <CAP01T74oMaGGtJNQ_hHWKzBwwGgwOmH=1Z-c3mauqC9U95UPvA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>,
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

On Fri, 26 Aug 2022 at 08:37, Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Aug 25, 2022 at 01:04:16AM +0200, Kumar Kartikeya Dwivedi wrote:
> > On Wed, 24 Aug 2022 at 20:11, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > I'm more and more liking the idea of limiting xdp to match the
> > > constraints of skb given that both you, Kumar, and Jakub have
> > > mentioned that portability between xdp and skb would be useful for
> > > users :)
> > >
> > > What are your thoughts on this API:
> > >
> > > 1) bpf_dynptr_data()
> > >
> > > Before:
> > >   for skb-type progs:
> > >       - data slices in fragments is not supported
> > >
> > >   for xdp-type progs:
> > >       - data slices in fragments is supported as long as it is in a
> > > contiguous frag (eg not across frags)
> > >
> > > Now:
> > >   for skb + xdp type progs:
> > >       - data slices in fragments is not supported
> I don't think it is necessary (or help) to restrict xdp slice from getting
> a fragment.  In any case, the xdp prog has to deal with the case
> that bpf_dynptr_data(xdp_dynptr, offset, len) is across two fragments.
> Although unlikely, it still need to handle it (dynptr_data returns NULL)
> properly by using bpf_dynptr_read().  The same that the skb case
> also needs to handle dynptr_data returning NULL.
>
> Something like Kumar's sample in [0] should work for both
> xdp and skb dynptr but replace the helpers with
> bpf_dynptr_{data,read,write}().
>
> [0]: https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@gmail.com/T/#mf082a11403bc76fa56fde4de79a25c660680285c
>
> > >
> > >
> > > 2)  bpf_dynptr_write()
> > >
> > > Before:
> > >   for skb-type progs:
> > >      - all data slices are invalidated after a write
> > >
> > >   for xdp-type progs:
> > >      - nothing
> > >
> > > Now:
> > >   for skb + xdp type progs:
> > >      - all data slices are invalidated after a write
> I wonder if the 'Before' behavior can be kept as is.
>
> The bpf prog that runs in both xdp and bpf should be
> the one always expecting the data-slice will be invalidated and
> it has to call the bpf_dynptr_data() again after writing.
> Yes, it is unnecessary for xdp but the bpf prog needs to the
> same anyway if the verifier was the one enforcing it for
> both skb and xdp dynptr type.
>
> If the bpf prog is written for xdp alone, then it has
> no need to re-get the bpf_dynptr_data() after writing.
>

Yeah, compared to the alternative, I guess it's better how it is right
now. It doesn't seem possible to meaningfully hide the differences
without penalizing either case. It also wouldn't be good to make it
less useful for XDP, since the whole point of this and the previous
effort was exposing bpf_xdp_pointer to the user.
