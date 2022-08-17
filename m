Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDBC59675C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238508AbiHQCU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238331AbiHQCU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:20:27 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D5E98D3B;
        Tue, 16 Aug 2022 19:20:26 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z187so10910825pfb.12;
        Tue, 16 Aug 2022 19:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=NqWldGNpwZSELo/NOljXxirvptqzExTo+96dH4lgN8I=;
        b=G9iNeiHmCyay/m8KYcNdtNoZ3aISDNZOoVKuJWwpMFo9gKFVSinjhWKx4S4qNr7B0R
         I11di3q39iSDwt4FC14bKIRTmMYKDLETRa3m3ZHksmU0FrnVn5ZbwGbpEeOEY+5Cu2TA
         PPutfn0ix1lbLrGQjULhDNF6Ar4qG3t5fZ6s5OohPR9Pk26auvrtjU0gKquF/cYl8tNZ
         3dMC2BOwxzEADt6rkVEx7J6Y6QzUXxeQ/IF4y3K21ITVH2VG8XymTz5ewHEYRD4RncfY
         uDV6jQj0rzWwA5CKvbHjZGOf37hKzA9ix3zDSDdlPj3ykH1t9k3X1XcmRvRd90qSJ2Lv
         QLIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=NqWldGNpwZSELo/NOljXxirvptqzExTo+96dH4lgN8I=;
        b=1FPeKAhGvKQV15GO7+WgqAM6U2HyJwee9lz62bplYL/gHX1vsoVdZCIbuVA/4UH3bY
         NtIqUlDAgpJqdx3WFbvALSdh3NTKQKVbeC+mvptgxWeCgCCmm20UCir3DEoYWEw8Xu2L
         tAaONX3yp7xpzlKWf+nR/Yz/g6LrfAkw+6u7yK92y/njeudgZnEOlBZi+pQAHSek4L0g
         jl1QA+86RTBWhI5HUprJEl1M6C4JH7pXwjDlaag18rnuo1mFHh0E6B5ZQsnPXF1S4qNo
         FIq3rfSW1rJbkv5uO3H0pu2HNz0SNmKgCibDMpjI8A8goI6RbOluvXaC7lpao//fiVHS
         7XZg==
X-Gm-Message-State: ACgBeo0PvianJrh/1aHI8GTzRK+4JoibGcU6/zHMgx6DnJwuWlf7O6pF
        WzeVkfrPO119qu6w0d7QPa/4YgTC7RXyMGTrJBU=
X-Google-Smtp-Source: AA6agR76KtiC6o0Wf+hQUzMWDHcQcqNTf+4w5zlfHZX/GCsknGl5jJartyCJECQj8pW7lTTdUuILGKCJKDi0nZYQiQU=
X-Received: by 2002:a65:6a0c:0:b0:429:7ade:490b with SMTP id
 m12-20020a656a0c000000b004297ade490bmr8187301pgu.621.1660702825995; Tue, 16
 Aug 2022 19:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220816032846.2579217-1-imagedong@tencent.com> <CANiq72mQpZ-z1vVeOwdaOB3b=jjQHtPwz3-jaPRV330-yL_FqQ@mail.gmail.com>
In-Reply-To: <CANiq72mQpZ-z1vVeOwdaOB3b=jjQHtPwz3-jaPRV330-yL_FqQ@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 17 Aug 2022 10:20:14 +0800
Message-ID: <CADxym3Y1ZoWrkGW3v4PbVMvbEYnoFgHmFXCD-QpY4Of9hrAxBg@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     kuba@kernel.org, ojeda@kernel.org, ndesaulniers@google.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>
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

On Tue, Aug 16, 2022 at 5:02 PM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Tue, Aug 16, 2022 at 5:29 AM <menglong8.dong@gmail.com> wrote:
> >
> > Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
>
> Hmm... Why did you add me as a reporter?
>

Enn...because you pointed out my code's problem, just like what robot do.
Shouldn't I?

> > + * Optional: not supported by clang.
> > + * Optional: not supported by icc.
>
> Much better, thank you! Please add the links to GCC's docs, like in
> most attributes (some newer attributes may have been added without
> them -- I will fix that).
>
> In any case, no need to send a new version just for this for the
> moment, I would recommend waiting until others comment on whether they
> want `__optimize__` used here as the workaround.
>

Okay, I'll wait longer before the next version.

Thanks!
Menglong Dong

> Cheers,
> Miguel
