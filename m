Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB97913DEB
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfEEGaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:30:18 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36441 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEEGaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 02:30:18 -0400
Received: by mail-lj1-f193.google.com with SMTP id y8so8229496ljd.3;
        Sat, 04 May 2019 23:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z6kO7dxsMMunnZKARKyE/0LnltVHVlMXkjj/mA+/oFk=;
        b=UAP36nyOe2ByH+5om3PIY6bb2LytGPegl2pdbrf+lHEtrVtTM1CcuX8tFo2z2FR+Mg
         vNZKygmXN/Rk3n7tIDKc3Zff5r7puDOeq/9QfgzrRBeR1N13nikcAr1X6WR1DAZygFz3
         fz6c84tlZQKs9uon9uyxghe6clzo3bc77vJnjfBNwIFNAJ+e2rToy+4hzmo/PAxJj7S9
         3h474cQyPIj/a2sFBs0A4Sm82lgz067TwCDZAr9UBUe95zkv0WtpZeo92bFlW7Dbn+8o
         8x0HV21XHZqpYZaKcCPnb+FDR0jUCii5TNBCdRQxzmUM/kVwAqYdrWYQ2tKVrTAOjE5Q
         uJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z6kO7dxsMMunnZKARKyE/0LnltVHVlMXkjj/mA+/oFk=;
        b=bzLDIF/m+vHBLlEz2BT7ujq5cSEZoVKztO4cQovVJ44Omj8CeesJ9dcnk3il6hYgVi
         I/QY137Na4Yodox8R93YCRduImB8IGJv/xr5jPlU+7B7P68YGLYU2OSuQLK9RLotQ3p6
         X4kEg7k6Il502dfu+b+4UAQ3Kw0/lgzI5fBPpUlyV1/1Nz6T8c7S98Fhl0NepQfZee/9
         Qt0UYIzdcvNEUc8CB910crJZwrNlPPKXXhF3+VSCq6g29fPvxu1qQQcxDen04c9B7vLU
         FANsMwQAbtM+kzh1d0co9B7b4lL5x57yonNNnIYEj/3kfvptoFDwqN4DBqLdyuSbAHDX
         ZaXw==
X-Gm-Message-State: APjAAAUpJhESuLdNqczuwCOlVRK/x6dgNAbYIcX2KemQdrXvpxc3HoJR
        8HZ5YVx8UilqjJa6BQvMMa287B+mf5bwHjFJeUM=
X-Google-Smtp-Source: APXvYqxuk6dLCFvzv+YmVVMA5/nC9GP3iucB/0qX55Djj1G/5n1TL1RiEvv4ZPGNbwcsDhR6bqdsttcBjCByo2JASQw=
X-Received: by 2002:a2e:6e01:: with SMTP id j1mr9183204ljc.85.1557037816106;
 Sat, 04 May 2019 23:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190430124536.7734-1-bjorn.topel@gmail.com> <15B5FD82-D048-416F-9D1E-7F2B675100DA@flugsvamp.com>
In-Reply-To: <15B5FD82-D048-416F-9D1E-7F2B675100DA@flugsvamp.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 4 May 2019 23:30:04 -0700
Message-ID: <CAADnVQ+Jas=-sJyPRDA-79EQFfZAzjJAiXLwxZUkmv9MS+dLmQ@mail.gmail.com>
Subject: Re: [PATCH bpf 0/2] libbpf: fixes for AF_XDP teardown
To:     Jonathan Lemon <jlemon@flugsvamp.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        bpf <bpf@vger.kernel.org>, William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 8:38 AM Jonathan Lemon <jlemon@flugsvamp.com> wrote=
:
>
>
>
> On 30 Apr 2019, at 5:45, Bj=C3=B6rn T=C3=B6pel wrote:
>
> > William found two bugs, when doing socket teardown within the same
> > process.
> >
> > The first issue was an invalid munmap call, and the second one was an
> > invalid XSKMAP cleanup. Both resulted in that the process kept
> > references to the socket, which was not correctly cleaned up. When a
> > new socket was created, the bind() call would fail, since the old
> > socket was still lingering, refusing to give up the queue on the
> > netdev.
> >
> > More details can be found in the individual commits.
>
> Reviewed-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied. Thanks!
