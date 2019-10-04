Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3A6CBFEC
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390150AbfJDP7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:59:41 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40980 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389773AbfJDP7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:59:40 -0400
Received: by mail-io1-f65.google.com with SMTP id n26so14576443ioj.8;
        Fri, 04 Oct 2019 08:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=1fDIFwSxbB6EMoy6o2ey6HkUyTmcSFfa0LxeDRrvOZ8=;
        b=AuRjYOSGaY8hut+10T/VFGkLt7H2WTV9oSsW74YJ6iYTACT2qYvLAZlaxrW3pxTOFL
         fanYZrilkEJG6b0+jnRxdMfP95rbGKiNd3AfkWTH67C1aebD5ohVrJcppPtrS58REmRH
         qkD+llJhMO2AR+X9hLB8osrpheRcYVitiVTycI9FeoTCvHty7p4ksmniHIyir16WfiPB
         by880AjdGZWe92cjw9iIGS/03GNATRyrC0Sd4suYVGqOo4VUoZMqrxpYLO3jKTaWRvtr
         H9ylXkxUdR1889CHtJ2g5uW83xZCu/dt9JyS3IX5FS7scZmpnbO206ztVSxtpCM8NNnO
         Viug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=1fDIFwSxbB6EMoy6o2ey6HkUyTmcSFfa0LxeDRrvOZ8=;
        b=TFRv986sG3eKg8f3W1D9ZA+swef9Fw6mkto9PmWnwB2+XFs0XchMBP3y/7kHW8OStT
         DLHqzD9185WCwn1p2xFIuI88lXXW45QLCVA+MhTO1HrlOBn2dpwBNSZECS0P3Q8QCrxq
         8X/fQq+aMb125iTAxDH+gPgepahxyy9n8rUk+8YjgwzX4137KGK1rjwSNE1DYTOy6Ybh
         FAyXZIwkG6OdvwA1c5GBo1d9Z+u54dkpkwcJ2vW6C9tTrBriEfzkw0lTuYOQer27rlMd
         xMmrC1fiIvKQNsdupZc4+T3nHQ54Nw4+jzr82/OC/LnePes7ALxCfQG3KH2zRlp7gN0y
         AYVw==
X-Gm-Message-State: APjAAAXZFFnn1gx5q3CqdDL+vp5nqVxt/E3nz+7iRTSLYdBpJf30Ja16
        6IxCqLNWaxDFS/VJ3uS/h54=
X-Google-Smtp-Source: APXvYqwY7z2ki6AJWRIZNK+N6VDl22mf6vq3VhxLTstHSHxs79JhPf3wcy7MDzUjUroB3CbKD8U8vQ==
X-Received: by 2002:a6b:2c8d:: with SMTP id s135mr12935589ios.98.1570204779924;
        Fri, 04 Oct 2019 08:59:39 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i4sm2104821iop.6.2019.10.04.08.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 08:59:39 -0700 (PDT)
Date:   Fri, 04 Oct 2019 08:59:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Message-ID: <5d976c62bb52b_583b2ae668e6e5b41@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzbUSQdYqce+gyjO7-VSrF45nqXuLBMU6qRd63LHD+-JLg@mail.gmail.com>
References: <20191004030058.2248514-1-andriin@fb.com>
 <20191004030058.2248514-2-andriin@fb.com>
 <5d97519e9e7f3_4e6d2b183260e5bcbf@john-XPS-13-9370.notmuch>
 <CAEf4BzbP=k72O2UXA=Om+Gv1Laj+Ya4QaTNKy7AVkMze6GqLEw@mail.gmail.com>
 <fb67f98a-08b4-3184-22f8-7d3fb91c9515@fb.com>
 <CAEf4BzbUSQdYqce+gyjO7-VSrF45nqXuLBMU6qRd63LHD+-JLg@mail.gmail.com>
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

Andrii Nakryiko wrote:
> On Fri, Oct 4, 2019 at 7:36 AM Alexei Starovoitov <ast@fb.com> wrote:
> >
> > On 10/4/19 7:32 AM, Andrii Nakryiko wrote:
> > >> If we are not going to validate the section should we also skip collect'ing it?
> > > Well, if user supplied version, we will parse and use it to override
> > > out prepopulated one, so in that sense we do have validation.
> > >
> > > But I think it's fine just to drop it altogether. Will do in v3.
> > >
> >
> > what about older kernel that still enforce it?
> > May be populate it in bpf_attr while loading, but
> > don't check it in elf from libbpf?
> 
> That's what my change does. I pre-populate correct kernel version in
> bpf_object->kern_version from uname(). If ELF has "version" section,
> we still parse it and override bpf_object->kern_version.
> bpf_object->kern_version then is always specified as part of
> bpf_prog_load->kern_version.
> 
> So what we are discussing here is to not even look at user-provided
> version, but just always specify correct current kernel version. So I
> don't think we are going to break anything, except we might allow to
> pass some programs that were failing before due to unspecified or zero
> version.
> 
> So with that, do you think it's ok to get rid of version section altogether?

Should be fine on my side. Go for it.
