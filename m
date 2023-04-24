Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE4A6ED408
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 20:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjDXSAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 14:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbjDXSAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 14:00:10 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6619476B3
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 11:00:08 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3ef2452967fso42334091cf.3
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 11:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1682359207; x=1684951207;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LlRkGSdEXncwM0PBf9n/N1FPqEniuAvpiADhOOV7oaU=;
        b=Nc/htkEIM7gLjkyElNiu0ClSDaT8ixeMNVYverT4Tm8Q9Q9OmUiTTzNCWfTYN3JY4i
         V+5bdaILYV6CWcO+gcFbABYnFng3LljWEKwwI+QzYlCIhXwg6DldQAkO93ckNzLB1ndd
         txWe/8B/8qNJZHYbklf5BIvpG55Gm2ZBYc25jV33zJYpdshOJSHN3VEJQXFOxXfVcgd9
         M8Ctfeoo5HB1UvFSdoWFVz4TMkfR+Xyw/8uaFHMdlWD+U2QfZld7gZQRo4owmGeVDOXF
         HSieHPxrfK5TlCfDK6e46UiFFsvGPA8bod8EDk6cBA9CxCj0fQUqfun/MS+9n7fGuFn3
         /Fyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682359207; x=1684951207;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LlRkGSdEXncwM0PBf9n/N1FPqEniuAvpiADhOOV7oaU=;
        b=Rn3kcpNPbaVHIPPL91k4Q13KyMNjFPGms2M27aHOg+VU7idxB0fxeR/xSFc1a/fEg9
         X0cJNVYzfb0Ruy2obOtOB2gLUOTKs2EQ6VSF0ELJy6Gk0F2zSIymbfI7S10F/kazX62x
         hz24XyUUjp+9TW85gQ5c6m/AqLdHUYjz60HmYW6rTvZtmR8zrIr5vShmm//sas34VVHn
         SPsbMevzO2qJag+rUIW79eJUaLE2qMhQSm2yCqQHaNB7m2236SaqcbrWrQGG4NBv9zIQ
         tJN9n+qh5igghXxUOK5W6pa42KGaSU6ejvLz31IF4/3mcpwt0cI1mQHBKwn2Jaum0SWb
         RsKg==
X-Gm-Message-State: AAQBX9de0RVgZxXhUl+ImW0N56oq3PUDGznhJI0/jPfMTN6uNwJD1nXX
        r531hyljqAeIBhxLDYL/Fk/vzA==
X-Google-Smtp-Source: AKy350bpnv/TpaRXAb+ndcpC76lPNYkO86R3kHlzwtU+DD/DIjuKQqPWiuJnS63KYsdheQg9wYpiLQ==
X-Received: by 2002:ac8:5cc8:0:b0:3ef:4da0:a1fc with SMTP id s8-20020ac85cc8000000b003ef4da0a1fcmr24514049qta.50.1682359207561;
        Mon, 24 Apr 2023 11:00:07 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id u28-20020a05622a199c00b003c034837d8fsm3812578qtc.33.2023.04.24.11.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 11:00:07 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pr0Tn-001VxD-Q2;
        Mon, 24 Apr 2023 14:59:59 -0300
Date:   Mon, 24 Apr 2023 14:59:59 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Message-ID: <ZEbDn8fVRvm5XeEl@ziepe.ca>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
 <20230424120247.k7cjmncmov32yv5r@box.shutemov.name>
 <3273f5f3-65d9-4366-9424-c688264992f9@lucifer.local>
 <20230424134026.di6nf2an3a2g63a6@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424134026.di6nf2an3a2g63a6@box.shutemov.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 04:40:26PM +0300, Kirill A. Shutemov wrote:
> > Something more general would be preferable, however I believe there were
> > concerns broader than write notify, for instance not correctly marking the
> > folio dirty after writing to it, though arguably the caller should
> > certainly be ensuring that (and in many cases, do).
> 
> It doesn't make much sense to me.
> 
> Shared writable mapping without page_mkwrite (or pfn_write) will setup
> writeable PTE even on read faults[1], so you will not get the page dirty,
> unless you scan page table entries for dirty bit.

The general statement for supporting GUP is that the VMA owner never
relies on write protect, either explicitly through removing the write
bit in the PTE or implicitly through zapping the inode and removing
all PTEs.

The general bug we have is that the FS does some action to prevent
writes and then becomes surprised that the page was made dirty.

GUP allows write access to the page to continue past any write protect
action the FS takes.

AFAIK all GUP users do correctly do mkdirty and we have helpers to
support this during unpin, that is not the bug.

So, I don't know about page_mkwrite, if it correlates with the abvoe
then great :)

Jason
