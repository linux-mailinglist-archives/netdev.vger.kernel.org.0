Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886F46F4747
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbjEBPdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbjEBPdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:33:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBED187
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 08:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683041585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qVyMlYQrCOCJQlbTbssjDOURAbJMXiphryUuhr0Mq9s=;
        b=VRz21z9SNIOImSihvf7sf65+urDKLQji5KmoAj8yvJ4zBqT64qy/71mro2psfwNm+bYcFF
        SJdWMaiE4IbGY71rAU3FhP+A1YlveOOSjKQ8SkIT7TN3QVFY9JhoLbFqZmDaYBuFQS+TKI
        L6w6O0uwsqElpWCZJZqL8pH8kNBB/n8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-bcpFHHpYOXKCjGNfrkEvSQ-1; Tue, 02 May 2023 11:33:03 -0400
X-MC-Unique: bcpFHHpYOXKCjGNfrkEvSQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-61b5f341341so2582446d6.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 08:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683041583; x=1685633583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVyMlYQrCOCJQlbTbssjDOURAbJMXiphryUuhr0Mq9s=;
        b=eXEmE2KuZKQL7ENmiiBMS7wlYqMicVVDZEhPoCoBEDyKzX8pK++yR6HgYDPOA8mjoa
         aWnsHxQ4qZuNdEP8dL3cbyWCRd221JGCzMkc5IyaloeHnFUpTZUmDqx/pMhLDM8Zh5nH
         SKegjG5sq6TNHai/jOeF2yo77cC0QC0+3sWBcOu9tSaeqckv5JKjJC9c6lv105HEkpNG
         9kRrrXzQ7tHjT4aMIqdQvhYQFrQffupGMaRN1wzacxck8loHcygp/NQTuTloFOdA20R4
         r/nSHURy82ge15v6FEcLM84iaVAU8WfTB1qSreA8P9POi92HMl0hrJA4MWH/DCmDRbag
         C3ww==
X-Gm-Message-State: AC+VfDyap//aPCoI+Wayc9AkqGo5f3xOM79XPsggQH8HtXrcF7r31Uya
        jlV6A9Fs6exesbr5uw8HsLN/t5ecM6X8JyunU5iyN9lBJpFXWasQat8cR5y8wmcsjxRpjsRyFJZ
        pt8CJPmcHSkbkahkX
X-Received: by 2002:a05:6214:4102:b0:5ef:55d8:7164 with SMTP id kc2-20020a056214410200b005ef55d87164mr4077987qvb.5.1683041582839;
        Tue, 02 May 2023 08:33:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ccuD8/o8IUQHBuYySeI12ByFV75gf5qFhRsuq92iWZyQjMkHy5mj41RjKZD3b/nlfQUiruw==
X-Received: by 2002:a05:6214:4102:b0:5ef:55d8:7164 with SMTP id kc2-20020a056214410200b005ef55d87164mr4077964qvb.5.1683041582540;
        Tue, 02 May 2023 08:33:02 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id i3-20020a05620a27c300b0074236d3a149sm9758731qkp.92.2023.05.02.08.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:33:00 -0700 (PDT)
Date:   Tue, 2 May 2023 11:32:57 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
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
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <ZFEtKe/XcnC++ACZ@x1n>
References: <ZFER5ROgCUyywvfe@nvidia.com>
 <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
 <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
 <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
 <ZFEVQmFGL3GxZMaf@nvidia.com>
 <1ffbbfb7-6bca-0ab0-1a96-9ca81d5fa373@redhat.com>
 <ZFEYblElll3pWtn5@nvidia.com>
 <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
 <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
 <ZFEqTo+l/S8IkBQm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZFEqTo+l/S8IkBQm@nvidia.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 12:20:46PM -0300, Jason Gunthorpe wrote:
> On Tue, May 02, 2023 at 10:54:35AM -0400, Matthew Rosato wrote:
> > On 5/2/23 10:15 AM, David Hildenbrand wrote:
> > > On 02.05.23 16:04, Jason Gunthorpe wrote:
> > >> On Tue, May 02, 2023 at 03:57:30PM +0200, David Hildenbrand wrote:
> > >>> On 02.05.23 15:50, Jason Gunthorpe wrote:
> > >>>> On Tue, May 02, 2023 at 03:47:43PM +0200, David Hildenbrand wrote:
> > >>>>>> Eventually we want to implement a mechanism where we can dynamically pin in response to RPCIT.
> > >>>>>
> > >>>>> Okay, so IIRC we'll fail starting the domain early, that's good. And if we
> > >>>>> pin all guest memory (instead of small pieces dynamically), there is little
> > >>>>> existing use for file-backed RAM in such zPCI configurations (because memory
> > >>>>> cannot be reclaimed either way if it's all pinned), so likely there are no
> > >>>>> real existing users.
> > >>>>
> > >>>> Right, this is VFIO, the physical HW can't tolerate not having pinned
> > >>>> memory, so something somewhere is always pinning it.
> > >>>>
> > >>>> Which, again, makes it weird/wrong that this KVM code is pinning it
> > >>>> again :\
> > >>>
> > >>> IIUC, that pinning is not for ordinary IOMMU / KVM memory access. It's for
> > >>> passthrough of (adapter) interrupts.
> > >>>
> > >>> I have to speculate, but I guess for hardware to forward interrupts to the
> > >>> VM, it has to pin the special guest memory page that will receive the
> > >>> indications, to then configure (interrupt) hardware to target the interrupt
> > >>> indications to that special guest page (using a host physical address).
> > >>
> > >> Either the emulated access is "CPU" based happening through the KVM
> > >> page table so it should use mmu_notifier locking.
> > >>
> > >> Or it is "DMA" and should go through an IOVA through iommufd pinning
> > >> and locking.
> > >>
> > >> There is no other ground, nothing in KVM should be inventing its own
> > >> access methodology.
> > > 
> > > I might be wrong, but this seems to be a bit different.
> > >
> > > It cannot tolerate page faults (needs a host physical address), so
> > > memory notifiers don't really apply. (as a side note, KVM on s390x
> > > does not use mmu notifiers as we know them)
> >
> > The host physical address is one shared between underlying firmware
> > and the host kvm.  Either might make changes to the referenced page
> > and then issue an alert to the guest via a mechanism called GISA,
> > giving impetus to the guest to look at that page and process the
> > event.  As you say, firmware can't tolerate the page being
> > unavailable; it's expecting that once we feed it that location it's
> > always available until we remove it (kvm_s390_pci_aif_disable).
> 
> That is a CPU access delegated to the FW without any locking scheme to
> make it safe with KVM :\
> 
> It would have been better if FW could inject it through the kvm page
> tables so it has some coherency.
> 
> Otherwise you have to call this "DMA", I think.
> 
> How does s390 avoid mmu notifiers without having lots of problems?? It
> is not really optional to hook the invalidations if you need to build
> a shadow page table..

Totally no idea on s390 details, but.. per my read above, if the firmware
needs to make sure the page is always available (so no way to fault it in
on demand), which means a longterm pinning seems appropriate here.

Then if pinned a must, there's no need for mmu notifiers (as the page will
simply not be invalidated anyway)?

Thanks,

-- 
Peter Xu

