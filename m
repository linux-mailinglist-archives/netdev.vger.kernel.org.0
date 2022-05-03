Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797B751837D
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbiECLwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 07:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbiECLwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 07:52:36 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465D335A92
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:49:04 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id y63so17896413oia.7
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 04:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bSXV9PrUUGhVycOu/J4fBj5chKdIrO0Ql5olYi0vSd8=;
        b=EhLk4QD8o470moC0OQtXUJEkeGOuhJP7m3BdSFzrKvpKeHc++CQ5VcBNB8p+t/+ULb
         mUs0X7+NoyUX71r4F4Q6AqvPde/whddEC8nQgV7/xuf543eAWAourHoKkPFOJIVkJ7f5
         y5S8nlT5aC3a9dDgieTz47gxlMOYr7Fq+aor/UlSZpj5j4euCtAGzUU6xKKogQ7B2GID
         bCDIgFY52vnw19sjxzyI8JFWMW3iwMEo4+N/DPmGXgTUmP0vrhPGU2Yb7CNN3YJ0BJxk
         v0UUrXC5KaM/A6D9gMwaP6XrN3FgYA8EFuKmgSEuQVmzC+EFHcPsMnGdc4JYv7c99/Go
         txgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bSXV9PrUUGhVycOu/J4fBj5chKdIrO0Ql5olYi0vSd8=;
        b=QUOXAaoNX5pHafe5xb9DrXSJ0C1HPp+y6PSmr7boDAkT7JBzJD9Xhr5WE8uDbzuL9c
         yFLAmKB5xnhlPwYjxQ07sO3bdq9fCnnJ5gj/ct7/cIkvlnRyyi+hdZO2IlUOAE0R2Kuh
         PFXuMrvv1bGUex1BREObzuZUALNtAJK8BadAnhKHygkI3YvTHvXUcDSAIWJA+jdySGdn
         ncjbeT1AouiU+6iWTasByULoTYzWSPK47iLTt/lFBEbFiG6jxnUwXoZbNyKlgvNyHXxT
         cYSWXr32TTChwyZKdjiZuf1XjcQhEpx/X/Z0nprt/I/lMSqGp7DyhJb0Mx2r0ZNzas0a
         kYDg==
X-Gm-Message-State: AOAM531u8/NkqmkP95HXzu5mzIhUwX3UZjrld80FPjJailfhF3yeECFQ
        4M82I0UhtP5bnZ8OuxYjqBWusmsLGyCXqXyWrJdvCQ==
X-Google-Smtp-Source: ABdhPJwyBTRJk8+J4ioWmZvVzAmOxgN9NvzBheRx+KThLSEpiOI0+072NTxNv0o0eTMZHbWGo3hi4tpUZTNUUEX+OPQ=
X-Received: by 2002:a05:6808:f0f:b0:326:29af:dd2d with SMTP id
 m15-20020a0568080f0f00b0032629afdd2dmr1587521oiw.211.1651578543310; Tue, 03
 May 2022 04:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000264b2a05d44bca80@google.com> <00000000000070561105dbd91673@google.com>
In-Reply-To: <00000000000070561105dbd91673@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 3 May 2022 13:48:52 +0200
Message-ID: <CACT4Y+aV-3dT7QDSs1a+yuJ_AZHJZQYDEK4fKwC-ZjsP+65LJg@mail.gmail.com>
Subject: Re: [syzbot] WARNING in cpuset_write_resmask
To:     syzbot <syzbot+568dc81cd20b72d4a49f@syzkaller.appspotmail.com>
Cc:     cgroups@vger.kernel.org, changbin.du@intel.com,
        christian.brauner@ubuntu.com, davem@davemloft.net,
        edumazet@google.com, hannes@cmpxchg.org, hkallweit1@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        lizefan.x@bytedance.com, longman@redhat.com, mkoutny@suse.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Apr 2022 at 21:25, syzbot
<syzbot+568dc81cd20b72d4a49f@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit d068eebbd4822b6c14a7ea375dfe53ca5c69c776
> Author: Michal Koutn=C3=BD <mkoutny@suse.com>
> Date:   Fri Dec 17 15:48:54 2021 +0000
>
>     cgroup/cpuset: Make child cpusets restrict parents on v1 hierarchy
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D142f17f770=
0000
> start commit:   e5313968c41b Merge branch 'Split bpf_sk_lookup remote_por=
t..
> git tree:       bpf-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc40b67275bfe2=
a58
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D568dc81cd20b72d=
4a49f
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13bb97ce700=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D12062c8e70000=
0
>
> If the result looks correct, please mark the issue as fixed by replying w=
ith:
>
> #syz fix: cgroup/cpuset: Make child cpusets restrict parents on v1 hierar=
chy
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion

Based on commit subject looks reasonable:

#syz fix: cgroup/cpuset: Make child cpusets restrict parents on v1 hierarch=
y
