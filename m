Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4EE6ECBBE
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 14:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjDXMC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 08:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjDXMCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 08:02:55 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F50CE65;
        Mon, 24 Apr 2023 05:02:54 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BEBF35C01A8;
        Mon, 24 Apr 2023 08:02:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 24 Apr 2023 08:02:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1682337771; x=
        1682424171; bh=CRvO6aIzOksETinFwGWymGxM2N+ncqpqbziqE4P90jE=; b=K
        s8mDDYXrnRqjqrU5BW4+OV7zVGUbFLVjLriun4tmAFCJELjr4REGLRVSHgHjhkjh
        Xep4y/SqEidGausW58qWVR8jV0yGSvhN/Pkl61At06FSgniI8CibRUvR+YD1b+dh
        noEgKtRqS7jqcbClfTrEG7qKpk/BLsPKrBL/8wNaYeGng0lPT93tpRlmm5nMvkRO
        wi4gcS9PXeZGCx7SXYH1LjxMAn79yIinR33/dmBUHCf0uiBgYFB0tfc2MxYSEOY2
        7f2skw3npSzI0p7FU8AxwJFFqhgj6O9HvOrMi402nmPpIQ/Mrbm5HNknsJC0uGXy
        pf9CcxKfMg0SPZ/y5z/Gw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682337771; x=1682424171; bh=CRvO6aIzOksET
        inFwGWymGxM2N+ncqpqbziqE4P90jE=; b=fExb4HuszmPiaoxHgs+cKxDIwLQU+
        eEdwK2PqGEzrWcrFhpexicu42iT/FXcS1JopTEEOIjoC+XdgRDkrxeInk89/akXe
        PgZ1PUW+MjIVtohFqSGh+/6W/f9JBBeF1B0vOX/z/0GNNKp8ybiJa/cvEWXD5Bh6
        uqco/RnE0UyicwnzNTOr80Z6fKImcXU7a35zhWmi2s3LmSL0L9C9dklH/TShrowR
        VrxsvxS7B30zdia8qb5kzgQhhFD0DSYAr4joSMPH4te8KQoir0o/UxY4XNrXUS+r
        YHmdaKH+NHa3fUXEZ/GmZqCCZxTQUgUj2/cyvklGRoPFG59SjlT1zPIIA==
X-ME-Sender: <xms:6m9GZANNYr6TGHymmAD1-8ch6CPDymdpqrqJCHFrWSvrXbg0y9_PAA>
    <xme:6m9GZG-YxUHkJl6fztunDYkp2nnOQJAM7lEvUe-hY_Yw7_1-wOLbr63PYJNA00LF5
    HQyk1__Q98Gxh__uCY>
X-ME-Received: <xmr:6m9GZHT5yUcDaIuEjNwYi078xTrEsa0hHkih8eBHuRE4wyAXL-_SQD3kdB35IUUhS_bu2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedutddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdttddttddtvdenucfhrhhomhepfdfmihhr
    ihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlsehshhhuthgvmhhovhdrnh
    grmhgvqeenucggtffrrghtthgvrhhnpefhieeghfdtfeehtdeftdehgfehuddtvdeuheet
    tddtheejueekjeegueeivdektdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvg
X-ME-Proxy: <xmx:6m9GZIva8NohubvE-CE0B9aBb6EAGLY58ZvjYHuVRLj-oFgK1r9VUA>
    <xmx:6m9GZIezTduoYrFkQgeKd--0ZG2lvutgkn4yvHHLo4oWPRIxucHJpg>
    <xmx:6m9GZM1Wu0LH7Uws3qx8n4fbr0wRPFxLbnj7kTuKLgmA7gzKUDZp2w>
    <xmx:629GZADcnXNbrlZmost-ak_0YFJdISlmSeeG4Rh7NaAM9e0Zo7Vnzg>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Apr 2023 08:02:49 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 1FE9F10A0FA; Mon, 24 Apr 2023 15:02:47 +0300 (+03)
Date:   Mon, 24 Apr 2023 15:02:47 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Message-ID: <20230424120247.k7cjmncmov32yv5r@box.shutemov.name>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 02:37:05PM +0100, Lorenzo Stoakes wrote:
> @@ -959,16 +959,46 @@ static int faultin_page(struct vm_area_struct *vma,
>  	return 0;
>  }
>  
> +/*
> + * Writing to file-backed mappings using GUP is a fundamentally broken operation
> + * as kernel write access to GUP mappings may not adhere to the semantics
> + * expected by a file system.
> + *
> + * In most instances we disallow this broken behaviour, however there are some
> + * exceptions to this enforced here.
> + */
> +static inline bool can_write_file_mapping(struct vm_area_struct *vma,
> +					  unsigned long gup_flags)
> +{
> +	struct file *file = vma->vm_file;
> +
> +	/* If we aren't pinning then no problematic write can occur. */
> +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> +		return true;
> +
> +	/* Special mappings should pose no problem. */
> +	if (!file)
> +		return true;
> +
> +	/* Has the caller explicitly indicated this case is acceptable? */
> +	if (gup_flags & FOLL_ALLOW_BROKEN_FILE_MAPPING)
> +		return true;
> +
> +	/* shmem and hugetlb mappings do not have problematic semantics. */
> +	return vma_is_shmem(vma) || is_file_hugepages(file);

Can this be generalized to any fs that doesn't have vm_ops->page_mkwrite()?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
