Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F226C34B42E
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 04:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhC0D6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 23:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhC0D6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 23:58:38 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39876C0613AA;
        Fri, 26 Mar 2021 20:58:38 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 8so7859465ybc.13;
        Fri, 26 Mar 2021 20:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dQfz+htambAa4BfG0XXL2X4dUD3Llux27n7VISLHCSo=;
        b=WWiOQDMLoDecyGhpEsXeCL5CbShRvX2A3MDAuV1XTucG4FpczG5e4Mdkso7SzSiQPG
         Sfit+tiZdfKlBdXBr+GYlOxEFheZVVrX75g2L5Yqk/a/A9VZw+8XbWJyEM8A+8JCy5ct
         lydo7vLGNv3BxoHwUkGbJMFeZr28OZslLVyr2lYRvgRmJZpY/kZsmO/Njk4/WKsWzdTL
         v3vNBrCxGkoY9uOMxgBEb5l4Puzw/7Ps9u3HZrWxbitNcNSq99HAoe+wMli290c3b18p
         6jT5DPGW805Ygkm7vcFUhyDneI6jMeni74wuKmVNi+aFSAXHthNjk7PMDv6J1Le0WotE
         kUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dQfz+htambAa4BfG0XXL2X4dUD3Llux27n7VISLHCSo=;
        b=dl6VsAfAV0MZwpM1c5aLaMMoNU+zZ3fkZT4RvTdbvVCEtLhakfRmiTpDaFSR5/CFW2
         2qDn5kYpCy/3zGBgW5HF84MEuGKxtjbBZ1SAFp7e74VBlFuOeETw0Rxd8XeghHWTpO6D
         vybobfUhLZCMHsHxEP05T+LRrc3h57tzwnB0XdiFsbWqsmPpeOsYwkE2UFQUm929mu4X
         GpKA+SywVioH1pLksRwv6vKPBdGwB+04Xw6y8jdVG8LBumQCpDLWzaelvyrsClyalFhG
         WjeQ8gu1BVRZR58G6Ett3Yfy1f6mtfo2BLVF77RTCHJv1h3okzFxlAHvSR/YLP4duFG/
         uYbg==
X-Gm-Message-State: AOAM532NFREGkT+j0cnISoBLN7nmcOeqybk51cegnFOCGSmuPEuIwaD4
        Reh4xPCGgqNxoDM2VicXY5i6HHfkwzlIWdOirwM=
X-Google-Smtp-Source: ABdhPJySVsmAYT7xz3px0vO6xDfIgbqJJVttAN+JMwK27Xf55MApnh4FFGvqxIt9+JN4kyNyxVmbxRVu6X859AoHstM=
X-Received: by 2002:a25:4982:: with SMTP id w124mr22866581yba.27.1616817517488;
 Fri, 26 Mar 2021 20:58:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-2-memxor@gmail.com>
 <CAEf4BzaVK4=vB6xaMc-VwhQagg6ghx8JAnuLsf43qZa_w_nyyw@mail.gmail.com> <20210327035406.bkc6qnklz5gjgtnm@apollo>
In-Reply-To: <20210327035406.bkc6qnklz5gjgtnm@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Mar 2021 20:58:26 -0700
Message-ID: <CAEf4BzYoWsp+ctR1uwL+Y+=Ho-oBOo3ciaYk9d5XPMDxahNHAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] tools pkt_cls.h: sync with kernel sources
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 8:54 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sat, Mar 27, 2021 at 04:55:51AM IST, Andrii Nakryiko wrote:
> > On Thu, Mar 25, 2021 at 5:01 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > Update the header file so we can use the new defines in subsequent
> > > patches.
> > >
> > > Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  tools/include/uapi/linux/pkt_cls.h | 174 +++++++++++++++++++++++++++=
+-
> >
> > If libbpf is going to rely on this UAPI header, we probably need to
> > add this header to the list of headers that are checked for being up
> > to date. See Makefile, roughly at line 140.
> >
>
> Ok, will do in v2.

Just please hold off until I finish review of the rest of your patches.

>
> > >  1 file changed, 170 insertions(+), 4 deletions(-)
> > >
> >
> > [...]
>
> --
> Kartikeya
