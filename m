Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9858F1B1B53
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 03:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDUBlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 21:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgDUBlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 21:41:01 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C37C061A0E;
        Mon, 20 Apr 2020 18:41:00 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id q19so12211067ljp.9;
        Mon, 20 Apr 2020 18:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qMrO/e1+jxJRx18PN/XzwrSdTrA9PpTsr2dVT26dXRs=;
        b=phBGNrwWujEwSYnGz8UDqE4rSxBuMliZqHP8AbojlH2BaUGLMUSKH66km/dVKnG9h8
         TNJ9UtZfGp9iwFY17M9uFpkZoHmPqTgl2TaOsPE7OHB75+AyMdLi6IFcdRJSxkugOWrg
         dVO6xAsvHTR4+YB0cjtOrYUpdeQTUxikDD7++bov/xeM5mG+k3FYDLVWD9sdDieke6a8
         nYFjVIICv8VbZ48Lt/bNam9yW5uPtdsc9IZccxMJiTi8zQ+npFu7VB9QltBEr7ecExoY
         lhHf0SeCvCQLE0InmUw+DqGG98vL6sROfeDz08gPILwKJd3+9uQ+QII2d4/T0rZkmmON
         j8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qMrO/e1+jxJRx18PN/XzwrSdTrA9PpTsr2dVT26dXRs=;
        b=cDOIndwUkr0de9XWTJNy4sp/ABR6NG+iN0/RP7oFVmFdUTF5T/Vqr45N3MJwALVCle
         dhJrWDrdBz2DqBieLCL4WzvxYainPF6SslzenLxKgKUAdHY4JzI1R2r70GQXLS8XhG6b
         hwjqZE8H0oNxBjTSZDLYIkb4ktq2+SJYBWTrac3LKbtlxc5SA/QvgdyqbCqufbVpEqS7
         9bGf+cVopfeLXFsTz3J938UCEOFqKHkVaWbU5B+nRWfczO0nJclWiQOK5aA51DHs0/jI
         S4I26YpOXavdETC3tcK1XZgC0Ang6i4DQnWU42wgugc1U4p3bkLmcekotPCl+liGRj4Y
         6uuA==
X-Gm-Message-State: AGi0PuY+opXeeymU7Bm9a0MIJysGnl5LLCLy+Zg16/dit/K1/h6PAzYC
        AWOJFOkMACDd6i/D6tlpC9Mv4YNhGg8zT1DU25s=
X-Google-Smtp-Source: APiQypIgidvHa/lvhRiig6bws2KKLd5nCr/Nd62vY2hOqBMXXay1S7Y36x9w+JL7r8P/mShO8lgOjFdyziG+iXz5foE=
X-Received: by 2002:a2e:b4c2:: with SMTP id r2mr7333640ljm.143.1587433258934;
 Mon, 20 Apr 2020 18:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200416083120.453718-1-toke@redhat.com>
In-Reply-To: <20200416083120.453718-1-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 20 Apr 2020 18:40:47 -0700
Message-ID: <CAADnVQ+URBzSzc9Kb+fc7=nVdX_gXkdQNTqx6waPGcRQpd-C8A@mail.gmail.com>
Subject: Re: [PATCH bpf v2] cpumap: Avoid warning when CONFIG_DEBUG_PER_CPU_MAPS
 is enabled
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Xiumei Mu <xmu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 1:33 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> When the kernel is built with CONFIG_DEBUG_PER_CPU_MAPS, the cpumap code
> can trigger a spurious warning if CONFIG_CPUMASK_OFFSTACK is also set. Th=
is
> happens because in this configuration, NR_CPUS can be larger than
> nr_cpumask_bits, so the initial check in cpu_map_alloc() is not sufficien=
t
> to guard against hitting the warning in cpumask_check().
>
> Fix this by explicitly checking the supplied key against the
> nr_cpumask_bits variable before calling cpu_possible().
>
> Fixes: 6710e1126934 ("bpf: introduce new bpf cpu map type BPF_MAP_TYPE_CP=
UMAP")
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Tested-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Applied. Thanks
