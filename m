Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021CE38160F
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 07:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhEOF1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 01:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbhEOF1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 01:27:23 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B57C06174A;
        Fri, 14 May 2021 22:26:10 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id y2so1672535ybq.13;
        Fri, 14 May 2021 22:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3qC/HEtqoIJGROP6iKnL5XKtySpCPC8sBZ3oZgPSb2o=;
        b=YS6AL4E9YEoTcTaGqW8QD69+yniVavqR+wfxH1ILWdY8MCsDal2aj27Iyxw2CcqP5L
         rB1xOlq2C75wrjZQpWh2fUn2MdK/bCpo01LVb17BfSyQUaO3PlIDM+rr3JRPGZsrX0a4
         FrOo2tH2m5kxzT+zoZ4VOwc017tfdFZ0QInAnvwoObOEiawDNVz9kSBwBtwVYNS+e6Hz
         UhIR6sjWlNgNpend+vuqhEPq2Hx9SnApsOHSn93EU0EXnMocJPyFCiDr0Ge3GaUtzpXH
         Z4vWa1eorn4NSPV2Z9B3fzc6sl/uLYi+b43S2o++O8HUfOhYE22Wu17pdxPYX0Jadm32
         SXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3qC/HEtqoIJGROP6iKnL5XKtySpCPC8sBZ3oZgPSb2o=;
        b=CZ6JLw1Ww+D1ukeCEp6OWvonX1z2pzmDom+E5WxzE5S8dONtwy3PjRztXMSlEjA6QU
         eZTsCDz0HKRZHWPPv0YsQHNNEdq5TZWaJHzQoc/89JrpSnRS3NQntbIcO50Gz5L7lATs
         zsZUj6qwf1g5xBVKqBW7EdXkwOUU1p5iTaW5E3s9O9DyvuYX564Wld2vZZe6es3l8N5I
         ahM4ZCrADZtmH7y55WuPVgHmABKNFrqrIzWz3RJQtNMjRyeGRvIVI394XPlpVB9Do5Vk
         t27HAMPZpzVZ6gbWj6krq04B+18bLFdk1wCzAYUB19Oa8Hb8FTES/KBRE2ZP8uj5A6kP
         h3tw==
X-Gm-Message-State: AOAM532gHFWGqEBEBd8gufwy841smJuety3ngZrdC3UaUDpZJb3567Ra
        7uvVgiXXQ35vJSr9LfDRKiiM7vnWaN3s9Zs7u+M=
X-Google-Smtp-Source: ABdhPJwOgutSNIwen1bh3ICH32d1zZF/Am7UP2GmI1G6PjPKp1RG2ZnCANI1oBUsW2Nn6wzUZailDEBbEoDe9wwx1Fo=
X-Received: by 2002:a25:3357:: with SMTP id z84mr67444368ybz.260.1621056369263;
 Fri, 14 May 2021 22:26:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210514195534.1440970-1-andrii@kernel.org> <CAADnVQJEWUJ68SQG=bDHG007384xsbPzH5-hdXuZYpDR-txBBA@mail.gmail.com>
In-Reply-To: <CAADnVQJEWUJ68SQG=bDHG007384xsbPzH5-hdXuZYpDR-txBBA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 May 2021 22:25:58 -0700
Message-ID: <CAEf4BzbBJgcD-QOyWPLWdMf+CZHFnpyLd-F9-eiZ-4fGsS_y6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: reject static entry-point BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 4:14 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, May 14, 2021 at 1:34 PM Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Detect use of static entry-point BPF programs (those with SEC() markings) and
> > emit error message.
>
> Applied. I was wondering whether you've seen such combinations ?

Haven't seen this anywhere in the real code, only tested locally by
adding static to one of selftests. Unlikely to break anyone, but good
to be as strict as with maps.
