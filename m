Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326986F46E1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbjEBPTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbjEBPTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:19:14 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFF11704;
        Tue,  2 May 2023 08:19:13 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f09b4a1527so41041885e9.0;
        Tue, 02 May 2023 08:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683040752; x=1685632752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EMDcO9JRQp+eGZiLNGZuH9Z/nD7SGrXL+vGe1dHac2k=;
        b=TVnRsHX/cp5Qtg8lp16YUG02NC+ZrJi3caXZ7nPAEPhvOTz7029SyJjN4SdD1ve/Mz
         E2FjKLDfXqedBtpVyH4iFb5Vc6Un6qVQCYpg7kC6HpP4DS5ap6sUvqQc+3vOqTtyexOy
         E0AZBEPb3/daR7pMj8kwx9zzXFy/2JyYkmknjhAETBLzhUSGINMmPk28zqZFJUQkGqeU
         b2lSDb0GDJNz1ruNMmIPcKianju4nA+zTsMbvsg3rpXCiYvCDVBO1qkVZwqa8x1Z+MeY
         bedHMZGV01ddupOGqImeMvtEN0tEkPBNAvC/pG4uxmSQ8ASRSZNba5suyzgqpTS/cF96
         EWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683040752; x=1685632752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMDcO9JRQp+eGZiLNGZuH9Z/nD7SGrXL+vGe1dHac2k=;
        b=NtgVHL2qa3evtjR/ZczCQ8MFBUiHgyEglhFAYE+mgIpQqtqQ/jZocsqzvfnxInMM+6
         LFwpWay9SFnj0h898aa12Q5yx3qSVSavl3iHB33NRQGx/1FC5w2nWZ0uyAfXtKaNmJCZ
         rjX45BWOZC3JYioGiwan8wQKGtUQaF9B7uLtaojXkd0UVeV4+ReqZDrEgbR+Xhd3MNU0
         pjV+eqJcdcIw2zjFJoN/dsUVRqmuXbV8vkidotQ2EZiW8uEnPQe9RBWTV9tbDDh+jFcC
         jxuvU/ma/D0HTEqvtICmGE8HNIvf1HtPVUbwT5EtNM8J1YM+OnLiUeP0tgSu+OOiM8V/
         4LlQ==
X-Gm-Message-State: AC+VfDzGt1d/+3Neq/aQqWrtIISCUultHemIrc7GShRtDBpduxkEazUm
        +mvWtOyuICAuen9WAY/+xXs=
X-Google-Smtp-Source: ACHHUZ7hz/4x5oSKMo0hPlxgSGnmN/QIy7aFzU1N2reK24btMnDSCCKYUee82DSZE/vTzGS2+EiGEQ==
X-Received: by 2002:a1c:ed0e:0:b0:3f1:7372:66d1 with SMTP id l14-20020a1ced0e000000b003f1737266d1mr12372603wmh.0.1683040751465;
        Tue, 02 May 2023 08:19:11 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id o3-20020a05600c378300b003ef5f77901dsm35698904wmr.45.2023.05.02.08.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:19:10 -0700 (PDT)
Date:   Tue, 2 May 2023 16:19:10 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <25b7aa40-fad0-4886-90b2-c5d68d75d28b@lucifer.local>
References: <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <ZFEL20GQdomXGxko@nvidia.com>
 <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
 <ZFER5ROgCUyywvfe@nvidia.com>
 <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
 <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
 <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
 <ZFEVQmFGL3GxZMaf@nvidia.com>
 <1d4c9258-9423-7411-e722-8f6865b18886@linux.ibm.com>
 <1f3231c0-34b2-1e78-0bf0-f32d5b67811d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f3231c0-34b2-1e78-0bf0-f32d5b67811d@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 05:09:06PM +0200, David Hildenbrand wrote:
> On 02.05.23 15:56, Matthew Rosato wrote:
> > On 5/2/23 9:50 AM, Jason Gunthorpe wrote:
> > > On Tue, May 02, 2023 at 03:47:43PM +0200, David Hildenbrand wrote:
> > > > > Eventually we want to implement a mechanism where we can dynamically pin in response to RPCIT.
> > > >
> > > > Okay, so IIRC we'll fail starting the domain early, that's good. And if we
> > > > pin all guest memory (instead of small pieces dynamically), there is little
> > > > existing use for file-backed RAM in such zPCI configurations (because memory
> > > > cannot be reclaimed either way if it's all pinned), so likely there are no
> > > > real existing users.
> > >
> > > Right, this is VFIO, the physical HW can't tolerate not having pinned
> > > memory, so something somewhere is always pinning it.
> >
> > I might have mis-explained above.
> >
> > With iommufd nesting, we will pin everything upfront as a starting point.
> >
> > The current usage of vfio type1 iommu for s390 does not pin the entirety of guest memory upfront, it happens as guest RPCITs occur / type1 mappings are made.
>
> ... so, after the domain started successfully on the libvirt/QEMU side ? :/
>
> It would be great to confirm that. There might be a BUG in patch #2 (see my
> reply to patch #2) that might not allow you to reproduce it right now.
>

Yes apologies - thank you VERY much for doing this Matthew, but apologies, I
made rather a clanger in patch 2 which would mean fast patch degrading to slow
path would pass even for file-backed.

Will respin a v7 + cc you on that, if you could be so kind as to test that?

> --
> Thanks,
>
> David / dhildenb
>
