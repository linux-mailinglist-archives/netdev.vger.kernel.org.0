Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C9457449B
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 07:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiGNFib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 01:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbiGNFi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 01:38:28 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9EE23BDB;
        Wed, 13 Jul 2022 22:38:26 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id va17so1529789ejb.0;
        Wed, 13 Jul 2022 22:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LN+1uoqcR3KE6d2ub05nM0U9flW1gWOpOYcp0ljPW/c=;
        b=NJE4zBKGnY3Av+rcwLIeejYfMkcXaV5aumDpt+2ZWbe0Sa8J72c3d4Alhz+Qu9N4me
         51p4gctNDG2AVCsxbLERiDmlSYQWK1kfiTQB3389ESGJamF8q5prcfmpOOpaU6yMh9bc
         hvb8e6dhk8QoZjFAWtFs1DiGnLrb5BxodiqOzLBBrYencDSyBL6bhnYknWj+MgD5Lfq/
         BuERsFX+8afZ7Sj9InoNZ+DOL6ugjwACN5r7PJQiuMviupBAKLkNgPwyTUtV1tZiVC0U
         kj7r33608TYRZP+FHhw44xejP0StjvfUn5evrjYlc5jrBpFMvcWhWLmVGGTXut9QN/DQ
         KwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LN+1uoqcR3KE6d2ub05nM0U9flW1gWOpOYcp0ljPW/c=;
        b=svOkkTmc7UCJBEo5IRb3ExYCB6LnQSjDkk/aknvyTBREpshFiGgpRyiRU7TEAC2txY
         qesWBiZC8ter5eD2uR1pBENeVjeRuaUrQBIb6OWwR9/ppwzmnXX13PZEMxtYZpZl0qPj
         7rvHQ3UFI1tuCsiR6odmOudIBYyS/eoJVaSUJ2CjQhO5yQLyTmt0GdrpnmKdFmIFAFDM
         FjADDG5f2yuUnNDzvYpmJW0hB5hYkJ80EiIsM7C/GfGaOQKwxor54QjXlMWAsZrUZD2J
         +w54nu7k4Bic82Uoc5PmkwiP3+NVfwF5XD70k0KEM+BDfEICD0c+nxM+ByLGJa92JruI
         OBGQ==
X-Gm-Message-State: AJIora/1koqAW42w8fZWR41XgbYK1D4UsDQOBu+3Yno/iIEeB5mpvou9
        0rOTTED932UTgUnXR3I8WRhdtqqp1nzsZGbZGz4=
X-Google-Smtp-Source: AGRyM1vH3Xx79OVC0UwU25nsLG/XOu5LrvqtDWa5T9t3ZADfXWe/MUud5IMiSl0ejt9nj4SmnOTfT/9672m6v2dnTII=
X-Received: by 2002:a17:906:5a6c:b0:72b:561a:3458 with SMTP id
 my44-20020a1709065a6c00b0072b561a3458mr7127966ejc.114.1657777105039; Wed, 13
 Jul 2022 22:38:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <20220713111430.134810-16-toke@redhat.com>
In-Reply-To: <20220713111430.134810-16-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Jul 2022 22:38:13 -0700
Message-ID: <CAEf4BzYUbwqKit9QY6zyq8Pkxa8+8SOiejGzuTGARVyXr8KdcA@mail.gmail.com>
Subject: Re: [RFC PATCH 15/17] selftests/bpf: Add verifier tests for dequeue prog
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 4:15 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> Test various cases of direct packet access (proper range propagation,
> comparison of packet pointers pointing into separate xdp_frames, and
> correct invalidation on packet drop (so that multiple packet pointers
> are usable safely in a dequeue program)).
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Consider writing these tests as plain C BPF code and put them in
test_progs, is there anything you can't express in C and thus requires
test_verifier?

>  tools/testing/selftests/bpf/test_verifier.c   |  29 +++-
>  .../testing/selftests/bpf/verifier/dequeue.c  | 160 ++++++++++++++++++
>  2 files changed, 180 insertions(+), 9 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/dequeue.c
>

[...]
