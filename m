Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667A0257EB4
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgHaQ0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgHaQ0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:26:22 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CFFC061573;
        Mon, 31 Aug 2020 09:26:21 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id e11so7406256ljn.6;
        Mon, 31 Aug 2020 09:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yhvKUgsISzaPktQrje7G3F3kKJV13GPsJJTzIICIW9k=;
        b=FNdV9HH5w422psfFU7Ug2cmvbUgGQ6TrEZMRLfKO1uv+yuUFCtH7zoDsne6+uuUGHa
         SjU0iQQq7J8tPINFlS5fX6liZaqLaUyep8xUmXLyfZ+7VrvqncypgNMDnuXm0z1GYs4y
         KMKGX/xcRFoJVmEpVhh8lDb05xE1Dsu1DW/KS5KWhOIwuCwJbZOWotCQ+6JbAVTK0R38
         v8Fr+W6Ohm1xjnid7eESX5XZdp/5+c0llbXT9qCAZ/JVTPTNnKlT0IYAzjZgL4ONzIeu
         rVmoTpWQBVBD+I+/r+NRIOymnzAZ/2JKkxlbmZaE/dPXelYl0vMbs4JwbApyj8t+U/38
         XXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yhvKUgsISzaPktQrje7G3F3kKJV13GPsJJTzIICIW9k=;
        b=rpqSQe9gSOlyES2IdnziLhQ4fcl9N1Z98vEHtLubOwVSr3sLJJJPR6yD0nQm95bcoJ
         Coih7ag6QUGMt+b6VRDmkvbzJWBY8QgXr1BtobzEFwjiQAPC01bgcWcDBteHcIzVloPt
         Gs/cG8YQkQCD4LTQGXJbyDuDfBiblmg7CLexjxw9H2pifoMRT7J95VH97SaSlvKGxaut
         5s27MOkn2Uy+364L1j3lBgA1xiP6e1K/cTaOqo1nHkrAa62ayL6LMh3f5/nRGG2du2k5
         L/YPlOb8y6u0FVmrjxDw8hU8itXaHEk8I6vu/x+a4cmDo6B5Anmm4OtCUcugNEwxyZdf
         6h7Q==
X-Gm-Message-State: AOAM533QAH4TSL0PbxdhlqxTgwPrlukLXb9pdUvFeJdQNI11nP7Uqzgj
        oOoPXLcQHDyRSDBs7W2bdXJKzymgE98ukX6fZBU=
X-Google-Smtp-Source: ABdhPJx2IgPcQuXFUnHRVfcBiFJVcMrs9dxgHtkMeDjrHLaM3x1LV8nAaKZ0KI9cuaAd7fzqoMUuQI3shpw8GUi6r9s=
X-Received: by 2002:a05:651c:82:: with SMTP id 2mr1034980ljq.2.1598891179857;
 Mon, 31 Aug 2020 09:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
 <20200827220114.69225-3-alexei.starovoitov@gmail.com> <CAJ+HfNgsP+DhQ16N3N4VtXNbmyE8yhZU7XFBG6gPimm17196pg@mail.gmail.com>
In-Reply-To: <CAJ+HfNgsP+DhQ16N3N4VtXNbmyE8yhZU7XFBG6gPimm17196pg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 31 Aug 2020 09:26:08 -0700
Message-ID: <CAADnVQJ673LvCAgtZu3L+Lf36oVgKd330XboR3TdRHX1uYQtLQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Josef Bacik <josef@toxicpanda.com>,
        Benjamin Poirier <bpoirier@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 7:52 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Fri, 28 Aug 2020 at 00:02, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
>
> [...]
>
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 6f5a9f51cc03..3ebfdb7bd427 100644
>
> [...]
>
> >
> > +/* non exhaustive list of sleepable bpf_lsm_*() functions */
> > +BTF_SET_START(btf_sleepable_lsm_hooks)
> > +#ifdef CONFIG_BPF_LSM
> > +BTF_ID(func, bpf_lsm_file_mprotect)
> > +BTF_ID(func, bpf_lsm_bprm_committed_creds)
> > +#endif
> > +BTF_SET_END(btf_sleepable_lsm_hooks)
> > +
>
> I'm getting:
>   FAILED unresolved symbol btf_sleepable_lsm_hooks
> when CONFIG_BPF_LSM is not set.
>
> Adding a BTF_UNUSED_ID unconditionally to the set helps, but I'm on a
> BTF limb here, so there might be a more correct/obvious workaround
> here...

yeah. thanks for reporting. The fix is on the way.
