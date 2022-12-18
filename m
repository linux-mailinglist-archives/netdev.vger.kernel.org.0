Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DD664FD31
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 01:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiLRAIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 19:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiLRAIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 19:08:37 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92B9FAFA;
        Sat, 17 Dec 2022 16:08:36 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id y25so8780256lfa.9;
        Sat, 17 Dec 2022 16:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Zy6O1GJ+MpQRSh8rSrTdEP7Jjp+UuQJ4HR2UeftiX/A=;
        b=CIiR38NLTS1pl7pq0rfnIBEyRAvaZJlv4ygCeFvqn/KYT/AK1QER8eGWEv2en/yosY
         F6U7wQRhFRTNvQEs/EX/0I8vD9GQT7W0Q6io//gZzYYQq4NFy6Ak8ijRPjYFq5Nz3OI3
         tay80XJ31CQ93yDJEKIccpbTwi6eNgGBJj+fhzqvj0X0Ka1kAKxp3iDfyUJv1kJcosvg
         SmGZ1wTmd+2pWPap2jn+G1EQYQpeUqxtveOaSDsELdSAQZYg2q9NhF6QYX3NipfXX79w
         l1+DNdpIs7rjHrF+4V7M0n70GI0Ijh4aRzDsWnYyQuh+k4qNaDMW1X8IoQx6Sz8LT2Fi
         oNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zy6O1GJ+MpQRSh8rSrTdEP7Jjp+UuQJ4HR2UeftiX/A=;
        b=NgTanW7ln/Y2xk8AyUVeePYgDEX4+RJuXYn4CBtOoFSzuGapbVJxKPKm+2Aeecpciq
         3l7a/pGkmKfB/Ju0iqrok2XJZXmItjlsbXBsS7apEcxHA1FWGN4hr7qfrKacFilzvSay
         63SOpALerdsmPGOqgOed3e6mcQOQz7sBXrRS7bmmNzcL4UuO44HwRCOSs2L3d4/urj7t
         4iwy1I7eDctnle1xgs8GyV1AxprflAu9iaH+xxMBSNJsYk340oAVd4ifrmpeLAUm6pRK
         RWk3mozIdFnARcyPxjjqCsdJJ3o5bWdCuxHZehyC2XIvNH07KFhxbeiHmKKl1Vas3+sl
         +2qA==
X-Gm-Message-State: ANoB5pnES/NzW0JA8qKLAb6R3g12nXle5tKv5vJ2IiYQgz1KDIhd2r3C
        RBp0V63TMtUT1R1MrDKjab2Pbn5ZbR6CLRSMHQ==
X-Google-Smtp-Source: AA0mqf4old/eUlYF3puPcZJtsWraKtEUbODrDYILemuVTv+giTBiJgn3ba+9ScVZOJj+SzUEo3dk+mVurqK1ZCeHacc=
X-Received: by 2002:a05:6512:258b:b0:4b5:a5c7:3289 with SMTP id
 bf11-20020a056512258b00b004b5a5c73289mr3650150lfb.8.1671322114906; Sat, 17
 Dec 2022 16:08:34 -0800 (PST)
MIME-Version: 1.0
References: <20221217153821.2285-1-danieltimlee@gmail.com> <fe2bf0e5-9b5e-51fe-d6c8-55390f75313d@meta.com>
In-Reply-To: <fe2bf0e5-9b5e-51fe-d6c8-55390f75313d@meta.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sun, 18 Dec 2022 09:08:18 +0900
Message-ID: <CAEKGpzjrQ_6c1XqR2s2T-Zkgknpqbo_P_3JN4PySh9MHE9fC2Q@mail.gmail.com>
Subject: Re: [bpf-next 0/3] samples/bpf: fix LLVM compilation warning with
To:     Yonghong Song <yhs@meta.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 18, 2022 at 2:48 AM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 12/17/22 7:38 AM, Daniel T. Lee wrote:
> > Currently, compiling samples/bpf with LLVM emits several warning. They
> > are only small details, but they do not appear when compiled with GCC.
> > Detailed compilation command and warning logs can be found from bpf CI.
>
> Could you change the subject line to
>    samples/bpf: fix LLVM compilation warning
>
> >
> > Daniel T. Lee (3):
> >    samples/bpf: remove unused function with test_lru_dist
> >    samples/bpf: replace meaningless counter with tracex4
> >    samples/bpf: fix uninitialized warning with
> >      test_current_task_under_cgroup
> >
> >   samples/bpf/test_current_task_under_cgroup_user.c | 6 ++++--
> >   samples/bpf/test_lru_dist.c                       | 5 -----
> >   samples/bpf/tracex4_user.c                        | 4 ++--
> >   3 files changed, 6 insertions(+), 9 deletions(-)
> >


Thanks for pointing this out.
I will send a v2 patch.
