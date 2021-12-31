Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B46482613
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 00:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhLaXFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 18:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhLaXFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 18:05:54 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FD2C061574;
        Fri, 31 Dec 2021 15:05:54 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id x15so21005274plg.1;
        Fri, 31 Dec 2021 15:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g5v1xPzowAYu3QM3an7egFraB+wrAFLcZhivMPg3KZ4=;
        b=CuXocwPY1LkIGBBMnlAvjl1KAGA+hh8/mmpui7RbE6MbUWGHMiiBnWklZg16g7bnfW
         VInYAmQuN3ZzoOGApQaNTUIDYvdX5tibV9MycFnF4+NJisK4XvzBx9LCWxUm3UXvke2D
         gPa7BamE97GqNJxLtvh7jdKnI3N2M1XMclwJXaY8GpvAnBNKAHD2kNzyDqsjuz2g4sCP
         lJryWI4ce9QzLQ8wjlbJfsePyHauKpvxzkUVKYCX4JhwjHfk/r8k6wssDjew4ELQAgP1
         XDsBmPiFpfB4gp5RWsQQmng/kF6SPWA5gvUSBtID43qZ3suSMLW0VefjrdnkZWGVB1yX
         Seag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g5v1xPzowAYu3QM3an7egFraB+wrAFLcZhivMPg3KZ4=;
        b=tH5/0eF/yH+/W+gu35R2g4SlV1VkiUR9ErAZ+iuF+tSI4wLqEv/yvJ6oOtPwUNOyFK
         SaK5MWOYzpVx/Jb6xXP1548TPWSUuUDufpjXS9+Ct1Vve4VF5RaOL+JX2bOogvbcQvcC
         S3txEPlZ6Ufa/2jQatjJo87GSE9dD5RvEL3B219J0XHUkUZtiqwVcvjz3UtDhaJ0XlM8
         jG4pcgNaHPdV2L6ef3r7mHndcz/BVZ95RKUiVYMjRatywFwoA4KehhAkQCEjIs4gByzt
         xOnp+IdHzFzpDkQUTlSOGs9cT/sIn7sNlx+r657dWinuq9qTLk/5FxBqhfhT4rmmyVMT
         PMsg==
X-Gm-Message-State: AOAM532ENQ6yKDED9x9hpPy+heuyWXwe5QJMCBw4U0GrGT8rs1g3PLkd
        RZ9z0fjeVsAcdnLkQZDPWbOVJLIqLxI=
X-Google-Smtp-Source: ABdhPJwAXDdng5LIu7g1RaPML/kmSMWkLIJVrRea+7I/d8/AqEU0qSTAiGnHS1teHg6tlLkqby536w==
X-Received: by 2002:a17:902:e843:b0:148:f219:afb7 with SMTP id t3-20020a170902e84300b00148f219afb7mr38168648plg.81.1640991953323;
        Fri, 31 Dec 2021 15:05:53 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id k8sm33927314pfu.72.2021.12.31.15.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 15:05:52 -0800 (PST)
Date:   Sat, 1 Jan 2022 04:35:50 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com,
        linux-modules@vger.kernel.org, mcgrof@kernel.org, jeyu@kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
Message-ID: <20211231230550.t2wjz5g5ancrqx7d@apollo.legion>
References: <Yc0yskk0m2bePLu6@dev0025.ash9.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc0yskk0m2bePLu6@dev0025.ash9.facebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 09:46:50AM IST, David Vernet wrote:
> Adding modules + BPF list and maintainers to this thread.
>

Thanks for the Cc, but I'm dropping my patch for the next revision, so there
should be no conflicts with this one.

> [...]

--
Kartikeya
