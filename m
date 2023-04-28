Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0327A6F1C4A
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346014AbjD1QJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345696AbjD1QJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:09:41 -0400
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348D35261;
        Fri, 28 Apr 2023 09:09:38 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 645C72B0694E;
        Fri, 28 Apr 2023 12:09:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 28 Apr 2023 12:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1682698172; x=
        1682705372; bh=cbTkCGhDldgonJsiL/EQyO8MV5eih+uB/j3ETloCYi8=; b=U
        TKTcGQ8yytq19css891tWK51auYev0Reld9bJ2my3BP3Ifw8+k1H1f8i/2a2JcwW
        4tUKfHWVGOe2XMolnZknhJILbtoA9XhdE7Pz/fuDtvzGQwm5l/ePS4LPlHWCIJ9H
        igWwwG/T18AJtu6qcnbiJ06P1t4JZTVoKFg0hmp96woab3Wen/tOgb18Slzot/Zs
        KT6dSF/51ILQfun3/pGQ+5g8RjJO1SswYg+tdzZhQ2vN3lw0b5o9YEU6xymzcVf+
        xMZNDwY7kk7JA+ml7SgZn+Ls05W1+MmnllgCx8xaVgalQNH+nwTeqDq+mIflZwaI
        PGzKAOeMLzsosAbl99HUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682698172; x=1682705372; bh=cbTkCGhDldgon
        JsiL/EQyO8MV5eih+uB/j3ETloCYi8=; b=KwoQuMAh1OWYUsQgYguWDapvbenN+
        NPb1xxRBlTpeCEUB06Fmt1l8S5j051HrQN0bMWCA30PS/5c5y6x+JicySX2X1SML
        nXjP2gqaVmpN3OHeFX19ZG2OfkP9XhkJFeG/8nBNWVJoDeU7Ytd7B21sMbraVKAJ
        xpzmJviZg59T4n60trgG4+aXTgZUe2cPxyWOtiCPF4+aHa6/RIvDASNVjBxpM6P8
        Hq5bMIPkTkfjhkXXzjcl3GqKwux6BGiC7FI8UWSAhpctF21GjFfYVyu9rF1zsi5Y
        4pqy8t80fkltCAvjQr3KCe57qRmNjdnZkrak5kLMp45AvJrtV098LKWLQ==
X-ME-Sender: <xms:ue9LZHc15g2COXDiT235MxBncV3-Ks6UYezPeeWJYINkFuXpOriZ_A>
    <xme:ue9LZNPJt4JqPx1KiFB90OqISOQoJatrad8ziZdtMUM0EmMzeLgzASGf6Xn5QHcQF
    _lVt5AnBdg2sXcV5gY>
X-ME-Received: <xmr:ue9LZAjZeMdgdQ8y8BQ4sdXsnXbhYZHm7kQq_V2DxC_NU6jZ4RxHw2CuZwjg7GLDGYwtLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedukedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdttddttddtvdenucfhrhhomhepfdfmihhr
    ihhllhcutecurdcuufhhuhhtvghmohhvfdcuoehkihhrihhllhesshhhuhhtvghmohhvrd
    hnrghmvgeqnecuggftrfgrthhtvghrnhepgfdtveeugeethfffffeklefgkeelgfekfedt
    heeileetuefhkeefleduvddtkeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:ue9LZI8EtclLzxy3ZY7zPpzbhOAHJaYrRZ46mRD072g_oj5E51VD3Q>
    <xmx:ue9LZDsvQ_abrLpWkCXZ-AZmB0XFGWRAkxFK35nN-oET8Jv2HlVuXA>
    <xmx:ue9LZHG6VGyrNfjx6oHcM3AUlmxe7fSmc_YALlcAKXdHteQ9CfbL_Q>
    <xmx:vO9LZFbSdoe0zavFOra8obUbyloAG3xDqqIz538zJw2J5uFgP_37lwMtrx8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Apr 2023 12:09:28 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 856481041AE; Fri, 28 Apr 2023 19:09:25 +0300 (+03)
Date:   Fri, 28 Apr 2023 19:09:25 +0300
From:   "Kirill A . Shutemov" <kirill@shutemov.name>
To:     David Hildenbrand <david@redhat.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 05:43:52PM +0200, David Hildenbrand wrote:
> On 28.04.23 17:34, David Hildenbrand wrote:
> > On 28.04.23 17:33, Lorenzo Stoakes wrote:
> > > On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
> > > > > > 
> > > > > > Security is the primary case where we have historically closed uAPI
> > > > > > items.
> > > > > 
> > > > > As this patch
> > > > > 
> > > > > 1) Does not tackle GUP-fast
> > > > > 2) Does not take care of !FOLL_LONGTERM
> > > > > 
> > > > > I am not convinced by the security argument in regard to this patch.
> > > > > 
> > > > > 
> > > > > If we want to sells this as a security thing, we have to block it
> > > > > *completely* and then CC stable.
> > > > 
> > > > Regarding GUP-fast, to fix the issue there as well, I guess we could do
> > > > something similar as I did in gup_must_unshare():
> > > > 
> > > > If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
> > > > fallback to ordinary GUP. IOW, if we don't know, better be safe.
> > > 
> > > How do we determine it's non-anon in the first place? The check is on the
> > > VMA. We could do it by following page tables down to folio and checking
> > > folio->mapping for PAGE_MAPPING_ANON I suppose?
> > 
> > PageAnon(page) can be called from GUP-fast after grabbing a reference.
> > See gup_must_unshare().
> 
> IIRC, PageHuge() can also be called from GUP-fast and could special-case
> hugetlb eventually, as it's table while we hold a (temporary) reference.
> Shmem might be not so easy ...

page->mapping->a_ops should be enough to whitelist whatever fs you want.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
