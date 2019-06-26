Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B155D574DB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 01:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfFZXUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 19:20:53 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34408 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfFZXUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 19:20:51 -0400
Received: by mail-io1-f67.google.com with SMTP id k8so610820iot.1
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 16:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=brea/2Qx9pBcYGaH6DB1Fc3qM+qPNzkSABIn8ioCvPU=;
        b=ZaJnj72valkhOWXD57cAGw+gAAyEfQy/JR47wmIiwfnDtp1TQpOJwz7GpvJSXTUD0u
         ZA/U+rG82kpbeH8Uqa6aoazQ8fD/ngaK2CVgNrTaqAQFz3f57WqXINxufX5TlzRjxCQa
         xI8Ss8Ko+wdFKlJb0vWMvWfg8h0WPripGQ3EU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=brea/2Qx9pBcYGaH6DB1Fc3qM+qPNzkSABIn8ioCvPU=;
        b=R4tpSL93qOdxr2J2fmVlUTdIJwhr2oAIRlQoSbxMmN2/EEwBYA0h66foU69f5prwyP
         WD2ge71TuCbx1iM+sDT8kFprr2y4UCO3V2tuXz8OINBiOxjqC5tsBPBviPSRnu/1uPAr
         7FMrqd/PL28kUh9GFNZSv3zMORPa1Y2m9ZNQCCYnM/JaUBdG6ymAO21gznqxL/iZIj5V
         vss7MpzxnOLntdWyUO7q8tAjKjtNULNFbPYk8/iyQ4yVFvsmoPcDwo7zLTJz41OrHXat
         Lp/jAXuVYcyUmFPhpmY6a6qDQPvyIoNzVncGVDO94UuWbgLmwn+Uhc83iVArl70UzUWC
         BHag==
X-Gm-Message-State: APjAAAUvTvMvhn8+0oiYo1QqaRJdNNuk2gzAQo4khuQkzbpY17WsZTW0
        2Qb0LybsVsTHSMibk0oubrW3khvcuumPXxs4u6bGKQ==
X-Google-Smtp-Source: APXvYqx4WUGRRdnDMn1qRC9QzduXjQrWAsPLCwLSndDqxI0ewueoPskdlrvCJKhtJLOzQy0pNf8LolgeC9PNFB3+1so=
X-Received: by 2002:a6b:f90f:: with SMTP id j15mr894411iog.43.1561591247732;
 Wed, 26 Jun 2019 16:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190621225938.27030-1-lukenels@cs.washington.edu> <CAJ+HfNgHOt4gMSq_gufwxb=cKekCfLrk-uGJuGeDiOeQV1-wwQ@mail.gmail.com>
In-Reply-To: <CAJ+HfNgHOt4gMSq_gufwxb=cKekCfLrk-uGJuGeDiOeQV1-wwQ@mail.gmail.com>
From:   Luke Nelson <lukenels@cs.washington.edu>
Date:   Wed, 26 Jun 2019 16:20:37 -0700
Message-ID: <CADasFoC6ga_DuHL+RxLPzBhMHr+Jj5OgGkjuUgX0o6Rx5vsvdw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] RV32G eBPF JIT
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 3:11 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
> >   - Far branches
> >       These are not supported in RV64G either.
>
> This would be really nice to have, now that the size of BPF programs
> are getting larger.

I've sent out an updated version of the patch here, with support for
far branches: https://patchwork.ozlabs.org/patch/1123052

Thanks!
