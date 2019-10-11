Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08ACD4675
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfJKRSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:18:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40945 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbfJKRSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 13:18:23 -0400
Received: by mail-qt1-f196.google.com with SMTP id m61so14910629qte.7;
        Fri, 11 Oct 2019 10:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/m8UsFu180b4FnhyLSiGjcpT2hhOS/UR73wom/1nXMk=;
        b=ifl0mmcntetv0bQYTiTujkuMUC6OUCHTFRGy208UBnZE3jvzPReHXJDSFCpw2f0+G3
         oyifpYXxrGglGVQazv0YBdO/RT+SJ2va7F3g55d3WO9q2GM2ApwJwoF+JdKTP4+/s4kd
         nGeMheX9L7DE8Lqec5QxMNC4nKDQYUu+Gx3YtA1AQt2kZQJLr7HwunlyKJ1L+3tEyP8U
         VHCOf4EAlQXJLgDKMNiL4W9Ll8Z+XVFzWxba3DGIWgqGcMgcyC47Qvditq/Ve0+3CkLq
         815gNr+Gd3d3AhfypJk1B35Hqfwl3KPKyC6d+IeM3oo3N0Lg/ZnVRscLDS08DUkxny+K
         tu6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/m8UsFu180b4FnhyLSiGjcpT2hhOS/UR73wom/1nXMk=;
        b=QD0rk80f2YdtLUbugA/1LdAfLUyLKdI94esjeg4G0HCLXA12mnS3j4ym/9bvz3fyRO
         +4z6i8J9ZcedMGT+aG+46ZHwphY0KGzehnyGV54GOJiUQet7BvZouSOh9mh8gdSDSPwu
         1VhLlhmGudNZkwnfT8Nf5q7jHYV5YpPt9cPMTvhSdqDnFF5BMRzoWSih/u8PAqYZz8b/
         eh91w3HlfA8aJmuyfRbfr93QgVofzVfhOFduN8fsVo2QJNfug+TAoKcmrBLG7+W8aJqb
         ZSVe4iHpIJkd4g95Egw1kIoUxsszf2V6981po74Vi+c6nCXkTvvApprc1bQS8y2Ewrky
         ma/g==
X-Gm-Message-State: APjAAAWMt6OjtlX4NBw1hRvzwd2cDj6Zj9qpa6L/ZN6WkIddZfuQX1HO
        eijbPNuParil4axAkXmsUG/njssdvsG8FAjn8UU=
X-Google-Smtp-Source: APXvYqxRl61hZr6zf7qMLGvX1nJhIozKodJ+xRrLssJWndc+3nNbXKY4cNMbLLB9vApzCKvh8+I0Tj8O2N507Oe+Wm4=
X-Received: by 2002:a05:6214:134d:: with SMTP id b13mr16694914qvw.228.1570814302662;
 Fri, 11 Oct 2019 10:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191011042925.731290-1-andriin@fb.com> <20191011051507.akhuheqjizpfq7xx@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191011051507.akhuheqjizpfq7xx@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 10:18:11 -0700
Message-ID: <CAEf4BzZO8bz3B-Xz2X-LR50YnE4mefHQs9NnHRB7-Zq4TXd-ug@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] bpf: fix cast to pointer from
 integer of different size warning
To:     Martin Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 10:16 PM Martin Lau <kafai@fb.com> wrote:
>
> On Thu, Oct 10, 2019 at 09:29:25PM -0700, Andrii Nakryiko wrote:
> > Fix "warning: cast to pointer from integer of different size" when
> > casting u64 addr to void *.
> >
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as scalars")

Oh, right, thanks! I'll post v2 w/ Ack and Fixes tags.

>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
