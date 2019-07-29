Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF0679A72
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbfG2U5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:57:39 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42900 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbfG2U5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:57:38 -0400
Received: by mail-lf1-f66.google.com with SMTP id s19so43046189lfb.9
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 13:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lwj7xdkL/p1rXqDvCD2EivR7RM4u7oDcZx/DOnUaDOc=;
        b=uHQUxQQLnkUkYBhKI334hxbglwFlRSMffJAB6rhAICBaX3vOoO5lppQhroc24Okvfr
         V3zy4HmE+YXuAM+7KhhUctMpdF3jprKf1F7IIS2dW6m8DhP9zMoaVwcv6ccfHBuxtxjH
         4AHQ8rjxxrOzz7qqDlPmmMobiNzTwZWgcfStJXdCmd8GUHPImJieCMu7l6Wb0Dhbgi9w
         lCbvYxgSxTkmrofkKYElTNprbyg/YG9z6VFugrHzGv5qiT8kd9sxZbKF3j8I6t26s6Jk
         WnOO1cm4y73NdyOidBquTJkNCmvbqFya1Oip4Ao4JmeuNjYuPy2VQZF1XZ/dgAkVWPvU
         hIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lwj7xdkL/p1rXqDvCD2EivR7RM4u7oDcZx/DOnUaDOc=;
        b=mU9gHvHJ6oIkn9eqBTSeZxcWhe0ZXDLn8wobKbTwSl4R7sonWVvtk+aWIwMlvWTZBk
         b9K0A/x1Zvc3BOUTvr5Arul16tcz+wAlL/qBIdoSsx6Pgl2WKxTzB7BInqpwttQwd2Qk
         34GeQi2NzQOSLKxhXs/thkDbWYivtL0ickvjtr/nTGvq/swxAWVNHDVUrVkw9W6lOqct
         altS5IY1hzAvrONzeyRK420hXAUpGdA4wupAW1uQqy59wwlzEi1q1+96li4BR3URiHq4
         rv2kM64gVH9vttchbHTTqU5mmM5F2TNydYiSfc1D+4tMnaWziuh7gVEmpxiGmry5zE8x
         Kjpg==
X-Gm-Message-State: APjAAAWkFUPqAocSmxTJ3uf4haOKq7FprAE5wXyLM+32+JPeVdYKgfgt
        wR1nGGTxUu2ZsYLGteTQla/fLktRR4BMvYVJOVk=
X-Google-Smtp-Source: APXvYqxLqt/2QUtBs2zDbabGeMPRr01FTN1c81QG0sezwUDn89/3sMI9ReJls0aTmXUDEnP1h8cCExr+DGFKKjsuGoM=
X-Received: by 2002:ac2:4351:: with SMTP id o17mr32044502lfl.100.1564433856565;
 Mon, 29 Jul 2019 13:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <156415721066.13581.737309854787645225.stgit@alrua-x1> <CAADnVQJpYeQ68V5BE2r3BhbraBh7G8dSd8zknFUJxtW4GwNkuA@mail.gmail.com>
In-Reply-To: <CAADnVQJpYeQ68V5BE2r3BhbraBh7G8dSd8zknFUJxtW4GwNkuA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 29 Jul 2019 13:57:25 -0700
Message-ID: <CAADnVQLY3CUe3hdDMvEc3QiM6gLd6fEVy9vwDc38wpY4_wajxQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/6] xdp: Add devmap_hash map type
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 7:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jul 26, 2019 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > This series adds a new map type, devmap_hash, that works like the exist=
ing
> > devmap type, but using a hash-based indexing scheme. This is useful for=
 the use
> > case where a devmap is indexed by ifindex (for instance for use with th=
e routing
> > table lookup helper). For this use case, the regular devmap needs to be=
 sized
> > after the maximum ifindex number, not the number of devices in it. A ha=
sh-based
> > indexing scheme makes it possible to size the map after the number of d=
evices it
> > should contain instead.
> >
> > This was previously part of my patch series that also turned the regula=
r
> > bpf_redirect() helper into a map-based one; for this series I just pull=
ed out
> > the patches that introduced the new map type.
> >
> > Changelog:
> >
> > v5:
> >
> > - Dynamically set the number of hash buckets by rounding up max_entries=
 to the
> >   nearest power of two (mirroring the regular hashmap), as suggested by=
 Jesper.
>
> fyi I'm waiting for Jesper to review this new version.

Now applied.

Toke,
please consider adding proper selftest for it.
        fd =3D bpf_create_map(BPF_MAP_TYPE_DEVMAP_HASH, sizeof(key),
sizeof(value),
                            2, 0);
        if (fd < 0) {
                printf("Failed to create devmap_hash '%s'!\n", strerror(err=
no));
                exit(1);
        }
        close(fd);
is not really a test.
