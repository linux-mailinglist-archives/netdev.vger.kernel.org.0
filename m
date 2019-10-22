Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B6E0AD6
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbfJVRmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:42:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41571 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731061AbfJVRmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:42:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571766127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LpfkEMXmZt1WFPnGraTJgtnhIR/gR2WUdMmGfh42Rqs=;
        b=PYhs/uflRCSl5N25Z1jm5fEWmLWtHSL2khPoq3Vqk6Ng/oqjo8dBJha9/gFVoX6/Gs4nlg
        AqWrpJGLlfCwwCxKROppngjqdkGOIveOIkEuojJ60uNyR9emUVWrRnfslZMu4oR91/qPNp
        8/4PiVC9u0n+ZCdgA4RYy3Pha1wE1Iw=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-lhYnaVVtPlih12bUNv0GmA-1; Tue, 22 Oct 2019 13:42:05 -0400
Received: by mail-lj1-f200.google.com with SMTP id x13so3100249ljj.18
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 10:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=p4Ptj3uKdMq6GjmS+mQFiC7l4xjbjGQnVWvpWc/EejU=;
        b=XQeH1tyjvTr4gp3/DnHqTGanMfkBHkqKClbIgQtQLeKg7HKSFqha52keYqWtA8LOzs
         68muVp4HRpBRFtUFtc9b/b7SQZCKddDqxhsXs5wK3UyZyDdt0y8wz1a9ehAa1LpX5Szf
         kta0j11f6Qd1Rg2PMcxUQW7JKM29SG3HgW9NO95WsOKLpU5jYsUCpslvE5eLgj+1Ri1h
         ZNl01EQvvrXAQSNJ1zV7n37+R2pH8boj6qKY6p7elwXJS6Zu7x8l4sAn+2Z79OLcuWUx
         eWItv8ATgWwWcxg63ubiY6EpYaRWg8TODNtbr/TmiayzaZ8Jc8FNMrC6JW+2+ODslp4a
         +QwA==
X-Gm-Message-State: APjAAAU6ZUzhwEE25G0xU19WuicbQ46SPw5qA50CK01hYeymcV1K2cpC
        ibXOsc0qqIBHnSp3cHd3QoLe81FwZ8irXr7tmKlMKmslxbEwQ8gvO6pWr9XDDfiTZqkWqrK4GMi
        Ez2psDcDYBQKIgfmP
X-Received: by 2002:ac2:47ed:: with SMTP id b13mr15510531lfp.43.1571766123958;
        Tue, 22 Oct 2019 10:42:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwXH2l/yNrfKnO1j1J6tqaWWFT7bGLQEGy61vpzhv7Hh0Jh3G8Iow41oIQefEd4zdmGobctLw==
X-Received: by 2002:ac2:47ed:: with SMTP id b13mr15510518lfp.43.1571766123769;
        Tue, 22 Oct 2019 10:42:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id i11sm8998963ljb.74.2019.10.22.10.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 10:42:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0522A1804B1; Tue, 22 Oct 2019 19:42:02 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: make DECLARE_LIBBPF_OPTS macro strictly a variable declaration
In-Reply-To: <20191022172100.3281465-1-andriin@fb.com>
References: <20191022172100.3281465-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Oct 2019 19:42:01 +0200
Message-ID: <87imogoexi.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: lhYnaVVtPlih12bUNv0GmA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> LIBBPF_OPTS is implemented as a mix of field declaration and memset
> + assignment. This makes it neither variable declaration nor purely
> statements, which is a problem, because you can't mix it with either
> other variable declarations nor other function statements, because C90
> compiler mode emits warning on mixing all that together.
>
> This patch changes LIBBPF_OPTS into a strictly declaration of variable
> and solves this problem, as can be seen in case of bpftool, which
> previously would emit compiler warning, if done this way (LIBBPF_OPTS as
> part of function variables declaration block).
>
> This patch also renames LIBBPF_OPTS into DECLARE_LIBBPF_OPTS to follow
> kernel convention for similar macros more closely.
>
> v1->v2:
> - rename LIBBPF_OPTS into DECLARE_LIBBPF_OPTS (Jakub Sitnicki).
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


> +#define DECLARE_LIBBPF_OPTS(TYPE, NAME, ...)=09=09=09=09    \
> +=09struct TYPE NAME =3D ({ =09=09=09=09=09=09    \
> +=09=09memset(&NAME, 0, sizeof(struct TYPE));=09=09=09    \
> +=09=09(struct TYPE) {=09=09=09=09=09=09    \
> +=09=09=09.sz =3D sizeof(struct TYPE),=09=09=09    \
> +=09=09=09__VA_ARGS__=09=09=09=09=09    \
> +=09=09};=09=09=09=09=09=09=09    \
> +=09})

Found a reference with an explanation of why this works, BTW; turns out
it's a GCC extension:

http://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html#Statement-Exprs

-Toke

