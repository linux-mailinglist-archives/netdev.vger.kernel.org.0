Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0376F4A6E
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjEBThK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 15:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEBThI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 15:37:08 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967661BF9;
        Tue,  2 May 2023 12:37:07 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f18dacd392so26600615e9.0;
        Tue, 02 May 2023 12:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683056226; x=1685648226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yAN6Tx0XQ5cbgXparCHR/XEVN6lZoL4POmuLsxZAKdE=;
        b=k8kErdOPVqPjXe1UVr8CE/r8s1h4neD6cqHotJu9TowY8FOBIbOn+5Ho9ZTcDCagRk
         /XQzmVQnTYSOtm4WXN+YcYgnIVypug7+S+yvYzavsLrJJaDl3qd8/9WwOTa/UoKghyGo
         NUlKZ6xBdsjrqeAlsaefz8tdfEVcA6NFDLZ5vh3zQUugFLoVs+e+0KHh9Lrp3le77uTF
         FVOS0g558WHu+VX3dSGsRy5SrfkcF3tIGvfwKbSTagyG/arJM13RThshZmv2XxHYpwAC
         AP9tdMAwmJwBH5VsPgI5xQ+ODO651sEuQ2Yj/V01JnjkBFUmuaF4qQDQuDmFV7hJ67aX
         LcPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683056226; x=1685648226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yAN6Tx0XQ5cbgXparCHR/XEVN6lZoL4POmuLsxZAKdE=;
        b=BLivDXTsNdfsBxe+oLRmLI5+9Gcc/aLDtZlXrF1StJ3xNWh2EMuevLyOB6fqrjkXTo
         VuMY7F1NKi0e7FFyWUhOOqJTLhbAy+kLCrzqHSXgKLQhgEbD3YD4aFe5QzPw2i6ztQo5
         AIr7HL2K54rEq5yAMLUYRQb/9IGY6JYi2ljACHfvc6JFsJSHNX7DioZPBKAIzX6e4qz8
         SdgQJupiwff8TZj2zgMdBjCyQuVBaiUl6Xx42/0/NP3NC3KHS/N+OcClsI40tNpLaXLM
         go4K4fdK7NlMoRO2/CBUCOQqE8ngLjmR+h8BR5vHQ+8cdptLSyh3G0y1tAwhHw5oIsE0
         CFTA==
X-Gm-Message-State: AC+VfDyn0bfCJ+6gXUD43knKfEgQtc5On0EQADe97MU5rr5IKr75xNPN
        5A3hJU+/QVy+EzW5Rc3numg=
X-Google-Smtp-Source: ACHHUZ7A2jMMtWzk7T9cgrRfNHzt/pitx4iisIgGusHr6EWYS363YI6sIGUZvgHUP7w7dxyOLghViw==
X-Received: by 2002:a1c:7907:0:b0:3f1:8ef0:7e2f with SMTP id l7-20020a1c7907000000b003f18ef07e2fmr12767978wme.25.1683056225811;
        Tue, 02 May 2023 12:37:05 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id t24-20020a1c7718000000b003f3195be0a0sm16618019wmi.31.2023.05.02.12.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 12:37:05 -0700 (PDT)
Date:   Tue, 2 May 2023 20:37:04 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <b1144819-2d03-4e63-b0e7-0fda6130de7d@lucifer.local>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
 <20230502172231.GH1597538@hirez.programming.kicks-ass.net>
 <406fd43a-a051-5fbe-6f66-a43f5e7e7573@redhat.com>
 <3a8c672d-4e6c-4705-9d6c-509d3733eb05@lucifer.local>
 <ZFFfhhwibxHKwDbZ@nvidia.com>
 <968fa174-6720-4adf-9107-c777ee0d8da4@lucifer.local>
 <434c60e6-7ac4-229b-5db0-5175afbcfff5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <434c60e6-7ac4-229b-5db0-5175afbcfff5@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 09:33:45PM +0200, David Hildenbrand wrote:
> On 02.05.23 21:25, Lorenzo Stoakes wrote:
> > On Tue, May 02, 2023 at 04:07:50PM -0300, Jason Gunthorpe wrote:
> > > On Tue, May 02, 2023 at 07:17:14PM +0100, Lorenzo Stoakes wrote:
> > >
> > > > On a specific point - if mapping turns out to be NULL after we confirm
> > > > stable PTE, I'd be inclined to reject and let the slow path take care of
> > > > it, would you agree that that's the correct approach?
> > >
> > > I think in general if GUP fast detects any kind of race it should bail
> > > to the slow path.
> > >
> > > The races it tries to resolve itself should have really safe and
> > > obvious solutions.
> > >
> > > I think this comment is misleading:
> > >
> > > > +	/*
> > > > +	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
> > > > +	 * to disappear from under us, as well as preventing RCU grace periods
> > > > +	 * from making progress (i.e. implying rcu_read_lock()).
> > >
> > > True, but that is not important here since we are not reading page
> > > tables
> > >
> > > > +	 * This means we can rely on the folio remaining stable for all
> > > > +	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > > > +	 * and those that do not.
> > >
> > > Not really clear. We have a valid folio refcount here, that is all.
> >
> > Some of this is a product of mixed signals from different commenters and
> > my being perhaps a little _too_ willing to just go with the flow.
> >
> > With interrupts disabled and IPI blocked, plus the assurances that
> > interrupts being disabled implied the RCU version of page table
> > manipulation is also blocked, my understanding was that remapping in this
> > process to another page could not occur.
> >
> > Of course the folio is 'stable' in the sense we have a refcount on it, but
> > it is unlocked so things can change.
> >
> > I'm guessing the RCU guarantees in the TLB logic are not as solid as IPI,
> > because in the IPI case it seems to me you couldn't even clear the PTE
> > entry before getting to the page table case.
> >
> > Otherwise, I'm a bit uncertain actually as to how we can get to the point
> > where the folio->mapping is being manipulated. Is this why?
>
> I'll just stress again that I think there are cases where we unmap and free
> a page without synchronizing against GUP-fast using an IPI or RCU.

OK that explains why we need to be careful. Don't worry I am going to move the
check after we confirm PTE entry hasn't changed.

>
> That's one of the reasons why we recheck if the PTE changed to back off, so
> I've been told.
>
> I'm happy if someone proves me wrong and a page we just (temporarily) pinned
> cannot have been freed+reused in the meantime.

Let's play it safe for now :)

>
> --
> Thanks,
>
> David / dhildenb
>
