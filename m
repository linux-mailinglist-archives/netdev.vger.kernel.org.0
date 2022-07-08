Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4D456C22B
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbiGHWXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 18:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238170AbiGHWXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 18:23:06 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46253A2E73;
        Fri,  8 Jul 2022 15:23:04 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r18so142176edb.9;
        Fri, 08 Jul 2022 15:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yBdvBTe3g+WoWKyR2cO1ADMFniLHi7aD7N14QfJmN44=;
        b=U7LtpCI6Et+ZUqPOwI7r1KOG9LRVjRO7f1c4kL0531lewHHh9QjqKjQcAHW8knDWzw
         z73ez2NzxOWumdTs0B+BCHhvvM9dxWx86TkIYUNcIzrsyC8q5kjidXciPy0HMN19m/kE
         flvme3cuK73mxM7PMMkL3lmulqAksdjMTlj8baWX7qfqcvDTi3+uhoK1GToJ9mh0uzLP
         WVaN6MxWGI2e6MJ5CL8xAt4kKst2ifyXiczourRO+nvn0ZBXlmTgjlHh4G40LZHMl3tk
         1RL58VIR2/Uq7XB6Z8P2akBKPo17vtaz7T/8SRZcCSkNxvZ66HkM/rzCP1jj6hfteyOw
         FVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yBdvBTe3g+WoWKyR2cO1ADMFniLHi7aD7N14QfJmN44=;
        b=3ujGw6h0CTwhWHddQGlTyYL54zH4HomM+H3+6fJVV1X2Lq9jjGVsOwS6FIvW++GInK
         bBBIEx9C0mgVwyI2spRkJjuaKtHR9qDSykUybxYG0E1uDFUd4MobWVE9BkTb1FN7wq2u
         sL0YhjZAVrOYhqZ6GQJGAmGyJuqm5syqmJYdkZjA4H92U1+zA0RxCIwcXeVzApFFgeiB
         n8IqARTlRkD/v6YZ844Df1AacrUBKkDwe4cKDw31jzTPj00N6F4+lOQ5LWvbJU0avie6
         uSRAAwABrjj2yGEj9EdG0OWyUGpfszLD2H3CeSApXpu3Z5PJn73d/tdp8LRtyyHeYtgA
         ffqQ==
X-Gm-Message-State: AJIora+tEgbMP2gLxzqlIBlNTn0z8jpgSQzhaEFgaAHB10gvO1zCoIAH
        a00By8XXxLQu9X8T/WvLtGk0By0IPyy3ynig9Q8=
X-Google-Smtp-Source: AGRyM1tiUsd7f6UAjFxaGOKMCFQWdEHIWpjx8lm0dM4npIINocOYFvbbYuCc1fEkvWycP/6zDtaD1wDwsObcNke4aAQ=
X-Received: by 2002:a05:6402:c92:b0:43a:7177:5be7 with SMTP id
 cm18-20020a0564020c9200b0043a71775be7mr7796141edb.224.1657318982890; Fri, 08
 Jul 2022 15:23:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220703130924.57240-1-dlan@gentoo.org> <YsKAZUJRo5cjtZ3n@infradead.org>
 <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com> <YsUy8jBpt11zoc5E@infradead.org>
In-Reply-To: <YsUy8jBpt11zoc5E@infradead.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Jul 2022 15:22:51 -0700
Message-ID: <CAEf4BzZrvOyYxmJpw=azZ59adeEqnHYqnUXKQProyUKBP5NaUA@mail.gmail.com>
Subject: Re: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Yixun Lan <dlan@gentoo.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
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

On Wed, Jul 6, 2022 at 12:00 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Jul 05, 2022 at 10:00:42PM -0700, Andrii Nakryiko wrote:
> > riscv existed as of [0], so I'd argue it is a proper bug fix, as
> > corresponding select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE should
> > have been added back then.
>
> How much of an eBPF ecosystem was there on RISC-V at the point?

No idea, never used RISC-V and didn't pay much attention. But why does
it matter?
