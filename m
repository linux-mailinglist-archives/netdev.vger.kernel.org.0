Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59525133F41
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgAHKZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:25:54 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:34282 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgAHKZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 05:25:53 -0500
Received: by mail-qv1-f68.google.com with SMTP id o18so1175790qvf.1;
        Wed, 08 Jan 2020 02:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5kbM5RsKRx6o6YhmJGGhhIaTRS4GFp+h2/QR0XZ73Ao=;
        b=lmd5bAqtw7xLmMGBWZdPFQQQ/0oI83XWYe3k8aiJ0Q8bg6QLYY1mY1tSr5denSl7f5
         qjx3KjKykLh5E13C2h7sulU2vUtCnMEqZ+QC7TbP8CZP11I3AGmdRj6DvQ30CdspZ53A
         Nn6KM+jcZCMnWnBJ/GrjoInPVrG7YnPS5K0vag/4x/cyx1MzxwyULjd0x+oRy34tYuvH
         t49AOtr3UmVOR1o2UXk9zVs7Gmz8l8sSavxtiAkA69esCKjmzy5DWk4iK8lny2OHmajy
         5Exz7QaUSsDTJlkgN0jyq7otrdDeB67/GvMT8VlH09/SdVdhAglRW5h9tdgiP9sjm2Tq
         WPhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5kbM5RsKRx6o6YhmJGGhhIaTRS4GFp+h2/QR0XZ73Ao=;
        b=HL17YbpoXId1VDTVdtMhree4dnEywiQk8nHbSiXjSN2c3sFhM+Ks5DMGHFx8iEAd1G
         FAnBo+cgJQbWxEQ7DPssEzI6oEG59Ar/2UqUUYtxWSEKASi63gNx8wYH9jKk8+NdCO2e
         N83Bh8VUut/tJbctmKgUKDGCr2K4t65n8cCADdH8l0HduJ1tcyG6GdZQLrbTeOBwLb3p
         E9vTjVvtlPJzj/453/8w80GtfHWlhpcUeXWDDTHG9ct8l1Ok3/88gxBUsi5cNzwNE2T9
         XSO8VAGOIInsEyLtNIkocn0iXlzh5LNXgrL+L3IZREc3MrA/KwJYKGfxiNsW4O59dY/8
         beLw==
X-Gm-Message-State: APjAAAXm0TjjvTxONUJsUB5f7uI1tfai7PnkF+ZZ4aUhCZI7lj2fUL+l
        CJNd6rcMMZwMEsi8KnSCOQWPV8k0cacYc0vVyVQ=
X-Google-Smtp-Source: APXvYqxCzs2gM9Z7fy9FySROdzPlsTk0sHDetpwvMbYY26rn48AE7SjgOSYS4ruSRv2KT/cF3ADEkwmCGjdvLPDGuFc=
X-Received: by 2002:a0c:f748:: with SMTP id e8mr3435577qvo.233.1578479153019;
 Wed, 08 Jan 2020 02:25:53 -0800 (PST)
MIME-Version: 1.0
References: <20191219061006.21980-1-bjorn.topel@gmail.com> <20191219061006.21980-6-bjorn.topel@gmail.com>
 <5e14c6b07e670_67962afd051fc5c05d@john-XPS-13-9370.notmuch>
 <CAJ+HfNg2QFfhrwuEkZJjTKEYHhd1ByHgfmSp7wtwN_w2qB4rqA@mail.gmail.com> <874kx6i6vm.fsf@toke.dk>
In-Reply-To: <874kx6i6vm.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 8 Jan 2020 11:25:41 +0100
Message-ID: <CAJ+HfNim-W57KYpsYE3hu4iXa_EtjtvURHqh6iSmVHdi0OcsLQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] xdp: make devmap flush_list common for
 all map instances
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jan 2020 at 11:23, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.=
com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
> > On Tue, 7 Jan 2020 at 18:58, John Fastabend <john.fastabend@gmail.com> =
wrote:
> >>
> > [...]
> >> __dev_flush()?
> >>
> > [...]
> >>
> >> Looks good changing the function name would make things a bit cleaner =
IMO.
> >>
> >
> > Hmm, I actually prefer the _map_ naming, since it's more clear that
> > "entries from the devmap" are being flushed -- but dev_flush() works
> > as well! :-) I can send a follow-up with the name change!
>
> Or I can just change it at the point where I'm adding support for
> non-map redirect (which is when the _map suffix stops being accurate)? :)
>

Even better! :-) Thanks!

Bj=C3=B6rn
