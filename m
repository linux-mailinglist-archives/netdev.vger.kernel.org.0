Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4F813FC4
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 15:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfEENdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 09:33:50 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34017 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEENdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 09:33:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id j6so11915602qtq.1
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 06:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8vh9GzL6Z3TESI/K8Xe7IDmt4lW4rJ2TS6d8Gg9f4ec=;
        b=M+OUTlMvvZ88jH6CNuww2buF0wxPz/6/FyF26etHaJ7ads1jgfn2rS5KA/IggKuCiu
         d5PlVyD6rNhxPiGnCzrrAbPGJkW2aSWXx8nKyGn3XiIe97TXbZnZWcH2GqnTn7P1eY4s
         Hhs3bavkmsu1/D4xik3PSsJGHYede+vjcqdQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8vh9GzL6Z3TESI/K8Xe7IDmt4lW4rJ2TS6d8Gg9f4ec=;
        b=M1q+ppov2gGSBzM5N2D/uSeupxpXcqAfAwquzu//LfZ3Jd/4+376MU3Y1oyZQzPsXi
         6/5Vt7zUTfYLooqpxFj02hRMTpTcVLK8RLBj7SSTi9n45t8Tq5jBehukrnHJRi2+ehwX
         l0AaSwUUCe6q1lnSfQ7A1GUMw+87LlBbRoj9+7M+/Hh4FmUQCBgaKnnTs4TUcdlt+Q/V
         C0LJZN1/R12UUCRg4UlFnJpPOlAPKvN7kVX/ADBI+aQXxOecnetyFcdoFUzrmxVQodJz
         KWyUbdCVwSxRMw9U8+BfJYMj5TWieiw1LAMwvm6I049jeXftWwAWBvT/B+uCry2WqmC/
         rT1A==
X-Gm-Message-State: APjAAAW3ePyje3j6qX60v/1j9pWdBxF591gR+kbk5yTgWUSl8VwOuisr
        simancWLESlLofTCx695GcEu7g==
X-Google-Smtp-Source: APXvYqwZvrE19A+Oum63yFFoi2lvqbKSvPQtjx3rBN2iVToNB0C1ZrwrxK4w7/ddQ64WYLVkAEJcdg==
X-Received: by 2002:ac8:6b11:: with SMTP id w17mr4479401qts.285.1557063225078;
        Sun, 05 May 2019 06:33:45 -0700 (PDT)
Received: from localhost (c-73-216-90-110.hsd1.va.comcast.net. [73.216.90.110])
        by smtp.gmail.com with ESMTPSA id o55sm6298213qtj.14.2019.05.05.06.33.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 06:33:44 -0700 (PDT)
Date:   Sun, 5 May 2019 13:33:42 +0000
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        duyuchao <yuchao.du@unisoc.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] bpf: Add support for reading user pointers
Message-ID: <20190505133342.GC3076@localhost>
References: <20190502204958.7868-1-joel@joelfernandes.org>
 <CAADnVQ+CPXKv_fryOxnDXjCLmWxor2j+WBFvPtG-Tcyr=hzRpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+CPXKv_fryOxnDXjCLmWxor2j+WBFvPtG-Tcyr=hzRpQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 05, 2019 at 12:19:42AM -0700, Alexei Starovoitov wrote:
> On Thu, May 2, 2019 at 1:50 PM Joel Fernandes (Google)
> <joel@joelfernandes.org> wrote:
> >
> > The eBPF based opensnoop tool fails to read the file path string passed
> > to the do_sys_open function. This is because it is a pointer to
> > userspace address and causes an -EFAULT when read with
> > probe_kernel_read. This is not an issue when running the tool on x86 but
> > is an issue on arm64. This patch adds a new bpf function call based
> > which calls the recently proposed probe_user_read function [1].
> > Using this function call from opensnoop fixes the issue on arm64.
> >
> > [1] https://lore.kernel.org/patchwork/patch/1051588/
> ...
> > +BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size, const void *, unsafe_ptr)
> > +{
> > +       int ret;
> > +
> > +       ret = probe_user_read(dst, unsafe_ptr, size);
> > +       if (unlikely(ret < 0))
> > +               memset(dst, 0, size);
> > +
> > +       return ret;
> > +}
> 
> probe_user_read() doesn't exist in bpf-next
> therefore this patch has to wait for the next merge window.
> At the same time we would need to introduce
> bpf_probe_read_kernel() and introduce a load time warning
> for existing bpf_probe_read(), so we can deprecate it eventually.

Ok I will update it accordingly. Agreed. thanks,

 - Joel

