Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF7E133F3A
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgAHKYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:24:36 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:36502 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgAHKYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 05:24:36 -0500
Received: by mail-qv1-f67.google.com with SMTP id m14so1168359qvl.3;
        Wed, 08 Jan 2020 02:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BtNhYrfDUm+S4HF4zqTlYJj0wMVZjXmP2Eqs3MbmR44=;
        b=G7MXDHuLHi58ENJD9AEYo49/bgozzcjjWCn7dbA7zl9KZbav/0A4/Eo9CWzCgREZn5
         TIsZIFbEiClqBGlr7OLhAl/edv+a/7t38FScnGiL1iRy3Efy1YUsvCNWfxdK4bSff6hw
         eOpa+I25TYfpZKpTIbvLhgP5gEhLZhjk3lJRftt8LWNKAABGzuHlnq3FWtrZQDzbt4Gb
         qEnSaWglWeqL6G5+uryhEseVqDKv/rfLZ4W3bXKNBZG/FQxUw6TKZttIMTw7TjzA4IM0
         C6Z1Cas4T1f2ZA/+6kR/KtbSXoPyc+nRtCq+nMBLdS7kFnfAy0x7AElcZnpGmU9SwoQm
         PD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BtNhYrfDUm+S4HF4zqTlYJj0wMVZjXmP2Eqs3MbmR44=;
        b=iXFiOePfYSEG25misic7WGEXoBye5+hk0eEKAkUyXa6FN9MVWPD2gi291qeUZM5AMU
         NP4RiKIRhvtPAatZlskjiIMa+zqefp64AJYiA5N8Ywz9bKuugDinP+soplaeKZPxRYlV
         o60hI1VbCLpYbA0Mcf2/JJTP3okLsbsuU801tgX18k42zF/SBAqsRHAFi3ZMOa04tziB
         48XCFBhTtDAkwN9IlY7OpJm6HdT06KTahEpvtiG9YxAOAMmbDCKY8Sh/0D/+QJCgvfhq
         UrmIpN52Cu6auhtHF3K8AuFwZWRCikw6dW4MaF/ZE79EBvBziGTO4FjBrmAMYOscMVLC
         JwUA==
X-Gm-Message-State: APjAAAWccgoqp9fsNTD2oAyvu1KtS7SLOcsekGBQl8MrMIeMEl14atWD
        DiD6BVHoQd//Rg5FPIBFX+Rkbfa5GHqLTRd6vok=
X-Google-Smtp-Source: APXvYqyeuajwKsOb/R4TAXeai5nAoY6NOG0wnnIURdexHJLl3nsxKa0PWEO6j8TbBYUgex7uDrbOPZDB8AAu+ERKnj4=
X-Received: by 2002:a0c:ed47:: with SMTP id v7mr3386256qvq.10.1578479075254;
 Wed, 08 Jan 2020 02:24:35 -0800 (PST)
MIME-Version: 1.0
References: <20191219061006.21980-1-bjorn.topel@gmail.com> <20191219061006.21980-8-bjorn.topel@gmail.com>
 <5e14caaaab6f7_67962afd051fc5c06f@john-XPS-13-9370.notmuch>
 <87imlnht6k.fsf@toke.dk> <5e15504b79ddb_68832ae93d7145c063@john-XPS-13-9370.notmuch>
In-Reply-To: <5e15504b79ddb_68832ae93d7145c063@john-XPS-13-9370.notmuch>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 8 Jan 2020 11:24:24 +0100
Message-ID: <CAJ+HfNgp1nGALS=yz_aZXgoUbL7TirzC0tJ7W-KO0_CMN-kByQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/8] xdp: remove map_to_flush and map swap detection
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Wed, 8 Jan 2020 at 04:45, John Fastabend <john.fastabend@gmail.com> wrot=
e:
>
> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
[...]
> >
> > This series was already merged, but I'll follow up with the non-map
> > redirect change. This requires a bit of refactoring anyway, so I can
> > incorporate the lock removal into that...
> >
> > -Toke
> >
>
> Ah I was just catching up with email and missed itwas already applied.
>
> I can also submit a few fixup patches no problem for the comments and thi=
s.
>

Ah, perfect! Thanks, John and Toke!


Bj=C3=B6rn
