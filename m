Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B87458E1D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfF0Wqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:46:30 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35994 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfF0Wqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:46:30 -0400
Received: by mail-lf1-f66.google.com with SMTP id q26so2674357lfc.3;
        Thu, 27 Jun 2019 15:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WbKFA8nfiqwP3WME3wq4eMlttkltsE/mXA4fzXKriYQ=;
        b=hDD5kwBiGAcqYYspA/gkDsom9D+MxR8UPLt+pOGqvkM0bH6CrYUe5CHlOtonvtJpU0
         1x60f+T+JUj/XSz9wkpykME8d4Zi0oyoLhXfV6yDJKcwYje3UUd+OLUmou+mBOfj6ebZ
         Cyj7779K7DExX8Zt8bLqO/YJm7WT9M/Ehj4U1sIcKCKh2QchPQIGwBSwQNgVQ3S3vCvr
         t8OYPz96rRNH9x2QhcvGXoqagPkdADen33w08Wk2Q9zvuRaqNX9pvwqR8GdG8A4XKfa7
         RTNzuKrSxjzAgJiurLvEVyyvDI9Os+jZsjGUXsCzvPS6Y6NMzYnmQeprIrZtH6SHe9cu
         3j/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WbKFA8nfiqwP3WME3wq4eMlttkltsE/mXA4fzXKriYQ=;
        b=l9gwBQmFdoQbqOSb0aBoM8sYRN6Co0a8CXaf+7SmyPoChJU7OFwzQQdEmjq4C+/KZA
         lgLqTx4HxiJ3Q6YfhDCVBVCh7Oycqj6KI2qdIUcS6tJzUYfw8QaUpmZUY2xecrfChZ7n
         S0hKrdLx7IHmkVy6DyerVMqBoLmEV0M2P6rhlctKonEg5llohsLVBRVLdCppdp1r74ox
         +p6Xfh4oGl1OBxhLhAVBExQ1C1p0ySAcNDfMzQvZLm/C2SrTGAfcQ3elEQ+sK+Ifzk6A
         Iq1KPnTHyboLSUckjuPVxAy9dXpkwt5E/gMgo/u+BKWJI1tzEIORB5+pZoTKU5G1lji1
         Ahtg==
X-Gm-Message-State: APjAAAWhZTaajtqEHvEZ6+6a7LpepQZxCnANYj+6gtGu+M77XaF8JJEE
        LxPcvUCclbU1IpQ7cnBZdobHvYkTRwR8kd3Goto=
X-Google-Smtp-Source: APXvYqy34aHCsARRvm4xYsFmMIg0chHSbLYWGtceKDo7o8C7OZGqwzf/ojSBfX6M784gbU8HN3922tl2bcyfF1jF9XE=
X-Received: by 2002:ac2:5337:: with SMTP id f23mr3391399lfh.15.1561675587735;
 Thu, 27 Jun 2019 15:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190627203855.10515-1-sdf@google.com> <20190627223147.vkkmbtdcvjzas2ej@ast-mbp.dhcp.thefacebook.com>
 <20190627224341.GE4866@mini-arch>
In-Reply-To: <20190627224341.GE4866@mini-arch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 27 Jun 2019 15:46:16 -0700
Message-ID: <CAADnVQLDqFghrL9rWG-=0H5=vbh-B+WbSr-VX4acO4bjUwyQoA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 0/9] bpf: getsockopt and setsockopt hooks
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 3:43 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> > There is a build warning though:
> > test_sockopt_sk.c: In function =E2=80=98getsetsockopt=E2=80=99:
> > test_sockopt_sk.c:115:2: warning: dereferencing type-punned pointer wil=
l break strict-aliasing rules [-Wstrict-aliasing]
> >   if (*(__u32 *)buf !=3D 0x55AA*2) {
> >   ^~
> > test_sockopt_sk.c:116:3: warning: dereferencing type-punned pointer wil=
l break strict-aliasing rules [-Wstrict-aliasing]
> >    log_err("Unexpected getsockopt(SO_SNDBUF) 0x%x !=3D 0x55AA*2",
> >    ^~~~~~~
> >
> > Pls fix it in the follow up.
> Sure, but I can't reproduce it with gcc7 nor with clang9 :-/

I see it with gcc 6.3
