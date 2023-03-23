Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A70B6C6693
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCWLaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCWLay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:30:54 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E53AD27;
        Thu, 23 Mar 2023 04:30:53 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i9so20057376wrp.3;
        Thu, 23 Mar 2023 04:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679571052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zY62E3taIidO3hGOd5wWvRP3S0XrrcHHNrzlQQ+yG/I=;
        b=AUHkdaJRAmsu/4O6t590y2vFDiDXILgf/TkRzJNc4RFIBjztdmAZ8TZMiSywCEm9I2
         KfrFWPVv0iHtZbdbPinviv0cz8eMWUr2muJ7YR6ld91vO/L4f9GcBbCBBMWtVL6jrC8s
         Yx0x5JzdQ1LQ+5/hr5EaHFlDcgEaeoIy7dNy9s4ZnyxmXu94LqDaw/SqwXp2nDhElLAO
         WFPcz0eozGTdY1KqRiO3WgUPwATBFeRTqBVGt71L5gZDWxVMjkGyf5Kubr7GLTiu7Bc5
         pA2PgRDQIvC9tRGDI1erHTTR5KLN+7++i4M2c+kY3mIpWCLPzoKwbXN7JFlCPy6ZR6Ed
         Oqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679571052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zY62E3taIidO3hGOd5wWvRP3S0XrrcHHNrzlQQ+yG/I=;
        b=Lmm7NPoCltoExHh5Hz6E3zzAIJQqnYiqmMGooAqZ4luv69gbowS9ZelicXRbtKSHAG
         9RVU6vzyhLlMeCCvZn50WyRaKftRqaySnUX0kJmO+/RdTvccixfaoq6HuOmyWILWiuZ0
         WMnto/0GSs1AhQonYxJ7ig3R3nWOOkv1dpzG9FE0q4o/1Wj3RkhBorX8zaQ6S9zEyr/U
         vdR4YpN2AP6sH8FKN12idMFwQ6ug9tW52w+2zGR3tycHxRlwe2F/NGbCWRLZuyUfvdRA
         woDbg+ysbmEtKiFKf3JJpccfXB7BlGpPZjuE6Df0oNpQuUTXfVdTmnoTXAiOahbjcSEW
         AsLg==
X-Gm-Message-State: AAQBX9exMoPy+44p35gTgGtrdqPSNz6lifn9TaXrN1RCUDfqEawDsOg/
        xV0vIzxFzNpyb8TGxjGlEg8=
X-Google-Smtp-Source: AKy350Z1Cq3tJUQbPKAwFACOfc9Qhkl/i3pVwrVprLRUk7xFFOAsGg7Y6IfkICzatZxCkNdXugM++Q==
X-Received: by 2002:adf:ec0b:0:b0:2d7:4c98:78fe with SMTP id x11-20020adfec0b000000b002d74c9878femr2640551wrn.34.1679571051623;
        Thu, 23 Mar 2023 04:30:51 -0700 (PDT)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id b15-20020adfe30f000000b002c706c754fesm15993836wrj.32.2023.03.23.04.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 04:30:51 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 23 Mar 2023 12:30:48 +0100
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+c49e17557ddb5725583d@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, boqun.feng@gmail.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        fgheet255t@gmail.com, haoluo@google.com, hawk@kernel.org,
        hdanton@sina.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, longman@redhat.com,
        martin.lau@linux.dev, mingo@redhat.com, netdev@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, sdf@google.com,
        song@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, will@kernel.org, yhs@fb.com
Subject: Re: [syzbot] [bpf?] [trace?] possible deadlock in bpf_trace_printk
Message-ID: <ZBw4aDjCv6kwuxzQ@krava>
References: <0000000000006294c805e106db34@google.com>
 <000000000000690cbc05f779cba8@google.com>
 <CACT4Y+Z1Vm+ci43qnoZiF89mo_R1eQV0Cd9Y_MUNoXD1FytR2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Z1Vm+ci43qnoZiF89mo_R1eQV0Cd9Y_MUNoXD1FytR2A@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 08:50:10AM +0100, Dmitry Vyukov wrote:
> On Wed, 22 Mar 2023 at 10:29, syzbot
> <syzbot+c49e17557ddb5725583d@syzkaller.appspotmail.com> wrote:
> >
> > syzbot suspects this issue was fixed by commit:
> >
> > commit 05b24ff9b2cfabfcfd951daaa915a036ab53c9e1
> > Author: Jiri Olsa <jolsa@kernel.org>
> > Date:   Fri Sep 16 07:19:14 2022 +0000
> >
> >     bpf: Prevent bpf program recursion for raw tracepoint probes
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a653d6c80000
> > start commit:   a335366bad13 Merge tag 'gpio-fixes-for-v6.0-rc6' of git://..
> > git tree:       upstream
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9e66520f224211a2
> > dashboard link: https://syzkaller.appspot.com/bug?extid=c49e17557ddb5725583d
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e27480880000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12737fbf080000
> >
> > If the result looks correct, please mark the issue as fixed by replying with:
> >
> > #syz fix: bpf: Prevent bpf program recursion for raw tracepoint probes
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> Looks reasonable:
> 
> #syz fix: bpf: Prevent bpf program recursion for raw tracepoint probes

agreed, thanks

jirka
