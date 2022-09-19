Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8EF5BD453
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 20:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiISSDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 14:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiISSDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 14:03:23 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A864599C;
        Mon, 19 Sep 2022 11:03:21 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EF2C25C03D7;
        Mon, 19 Sep 2022 14:03:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 19 Sep 2022 14:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1663610598; x=1663696998; bh=987LUrc4zQ
        PtHVau80T7pZjc6IgipyocTtu77bLG6/g=; b=k34h2mW1ChpGJS7VPbcoR55SmX
        lI9JlZPaFyet4658/jWi7lDmrqxDoM/LYsDisT2Uk+9dVSjQ3J39nuXAr1rGzkw5
        6vk/CvInT0MgoSm644jRZDGKF79IbutEcgBcfAd5ROcDQGhL+FJ1A/5Y+lY/l+Hm
        BDLT6FT8wv2ZDq5+FSyoTfT7UMyPSwpWfsBvyEtDU2YCCliqGhFGr1lorvu9NlJ1
        uq6+XCyAwbNOvzXUAEZ+ykw3L9jL3NtEth9yfmVNONaAl0gRMfv7PkM/KLd359nM
        sFM64XXDuNo15oS3EO0kfXz0Nqb8SlQvZ1VJUecDMKSPxU5Fa33Mi+7OWcEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663610598; x=1663696998; bh=987LUrc4zQPtHVau80T7pZjc6Igi
        pyocTtu77bLG6/g=; b=1Gm41UVhoHKB9WKRlHghT1PulnDbf30g7hBJeRpHiAZw
        C+XzNMuVP5y6vnClJitGNl4eMEazhtALy3mIanSznSSIR5yh/ms6IrqMnmeqx0m6
        Mra6zmIih+qGFvNz5fnRIZ7kGB9XQkQwcSVsTXODaNFf70LD1IlDSwHcs4R08sP+
        D3pCUaOnu795mRpBa/wH0QocFBABr5BEsSxR4x5pjDZHZFA0rghvVboigzS/NZlE
        dV1BvBRXREG2MvDSq+/p7XCgaeH93Zv9jX3iMdqRqGT+sSadtHj44syWrCopEUDM
        DtRe4GjD1VJ7YjbNgcnncuUo7+NmLdQBS0SoSVaMkA==
X-ME-Sender: <xms:5q4oYyMutQN941BrJrJphmyOgghX5lVoudCeMf4Fb70yBco05AV3pQ>
    <xme:5q4oYw8z0oVr7lF71EMn2FZcEuqnm4nNhSpcL0l-PCoNz2EIyTfxD3GNhJ1PXPCLa
    sCOFs7k3jIfdcxklw>
X-ME-Received: <xmr:5q4oY5SPk98Rqyc88ITJD3t7v1_XuTZH_S7YztEuuqzsn3I1yRUmEV8DbujwXxjPe2M_bbqrYR-c7kb3FWkZ3MWk3sSCKX4-BsL9tpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdefhedmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredt
    tddtvdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqe
    enucggtffrrghtthgvrhhnpeevuddugeeihfdtffehgffgudeggeegheetgfevhfekkeei
    leeuieejleekiedvgfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:5q4oYyuGJr5SkZGVcR8SkvFGqtBKeqRPCdF2iFnbcbqoZhZX3kmm5A>
    <xmx:5q4oY6eG2chxcEDPzFyLWvpj68KSmK9xK0rxEnSSrSDnFRqpFqpjsg>
    <xmx:5q4oY237cmjc8qBF4GTZTlfiIARDHjZPaFMeqjpYDg1qLe5IF4IHmA>
    <xmx:5q4oY7UQW-axktvP_TiZ-Og7oFmoSV2hqV4vq8gIHedwQyldO3dStw>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 14:03:17 -0400 (EDT)
Date:   Mon, 19 Sep 2022 12:03:15 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, pablo@netfilter.org,
        fw@strlen.de, toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Subject: Re: [PATCH bpf-next] bpf: Move nf_conn extern declarations to
 filter.h
Message-ID: <20220919180315.n565ugbvzlxqgezq@kashmir.localdomain>
References: <c4cb11c8ffe732b91c175a0fc80d43b2547ca17e.1662920329.git.dxu@dxuuu.xyz>
 <ada17021-83c9-3dad-5992-4885e824ecac@linux.dev>
 <CAP01T74=btUEPDrz0EVm9wNuMmbbqc2wRvtpJ-Qq45OtasMBZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP01T74=btUEPDrz0EVm9wNuMmbbqc2wRvtpJ-Qq45OtasMBZQ@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 10:35:03PM +0200, Kumar Kartikeya Dwivedi wrote:
> On Fri, 16 Sept 2022 at 22:20, Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >
> > On 9/11/22 11:19 AM, Daniel Xu wrote:
> > > We're seeing the following new warnings on netdev/build_32bit and
> > > netdev/build_allmodconfig_warn CI jobs:
> > >
> > >      ../net/core/filter.c:8608:1: warning: symbol
> > >      'nf_conn_btf_access_lock' was not declared. Should it be static?
> > >      ../net/core/filter.c:8611:5: warning: symbol 'nfct_bsa' was not
> > >      declared. Should it be static?
> > >
> > > Fix by ensuring extern declaration is present while compiling filter.o.
> > >
> > > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> > > ---
> > >   include/linux/filter.h                   | 6 ++++++
> > >   include/net/netfilter/nf_conntrack_bpf.h | 7 +------
> > >   2 files changed, 7 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > > index 527ae1d64e27..96de256b2c8d 100644
> > > --- a/include/linux/filter.h
> > > +++ b/include/linux/filter.h
> > > @@ -567,6 +567,12 @@ struct sk_filter {
> > >
> > >   DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
> > >
> > > +extern struct mutex nf_conn_btf_access_lock;
> > > +extern int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
> > > +                    const struct btf_type *t, int off, int size,
> > > +                    enum bpf_access_type atype, u32 *next_btf_id,
> > > +                    enum bpf_type_flag *flag);
> >
> > Can it avoid leaking the nfct specific details like
> > 'nf_conn_btf_access_lock' and the null checking on 'nfct_bsa' to
> > filter.c?  In particular, this code snippet in filter.c:
> >
> >          mutex_lock(&nf_conn_btf_access_lock);
> >          if (nfct_bsa)
> >                  ret = nfct_bsa(log, btf, ....);
> >         mutex_unlock(&nf_conn_btf_access_lock);
> >
> >
> > Can the lock and null check be done as one function (eg.
> > nfct_btf_struct_access()) in nf_conntrack_bpf.c and use it in filter.c
> > instead?
> 
> Don't think so, no. Because we want nf_conntrack to work as a module as well.
> I was the one who suggested nf_conn specific names for now. There is
> no other user of such module supplied
> btf_struct_access callbacks yet, when one appears, we should instead
> make registration of such callbacks properly generic (i.e. also
> enforce it is only for module BTF ID etc.).
> But that would be a lot of code without any users right now.
> 
> >
> > btw, 'bsa' stands for btf_struct_access? It is a bit too short to guess ;)
> >
> > Also, please add a Fixes tag.
> >
> 
> Agreed. Daniel, can you address the remaining two points from Martin and respin?

Yes, will do.

Thanks,
Daniel
