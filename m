Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683451C60A2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgEETCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgEETCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:02:10 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94927C061A0F;
        Tue,  5 May 2020 12:02:08 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id y4so2800577ljn.7;
        Tue, 05 May 2020 12:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wBvhKwmcVv6FRkagJX1MbFywc36H651HjTJDyfrw6P4=;
        b=Zz7Rvvk9/J0J9XqJ4a2vmzc/M4dxF851cKAxxrzLTF0Efekb5KsLzN4BkGLLKgLjCi
         J0adM7U2wfl3XuWpX+vFcIzxPi/2+2y8kecbYNxQy7XzjTt3dEERycUMlBzkT/Ov7vYP
         jHDZZoC9mto77yRjOwbFrd13QS4AqfFUyUM2ukTPQ1ysBD0sGlxFReTEjlnBUYlfIDJJ
         jagDlDIR62RgtOw0VTkj0MnQIEIg6W5tKoMrXU1K+L3Te+mAPF48PnDxWzZ3+riE2iyC
         BGwLZvjLxk+++TBa1ev8eH1MRq9Tu/Wnv3Xuxw+GQ4s7XYG8IFCh3quV0jHWZq/e48BD
         XIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wBvhKwmcVv6FRkagJX1MbFywc36H651HjTJDyfrw6P4=;
        b=dCUy2Gy8VW4vXBQFZK7nzM8w3M6O9dvNpQFQMzI/EmeCZRwkc1dzndScHpxZ1Sw1GI
         Mkbj4GNwHfLmcASNtcH+xaQztWoam1YB/jsjtb6KbAJO3UidempuRICEl2SR0Tdip2EL
         Zb7BdQb+BEsf6hVtkDumgiykeNp+oAii2POeNie+AmrUtzm6jT1MOsZ+9fF7tB87XXxu
         +eCrLIBo72yWcrzB6VcOdJbygGm2TKuTKzP5Y1j+bsyI1Zfu1FS0KyTPsGWkzn32tx1z
         DYmqyBjrVROQjMQJywA+G4ptSt1MFQcUwgjN0urOBuD0zEbGsHAljQxmC5w36j1Uxv9V
         maDw==
X-Gm-Message-State: AGi0PuaoCJKh3yGxsqwsybRK7ZftJ+4WTiaBoAVuV8vUMm/ydA3mScJW
        A5q1wcau8XVQd4Ktq4Yl63cXY0ZB3tt1TArwuck=
X-Google-Smtp-Source: APiQypLaZIyqVtMFvJ7FUvsJiexAYX1rKRrXsbSEU3wYxJ9F8QQo7QJsiJk7zH1oTBdn2igLUieTKaz1uy2zN5BFwuY=
X-Received: by 2002:a2e:b17a:: with SMTP id a26mr2505035ljm.215.1588705327042;
 Tue, 05 May 2020 12:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140734.503701-1-arnd@arndb.de> <F51BF018-3035-489D-8232-6D23A426D179@fb.com>
In-Reply-To: <F51BF018-3035-489D-8232-6D23A426D179@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 5 May 2020 12:01:55 -0700
Message-ID: <CAADnVQJS6aD5RSQsJ3i0LrfiQCBvuXeDb-q+KpZoW1MteN-F=g@mail.gmail.com>
Subject: Re: [PATCH] sysctl: fix unused function warning
To:     Song Liu <songliubraving@fb.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 11:25 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On May 5, 2020, at 7:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > The newly added bpf_stats_handler function has the wrong #ifdef
> > check around it, leading to an unused-function warning when
> > CONFIG_SYSCTL is disabled:
> >
> > kernel/sysctl.c:205:12: error: unused function 'bpf_stats_handler' [-Werror,-Wunused-function]
> > static int bpf_stats_handler(struct ctl_table *table, int write,
> >
> > Fix the check to match the reference.
> >
> > Fixes: d46edd671a14 ("bpf: Sharing bpf runtime stats with BPF_ENABLE_STATS")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> Thanks for the fix!

Applied to bpf-next.

Arnd, please make sure subject includes target tree like [PATCH
bpf-next] in the future.

Thanks
