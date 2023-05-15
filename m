Return-Path: <netdev+bounces-2618-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B22702B89
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47DD1281268
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884B8C2C3;
	Mon, 15 May 2023 11:31:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D4AC138;
	Mon, 15 May 2023 11:31:59 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0518138;
	Mon, 15 May 2023 04:31:55 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-965f7bdab6bso2222322866b.3;
        Mon, 15 May 2023 04:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684150314; x=1686742314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vvfV0sEFtRCF/8ZbA1b9yt0/e64L7RJ3L0AI8zLMm9I=;
        b=kPjpVmksuf9oAOejRIjWtY9929N374P+GeBpuGDe9iZWM2wPxC/p7NH6UEF5CISwH4
         jbUJRuyomH2kG/yCIN+G9SheAr2hkP2YMdk0OxcEvVYwkJGttFgvtC7xpQGR6CB3GgKo
         mBkuqwLXnswyAkUiZe3Pb6f9p2sS9PuFyWzDFq68Xo6/Ss+7ngAKnr/qYPzt18rawGCm
         GHur/KAmxb8a/zFus0h5gVJmVgcTT5V16E7PmlkWqFq66Qnr4jGrFF3uKVuyXZJqDOfy
         7MZ0mjag4BxFqnNTV1u51azqbFpO3Pe7MRPdRD7Vr+VDJWy2LDZGy7rNOKFtseSEylK2
         da1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684150314; x=1686742314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vvfV0sEFtRCF/8ZbA1b9yt0/e64L7RJ3L0AI8zLMm9I=;
        b=TIsyANi821eRhJysbtGmFa5LO20worihSRmxLwqJsfOgranq/DqoJ8ilW3dLatb2Bh
         kfltPVnTkuRO78Pp4QPO0ZesXSklwuqD9PR39y/1QmonKWF6sdqgjbzPiTOQFBNKutvu
         by1q1lMGy2lHFiEVXRAMuMUgV7U94DmVPtUD/UL5zMtLRRqZEz0tXAlRuOEk0TNusG6m
         DvJTpT7corv/O/ypOJ32quYpYdATXIfvaedW07mTPiFVQFZnnsOy8pY3FEXW/7TT3wpN
         QPoJ9Gz02c+HIfIj0N9UU++he/Q0LUszMy7fcLTWhzJxMcPy1+zwNBWOKEycErI4JM66
         7S7A==
X-Gm-Message-State: AC+VfDzmu4oZc84054NXLvQlvime83wQuRQNrxZH0uSs16q34ov5SB3R
	dBFnJUOhbJWX2osj5IJLla8=
X-Google-Smtp-Source: ACHHUZ4cvEaBYT8S0j4/i8jS1x5f8hGr+r0ucmaZDxWPOpxxOrBcBp7R6Ds7K5N4DMVSU/SZjBBVtQ==
X-Received: by 2002:a17:906:58c5:b0:966:58ad:d934 with SMTP id e5-20020a17090658c500b0096658add934mr26454295ejs.0.1684150313896;
        Mon, 15 May 2023 04:31:53 -0700 (PDT)
Received: from localhost ([31.94.21.70])
        by smtp.gmail.com with ESMTPSA id hz20-20020a1709072cf400b0094f4d2d81d9sm9303913ejc.94.2023.05.15.04.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 04:31:53 -0700 (PDT)
Date: Mon, 15 May 2023 12:31:51 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bjorn Topel <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	"Kirill A . Shutemov" <kirill@shutemov.name>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v9 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Message-ID: <59c47ed5-a565-4220-823c-a278130092d5@lucifer.local>
References: <cover.1683235180.git.lstoakes@gmail.com>
 <0eb31f6f-a122-4a5b-a959-03ed4dee1f3c@lucifer.local>
 <ZGG/xkIUYK2QMPSv@infradead.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGG/xkIUYK2QMPSv@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 14, 2023 at 10:14:46PM -0700, Christoph Hellwig wrote:
> On Sun, May 14, 2023 at 08:20:04PM +0100, Lorenzo Stoakes wrote:
> > As discussed at LSF/MM, on the flight over I wrote a little repro [0] which
> > reliably triggers the ext4 warning by recreating the scenario described
> > above, using a small userland program and kernel module.
> >
> > This code is not perfect (plane code :) but does seem to do the job
> > adequately, also obviously this should only be run in a VM environment
> > where data loss is acceptable (in my case a small qemu instance).
>
> It would be really awesome if you could wire it up with and submit it
> to xfstests.

Sure am happy to take a look at that! Also happy if David finds it useful in any
way for this unit tests.

The kernel module interface is a bit sketchy (it takes a user address which it
blindly pins for you) so it's not something that should be run in any unsafe
environment but as long as we are ok with that :)

