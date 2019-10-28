Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A38E7A91
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388493AbfJ1UyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:54:19 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38003 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJ1UyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:54:18 -0400
Received: by mail-qk1-f195.google.com with SMTP id e2so1352101qkn.5;
        Mon, 28 Oct 2019 13:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ELFM7hs7CuuuKZAdnwtMxunSGfP74t02oivKE3X+k/I=;
        b=Vjcs/dfM9W6Rjh0ZvrvJsgLzY3MijGyij4P7qrBvA5TsXM2ZhW4pVsFT2Gj28DGud1
         bbQ2qtb1C/Rl7QoNC5SGUHSxZ2D27rrqaq7ajJ5t6hgIo0Dz5cwXENlQc1oWNpUwP7i3
         oLrjix4MJwInv6vTcki1RSv3mOwQ/dw3jZUfinNMaOamslEEqWkg7EQdagh4woKJmvWU
         hGbZHHk5UQzNtLWldWO/mhXHExXDvR2V3Kf4khlZUl7N11A1Yggu+4z4KieE2Sa40CfK
         CULhkREGV8vLDtHTLuX34iGOwwbIEiTz70BbkEB6DsuoQBmJxflEGFWeuv3br8B4ugBd
         bt3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ELFM7hs7CuuuKZAdnwtMxunSGfP74t02oivKE3X+k/I=;
        b=G9GC9+BIovpKVZcap0OyTZld8kj4DsDt8cddzfqzPeIkrFFH6b6px/1zJ9pfHe3Z5F
         fmmIrUEAl3Kv4dK6qqJ6L7xI5Ej/WOmSZ6b4SEyIpsCJpNUPemGOfMlEOqUmezYn36Rw
         M5Q3KCyCx0MD6cDsJEB1tRGTeDKcsvC3rdhAJ04sEgD00yJwoRh9RpGk2y5DCDuke8L7
         4oB3OqyZ0Vv7YX0Yfia3sR+Sf8quig5f5POmfDkuvj7cQ8GWQ+nMcZKbo459LHZXwZv3
         z9wSoWzeteK/jjO1r/MPySZ6TAwhRnND/yBhZAO1uD8pgQpo59lzbahHRlUmnGfd3yQF
         ckTQ==
X-Gm-Message-State: APjAAAUhhQr/Zeh0hczOWYhE6bgd5HFDgbdJy6rgm7pSeBlTiPpQlALG
        +e2A1wze9S7iiP65KFV1KKtFWqjiGticpWjGC1WWk7k3
X-Google-Smtp-Source: APXvYqzwSXznPpcqOt4g32qV5OQYKyieOMOxaiFdl3+jkuAgACK41q+X56rvjYLZ30DHhTRDdo0mD8vkiDN0ZwJNPEA=
X-Received: by 2002:ac8:6f27:: with SMTP id i7mr466326qtv.359.1572296056426;
 Mon, 28 Oct 2019 13:54:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191025093219.10290-1-bjorn.topel@gmail.com> <20191025093219.10290-2-bjorn.topel@gmail.com>
 <20191028110056.17eea9fb@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191028110056.17eea9fb@cakuba.hsd1.ca.comcast.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 28 Oct 2019 21:54:04 +0100
Message-ID: <CAJ+HfNhoRy=mEw=qNRCYwjcn+cANb0wTO4kgs=iU4W0bvoPyVw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/2] xsk: store struct xdp_sock as a flexible
 array member of the XSKMAP
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Oct 2019 at 19:01, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 25 Oct 2019 11:32:18 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > Prior this commit, the array storing XDP socket instances were stored
> > in a separate allocated array of the XSKMAP. Now, we store the sockets
> > as a flexible array member in a similar fashion as the arraymap. Doing
> > so, we do less pointer chasing in the lookup.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Damn, looks like I managed to reply to v2.
>

No worries! Thanks for taking a second look.

> I think the size maths may overflow on 32bit machines on the addition.

Ugh, right. Re-reading the older threads. Thanks for pointing this
out!I'll get back with a v4.


Bj=C3=B6rn
