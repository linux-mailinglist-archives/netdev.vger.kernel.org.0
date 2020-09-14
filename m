Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9331F269532
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgINSw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgINSw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:52:56 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0CDC06174A;
        Mon, 14 Sep 2020 11:52:55 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id k25so860186qtu.4;
        Mon, 14 Sep 2020 11:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cRuE7ghYmX/MnQQcJBt4NDc6WttGR8e1vIUwI+1gPGA=;
        b=UkRrlE0m1+WF9msVPr5gid8roJaZt1r/OaDQRSyARhhE2uG/LpFzV4A8O2BgFe9IPV
         s/YYuXXzYjOA3bwgt09LzqgiryW058mZ9M6MLiucyIRnfOm88EEn+a8byN4gdrQGKsmY
         Be3s2tamJOxHcVFHpaamPWM5+tfrwYeKrz/lkszY7r+8ifHgRJ6WT6RRXfQuPLz5Hheo
         tRj5diMAy/AmHvYFGYQQ5CNF+T7P86ExaIUB/fG0TiYfTXjbWqU9Km8WIZUn+x1pOpr4
         s6MDO2GzC631it4Y5UlFJziZ67zBVHiqY8hcvQj6GREu6JNTf5npc33KFXPB1XL9XjZz
         4Vig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cRuE7ghYmX/MnQQcJBt4NDc6WttGR8e1vIUwI+1gPGA=;
        b=TRHWDDcKX17GIBWIC2DpPM95S5tLCtTJtiy0WbzDAsGSSkI3FhrNqzJ2m26YIcWLoC
         IVJCHdv+hn+aGShafRNCUn+iB9nZubhWH2ID3lmuf8hTfIwomn5/Ma0+aXTTWQ+MrVzS
         YSPuZIukp0xRAWI5ZKYsI3u91uN9/ToUxlPJiQwdAvy/ESgobgfYpN6AGChHw8G6//lL
         VMMR7oYMPpj4bxn89dty705atTrlcnDuCIbJrpgRvrddkZF4bRghALJGrIbrTmHWG74c
         ldJu8nYQA5KG3lN2aW6ZjBf+I1E32GINz4lhm8A0Tk9pV28HxpIAXququJxSUAaKFWeD
         Cq8g==
X-Gm-Message-State: AOAM532E0mvgWI0fHQzn9smLcVa2CHyvLGUlaxKYamCbG/memdLI5Sap
        ZVmvT54H4KEsvXcYOGnOTJGskuO6lEVJqq+j3UU=
X-Google-Smtp-Source: ABdhPJxhDixSFUwxkAnEUQeXy07ajAOQms0ZLcAVN9gFyyOzsMsuLpLHTuY8o7iLRBRsA5g/KT7lYKHt6LTXZh1bHxo=
X-Received: by 2002:ac8:660a:: with SMTP id c10mr2319819qtp.300.1600109572562;
 Mon, 14 Sep 2020 11:52:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
 <20200914122042.GA24441@willie-the-truck> <20200914123504.GA124316@apalos.home>
 <20200914132350.GA126552@apalos.home> <20200914140114.GG24441@willie-the-truck>
 <20200914181234.0f1df8ba@carbon> <20200914170205.GA20549@apalos.home>
 <CAKU6vyaxnzWVA=MPAuDwtu4UOTWS6s0cZOYQKVhQg5Mue7Wbww@mail.gmail.com>
 <20200914175516.GA21832@apalos.home> <CAKU6vybuEGYtqh9gL9bwFaJ6xD=diN-0w_Mgc2Xyu4tHMdWgAA@mail.gmail.com>
 <20200914182756.GA22294@apalos.home>
In-Reply-To: <20200914182756.GA22294@apalos.home>
From:   Xi Wang <xi.wang@gmail.com>
Date:   Mon, 14 Sep 2020 11:52:16 -0700
Message-ID: <CAKU6vyYhG20qaA1iKwD=-pZHWjZYEZvX6Qmjs=aA-uJ-uwCw7w@mail.gmail.com>
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Will Deacon <will@kernel.org>, bpf@vger.kernel.org,
        ardb@kernel.org, naresh.kamboju@linaro.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:28 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
> Even if that's true, is any reason at all why we should skip the first element
> of the array, that's now needed since 7c2e988f400 to jump back to the first
> instruction?
> Introducing 2 extra if conditions and hotfix the array on the fly (and for
> every future invocation of that), seems better to you?

My point was that there's no inherently correct/wrong way to construct
offsets.  As Luke explained in his email, 1) there are two different
strategies used by the JITs and 2) there are likely similar bugs
beyond arm64.

Each strategy has pros and cons, and I'm fine with either.  I like the
strategy used in your patch because it's more intuitive (offset[i] is
the start of the emitted instructions for BPF instruction i, rather
than the end), though the changes to the construction process are
trickier.

If we decide to patch the arm64 JIT the way you proposed, we should
consider whether to change other JITs consistently.
