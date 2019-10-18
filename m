Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 511E4DCAFB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437362AbfJRQ2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:28:41 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38530 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732948AbfJRQ2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:28:41 -0400
Received: by mail-qt1-f194.google.com with SMTP id j31so9926087qta.5;
        Fri, 18 Oct 2019 09:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tN9oYHiUwoH1r7uqZMD+ykxqZWmlQKOgWRW4Qq2HjJY=;
        b=oeZcOscZtpWxgbAnVrlRee2Jh9eYjtLOUOTbI/yTDxVm+ysmgEuDSmn+3XP40OQ4zW
         NxLZOD5Pzs4gDDDKRQp52Oi9RuSPGkkSHK5MR+mgGQla7koyzJ5LgbsziogM8LDwKRkF
         DH77c0o3wUNC63tu9mKQcIrLLSrXUGqMX1h6A3pTHRL0032FzWrcA3JzFgzLEqzoecgB
         fYAg2kZeYPQdPH37H4LHIdxQOtnw7EhZPerfigUzi6KszDXFWY6gG9H44ssnAEDc5JtD
         L06aWj7VWuhhm/JBJC7+DW30w1TVJTM4nxMv9oW62GGINJg78DK05WEg6WMhF9cqMbku
         4Hog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tN9oYHiUwoH1r7uqZMD+ykxqZWmlQKOgWRW4Qq2HjJY=;
        b=cKFk+12YGpCadouKKAiUqyExddPy/FUXj8IVAFzvvaSyJ3tEf32X8hdgtquz/PxONv
         nvaVxr/JYR016dVU51hI6xVEP+0uV6zdTVpZMBDEMqoWJC9FgN5nEcWjDQ8inUmqcq23
         tKmnb015lFjoq2kcJWjKea53HaZO6TmhgVBCsCoJfTmdna5lHiAOcpCUDqRXf2j2OqsO
         1HMBEGHevC1me7dCR/hjo5/dOIBleh+XzAgwdREhgt4T+HEJO3bILLpNDtjVSVc4r7gw
         vSwG1P4cJh/ooPIeGQNZ3Fea6O9D9ZzNMPpRp5rZwItyLWlB07uSH7a5IHZjmSv5KVLp
         gVdg==
X-Gm-Message-State: APjAAAUVCaeADGajzb+D4BEM5zZFx/tT/k2ivmpXnpB0KFBqqcfOJFIQ
        imPpgC2TJo1CF3VZLWUg8tIwQiCVVA2Mmi/OKfFI1Pii
X-Google-Smtp-Source: APXvYqzJIBq0VJxAq6m1hqAL8EDuc3igKbSADUc4R5M5t6LhuntyyzpTkN8grkBb8J50b3I9Sfjn/1l3sYizNhICstQ=
X-Received: by 2002:aed:35e7:: with SMTP id d36mr3449210qte.59.1571416119718;
 Fri, 18 Oct 2019 09:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191016132802.2760149-1-toke@redhat.com> <CAEf4BzbshfC2VXXbnWnjCA=Mcz8OSO=ACNSRNrNr2mHOm9uCmw@mail.gmail.com>
 <87mudye45s.fsf@toke.dk>
In-Reply-To: <87mudye45s.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Oct 2019 09:28:28 -0700
Message-ID: <CAEf4BzZxszYrXCEpDqe6Gi9FggUOnDiQjP9BQTq=EcszwSghKA@mail.gmail.com>
Subject: Re: [PATCH bpf] xdp: Handle device unregister for devmap_hash map type
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 3:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Oct 16, 2019 at 9:07 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> It seems I forgot to add handling of devmap_hash type maps to the devi=
ce
> >> unregister hook for devmaps. This omission causes devices to not be
> >> properly released, which causes hangs.
> >>
> >> Fix this by adding the missing handler.
> >>
> >> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up dev=
ices by hashed index")
> >> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  kernel/bpf/devmap.c | 34 ++++++++++++++++++++++++++++++++++
> >>  1 file changed, 34 insertions(+)
> >>
> >
> > [...]
> >
> >> +
> >> +               while (dev) {
> >> +                       odev =3D (netdev =3D=3D dev->dev) ? dev : NULL=
;
> >> +                       dev =3D hlist_entry_safe(rcu_dereference_raw(h=
list_next_rcu(&dev->index_hlist)),
> >
> > Please run scripts/checkpatch.pl, this looks like a rather long line.
>
> That was a deliberate departure from the usual line length, actually. I
> don't think it helps readability to split that into three lines just to
> adhere to a strict line length requirement...

Wouldn't local variable make it even more readable?

>
> -Toke
>
