Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC2E6068DF
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 21:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJTTaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 15:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJTTae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 15:30:34 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CD11A5B1C;
        Thu, 20 Oct 2022 12:30:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id w18so1889147ejq.11;
        Thu, 20 Oct 2022 12:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bb8tUZkUDdEfCtbj9v9BtSlOnFqvAoDEAD0yrPFqVao=;
        b=RkgZgoAGFYQuM4tjiPOGCTBZJSZA908D7jM1AoLLBWm2VVMPlAWzOzIIU4Er+vwsQi
         i5/zoREWaEi8sVHRW4gDzCS10puiFGmcZqhGECuJKuEqYSZpLvy+qyFFLVQtGe2U1cuG
         VS0Fhqgjq/iOgT/3k0zDb+V25p5gmqaIzJ4RnXB1ZXE/XHDrB3BWeZ1FRIyEEvedKkSK
         JD2CctoPwIf94swm/zF1jZ1Y7XJhoywP5RWGOI9gq9VCCOqUNuO14NzzPxlz3/SH3/Ju
         kbYl6FEmdT+7mcYLhvUxeHVSoFCPgCM/1vep69dv5twb4jGe3+PNk0se9Ctj3yHX8tLJ
         C85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bb8tUZkUDdEfCtbj9v9BtSlOnFqvAoDEAD0yrPFqVao=;
        b=McmlG50oIX0yb1Jo3laA7fHxxaDL+gBwEyiDAvoPWFhYLNEr7CjiaC9AYyIkntX6ru
         UI1S7OVLQLYE4XxtdSqOA6E5y52CaKuthATsacnSYTAq5e5qIegBnshJNMrLm/6CCcg4
         BImnA2KnSjqbmUQ2vcmclVE7ayRYM9Nl69JPX3sFzSdWIqgdzLcnNA2Shfrm/MIoF/n9
         zzZ9H9DjdkvDGSac3UHzjk6nydkF6L6oCXzhO+QM4/Kf7xL55rOXUK0/ds3w8rxqSQov
         kA9xqK00AsMR1JyN2NdL7AZofLlewlHxArB/d+miLv1dEuu79L4/7UpzzBfnuvYxTxbm
         NCxw==
X-Gm-Message-State: ACrzQf1ls3tddcmKM2SrhCi/RbFfD9hetbxfOY+gL3DscR3quh2pGZS6
        5ZRM0IhrLKyi7EXGYR6AUotGX4asoQLfDZYE2EQ=
X-Google-Smtp-Source: AMsMyM7rx+/3Di2dVksUzUjLlaIThVXf0csRoYO8+j/ReOYbCaEOpLjmAeXEjPpVD0euLhrYmlf1bk2eX706CpU1U3o=
X-Received: by 2002:a17:907:1dd8:b0:78d:cbdc:ff1f with SMTP id
 og24-20020a1709071dd800b0078dcbdcff1fmr12123904ejc.412.1666294230824; Thu, 20
 Oct 2022 12:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220907183129.745846-1-joannelkoong@gmail.com>
 <20220907183129.745846-2-joannelkoong@gmail.com> <cd8d201b-74f7-4045-ad2f-6d26ed608d1e@linux.dev>
 <CAJnrk1ZTbHcFsQPKWnZ+Au8BsiFc++Ud7y=24mAhNXNbYQaXhA@mail.gmail.com>
 <8f900712-8dcc-5f39-7a66-b6b2e4162f94@linux.dev> <de696460-ab5c-0770-017a-2af06eab5187@linux.dev>
In-Reply-To: <de696460-ab5c-0770-017a-2af06eab5187@linux.dev>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 20 Oct 2022 12:30:19 -0700
Message-ID: <CAJnrk1YXr5R679Usko8V8b3dDO5eUcL=mTp14yPHbPXnkfk7Ew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/3] bpf: Add skb dynptrs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        martin.lau@kernel.org, kuba@kernel.org, memxor@gmail.com,
        toke@redhat.com, netdev@vger.kernel.org, kernel-team@fb.com,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 11:40 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 10/19/22 11:34 PM, Martin KaFai Lau wrote:
