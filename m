Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890BF183E45
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 02:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgCMBHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 21:07:06 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37438 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCMBHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 21:07:06 -0400
Received: by mail-lj1-f194.google.com with SMTP id r24so8686583ljd.4;
        Thu, 12 Mar 2020 18:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LoZfayZbxCT6TEBCz46u7juQecvUBpxI5Rt9cQ5jcu8=;
        b=mVgyIJtFmHvWtGGKd/ot0R952a/sER70bjIHCH6Jm9knWLA+QRuElQAiGkEWYJ8scj
         cXpIfUudCu2ttENdrLnpZt3jgcdhoUBIZZYe58/C7sK73FrJb5YfsZr6MXagFAGsU383
         o+9T3FScBtIjqhmTkAT//arsIW8Vp9aM+TW2nljnytV65EVI7YDOOe5DamWEEqggEd+u
         4LvvHC3pb6h7lOi45jbcn3oIz2fGDy5fK9Y5YmJFupbNL/6gI2Bp72t32YXfufF79zpl
         kyrpRnB2Dpz1G/Agoi8DkoAt+eredXoOnbOWTRY97EpW8WfIiWO6CMGmdK/OHTHt/Xbr
         Jokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LoZfayZbxCT6TEBCz46u7juQecvUBpxI5Rt9cQ5jcu8=;
        b=EkLA1wq4GWd/JDkLg8iqKl13esK0IW2ADsUeYS+dyN7Sl0BnHC6z87rlBtpOtn6vTp
         uEvaG2ZNbDwxZNk6yYqVGi+uUrVbXb0CecJpOpYzRMAIhguOTnAzNKcs13dEJ6c3+vH/
         w1AhZBr1QXoqjqOUK42zY0uUVaw6u+ZVwyELFYdmaA55cTrP+eWRNR99xEhlq3bPo70L
         ypCp79uhYqx683ZDnWLr+mGPRZc8yPSPlmOb90MSLZtA29iFrd9qm4YXuoUN+FfzHsX+
         tj3aSHNZe2uXL6Rbkffp8LYuUBvv/mL2QFkMhKI/BVB7h7Izs8/9MAzf1E11vsfoqOaw
         HG0g==
X-Gm-Message-State: ANhLgQ1Xzk0d3E62q6G7jjBZTauBWdF546PfopmVTULXtSRhGBxejajA
        JzONZ2GP11k0SVC4d8aDNJfEtYLhbD1g2NZOAhw=
X-Google-Smtp-Source: ADFU+vsrwP48lglOzRoW+AeJF/zLVkcnmK/Xhe6/hdpc0QEMc41M+FfrLk0vw3ZXg8EZm6FgDnG55U7Cjxfusk5Z1As=
X-Received: by 2002:a2e:b5a2:: with SMTP id f2mr6935792ljn.212.1584061624081;
 Thu, 12 Mar 2020 18:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <158348514556.2239.11050972434793741444.stgit@xdp-tutorial>
In-Reply-To: <158348514556.2239.11050972434793741444.stgit@xdp-tutorial>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 Mar 2020 18:06:52 -0700
Message-ID: <CAADnVQ+G2AWsDQWyD86k61h5P79Rwgg43aezmKLjd3AabMY0tw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add bpf_xdp_output() helper
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 6, 2020 at 12:59 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Introduce new helper that reuses existing xdp perf_event output
> implementation, but can be called from raw_tracepoint programs
> that receive 'struct xdp_buff *' as a tracepoint argument.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Applied. Thanks
