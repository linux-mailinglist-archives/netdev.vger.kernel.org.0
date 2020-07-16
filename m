Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E3D2228A3
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgGPRAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPRAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 13:00:16 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE87C061755;
        Thu, 16 Jul 2020 10:00:15 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c139so6152699qkg.12;
        Thu, 16 Jul 2020 10:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xFnhvo+oT7GkUt0UP+3Y7RXHPYTZ7W0L8kttJ5pOMG0=;
        b=uc8tm4PfXmj/nu0p0WWHr51Owa30uzDsIaHZCBWMKUFn403QuwcVj+FilVdCYDqYEO
         lyu7O0/4ytK7ZYoQmb3SkChV67Fq8RFsJMjsD5MRi0032LGRz19re/y4aXDWR3SqLriQ
         FzGQ7dRkaG+oy6QHkzzuK5TPSuiKId0XzpAo6wFxVKetEpwzYXz6DEAh5yV82Rq01X8v
         MLEHtHm0QQ5uWKPsFTAIQBf0AV8qolmtvSIokRopzZznaT62MH2MISURh52Gr0+CMqeZ
         i9LPqY5gMGt+Xslo2lmhLrXqvcd/Kqn/oTtMs7adM3Z/TptovmCjL5sp56Q+UXEIY1Oq
         4QIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xFnhvo+oT7GkUt0UP+3Y7RXHPYTZ7W0L8kttJ5pOMG0=;
        b=QA1LiV6Jeq8drrFveQjtp57teCZ8e0zqcKT0qYGWN2n3FjmEcz/jrmrflSlU1vZCnc
         DSX2QsjXWarziM8vlyi19KSpkZk9gBXzmCuppf6FFft1h7b01KL1Madel0jgFAVwL5BD
         8Q4WUyv0Ay0F8gwUnNQlYwc39QjeDLDquSCIKOCxrPK/BmPxb//dBKNwzAZTFhf0j5xG
         ovdbQS0eR6X0WzmPhZc+E/qew3jjXI1MS4Ij1Hi4GN5qRT0Wk+6LmmND+u1mRPPIMMvp
         HRzV1UMaH2WUvWvbG9LGoh3IAJTZiY8/k91pZIy8L0259GRWdpULxiGyuVyS3Racfb/v
         YoRw==
X-Gm-Message-State: AOAM5324cvqEn5orRD2WYp5cCH7AS2FMK5HGwNlorxxQGjtYqjsM8Chn
        OyrKj8AXKQwNthpKgbU0LBKC6o3VSNw74QHCyGA=
X-Google-Smtp-Source: ABdhPJz0HV6BSIemzLDmEKsM1PULchEXNXJBIS75Wg4fCq+tO+eyPBKyWbeRI4EsBpNwLS+Kl4UtttMZynpqfeSNl74=
X-Received: by 2002:a37:270e:: with SMTP id n14mr4889742qkn.92.1594918814827;
 Thu, 16 Jul 2020 10:00:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200716045602.3896926-1-andriin@fb.com> <20200716045602.3896926-10-andriin@fb.com>
 <20200716082259.40600e03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716082259.40600e03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jul 2020 10:00:03 -0700
Message-ID: <CAEf4Bza_Sr6XcFQpP5jgYLt03CDVXR7zUv2cjNBMSWFqaWZDGQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 9/9] bpf, xdp: remove XDP_QUERY_PROG and
 XDP_QUERY_PROG_HW XDP commands
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 8:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 15 Jul 2020 21:56:01 -0700 Andrii Nakryiko wrote:
> > Now that BPF program/link management is centralized in generic net_devi=
ce
> > code, kernel code never queries program id from drivers, so
> > XDP_QUERY_PROG/XDP_QUERY_PROG_HW commands are unnecessary.
> >
> > This patch removes all the implementations of those commands in kernel,=
 along
> > the xdp_attachment_query().
> >
> > This patch was compile-tested on allyesconfig.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c: In function =E2=80=98dp=
aa2_eth_xdp=E2=80=99:
> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2079:25: warning: unused=
 variable =E2=80=98priv=E2=80=99 [-Wunused-variable]
>  2079 |  struct dpaa2_eth_priv *priv =3D netdev_priv(dev);
>       |                         ^~~~
>

Oh, I've fixed a few such warnings already, but apparently missed the
last one. It's hard to notice those in allyesconfig build. I've
double-checked the build log with grep now, it seems like there are no
more warnings anymore, thanks!
