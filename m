Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD185458D0
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiFIXq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiFIXq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:46:26 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BB62C11A;
        Thu,  9 Jun 2022 16:46:25 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id g17-20020a9d6491000000b0060c0f0101ffso6240432otl.7;
        Thu, 09 Jun 2022 16:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X141ZafwMnCya6zJqjlrPW7zfFJHx0toBuGRvDUmsjo=;
        b=q0XI0ntOLGfgMtPYG+icei7LjXutXp3f1wiAcFHblSBQLpArWvXjxTipBntsbcUa5q
         uAuctNRnldKvWtYq1gkFDgB0kTpQYPQIC4IdHb3vJRdBCTUM3tHQ+6BQhB72M0DncDaP
         yGYp2E8WiYKx8Nwhm/0h+jHI+rgeCZ9oNfNwrpxtlosamsr5k61n8hFpO5GsQjhwIDJa
         VW4o3S/K1xWzXFEHGkPWiCfCFeLECZpOXn8Upu9Ca3TFWp67de63HE5Sny5P9kCMfbXW
         24yo2TyJtFDppyZtP58oWsTlrhFr8CZpZ+rusNdW9ccuMJqpDUXamp6uWijgttsrgCzY
         TgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X141ZafwMnCya6zJqjlrPW7zfFJHx0toBuGRvDUmsjo=;
        b=eB3SZGWyztcjnWRt/aW2qQZnrm2YKQinq+6AddxQPyP3Gr9IJpzVGSG6wY8DdBx8Gq
         uDLoqUU4UZVBmM4uvsLFrq85FzlgRmfQtO7OBt+b/cMQRoGCQAGkLAXcUO8PWRbCxhYN
         D8pyWjIyQD6Le4VNKM3IyukArZxQVvrWOfdKwsxiEwL6DmDb5ZVeriighVnKGihQ3xwM
         g4gqAuGcV3hqiYI4vhoaaTAyzFijgvyA0u6PjGXpBnAWisPSIUTW6oOhItOVPalLt6H/
         dSJqSyY/4/Oetej45oakQeBiDAqQyGLLzIxzWV5AJlbJNN0mBql/rZXSxCMFaTYWdWT/
         sEaw==
X-Gm-Message-State: AOAM531ePWeK13rd9711Kz8RQ1Y8ngCzUkv7hD4mvaiVg4oUIvLXnwhc
        zNl8HmxCRUkj6rbfK3dVYKpsMuAzM7RqajIFqUWk/z+KABxoxA==
X-Google-Smtp-Source: ABdhPJzn+Em+TQCsBFUUWarhAuEu/9+7NVktDF+yx31ZZZuLx3eXMPhCu3l/Pbw48K8J5jaRzoC/3IURySvaJsp3BiE=
X-Received: by 2002:a9d:7056:0:b0:60c:f8b:afac with SMTP id
 x22-20020a9d7056000000b0060c0f8bafacmr6250091otj.30.1654818384775; Thu, 09
 Jun 2022 16:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220609062829.293217-1-james.hilliard1@gmail.com> <CAEf4BzaNBcW8ZDWcH5USd9jFshFF78psAjn2mqZp6uVGn0ZK+g@mail.gmail.com>
In-Reply-To: <CAEf4BzaNBcW8ZDWcH5USd9jFshFF78psAjn2mqZp6uVGn0ZK+g@mail.gmail.com>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Thu, 9 Jun 2022 17:46:13 -0600
Message-ID: <CADvTj4oBy3nP3s2BaN_+75dYfkq2x72wG3dC3K09osRzkcw2eA@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: replace typeof with __typeof__ for -std=c17 compatibility
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 12:11 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jun 8, 2022 at 11:28 PM James Hilliard
> <james.hilliard1@gmail.com> wrote:
> >
> > Fixes errors like:
> > error: expected specifier-qualifier-list before 'typeof'
> >    14 | #define __type(name, val) typeof(val) *name
> >       |                           ^~~~~~
> > ../src/core/bpf/socket_bind/socket-bind.bpf.c:25:9: note: in expansion of macro '__type'
> >    25 |         __type(key, __u32);
> >       |         ^~~~~~
> >
> > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > ---
>
> If you follow DPDK link you gave me ([0]), you'll see that they ended up doing
>
> #ifndef typeof
> #define typeof __typeof__
> #endif
>
> It's way more localized. Let's do that.

Won't that potentially leak the redefinition into external code including the
header file?

I don't see a redefinition of typeof like that used elsewhere in the kernel.

However I do see __typeof__ used in many headers already so that approach
seems to follow normal conventions and seems less risky.

FYI using -std=gnu17 instead of -std=c17 works around this issue with bpf-gcc
at least so this issue isn't really a blocker like the SEC macro
issue, I had just
accidentally mixed the two issues up due to accidentally not clearing out some
header files when testing, they seem to be entirely separate.

>
> But also I tried to build libbpf-bootstrap with -std=c17 and
> immediately ran into issue with asm, so we need to do the same with
> asm -> __asm__. Can you please update your patch and fix both issues?

Are you hitting that with clang/llvm or bpf-gcc? It doesn't appear that the
libbpf-bootstrap build system is set up to build with bpf-gcc yet.

>
>   [0] https://patches.dpdk.org/project/dpdk/patch/2601191342CEEE43887BDE71AB977258213F3012@irsmsx105.ger.corp.intel.com/
>   [1] https://github.com/libbpf/libbpf-bootstrap
>
>
> >  tools/lib/bpf/bpf_core_read.h   | 16 ++++++++--------
> >  tools/lib/bpf/bpf_helpers.h     |  4 ++--
> >  tools/lib/bpf/bpf_tracing.h     | 24 ++++++++++++------------
> >  tools/lib/bpf/btf.h             |  4 ++--
> >  tools/lib/bpf/libbpf_internal.h |  6 +++---
> >  tools/lib/bpf/usdt.bpf.h        |  6 +++---
> >  tools/lib/bpf/xsk.h             | 12 ++++++------
> >  7 files changed, 36 insertions(+), 36 deletions(-)
> >
>
> [...]
