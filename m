Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07420598C92
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245487AbiHRTbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiHRTbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:31:36 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA98CCE26;
        Thu, 18 Aug 2022 12:31:34 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C5C2E3200912;
        Thu, 18 Aug 2022 15:31:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 18 Aug 2022 15:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1660851090; x=1660937490; bh=6ZLA0ZxxOs
        vZ7EcJtLoaAaNIn+eskICnHUlHLXCBjGY=; b=V9SKVDb/20RhGaAKqsOP3qSg6L
        r6wSoJ6CYVL9KG09dah3XDrMpeoq7d73iGJcUuNsAPpiGdROInKyJmKDKMKgKIv4
        todFY5WzEno1B4FCPl+zcbhB6cVWyMZZfPRx0bDphGhu7lxX2gy6VlOtd9FRYfbT
        JnyOHSuT3C2DCHD3qw2VJ92HV+8nzV+U4NMZQR4l49Tk68f7/Fqxn28w9jXJW0ZA
        w9qnKy1QYrH2Hc6u5Ilw3OkxGIDWUqSS5Z7JnCI+ELPcFjToCVv4C+q/Qi2n5/om
        Yx/W4zantiSo8kZnDmahQ/g7bOj53rGqynGWakC10NEeUSZvNiAEapvNGwFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660851090; x=1660937490; bh=6ZLA0ZxxOsvZ7EcJtLoaAaNIn+es
        kICnHUlHLXCBjGY=; b=U6jx24CsqYwpjLnFJ+4HgjhVVCtX8Eb7ZYz599E3dO6V
        aru8yoQI/HJ85+eYJx8qBDyIU0SzbkHvXkREilEWvNQVF80Cbj7tlg3eG328qlrL
        2Gwm/WmrMaliQw3uS3T803kUqm32oM/SI81bFAKTtk2QYtNg9ZOlw6pyxhs9qbEp
        b9OrAhulz7lXOv2wgO5B1729tpOifIRUlHD+Wnpl0Q7ScIryS2B+CdrnF7f3C52+
        HqWwoKqsv+oDfjv7Dg/wuvJ9OAFMgKjPXsVi3OxH9xvAN5Rr+ZEx56RZ30E0iac4
        B1Rm0nsSWz91R3mDj4ldzbPWzgYoo6S9WIWm2mxpUQ==
X-ME-Sender: <xms:kZP-YmzFwbPRKcB1Cm4Fs2kgDCDF4bWOVLdCW90hC0SWvpRlO69J_Q>
    <xme:kZP-YiQzZpAuheheWqmRCJs50BxKGl7EbvRM3Tn0_E572q3K9cvPpOXpp8Iq5JKdl
    2UNg23uEOaukxxIsA>
X-ME-Received: <xmr:kZP-YoV2BqKmXr1vlzPi_l1mTqOYX5XkyKMvqKsQS44wsP113r4cRBveBvk2L8na0mWjooa7KnRhCp18dS9ZApBDETDFjr3qD4H6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehledgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhepff
    fhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpeevuddugeeihfdtff
    ehgffgudeggeegheetgfevhfekkeeileeuieejleekiedvgfenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:kZP-Yshgu6iaUbk7Uc6aHVeHipbse-neN5k8_RsAbvFG9w-TEu1oUQ>
    <xmx:kZP-YoCpXxVl8LmtBSlqoBeq-eAtF6aK-UAywQLqe0zdSRzwk_48ZQ>
    <xmx:kZP-YtLH6s5LSpMmfHwylLYE8eQlOcrtejC2wWGrbLhw7fGiOZT23w>
    <xmx:kpP-YotDCkaSiKtWrgHklaLTY7gf9SI091tU1ubD0Fr3hZWGdcl9NQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Aug 2022 15:31:28 -0400 (EDT)
Date:   Thu, 18 Aug 2022 13:31:27 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/4] bpf: Add support for writing to
 nf_conn:mark
Message-ID: <20220818193127.ykwoinzpoyxqwevg@kashmir.localdomain>
References: <cover.1660761470.git.dxu@dxuuu.xyz>
 <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
 <CAP01T75P5uM9EyX38bcoF4L2cbQ8orNVNhZsdoMXRThX5fd6JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP01T75P5uM9EyX38bcoF4L2cbQ8orNVNhZsdoMXRThX5fd6JQ@mail.gmail.com>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 09:48:31PM +0200, Kumar Kartikeya Dwivedi wrote:
> On Wed, 17 Aug 2022 at 20:43, Daniel Xu <dxu@dxuuu.xyz> wrote:
[...]
> > diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
> > index a473b56842c5..0f584c2bd475 100644
> > --- a/include/net/netfilter/nf_conntrack_bpf.h
> > +++ b/include/net/netfilter/nf_conntrack_bpf.h
> > @@ -3,6 +3,7 @@
> >  #ifndef _NF_CONNTRACK_BPF_H
> >  #define _NF_CONNTRACK_BPF_H
> >
> > +#include <linux/bpf.h>
> >  #include <linux/btf.h>
> >  #include <linux/kconfig.h>
> >
> > @@ -10,6 +11,12 @@
> >      (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
> >
> >  extern int register_nf_conntrack_bpf(void);
> > +extern int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> > +                                         const struct btf *btf,
> > +                                         const struct btf_type *t, int off,
> > +                                         int size, enum bpf_access_type atype,
> > +                                         u32 *next_btf_id,
> > +                                         enum bpf_type_flag *flag);
> >
> >  #else
> >
> > @@ -18,6 +25,17 @@ static inline int register_nf_conntrack_bpf(void)
> >         return 0;
> >  }
> >
> > +static inline int
> > +nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> > +                              const struct btf *btf,
> > +                              const struct btf_type *t, int off,
> > +                              int size, enum bpf_access_type atype,
> > +                              u32 *next_btf_id,
> > +                              enum bpf_type_flag *flag)
> > +{
> > +       return -EACCES;
> > +}
> > +
> 
> We should make it work when nf_conntrack is a kernel module as well,
> not just when it is compiled in. The rest of the stuff already works
> when it is a module. For that, you can have a global function pointer
> for this callback, protected by a mutex. register/unregister sets
> it/unsets it. Each time you call it requires mutex to be held during
> the call.
> 
> Later when we have more modules that supply btf_struct_access callback
> for their module types we can generalize it, for now it should be ok
> to hardcode it for nf_conn.

Ok, will look into that.

> 
> >  #endif
> >
> >  #endif /* _NF_CONNTRACK_BPF_H */
[...]
> >
> > +/* Check writes into `struct nf_conn` */
> > +int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> > +                                  const struct btf *btf,
> > +                                  const struct btf_type *t, int off,
> > +                                  int size, enum bpf_access_type atype,
> > +                                  u32 *next_btf_id,
> > +                                  enum bpf_type_flag *flag)
> > +{
> > +       const struct btf_type *nct = READ_ONCE(nf_conn_type);
> > +       s32 type_id;
> > +       size_t end;
> > +
> > +       if (!nct) {
> > +               type_id = btf_find_by_name_kind(btf, "nf_conn", BTF_KIND_STRUCT);
> > +               if (type_id < 0)
> > +                       return -EINVAL;
> > +
> > +               nct = btf_type_by_id(btf, type_id);
> > +               WRITE_ONCE(nf_conn_type, nct);
> 
> Instead of this, why not just use BTF_ID_LIST_SINGLE to get the
> type_id and then match 't' to the result of btf_type_by_id?
> btf_type_by_id is not expensive.

Ah yeah, good idea. Will fix.

[...]

Thanks,
Daniel
