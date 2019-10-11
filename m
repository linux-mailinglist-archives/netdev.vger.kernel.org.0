Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E39C0D498F
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 22:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfJKU6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 16:58:53 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40865 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfJKU6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 16:58:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id d22so4990823pll.7;
        Fri, 11 Oct 2019 13:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=rPzNi0bFJ9lr3/YdikETU74TEKXXfUYJ6X4Lm1ruCb4=;
        b=pwZ+qLiSyGg46Q+sK+idN3AR3hxfltSZMS/IryiNrpA9No2vHD2Nhg1LEY9fQ/2nj2
         /PFRXUklKkifU5wIeqMffLhu+H2X5CJewTmSdI/e59+uob8SmOtVgSW+CVxSp2/IBMvG
         EG7bdWWr5/s2zmwi5gfClFY1lR+bHFAxBV4hfUmKVTVdWxs0C+HpoxPSAvrMA8kTZxql
         CA1LCCkljSCabuoSOjWLwvV1WdymQmNHyJeeR9YwhV5NQ7WfvZlRXv3twfj1OS+jGpu5
         FQTVzHz1XZLdU0RzAz+5z+26QboITO/8EhSezd/HDGFj/u5cGjMVmE2Byjz57AjmLTQA
         XLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=rPzNi0bFJ9lr3/YdikETU74TEKXXfUYJ6X4Lm1ruCb4=;
        b=GZ1Q2h7sOK/6YgD0hwmF/MRAmKGI1UwPL16Eu7ntqFxy0nVYdSDoRGE2bNxrSvk1BW
         /gtyhewjwZvLeNBP6AempNY7IqYqdXuAGioXqoKy98sHBoxvsNzi+MSsH5U1lTvuFb4C
         OazG1hWrQOwqZS/3d0UCNY9XNPCJNwRCBkGCgjAyV8FVpJR4tiZ7Oo1lwK51f4i9Lkld
         j767b7kEA16/bDSYq6NHn2YZHDeiFn0vBmztpdAagKcKewZHZzDpuwK+nKolaqVbXiq6
         H7Iy1g4sis0SPVPp8Res2JDRKW3yOy/FJh6YeV4mQjzN1rbhV/k2WRLhtW7KueLV0XcP
         nCxw==
X-Gm-Message-State: APjAAAUdjlIOoUcKogpz4QZBMipiNwq1IODG09FOPb0cUckb/LpMPJxd
        rk+MtiQrrBoiwZbDQYPKJCY=
X-Google-Smtp-Source: APXvYqwnSNS4SW8N1cWOAWcAAe2xrEXI+5VrTO+XHnJT2oHnhBgw5K1RMZIrdGSJMNQFWHlUh0SLVg==
X-Received: by 2002:a17:902:a985:: with SMTP id bh5mr16709373plb.184.1570827532454;
        Fri, 11 Oct 2019 13:58:52 -0700 (PDT)
Received: from localhost ([131.252.143.44])
        by smtp.gmail.com with ESMTPSA id b5sm8283960pgb.68.2019.10.11.13.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 13:58:51 -0700 (PDT)
Date:   Fri, 11 Oct 2019 13:58:51 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Message-ID: <5da0ed0b2a26d_70f72aad5dc6a5b8db@john-XPS-13-9370.notmuch>
In-Reply-To: <CAJ8uoz3t2jVuwYKaFtt7huJo8HuW9aKLaFpJ4WcWxjm=-wQgrQ@mail.gmail.com>
References: <1570530208-17720-1-git-send-email-magnus.karlsson@intel.com>
 <5d9ce369d6e5_17cc2aba94c845b415@john-XPS-13-9370.notmuch>
 <CAJ8uoz3t2jVuwYKaFtt7huJo8HuW9aKLaFpJ4WcWxjm=-wQgrQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix compatibility for kernels without
 need_wakeup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson wrote:
> On Tue, Oct 8, 2019 at 9:29 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Magnus Karlsson wrote:
> > > When the need_wakeup flag was added to AF_XDP, the format of the
> > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the kernel
> > > to take care of compatibility issues arrising from running
> > > applications using any of the two formats. However, libbpf was not
> > > extended to take care of the case when the application/libbpf uses the
> > > new format but the kernel only supports the old format. This patch
> > > adds support in libbpf for parsing the old format, before the
> > > need_wakeup flag was added, and emulating a set of static need_wakeup
> > > flags that will always work for the application.
> > >
> > > Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in AF_XDP part")
> > > Reported-by: Eloy Degen <degeneloy@gmail.com>
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> > >  tools/lib/bpf/xsk.c | 109 +++++++++++++++++++++++++++++++++++++---------------
> > >  1 file changed, 78 insertions(+), 31 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > index a902838..46f9687 100644
> > > --- a/tools/lib/bpf/xsk.c
> > > +++ b/tools/lib/bpf/xsk.c
> > > @@ -44,6 +44,25 @@
> > >   #define PF_XDP AF_XDP
> > >  #endif
> > >
> > > +#define is_mmap_offsets_v1(optlen) \
> > > +     ((optlen) == sizeof(struct xdp_mmap_offsets_v1))
> > > +
> > > +#define get_prod_off(ring) \
> > > +     (is_mmap_offsets_v1(optlen) ? \
> > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.producer : \
> > > +      off.ring.producer)
> > > +#define get_cons_off(ring) \
> > > +     (is_mmap_offsets_v1(optlen) ? \
> > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer : \
> > > +      off.ring.consumer)
> > > +#define get_desc_off(ring) \
> > > +     (is_mmap_offsets_v1(optlen) ? \
> > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.desc : off.ring.desc)
> > > +#define get_flags_off(ring) \
> > > +     (is_mmap_offsets_v1(optlen) ? \
> > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer + sizeof(u32) : \
> > > +      off.ring.flags)
> > > +
> >
> > It seems the only thing added was flags right? If so seems we
> > only need the last one there, get_flags_off(). I think it would
> > be a bit cleaner to just use the macros where its actually
> > needed IMO.
> 
> The flag is indeed added to the end of struct xdp_ring_offsets, but
> this struct is replicated four times in the struct xdp_mmap_offsets,
> so the added flags are present four time there at different offsets.
> This means that 3 out of the 4 prod, cons and desc variables are
> located at different offsets from the original. Do not know how I can
> get rid of these macros in this case. But it might just be me not
> seeing it, of course :-).

Not sure I like it but not seeing a cleaner solution that doesn't cause
larger changes so...

Acked-by: John Fastabend <john.fastabend.gmail.com>
