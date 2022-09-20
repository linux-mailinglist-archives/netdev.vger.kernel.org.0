Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5F5BE8B8
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiITOWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiITOWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:22:23 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E173867C9E;
        Tue, 20 Sep 2022 07:20:36 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id B919C5C00E9;
        Tue, 20 Sep 2022 10:20:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 20 Sep 2022 10:20:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1663683635; x=1663770035; bh=pPvqmUU71q
        wrpLnIBmAaZIEwDK27ICHWN327l1OQYAo=; b=fZ6Mqcc89NTAsDirXXSi6QVtel
        m3+eQsWM9NeVaLSGhBuI1E4e3ufB5/39QOpZkuIlTLBtJNRzhfYMxnDvFf5dKfLn
        qyIwnOrsWO+Jv48UtHOI8avIzr35u9in3yYq4nEieNOeyTYkcMWU5futwjnkCQ8o
        ySuZoBojvFOxiJ0kFckOAs3gLuuGX4qWcJipkYCd/UoP7a9ufI6xfvIdHs0xgLTE
        htrUryD0lf9dXquJ6e3ElCbeDT2AXjUvxzjKCQtqf394saE526jUYwFcf9RIYRLm
        v96ZMfkJp6v0OO+jH6xuM8RBm7sSnhsCLP1ejh2BUeAaiiiEvTMgRKp0dIAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663683635; x=1663770035; bh=pPvqmUU71qwrpLnIBmAaZIEwDK27
        ICHWN327l1OQYAo=; b=e11CPf1U3XKvfGGo4OukYtRjlapAfQEBEUOp/bT+JoZV
        uT4PQWRcnw9iCTaUzZRreF6tawFiCrZP+iDMxrYGZclQ9owRqaEwv5CYIv+JKtg+
        BYD8Dj3AfLYdzwq1gQnIjX2JT+KNIPHvlSs0YZsBIGIOvtk4X8KqiCQNwm9vxnX+
        iQdlwjvZ0laymTUlJuTS9j8DHEHYBeM4bkc9RJDdq/wUisZBU7wzAFSFp2m0nvTn
        LiNnB/rNNJV/McSA1NAhVgdytS7eSifV4lql1MrLaNcTq/tJOY0edF4ZN4vgs5V5
        EvFA53/Xo1TUWFxsMCO2+CrE6KnsEUlPriERARWWnA==
X-ME-Sender: <xms:M8wpY7eurYPBpJlK2devgHiI-zc1iBhkJL5vpLzQiBkSyu3NrnwkQg>
    <xme:M8wpYxPqlSYO6hVwol8Wop3RpIZZbpMJd1uQKucsDvTTqoOy8KguZcEWAw7tWwK_X
    vM7-2b0klvheU0Y-A>
X-ME-Received: <xmr:M8wpY0gUBlm9qrFdeZcSD1UYKlTsrjaky0jDH1q-rGl7pauRO4X_nU1Zpo-nGBBhIfc9DoF4v6wNl8jyp_6bAI8eRoWQMjpyBvbWcTI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvledgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfeehmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddt
    tddvnecuhfhrohhmpeffrghnihgvlhcuighuuceougiguhesugiguhhuuhdrgiihiieqne
    cuggftrfgrthhtvghrnhepgefhleevheekleejhfeggefhhfefteegieduudevleefudeh
    veevfffgleegtdejnecuffhomhgrihhnpehinhgtlhhuuggvqdifhhgrthdqhihouhdquh
    hsvgdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:M8wpY8--EsXlH4aY7IrmJaGbHF39U-MtOi9OCFkdQR3DlsvLb1PAUA>
    <xmx:M8wpY3v8gGUi5RGohdBXvhi0ilM2ClkMN_SrAUkJHAU8MUj6yKRq2w>
    <xmx:M8wpY7GeDAf_YAAU5KGvGZA_60PfwkYiaMkCbpCwxnzOyoINMin91g>
    <xmx:M8wpY4mj299Ph9PE0v2ai0M-pBowxQGXQgJI1Dn6rrM5f0qPtVjMjg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Sep 2022 10:20:34 -0400 (EDT)
