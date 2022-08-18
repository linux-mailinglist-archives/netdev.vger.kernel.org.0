Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A97598C96
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345511AbiHRTcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiHRTb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:31:58 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2665CCCE34;
        Thu, 18 Aug 2022 12:31:58 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 741CB3200912;
        Thu, 18 Aug 2022 15:31:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 18 Aug 2022 15:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1660851115; x=1660937515; bh=N34gQPDvkw
        MyOkC3GrCuym5zwS0Pzq+Cxj1ER7CAjUM=; b=NrL8bYm4JIEZp86igNy2yRBLc/
        IDVVNyhH2xn+VNrhWAyd5BCMaZp+D7Cu9o1pw0Zb/4FcIB3yrV0sRIR53COzjXbw
        Snh5ytq/tBnh4QH6smBuKIOfkR3T+WHS4BaNJNTA+lD1VYPVPtyclAkT/xEvieHn
        WjV320NzBN34YpdluhIU3XORPtzMv76Mz924qd1lXh8paEOP3zS1vOBfWsvFDJNb
        rJX+OOQQAdRNxs8hLVHK9vXyHABLeg2rUAHj/4QhYruXlBkZJe3OuM7jb5TTv9WI
        XTumdUELROwi9aAAmC1svRIqj/uNTOpHJAt3Xv1TYZoCALjG3R8RMu5FG2MQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660851115; x=1660937515; bh=N34gQPDvkwMyOkC3GrCuym5zwS0P
        zq+Cxj1ER7CAjUM=; b=XY4feljb7VAY8mhgojciE7utjdWlrN4xCYTs2ujZTIW/
        jb3QmoDCTov9Dys02S4VC/FhsoYAKmNZv21GnS2WAGdWcgysqP9+gXg9Pci7o9O8
        4M34U2gfHBVu0rENeum4Zsh3401gjS+JIyrI355+/S/ohAvwjeuG+XFWnVVX1lLg
        RJTAgbZnGNG6+cLA/qvxRGjy72xuznKlddi429b6m92GP0jbWMpyRxBMnDkfqhS3
        kpCxPFIYo0s/i3EaGZs806FYTsHTUcaQWCYW40qu+eC97knst2IBaBuEkJUIGyZ5
        iX7AyrpBiH41pai+eySfvHJCGvW1keDFKiNy6UUF3A==
X-ME-Sender: <xms:q5P-YoeVGxjYqHKgGMetgDQzzQLMga2vHYpIasWgw_Ng7rhXzdwrFQ>
    <xme:q5P-YqMQgD4m5_yQPhD3xieWEJ4FGqsb1aAQcwviKuY905wr56e2Qr1ZEluvTzSta
    eSuWaaAKZrCeOlTng>
X-ME-Received: <xmr:q5P-YpjfHVPfIYvUWQ6-lbMoqRWYKoGQNn2HiDN9hL0aH416Dd18mfae4bfH_e-B6biTIrm-3YV4oNvFXk6DzlqkUG6KYeE24E3->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehledgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdejtddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredt
    tddtvdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqe
    enucggtffrrghtthgvrhhnpeevuddugeeihfdtffehgffgudeggeegheetgfevhfekkeei
    leeuieejleekiedvgfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:q5P-Yt8vnm8CygyL_eUwAsUU5fi-qacNH9OMbGZAEuzlES_7uObG1w>
    <xmx:q5P-YkuANGXjq-FfMOSG8CQJ0AA1yzXZ7EbJXD7hzXwmCR1q8etLMA>
    <xmx:q5P-YkGeqBI-noWwMDUNWQQBOnbzjGL7qI6PqHvIO8a4dZOJmubaMg>
    <xmx:q5P-YlEM1H1-ug7APxyiT8jmTonkTF55Dz_JPaKcIYF0shilIawD-w>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Aug 2022 15:31:54 -0400 (EDT)
Date:   Thu, 18 Aug 2022 13:31:53 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 3/4] bpf: Add support for writing to
 nf_conn:mark
Message-ID: <20220818193153.wysd2wizpf5kgaqu@kashmir.localdomain>
References: <cover.1660761470.git.dxu@dxuuu.xyz>
 <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
 <CAADnVQ+G0Hju-OeN6e=JLPQzODxGXCsP7OuVbex1y-EYr6Z5Yw@mail.gmail.com>
 <20220817220501.kiftkkaqepooforu@kafai-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817220501.kiftkkaqepooforu@kafai-mbp>
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

On Wed, Aug 17, 2022 at 03:05:01PM -0700, Martin KaFai Lau wrote:
> On Wed, Aug 17, 2022 at 02:30:01PM -0700, Alexei Starovoitov wrote:
> > On Wed, Aug 17, 2022 at 11:43 AM Daniel Xu <dxu@dxuuu.xyz> wrote:
> > >
> > > +/* Check writes into `struct nf_conn` */
> > > +int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> > > +                                  const struct btf *btf,
> > > +                                  const struct btf_type *t, int off,
> > > +                                  int size, enum bpf_access_type atype,
> > > +                                  u32 *next_btf_id,
> > > +                                  enum bpf_type_flag *flag)
> > > +{
> > > +       const struct btf_type *nct = READ_ONCE(nf_conn_type);
> > > +       s32 type_id;
> > > +       size_t end;
> > > +
> > > +       if (!nct) {
> > > +               type_id = btf_find_by_name_kind(btf, "nf_conn", BTF_KIND_STRUCT);
> > > +               if (type_id < 0)
> > > +                       return -EINVAL;
> > > +
> > > +               nct = btf_type_by_id(btf, type_id);
> > > +               WRITE_ONCE(nf_conn_type, nct);
> > > +       }
> > > +
> > > +       if (t != nct) {
> > > +               bpf_log(log, "only read is supported\n");
> > > +               return -EACCES;
> > > +       }
> > > +
> > > +       switch (off) {
> > > +#if defined(CONFIG_NF_CONNTRACK_MARK)
> > > +       case offsetof(struct nf_conn, mark):
> > > +               end = offsetofend(struct nf_conn, mark);
> > > +               break;
> > > +#endif
> > > +       default:
> > > +               bpf_log(log, "no write support to nf_conn at off %d\n", off);
> > > +               return -EACCES;
> > > +       }
> > > +
> > > +       if (off + size > end) {
> > > +               bpf_log(log,
> > > +                       "write access at off %d with size %d beyond the member of nf_conn ended at %zu\n",
> > > +                       off, size, end);
> > > +               return -EACCES;
> > > +       }
> > > +
> > > +       return NOT_INIT;
> > 
> > Took me a long time to realize that this is a copy-paste
> > from net/ipv4/bpf_tcp_ca.c.
> > It's not wrong, but misleading.
> > When atype == BPF_READ the return value from
> > btf_struct_access should only be error<0, SCALAR_VALUE, PTR_TO_BTF_ID.
> > For atype == BPF_WRITE we should probably standardize on
> > error<0, or 0.
> > 
> > The NOT_INIT happens to be zero, but explicit 0
> > is cleaner to avoid confusion that this is somehow enum bpf_reg_type.
> > 
> > Martin,
> > since you've added this code in bpf_tcp_ca, wdyt?
> Yep, sgtm.  This will be less confusing.

Ok, will fix both occurrences. 

Thanks,
Daniel
