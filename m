Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6804F0F96
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 08:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377549AbiDDGsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 02:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240418AbiDDGsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 02:48:23 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F8F28E33;
        Sun,  3 Apr 2022 23:46:28 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b16so10131844ioz.3;
        Sun, 03 Apr 2022 23:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M/ND59KmZvPdpCwop6kKf93Nl3TUk021MGv6o2kMXv0=;
        b=a4TMNm5gok5lKKfjZnHMs5KIJXc02H+5A+s9DtnAPAJcL25Lk5rUxrDE/OzUB/dcrb
         8RoiZFXfcMVC9zM1Kl5GNnxkMHyun+4ERqcMvrS9kyBQrIVK87DSNzZ8rGIsQOBzgEUU
         186bk4eFiowkFDhxox6NbiKCJTxklaC7tsC2KrcKWrFSks/9WGkRA7NvbcrLVT/MaoXf
         QMD8XKgW7aRzOtEfRCdf9ZTr+zjJa6dR4zQkv3aPHfao2WXp3cQMIiwidpkfV4fqhX0z
         9hfIuGbc6LZdyNNUOfAFkulO9UmwqyS8WMSytT5LAWoCJOj5uqbU08uGQLQRpY5z/J+1
         N12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M/ND59KmZvPdpCwop6kKf93Nl3TUk021MGv6o2kMXv0=;
        b=MOqT2IripEEE8Jj4n8/N1Fd9xJcDzJfReaa7Ot+QIxxhJ3MFHGWcG9aQ11tTal1P88
         KMMvvKwXlsQ9HPfYxxErBwdg2ptqzHhZ811Hp4rE7fmyAp9K6jg2TI6aAYwRE6yahrvG
         OA9eHbIcFBw6ENE3qdFf5udNbH8K8cHPedvrC4iuWmMK4PM0wPeIhcs6G1JteK0sgQ9q
         PEUkRl5SDMpftyGQo5tsFkQGHlgQaOnE06Kf29uHNvo4GAQaRBvDO0EAppQIl36cEK/I
         EtgAe4GvLKI/PHMf2MIgjDuiuDL3hvfLONKq8p35M5cp69e9hFMAX+UblgVVAd/0btKH
         2xsw==
X-Gm-Message-State: AOAM532TxWJ/H1CuWhgqGYyLvOeInIaAsksZskWN4Hxh6EKCvnhY5giq
        PGMY7drhFhT2alvmnBlXgL4QHv3nYMGcScjhvWA=
X-Google-Smtp-Source: ABdhPJwH0Ebekk47csRvkhGLqgqFzSdAunRrK9Ut+Bh+VjZEX8xxx1XGO+QzTqjuQNza0DNtE2RMagMZteLI/ni7eoM=
X-Received: by 2002:a05:6638:2105:b0:323:68db:2e4e with SMTP id
 n5-20020a056638210500b0032368db2e4emr11544611jaj.234.1649054787604; Sun, 03
 Apr 2022 23:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220403144300.6707-1-laoar.shao@gmail.com> <20220403144300.6707-2-laoar.shao@gmail.com>
 <CAEf4BzZ2U=H-FEft3twSV7RCgTHHVJ8Dt6_RuYMdHdtC17WM1A@mail.gmail.com> <CAEf4BzYGOgrbvobqPBW+1Zdb5W7Cj0WUvQNitnrxJNgSOCnzQQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYGOgrbvobqPBW+1Zdb5W7Cj0WUvQNitnrxJNgSOCnzQQ@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 4 Apr 2022 14:45:51 +0800
Message-ID: <CALOAHbC3Nead_=6jLX30yorpSUyVkOo7bLJO+NvuZX9MBrrhSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/9] bpf: selftests: Use libbpf 1.0 API mode
 in bpf constructor
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 4, 2022 at 9:27 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Apr 3, 2022 at 6:24 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sun, Apr 3, 2022 at 7:43 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > >
> > > In libbpf 1.0 API mode, it will bump rlimit automatically if there's no
> > > memcg-basaed accounting, so we can use libbpf 1.0 API mode instead in case
>
> also very eye catching typo: basaed -> based

Thanks for pointing this out. I will be more careful.