Date:   Tue, 20 Sep 2022 08:20:33 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     pablo@netfilter.org, fw@strlen.de, toke@kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
Subject: Re: [PATCH bpf-next v2 3/3] bpf: Move nf_conn extern declarations to
 filter.h
Message-ID: <20220920142033.3k3yuupwyb5cxqxb@kashmir.localdomain>
References: <cover.1663616584.git.dxu@dxuuu.xyz>
 <3c00fb8d15d543ae3b5df928c191047145c6b5fe.1663616584.git.dxu@dxuuu.xyz>
 <dc251395-78af-2ea3-9049-3b44cb831783@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc251395-78af-2ea3-9049-3b44cb831783@linux.dev>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 10:20:47PM -0700, Martin KaFai Lau wrote:
> On 9/19/22 12:44 PM, Daniel Xu wrote:
> > We're seeing the following new warnings on netdev/build_32bit and
> > netdev/build_allmodconfig_warn CI jobs:
> > 
> >      ../net/core/filter.c:8608:1: warning: symbol
> >      'nf_conn_btf_access_lock' was not declared. Should it be static?
> >      ../net/core/filter.c:8611:5: warning: symbol 'nfct_bsa' was not
> >      declared. Should it be static?
> > 
> > Fix by ensuring extern declaration is present while compiling filter.o.
> > 
> > Fixes: 864b656f82cc ("bpf: Add support for writing to nf_conn:mark")
> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> > ---
> >   include/linux/filter.h                   | 6 ++++++
> >   include/net/netfilter/nf_conntrack_bpf.h | 7 +------
> >   2 files changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 75335432fcbc..98e28126c24b 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -567,6 +567,12 @@ struct sk_filter {
> >   DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
> > +extern struct mutex nf_conn_btf_access_lock;
> > +extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct btf *btf,
> > +				     const struct btf_type *t, int off, int size,
> > +				     enum bpf_access_type atype, u32 *next_btf_id,
> > +				     enum bpf_type_flag *flag);
> > +
> >   typedef unsigned int (*bpf_dispatcher_fn)(const void *ctx,
> >   					  const struct bpf_insn *insnsi,
> >   					  unsigned int (*bpf_func)(const void *,
> > diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
> > index d1087e4da440..24d1ccc1f8df 100644
> > --- a/include/net/netfilter/nf_conntrack_bpf.h
> > +++ b/include/net/netfilter/nf_conntrack_bpf.h
> > @@ -5,6 +5,7 @@
> >   #include <linux/bpf.h>
> >   #include <linux/btf.h>
> > +#include <linux/filter.h>
> 
> The filter.h is only needed by nf_conntrack_bpf.c?  How about moving this
> include to nf_conntrack_bpf.c.  nf_conntrack_bpf.h is included by other
> conntrack core codes.  I would prefer not to spill over unnecessary bpf
> headers to them.  The same goes for the above bpf.h and btf.h which are only
> needed in nf_conntrack_bpf.c also?

Ah yeah. Thanks for catching. Will send out a v3.

Now I'm wondering if https://include-what-you-use.org/ would work with
kernel source. Might give it a try later.

> 
> >   #include <linux/kconfig.h>
> >   #include <linux/mutex.h>
> 
> Also, is mutex.h still needed?

Nope. But forgot to send that out in v3. I'll roll it into v4 if we need
another respin or otherwise I'll send out a separate patch after.

> 
> > @@ -14,12 +15,6 @@
> >   extern int register_nf_conntrack_bpf(void);
> >   extern void cleanup_nf_conntrack_bpf(void);
> > -extern struct mutex nf_conn_btf_access_lock;
> > -extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct btf *btf,
> > -				     const struct btf_type *t, int off, int size,
> > -				     enum bpf_access_type atype, u32 *next_btf_id,
> > -				     enum bpf_type_flag *flag);
> > -
> >   #else
> >   static inline int register_nf_conntrack_bpf(void)
> 
