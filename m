Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692D26ADBF
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 19:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388184AbfGPRgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 13:36:03 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35510 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfGPRgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 13:36:03 -0400
Received: by mail-lj1-f194.google.com with SMTP id x25so20816881ljh.2;
        Tue, 16 Jul 2019 10:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ESHVl2nHbn2TEsWSPrPco8gru5D+8LAzsntDZMK/VjA=;
        b=arTRktg+807+oLCbu2PSQLbOKSpG3qhizwfMeus8qndYPDMRgFhycBiFvkSHfv99wJ
         8i8mmra1iqnOhJpD1YmWJLc6EoiErMNbu2S+bIy05UoCbAvpFtpk+IpDluH0BpDib+/T
         XSlruiP9MP0C6yxFEAnidUNoBTpsrDCe6on6VKGiCCZO4F3Cdq5ZiJnhCQ1j8LsZB8Dp
         Vi4Jx0wzziZYqgeOogWLccJJil3VHDeuJUij9JOmSN2F0GvG2Fev5PMfr0dc+Lv28gKm
         xCzjPZeM2DRhDJlKGms2G08yA+S8iQrTBCfXpjw4WJPLfmlEpoNvY5tH5PTwdbPuXUk6
         iWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ESHVl2nHbn2TEsWSPrPco8gru5D+8LAzsntDZMK/VjA=;
        b=Z6U9AcwZu9V9OQ561X9JRPNaYt3621yHbJUnkw83YPDFLPXBKfgx75F4h4e6E/Y0Od
         aStKhOOwmN1zufYt+JlAtVwR1IF7xJe7tPgJvxu1y2nIznoEeE7Rw7OY3rgNVn4p8Jho
         znu9WJkUToenoWBIvDFacr1dx3UX2I9oEIVGspd2mXlmeXaQOIVHQgFHvH/JFaulhYUJ
         atX1O/yGYiNc2te29ZMtEaIyRqRpN5uhDjHFMhA/IUGWjGVGcNEi9AF+9M0EFFD3oTUh
         D+k1cvYfxtTcf5Hc6aMbv1lTqf64DWh6VjGrvGGEFraezdylN3EzDSRAIe0llPgkQ+6G
         ZAiw==
X-Gm-Message-State: APjAAAWoi0o2P6FdEUicFP5O58sLjAJU2sgSjuvnOr6eJe/EKrYdfZap
        wpr7fiuxtX8sVyu2/zqReSljThgOQZw9+232aU4=
X-Google-Smtp-Source: APXvYqxkW6cvHHyqbcBgrzHGuYqarA6naNYMtEgstzEIZDJU5i1Nom50UQXEvYRaF1Gxig2e7RF/TgvZCSlOyUckKnc=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr18023760ljj.17.1563298561116;
 Tue, 16 Jul 2019 10:36:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190716035704.948081-1-andriin@fb.com> <CAJ8uoz03xFA4TW7GNmLAw_A0wMjHUjYU2rG3pRWsEX-sAX8BFw@mail.gmail.com>
In-Reply-To: <CAJ8uoz03xFA4TW7GNmLAw_A0wMjHUjYU2rG3pRWsEX-sAX8BFw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 16 Jul 2019 10:35:49 -0700
Message-ID: <CAADnVQJzWLpbbLFRKPpXre3oOt9baap6Hm7DYZqpzaLK_iodTQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix another GCC8 warning for strncpy
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 10:31 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Tue, Jul 16, 2019 at 5:59 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Similar issue was fixed in cdfc7f888c2a ("libbpf: fix GCC8 warning for
> > strncpy") already. This one was missed. Fixing now.
>
> Thanks Andrii.
>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

Applied. Thanks
