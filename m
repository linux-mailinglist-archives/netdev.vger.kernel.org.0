Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5A46F2F25
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 09:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjEAH10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 03:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjEAH1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 03:27:24 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFCB127
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 00:27:22 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64115eef620so25138851b3a.1
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 00:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682926042; x=1685518042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ibXuk7FbYrowdFzsiIEHtgPKzlyAO+Sfsye0fqZ102E=;
        b=IKlhLUer77vP+NjL6egKLZ4SBjsZvxj/D3clB+asMNMvxbEKZVyD67jL8L+HgQcTZP
         bx2+VCvjy6HeCWRCAKSjdVeCtOUPiNZOnarnxDf2Ay6KT0thLI2fnISAw3lEGAFT3jl2
         kDsM3kvKxVx4yCWkUsfVNm1hwj4coNk2oyMCtjatrEV3EX4+4UoJMiPf3zbEvc9Jjg1m
         0bcMJvDlbUEMRKu34+4Ed5M78tX9h6w4sQUUsnBU8Gli1HsSt1NKbMvyBp/4K2SrmTSi
         DEZoHLZVnAjL+yBP9KaRc6NDRzIuI950QrEuS8Jegk9aH6BmTEHBRYboZ8q0GghNqhi2
         OyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682926042; x=1685518042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibXuk7FbYrowdFzsiIEHtgPKzlyAO+Sfsye0fqZ102E=;
        b=HtOwufvqT0JTzCa6NGz682AHIofJBrjMMRhPwArC5g4mFdtpSirvaVmw2xXU7Mn7R1
         gSQk9m2x49opTzYuP4B1kQPytEjl8I21ef3PIIXOohDGpIIY1TD4kmy2w2qNt1d7xHCE
         3tgaHDavtpsJuW828LdbAB+/CcSsTMy557nlCQyPDkSA6OhJ19lPO5E+2L14WpLPa/TJ
         FQdPdfTKU3N/APOKV24XF5pcMZ+YVkrVEvcor/WGoet5asT7T4m3bm8TufxWcfjkxWcS
         HhG71ASqJMhsgE1CKhrotUyGHAj5rSq9pBlVjMIqiU6POdhqQCw+pWhGF/1/kVd0QMxn
         cWTg==
X-Gm-Message-State: AC+VfDxiG7/PfbkSymDlNcB4bcnwtStIFJx0mLkpUgr/A/n5fLD0vyr8
        ww2DVRKGyHvRDAq2GZyClVbEmQ==
X-Google-Smtp-Source: ACHHUZ4UvG80mxUfpvf1acfCnS2H3KC6jDEcSFVNzFYuXXy+v/xi65gkE5IdZ0bX/96Zq1X5x+FUpg==
X-Received: by 2002:a05:6a00:a16:b0:63d:3c39:ecc2 with SMTP id p22-20020a056a000a1600b0063d3c39ecc2mr17292848pfh.12.1682926041931;
        Mon, 01 May 2023 00:27:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id t40-20020a056a0013a800b0063d29df1589sm19371079pfg.136.2023.05.01.00.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 00:27:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ptNwM-009yXy-1S; Mon, 01 May 2023 17:27:18 +1000
Date:   Mon, 1 May 2023 17:27:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <20230501072718.GF2155823@dread.disaster.area>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <ZEwPscQu68kx32zF@mit.edu>
 <ZEwVbPM2OPSeY21R@nvidia.com>
 <ZEybNZ7Rev+XM4GU@mit.edu>
 <ZE2ht9AGx321j0+s@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZE2ht9AGx321j0+s@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 29, 2023 at 08:01:11PM -0300, Jason Gunthorpe wrote:
> On Sat, Apr 29, 2023 at 12:21:09AM -0400, Theodore Ts'o wrote:
> 
> > In any case, the file system maintainers' position (mine and I doubt
> > Dave Chinner's position has changed) is that if you write to
> > file-backed mappings via GUP/RDMA/process_vm_writev, and it causes
> > silent data corruption, you get to keep both pieces, and don't go
> > looking for us for anything other than sympathy...
> 
> This alone is enough reason to block it. I'm tired of this round and
> round and I think we should just say enough, the mm will work to
> enforce this view point. Files can only be written through PTEs.

It has to be at least 5 years ago now that we were told that the
next-gen RDMA hardware would be able to trigger hardware page faults
when remote systems dirtied local pages.  This would enable
->page-mkwrite to be run on file backed pages mapped pages just like
local CPU write faults and everything would be fine.

Whatever happened to that? Are we still waiting for hardware that
can trigger page faults from remote DMA transfers, or have hardware
vendors given up on this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
