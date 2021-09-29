Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929EE41BEAC
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 07:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243949AbhI2FYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 01:24:38 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:35874
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242445AbhI2FYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 01:24:37 -0400
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9187A40318
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 05:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632892976;
        bh=MnfWci33OxaIqWkhaUWKgeCRCJGFxddYrn7zGjAWBHA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=A3E908NKT5lrxierITA4ef/Bz19YWD3rL6Cga4Ny5DhETDk3fQQ5xP5zHN6ZX9lNn
         kft1foZh/cC12afLpFAWeMoR4T/dWqyRQp7DFj+eOz2S30AqBgY2vU7UjgN53d8SqW
         AwoNgULFA/RuTpxQCY0zRt2mN0YcHAlcmq0YG86PrMB+AE8p6onP9/OYG+MBf0x0uN
         QTQTBpxE4so5SL6eJJXL96wJKJm3+gSlA8xpNibkzpTu0tIzvC6UzmPPHYNmEvCAfd
         XpRztnsOSDHCPjh+bIqV+A68KLJ3PG7Cyv0+UEm1TtswzuRWuVgsoEV4Pf2SwGY+PI
         XIfb6ks+tDzfw==
Received: by mail-pl1-f200.google.com with SMTP id n2-20020a1709026a8200b0013e2253d774so631843plk.14
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 22:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MnfWci33OxaIqWkhaUWKgeCRCJGFxddYrn7zGjAWBHA=;
        b=5byTiuFIPdqe/bFh6MmXbjMuCEdezjMwyHI7WBKyl8gSijw8YpCBtZ8qshk+P+uSiY
         h0oxM42TIk8SPZLHKwnSqGw8l97PCzzPx3fX5Y7qT8ut6p+pK6aWkwIq1zet9H4ihtCv
         92vv7qFoXdQ/R0F7jrO7Ivtf7I5WJajHQr8tMvaNCmOndmvsXesGIJpYdqo1iM0gkIrn
         kqHKuXjimMNyeGSwXuv+SMOQyavpXoxuG05llsUfji3MXSwfFo18iWXB84VMvAa5f8ss
         MCvR9WS0oPEaK1ComFfzjReXe/Aig2AA370cm3o3dnknkeRjOFbi7j4SFVkbMR9KGdlp
         PDvg==
X-Gm-Message-State: AOAM530J405PJ2c0liXW2dlPSruyRUYEMEztIKSBbIaGOGIPVfZfyNNj
        b3JZUTJEo4J/eE8h7Aja2Qoj0AZ3RjxcUu7wwPZWnblc6InsHUNFmk5moXff6Tp3PejVMSW1l4j
        3Tfpzt4at9jntvrALe+i/JOS75xixu+7k4roFGbB9UfBkggrS
X-Received: by 2002:a17:902:c205:b0:13e:6097:b992 with SMTP id 5-20020a170902c20500b0013e6097b992mr356402pll.88.1632892974837;
        Tue, 28 Sep 2021 22:22:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwe8IyOlbCT51ICJiY1uJcNZ5fZbmOaqVjrN7mA1wMd1ahpwf2AhqRpxfpONAKrmSs5BjZzbTIu2c62FHkYrnM=
X-Received: by 2002:a17:902:c205:b0:13e:6097:b992 with SMTP id
 5-20020a170902c20500b0013e6097b992mr356367pll.88.1632892974439; Tue, 28 Sep
 2021 22:22:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210823030143.29937-1-po-hsu.lin@canonical.com> <87h7fdg8pr.fsf@cloudflare.com>
In-Reply-To: <87h7fdg8pr.fsf@cloudflare.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Wed, 29 Sep 2021 13:22:54 +0800
Message-ID: <CAMy_GT8=vViQOGANARcTb4qyB4635nLC=XAFZTijchou+Aa9Dg@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: Use kselftest skip code for skipped tests
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        hawk@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, kpsingh@kernel.org,
        john.fastabend@gmail.com, yhs@fb.com, songliubraving@fb.com,
        kafai@fb.com, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 5:44 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Mon, Aug 23, 2021 at 05:01 AM CEST, Po-Hsu Lin wrote:
> > There are several test cases in the bpf directory are still using
> > exit 0 when they need to be skipped. Use kselftest framework skip
> > code instead so it can help us to distinguish the return status.
> >
> > Criterion to filter out what should be fixed in bpf directory:
> >   grep -r "exit 0" -B1 | grep -i skip
> >
> > This change might cause some false-positives if people are running
> > these test scripts directly and only checking their return codes,
> > which will change from 0 to 4. However I think the impact should be
> > small as most of our scripts here are already using this skip code.
> > And there will be no such issue if running them with the kselftest
> > framework.
> >
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> > ---
> >  tools/testing/selftests/bpf/test_bpftool_build.sh | 5 ++++-
> >  tools/testing/selftests/bpf/test_xdp_meta.sh      | 5 ++++-
> >  tools/testing/selftests/bpf/test_xdp_vlan.sh      | 7 +++++--
> >  3 files changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_bpftool_build.sh b/tools/testing/selftests/bpf/test_bpftool_build.sh
> > index ac349a5..b6fab1e 100755
> > --- a/tools/testing/selftests/bpf/test_bpftool_build.sh
> > +++ b/tools/testing/selftests/bpf/test_bpftool_build.sh
> > @@ -1,6 +1,9 @@
> >  #!/bin/bash
> >  # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >
> > +# Kselftest framework requirement - SKIP code is 4.
> > +ksft_skip=4
> > +
> >  case $1 in
> >       -h|--help)
> >               echo -e "$0 [-j <n>]"
> > @@ -22,7 +25,7 @@ KDIR_ROOT_DIR=$(realpath $PWD/$SCRIPT_REL_DIR/../../../../)
> >  cd $KDIR_ROOT_DIR
> >  if [ ! -e tools/bpf/bpftool/Makefile ]; then
> >       echo -e "skip:    bpftool files not found!\n"
> > -     exit 0
> > +     exit $ksft_skip
> >  fi
> >
> >  ERROR=0
>
> This bit has been fixed a couple days ago by a similar change:
>
> https://lore.kernel.org/bpf/20210820025549.28325-1-lizhijian@cn.fujitsu.com
>
Hello Jakub,

Thanks for the feedback, I have submit a v2 patch for this:
https://lore.kernel.org/bpf/20210929051250.13831-1-po-hsu.lin@canonical.com/

Cheers

> > diff --git a/tools/testing/selftests/bpf/test_xdp_meta.sh b/tools/testing/selftests/bpf/test_xdp_meta.sh
> > index 637fcf4..fd3f218 100755
> > --- a/tools/testing/selftests/bpf/test_xdp_meta.sh
> > +++ b/tools/testing/selftests/bpf/test_xdp_meta.sh
> > @@ -1,5 +1,8 @@
> >  #!/bin/sh
> >
> > +# Kselftest framework requirement - SKIP code is 4.
> > +ksft_skip=4
> > +
> >  cleanup()
> >  {
> >       if [ "$?" = "0" ]; then
>
> Would consider making it read-only:
>
>   readonly KSFT_SKIP=4
>
> [...]
