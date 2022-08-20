Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7785759AA01
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 02:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243577AbiHTAVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 20:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiHTAV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 20:21:29 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59511115991;
        Fri, 19 Aug 2022 17:21:28 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C2E4732003D3;
        Fri, 19 Aug 2022 20:21:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 19 Aug 2022 20:21:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1660954886; x=1661041286; bh=ODX32u60O9
        mjzEl0Wc2d+XWmaBYDOGVb4HYRgD4/OlI=; b=ZqNbtr1c6Br/SYW/qVqjdVWygN
        aCmbUB36ZDc/vU5c5WRsJFRvYXw+VqGaT6nxWu9NizdbTsRao445lCsJaP6VKk/v
        4yoD1LwZsHXXwcLRcwA1gUn/XHiD7SZOwmZ/yIU2UitY9CwZ9FeQMJOs2iCSSdSn
        QQGwkv86K9G07Uao4izkuGRiINHK5GOktuWCkqKc1YI1wjbfYgfBu6wBJI6aR1iQ
        6kWqr93Ti4VmgMBlWFAvGFS1ni2CfqyRpjuSnavyMLCRl1KLWOY+ZgViMUZrWobX
        zSf8DJ/bCh4wCD4lThtq6fsiA/AF0GHFH3XA9Jyg9p2wsUbzuZaPu+Gu6vBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660954886; x=1661041286; bh=ODX32u60O9mjzEl0Wc2d+XWmaBYD
        OGVb4HYRgD4/OlI=; b=Rq/fr1zZ824tnOMOPbfLj9iUS7VlW7cf6Thp3ukFWjDF
        lBkQSsJsfwUJ1wgFfhNAmhBKykSkqRkJuKvGFhndgS9zvpLG32TFxy9QWHig9gD8
        yqlf5ceIi2fMGC5FAM4A7ac6Fp7LxNykVL0KEwQP7q/aqp4+jkYp49F4n/fUN0/V
        JMoknZ8sXHGiAsyM7NLBsuD7gz3rDsxroj5861ezfyi77V2ysxVn8XW91aiCjoLG
        cyLfiFjN6BqQmF5O3MqGt/tWl/iTuhJg8AinthItYQ1RNrJlTgbXms0NkUmOAcQ6
        EeCa2LJTMjEBVX9ke+I4SeTpCiCm/6YKVtb5i0+cCQ==
X-ME-Sender: <xms:BikAY8EDbNcAyMV3rqhVgXhcy-l7H3jhT01JOlzNiPFSOk9fE9Y2bQ>
    <xme:BikAY1UbP-BzAQMk3UMehBp-N26UZDnuwwPEjOnjCkEi2dfb1KwsaUDEq7B4Yno1p
    DfX2BP-O_SjSHvScQ>
X-ME-Received: <xmr:BikAY2JZKQ0exEsoSKa1junqgSY3WkPJCJiRdbXGmGAO2QOEy59adviqUO33LRosmH9wHWzXSWhodmQuubG2N-DpUkPbQuZcsJOM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeivddgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpeffhf
    fvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepveduudegiefhtdffhe
    fggfdugeeggeehtefgvefhkeekieelueeijeelkeeivdfgnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:BikAY-GGJGggK9lRoifJZ04bBxMEsPNwXzu7VOoqHYpK-6zV6sgCzA>
    <xmx:BikAYyVYa9oBeWiHsfGpS2npgY369SJnLcPtwUuiZfkQ3T6T0dN22w>
    <xmx:BikAYxNi6EnNqrqR2WTEr0lbGC8qe78feK2jldE_-z6QDwYe1YGfIw>
    <xmx:BikAY7M9HK2vgUSzU26ioYde99cpQXwzd4f7DWZ4V1CckIlAN-XBzQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Aug 2022 20:21:25 -0400 (EDT)
Date:   Fri, 19 Aug 2022 18:21:24 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 4/5] bpf: Add support for writing to
 nf_conn:mark
Message-ID: <20220820002124.g3d5fud5klvrkjil@kashmir.localdomain>
References: <cover.1660951028.git.dxu@dxuuu.xyz>
 <f44b2eebe48f0653949f59c5bcf23af029490692.1660951028.git.dxu@dxuuu.xyz>
 <CAP01T74fSh6Z=54O+ORKJD7i_izb7rUe3-mHKLgRdrckcisvkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP01T74fSh6Z=54O+ORKJD7i_izb7rUe3-mHKLgRdrckcisvkw@mail.gmail.com>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kumar,

On Sat, Aug 20, 2022 at 01:46:04AM +0200, Kumar Kartikeya Dwivedi wrote:
> On Sat, 20 Aug 2022 at 01:23, Daniel Xu <dxu@dxuuu.xyz> wrote:
[...]
> > +static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
> > +                                       const struct btf *btf,
> > +                                       const struct btf_type *t, int off,
> > +                                       int size, enum bpf_access_type atype,
> > +                                       u32 *next_btf_id,
> > +                                       enum bpf_type_flag *flag)
> > +{
> > +       btf_struct_access_t sa;
> > +
> > +       if (atype == BPF_READ)
> > +               return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
> > +                                        flag);
> > +
> > +       sa = READ_ONCE(nf_conntrack_btf_struct_access);
> 
> This looks unsafe. How do you prevent this race?
> 
> CPU 0                                              CPU 1
> sa = READ_ONCE(nf_ct_bsa);
> 
> delete_module("nf_conntrack", ..);
> 
> WRITE_ONCE(nf_ct_bsa, NULL);
>                                                          // finishes
> successfully
> if (sa)
>     return sa(...); // oops
> 
> i.e. what keeps the module alive while we execute its callback?
> 
> Using a mutex is one way (as I suggested previously), either you
> acquire it before unload, or after. If after, you see cb as NULL,
> otherwise if unload is triggered concurrently it waits to acquire the
> mutex held by us. Unsetting the cb would be the first thing the module
> would do.
> 
> You can also hold a module reference, but then you must verify it is
> nf_conntrack's BTF before using btf_try_get_module.
> But _something_ needs to be done to prevent the module from going away
> while we execute its code.

I think I somehow convinced myself that nf_conntrack_core.o is always
compiled in. Due to some of the garbage collection semantics I saw in
the code.

Lemme take a closer look (for learning I guess). Mutex is probably
safest bet.

[...]

Thanks,
Daniel
