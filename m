Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D84DF8CF
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 01:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbfJUXvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 19:51:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35934 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729718AbfJUXvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 19:51:49 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so14569918qkc.3;
        Mon, 21 Oct 2019 16:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fA4DzDDb37GYRX8f6lr/tfBcE+7lANGen1uqlYoMgbY=;
        b=mCsynA1gw+aJlECQMFhALlINbYokkCa3E4wiYNoW8qxrLFW5n3zZN6YpeIouCXK/Et
         3HkDIwp24jMpW+wBrR+N4mDFIOUkFO4Ecb5Htauf8oDeC5uP9M6GkYjwGBFKVubMoyXx
         vaWQN+aOIZIFT8+uySzmHHNs+eyVWKYDXDM7BaHgGoDzfNPidVLcgX8tkDQDjP2I8M5Y
         j9fESHpKvfHNWGL0FbsB3Z7OZVmdIdrd2PKF/fb9ifOEeUrqyyzs90C4jM57SaypDfRI
         +nA6Mb0x4ZEnOsAXJuOQR9vvUZiGNpOWw6Q1m1PgpVpzmV2Gvi1O/30Z5R21bZZYkgwH
         dhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fA4DzDDb37GYRX8f6lr/tfBcE+7lANGen1uqlYoMgbY=;
        b=VIfeVC6cOzGZMemgfPnyqMYDN8y6g4vJXnty+lEb6/yTH/aLC/b10NHwKXOHyRZ4xV
         A14emG902lalf9/R4wC94WOrAbfat2tfHNYa2A1faFcsy3fyZysK7mp6FX6gFjmnN2pv
         g7QQNi/CbNvhKdrCAQKleHybDrxx4KoQLfY73R/Kb5Z+Gw8E76LbR2Jw6Ubx9JDbbULu
         lPBUnLURvfui+jeVrniN/c6zsQBWOhPikjcrMjlynbaxc8bLFrSGIqEl53v2CU2vNoAC
         oeHeOln0WnR+MPYQnqJJ+/E/7p7jmfP8d7C+cvsEDwiohgUEegZiOuUkdL0XykV3mN75
         zYyw==
X-Gm-Message-State: APjAAAXmrJQOxNqRaMQwnsQM2Cpje2WR5A4LdeNVMGrgrtAoP7mo4MU2
        d7T25mj9utpmaD5Lh2a6bylYsBSxOcdhJ2sr0Qs=
X-Google-Smtp-Source: APXvYqyV4vFZJo0+46q04SFCB99PTIJPmsBHtX8WhycAClyoIL50nFDuFsQN9/76B0KjH/vOL7JT4EoaRlEpfnnYNHU=
X-Received: by 2002:a37:b447:: with SMTP id d68mr415313qkf.437.1571701908286;
 Mon, 21 Oct 2019 16:51:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191021165744.2116648-1-andriin@fb.com> <87mudtdisk.fsf@cloudflare.com>
In-Reply-To: <87mudtdisk.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Oct 2019 16:51:37 -0700
Message-ID: <CAEf4BzaWEJ1t-4rB9ZftiSEdSBToAjFvnheo2z+H+OsG=BqZzA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: make LIBBPF_OPTS macro strictly a
 variable declaration
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 12:01 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Mon, Oct 21, 2019 at 06:57 PM CEST, Andrii Nakryiko wrote:
> > LIBBPF_OPTS is implemented as a mix of field declaration and memset
> > + assignment. This makes it neither variable declaration nor purely
> > statements, which is a problem, because you can't mix it with either
> > other variable declarations nor other function statements, because C90
> > compiler mode emits warning on mixing all that together.
> >
> > This patch changes LIBBPF_OPTS into a strictly declaration of variable
> > and solves this problem, as can be seen in case of bpftool, which
> > previously would emit compiler warning, if done this way (LIBBPF_OPTS as
> > part of function variables declaration block).
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> Just a suggestion - macro helpers like this usually have DECLARE in
> their name. At least in the kernel. For instance DECLARE_COMPLETION.

Yes, it makes sense. This will cause some extra code churn, but it's
not too late. Will rename in v2 and fix current usages.

>
> -Jakub
