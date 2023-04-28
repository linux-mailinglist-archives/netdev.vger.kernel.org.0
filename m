Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3D56F1D91
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346478AbjD1Rmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346460AbjD1Rms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:42:48 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99ABD7;
        Fri, 28 Apr 2023 10:42:44 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2fa36231b1cso261f8f.2;
        Fri, 28 Apr 2023 10:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682703763; x=1685295763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a7uMAN4inFdAmgs2662MiDQxbIMz/NYQ0viDeHuh/7A=;
        b=CMnGzA5IvVawATNWyQUiLXjSQMbc3k7Ou4ptro6AT4w0gpDvp1RmBl95mjRKX0I7HZ
         GQuHVAYZIS8xU01Dbwql57be47Lm+Y4Jlup4Ve2oF+73ZXWawVQ7NH20BEgB470z/qdp
         0BxzsNAI8mCD6pIs3KzIhhcJOwpd2YHCRZZL7NeGa0Z2edavcVma1h88s8pXS1pEiSks
         aJm6gFRmEf4Lh7wgXg9YS8d5CdMoYQ5oEZHk5e2WCinTzMDA2Qr/ofzC/Hmq0xA193tt
         KgSxzTmCLCR3TBV1T/DUBTAl19W7yTfK6oRmsuSBMF2xeWc6wjtdXm47alSRv+X1sVsr
         EKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682703763; x=1685295763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7uMAN4inFdAmgs2662MiDQxbIMz/NYQ0viDeHuh/7A=;
        b=iDiXiiagBdwPmIwVfyQgVG8OMgqeBLXV2Ed8UHF5LmLF7lJmXO6t0r3T84SpqIbe+z
         XOJvtCP7+ymVAMAcFVbC7QUPraG4fcqyjxXDPBDdTDplenXRbfvibVEusX4NIrEU6CDc
         T25xxpZQvNBHBF+VFn8eapfbpHNIvXfzfycqFWQQaqSfuuwSW2JmLetlni+q33FjeOaj
         FNIp/hRdf1LQNZfK1wQfNaR1AvVmH8X+IBQ8Dg/DqRmh31nd/Cx3ASLUJItTMkmX0SrP
         wU04NXcgHxndtssyLU3m/HNV550t7dMMHzQ5sVQw69AJL3UotFNssjbGNRwYQ4u6yPCk
         bASg==
X-Gm-Message-State: AC+VfDz9cJ7UPqSFpVTZyKzHEftayNleVQ5Rbgdb5az6VBzY7DvslFs6
        C38asSjYhdRkUHJYvD06nVo=
X-Google-Smtp-Source: ACHHUZ489c8i55WQeazaUSoDba4YXhLZWyaFW7PUQj7k71PVXJgOr7z/SgZw+VBCsKqNxaLBezbriw==
X-Received: by 2002:a5d:4651:0:b0:2f9:9763:1357 with SMTP id j17-20020a5d4651000000b002f997631357mr4210267wrs.8.1682703763194;
        Fri, 28 Apr 2023 10:42:43 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id v15-20020a05600c444f00b003f09cda253esm28758504wmn.34.2023.04.28.10.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 10:42:42 -0700 (PDT)
Date:   Fri, 28 Apr 2023 18:42:41 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Hildenbrand <david@redhat.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
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
Message-ID: <34bc4f3c-8dfe-46ec-9f9b-358cdf4c37e3@lucifer.local>
References: <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
 <ZEv2196tk5yWvgW5@x1n>
 <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
 <20230428165623.pqchgi5gtfhxd5b5@box.shutemov.name>
 <1039c830-acec-d99b-b315-c2a6e26c34ca@redhat.com>
 <ZEwC+viAMJ0vEpgU@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEwC+viAMJ0vEpgU@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 02:31:38PM -0300, Jason Gunthorpe wrote:
> On Fri, Apr 28, 2023 at 07:02:22PM +0200, David Hildenbrand wrote:
>
> > > No. VMA cannot get away before PTEs are unmapped and TLB is flushed. And
> > > TLB flushing is serialized against GUP_fast().
> >
> > The whole CONFIG_MMU_GATHER_RCU_TABLE_FREE handling makes the situation more
> > complicated.
>
> Yeah, you have to think of gup_fast as RCU with a hacky pre-RCU implementation
> on most architectures.
>
> We could make page->mapping safe under RCU, for instance.
>
> Jason

Does it really require a change though? I might be missing some details,
but afaict with interrupts disabled we should be ok to deref page->mapping
to check PageAnon and a_ops before handing back a page right?
