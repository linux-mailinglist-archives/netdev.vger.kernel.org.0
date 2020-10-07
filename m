Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF352286B8B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 01:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbgJGXeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 19:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgJGXeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 19:34:06 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75273C061755;
        Wed,  7 Oct 2020 16:34:06 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id j76so3135201ybg.3;
        Wed, 07 Oct 2020 16:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kaCT7dYjwn0iby+pZpZ0as46gkP09c55vm9iTwuQ43k=;
        b=VvL6KeqH2M7cjLYRe2GMebHS7XeJ14btFEbO46x7Ib+XdiWOCJeCg6MsDeZBItqVIF
         TBjQlB72EUETmExH+9e6p8ZBJ3cDpzV59ULVF+l3M25ovwbEBoljqEDeo/WTxbPY23Nb
         WRmudN4jHtMuvhecpAY75x7H56SKVh70jR+hbFZ+nClGbIJKoNAoHAnBYbrl0s8Z0KCK
         bZS9HMEMnzUGuAa0FmMfslfmT8M5XtIPl3Ira24XnPhdC6ILrz3ZoqENe+39xmIVKLHf
         QTblIK7jwKx3ceyikGZeZnshZVAtC6ooaeKxTVuBl6/668i0hbvAFCFL82yjQDIwGQh8
         43Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kaCT7dYjwn0iby+pZpZ0as46gkP09c55vm9iTwuQ43k=;
        b=YZcysWMTngRjP1d3xdOO6AAHv1VoqJisj6saYzmtiH+yO6LFvMig7MlhVl6hPypwc/
         dYDlTbQXOdjJ3o1o1RTl8vBre+kEXxdnG5cLl1piSN3dJXHC/gTe7uiVouGYX4xmieFb
         QvoJEOfFEYTqM9DQYelHLWjPMI9zxxQU6beEsAD8Nr22zAGfBjQhhxZyE43GCFDnvKm0
         BnYmzJ51E2qN0ALk3FVwGTAkKI9fzIhtalgh5ZCITiCusecf0dbCmrDTJZtwiEk+xRgf
         JWQ8DDcsD/UFIJbHfKkeMMrau9oQRGmBfTZx+8FaSYh4fTaZHEi8khdAZyx71FwK6Zp0
         msGw==
X-Gm-Message-State: AOAM530LNjCq3f7Yb051DCGfkJyovGbg/BuFkTMfyDENc0WlH02sMD26
        wTz4ffxqO5ZoiR7GaYV0gUYrY8uZe6qOx1r9NUw=
X-Google-Smtp-Source: ABdhPJzNOvPoWvIHesHaM3vcc0NnSFa2zdDkhroQrjoSDf/aGv3jVz9s7dHFckBh3mGi6yNOYkb4YX8mToCCBPV/rWs=
X-Received: by 2002:a25:2596:: with SMTP id l144mr7255708ybl.510.1602113645664;
 Wed, 07 Oct 2020 16:34:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201007202946.3684483-1-andrii@kernel.org> <20201007202946.3684483-5-andrii@kernel.org>
 <20201007232957.nrmqryypzc44rqcd@ast-mbp>
In-Reply-To: <20201007232957.nrmqryypzc44rqcd@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Oct 2020 16:33:54 -0700
Message-ID: <CAEf4BzbHQ__QtEjCssXqE-uHCAmTvQHRB4gOYC2-8Up5_s7B8g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: validate libbpf's
 auto-sizing of LD/ST/STX instructions
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 4:30 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Oct 07, 2020 at 01:29:46PM -0700, Andrii Nakryiko wrote:
> > diff --git a/tools/testing/selftests/bpf/progs/test_core_autosize.c b/tools/testing/selftests/bpf/progs/test_core_autosize.c
> > new file mode 100644
> > index 000000000000..e999f2e2ea22
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_core_autosize.c
> > @@ -0,0 +1,172 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2019 Facebook
>
> The year is wrong.
> Also Copyright should be in /* */
> The // exception is only for SPDX and only in .c
> .h should have both in /* */

argh, copy/paste from test_core_reloc.c

We have plenty of those '//' vs '/* */' issues with SPDX and
Copyrights in selftests. Might be a good idea to finally fix all that.
