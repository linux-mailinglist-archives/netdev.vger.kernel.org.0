Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBECD5953A8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbiHPHYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbiHPHYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:24:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465B82C922C;
        Mon, 15 Aug 2022 20:30:55 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id k14so8299339pfh.0;
        Mon, 15 Aug 2022 20:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=P1ObS2Ks4kjBRkWKn0mTEfRTELGUp7wMDYb+ScsU4UA=;
        b=fSxPpxevvj1qJBqzaHMjw1Ls7IWVszx+J6lgCpDdFJXF1JvXXNOPcJOAkvR4FPIjd1
         qFLVmFhFi6I6XkDYZCaqWOPdTd+znVbExdQb/GUuGjraM9/y/KhJBB50qTOPPfHM2v46
         3dLHuK4itNpokN5SWZOjaa2aTRXgM1ni95OVY1RwShPv09mZ7Pu5KEo09LYICplZAt7m
         lAWDJzV5d2P0ikziLIV2TVC+gGOrQYLZ+SqudiZAymB4MahqOsbexCnyGV00TcT5UoB0
         flhoKXGFP/t29BzYvoZOjgBQg4t41ThZcY1dNP6wQeL3M6FRA1KKM38ZRs/vykTQdI8j
         yq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=P1ObS2Ks4kjBRkWKn0mTEfRTELGUp7wMDYb+ScsU4UA=;
        b=spT3wWQHk2mHFbdtvvZ+BynWOpCvNlYystQkQy5A2WZzg5Lr40QZzecMpqmc4e7bOy
         hdy+92q8TKDsQHWqWNCpkYYdoe7H8zQL4LGDN7uNkLsVdlIgT3Av+3TMlwN/5fPvcxhC
         5m7nA3wQUbMqmeZA13TSX/gfTF0jmF5e5FH2yMWqhiPU4H5xBe7mr1ox1LTtyflrYZAL
         bApHJFtHxKhRSt/kjPjwTOGoLRkkA/zYr+TpK7g/OkskmyMCRYtJ5Oh+F7u9QS9F7hqf
         wem0YAsTyXCD3Bof7PZj3ehqhoK+wwstentQH/RQ59aMiUlBLym7Yr6zV5SNz/N0tGtu
         Qp/w==
X-Gm-Message-State: ACgBeo0hqiOnjOIInizTfTg7WmSGNMb4es3QisCPCeesyqBjAYpG3rx1
        0gCffVKF+ut3+2PoE4wQyq+a8K3/uV/8yyVSnc0=
X-Google-Smtp-Source: AA6agR5FUwb36fCXc58Tr80N2474jeS+A4xJF4DoAJBA9UUfPktru8hbWIAz25MhebnsO9i8WLPLs4rtyzyVMD5fTZU=
X-Received: by 2002:a65:6a0c:0:b0:429:7ade:490b with SMTP id
 m12-20020a656a0c000000b004297ade490bmr4442285pgu.621.1660620653469; Mon, 15
 Aug 2022 20:30:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220815062727.1203589-1-imagedong@tencent.com> <CANiq72=01dzC5zs6-7Y4qrKYoFE1JpKes0ykN+x=FgGSmt9PCg@mail.gmail.com>
In-Reply-To: <CANiq72=01dzC5zs6-7Y4qrKYoFE1JpKes0ykN+x=FgGSmt9PCg@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 16 Aug 2022 11:30:42 +0800
Message-ID: <CADxym3YnD=eP4n_RCrKy67z55e=tQZDNuJUw9hpTKZ6JNwspaA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: skb: prevent the split of
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

On Mon, Aug 15, 2022 at 7:52 PM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Mon, Aug 15, 2022 at 8:27 AM <menglong8.dong@gmail.com> wrote:
> >
> >  include/linux/compiler-gcc.h   | 12 ++++++++++++
> >  include/linux/compiler_types.h |  4 ++++
>
> No, this should be in `compiler_attributes.h` like you had it before.
>
> To be clear, what you did here would be fine, but it is the "old way"
> (we added `compiler_attributes.h` to reduce the complexity of
> `compiler-*` and `compiler_types.h` and make it a bit more
> normalized).
>
> Please take a moment and read how other attributes do it in
> `compiler_attributes.h` with `__has_attribute`. Check, for instance,
> `__copy`, which is very similar to your case (not supported by Clang
> and ICC, except in your case GCC always supports at least since 5.1).
>

Okay, I think I'm getting it now! Thank you, and I'm sending the V4.

Menglong Dong

> Cheers,
> Miguel
