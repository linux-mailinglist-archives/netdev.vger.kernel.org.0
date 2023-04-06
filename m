Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE1D6D8EB6
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 07:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbjDFFNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 01:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbjDFFNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 01:13:40 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EA38A7F;
        Wed,  5 Apr 2023 22:13:39 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b20so146450743edd.1;
        Wed, 05 Apr 2023 22:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680758017; x=1683350017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7CD8/z7IPUYyJif1qDTJHSqtLjAhDIy/xYROM0qMSQ=;
        b=FCiaxic3eu5ZxHVe+eDa9a4pH88pJFWZuRIrA2dZNRjjvq/w6PRs7H9N9HNuXERGlM
         0gaOUgAsFniTE73YXMu13pRMdRJ3jZJlEe8oSWSWEuGi61bvlXFInfPb4nt4BUeUvp0a
         /C0UYJnWycZVvaudOBv4fsNz1C9C/b8b2ooGA/UVfeW4l3g8SSd2vlQFWVATQ6MeFCGE
         SzFgozWH7XEI4EEWc3tVY5PPGD3ptGppt6BF+rYIWpQ+9PyLO/lI0C8IvXRIkKMOO52c
         NcKBqpVXWW6LAROtMN1bAyC4dHBhqFJoLsdFR/m2k9+R8gH0Bij+g5iJch4r+W1JnZaP
         y0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680758017; x=1683350017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7CD8/z7IPUYyJif1qDTJHSqtLjAhDIy/xYROM0qMSQ=;
        b=Ija1z5TX4fel7ETZtMHQHF3JPVmlWDuCMKrHalBrtuylUpoV/atdTW34B6puDkC+tM
         kFpl/HrgBmW3BuO8I0k844MrOWsmiOpZjPpRZp8afiRdWYcJ8HQ8H/sWy4zp0ibpfVKc
         Vv7ksy1ytpVGxP0/4T7LbiGoLgdXSSxrRJbl/2ZYUDCLDQ8iB2yeute/K+JMxvJcRC9A
         tFyJM3Ss6xYdYAyWwCHjRIEhEK0c4FEvgmc3FU9RLRJuHvTiNOyna9d6eo50CdkOsyUc
         X41P9YcNk1PbWX47NVaz+oap0IY2ywVLpJp0RsNAWKB19kVJtxqYNdjLSyUxn6Rtx4MV
         rEcg==
X-Gm-Message-State: AAQBX9d0vxnG8k9LZxYz3eNox7PF5SWXBA5AmgCEGM2CbRNRkb5d8ZyM
        YJDQyFHmvCI+Qe50i0fDhbqm9E2pPteQp27+Gady5lrjhyU=
X-Google-Smtp-Source: AKy350bgX8+d/uvTXs9qcDQdgmYn2oD4iJDI71dhCm9bUL3AsNz+WW7SXKBnG/KLZ1QffnnjKLR5/xSgEwLZbO7vg8g=
X-Received: by 2002:a17:906:d0cd:b0:931:3a19:d835 with SMTP id
 bq13-20020a170906d0cd00b009313a19d835mr2777137ejb.3.1680758017436; Wed, 05
 Apr 2023 22:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404145131.GB3896@maniforge> <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
 <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
 <20230404185147.17bf217a@kernel.org> <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
 <20230405111926.7930dbcc@kernel.org>
In-Reply-To: <20230405111926.7930dbcc@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 5 Apr 2023 22:13:26 -0700
Message-ID: <CAADnVQLhLuB2HG4WqQk6T=oOq2dtXkwy0TjQbnxa4cVDLHq7bg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the verifier.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 11:19=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 5 Apr 2023 10:22:16 -0700 Andrii Nakryiko wrote:
> > So I'm exclusively using `pw-apply -c <patchworks-url>` to apply
> > everything locally.
>
> I think you can throw -M after -c $url? It can only help... :)

Yeah. If only...
I'm exclusively using -c.
-M only works with -s, but I couldn't make -s -M work either.
Do you pass the series as a number?
but then series_json=3D$(curl -s $srv/series/$1/) line
doesn't look right, since it's missing "/mbox/" ?
User error on my side, I guess.
My bash skills were too weak to make -c and -M work,
but .git/hooks tip is great!
Thank you.
