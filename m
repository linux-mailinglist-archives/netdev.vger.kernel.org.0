Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E70A189113
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 23:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCQWIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 18:08:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34464 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgCQWIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 18:08:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id t3so12478420pgn.1
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 15:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Li3o+eGMse4pCU/GrJAq05vX5J9NsNX7XZC9vo43bFI=;
        b=dVWGGx4Ex/EgOJQMHos70oiT0HZBXZIkxkq8RD2k2Kg04nSKC01bngo3JnikuiXhyf
         sCfKEKx5EcRIxg/F9pYE1SDTHYK8z6CWdEfyc8Cvdlcn7C8viudRW8Yac8mXDDEUsNNy
         ZkVOzLTMW9eRC/14UaSWGk1baLJP/7JwcJHA82+VvRknAfCmeom69VEAnP3+45eL3mfN
         63kUbJA6x7HeAgd6u9wsMfwf5lB7YtcTaGbu8dSCJO4qGwM4ipzK96KHe4cdPLmGGA2n
         3ge3jMHTe64Y4G0gRmeK3Wqu+I43i7dai581mYMrDYza/o5g4nNR+0D4XUPoO6kDXQfE
         uwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Li3o+eGMse4pCU/GrJAq05vX5J9NsNX7XZC9vo43bFI=;
        b=dVEZlhGvO2syxVxyvLuxb4DgtYGQE7YsRIG+YO1nL8fr7Fd/oZ8GjWg2EoTJsYTxax
         EnrGXBlhyDb3nOaTT82Of9fAHep0wn2j8R/tZhttClVV12Oc8NBu+f8LHOigepmA/6Mk
         GqgOES6yYi/vLeajyTjS0B3DuMxiH/kZZTl6JVOm3L+qB3mZVNOr03SAJjZmy/o7TUrJ
         XDyBW7GxiYveguX4tzYFA7C/zwb1AnTWxH3Yl2WtI60EVU/vC+4apXiH/OqTQhf6fDOK
         YyUvuXDqVEH1dEXRxE9VPhLDMeE69aJr1v2+5aAufxMMigxTbu8bzamY64zFc2YaCA+m
         +meg==
X-Gm-Message-State: ANhLgQ1iEvCLoB61YBi0oI2sjVnVah+NUC+0hsYqGWpQ2F98Zo1mQkLA
        z0oz2eCFlNJbqqshLHYzxHli5ejQa+vIZ7M2F69BEA==
X-Google-Smtp-Source: ADFU+vucwmJXlfnY9ZVyT4ysegJfI4My7/1hC3Kl41EFeSrqxhrWy4JXvLVoC1GDCIIWjT1h3w9k2uTxvhgiOk5EG78=
X-Received: by 2002:a63:4453:: with SMTP id t19mr1213740pgk.381.1584482914250;
 Tue, 17 Mar 2020 15:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200317211649.o4fzaxrzy6qxvz4f@google.com> <20200317215100.GC2459609@mini-arch.hsd1.ca.comcast.net>
 <20200317220136.srrt6rpxdjhptu23@google.com>
In-Reply-To: <20200317220136.srrt6rpxdjhptu23@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 17 Mar 2020 15:08:22 -0700
Message-ID: <CAKwvOd=gaX1CBTirziwK8MxQuERTqH65xMBHNzRXHR4uOTY4bw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5] bpf: Support llvm-objcopy and llvm-objdump
 for vmlinux BTF
To:     Fangrui Song <maskray@google.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 3:01 PM Fangrui Song <maskray@google.com> wrote:
>
> On 2020-03-17, Stanislav Fomichev wrote:
> >Please keep small changelog here, for example:
> >
> >v5:
> >* rebased on top of bpfnext
>
> Thanks for the tip. Add them at the bottom?

"Below the fold" see this patch I just sent out:
https://lore.kernel.org/lkml/20200317215515.226917-1-ndesaulniers@google.com/T/#u
grep "Changes"

$ git format-patch -v2 HEAD~
$ vim 0001-...patch
<manually add changelog "below the fold">
-- 
Thanks,
~Nick Desaulniers
