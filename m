Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C93711E6EF
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfLMPtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:49:16 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34731 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbfLMPtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:49:16 -0500
Received: by mail-qk1-f193.google.com with SMTP id d202so2418351qkb.1;
        Fri, 13 Dec 2019 07:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Gsc6a8n1oq89OaeyrnkAHq66uYj42sNcEqmul1hr5nE=;
        b=QjWAuw7ObThExIdvmqhyAt/ihAFjyqCtI3GHXQPR56Mgd4N6ukVP4Fvtll6L1fEO/O
         E0m0514119d9Wo8P+CyBRBSGQv/3beU63PLaQMQmMXyfux52BWwMbzuSG6iIEm4C3TcC
         IBmLox0uTeGjgWu1AFaMWYNNf9chD2ywwhjyX1kO+eQ259IblAqHGiSZEbPOA4jnMxj+
         ci8JKdXofMYZacccbiEpI8d/wJNLu2iygJuJGBJyl0Z99bVZc+RQbcpp600j87adbd9g
         TXzJhu4eUSXP/5Qec53NNdObeQmgpljncCXnjsBXWnU9zvyLs464wTY3I9OVQ77Uqacr
         HBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Gsc6a8n1oq89OaeyrnkAHq66uYj42sNcEqmul1hr5nE=;
        b=pRchqWAfv4GoO/8LjXN0be2uaNeoxwJ7bk6KyRHBInvU31oEKxUgj4+V8YhabQZeIR
         w+F2ylK1KDdNvhwb0y7xQeVygI7pswREYOkXEmIUiE5FjCtdZu6nroKV015vpIv00Zrr
         3uIf23S1AkVElcIyio7F+xcFZEF58yn64qGEA9A3idlMwxzGQoNWNr2m8kMLF7JNGLBt
         E7PUDHSV3vCDVAz7A2mosv43tWx6Dr/FU5x7yHtmOI89w7C77sunFBTHr42xSflwqQ2l
         MojjSXQncVC4uRdnA41lo42QrTRxwoQevUSfAeL15jH3Cck6j/CaPVDx+SUew6GXQ6JE
         QG5A==
X-Gm-Message-State: APjAAAUrKDKQBkEoCGPQdJ0OgKcd2ZjOA6b4PNXPonKMN8TTl5fACq7x
        OT7NgAQpWEURhyA/28pG/24fRHqqoT7NqybRw1s=
X-Google-Smtp-Source: APXvYqxoPs/7BEx0y3EmTpxmZwL5BCI76Bmp1H6flWSYOBBcrGpFrpjKZPIcWV3fG0jGpbxrHkdipwXSxaFANxxpFv8=
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr14169383qke.297.1576252155437;
 Fri, 13 Dec 2019 07:49:15 -0800 (PST)
MIME-Version: 1.0
References: <20191211123017.13212-1-bjorn.topel@gmail.com> <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20191213053054.l3o6xlziqzwqxq22@ast-mbp> <CAJ+HfNiYHM1v8SXs54rkT86MrNxuB5V_KyHjwYupcjUsMf1nSQ@mail.gmail.com>
 <20191213150407.laqt2n2ue2ahsu2b@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191213150407.laqt2n2ue2ahsu2b@ast-mbp.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Dec 2019 16:49:04 +0100
Message-ID: <CAJ+HfNgjvT2O=ux=AqdDdO=QSwBkALvXSBjZhib6zGu=AeARwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 at 16:04, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Dec 13, 2019 at 08:51:47AM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> >
> > > I hope my guess that compiler didn't inline it is correct. Then extra=
 noinline
> > > will not hurt and that's the only thing needed to avoid the issue.
> > >
> >
> > I'd say it's broken not marking it as noinline, and I was lucky. It
> > would break if other BPF entrypoints that are being called from
> > filter.o would appear. I'll wait for more comments, and respin a v5
> > after the weekend.
>
> Also noticed that EXPORT_SYMBOL for dispatch function is not necessary at=
m.
> Please drop it. It can be added later when need arises.
>

It's needed for module builds, so I cannot drop it!

> With that please respin right away. No need to wait till Monday.
> My general approach on accepting patches is "perfect is the enemy of the =
good".
> It's better to land patches sooner if architecture and api looks good.
> Details and minor bugs can be worked out step by step.
>

Ok! Will respin right away!
