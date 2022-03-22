Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0D4E4456
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 17:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbiCVQjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 12:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239162AbiCVQjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 12:39:52 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18125DA0E;
        Tue, 22 Mar 2022 09:38:19 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s8so18574421pfk.12;
        Tue, 22 Mar 2022 09:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NJN6cvug/10iiAJgDTC9S5tiBDNsJnlTHUuBYkSpNaU=;
        b=TX05opdSyTQAGNgrLionRFhZE5NFzupFeD+ib2R3QPiYbtviA8jY03vzwWVQPr7KvE
         8bQaqte4UcRs8NqVL4EkP5WfJFwHDLQyY99ibP4Epfphhy5Zq0yVRR0o7HL9ez8uGC8w
         laacPJRNqtdR6q10lzfy0Etb6F/Sx9Tr3HCPp0l/14Ak5pR/pCEF8xjM0RFPPWYD5qde
         Bbg84M+fG4cAFMKB9RpG5DWafFn8V2K6rDOU7pCPRkfkN0F9SUpq3DrhqTC1y0TtW1sN
         QoIkeqKdyAAtSRf5JkNjApf+6g0XJYIXah3XHDP+aBjM/R0Gt0HzSqMwhVkkKtUN/cDw
         4rEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NJN6cvug/10iiAJgDTC9S5tiBDNsJnlTHUuBYkSpNaU=;
        b=ErHFlhBquxsk3nM/RvRbDC4utdosMRemIPWoaX5Kz1FVKDY9m3LzqKDH5syA3S/5Bp
         Va6h++SeAOkRmZ6hBY5SzoQiIo8IFc57/f2C+BR3rhGtye/5WytG8Enh4PWcP8azHIny
         PjvtUtjF2kUZ8O23cPg5EXJxOjUP9YvLG3oce76YgI3SlhOE+9nDD6mXUuTNo8W9U+kB
         SZh18LVs3t0XiSsCuadYBCTnTKF1F0hxhAbpB7zphxeW1b+v+hwUAxriMjlcFG9S/+tm
         iXFTPNOfVDAWXvxdtAKxw9ElzwNDg082nXjOFTAfACfWpHbdbNm4teWivcKU979GCIcI
         UPPw==
X-Gm-Message-State: AOAM532m0AIIwgbndWV5ZbdHIOvK4lw1erNlimraoFYQ0XNQz/17EyQs
        DfWtm0udn7VxNWEzSl6PhAYjw1OTVZrraj6LGYw=
X-Google-Smtp-Source: ABdhPJzVmN2QuKjSAGNcvDAtl//mEJbdUogh2Y/rnDOeObr1Gjnhoo2BZ3DF01U9IoG04OUs3CJBcZGQxdIuLiRBlvE=
X-Received: by 2002:a63:6809:0:b0:37c:68d3:1224 with SMTP id
 d9-20020a636809000000b0037c68d31224mr22092354pgc.287.1647967099353; Tue, 22
 Mar 2022 09:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220322050159.5507-1-alexei.starovoitov@gmail.com> <20220322233223.5e1a3c418f6d60081fae973e@kernel.org>
In-Reply-To: <20220322233223.5e1a3c418f6d60081fae973e@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 22 Mar 2022 09:38:07 -0700
Message-ID: <CAADnVQK0OrNHZRj3M8J8cOpyS99guMSc7103Ac+=EUp+8ubgyw@mail.gmail.com>
Subject: Re: pull-request: bpf-next 2022-03-21 v2
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
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

On Tue, Mar 22, 2022 at 7:32 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> Hi Alexei,
>
> So after this is merged, would you have a plan to merge the tip tree
> which has IBT to the bpf-next? Or should I wait for merging this series
> or IBT(ENDBR) series in Linus tree?
>
> If I add the no ENDBR annotation to the x86 rethook trampoline on this
> bpf-next branch, it will cause a build error...

Right now (after arch bits revert) there are no build errors in bpf-next
and won't be any after the merge into Linus's tree either.

linux-next is a proxy of what Linus's tree will look like in a few days.
Please create a single x86 arch patch against linux-next and make sure
Peter is happy with it.
We will land that patch at that time.

That patch will be pretty much the same as what you had earlier
with ENDBR annotation. And maybe regs->ss set which is future proofing
optional bit and not a functional part of the patch.
