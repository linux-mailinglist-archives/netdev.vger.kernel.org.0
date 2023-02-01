Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6796A685C46
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 01:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjBAAkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 19:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjBAAkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 19:40:41 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466024680;
        Tue, 31 Jan 2023 16:40:38 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id m2so11854998plg.4;
        Tue, 31 Jan 2023 16:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J9K+5oAOPyxL7rSO4xVEGjOS5UpsDr4zwZ0Bm08HRWY=;
        b=ntywoHBOK7S7HovRUydt4FQJRVU30VZ/BKbnE66Xj78hjpksGKfUFXiO+ycFETQiUl
         95+iwOkcMGcXFdK51YXFsQG/m/Zf+jMZyXMtFvlen23CTHOGybQ03YIFEKVv2T2sp04k
         j9kWAUDJ9kSQO6jRgGUg9C+SoUpY4YGt/cGAi7AQGnQoTqi9T/OXnvT/GBR+I84sS1us
         MEsI88RQbhLJSKv4jdldkwXuIvmd5bRKRE4ia5mXYkAk/o7OD+6rb7fQno/21h18NWpw
         mK3iQ+ZBPztIhUXkjkMtoIVNqE2hLPAv/twG2dJO9QS1GnyhTRs8lsNkqeZ0u13XwiLS
         6wWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J9K+5oAOPyxL7rSO4xVEGjOS5UpsDr4zwZ0Bm08HRWY=;
        b=ZQe2WvqxIkopzdL/aMUE3oZ/ezh91s6IMwNG/NQgYKPhdMfRHIFoK984T+yWhjvN/d
         j4JI4C6T/fIILrkBp5nm0bXN3O0OOjYLzVzzQNtdIjBx54ePUpORwIVv4yavuMQOOFOD
         jUzBTzuYlUfcB2pRgNNyVxgShNMM7EmwjGTDtIgMiwMDDMc1XGSDVxaTWJKg+7pIV5/4
         D9vmUvRDjzTciCYSCo/QA73/DEb7F49JVpJZexdp8EC3+4lF1Y6Fad6I4bjUMHxi/lI9
         PyT/M+JrjhLwveZXzvBpVZLyBsAIo4YOrpMvRB1F/lSErlreqiuYjdhRFLOP+UoofR7D
         lwcw==
X-Gm-Message-State: AO0yUKUFYFzlAQSyuropi9FBCfyq0fh1mCK9oYZrKlQzhGAa+3+DBDMg
        Zhqwdaa1+IHgJ+UZ7yeGgTo=
X-Google-Smtp-Source: AK7set+YyyuAnxKmx35yCmaaYb4rMrw/0uRLohz7+mBMdcya+2wQFgMA3c55LethFydZSJNLviBIBQ==
X-Received: by 2002:a17:90b:33c6:b0:22c:f9d:81c6 with SMTP id lk6-20020a17090b33c600b0022c0f9d81c6mr125153pjb.20.1675212037645;
        Tue, 31 Jan 2023 16:40:37 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:a530])
        by smtp.gmail.com with ESMTPSA id fh4-20020a17090b034400b0022c01ab2899sm23526pjb.49.2023.01.31.16.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:40:37 -0800 (PST)
Date:   Tue, 31 Jan 2023 16:40:34 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Joanne Koong <joannelkoong@gmail.com>, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com, kernel-team@fb.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
Message-ID: <20230201004034.sea642affpiu7yfm@macbook-pro-6.dhcp.thefacebook.com>
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com>
 <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev>
 <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
 <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbeUfmE-8Y-mm4RtZ4q=9SZ-_M-K-JF=x84o6cboUneSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbeUfmE-8Y-mm4RtZ4q=9SZ-_M-K-JF=x84o6cboUneSQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 04:11:47PM -0800, Andrii Nakryiko wrote:
> >
> > When prog is just parsing the packet it doesn't need to finalize with bpf_dynptr_write.
> > The prog can always write into the pointer followed by if (p == buf) bpf_dynptr_write.
> > No need for rdonly flag, but extra copy is there in case of cloned which
> > could have been avoided with extra rd_only flag.
> 
> Yep, given we are designing bpf_dynptr_slice for performance, extra
> copy on reads is unfortunate. ro/rw flag or have separate
> bpf_dynptr_slice_rw vs bpf_dynptr_slice_ro?

Either flag or two kfuncs sound good to me.

> > Yes and No. bpf_skb_store_bytes is doing pull followed by memcpy,
> > while xdp_store_bytes does scatter gather copy into frags.
> > We should probably add similar copy to skb case to avoid allocations and pull.
> > Then in case of:
> >  if (p == buf) {
> >       bpf_dynptr_write(dp, buf, 16);
> >  }
> >
> > the write will guarantee to succeed for both xdp and skb and the user
> > doesn't need to add error checking for alloc failures in case of skb.
> >
> 
> That seems like a nice guarantee, agreed.

Just grepped through few projects that use skb_store_bytes.
Everywhere it looks like:
if (bpf_skb_store_byte(...))
   return error;

Not a pretty code to read.
I should prioritize bpf_assert() work, so we can assert from inside of
bpf_dynptr_write() eventually and remove all these IFs.

> > > >
> > > > > But I wonder if for simple cases when users are mostly sure that they
> > > > > are going to access only header data directly we can have an option
> > > > > for bpf_dynptr_from_skb() to specify what should be the behavior for
> > > > > bpf_dynptr_slice():
> > > > >
> > > > >   - either return NULL for anything that crosses into frags (no
> > > > > surprising perf penalty, but surprising NULLs);
> > > > >   - do bpf_skb_pull_data() if bpf_dynptr_data() needs to point to data
> > > > > beyond header (potential perf penalty, but on NULLs, if off+len is
> > > > > within packet).
> > > > >
> > > > > And then bpf_dynptr_from_skb() can accept a flag specifying this
> > > > > behavior and store it somewhere in struct bpf_dynptr.
> > > >
> > > > xdp does not have the bpf_skb_pull_data() equivalent, so xdp prog will still
> > > > need the write back handling.
> > > >
> > >
> > > Sure, unfortunately, can't have everything. I'm just thinking how to
> > > make bpf_dynptr_data() generically usable. Think about some common BPF
> > > routine that calculates hash for all bytes pointed to by dynptr,
> > > regardless of underlying dynptr type; it can iterate in small chunks,
> > > get memory slice, if possible, but fallback to generic
> > > bpf_dynptr_read() if doesn't. This will work for skb, xdp, LOCAL,
> > > RINGBUF, any other dynptr type.
> >
> > It looks to me that dynptr on top of skb, xdp, local can work as generic reader,
> > but dynptr as a generic writer doesn't look possible.
> > BPF_F_RECOMPUTE_CSUM and BPF_F_INVALIDATE_HASH are special to skb.
> > There is also bpf_skb_change_proto and crazy complex bpf_skb_adjust_room.
> > I don't think writing into skb vs xdp vs ringbuf are generalizable.
> > The prog needs to do a ton more work to write into skb correctly.
> 
> If that's the case, then yeah, bpf_dynptr_write() can just return
> error for skb/xdp dynptrs?

You mean to error when these skb only flags are present, but dynptr->type == xdp ?
Yep. I don't see another option. My point was that dynptr doesn't quite work as an
abstraction for writing into networking things.
While libraries like: parse_http(&dynptr), compute_hash(&dynptr), find_string(&dynptr)
can indeed be generic and work with raw bytes, skb, xdp as an input,
which I think was on top of your wishlist for dynptr.
