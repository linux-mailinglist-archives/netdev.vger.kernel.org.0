Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEF94BAC4E
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 23:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343796AbiBQWJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 17:09:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiBQWJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 17:09:02 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3795131DFD;
        Thu, 17 Feb 2022 14:08:47 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id h5so5435426ioj.3;
        Thu, 17 Feb 2022 14:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MvHgL1DDyp9a3YBp2kBM2BvI5xMzXo1uXFaW8xYa9VQ=;
        b=LWIReTy3/Y2ZzNwQdcovQB/OheMvC5rGghHA4r+XaTGiActrh+vUk9+DY+pAym12IG
         O2jqZX+f7b1To8N+JwxptCA/ZFo+6VZSL10TwtHPZztoBsGk4si7zypYi03hL3kE0tHz
         14FgQ0wp2VQ6wI00/bxTtWR9sRVt9w7hxRPhmpITt3XhvrE4AiWMp97VFS884A0uHchU
         U9fea8MawkpIkb/8nXL8EYK8DAH5f58kgx0/HPbMm1+bqlovF+RhqZXBLml3t+INuK22
         i5Lp12IXyq/q/JFl05YlIHAmAZpV0U/LbS542D3NxLQJS4SuhBBIXQYcWMSWvI3fTfSL
         Qsfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MvHgL1DDyp9a3YBp2kBM2BvI5xMzXo1uXFaW8xYa9VQ=;
        b=gN8ufJV+fJYLbpwcVTNNMZ3rhdzw7Jn4fFRfPrT4t+60/teiyL7kHCkWv5j2dHqUO7
         Tr4XCuk82cXLe359+s1wZeUQ4MSkfrsPDttKdwRlcQb/YDHlh+3W9ncB0mS5G/p/CnLY
         6QEULSlPF9wZtCzSlHTm4h2efiIHMSJSHp47K1bRu5/RYd05KzPEWBaxJ17k/FDJbbCp
         4psPq1AAyLtG0TDy1zFf9trsI3UFC292+ItYWFz5EcwOL5HhKmY2GSygaKxTenb2Gzjy
         5h40NHhyaxEHPZ3GTNo9BEFgsc+wS61DwAMVnzAFlI0q5AhSTIZYwCx7sROX2y0wnhKX
         MoKw==
X-Gm-Message-State: AOAM5314/MJbD/VdEEsFgF0LpL2cbw1eelrShlAJVQdxgnSmsxWcb9kV
        oUxh5RjOkYycjND5mHv5ErAwfTv5yeCxnzLCo8m7Y8UK1Vqjgg==
X-Google-Smtp-Source: ABdhPJw3PWH+Ott/aq6AcqA8ep7kzWR5lFsSHsjNt3vzSPhR1XM1P+5Rg9oKOCQQwQxfq7rJhT3svyiZGvo2sDmPyDw=
X-Received: by 2002:a05:6638:24d0:b0:314:4ed8:da5f with SMTP id
 y16-20020a05663824d000b003144ed8da5fmr3260159jat.93.1645135726648; Thu, 17
 Feb 2022 14:08:46 -0800 (PST)
MIME-Version: 1.0
References: <7b2e447f6ae34022a56158fcbf8dc890@crowdstrike.com>
In-Reply-To: <7b2e447f6ae34022a56158fcbf8dc890@crowdstrike.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Feb 2022 14:08:35 -0800
Message-ID: <CAEf4BzbB6O=PRS7eDAszsVYEjxiTdR6g9XXSS4YDRh8e4Bgo0w@mail.gmail.com>
Subject: Re: Clarifications on linux/types.h used with libbpf
To:     Marco Vedovati <marco.vedovati@crowdstrike.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Martin Kelly <martin.kelly@crowdstrike.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>
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

On Tue, Feb 15, 2022 at 4:58 AM Marco Vedovati
<marco.vedovati@crowdstrike.com> wrote:
>
> Hi,
>
> I have few questions about the linux/types.h file used to build bpf
> applications. This file gets included by both userspace applications using
> libbpf and by bpf programs. E.g., in a userspace application:
> foo.c
>   foo.skel.h
>     bpf/libbpf.h
>       linux/bpf.h
>         linux/types.h
>
> Or in a bpf program:
> foo.bpf.c
>   linux/bpf.h
>     linux/types.h
>
> libbpf provides its own copy of this file in include/linux/types.h.
> As I could understand from the Git history, it was initially copied from
> linux include/linux/types.h, but it is now maintained separately.
>
> Both linux bpftool and bpf selftests however are built using another
> types.h from tools/include/uapi/linux/types.h.
> Is there a reason why bpftool and selftests aren't built using the same
> types.h distributed by libbpf?
>
> I also see that the license of the three files differs:
> - (libbpf) include/linux/types.h is "LGPL-2.1 OR BSD-2-Clause"
> - (linux) include/linux/types.h is "GPL-2.0"
> - (linux) tools/include/uapi/linux/types.h is "GPL-2.0"
> Is there a reason why tools/include/uapi/linux/types.h isn't licensed as
> "GPL-2.0 WITH Linux-syscall-note"?
>
> Finally, would it make sense to also have libbpf use
> tools/include/uapi/linux/types.h instead of its own copy?
> The advantages would be:
> - consistency with linux use
> - the only architecture specific header included is "asm/bitsperlong.h",
>   instead of all the ones currently included.


include/uapi/linux/types.h (UAPI header) is different from
include/linux/types.h (kernel-internal header). Libbpf has to
reimplement minimum amount of declarations from kernel-internal
include/linux/types.h to build outside of the kernel. But short answer
is they are different headers, so I suspect that no, libbpf can't use
just UAPI version.

>
> Thanks,
> Marco
