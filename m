Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57096F49F1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjEBSxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjEBSxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:53:34 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7D6E78;
        Tue,  2 May 2023 11:53:33 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f178da21b5so27542825e9.3;
        Tue, 02 May 2023 11:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683053612; x=1685645612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TKK6aVpjuVU0zocvvzx2NbMr8G38Leo7ZXygkcERGR4=;
        b=jT2Ze1BFSPANcjCx4YcSDsjU1FiI4f5SmDTIL5/oTgcpjUvLjtzuLvRH05Bo5BUlYA
         qVEKklhBVPjmFaFDEMRVR+ue7Gtso382k3buRqEG6lWw87eXFHlSWfUFyjMyUW9R0MWH
         4xmD3hAU3EhxU5P6CIAoSu9SCbn+dxxiD6eq3TCe1ufBZhHEzauGYyXQJqZLvo6j6W80
         ls4t0c6POelCUOF3mcMCzYXkWAf0cF1oKxZ5TO203hnDDNYN1Lcnqs4OdSnV5pG1yVks
         k+tMkFqvqzWwkX0nAqGkIZEQZ1fkoGmZi8S9B0ZmI1rfitvHnxspT7dy6bGjbUYqceuN
         GCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683053612; x=1685645612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TKK6aVpjuVU0zocvvzx2NbMr8G38Leo7ZXygkcERGR4=;
        b=hLXjBniekhV5CFSmcgrX3kpfmkTbdSekZ8RPLv7GyrhavZ437ifPmNI6tj6+Hkpcug
         EJQFh4FiatIi9Bb+BhSe6AEF1JM/RA0XF3YoQwtYBOgm3uFa19lWAO40Z33wKl+7McJd
         nPIaH8FBjRcgu2/3NmLRJ1t/siGzCGFcE096WEmbg2/pg4JVAokCSTD1CDpiz/tDoMEi
         5qwBMlg5gLKK+7aZzepvOCpHLKE9rR5oCYztoJYL1XmBhtET5LhbAl1x7Gesti7nU1zI
         59mZ9WjXO0/Tsz9nc0/7m25WOT2AMZFpqAYTAxKrav9rHyKAnjOLHtO54hZNX/0Qj19p
         pQuQ==
X-Gm-Message-State: AC+VfDy+9UQRxAj5pfOJNuXuo329B5oz2/+rh1UuM6LYt0wMcSgmq9h3
        XvJnTl0JN+1FSW/LPy42qzI=
X-Google-Smtp-Source: ACHHUZ7qBkKeVcJYF3HVFy70TfXWnSC+pmhIvAlKW7Ydykfbneuk4r/VXOqXv1LhyTw5KsdoKuYxAg==
X-Received: by 2002:a05:6000:124b:b0:306:31b7:abe4 with SMTP id j11-20020a056000124b00b0030631b7abe4mr4532656wrx.14.1683053611747;
        Tue, 02 May 2023 11:53:31 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id b5-20020a056000054500b002e5ff05765esm32028462wrf.73.2023.05.02.11.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 11:53:31 -0700 (PDT)
Date:   Tue, 2 May 2023 19:53:30 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
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
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v7 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Message-ID: <92fd5d71-ef9b-4971-944a-2a7bd74b5970@lucifer.local>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <ce86e956-173f-848a-a1f3-f102134ccd94@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce86e956-173f-848a-a1f3-f102134ccd94@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 02:45:01PM -0400, Matthew Rosato wrote:
> On 5/2/23 12:34 PM, Lorenzo Stoakes wrote:
> > Writing to file-backed mappings which require folio dirty tracking using
> > GUP is a fundamentally broken operation, as kernel write access to GUP
> > mappings do not adhere to the semantics expected by a file system.
> >
> > A GUP caller uses the direct mapping to access the folio, which does not
> > cause write notify to trigger, nor does it enforce that the caller marks
> > the folio dirty.
> >
> > The problem arises when, after an initial write to the folio, writeback
> > results in the folio being cleaned and then the caller, via the GUP
> > interface, writes to the folio again.
> >
> > As a result of the use of this secondary, direct, mapping to the folio no
> > write notify will occur, and if the caller does mark the folio dirty, this
> > will be done so unexpectedly.
> >
> > For example, consider the following scenario:-
> >
> > 1. A folio is written to via GUP which write-faults the memory, notifying
> >    the file system and dirtying the folio.
> > 2. Later, writeback is triggered, resulting in the folio being cleaned and
> >    the PTE being marked read-only.
> > 3. The GUP caller writes to the folio, as it is mapped read/write via the
> >    direct mapping.
> > 4. The GUP caller, now done with the page, unpins it and sets it dirty
> >    (though it does not have to).
> >
> > This change updates both the PUP FOLL_LONGTERM slow and fast APIs. As
> > pin_user_pages_fast_only() does not exist, we can rely on a slightly
> > imperfect whitelisting in the PUP-fast case and fall back to the slow case
> > should this fail.
> >
> > v7:
> > - Fixed very silly bug in writeable_file_mapping_allowed() inverting the
> >   logic.
> > - Removed unnecessary RCU lock code and replaced with adaptation of Peter's
> >   idea.
> > - Removed unnecessary open-coded folio_test_anon() in
> >   folio_longterm_write_pin_allowed() and restructured to generally permit
> >   NULL folio_mapping().
> >
>
> FWIW, I realize you are planning another respin, but I went and tried this version out on s390 -- Now when using a memory backend file and vfio-pci on s390 I see vfio_pin_pages_remote failing consistently.  However, the pin_user_pages_fast(FOLL_WRITE | FOLL_LONGTERM) in kvm_s390_pci_aif_enable will still return positive.
>

Hey thanks very much for checking that :)

This version will unconditionally apply the retriction to non-FOLL_LONGTERM
by mistake (ugh) but vfio_pin_pages_remote() does seem to be setting
FOLL_LONGTERM anyway so this seems a legitimate test.

Interesting the _fast() variant succeeds...

David, Jason et al. can speak more to the ins and outs of these
virtualisation cases which I am not so familiar with, but I wonder if we do
need a flag to provide an exception for VFIO.
