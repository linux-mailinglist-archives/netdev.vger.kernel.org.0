Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D780746573E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352977AbhLAUmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352997AbhLAUkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 15:40:05 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C263C061574;
        Wed,  1 Dec 2021 12:36:40 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b11so18596654pld.12;
        Wed, 01 Dec 2021 12:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yBtyrgQgTcwj7GSArxFRQ9lJWzU4lnRaFr8P+y6Z3lk=;
        b=TORDP2yvoTmQHQlYus5L8mrBh7nC/YS+DkGtMRhynIkjmrJ3b5z33la/FY9j3lFZdr
         dbwdsRuOGits2zcqEc3U+xeapuHJxQi+8m97b71iCwtL/7TLUi27YdBckEoWAFbZqRfD
         9GANQBOjmbJp72M2G37I2nRqBX1DWeQ9KJJxHoL0suAS/JGAfy+wHlEjlo32vU0+hrKy
         V1lVhd2Rr0IbdVN/lxdl9XyN6fM+HARVr5+kkv9dR18g2JTYpzupERdzEnCxMMDyomUl
         vJ6Xdzo59I+VsXwpNRD+LK7dGYEVBzFSczrylr30ucKMhmWzV3Ifo3ooMaQwX2ytsZ1r
         5B2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yBtyrgQgTcwj7GSArxFRQ9lJWzU4lnRaFr8P+y6Z3lk=;
        b=P+bvWFw8mXgSUds913Tua0UXEsaXk93m7ZWNnMeMuA5vlhp6IY2Ww3hHCCHBjBujiP
         YyxLoNr6lIu/SUTX1eV1YFjloyZR8TFlKXcWIrDPUeSdxp+jxcPajeFCWH8VekpSIixr
         Rk4ALhc3MsfhNliICB7rqIJqAJnPyHc/zMHjb6mqiIJ5bc4zttckHRh2AKbQ3Q+oKDPH
         TsmOxIKFqPmFa3VM0dpDJqIqazVC98Ld2QpUdNXmhBbg7luTvIubYRmBjvcbQinsrL99
         M0w2vfK8oeGz7PZUJdCACVwx6Fr2/Q3uFsMIEzol6ORMHwpcBkBvQSd9MMDaFgZZ/gyh
         pung==
X-Gm-Message-State: AOAM532fsooqa5DsJ1B1swgkrGG9rSYqnkW05ozWDhNpCL20W0TlRgwM
        gu0fJY4TYDJU8c9UhQuiI5XgzKz6k3E48ak/MD4=
X-Google-Smtp-Source: ABdhPJyF3wNU5906boaYjCZBSUXyq2AFtqmnSQa/tMv+zkOrgBKNJgDC5BA8yvyz0x+KfwIYvId4PstY/dz/ybwxgCk=
X-Received: by 2002:a17:90a:1f45:: with SMTP id y5mr687102pjy.138.1638391000123;
 Wed, 01 Dec 2021 12:36:40 -0800 (PST)
MIME-Version: 1.0
References: <20211118112455.475349-1-jolsa@kernel.org> <20211118112455.475349-7-jolsa@kernel.org>
 <CAEf4Bza0UZv6EFdELpg30o=67-Zzs6ggZext4u40+if9a5oQDg@mail.gmail.com>
 <YaPFEpAqIREeUMU7@krava> <CAEf4BzbauHaDDJvGpx4oCRddd4KWpb4PkxUiUJvx-CXqEN2sdQ@mail.gmail.com>
 <CAADnVQ+6iMkRh3YLjJpyoLtqgzU2Fwhdhbv3ue7ObWWoZTmFmw@mail.gmail.com> <CAEf4BzabQ9YU=d-F0ypA6W73YD534cAb2SkAkwYuyD6dk71LSQ@mail.gmail.com>
In-Reply-To: <CAEf4BzabQ9YU=d-F0ypA6W73YD534cAb2SkAkwYuyD6dk71LSQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Dec 2021 12:36:29 -0800
Message-ID: <CAADnVQKjOGr+v-xA6JP2wriha6BFFA0cs8cdUY-74ft2YYzXkg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/29] bpf: Add bpf_arg/bpf_ret_value helpers for
 tracing programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 10:00 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> But you emphasized an important point, that it's probably good to
> allow users to distinguish errors from reading actual value 0. There
> are and will be situations where argument isn't available or some
> combination of conditions are not supported. So I think, while it's a
> bit more verbose, these forms are generally better:
>
> int bpf_get_func_arg(int n, u64 *value);
> int bpf_get_func_ret(u64 *value);
>
> WDYT?

Makes sense to me.
The verifier will be able to inline it just fine.
Two extra insns only compared to direct return.
