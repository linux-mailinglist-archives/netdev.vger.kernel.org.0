Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79423CCA64
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 21:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhGRTdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 15:33:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229585AbhGRTdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 15:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626636651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UMbUN0PIcZzGJJuGdmd4lX1sf8HgOI8cNdSUuQof+xw=;
        b=HZB0lvlq5jFQ4CSOLVwdjsLEoUgCURLl9YuMTMBg5Drwb0rZY7jZd1CZTTQ4t1FNrlTctA
        56iIY3kOqj0EgREkzP6+XbBe3gkJosHbh+GNdUIJSEVZixf9OQDQJoZRCaZ8v+FkC7qtCs
        Mq2mMHZ1e0nOFIDpddH2FHMIKUI8650=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-Wz6YHrSYNH2OipSKyqm2Lg-1; Sun, 18 Jul 2021 15:30:50 -0400
X-MC-Unique: Wz6YHrSYNH2OipSKyqm2Lg-1
Received: by mail-ed1-f72.google.com with SMTP id n6-20020a05640205c6b02903a65bbc4aebso7999161edx.10
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 12:30:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UMbUN0PIcZzGJJuGdmd4lX1sf8HgOI8cNdSUuQof+xw=;
        b=JoI4C9FN6bJiohuC+ku2+Xy7qKTPIOTLZh7SI7A7oe40gSqIuPFxUFlj4bxuufzK1V
         zt8VOC1GegbT59gRl5yCt/SpHHKOO1/5HVD3PrndPnSIy5efcMu11mLPE4OhqLCyF4Gz
         yk97UQtVkRWHe06yx9jh2qZZBYAguGGjpFT5021lsjOBHiUeqMkU5t9NCzhGYDVvj4n1
         tCzzs0pGx9bOyXrWp6mqE/rMMXNMKpUf3GCVZmGCRDMxQ9l40IYGP0bMkflEGdiFdT/X
         SlOEii/TxQodftyaXBgmB+NgSibon3CS3JR2RLFXWvUuL+kZeoKEdfPnTDDtIr0WpJl3
         DkNg==
X-Gm-Message-State: AOAM530AtReZfBs/X8i/nsZXFXM490WTQ2NWr3H5G+RKMFBI1SHZq2yj
        MDjsZZ2RcaV8YMeIc9JeTj9BANA7ZC4Vn/jMdBRdObCn7oaslOgyULih91asaqGEKPSmHYx2FFr
        tQSb8C5F+tilnvema
X-Received: by 2002:a17:907:1b22:: with SMTP id mp34mr24025828ejc.408.1626636649013;
        Sun, 18 Jul 2021 12:30:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO3pISC5FcbdXyODTkbOgid74DkSr+FumVlJJdk/paaXorvh3maGZ3rfoZ0HHLWlqvmtKHmw==
X-Received: by 2002:a17:907:1b22:: with SMTP id mp34mr24025808ejc.408.1626636648889;
        Sun, 18 Jul 2021 12:30:48 -0700 (PDT)
Received: from krava ([83.240.60.59])
        by smtp.gmail.com with ESMTPSA id f18sm5157641ejx.23.2021.07.18.12.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jul 2021 12:30:48 -0700 (PDT)
Date:   Sun, 18 Jul 2021 21:30:46 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCHv4 bpf-next 3/8] bpf: Add bpf_get_func_ip helper for
 tracing programs
Message-ID: <YPSBZoMXGYIWqRuI@krava>
References: <20210714094400.396467-1-jolsa@kernel.org>
 <20210714094400.396467-4-jolsa@kernel.org>
 <CAADnVQLjrdv4Vbo+dQJXffMBwuYFCAqc6zxTys3vk4BoyrDHTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLjrdv4Vbo+dQJXffMBwuYFCAqc6zxTys3vk4BoyrDHTQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 06:09:22PM -0700, Alexei Starovoitov wrote:
> On Wed, Jul 14, 2021 at 2:44 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding bpf_get_func_ip helper for BPF_PROG_TYPE_TRACING programs,
> > specifically for all trampoline attach types.
> >
> > The trampoline's caller IP address is stored in (ctx - 8) address.
> > so there's no reason to actually call the helper, but rather fixup
> > the call instruction and return [ctx - 8] value directly (suggested
> > by Alexei).
> >
> > [fixed has_get_func_ip wrong return type]
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> I removed these tags, since they don't correspond to any real commit in the git.
> Otherwise all patches would have been full of such things when patch series
> go through iterations. Also fixed a few typos here and there,
> manually rebased and applied.
> Thanks!
> 

thanks,
jirka

