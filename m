Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0C84551F2
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbhKRBEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242118AbhKRBEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 20:04:00 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644A7C061766;
        Wed, 17 Nov 2021 17:01:01 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id p17so3792056pgj.2;
        Wed, 17 Nov 2021 17:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CldWxF+xHdMGvS6Ww1B8FNZQUYPzrzWUDuo2TU0I4PM=;
        b=IXgkU6U+xtO8Ku5gLtxEqkE+vVeF2WpddqjXMgSDNbjqghnhEYbjAq0UKoge6akEA3
         tIyUDzAoUHxIAC5WF4aVf2dWN9i6drJVqdfWMwjb0R2wH7gLmWN3Eni/PSW1zaRP7h3Y
         9d3tL7uqSuQ8MHTy4hbKSw3mlz3SkZvcAkof6wkMyrbLdfU0tJ0rmBh5fdRPY1x80AvW
         A/wpKOr/u4mV4kf1yqeiF6ItMSbYAvzteKET1BwFU6pPXCufKCrGhJvkQ9KjOJ3fl1At
         F9eqjhTpZJS9e+n1lEGQaWrSjSBeqL1ADwvSdnHfQmsWfyMcOmgqbIg7iqvLJwgk4l7m
         Qd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CldWxF+xHdMGvS6Ww1B8FNZQUYPzrzWUDuo2TU0I4PM=;
        b=MTnNzfgKQZq4dSoEaw1wMpIbVMmb5Q61lHBgIhgPPlYxetnOK9qhiOogyPrYxKQQah
         snufY3BvUtPUQglBbupqJVDAjABhZXdwZvYCRE3cJgSmM/nrV3AbIR3fnq2ciPLT5V23
         Vt0hTOW0uyoLZaNqRuzU57P1yyA5gyMGx7OYCfoiWF5yhf2FT3UbKwKSTKqMsgKTDIPE
         UbiIB1SlpVUlnm6Ta5i1ZZVuNAdQo5dWsLgpyxjF4Yqib4/iHqPrZZcYK3o1t4dorO0G
         zYzpvR8GZ055GmB/TiFXlRIv1tVnI8f1T5B0wk5fqPsR0PypiXoMFIgAxEhclecUtTIu
         e2cA==
X-Gm-Message-State: AOAM530aXoYyjWfriCQNI68vEvJyinV+Kz1Yo1m36tVakQfnt5DavyiB
        0inX4a5ZRKZ3eyyGaocAOPg=
X-Google-Smtp-Source: ABdhPJwvQI25wT11ooPWmvblcwDtsd2TZz/VblITP8t0Z8TTBiF4LO6D6NNriPTY1X6BIjEfcMRIsA==
X-Received: by 2002:a62:18d2:0:b0:4a2:b2d0:c39f with SMTP id 201-20020a6218d2000000b004a2b2d0c39fmr30558131pfy.69.1637197260931;
        Wed, 17 Nov 2021 17:01:00 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:6d])
        by smtp.gmail.com with ESMTPSA id d3sm860320pfv.57.2021.11.17.17.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 17:01:00 -0800 (PST)
Date:   Wed, 17 Nov 2021 17:00:59 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf] selftests: bpf: check map in map pruning
Message-ID: <20211118010059.c2mixoshcrcz4ywq@ast-mbp>
References: <20211111161452.86864-1-lmb@cloudflare.com>
 <CAADnVQKWk5VNT9Z_Cy6COO9NMjkUg1p9gYTsPPzH-fi1qCrDiw@mail.gmail.com>
 <CACAyw99EhJ8k4f3zeQMf3pRC+L=hQhK=Rb3UwSz19wt9gnMPrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw99EhJ8k4f3zeQMf3pRC+L=hQhK=Rb3UwSz19wt9gnMPrA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 08:47:45AM +0000, Lorenz Bauer wrote:
> On Sat, 13 Nov 2021 at 01:27, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > Not sure how you've tested it, but it doesn't work in unpriv:
> > $ test_verifier 789
> > #789/u map in map state pruning FAIL
> > processed 26 insns (limit 1000000) max_states_per_insn 0 total_states
> > 2 peak_states 2 mark_read 1
> > #789/p map in map state pruning OK
> 
> Strange, I have a script that I use for bisecting which uses a minimal
> .config + virtue to run a vm, plus I was debugging in gdb at the same
> time. I might have missed this, apologies.
> 
> I guess vmtest.sh is the canonical way to run tests now?

vmtest.sh runs test_progs only. That's the minimum bar that
developers have to pass before sending patches.
BPF CI runs test_progs, test_progs-no_alu32, test_verifier and test_maps.
If in doubt run them all.
