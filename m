Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE756567D92
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiGFFA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGFFA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:00:56 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101A31BE91;
        Tue,  5 Jul 2022 22:00:55 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id g26so25037069ejb.5;
        Tue, 05 Jul 2022 22:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vawKJQXmsefWF4gLD71WEblECZZ9kLxHvZ5C6nvYmiI=;
        b=ckZuNTHyUmXtAw+lhiU29cOyNgXqttUGQcxP5edTEyjMqf4XGnyfIeLyhoZnEOLZN/
         nVd+U6OruliAuhAZe6R/u1mJzVgVIxYqrISwA/D3rNjpshP+4G2aQkdV7Lo13NpzSfXk
         Yl3WqOsmWUbkDok2a4WHD6OKStvrPAxeXS5R6jRysniwOh3AiLpbDAVPvBKFY5MaZHTp
         chSeZRUwAmrxLlU+bjOzHL+QX6y+0nbDDJh4ZXXG5fB6IL2V8A5wlAQd+Mkz/Uf5K7lz
         1vEL/gTcR9dO+BbQ+JYt4F/Yop8Ur763Q7YkhmJd51FJpoGG1zcNJdiXtZLfzwaoitmk
         5YPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vawKJQXmsefWF4gLD71WEblECZZ9kLxHvZ5C6nvYmiI=;
        b=P/ApRWscL+C85CO2PTAspwUECSa0J6I3e9MDPzVUTm6FBGRGARowigbFxfr9m9d64I
         PoeIkbtr20IFqJJC4g0TK1tkbZTy3TijhRltScZDWNmUpk/0TF+JjpofjbROiIBZ8LLq
         8NzmzxhRaKKis3El38VNoZdNBvGA5QmbH918n2oYTILWn1qYyinJMvoEa6Rp82fyS7qr
         u0ulhawY8SsOcyfMYS86x547iiKyhGNk0yOoezehrH7t6yobC8mrAuFamO16CJI/2bjk
         qxChRNbjvFg8pFYpR3jhiZbsCLiXiXRYDJLSuS52e+Boo419bWB9g/X4RJEY7sQDDl91
         tvNg==
X-Gm-Message-State: AJIora/G6/RIZ/vSmqcro84jaS5P9sI1aeB+aTVm0ZC8V9HEHi2r4o8g
        /gBqIh19+XqPEwgIeMZaB8fk8ReM9CwPgWBiwKQ=
X-Google-Smtp-Source: AGRyM1tnC7xEukUs2A0VoewEY2CoIfV7aCqGo0G38aLeVq+D6tBDe5KKFSQhFuBWTDBmF+DkqCrq7G46Mnc6e/XGRPo=
X-Received: by 2002:a17:906:6a11:b0:726:97b8:51e9 with SMTP id
 qw17-20020a1709066a1100b0072697b851e9mr38260616ejc.115.1657083653634; Tue, 05
 Jul 2022 22:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220703130924.57240-1-dlan@gentoo.org> <YsKAZUJRo5cjtZ3n@infradead.org>
In-Reply-To: <YsKAZUJRo5cjtZ3n@infradead.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Jul 2022 22:00:42 -0700
Message-ID: <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com>
Subject: Re: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
To:     Christoph Hellwig <hch@infradead.org>,
        Alan Maguire <alan.maguire@oracle.com>
Cc:     Yixun Lan <dlan@gentoo.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
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

On Sun, Jul 3, 2022 at 10:53 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Sun, Jul 03, 2022 at 09:09:24PM +0800, Yixun Lan wrote:
> > Enable this option to fix a bcc error in RISC-V platform
> >
> > And, the error shows as follows:
>
> These should not be enabled on new platforms.  Use the proper helpers
> to probe kernel vs user pointers instead.

riscv existed as of [0], so I'd argue it is a proper bug fix, as
corresponding select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE should
have been added back then.

But I also agree that BCC tools should be updated to use proper
bpf_probe_read_{kernel,user}[_str()] helpers, please contribute such
fixes to BCC tools and BCC itself as well. Cc'ed Alan as his ksnoop in
libbpf-tools seems to be using bpf_probe_read() as well and needs to
be fixed.

  [0] 0ebeea8ca8a4 ("bpf: Restrict bpf_probe_read{, str}() only to
archs where they work")
