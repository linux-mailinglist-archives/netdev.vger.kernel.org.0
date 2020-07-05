Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7520E214F34
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgGEURX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbgGEURW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:17:22 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11847C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:17:22 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id h28so32953208edz.0
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bli7823nzgPd4+zzTvhEWYIQlQOolCEdTUm/wr04xHI=;
        b=R7tVqK4S06XyeSJoTsJjrNQfFwww4cEHoPm/CtrrugENTDy1vqCVO+sDyMGWTFks1W
         5RawwMRBiS/INbOjWFg3B9vdk7NUoOnjuO+5/kBRz+Eb+sT5BIBi86j23t13MrcW941E
         tjh8GC9eV5hPjYuXImtn6v1yDp1zlaW2xJOOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bli7823nzgPd4+zzTvhEWYIQlQOolCEdTUm/wr04xHI=;
        b=Zg3BG85SeEGz6Chvole+eC/dbhKmqAoqHTujasNe9y1+Ew96p9hTH6p0e3GWTxY56g
         8s33jm7WKLHGSn/1nUzyXw+nCZfreaIw8ZA01rEaJH4cKRKMlDZ6hb3tQpTEVkpVaGfP
         uvuzsf2ZPCDji6I9zI7j/lWOiWN0Kuwf+4sV7/sNL2rGCMdVIWpkCdaMF9zq16vN2rp+
         8pHdCqUGvxalPfGGivToVQY4M/8wMCEnGwHvQedrIvLVCCfBmNGpJHiS1YAql3pYUrfX
         Wz/jgSaVLeZAOR/LtW/uaWxDbLelpR1sSDeQbst5MzOMwlequNLwdggzwfoZH1QZo5f1
         Tw4g==
X-Gm-Message-State: AOAM5305LKZdV7uTsFBa8QDBao6YIzyFwmhGh2ck3ztFWkHat15XSXCc
        WgKFMWGsqD268hLUIA7GNygBjjCz6Us=
X-Google-Smtp-Source: ABdhPJxX/QVL0yJdT1+yfNqv7ZI1sOKQwYfP9yOQUzhvPOu+ml/gdluRhub0i8cSysW8y4S48MCJZA==
X-Received: by 2002:aa7:c50e:: with SMTP id o14mr52530749edq.168.1593980240553;
        Sun, 05 Jul 2020 13:17:20 -0700 (PDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com. [209.85.221.43])
        by smtp.gmail.com with ESMTPSA id sd15sm15197609ejb.66.2020.07.05.13.17.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:17:20 -0700 (PDT)
Received: by mail-wr1-f43.google.com with SMTP id a6so38683168wrm.4
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:17:20 -0700 (PDT)
X-Received: by 2002:a2e:9b42:: with SMTP id o2mr24759339ljj.102.1593979869955;
 Sun, 05 Jul 2020 13:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200702232638.2946421-1-keescook@chromium.org>
 <20200702232638.2946421-5-keescook@chromium.org> <CAHk-=wiZi-v8Xgu_B3wV0B4RQYngKyPeONdiXNgrHJFU5jbe1w@mail.gmail.com>
 <202007030848.265EA58@keescook>
In-Reply-To: <202007030848.265EA58@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 5 Jul 2020 13:10:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgEkTsNRvEM9W_JiVN6t70SnPuP=-1=LyhLS_BJ25Q4sQ@mail.gmail.com>
Message-ID: <CAHk-=wgEkTsNRvEM9W_JiVN6t70SnPuP=-1=LyhLS_BJ25Q4sQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] kprobes: Do not expose probe addresses to non-CAP_SYSLOG
To:     Kees Cook <keescook@chromium.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable <stable@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 8:50 AM Kees Cook <keescook@chromium.org> wrote:
>
> With 67 kthreads on a booted system, this patch does not immediately
> blow up...

Did you try making read/write inc/dec that thing too? Or does that
just blow up with tons of warnings?

                 Linus
