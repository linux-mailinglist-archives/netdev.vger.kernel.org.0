Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B1F3C953B
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhGOAq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhGOAq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 20:46:56 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5231AC06175F;
        Wed, 14 Jul 2021 17:44:03 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id u13so6718054lfs.11;
        Wed, 14 Jul 2021 17:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4lwEPZyeOG5aBWm24/hq0DiAQ1/5T1mG1Q20l9DdA8w=;
        b=vMgvHdo+q9SzU83HK61i5sZA4LxpESy5iZozmel47moKFAyNL80DiF1VZt5bjTImlY
         YKKl7Ela7AOzMnyYnJLimi8UcovJtAxpgDYjwjA3l840K3JdHh1vUOIJ977jyuC0YVsv
         cbbdInSphFSKH5KWyFAKSTQbwA1W/pbwMHEaGJ6gx84UdRW16YyeypoMqMB36+V/ydtE
         iGjd6wyO68HqHioQKgL7WMp7IwGCTvMlZygD/R8kU4Bq/3Dtrv6GBgDCBS+Oc+uXfO4F
         /6SRjTlxT8wznIpa8VRCT73413toocEE40lFL16pEVUB+F/stM0hlWxJ3xcwezYz8HKQ
         d27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4lwEPZyeOG5aBWm24/hq0DiAQ1/5T1mG1Q20l9DdA8w=;
        b=ibKzrZuA+7ypE2FPn96p9ZDRCSdYOTn2krSlr2omrczFS5ZN1zxjWodoktikiignDo
         BN0CCpSzoda7Ia/H3v17taFzF8+AjLu+RMBbmRkKT0CII+PaTZF0UkLUev5s4rJGKtI4
         sJB2r2Yoir4vnLPKeUdzAx67XwhVQzvfD4DW7g1GMNytOfuNhue+Hvvfiv+vbU7U0gMn
         T+y+s6i2+CZsr9MXeGx+GOr9rEJR4L/Ep17kDeLtCZ6I+nvgJaOA5wVQF3X4yjnCvKka
         buU0XwyoxBGqxuWr4br2HQbdDt2Z3aswgAQg9BLJeNVGN3kTHfoawU8yUu4fzcom9wKd
         SuTg==
X-Gm-Message-State: AOAM533D3cTaiHuTtcJKiiy1czglNt9n4WdGK4NZ5cOJS0mLzUIRRQpA
        xi5bio8MRKPnSnFvKh4CAxHFowZZZ14x+4sHKIE=
X-Google-Smtp-Source: ABdhPJxCKOyEh62ZMXpVxwAg0dFgb70DZrT8ZCJP5BfnJmb8hrA8M+bZ3fUfv6WQWw/4HmGOu8aOmSTsC82mtlSw2TY=
X-Received: by 2002:a05:6512:3f9a:: with SMTP id x26mr549160lfa.75.1626309841103;
 Wed, 14 Jul 2021 17:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
 <20210714010519.37922-4-alexei.starovoitov@gmail.com> <CAEf4BzbJb3q0=LwHs_JXXB2a7wsY=rCF7E+nxsM2SgcC6KK8jA@mail.gmail.com>
In-Reply-To: <CAEf4BzbJb3q0=LwHs_JXXB2a7wsY=rCF7E+nxsM2SgcC6KK8jA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 14 Jul 2021 17:43:49 -0700
Message-ID: <CAADnVQJyP0D2iFgvcCurMPF0_hQjAzqeL1wdpe8u6-ah0Oz=eA@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 03/11] bpf: Introduce bpf timers.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 5:00 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> > +       }
> > +       /* allocate hrtimer via map_kmalloc to use memcg accounting */
> > +       t = bpf_map_kmalloc_node(map, sizeof(*t), GFP_ATOMIC, NUMA_NO_NODE);
>
> I wonder if it would make sense to use map->numa_node here to keep map
> value and timer data in the same NUMA node?
>
> > +       if (!t) {
> > +               ret = -ENOMEM;
> > +               goto out;
> > +       }
>
> [...]
>
> > +
> > +/* This function is called by map_delete/update_elem for individual element.
> > + * By ops->map_release_uref when the user space reference to a map reaches zero
> > + * and by ops->map_free when the kernel reference reaches zero.
>
> is ops->map_free part still valid?

Both good points. Will respin.
