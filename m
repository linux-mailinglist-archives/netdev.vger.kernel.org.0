Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7F76C6122
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 08:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjCWHu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 03:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjCWHuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 03:50:25 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8531B324
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 00:50:24 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id s8so26298134lfr.8
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 00:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679557822;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IlLAgQAMrY+Qapa3HyIEMrrk5zkFmAKmKhKxYGqlRfA=;
        b=X2pZvw8F39X1gqKZVD2n/DZSu2hANXRU4xGF6wdBeoJrF60vbYwLuvWcCYMSoO2/cG
         WvIgjsqj11antMece7AYvd1g6iaS1ccg/JUzkslCbjCmGTVF4r6gOBb+PcH5ERzCwtgz
         MWTPXJ8Dh5ucwqM4NrcyqgBdQwvpqE7zdKxsAyzxmZJ6smmqAOAGJ/pPCGfonij0pYoS
         3uAB9OgAnYlWap7grV8I3amlHxJFJOF56WnlVnyGXJvAAky6axmybPjLu/tXYwyQvFuH
         51bA0q7T953hvaeB6RVCPY8ZUbbA2KiLTIwfwrbhoBzuHYcI+ELJWjqlMGe6CAuk7raF
         +ucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679557822;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IlLAgQAMrY+Qapa3HyIEMrrk5zkFmAKmKhKxYGqlRfA=;
        b=UVYblTyVbD525H1afx1OPECEfmChCfHYJ4qAzEMgfh0ec4GUbIGXXbw+L4iQqtYGcP
         Hr/dLC9KppjZuc4vqoX3ax9TVMUzxYr9+XrDoB0y1S8A8aKUveb6Izom+EF2VRaTTgEc
         /4j38FV+S4hxEcnn57K2RP7YhzqyWLZYzMm2IpzjUxMwMpZGbIAflfv12q2NwuKH1RG3
         zT0SWaTPogUnm0aNqLjUF3XWZN9jVfNPfDnNNVUFb3Ufj2Ve9JG7QD7TQK8AoD3Sl1Zr
         nCEUXfKyi+gG5jCI9/qqcvqk2Ie4hPVPlIF7iheubGcj2XdFkmOq0jZnqewL/gpDYEWs
         sSdw==
X-Gm-Message-State: AO0yUKVGTa1RHM2MBs+CXzB7RQOS37I8loSNTope2cS1v6v9YWx7hjcZ
        RcKo/KZX9ERC5+7/nOIfoe8vyxEVhvKEv1E16Rj5sg==
X-Google-Smtp-Source: AK7set+AZnZ7RpTuuN1sbeWai2Zv6NPiiOXrLxauD56bQOThNui9RIOxVfAjNA3Zd4PBGiqVBF7PkHS6aCBTMvredJo=
X-Received: by 2002:ac2:5607:0:b0:4dc:807a:d147 with SMTP id
 v7-20020ac25607000000b004dc807ad147mr2820080lfd.6.1679557822371; Thu, 23 Mar
 2023 00:50:22 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006294c805e106db34@google.com> <000000000000690cbc05f779cba8@google.com>
In-Reply-To: <000000000000690cbc05f779cba8@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 23 Mar 2023 08:50:10 +0100
Message-ID: <CACT4Y+Z1Vm+ci43qnoZiF89mo_R1eQV0Cd9Y_MUNoXD1FytR2A@mail.gmail.com>
Subject: Re: [syzbot] [bpf?] [trace?] possible deadlock in bpf_trace_printk
To:     syzbot <syzbot+c49e17557ddb5725583d@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, boqun.feng@gmail.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        fgheet255t@gmail.com, haoluo@google.com, hawk@kernel.org,
        hdanton@sina.com, john.fastabend@gmail.com, jolsa@kernel.org,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        longman@redhat.com, martin.lau@linux.dev, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        sdf@google.com, song@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, will@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 at 10:29, syzbot
<syzbot+c49e17557ddb5725583d@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 05b24ff9b2cfabfcfd951daaa915a036ab53c9e1
> Author: Jiri Olsa <jolsa@kernel.org>
> Date:   Fri Sep 16 07:19:14 2022 +0000
>
>     bpf: Prevent bpf program recursion for raw tracepoint probes
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a653d6c80000
> start commit:   a335366bad13 Merge tag 'gpio-fixes-for-v6.0-rc6' of git://..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9e66520f224211a2
> dashboard link: https://syzkaller.appspot.com/bug?extid=c49e17557ddb5725583d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e27480880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12737fbf080000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: bpf: Prevent bpf program recursion for raw tracepoint probes
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks reasonable:

#syz fix: bpf: Prevent bpf program recursion for raw tracepoint probes
