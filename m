Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C9C4E3591
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 01:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbiCVAd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 20:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbiCVAdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 20:33:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC25392D53;
        Mon, 21 Mar 2022 17:31:39 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mz9-20020a17090b378900b001c657559290so939652pjb.2;
        Mon, 21 Mar 2022 17:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vExTsMzCWU2NmIqziveksRnNqdaa0L18t7tBLOIVEEY=;
        b=ph8G5oj1ABjdIeaipWejwRDBgf2SHBQperwRG7GGSOJslwFsBZ11KopaWgN4I45sk3
         Rxb402ZxuPaGaxOuRzI9ZdNkSt79LzVqRJzsVVDOioVuhW0mZFTHEYV5++8CuIyo8ilH
         D/fFgEH3IFxd6fl+DdGZaBaJKe7GreqwTeuCpyyw9mGFz3Y80jGSjG8KOnrtGEf/u/BN
         zmYWLDqoEMWfKAMnWkGJNCIm3yoXDpyqUUBG+ieDj5hFG5IqVeRrs8Q2tjzOPQ9kiczg
         b/6nArKiRIKbW67aZf0nT60JqjdqPpL01feS4Fui+QVZJNlrVL0myZjJFUNbyTsOShEI
         NdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vExTsMzCWU2NmIqziveksRnNqdaa0L18t7tBLOIVEEY=;
        b=1SotO1HHLN8B3qL7uyCD8F0nF02b5TpJaCeJS5tGh4bl+ofeVh6C2pDiVm6VDnM5Sz
         kd74xsck4KCtlUOCzZlK40RJLW73cTpzBZfEZNc0lZ6a0sVu5tbvIEETBv5W5nYAwPlM
         FXV0KqVNF1BdKkM5M+pcEIhEog5HbNoSjRWN9Xn7YoyyEPBSrPur2e9I94e2s8q8Z1C9
         gJ+Q1K2R+btm0IXF27aIrnzQTTmhvxVf+CsU/JbcNUFmRFi9idWV35o8PEcvHJyR35QC
         NblLzYYLNueudN0JXbAGnqqfdW5frLTykL+qW7gChmvxnJb+fm3wXeinWDaVwQGGMT1a
         GGQA==
X-Gm-Message-State: AOAM530WonHRtvsnfzcwtfNDhad1WeOBkg4+VJKEeKgplu4rY9fyKYQN
        ATvJT+IbufXig/MWozbvQCAtixl/QyI69HvYQ17ftIqMcj0=
X-Google-Smtp-Source: ABdhPJyOGAvACGSgF6ezE9B1LgVTFALg1fVfKVyAy0d6CdqSpF2/6AMtsGVgJzuF/v+h3eWxJ6Zce6TTv177WcB7vN4=
X-Received: by 2002:a17:90b:4f43:b0:1c7:552b:7553 with SMTP id
 pj3-20020a17090b4f4300b001c7552b7553mr1704554pjb.117.1647909099355; Mon, 21
 Mar 2022 17:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224608.55798-1-alexei.starovoitov@gmail.com>
 <CAHk-=wheGrBxOfMpWhQg1iswCKYig8vADnFVsA4oFWTY9NU5jA@mail.gmail.com>
 <CAADnVQK=JsytH_OtT6Q6fnijkTyv7NANV2902woQ6XT-fwWXQA@mail.gmail.com> <CAHk-=wi0fNH+FS-ng2Nvq2p1Jbfn+-G1AsK-XY7MD4gTJZg5ZA@mail.gmail.com>
In-Reply-To: <CAHk-=wi0fNH+FS-ng2Nvq2p1Jbfn+-G1AsK-XY7MD4gTJZg5ZA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 21 Mar 2022 17:31:28 -0700
Message-ID: <CAADnVQKreLtGkfAVXxwLGUVKobqYhBS5r+GtNa6Oc8BUzYa92Q@mail.gmail.com>
Subject: Re: pull-request: bpf-next 2022-03-21
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
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

On Mon, Mar 21, 2022 at 4:59 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Mar 21, 2022 at 4:11 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > Did you look at the code?
> > In particular:
> > https://lore.kernel.org/bpf/164735286243.1084943.7477055110527046644.stgit@devnote2/
> >
> > it's a copy paste of arch/x86/kernel/kprobes/core.c
> >
> > How is it "bad architecture code" ?
>
> It's "bad architecture code" because the architecture maintainers have
> made changes to check ENDBR in the meantime.
>
> So it used to be perfectly fine. It's not any longer - and the
> architecture maintainers were clearly never actually cc'd on the
> changes, so they didn't find out until much too late.

Not denying that missing cc was an issue.

We can drop just arch patches:
      rethook: x86: Add rethook x86 implementation
      arm64: rethook: Add arm64 rethook implementation
      powerpc: Add rethook support
      ARM: rethook: Add rethook arm implementation

or everything including Jiri's work on top of it.
Which would be a massive 27 patches.

We'd prefer the former, of course.
Later during the merge window we can add a single
'rethook: x86' patch that takes endbr into account,
so that multi-kprobe feature will work on x86.
For the next merge window we can add other archs.
Would that work?
