Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9391E48CE6
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfFQStI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:49:08 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41662 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbfFQStI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:49:08 -0400
Received: by mail-lf1-f65.google.com with SMTP id 136so7311873lfa.8
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nOSaXiJzVDj5IM4aW+0gcUHxkkLPWAqm3lSgcsh3l8M=;
        b=MvA2SRX/VcHcJ/x8ZeKMF1KFFgxP8vUPLAhIurER9lCvX2VZXMWPDioh1w1srq6rzn
         Zwoo9Xfyqg0l9Ax5Wz+NR2tDOku7ZmEn5fLqn1riZVzXmnUdqe43mDIsx1k087Au98Il
         q7u7RVM4b0VfVPtmQV1Q1W6OJiHBfodkWBImc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nOSaXiJzVDj5IM4aW+0gcUHxkkLPWAqm3lSgcsh3l8M=;
        b=FX2HdF79H2VK7OBMH+v8Y/rPopyLChTeln2us1Tee+VR9l7Gw7WatnxA+uJKaCELZU
         jthmlxIJqMtOGyXNAY512Qteh3vSGGzdz7u9Xd7cvVron43eGZ1DXAzFJRSY+Y9FW9PA
         1ORWrS+sZuCwi6twELCcUN02aaan89JMUfZv5nXrE6LwaD3jekPWIU7vXhpiR4Vspowl
         GIBxpoBuHLBVsU8wOwqcMEjnaC4na8WVCAx7mTJZfec3ogMl67nVlYxpm2bZy1ISumne
         EHGZobIR9bq0Y5WcSMQ5PguZWuMBoOAKgkniRIuKthbd/BiuVu5Tgc3gYMlZjjEPOH3n
         +Fmg==
X-Gm-Message-State: APjAAAWryEQ6fkmlKniYKfY3StTxf6aJzXCmy56exTC9fVH4f7m4Y5jB
        49WquzPpRd4rb6I0qEuukfi2x1ggELQ=
X-Google-Smtp-Source: APXvYqwZrEadZngFHaKp5trkqMCBBYV+7gQkZO7Ie0YfEhzo1r80X/rARgC1xd7xCx27umZX9Tok2g==
X-Received: by 2002:a19:bec1:: with SMTP id o184mr26357289lff.86.1560797345134;
        Mon, 17 Jun 2019 11:49:05 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id u18sm2249591ljj.32.2019.06.17.11.49.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 11:49:04 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id p24so7326193lfo.6
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:49:03 -0700 (PDT)
X-Received: by 2002:ac2:44c5:: with SMTP id d5mr6889528lfm.134.1560797343688;
 Mon, 17 Jun 2019 11:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190319165123.3967889-1-arnd@arndb.de> <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
 <87tvd2j9ye.fsf@oldenburg2.str.redhat.com> <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
 <871s05fd8o.fsf@oldenburg2.str.redhat.com> <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
 <87sgs8igfj.fsf@oldenburg2.str.redhat.com> <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
 <87k1dkdr9c.fsf@oldenburg2.str.redhat.com> <CAHk-=wgiZNERDN7p-bsCzzYGRjeqTQw7kJxJnXAHVjqqO8PGrg@mail.gmail.com>
 <87a7egdqgr.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87a7egdqgr.fsf@oldenburg2.str.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 Jun 2019 11:48:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjF6ek4v04w2O3CuOaauDERfdyduW+h=u9uN5ja1ObLzQ@mail.gmail.com>
Message-ID: <CAHk-=wjF6ek4v04w2O3CuOaauDERfdyduW+h=u9uN5ja1ObLzQ@mail.gmail.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Joseph Myers <joseph@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 11:19 AM Florian Weimer <fweimer@redhat.com> wrote:
> >
> > Unlike the "val[]" thing, I don't think anybody is supposed to access
> > those fields directly.
>
> Well, glibc already calls it __val =E2=80=A6

Hmm. If user space already doesn't see the "val[]" array anyway, I
guess we could just do that in the kernel too.

Looking at the glibc headers I have for fds_bits, glibc seems to do
*both* fds_bits[] and __fds_bits[] depending on __USE_XOPEN or not.

Anyway, that all implies to me that we might as well just go the truly
mindless way, and just do the double underscores and not bother with
renaming any files.

I thought people actually might care about the "val[]" name because I
find that in documentation, but since apparently it's already not
visible to user space anyway, that can't be true.

I guess that makes the original patch acceptable, and we should just
do the same thing to fds_bits..

                     Linus
