Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3E640CC53
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 20:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhIOSHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 14:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhIOSHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 14:07:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FC7C061574;
        Wed, 15 Sep 2021 11:06:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so4873098pjb.2;
        Wed, 15 Sep 2021 11:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pvEN7KugXHcnrzozoG39k+LPieQON2FX8llLC4usQH4=;
        b=NPpAu0Cm9A5rFyd2g8YF9gXZrq26LGbyYM6amLOoYkCx2JRTPWFqCnWJ6mz46VLu5q
         vAxcRFft0s0y6qSILHhaHJ7WN4VkPZxFrnKmuN6B/UGdw5YDjJZNayZ4ZY2UlxPc65Zq
         K/kK+yosQGQ9waXq+lPCSEiHcA1B9dffSWd1PZFY9MJozhIbt8GfZFs3+LBp7pCkr9ZF
         kv+N43op/LqqOwFCxOUIlPjIU5WCrTg3u1+MMiVQJ3mv3f1DyIx+T6KWqnTs6rdtuB9J
         fleLMGjYLB48AOTkwqXS5NBYNoXJg/hIGAq0LUq/zq4ReoRUr8RlDy64GcgDYkFde/m1
         BkSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pvEN7KugXHcnrzozoG39k+LPieQON2FX8llLC4usQH4=;
        b=YeJGd7cxaT3gTNICip8cg/X8KwXl63MciOcXLi/O13I5nT620kY4VqLapEQdmmHizM
         D9NghJhjPgfrxqnsxhl78tCunA1+ZKZK0wXNn0M5/pQ+2CvEeyIaRr1qqcLYUvuVS4SI
         S1ql+BDPLx8JDn9U5aI8aH8jYJUNJDPiHsV1RpP5j18gGFHCbQimATd6OBkSSGrKEEFE
         ZXWzZzcjFGae0Fnb5KZ7IJgTDlhWAI6HjuPVvVdDE4ohry8/tGyPPr+DOiInzhhWYjqq
         8rXijY5nlaE6ERcxEu7FDB/9YxDyo9k3RHR155UJoWPNVcTxmRnUjV5IoBNSsXz8tGNT
         zEaw==
X-Gm-Message-State: AOAM530DGfJS2zbJPrVIG6wXARB0Ag7rqSnCjCdRHZUSsBeXAE2Z4sXn
        0XwcWKSU2Iww6MeRla8/9LU=
X-Google-Smtp-Source: ABdhPJxVOmMhwZC0VWOanMP/iQsbUXhf0sAQAKOndvHx5Kd/DdCu1qX2Yv1X2IQFIDmr/Vz7gPT01Q==
X-Received: by 2002:a17:90a:bb13:: with SMTP id u19mr9895904pjr.42.1631729188778;
        Wed, 15 Sep 2021 11:06:28 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id h4sm609171pgn.6.2021.09.15.11.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 11:06:28 -0700 (PDT)
Date:   Wed, 15 Sep 2021 23:36:26 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 03/10] bpf: btf: Introduce helpers for
 dynamic BTF set registration
Message-ID: <20210915180626.a367fkhp2gb23yfb@apollo.localdomain>
References: <20210915050943.679062-1-memxor@gmail.com>
 <20210915050943.679062-4-memxor@gmail.com>
 <20210915161835.xipxa324own7s6ya@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210915161835.xipxa324own7s6ya@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 09:48:35PM IST, Alexei Starovoitov wrote:
> On Wed, Sep 15, 2021 at 10:39:36AM +0530, Kumar Kartikeya Dwivedi wrote:
> > This adds helpers for registering btf_id_set from modules and the
> > check_kfunc_call callback that can be used to look them up.
> >
> > With in kernel sets, the way this is supposed to work is, in kernel
> > callback looks up within the in-kernel kfunc whitelist, and then defers
> > to the dynamic BTF set lookup if it doesn't find the BTF id. If there is
> > no in-kernel BTF id set, this callback can be used directly.
> >
> > Also fix includes for btf.h and bpfptr.h so that they can included in
> > isolation. This is in preparation for their usage in tcp_bbr, tcp_cubic
> > and tcp_dctcp modules in the next patch.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  include/linux/bpfptr.h |  1 +
> >  include/linux/btf.h    | 32 ++++++++++++++++++++++++++
> >  kernel/bpf/btf.c       | 51 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 84 insertions(+)
> >
> > diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
> > index 546e27fc6d46..46e1757d06a3 100644
> > --- a/include/linux/bpfptr.h
> > +++ b/include/linux/bpfptr.h
> > @@ -3,6 +3,7 @@
> >  #ifndef _LINUX_BPFPTR_H
> >  #define _LINUX_BPFPTR_H
> >
> > +#include <linux/mm.h>
>
> Could you explain what this is for?
>

When e.g. tcp_bbr.c includes btf.h and btf_ids.h without this, it leads to this
error.

                 from net/ipv4/tcp_bbr.c:59:
./include/linux/bpfptr.h: In function ‘kvmemdup_bpfptr’:
./include/linux/bpfptr.h:67:19: error: implicit declaration of function ‘kvmalloc’;
 did you mean ‘kmalloc’? [-Werror=implicit-function-declaration]
   67 |         void *p = kvmalloc(len, GFP_USER | __GFP_NOWARN);
      |                   ^~~~~~~~
      |                   kmalloc
./include/linux/bpfptr.h:67:19: warning: initialization of ‘void *’ from ‘int’
	makes pointer from integer without a cast [-Wint-conversion]
./include/linux/bpfptr.h:72:17: error: implicit declaration of function ‘kvfree’;
	did you mean ‘kfree’? [-Werror=implicit-function-declaration]
   72 |                 kvfree(p);
      |                 ^~~~~~
      |                 kfree

> >  #include <linux/sockptr.h>

--
Kartikeya
