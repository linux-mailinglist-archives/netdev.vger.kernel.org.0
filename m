Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8046EE005
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 12:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbjDYKMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 06:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbjDYKMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 06:12:07 -0400
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044CDC15B;
        Tue, 25 Apr 2023 03:12:05 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 1B7DD2B0671D;
        Tue, 25 Apr 2023 06:12:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 25 Apr 2023 06:12:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1682417521; x=
        1682424721; bh=6ykmRoJ2ViKku45z63OOrhQO86nvESrAdiWG+K7bYwg=; b=c
        TDVrrJwJKmBSLCZheZhCKbfhHj89iyuDI9vXtVPgz7Ym9svXdHwoke8YmZXCqthh
        Dw/yM/Yh6/Jv7G+J6l6Hz8flfXI8blB1z1RdOTyprn4atgk5r/DyuW3RMbxU5w5R
        Si1LutW9YV4Ae12xbcNxhUZ6Z0mRfVihmRIuRAt3clBMGEoo68fwSqrMZtChKUZD
        vtUDX/Ybm48ar48ml6553kpg21Diy6e3UNUHLcKlx+Wmw0n6bt/9aNBmpO2rsJ2g
        9jb58e80XBwgakjaHtHw/nkJ0wasVCDg+Kvn6VcIvfTlQ/NiJJyWfBkmhvmETTEj
        zHTqFHPh2Hhe3XEIN54aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682417521; x=1682424721; bh=6ykmRoJ2ViKku
        45z63OOrhQO86nvESrAdiWG+K7bYwg=; b=WJYj4cV/CB4Wt++zgV0y3XLrBW2V8
        IdDYNBmyW2TZ1BrHyTSM9xB23HAFhIxnRPIIfMUl4cwi3LitMeI4niSUQDfl9LDx
        OPYbWpYhJlZmJg03JnqcJmvWCtPqpqA/6HouMN/xIHvYuPM5P5dx0vYavhlOn8Tm
        5LsAwNBieltv76YqxmRogvh50Xm6vyEAdzjio6lCgUIoZsNnqvgWFgioK8zPaaKw
        hMhwsBKgdekr/gn033pJNRMzyaELXGIdSWOA4MneADwWnj/xsxdsheSx2jvrh+oG
        UnZN4Re0NkR2JE7gRX8TD+r9w+ApJAQWuqc3dDXd9mB2rjvlwdtOVKDMw==
X-ME-Sender: <xms:badHZHZYeUEJENgpRE-Mpgrt1Kvgbk2MbTmcyCjfaBtU_2hp4c4IQA>
    <xme:badHZGbK4g4wsD9GCgR3WiRiO_Iia6kZTZANxPHNHZF7XueO7yYEp0ernSM95mBun
    XnNqO-UuaPRKcTMugA>
X-ME-Received: <xmr:badHZJ8p0BmVMjsWocvSADfdKF8pvgWXCejORpFkadjfYUkLpzXhOisfhMbwrbdPYMUaVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduvddgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdttddttddtvdenucfhrhhomhepfdfmihhr
    ihhllhcutecurdcuufhhuhhtvghmohhvfdcuoehkihhrihhllhesshhhuhhtvghmohhvrd
    hnrghmvgeqnecuggftrfgrthhtvghrnhepgfdtveeugeethfffffeklefgkeelgfekfedt
    heeileetuefhkeefleduvddtkeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:badHZNr-fYgDaMsdl0i06VFTXfz4uwQu1qn-h1U2NkURVghgIOZnjA>
    <xmx:badHZCoj2YlNzXGd--O7PUdLSPYnUr9pSyEqOofDPvkdLLGnyL_tTA>
    <xmx:badHZDRRqh6NXkdKb-2c7-BTlI6SRGXQ9rU1uFuPtofbAfFpt2ZXzQ>
    <xmx:cadHZPqdozY9VQMi-DJd91YwjAyNau4zQj66k-gSVvDIlBKXdE7pyUOlFp8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Apr 2023 06:11:57 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id F3F9D10BAC9; Tue, 25 Apr 2023 13:11:53 +0300 (+03)
Date:   Tue, 25 Apr 2023 13:11:53 +0300
From:   "Kirill A . Shutemov" <kirill@shutemov.name>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v3] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <20230425101153.xxi4arpwkz7ijnvm@box.shutemov.name>
References: <23c19e27ef0745f6d3125976e047ee0da62569d4.1682406295.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23c19e27ef0745f6d3125976e047ee0da62569d4.1682406295.git.lstoakes@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 08:14:14AM +0100, Lorenzo Stoakes wrote:
> GUP does not correctly implement write-notify semantics, nor does it
> guarantee that the underlying pages are correctly dirtied, which could lead
> to a kernel oops or data corruption when writing to file-backed mappings.
> 
> This is only relevant when the mappings are file-backed and the underlying
> file system requires folio dirty tracking. File systems which do not, such
> as shmem or hugetlb, are not at risk and therefore can be written to
> without issue.
> 
> Unfortunately this limitation of GUP has been present for some time and
> requires future rework of the GUP API in order to provide correct write
> access to such mappings.
> 
> In the meantime, we add a check for the most broken GUP case -
> FOLL_LONGTERM - which really under no circumstances can safely access
> dirty-tracked file mappings.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
> v3:
> - Rebased on latest mm-unstable as of 24th April 2023.
> - Explicitly check whether file system requires folio dirtying. Note that
>   vma_wants_writenotify() could not be used directly as it is very much focused
>   on determining if the PTE r/w should be set (e.g. assuming private mapping
>   does not require it as already set, soft dirty considerations).

Hm. Okay. Have you considered having a common base for your case and
vma_wants_writenotify()? Code duplication doesn't look good.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov
