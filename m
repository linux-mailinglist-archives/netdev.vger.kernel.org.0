Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142763FB236
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 10:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbhH3IDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 04:03:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233318AbhH3IDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 04:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630310572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rXrubIEC2DMSUpM/+V8SVHvpGY5IIt96CE00R1zKyYM=;
        b=U2gTqR0dHaS0kupjRZAICwc0KerwjRAnimtkWoCAANRBpsH6N3MhGChnC6lt5CeqMl4n5Y
        4Kqi3oRBnlBkDxHKohN45p/rskAV8rzDx6js344pmgSdjC5UlYHTEuWKKMMr+Z2xavYOug
        BsZf6qyNbiql4O/kwjByOcR6up7rNyY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-73E4IzkcOYae5DGSKtpRxQ-1; Mon, 30 Aug 2021 04:02:49 -0400
X-MC-Unique: 73E4IzkcOYae5DGSKtpRxQ-1
Received: by mail-ed1-f72.google.com with SMTP id m16-20020a056402511000b003bead176527so6076507edd.10
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 01:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rXrubIEC2DMSUpM/+V8SVHvpGY5IIt96CE00R1zKyYM=;
        b=MUZo/poRaWI4QT8b3G8Mco+wUPDnreIOA96M7PdSGw0rRtYJLJOY9/JTCBwtzYoOXc
         qDWEl458+DwKXEbcFiSOPz7rfZ/5MLKvRYNlqZ0CXPuLBXAgp8MwZKlgkEV3d/C5wBd8
         vJf6xEq0zqJWZ2ScqQn9t9xFY3eGM8f7f2HLsWyRZSnm1IdjqY5RBu7tqktXMRvDKjGW
         hUS9w3IibKR7JO4MjZVuhOBXKFSWL+rge1TPO2CGtV2nwAkb0SrUXcsFdtM6xRHouqoH
         tMGA2mgXdcuu/cDV61xTUYntMe3XaCUr6M61SDR+WuntusNpgx7yNgQ/LdRzeaPYhEMV
         y6tg==
X-Gm-Message-State: AOAM533xHXeYP5wt2ZkyALAAhbPPIOYFLbwkYxlsNfNzBwFS24N42qV4
        hQ1o4xGmxFiA9+kw8VDvbV0AprIc7ysTGv5GwKs5pM7jfGkd8jzhnxXl6fOrLKfxIIMKtpObxVk
        YoNrjCz9gefw9LjAc
X-Received: by 2002:aa7:d601:: with SMTP id c1mr16316438edr.143.1630310568204;
        Mon, 30 Aug 2021 01:02:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXcJW8oDEN0ZkObgpaUFwYy7NjLN/KkIEO0WkUwvPs1b+YMrZrZnVlhkNQV+KbC4oB0CA4+g==
X-Received: by 2002:aa7:d601:: with SMTP id c1mr16316412edr.143.1630310567996;
        Mon, 30 Aug 2021 01:02:47 -0700 (PDT)
Received: from krava ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id r28sm7351905eda.84.2021.08.30.01.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 01:02:47 -0700 (PDT)
Date:   Mon, 30 Aug 2021 10:02:45 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH bpf-next v4 00/27] x86/ftrace/bpf: Add batch support for
 direct/tracing attach
Message-ID: <YSyQpYCsrV3lm8/6@krava>
References: <20210826193922.66204-1-jolsa@kernel.org>
 <20210829170425.hd7zx2y774ykaedt@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210829170425.hd7zx2y774ykaedt@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 10:04:25AM -0700, Alexei Starovoitov wrote:
> On Thu, Aug 26, 2021 at 09:38:55PM +0200, Jiri Olsa wrote:
> > hi,
> > sending new version of batch attach support, previous post
> > is in here [1].
> > 
> > The previous post could not assign multi trampoline on top
> > of regular trampolines. This patchset is trying to address
> > that, plus it has other fixes from last post.
> > 
> > This patchset contains:
> >   1) patches (1-4) that fix the ftrace graph tracing over the function
> >      with direct trampolines attached
> >   2) patches (5-8) that add batch interface for ftrace direct function
> >      register/unregister/modify
> >   3) patches (9-27) that add support to attach BPF program to multiple
> >      functions
> 
> I did a quick look and it looks ok, but probably will require another respin.
> In the mean would be great to land the first 8 patches for the upcoming merge
> window.
> Jiri,
> can you respin them quickly addressing build bot issues and maybe
> Steven can apply them into his tracing tree for the merge window?
> Then during the next release cycle we will only iterate on bpf bits in the
> later patches.
> Thoughts?

sounds good, will do

jirka

