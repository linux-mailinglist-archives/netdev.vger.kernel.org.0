Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3E92000F6
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgFSD6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgFSD6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:58:18 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA5DC06174E;
        Thu, 18 Jun 2020 20:58:18 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id g11so3863042qvs.2;
        Thu, 18 Jun 2020 20:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0F37xm83jus+oFplaK8oHHUjtTdDriG0A+RwV1lRtUo=;
        b=IWsvMkKJDFqCpFKjygsrAUy3tq0lQBWGzHvwSigd9LXPNKR5U9SCzWA29SDxu5WuJC
         CNM2ij0w3dj7VRR5YglkEgGntEeLgHoWTPNQPzzVVaTr+Enb6hjsfRxSvFYewrc8/P7W
         GyN5VbCcaxEyMyxoM7stGV/tjb7DH5OMH4xr+9afjuvsfHn7qrYa/rp6Op81cZ3ix4j6
         WW3qdegEmDCC1jrf/MFZF4iCT063/2/cqmZlRIzgaUP55Gx6VkKwU4tpoZnbUFRTwQCj
         /rHmGueZCKasRZUaGh6hCnlk1ZqT9qV6Tyv5LIZ/p6Rg61Uqbsbck2kkoX/bS+0+vRYl
         pdzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0F37xm83jus+oFplaK8oHHUjtTdDriG0A+RwV1lRtUo=;
        b=hMm+2yQorHX7SLfez3w6YuBQw1p3AQTSMOnrvpnCFVfIKzUrdilfHXxxNbsa3bjq2x
         hgaORj0QnqESsu3tpH3B/rekHowJkpyfGBQJK4fEMuVp55GiLr5QO0fQT5NmsyPbnYUb
         lTLHNJ9Y3kI6u5EtFBqJdVF31sCR36889FWnY0CV2C5D5fx3wA6FB2noxvrnD1shal8q
         mRu6TpoGJcKF3IqyS3Py77lLg0psJrthUHRLtgnjV4oywJVmlCRq+UIERgj26Tym/SM0
         xCDsY32p8kCxtWOwy42s2OBtcYKX0Q8eA5pw09Z7NgdvUsK8bbzbb2yyzNIPKPn8OAgX
         pr9w==
X-Gm-Message-State: AOAM531LGouJCS8SA1zFFIAhcA2Jskf9+GlQuJEqgGoO5XMqrD5/VR3b
        4xBJjpRkVPFlF7v+uYU5h/Pq2RnFKAO0j0CyAps=
X-Google-Smtp-Source: ABdhPJzzRT6wEroaz/dslf5pCkAStIq+O9kW535Kcah5KbIMtrs+QsMe92UreLHK26CFZPqytYQOTfBkbu2VJRDC3Us=
X-Received: by 2002:ad4:4baa:: with SMTP id i10mr7130204qvw.163.1592539097727;
 Thu, 18 Jun 2020 20:58:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-7-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 20:58:06 -0700
Message-ID: <CAEf4BzY7207CWet_csENUznXESvy9SrQnfzu0PCXmAdHUO0rJw@mail.gmail.com>
Subject: Re: [PATCH 06/11] bpf: Do not pass enum bpf_access_type to btf_struct_access
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> There's no need for it.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

It matches bpf_verifier_ops->btf_struct_access, though, which, I
think, actually allows write access for some special cases. So I think
we should keep it.

>  include/linux/bpf.h   | 1 -
>  kernel/bpf/btf.c      | 3 +--
>  kernel/bpf/verifier.c | 2 +-
>  net/ipv4/bpf_tcp_ca.c | 2 +-
>  4 files changed, 3 insertions(+), 5 deletions(-)
>

[...]
