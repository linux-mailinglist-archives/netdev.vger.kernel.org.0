Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC395427394
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 00:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243605AbhJHWWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 18:22:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243610AbhJHWWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 18:22:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633731636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nzPIcRF7yHK4+23XSiiWLRtQD40Ph9+L4zPFH3eWNgY=;
        b=Ldbgr1zhNni/oYf32sKdk+TkUf7Qp5iN1kh3ttS4GeTs2AfoJedDt0aweBrvBdKOsI5cgg
        n+diVMR3baXQaLJfICWpR0WFV1wmO2DRE9mDkx1D+qecp8jm0TKF0/aUNwIjnmwfBBd2CW
        boQspZ+Fk/KIeg1uan9wHNqLmOuDtg8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-p6ObDnsjM7ueVhzuenH1qQ-1; Fri, 08 Oct 2021 18:20:31 -0400
X-MC-Unique: p6ObDnsjM7ueVhzuenH1qQ-1
Received: by mail-ed1-f72.google.com with SMTP id l10-20020a056402230a00b003db6977b694so2169345eda.23
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 15:20:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=nzPIcRF7yHK4+23XSiiWLRtQD40Ph9+L4zPFH3eWNgY=;
        b=hDD0sSrujyJCmp+PFtZCahEDwdJdH9evUdWMQVNkn3KD9XOZX5RnbvwBr0PDXqXOGj
         zcgztMhWwQMJ9gNr8dWCh45k3rikoVClI8ytPWfSaWc/+/+LObxmxNt6yiOtAJgohV4Z
         5onMYVUWqLj3wmM3K4+t2Y3InOMZeqXYshV3YxQcsyI6hfza4yYH+6O6Ww9O7K9rTTRQ
         zItkB3jke8bIADnyAZ9aSRKUuXxLpfVEDTLQoi9hoVRueytseocL0OIaUAL+s0phNh4u
         sK93oQmlj06FWa5ROqADn2CpS4hfGEld5aEPRULkcvKVQJXaSEDNrR9Ou7SSJ6wnT57N
         gDDg==
X-Gm-Message-State: AOAM533Wf3UFNnOxCfrFfChEilgCpe3pUMVXz0zY/YMSRzEPoBLRUGZB
        q390VpjNQtubuQJhfqW5NzoTNKATl+Voy0N6TufUhvWtWTEUfcUhzIGXus6/AuelFeAjpNDaI8l
        yXX23MUsT67SRqsZh
X-Received: by 2002:a17:906:454a:: with SMTP id s10mr7487302ejq.11.1633731629736;
        Fri, 08 Oct 2021 15:20:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyfQO3e/0f6CMOIsNdneGCdrMjkzpc5iceLZyD/a2EwPJNVkPJglStyNFlyJS/y0RvsnfCmA==
X-Received: by 2002:a17:906:454a:: with SMTP id s10mr7487178ejq.11.1633731628487;
        Fri, 08 Oct 2021 15:20:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d14sm178705ejd.92.2021.10.08.15.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 15:20:27 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 17D7E180151; Sat,  9 Oct 2021 00:20:27 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Joanne Koong <joannekoong@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Kernel-team@fb.com
Subject: Re: [PATCH bpf-next v2 0/3] Add XDP support for bpf_load_hdr_opt
In-Reply-To: <20211007235203.uksujks57djohg3p@kafai-mbp>
References: <20211006230543.3928580-1-joannekoong@fb.com>
 <87h7dsnbh5.fsf@toke.dk> <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
 <43bfb0fe-5476-c62c-51f2-a83da9fef659@iogearbox.net>
 <20211007235203.uksujks57djohg3p@kafai-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 09 Oct 2021 00:20:27 +0200
Message-ID: <87lf33jh04.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Thu, Oct 07, 2021 at 11:25:29PM +0200, Daniel Borkmann wrote:
>> I tend to agree with Toke here that this is not generic. What has been tried
>> to improve the verifier instead before submitting the series? It would be much
>> more preferable to improve the developer experience with regards to a generic
>> solution, so that other/similar problems can be tackled in one go as well such
>> as IP options, extension headers, etc.
> It would be nice to improve verifier to recognize it more smoothly.  Would
> love to hear idea how to do it.

So as far as I could tell, the verifier blows up in part because when
there's multiple bounded loops in sequence the verifier gets into a
combinatorial explosion of exploring all paths through the first loop
combined with all paths through the second. So if we could teach the
verifier to recognise that each loop is a separate entity to avoid this,
I think looping through headers would be a lot easier.

As you can probably tell, though, there is quite a bit of handwaving in
the above, and I have no idea how to actually do this. Some kind of
invariant analysis, maybe? But is this possible in general?

> When adding the tcp header options for bpf_sockops, a bpf_store_hdr_opt()
> is needed to ensure the header option is sane.  When writing test to parse
> variable length header option, I also pulled in tricks (e.g. "#pragma unroll"
> is easier to get it work.  Tried bounded loop but then hits max insns and
> then moved some cases into subprog...etc).  Most (if not all) TCP headers
> has some options (e.g. tstamp), so it will be useful to have an easy way
> to search a particular option and bpf_load_hdr_opt() was also added to
> bpf_sockops.

So if we can't fix the verifier, maybe we could come up with a more
general helper for packet parsing? Something like:

bpf_for_each_pkt_chunk(ctx, offset, callback_fn, callback_arg)
{
  ptr = ctx->data + offset;
  while (ptr < ctx->data_end) {
    offset = callback_fn(ptr, ctx->data_end, callback_arg);
    if (offset == 0)
      return 0;
    ptr += offset;
  }
  
  // out of bounds before callback was done
  return -EINVAL;
}
   
This would work for parsing any kind of packet header or TLV-style data
without having to teach the kernel about each header type. It'll have
quite a bit of overhead if all the callbacks happen via indirect calls,
but maybe the verifier can inline the calls (or at least turn them into
direct CALL instructions)?

-Toke

