Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978E46ECC13
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjDXMcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 08:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjDXMcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 08:32:01 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA58C5;
        Mon, 24 Apr 2023 05:31:59 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f195b164c4so18055555e9.1;
        Mon, 24 Apr 2023 05:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682339518; x=1684931518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E+9tG9/EzyZBijt6lC6jWfZSLjYD4vx+59W+aZZkyIo=;
        b=C5V0foNvh3vz2bZmAcmn7rxPK1cb2LCMUj8MB0CyqWHsZ8tSTdIEXUKNViuB+5YuVW
         gPT5utMBxCLPTr+qlEsN3NcwQ4qVcIiTsPQ26yO47rL2gugChaazEsVzahUEh+Xybdfg
         rvx5oY//oi6zrdzS5n5xlQj0KZwFa9DJMB1zySKWAlXGuhE7LNOrth4eXEX3Befp6Hhk
         OfKDPv4jlt/uCh99yFEDJZ5sGYv6DuMYxu7DMURoQFzDXcCWy4y0XtJWRsANviCGso0h
         T7jpblG4VmcnMF2zDDEKYS0w9UswI4ubo/sK+DU3u0FAobS/sTrXO9JM26Kyrbt8LSZ9
         bJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682339518; x=1684931518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+9tG9/EzyZBijt6lC6jWfZSLjYD4vx+59W+aZZkyIo=;
        b=HvxQ3CDmgaxETzscREecdPtU2CQx4WFvLyprGvURlibPNXTYf63df1on4MvvX5XG+z
         xWMTMmdimmyVI7DBdBVmUHpoM2nV6PakzDcUZkVg23GEcYqt9kXJ1CrgIIualISahPog
         W19jvHeC1sIwkUy20M/d23d7czUwBYFMNp5+BzIi4OluzjNS7r0Klu+NRDpf2VQm/Vxl
         IAv/zs5nGsg/Ud5QvuoZuNxg9PbJWCV9geaNR5IdFfX5bgoLy0hmTIZFCQ6vzklk0lYL
         I4vHVIklFoyJB3ZYRZFAwgz/QASuFd2b1RxWMGs1rlORBvEflC6625PbUjOZOIEectAy
         h9/g==
X-Gm-Message-State: AAQBX9cZ1bB0AcQ7+6bR7kiKhW1GxZi4X3+MUcaV4usK3sM4XTATWpYW
        IaJKqtOLBw3/zC66F8VfIrs=
X-Google-Smtp-Source: AKy350aJGl3Ap51xHWyxEtalSo0tkfykfYvDkmohzXzrBI/PGmieCgcfIbaVFxVI6X2fWNblU2x2/A==
X-Received: by 2002:a05:600c:21d7:b0:3f1:7a57:45cd with SMTP id x23-20020a05600c21d700b003f17a5745cdmr7792795wmj.28.1682339518121;
        Mon, 24 Apr 2023 05:31:58 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id j32-20020a05600c1c2000b003f173987ec2sm15478354wms.22.2023.04.24.05.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 05:31:57 -0700 (PDT)
Date:   Mon, 24 Apr 2023 13:31:56 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
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
Message-ID: <3273f5f3-65d9-4366-9424-c688264992f9@lucifer.local>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
 <20230424120247.k7cjmncmov32yv5r@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424120247.k7cjmncmov32yv5r@box.shutemov.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 03:02:47PM +0300, Kirill A. Shutemov wrote:
> On Sat, Apr 22, 2023 at 02:37:05PM +0100, Lorenzo Stoakes wrote:
> > @@ -959,16 +959,46 @@ static int faultin_page(struct vm_area_struct *vma,
> >  	return 0;
> >  }
> >
> > +/*
> > + * Writing to file-backed mappings using GUP is a fundamentally broken operation
> > + * as kernel write access to GUP mappings may not adhere to the semantics
> > + * expected by a file system.
> > + *
> > + * In most instances we disallow this broken behaviour, however there are some
> > + * exceptions to this enforced here.
> > + */
> > +static inline bool can_write_file_mapping(struct vm_area_struct *vma,
> > +					  unsigned long gup_flags)
> > +{
> > +	struct file *file = vma->vm_file;
> > +
> > +	/* If we aren't pinning then no problematic write can occur. */
> > +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> > +		return true;
> > +
> > +	/* Special mappings should pose no problem. */
> > +	if (!file)
> > +		return true;
> > +
> > +	/* Has the caller explicitly indicated this case is acceptable? */
> > +	if (gup_flags & FOLL_ALLOW_BROKEN_FILE_MAPPING)
> > +		return true;
> > +
> > +	/* shmem and hugetlb mappings do not have problematic semantics. */
> > +	return vma_is_shmem(vma) || is_file_hugepages(file);
>
> Can this be generalized to any fs that doesn't have vm_ops->page_mkwrite()?
>

Something more general would be preferable, however I believe there were
concerns broader than write notify, for instance not correctly marking the
folio dirty after writing to it, though arguably the caller should
certainly be ensuring that (and in many cases, do).

Jason will have more of a sense of this I think!

> --
>   Kiryl Shutsemau / Kirill A. Shutemov
