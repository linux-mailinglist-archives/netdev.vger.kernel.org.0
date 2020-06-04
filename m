Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512111EE38E
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 13:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgFDLlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 07:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgFDLlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 07:41:20 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63308C03E96D;
        Thu,  4 Jun 2020 04:41:20 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id n23so6848933ljh.7;
        Thu, 04 Jun 2020 04:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R0o4OOvzJQjARhQ6/49UmmkOyadJDn2uKBj3nrOAqQo=;
        b=uOadSoLGhaseNrsSLG0CEfcx1B7ZyXtznA1jW/71TjOkJaQ3v7NhDn32mtbkkPd0Q+
         1UDuNRM26ag+jysBJHImSQ2kyqAxp6Pbe8OVsuK3/X6E6BLOFRucdGoxisc/QkPMQfn9
         DSP221R/DYOdjftqL2dmeYiibVPWWApyDr996ybowslc4DnYfcHTAWJ50hppvye4onSW
         Wki6t+mbrF7ejKkqVkq6hFcUNg4F2aeKBWSYX0y86zDfF0gdQIlIFvOHHUjNdXP4a7ct
         pto6mvk/UvVFDpzwyBErLblgdgk4M9JUrlkGy+vs2gLKfjfB2m/WaWMIrcXH9QqP6urW
         FvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R0o4OOvzJQjARhQ6/49UmmkOyadJDn2uKBj3nrOAqQo=;
        b=P3AAWUXHRD5t3PsW07iHif5KVUnQhGTqfNZ1nMZ/+oBm6ftVVEBgYqOFJpjVXwCYDl
         3Bber2Wxs4QJ9bMSg8uM1zAAwd5KMDTHKjJ5tToQVPy+To6oKOA859oNgUJK8Zw7v3ZJ
         tLvBUVSYzsgMhZSxuFkwM/IDS9xvPeJ0ubRdLYyX/GuoYANchBOmPmPto2+J1FAicESX
         IwFEZaA8Kuwvd0VQHp2lvzVM2bUaOXxv1Oz1ErDI2qJiW6VI3Z+56JVMCDh3Lqn4miru
         Uq97hm7jgoQvJJEnmX74CEEcvfU2vTL8t9SDtrY1H3DPv2AYmK27OKcXM8tKGUc8vC1i
         2Q8A==
X-Gm-Message-State: AOAM533DlaKn9YP6kYlOx2K2g/zk9vvzB2ox9L9un0eEFKvWvmklROQx
        jdVIiXEOO3oaHch7bgZuSYiBPdo/rz/D4O0M2pc=
X-Google-Smtp-Source: ABdhPJxccA+5mnrfVxyneHXrV0mVelE29mG9oDomdWWW1fU5ho8qKcvQdw+EQpyMOql3tRqQBW/MgmXYvs677/gUgQE=
X-Received: by 2002:a05:651c:11c7:: with SMTP id z7mr2085283ljo.29.1591270878905;
 Thu, 04 Jun 2020 04:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-2-keescook@chromium.org> <874krr8dps.fsf@nanos.tec.linutronix.de>
In-Reply-To: <874krr8dps.fsf@nanos.tec.linutronix.de>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 4 Jun 2020 13:41:07 +0200
Message-ID: <CANiq72kLqvriYmMkdD3yU+xJwbn-68Eiu-fTNtC+Lb+1ZRM75g@mail.gmail.com>
Subject: Re: [PATCH 01/10] x86/mm/numa: Remove uninitialized_var() usage
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Kees Cook <keescook@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 9:58 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> but if we ever lose the 1 then the above will silently compile the code
> within the IS_ENABLED() section out.

Yeah, I believe `IS_ENABLED()` is only meant for Kconfig symbols, not
macro defs in general. A better option would be `__is_defined()` which
works for defined-to-nothing too.

Cheers,
Miguel