> > On 10/19/22 1:22 PM, Joanne Koong wrote:
> >> On Fri, Sep 9, 2022 at 4:12 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >>>
> >>> On 9/7/22 11:31 AM, Joanne Koong wrote:
> >>>> For bpf prog types that don't support writes on skb data, the dynptr is
> >>>> read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> >>>> will return NULL; for a read-only data slice, there will be a separate
> >>>> API bpf_dynptr_data_rdonly(), which will be added in the near future).
> >>>>
> >>> I just caught up on the v4 discussion about loadtime-vs-runtime error on
> >>> write.  From a user perspective, I am not concerned on which error.
> >>> Either way, I will quickly find out the packet header is not changed.
> >>>
> >>> For the dynptr init helper bpf_dynptr_from_skb(), the user does not need
> >>> to know its skb is read-only or not and uses the same helper.  The
> >>> verifier in this case uses its knowledge on the skb context and uses
> >>> bpf_dynptr_from_skb_rdonly_proto or bpf_dynptr_from_skb_rdwr_proto
> >>> accordingly.
> >>>
> >>> Now for the slice helper, the user needs to remember its skb is read
> >>> only (or not) and uses bpf_dynptr_data() vs bpf_dynptr_data_rdonly()
> >>> accordingly.  Yes, if it only needs to read, the user can always stay
> >>> with bpf_dynptr_data_rdonly (which is not the initially supported one
> >>> though).  However, it is still unnecessary burden and surprise to user.
> >>> It is likely it will silently turn everything into bpf_dynptr_read()
> >>> against the user intention. eg:
> >>>
> >>> if (bpf_dynptr_from_skb(skb, 0, &dynptr))
> >>>          return 0;
> >>> ip6h = bpf_dynptr_data(&dynptr, 0, sizeof(*ip6h));
> >>> if (!ip6h) {
> >>>          /* Unlikely case, in non-linear section, just bpf_dynptr_read()
> >>>           * Oops...actually bpf_dynptr_data_rdonly() should be used.
> >>>           */
> >>>          bpf_dynptr_read(buf, sizeof(*ip6h), &dynptr, 0, 0);
> >>>          ip6h = buf;
> >>> }
> >>>
> >>
> >> I see your point. I agree that it'd be best if we could prevent this
> >> burden on the user, but I think the trade-off would be that if we have
> >> bpf_dynptr_data return data slices that are read-only and data slices
> >> that are writable (where rd-only vs. writable is tracked by verifier),
> >> then in the future we won't be able to support dynptrs that are
> >> dynamically read-only (since to reject at load time, the verifier must
> >> know statically whether the dynptr is read-only or not). I'm not sure
> >> how likely it is that we'd run into a case where we'll need dynamic
> >> read-only dynptrs though. What are your thoughts on this?
> >
> > Out of all dynptr helpers, bpf_dynptr_data() is pretty much the only important
> > function for header parsing because of the runtime offset.  This offset is good
> > to be tracked in runtime to avoid smart compiler getting in the way.  imo,
> > making this helper less usage surprise is important.  If the verifier can help,
> > then static checking is useful here.
> >
> > It is hard to comment without a real use case on when we want to flip a dynptr
> > to rdonly in a dynamic/runtime way.  Thus, comparing with the example like the
> > skb here, my preference is pretty obvious :)
> > Beside, a quick thought is doing this static checking now should now stop the
>
> typo: should *not* stop the... :(
>
> > dynamic rdonly flip later.  I imagine it will be a helper call like
> > bpf_dynptr_set_rdonly().  The verifier should be able to track this helper call.'
>

Great! I'll change this in v7 to have bpf_dynptr_data() be able to
return both read-writable and read-only data slices, where the rd-only
property is enforced by the verifier.
