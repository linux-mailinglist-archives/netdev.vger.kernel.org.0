Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC1837237A
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 01:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhECXRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 19:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhECXRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 19:17:05 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD48C061574;
        Mon,  3 May 2021 16:16:10 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s22so4969626pgk.6;
        Mon, 03 May 2021 16:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FO9uK8mi/NsZ96ileL9gD5mEDQWLWR3N3X3cZ3+PdWc=;
        b=bKPz+fwcAbA6plyVmy28FHmcQAHF1TQAd/R7bKzT3s7L55zD/F82oHqhsklWhaDrhG
         1Jb4+uxA6Q76HLjgcmE1U7gZPZl5CiqxS6uJtZGMJysEwU+SWTefNxtipJY3IpsgqfSF
         +1E9+a9y6ShdtHauVp/XBbIkYgKwFbu1edvocE1+rndJTbxE1LhXxKuUOyWmUnQLJirR
         qC2/IZdeHwWWPhP8yIduY5OvDOLcFU2gH5ABYPUh4Iy9Bo8HwHIkY2+t5ZQpND2C2MV4
         +kVFOqqgWe3G1IOHOIHDc7WZFhBFaC8AggvKoI07KUt+IIzE54pqrN18Odi6fdjZNKzy
         esag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FO9uK8mi/NsZ96ileL9gD5mEDQWLWR3N3X3cZ3+PdWc=;
        b=OLmioGKqvbWSDMyJK+Vm5rfVG7K8qw+mj2iq7wCvG4nLRfAAAUSv0JUOz+k5IkfeIo
         Kr7uKDk1MrwIoGhh8tUstoY3oXm88S4fY+xlQ7ixSChyYyCl77e6bPPbeCCBFxA4mriv
         +wD72hz9+XVIeITGR1B22loSW06X2+tIRHvNMDgbp+ibacSFuhuWBThlovrqr8UdF1k2
         wEsqkbH+pXoz1U7oLSDytq4bVV6MS8QF88kbzY2+rrHdbzA3CbqjQyKMOQrnBBlAEKta
         NGpvUJltLYjEvp/p/zV/6H3sEQMLmsIkFOBk2Gv8kIagnChba0DFecDVzcQ/thBIQmNj
         Br/g==
X-Gm-Message-State: AOAM532hMjDn/4oRY1+wS1NjMMnSeJp2PDrgge/ImRPJJlA/oNk5tXYf
        +dHimmVuuiRs3DCYm2uWxsM=
X-Google-Smtp-Source: ABdhPJxFZH8lfLEcFId1QhdSHwL9ywxx0F2dPZ4ntx3Pc0fpncoNJaTCCOrOsQaLGloxfe7XLV/LQg==
X-Received: by 2002:a17:90b:3551:: with SMTP id lt17mr24257663pjb.92.1620083770046;
        Mon, 03 May 2021 16:16:10 -0700 (PDT)
Received: from localhost ([47.8.22.213])
        by smtp.gmail.com with ESMTPSA id 206sm821938pga.44.2021.05.03.16.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 16:16:09 -0700 (PDT)
Date:   Tue, 4 May 2021 04:41:20 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Shaun Crampton <shaun@tigera.io>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 2/3] libbpf: add low level TC-BPF API
Message-ID: <20210503231120.aqp5476l7jfiy5ws@apollo>
References: <20210428162553.719588-1-memxor@gmail.com>
 <20210428162553.719588-3-memxor@gmail.com>
 <CAEf4BzYhOQu1A-iK_D-gzcxfZj4BfDXoJ5=8zzHL8qO-URfRiA@mail.gmail.com>
 <20210501063246.iqhw5sdvx4iwllng@apollo>
 <CAEf4BzbGsXzT0V49FmqsaoORYpO-S1Y9yfPaR0MyoYFdCg+4wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbGsXzT0V49FmqsaoORYpO-S1Y9yfPaR0MyoYFdCg+4wQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 04:24:05AM IST, Andrii Nakryiko wrote:
> On Fri, Apr 30, 2021 at 11:32 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Sat, May 01, 2021 at 01:05:40AM IST, Andrii Nakryiko wrote:
[...]
> > >
> > > why didn't you put flags into bpf_tc_opts? they are clearly optional
> > > and fit into "opts" paradigm...
> > >
> >
> > I can move this into opts, but during previous discussion it was kept outside
> > opts by Daniel, so I kept that unchanged.
>
> for bpf_tc_attach() I see no reason to keep flags separate. For
> bpf_tc_hook_create()... for extensibility it would need it's own opts
> for hook creation. But if flags is 99% the only thing we'll need, then
> we can always add extra bpf_tc_hook_create_opts() later.
>

I'll put flags in the respective opts struct for both.

The hook creation path was kept generic enough so that this can be extended to
complex qdisc setup in the future than just clsact (even classful qdiscs should
be possible). So it is quite possible for bpf_tc_hook to take more parameters
than just flags by mapping different attach_point to different qdiscs.

Given some parameters are already optional depending on attach_point, it is
probably better to put flags in opts than dropping opts for now.

--
Kartikeya
