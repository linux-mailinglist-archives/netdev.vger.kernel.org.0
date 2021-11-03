Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2844447BA
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhKCRwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhKCRwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 13:52:30 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DC2C061714;
        Wed,  3 Nov 2021 10:49:53 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so1992244pjb.4;
        Wed, 03 Nov 2021 10:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pPvNZoulhiJWCQBU4zryUvX6Xw6xIu9z8BZ3Chcznm4=;
        b=gpawBxrRZngZIixIRKHyKRtR1WgFW2ojfyMQDjsOpC++wIjSzRyaFaP07qFWvCBVJ0
         w09HXzjMctEV21CwOW+TWEmzuLPyuECfp/2c3weqPltbM7e8pPWEndEWoH1sz98pgGmO
         n91iedxHJRVjnDnHWHDDzE9HrvdRIE1pqK3S5sp5r7WnPybj1jPUE7oShKghf2atpZAD
         e/dKIQYxtlNE0dbUHKNLv9tka4BMpgnwDUlWJow8DjcvYfcwo6J9g3HjxcRBgfbcNxl+
         8mXCQ+OzVlIGbvhdMn2GxBXVqP0amXRmZYcmGmzUIFmBs2dr4m74viUPzcOd0fIffcMq
         YFYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pPvNZoulhiJWCQBU4zryUvX6Xw6xIu9z8BZ3Chcznm4=;
        b=MtpNFDYShZ0+68eQNEAJPtbI9CpfO1qExhaJQz9cwlLLhizWOykS0YNZfsTYc1Ajw0
         6GuXX4iqxhYrKI5Jgu2EJl/NhWW5EYWGGKDnfDV73n/Tp9bgC4ZNn+FH2IPY0KlLDKaR
         PB2FdHnW05NBG2hcijKWYZbRGHeVGdqGCDwjBBHuLUN9IvsIa+MuhbCcKRsMOed139lo
         8SfpvHpg4vQAxRe3SybpzORJZQ+BBXcvvhWqcjj4tNEe/CqNJ4wMZsJYKjUYrVZrlThU
         j74z5Vbo9EAn8pw+X0iYz3sLV7uQ9bw9orZlKAXi8lRg8VlUsjHmFWiJzkl4NOUT6G49
         AS3w==
X-Gm-Message-State: AOAM530UMw2+PZWmB9lOa0ZNZHUgM0gVw/faa7MTCe3yvkhreWMEhZBR
        /6cr+jYu1b0jRfaQPy48lkWRk7WuW8gWd+LEA2XP8uSD
X-Google-Smtp-Source: ABdhPJwBy+n5eAeWFPR11/hBk/8XrZoz5ZTgXkU5n3+s8oDYIi2gp06Pm/KfcDO30PcR3yJ+Vddht3b6BoYbg92it8s=
X-Received: by 2002:a17:90a:6b0d:: with SMTP id v13mr16206841pjj.138.1635961792997;
 Wed, 03 Nov 2021 10:49:52 -0700 (PDT)
MIME-Version: 1.0
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
 <20211103001245.muyte7exph23tmco@ast-mbp.dhcp.thefacebook.com>
 <fcec81dd-3bb9-7dcf-139d-847538b6ad20@fb.com> <CAN22DihwJ7YDFSPk+8CCs0RcSWvZOpNV=D1u+42XabztS6hcKQ@mail.gmail.com>
In-Reply-To: <CAN22DihwJ7YDFSPk+8CCs0RcSWvZOpNV=D1u+42XabztS6hcKQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 3 Nov 2021 10:49:41 -0700
Message-ID: <CAADnVQJ_ger=Tjn=9SuUTES6Tt5k_G0M+6T_ELzFtw_cSVs83A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/3] Introduce BPF map tracing capability
To:     Joe Burton <jevburton.kernel@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 10:45 AM Joe Burton <jevburton.kernel@gmail.com> wrote:
>
> Sort of - I hit issues when defining the function in the same
> compilation unit as the call site. For example:
>
>   static noinline int bpf_array_map_trace_update(struct bpf_map *map,
>                 void *key, void *value, u64 map_flags)

Not quite :)
You've had this issue because of 'static noinline'.
Just 'noinline' would not have such issues even in the same file.

Reminder: please don't top post and trim your replies.
