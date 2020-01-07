Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01069132004
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 07:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgAGGwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 01:52:02 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41760 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgAGGwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 01:52:02 -0500
Received: by mail-lf1-f65.google.com with SMTP id m30so38065162lfp.8;
        Mon, 06 Jan 2020 22:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WUnO+radcDoArHUxgY/LqGVsNr7soHSA+IuBZIqQcIk=;
        b=OswjlB0+mvHFQ7VjpegU5m7dK61DFSydo/6/E18tQRfS94B3kqMk4IUuUb0880SuC7
         CtUQ9zxX1/AukkI8C8ugs7CsT7OdtYlkdFGZKBY922rcdnXgQLoQv/OUga1JhHbmoU0f
         bePjw0urMLkJaaoV1iQZ4ieAulDYNKUpXJZcsA9vUyJ/W+Eu3fBphRObpdRWU2YdgJtn
         cQX+z4CESHsSyBWttKiw6W18nCooOooY55qC3dVej1Eec62yWaBv0Qze1BPaL2zqaeuT
         tdna7fpLGOin/0zMsMfo25E/xJRBlc6At61vrOdbcJhYeDozQ9Ra2F9x3amgACZ3QPPe
         0UMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WUnO+radcDoArHUxgY/LqGVsNr7soHSA+IuBZIqQcIk=;
        b=mYuya3GC4p278QJRJYidwz1e4bhk9WIFJ0LFs9aFobE5BY/9EpZq/sRH0Gx4GsHKLQ
         dBZBr6yGZsePczxiF6+on7LsNxp4aYxz+EDwxLYaXi/9fJ0M336qcDqWrfKq0mnwRLOV
         FqKndsLyZvNGE0YhQQ/CH+dE7vmy1mNIOhaDh8TQdtUJQfNuIrOGg1XtKlJBu76Ckd3q
         e8I0OuegSrKh4PTxJqZCCZ2mgEBd5iMO7mPneZqArj1RXxr4DkrJtq2H76C1kePDaMdj
         EImmM1DRiIoyuMoW0Ksmmr1IUWYP5K/uyPHaug6nDzB3EilwZ2SdPPlfXd29K534y2f5
         +FXA==
X-Gm-Message-State: APjAAAUMZDFJCjlrlOm4cHRzb19v1kW6v5n3r1dS7C6I2DR/S4Po5aRE
        lgFJ+pEU/wbxCgvBLpnP9OrbL4doX2TE/Fy6hF0E7A==
X-Google-Smtp-Source: APXvYqxB33hvchxJV9c5VTYOx9pur7scggA4RYgB6JrpNzrL5mYN0Gy3eAnRA8wJk8Mt48gtPpjFVAWmsShm7Iryuj0=
X-Received: by 2002:ac2:4436:: with SMTP id w22mr58809295lfl.185.1578379919959;
 Mon, 06 Jan 2020 22:51:59 -0800 (PST)
MIME-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com> <20191211223344.165549-9-brianvv@google.com>
 <CAEf4BzaeLV8EkGunioqD=sn0Bin4EL0WMzp1T6GjdBajWaFQ+w@mail.gmail.com>
In-Reply-To: <CAEf4BzaeLV8EkGunioqD=sn0Bin4EL0WMzp1T6GjdBajWaFQ+w@mail.gmail.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Tue, 7 Jan 2020 00:51:48 -0600
Message-ID: <CABCgpaVEXW7Wa9hKn3Dymbt5Lu_XNia3S=akk6tG+8zWQ6=cHw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 08/11] libbpf: add libbpf support to batch ops
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for reviewing it, Andrii!

On Wed, Dec 18, 2019 at 6:54 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Dec 11, 2019 at 2:35 PM Brian Vazquez <brianvv@google.com> wrote:
> >
> > From: Yonghong Song <yhs@fb.com>
> >
> > Added four libbpf API functions to support map batch operations:
> >   . int bpf_map_delete_batch( ... )
> >   . int bpf_map_lookup_batch( ... )
> >   . int bpf_map_lookup_and_delete_batch( ... )
> >   . int bpf_map_update_batch( ... )
> >
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
>
> These libbpf APIs should use _opts approach from the get go to make
> them extensible, but preserving backwards/forward compatibility.
> Please take a look at one of few that are already using them (or
> follow Andrey's bpf_prog_attach work, as he's adding opts-based one at
> the moment).

I will add this to next version.
>
> >  tools/lib/bpf/bpf.c      | 61 ++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/bpf.h      | 14 +++++++++
> >  tools/lib/bpf/libbpf.map |  4 +++
> >  3 files changed, 79 insertions(+)
> >
>
> [...]
