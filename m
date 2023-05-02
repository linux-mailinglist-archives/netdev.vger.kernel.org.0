Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AA46F4A91
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjEBTp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 15:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjEBTp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 15:45:27 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAFA11B;
        Tue,  2 May 2023 12:45:25 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3062d764455so1899863f8f.3;
        Tue, 02 May 2023 12:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683056724; x=1685648724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WEozocFtC1MF/eLKX6k60Tc4cyy/cZXp+rUuv759qKQ=;
        b=KZxln+oq3LImf+LRQFD0qCtu0AGSzG9KubXRD4Q1Gt470PKWTvPO46MkvYdANnDfot
         WMCQBXBgzJOU5SuTc0nXZDekxwER2q70iXjYkDIft41htRddfCiBrbeyPJhS9KTxbxhm
         Rw1Wh6X34LNKhiCODiYNzteLUt8HJSjqzkU6H9SHuTZDm0yVtMmfXC8bMbsq8LyYtWZT
         TISJEBgqXIO/tUfJtqG4tbXbKetuph1sJqI+cL2fLt3oid5sjpVht6WM6UImaT915aIp
         BiokOY1tlqo1e1QRqTXlcNaiNx3EfCN0++cfyFZLy42mdPJqiMo20waAOZISMRNpvhQ9
         2lXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683056724; x=1685648724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WEozocFtC1MF/eLKX6k60Tc4cyy/cZXp+rUuv759qKQ=;
        b=hvL/7UVvnG7rJPQL9zS7+Ib5CcmImNWe7A9ArnAr99aK11wLSwwUyovGd/kqMwpJ87
         dU83Ac23Z/JD3Q2oeVFfP9dkqRk6oWSqeHViqBrVeKJe3Ki05ngR6Yw1icmUzt1SibCe
         yTnM6TbvLrswlEtpFqb0iboR5IWZ4apgAILZFsnuLxbcG5WuPThgR8542BrEa7AFXCnK
         rcz2qnd3PnqDrqLj8O20GTUY6enuMJjYG5wOs/sA4KM0/a0jIHqe4dtuRwbNHu6mH0Ve
         r4r6ETt5LM8JUnVtJdGb8baLiuKukX+f0eTFtfSxmJ5lQSgj6+8GhlddDzDbBTt/CD7W
         bpsg==
X-Gm-Message-State: AC+VfDyvgbS5niHkIQIZq0MswM4fMzxlNDJdjU+qnLEE/TFVAMwoKeMh
        YCqCRaPxSFvPImA/HUS51aE=
X-Google-Smtp-Source: ACHHUZ7giPh3fJflokbwuOw6F1c/R5MgKKjdAh0Buc08SMS5g5jeGTWiITv4rffr9WhhPRfzUnNUeA==
X-Received: by 2002:a5d:5384:0:b0:2fe:562c:c0dc with SMTP id d4-20020a5d5384000000b002fe562cc0dcmr13408438wrv.40.1683056723727;
        Tue, 02 May 2023 12:45:23 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id bl13-20020adfe24d000000b003062d3daf79sm6288950wrb.107.2023.05.02.12.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 12:45:23 -0700 (PDT)
Date:   Tue, 2 May 2023 20:45:22 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     David Hildenbrand <david@redhat.com>
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <bd75a53d-d461-488c-af8c-b7e483c22e41@lucifer.local>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <505b7df8-bb60-7564-af28-b99875eea12a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505b7df8-bb60-7564-af28-b99875eea12a@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 09:17:53PM +0200, David Hildenbrand wrote:
> > +static bool folio_longterm_write_pin_allowed(struct folio *folio)
> > +{
> > +	struct address_space *mapping;
> > +
> > +	/*
> > +	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
> > +	 * to disappear from under us, as well as preventing RCU grace periods
> > +	 * from making progress (i.e. implying rcu_read_lock()).
> > +	 *
> > +	 * This means we can rely on the folio remaining stable for all
> > +	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > +	 * and those that do not.
> > +	 *
> > +	 * We get the added benefit that given inodes, and thus address_space,
> > +	 * objects are RCU freed, we can rely on the mapping remaining stable
> > +	 * here with no risk of a truncation or similar race.
> > +	 */
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	/*
> > +	 * If no mapping can be found, this implies an anonymous or otherwise
> > +	 * non-file backed folio so in this instance we permit the pin.
> > +	 *
> > +	 * shmem and hugetlb mappings do not require dirty-tracking so we
> > +	 * explicitly whitelist these.
> > +	 *
> > +	 * Other non dirty-tracked folios will be picked up on the slow path.
> > +	 */
> > +	mapping = folio_mapping(folio);
> > +	return !mapping || shmem_mapping(mapping) || folio_test_hugetlb(folio);
> > +}
>
> BTW, try_grab_folio() is also called from follow_hugetlb_page(), which is
> ordinary GUP and has interrupts enabled if I am not wrong.

It does hold the PTL though, so can't fiddle with the entry.

But that does suggest folio_test_hugetlb() should be put _before_ the irq
disabled assertion then :)

>
> --
> Thanks,
>
> David / dhildenb
>
