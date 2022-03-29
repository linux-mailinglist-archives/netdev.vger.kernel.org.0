Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E9D4EB445
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 21:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241041AbiC2Twf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 15:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiC2Twf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 15:52:35 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E013D17A5B3;
        Tue, 29 Mar 2022 12:50:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gb19so18525534pjb.1;
        Tue, 29 Mar 2022 12:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W+3wVxsLtAbTsL8nxtMoxIj7SMW+0TqIqxYDApc8pGg=;
        b=RiJR8/VEpiExHjFbW3Ep536IZrw+3lizQ1IqT5oU+O6pE/irxH0UsqSQbjOuZJTi95
         hl2MwVjHuY9gVurjtF2Q4H0HKxWMsfDrLR/rmxojcrLCuz9RAvBepnl2xcYbTqK8Wmdj
         3DKcAOW0b5BT8ic9YfE7z3gRyK1ghnZgQ4JsvA0fHRVIqDFlaIKAP9gOlFwcW01ZNj/1
         5FCQ249p5y2QEeVd4h52c84ARB4P6I0MwXPLAGhrIVP9yStSp1QMTtVWRMpA/bIssqXP
         qV33OS5ENB3xJnhXPsJiKYVNNaPA7Xp/obm1Eje35+vq5AGVlx7UIHLb86fPqm/WoTgf
         q+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W+3wVxsLtAbTsL8nxtMoxIj7SMW+0TqIqxYDApc8pGg=;
        b=QX0BF0TeY7MfPkL0uoRbqoRzdEqO/ZumKUQQpRvlNTr01H2u4BloQMmTLfcPuuZx6J
         GtlhN/vsoa75HdmLJFFLBf/906wceSwkVwxNQ5KUtpFuUn5jz5opuFUJJFe5cODpwqrd
         jt7ksMbs0d461wMVoO5N4ohqE2Jbto+NXDzjO+QLrAe19gzoii0N4ANXpmle06rJ0s3N
         M1S1+mU0uGvo7bSb8stpwXDCGlsxUaHH8iNdfnsx3iKflvmZUQL+WeRJepvgPzcphqgk
         lVUMdcJas24GSjCzIpiy9DeCMRLieVE4xgGHxRPS4eK1oLlfZZFzgqazCr40saFPhrhS
         Rucg==
X-Gm-Message-State: AOAM531wRVKUNsxyGPGoT7ry+7cuBZRtdkh9E1UDJHBTWEagg4WxSD3F
        iIRgygz6ehlUtysuN+BEXoLI7e5lvTVC3p6omQQ=
X-Google-Smtp-Source: ABdhPJxKv/Z2GAEJzsBMwi3CG10S1WLjUHcstj2r0HsRZoG4nyoT3uJZSYE0n65hJoQDozm0b9l2uUOwEaZwww+SywQ=
X-Received: by 2002:a17:90b:3003:b0:1c9:9751:cf9c with SMTP id
 hg3-20020a17090b300300b001c99751cf9cmr797454pjb.20.1648583451388; Tue, 29 Mar
 2022 12:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220329181935.2183-1-beaub@linux.microsoft.com>
In-Reply-To: <20220329181935.2183-1-beaub@linux.microsoft.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Mar 2022 12:50:40 -0700
Message-ID: <CAADnVQ+XpoCjL-rSz2hj05L21s8NtMJuWYC14b9Mvk7XE5KT_g@mail.gmail.com>
Subject: Re: [PATCH] tracing/user_events: Add eBPF interface for user_event
 created events
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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

On Tue, Mar 29, 2022 at 11:19 AM Beau Belgrave
<beaub@linux.microsoft.com> wrote:
>
> Send user_event data to attached eBPF programs for user_event based perf
> events.
>
> Add BPF_ITER flag to allow user_event data to have a zero copy path into
> eBPF programs if required.
>
> Update documentation to describe new flags and structures for eBPF
> integration.
>
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>

The commit describes _what_ it does, but says nothing about _why_.
At present I see no use out of bpf and user_events connection.
The whole user_events feature looks redundant to me.
We have uprobes and usdt. It doesn't look to me that
user_events provide anything new that wasn't available earlier.
