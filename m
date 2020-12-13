Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62CC2D8B56
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 06:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgLMFFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 00:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgLMFFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 00:05:07 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CB3C0613CF;
        Sat, 12 Dec 2020 21:04:26 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id o144so11738778ybc.0;
        Sat, 12 Dec 2020 21:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z/uJz/Jw3MmfDGc84gX9EJKwTVBpnb7jcNLsPy/WYTg=;
        b=qbb6zoMeusOCfpjDEE+KXrzxNik5+GwTEST8oZQxqGb0IPh7Acicglg6QgggwsSODl
         nhmi5IZs8NFMHOJS9Yo8im9+F6eMyboUcziJjh0xGEuvW0hFEMamyfTAMmkMzuwuwX7N
         F7un+qdeVf7AfMvJFsM2N74xMrk1N+n+CNi+PoK2LZ/g5SRKe2ZSOaXInTCmSuGM2UqK
         WDSAPOgdLlaVIC/WZKgWOfLzQGw9yV3yCE+Yjctj5TDfdBKiGsBr/0IZ/eCnmiev/IRO
         dO9L/dpm29dI+w++0vDQl4NexJ7Effk7Df2uak5r9BhepGYXo6RWONeUuJxNmOU48l+r
         D/yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z/uJz/Jw3MmfDGc84gX9EJKwTVBpnb7jcNLsPy/WYTg=;
        b=XKSqZ6bfBciGaU7LzdB3WKul/iFwhhxI0Gv04mJjHedTiHmqdGEHQcMG3g2p57cPAU
         m/SYb+Hvj6Oyou8jUgTEqUAwYEyjrYyR+MWxLOD3wDwQd1vg4RQ0FJLwVrgsFeT09nGU
         c3UO6YyTZpKDrsrMG54+KCNE3YvJpqs3eqzWD+LaehX75++x0bDFy2a++DjfADG8nxWh
         2KKi4QUkLu/09LEvq2zShT1KehL772kfuvUb58+JWAS3iRqmgoiTykeYbpQlLVhXxjrj
         LprRssx2Ci+LVl1+/LwWecOJ2ZTprYJQC6CG8Oy4vaBpmlFOB7+OdI190upm/IsrCQ+w
         oTpQ==
X-Gm-Message-State: AOAM531pY59J2DVnZ6wFKh2A1Bg7hxt8NB+3guFBCYpna4MX96nhm+nY
        32bHdyYEQSmDLGgXUqMa5xRwOBW3yLuapGueO8nBGZTdHAc=
X-Google-Smtp-Source: ABdhPJwwjj1eu9V+fuA1Gf6y0i37Y+U+rhZRbNZrW53zzJW2PAYnMbAfMlzfkf0c0LLKIpapY5qqc4+MNZRlFQ4aivA=
X-Received: by 2002:a25:ef0c:: with SMTP id g12mr8240256ybd.26.1607835865316;
 Sat, 12 Dec 2020 21:04:25 -0800 (PST)
MIME-Version: 1.0
References: <20201128193335.219395-1-masahiroy@kernel.org> <20201212161831.GA28098@roeck-us.net>
In-Reply-To: <20201212161831.GA28098@roeck-us.net>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sun, 13 Dec 2020 06:04:14 +0100
Message-ID: <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 5:18 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> This patch results in:
>
> arch/sh/kernel/cpu/sh4a/smp-shx3.c: In function 'shx3_prepare_cpus':
> arch/sh/kernel/cpu/sh4a/smp-shx3.c:76:3: error: ignoring return value of 'request_irq' declared with attribute 'warn_unused_result'
>
> when building sh:defconfig. Checking for calls to request_irq()
> suggests that there will be other similar errors in various builds.
> Reverting the patch fixes the problem.

Which ones? From a quick grep and some filtering I could only find one
file with wrong usage apart from this one:

    drivers/net/ethernet/lantiq_etop.c:
request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
    drivers/net/ethernet/lantiq_etop.c:
request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);

Of course, this does not cover other functions, but it means there
aren't many issues and/or people building the code if nobody complains
within a few weeks. So I think we can fix them as they come.

Cheers,
Miguel
