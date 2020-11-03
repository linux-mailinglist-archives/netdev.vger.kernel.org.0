Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725192A4D95
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgKCRzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgKCRzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:55:24 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875D5C0617A6;
        Tue,  3 Nov 2020 09:55:24 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id x13so14247183pgp.7;
        Tue, 03 Nov 2020 09:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UfD3DZODM1Q1zxavmaKnOkFrJJUUgVEN3r6HvS0z8PM=;
        b=WSzueQjTb67p3RAUmPVtNMYtbe9KRxdBSSlIy2vcaAb8/CYv3lyYMX3+q4VxFbTnIB
         iGZkpoaLP7QhUNj0D6CMea2aQO7Adp4hHA81IzZhe2O0tZf5QIGjwBFYcuMWleli7JSN
         wamMk8SKrW6Y+M6DPfQDY22K/bDgiFb7nPhim0YD2dp5YopbT/3mB/zv+/X/W8IhJNEu
         80HhvaPkWZQ7J3jOvgJIuba923Gd0EujFw8hqvgD5IMU5M0FYITPEwk4BLIU2TexyM+F
         RZ6uHk6qzKdQ2Pydrr6AItrXCID+9OfzfVvHqQqgMyVsHrF/ye7xU0CizDRPj7v2IK1X
         2s6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UfD3DZODM1Q1zxavmaKnOkFrJJUUgVEN3r6HvS0z8PM=;
        b=YhBycLzkhmuuQAkrAQPCX9vj7Lz43+yHkZ2loAArv1GO2y6JjlBZORcRBDY3CYwDb1
         jqN3JkY3nTAPyhPzpL4XFvjME4G831baFlB9rCZ0b8n/LHw5zMF6JlNAosNjN6/zcADW
         9TRMkyVeIeEm+DcRpMzXjyRO+YpG5CdSKlZQmXbpE+nSWyHWB0zAR9LBWKkrgrq4/Y4z
         2fK38gf9/ALDNsRFJOhHnKKidJa5/tXIMMwP7doVZELEaj21c7NC3s9/94sjxEQBcW9H
         UXEibpRy4Y9sp+KQD8lvzNrC2cD4DR8b4zxzeosD4p+PwRvEveZGjam+0DMdjJAP9t3u
         4tnw==
X-Gm-Message-State: AOAM531iUsg56OxIH2JDvkIhNHGHGT3ml2+J/XvrkaTL1Ai7oHonnf/z
        0mGs3+vzEsvKSgwc9GmJOfY=
X-Google-Smtp-Source: ABdhPJwqeS2IsGQJlR2dpwxJHevHLWy3/K+zkzSe54oolrpTyMS/No2hq8Nhy+PmlepD9v1Lp+n0Rw==
X-Received: by 2002:a17:90a:d503:: with SMTP id t3mr391414pju.10.1604426123982;
        Tue, 03 Nov 2020 09:55:23 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4055])
        by smtp.gmail.com with ESMTPSA id 8sm4115739pjk.20.2020.11.03.09.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:55:22 -0800 (PST)
Date:   Tue, 3 Nov 2020 09:55:20 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
Message-ID: <20201103175520.spqvqhohtnietnlt@ast-mbp.dhcp.thefacebook.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-9-andrii@kernel.org>
 <20201103051003.i565jv3ph54lw5rj@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZV8oysWVmkF0K=FBFa5x=98duK8c+ixfiCFFP8dzWg2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZV8oysWVmkF0K=FBFa5x=98duK8c+ixfiCFFP8dzWg2w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 10:27:20PM -0800, Andrii Nakryiko wrote:
> On Mon, Nov 2, 2020 at 9:10 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Oct 28, 2020 at 05:58:59PM -0700, Andrii Nakryiko wrote:
> > > @@ -2942,6 +2948,13 @@ struct btf_dedup {
> > >       __u32 *hypot_list;
> > >       size_t hypot_cnt;
> > >       size_t hypot_cap;
> > > +     /* Whether hypothethical mapping, if successful, would need to adjust
> > > +      * already canonicalized types (due to a new forward declaration to
> > > +      * concrete type resolution). In such case, during split BTF dedup
> > > +      * candidate type would still be considered as different, because base
> > > +      * BTF is considered to be immutable.
> > > +      */
> > > +     bool hypot_adjust_canon;
> >
> > why one flag per dedup session is enough?
> 
> So the entire hypot_xxx state is reset before each struct/union type
> graph equivalence check. Then for each struct/union type we might do
> potentially many type graph equivalence checks against each of
> potential canonical (already deduplicated) struct. Let's keep that in
> mind for the answer below.
> 
> > Don't you have a case where some fwd are pointing to base btf and shouldn't
> > be adjusted while some are in split btf and should be?
> > It seems when this flag is set to true it will miss fwd in split btf?
> 
> So keeping the above note in mind, let's think about this case. You
> are saying that some FWDs would have candidates in base BTF, right?
> That means that the canonical type we are checking equivalence against
> has to be in the base BTF. That also means that all the canonical type
> graph types are in the base BTF, right? Because no base BTF type can
> reference types from split BTF. This, subsequently, means that no FWDs
> from split BTF graph could have canonical matching types in split BTF,
> because we are comparing split types against only base BTF types.
> 
> With that, if hypot_adjust_canon is triggered, *entire graph*
> shouldn't be matched. No single type in that (connected) graph should
> be matched to base BTF. We essentially pretend that canonical type
> doesn't even exist for us (modulo the subtle bit of still recording
> base BTF's FWD mapping to a concrete type in split BTF for FWD-to-FWD
> resolution at the very end, we can ignore that here, though, it's an
> ephemeral bookkeeping discarded after dedup).
> 
> In your example you worry about resolving FWD in split BTF to concrete
> type in split BTF. If that's possible (i.e., we have duplicates and
> enough information to infer the FWD-to-STRUCT mapping), then we'll
> have another canonical type to compare against, at which point we'll
> establish FWD-to-STRUCT mapping, like usual, and hypot_adjust_canon
> will stay false (because we'll be staying with split BTF types only).
> 
> But honestly, with graphs it can get so complicated that I wouldn't be
> surprised if I'm still missing something. So far, manually checking
> the resulting BTF showed that generated deduped BTF types look
> correct. Few cases where module BTFs had duplicated types from vmlinux
> I was able to easily find where exactly vmlinux had FWD while modules
> had STRUCT/UNION.
> 
> But also, by being conservative with hypot_adjust_canon, the worst
> case would be slight duplication of types, which is not the end of the
> world. Everything will keep working, no data will be corrupted, libbpf
> will still perform CO-RE relocation correctly (because memory layout
> of duplicated structs will be consistent across all copies, just like
> it was with task_struct until ring_buffers were renamed).

Yes. That last part is comforting. The explanation also makes sense.
Not worried about it anymore.
