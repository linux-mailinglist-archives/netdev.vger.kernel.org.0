Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D57DC7B5
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410454AbfJROtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:49:24 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43075 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbfJROtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:49:24 -0400
Received: by mail-io1-f67.google.com with SMTP id v2so7726814iob.10;
        Fri, 18 Oct 2019 07:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=FEppI0h+E7E6OfAxqCsyFwD0NTotM0BhHygP43OvOMU=;
        b=MJPTk2oc9EjoTbLUqBdXU7K/C8FWsa+Re8x7rTxcLjzWwcvfXFb+kslEbnPwDp3zsv
         LQ+aPxrTw18m/b9+tPpJ2M1CZvlVlUsGIXa5w4WscF3OghK+DPlipzJWFvGe6qUwY/Mj
         3cCK/VLM/AEs6pvsEBelrbM/DzfK2dUyNe09DNAMnxhjP5qwWcg7JWb8FtfvLwjd3XCX
         EzZXsWaJ5qVU/ZZmFN4M0kFMNndiAOBHJCeRZf/iBqh+8gibes6yjLfPayVlUQSh31kj
         Rs+73dw8S1qaHgS7T3rq8qs27komUi8E1qjGJz/wG9oQGhu5lCuVhv0PEMHeoqguMffd
         NLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=FEppI0h+E7E6OfAxqCsyFwD0NTotM0BhHygP43OvOMU=;
        b=pMlZyAEaKAlCJGKnTXo8MICmcydPRDJwQnvYXMVvVnKK/vQR1o0wMFEG+QL7Fun4Ve
         My6MM4NIIlisYQGiE4bRX9Nt5J2jY+Y7CDGgwS+ep+X3qbSzC7hysXXDR/XdZpzAFzUN
         uq5P4F85GitCRZEoWXAdDKMTLO/qGQGcj0nJ1fmC5KbMYRwiuXXYWrfapXYaQbcGrcRi
         IVddW1DEUz11KAGyNTZD7gyMNI7JiMfXZXV7dJ/cgmEuZqEux4rJZctDzcg0ATGGrRZ7
         xP6A1B1/GtnJ3Nd5nYx1E1k4R2ZE32NGxNzEvr4txXcMU/3gu7avT1hjHnM0EYQxP8eI
         WfEg==
X-Gm-Message-State: APjAAAU35qdTmwFl2ukfk9ZGyUdRdcDJl3Vn63Z77oECWtWlbZ7yGRKx
        7ykPY4zhU4LwDhHtGP5AvhY=
X-Google-Smtp-Source: APXvYqyJK9fmV19uGRZHGacg0FM1BcvxjzCXWx29SXt4iZXpAoKd7Vr9Cj3PUolnn7ejNlC2Mym9Kw==
X-Received: by 2002:a5d:8a16:: with SMTP id w22mr5003254iod.254.1571410162395;
        Fri, 18 Oct 2019 07:49:22 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f8sm1847163ioo.27.2019.10.18.07.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 07:49:21 -0700 (PDT)
Date:   Fri, 18 Oct 2019 07:49:13 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Message-ID: <5da9d0e9bca63_1a132ad0125505c044@john-XPS-13-9370.notmuch>
In-Reply-To: <5d976c62bb52b_583b2ae668e6e5b41@john-XPS-13-9370.notmuch>
References: <20191004030058.2248514-1-andriin@fb.com>
 <20191004030058.2248514-2-andriin@fb.com>
 <5d97519e9e7f3_4e6d2b183260e5bcbf@john-XPS-13-9370.notmuch>
 <CAEf4BzbP=k72O2UXA=Om+Gv1Laj+Ya4QaTNKy7AVkMze6GqLEw@mail.gmail.com>
 <fb67f98a-08b4-3184-22f8-7d3fb91c9515@fb.com>
 <CAEf4BzbUSQdYqce+gyjO7-VSrF45nqXuLBMU6qRd63LHD+-JLg@mail.gmail.com>
 <5d976c62bb52b_583b2ae668e6e5b41@john-XPS-13-9370.notmuch>
Subject: Re: [PATCH bpf-next 1/2] libbpf: stop enforcing kern_version,
 populate it for users
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Andrii Nakryiko wrote:
> > On Fri, Oct 4, 2019 at 7:36 AM Alexei Starovoitov <ast@fb.com> wrote:
> > >
> > > On 10/4/19 7:32 AM, Andrii Nakryiko wrote:
> > > >> If we are not going to validate the section should we also skip collect'ing it?
> > > > Well, if user supplied version, we will parse and use it to override
> > > > out prepopulated one, so in that sense we do have validation.
> > > >
> > > > But I think it's fine just to drop it altogether. Will do in v3.
> > > >
> > >
> > > what about older kernel that still enforce it?
> > > May be populate it in bpf_attr while loading, but
> > > don't check it in elf from libbpf?
> > 
> > That's what my change does. I pre-populate correct kernel version in
> > bpf_object->kern_version from uname(). If ELF has "version" section,
> > we still parse it and override bpf_object->kern_version.
> > bpf_object->kern_version then is always specified as part of
> > bpf_prog_load->kern_version.
> > 
> > So what we are discussing here is to not even look at user-provided
> > version, but just always specify correct current kernel version. So I
> > don't think we are going to break anything, except we might allow to
> > pass some programs that were failing before due to unspecified or zero
> > version.
> > 
> > So with that, do you think it's ok to get rid of version section altogether?
> 
> Should be fine on my side. Go for it.

... Actually it turns out this broke some kernels that report via uname()
incorrect version info. Sent a patch out to add just the bits back we need
to get it working again.

To bad but I can't fix distributions that are deployed so...
