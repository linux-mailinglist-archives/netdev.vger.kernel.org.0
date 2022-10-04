Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631675F45E0
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 16:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJDOqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 10:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiJDOqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 10:46:12 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78C55F13C;
        Tue,  4 Oct 2022 07:46:09 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3BFC65C0156;
        Tue,  4 Oct 2022 10:46:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 04 Oct 2022 10:46:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1664894766; x=1664981166; bh=Y1VGbCsu5o
        5kYEKIpKet6zL2OfYtDvzVRcqdfrxnqAE=; b=iwKLWJO4vqTKd6vNwZzNUz4x5M
        pSsYDoygZrLWW2YPA51tEw3zRZyzwr7+ixf13W1hw1yXCaXy7mDp4nClSEmXVknn
        wqHnv9KmxdPIw/U/Rd+MZEXD97KOmAVCVc8fiBivwxJtD4bKzNyy2P6MP8MjCvaZ
        q7JQoZm/+X+APZkF1LMjyLrD58SKQL6CP52HFRVayPv6xABIQqOTgf7utYl9+MYv
        uTCcd1cpZzOuJZBS0Elur82rYwjeglSA5McwBImxqiZ9zDJZZLUmcYwt1V3RvOx0
        I6awsigweDd8hQStS6WcRFB4I9myL+6n2doex4YK5SjzO91oCLuqTduTOx4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1664894766; x=1664981166; bh=Y1VGbCsu5o5kYEKIpKet6zL2OfYt
        DvzVRcqdfrxnqAE=; b=v6Aqx7DxvoPBuS1l/9/rpc13i4iWrrrMq8f3sqVDNvOD
        xiGDRU/3QM5ti+e5dC2wpfVh5FPRsm54LzxJl4rohrobBqsuZgoNGBCWQHYAoC/+
        l+IAKtrpCfNuvvHqqhMB9sabJt4Tqy/kmMcFyk7p3Amxutx9LQHOk5N+pteSUo+v
        Q2Lgc85dKtggip6/85fsgGOsBwFDyyUmBHvc95Z1wIts5LYSGunjuFrv95Ys28ds
        ZmJV9GVv5bvKhA28jP0cgHHtLcN1lEtHbcf2p8a6zVdXmIMOlWVLiYQvuC093e9E
        jVdDKpU7yIcENw5SAZIi9t8mI7sJzy1Pt63sG3yWcg==
X-ME-Sender: <xms:Lkc8Y88lVVljlxgzGiEajDnZqlZ_RLRIMPCFZzhVy4ovkbw1Frl8Ug>
    <xme:Lkc8Y0svAy68AmeJuarh2ewuDWGH7Ds3aW2mku2PzU65RJEuO9ughPtHP_0yYRbNS
    VlimS_pGWNHLzEX6Q>
X-ME-Received: <xmr:Lkc8YyDdXA6o__IOp-rKWjhML3bGxPFr_x9SalMZ3ztLvhWd6LaggjOLZGeGEjeCw2Oft7GYl2sOOcojgCDuGRAyqBbUZlsSxdT6N2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeiuddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfeehmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddt
    tddvnecuhfhrohhmpeffrghnihgvlhcuighuuceougiguhesugiguhhuuhdrgiihiieqne
    cuggftrfgrthhtvghrnhepheeltedvgffhgfduudelleeguddtueefgfefvdeukeffvdeg
    uddtvdeuteehteevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdig
    hiii
X-ME-Proxy: <xmx:Lkc8Y8dSmGqe8dk8Lq-ccl7MzLQu3wB7ebVanmXUvyQO4JtnUsYzig>
    <xmx:Lkc8YxPN8VoTgAqFosl7_D_mDO0ls9q-2_rcF4s82Ld89l4qYa0Vkg>
    <xmx:Lkc8Y2n_nf9JbpgaqVY8bZxYaHQFF_xPuJWuC76gzgZp1gmo1NBj7w>
    <xmx:Lkc8YyqJ1RsmJ5K-Lyqn1F_4u2UDDU_gvqeAf3kl7CX7cmt9Y1s4bg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Oct 2022 10:46:05 -0400 (EDT)
Date:   Tue, 4 Oct 2022 08:46:03 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin KaFai Lau <martin.lau@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <20221004144603.obymbke3oarhgnnz@kashmir.localdomain>
References: <20221003190545.6b7c7aba@kernel.org>
 <20221003214941.6f6ea10d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003214941.6f6ea10d@kernel.org>
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

Hi Jakub,

On Mon, Oct 03, 2022 at 09:49:41PM -0700, Jakub Kicinski wrote:
> On Mon, 3 Oct 2022 19:05:45 -0700 Jakub Kicinski wrote:
> > Hi Jiri,
> > 
> > I get the following warning after merging up all the trees:
> > 
> > vmlinux.o: warning: objtool: ___ksymtab+bpf_dispatcher_xdp_func+0x0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
> > vmlinux.o: warning: objtool: bpf_dispatcher_xdp+0xa0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
> > 
> > $ gcc --version
> > gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-15)
> > 
> > 
> > Is this known?
> 
> Also hit this:
> 
> WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using 92168
> WARN: multiple IDs found for 'nf_conn': 92168, 121226 - using 92168

I believe this is now-fixed pahole bug. See:
https://lore.kernel.org/bpf/20220907023559.22juhtyl3qh2gsym@kashmir.localdomain/

That being said, I didn't manage to find a pahole commit that directly
addresses the issue, so maybe upgrading pahole perturbed enough things
for this warning to go away?

If the warning is back on pahole master I can take another look.

Thanks,
Daniel
