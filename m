Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF80E4868C6
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 18:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242076AbiAFRka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 12:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242030AbiAFRk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 12:40:29 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02101C061245;
        Thu,  6 Jan 2022 09:40:29 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s15so2944919plg.12;
        Thu, 06 Jan 2022 09:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tIKL4QCS/ApvsfELc5xJTB2C5HIErojH+gu7cSOEmuc=;
        b=L9f/zEZVZmEq2MWaiDykmZHofZiyvwR/BzLIe2HTMLYpksLKilyU7XExAS6m5jliY0
         wUZUu6qMew3lxaVuXpjdw0GK8zjIcfb2QTAYHkpGuNeJ3t66E+KMl8s8cn0BYcYztSOs
         T/Sfzeskuw9uAAYOnw9k3lVUH4y4acx+0AdKCrNzc6xcZ/qjeUTK9+bxsPYq5Tm3q3GT
         TU6M5b5yGbiIYMw7Fgfbs3zLdgn03bWXnk1gx1HjMbAKHZPENOkHRvKJdaZmh/8JB76b
         043j0ptiTrufNUNEIKm+EMKzLFAonx2u2i5jJLVtVa01G5wkWoWUQdJoDBdSoVdg6JrK
         e22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tIKL4QCS/ApvsfELc5xJTB2C5HIErojH+gu7cSOEmuc=;
        b=hwQyV1ObIxLzQq+91RtXVFuml+rAj3MzhcSxH4JrvQp2ebZk5oXGXwIN8gnNfWQo0N
         8ZD4i9ocGsN9PmmJN+N6pbMSFLVi0NGxPIEdwUmhA2H5qnfBIUELh1z9Nr7AGW3ibk5N
         aLwcNmiDOwMG9gNQYYvHbV9/Qgww1qLCyOl23OMBkMOoovUFRD18FuutbYt3f3LhQ8gn
         0M+thzFQ/qOgvWH0M0HJz1d8W62LBuaTnoBZlXmvkFk5vlidcuNfdW9PBWkdrC+2Dg/+
         SYCc929saSdNSOhDljCK1LjfrAc6EVGQckX5r21AZx5EWT3WicBdu5yAt7UrkJ0HLYBY
         Gszw==
X-Gm-Message-State: AOAM531+ZCmhN1NeBssBLH3mFC1vt72y1dblykJYuT2PcJC/gOT90O3r
        nVro2qQyy81zRisaXyQBUvg7fxcCvsw4argFOG8=
X-Google-Smtp-Source: ABdhPJzdGpT9jKidTVKqyIqINhK4gDS97h/yzOqo2+IF9fY9lupRquWr2JmvZNc8ImiLVxJq91HYR2mPS9kKl4yESKE=
X-Received: by 2002:a17:902:6502:b0:149:1162:f0b5 with SMTP id
 b2-20020a170902650200b001491162f0b5mr58730003plk.126.1641490828478; Thu, 06
 Jan 2022 09:40:28 -0800 (PST)
MIME-Version: 1.0
References: <20220104080943.113249-1-jolsa@kernel.org> <20220106002435.d73e4010c93462fbee9ef074@kernel.org>
 <YdaoTuWjEeT33Zzm@krava> <20220106225943.87701fcc674202dc3e172289@kernel.org>
In-Reply-To: <20220106225943.87701fcc674202dc3e172289@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jan 2022 09:40:17 -0800
Message-ID: <CAADnVQLjjcsckQVqaSB8ODB4FKdVUt-PB9xyJ3FAa2GWGLbHgA@mail.gmail.com>
Subject: Re: [RFC 00/13] kprobe/bpf: Add support to attach multiple kprobes
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 5:59 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> That seems to bind your mind. The program type is just a programing
> 'model' of the bpf. You can choose the best implementation to provide
> equal functionality. 'kprobe' in bpf is just a name that you call some
> instrumentations which can probe kernel code.

No. We're not going to call it "fprobe" or any other name.
From bpf user's pov it's going to be "multi attach kprobe",
because this is how everyone got to know kprobes.
The 99% usage is at the beginning of the funcs.
When users say "kprobe" they don't care how kernel attaches it.
The func entry limitation for "multi attach kprobe" is a no-brainer.

And we need both "multi attach kprobe" and "multi attach kretprobe"
at the same time. It's no go to implement one first and the other
some time later.
