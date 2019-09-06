Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D2DABE3B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 19:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395128AbfIFRDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 13:03:36 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33463 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfIFRDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 13:03:36 -0400
Received: by mail-lf1-f68.google.com with SMTP id d10so5656867lfi.0;
        Fri, 06 Sep 2019 10:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pFej4wxE2EVtTNCk/OMsOq0HtvX92ziQW75AuLpO0jI=;
        b=fCCbdpy0J2LVqBogsZvHd2IG/eeEvMSdJuJyiUhWz51mAnlaODNNrEmPPnNFK+D4bI
         o/57TFe5dlo9TyPgJ4F0Qncz/i6ZdxeZF3ne12SZiOJgDqxoMxU0ewUshIo/euqMWKZk
         0oZGNrmxloGU073Yg3gFIN+vBJfHGpAai2ypRMucmx7pgcit900qUVTTk5Z3InjlQ2Va
         Ns9bycXRH7qBkerZQWGT9OZ4TDQN0awp4N95C+xXCkRj4Y1iDvdAassDH0sYCQRF3pln
         69S8R2O3LxNukNTEEyCmuAcmCu+n7etOCpAuyv/ccIPfFWx4SbqMx6lRhHSsY5SWzHDF
         Jqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pFej4wxE2EVtTNCk/OMsOq0HtvX92ziQW75AuLpO0jI=;
        b=OFWjvO7lwfvqUjdzB01YbU67DWuxbm37yBU9BnKd9qNZGFEM5/RBAISKT+vLWUhf6v
         RQYU4QO4+tPk5tb7KqO9oDG6hF9IN44p5ycRlUqYCRqq5RxZ2gQ/cB0TC9vF9cgOAlXY
         XiICwYx4JDeynhUK3l9D9icxy5ReIcdjLoL+j9yMJhA4acspAsTHoluIqX5Sg5X8D81Q
         AQ9yfJpeHRL4UMr+JRryCsdy7C+GqfYcPqldn8446JSQW3CNy5lQ+sRlH9If5jOpYDF8
         wMElNp5WJvPxpQGjuYZHC/q5jjxsT3XED5P/Qn4STh55pXqKudOiVB5DQQAV5gVVDsLW
         BOng==
X-Gm-Message-State: APjAAAU8h404SrcwxMltfEVx0RwPz/cUeptaGRNy1ZteBqTElA2eI8bp
        Gh+Ben8iZV3/9BUlk15VyTh4TWS5RSzv4gYFxJo=
X-Google-Smtp-Source: APXvYqxGJHRmSFcPOHRRO9SHFvrZgGiX9ePQ4dMJWMmgTGarOHsAXny1n4pTLxjwE7yQJ+35p0sTchMdLiR2Nh0VJWs=
X-Received: by 2002:ac2:4257:: with SMTP id m23mr6994101lfl.6.1567789414485;
 Fri, 06 Sep 2019 10:03:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190906073144.31068-1-jolsa@kernel.org> <62e760de-e746-c512-350a-c2188a2bb3ed@fb.com>
In-Reply-To: <62e760de-e746-c512-350a-c2188a2bb3ed@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 6 Sep 2019 10:03:23 -0700
Message-ID: <CAADnVQLgzkyGU35_L8yJ-XhEBkKtZcNtWGL1B9S=_vdnAnHhzQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] libbpf: Fix cast away const qualifiers in btf.h
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 2:09 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> On 9/6/19 8:31 AM, Jiri Olsa wrote:
> > hi,
> > when including btf.h in bpftrace, I'm getting -Wcast-qual warnings like=
:
> >
> >    bpf/btf.h: In function =E2=80=98btf_var_secinfo* btf_var_secinfos(co=
nst btf_type*)=E2=80=99:
> >    bpf/btf.h:302:41: warning: cast from type =E2=80=98const btf_type*=
=E2=80=99 to type
> >    =E2=80=98btf_var_secinfo*=E2=80=99 casts away qualifiers [-Wcast-qua=
l]
> >      302 |  return (struct btf_var_secinfo *)(t + 1);
> >          |                                         ^
> >
> > I changed the btf.h header to comply with -Wcast-qual checks
> > and used const cast away casting in libbpf objects, where it's
>
> Hey Jiri,
>
> We made all those helper funcs return non-const structs intentionally to
> improve their usability and avoid all those casts that you added back.
>
> Also, those helpers are now part of public API, so we can't just change
> them to const, as it can break existing users easily.
>
> If there is a need to run with -Wcast-qual, we should probably disable
> those checks where appropriate in libbpf code.
>
> So this will be a NACK from me, sorry.

Same opinion. This gcc warning is bogus.
