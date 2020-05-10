Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167F01CCC21
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgEJQJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728762AbgEJQJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:09:17 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B159BC061A0C;
        Sun, 10 May 2020 09:09:15 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a21so6804319ljj.11;
        Sun, 10 May 2020 09:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ry4sGaRz1hPd8ZrRZNs00n41ZYAYeYkvGcXZbHcvaBI=;
        b=u+UUdnsGPq4lbMio+RJwnb3Rhh1b7AyrDJtjpg60O8Ja723hCidH1NvIENdBPHVOlQ
         JL8wfY+LEv/uIDd79UEXHSrcUbEYLWYZIP+I3k/leRDu1x1cgVcxH+zuF+ougtsU+rRF
         5ijLUIjecDH4WnP3WSs7s04NkDr7gi6vwZKL+0D/TQyEzYcWsq8m7f5EiPUJzCDR57yt
         1k1q1wFzjvb2WC/tNar+SILoRHaQK893pLXnWyJUx+SC9SsuvSL28BIu32A0zbXkuD0+
         /Lwp9oKrSOH8Fsqs5YYR2J4VGBnzdnTXqkCFSVMoXuXlqc5pRm3uGLo9CDYFsy6oOaGm
         GHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ry4sGaRz1hPd8ZrRZNs00n41ZYAYeYkvGcXZbHcvaBI=;
        b=XOqqie1mgBkb7f3uaauz7Wia8kvpipkZ7ItyiX0CocNq47+X9iYxov7y5d8xJ7zTX8
         vpdOEgy7c+LsrdVEm/ZtqO7h7jAtsakCb17tW0mJ3nRyWHKrVvRTPvz8mqkDskfwAM3p
         I41Ebxg13skjL3eEQScwVX3XWLEKTcF4Eexnw5YQ4htMyrjVwN3tuqGB4i1KcAghGOsE
         vNyoKrMHAUMv0gwh1V0Je9caqqsWa6MatDFCNPnS4BS9uslyEqWtFiSyUipXnt9uspIm
         u0Gzljh2pIQbbcVDU/7OACK3LMm4YSW8RVnTCHEdM62X4J3oos5oWFU/4GH4071FEcgI
         kK7w==
X-Gm-Message-State: AOAM531tqZPIapkyqhDJi1gIFOyZ2L3Spxx6VmeO36WbNirPs0z7cV6T
        n2QDCcd/wJ/6AdRAL6nQleiK9AcKRczlLezy6UPhARwG
X-Google-Smtp-Source: ABdhPJw8nNjWQHOZGAVDMPXONG7yr1BCIBDN0uzfqZCnZGp0znI10MaScZ8zUHnoXJueST5HO4+L22GTnpf13uHTcLc=
X-Received: by 2002:a2e:9011:: with SMTP id h17mr7862445ljg.138.1589126954146;
 Sun, 10 May 2020 09:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200509175859.2474608-1-yhs@fb.com> <20200509175917.2476936-1-yhs@fb.com>
 <20200510003535.rfnwiuunxst6lqe5@ast-mbp> <51a07f55-6117-58c2-e1f4-a1f38130976d@fb.com>
In-Reply-To: <51a07f55-6117-58c2-e1f4-a1f38130976d@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 10 May 2020 09:09:02 -0700
Message-ID: <CAADnVQ+90UtuXVj8sCmyQQZCxFFfmcUq05w5DBybWxSN_0AL4A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 16/21] tools/libbpf: add bpf_iter support
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 10:07 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/9/20 5:35 PM, Alexei Starovoitov wrote:
> > On Sat, May 09, 2020 at 10:59:17AM -0700, Yonghong Song wrote:
> >> @@ -6891,6 +6897,7 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
> >>
> >>   #define BTF_TRACE_PREFIX "btf_trace_"
> >>   #define BTF_LSM_PREFIX "bpf_lsm_"
> >> +#define BTF_ITER_PREFIX "__bpf_iter__"
> >>   #define BTF_MAX_NAME_SIZE 128
> >
> > In the kernel source the prefix doesn't stand out, but on libbpf side it looks
> > inconsistent. May be drop __ prefix and keep one _ in the suffix?
>
> Currently, I have context type as
>     struct bpf_iter__bpf_map
> Based on the above proposal, we will have function name as
>     bpf_iter_bpf_map
> It is quite similar to each other. My current usage to have
>      __bpf_iter__bpf_map
> intends to make func name and struct type name quite different.
> Or maybe
>      bpf_iter__bpf_map vs. bpf_iter_bpf_map
> just fine as user should not care about func name
> bpf_iter_bpf_map at all?

Type names bpf_iter_bpf_map and bpf_iter_foo don't look
unique, but I don't see why they should.
If code really required type name uniqueness __bpf_iter__ prefix
wouldn't provide that property anyway.
I think bpf_iter_ falls into the same category of prefixes like
those used by lsm, trace, struct_ops. Or I could be missing
why iter has to be different.
