Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C1927D32A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbgI2PxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbgI2PxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:53:23 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081BEC061755;
        Tue, 29 Sep 2020 08:53:23 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id w3so4442929ljo.5;
        Tue, 29 Sep 2020 08:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6T/gPSM6Tob1Q+HsGf85RqPislMCOa4wYNT++JFjYoM=;
        b=t52BqWyQUd0GTxqJ9DXqv7zkiMfTH34gLp7/BvexUSS+v0cvUatMAwuf+gmEBK1xS0
         FmB59AMqNLKMXC1dCLgHFD55qyOgcQZFGHIXXMLrkJsT/+EpOfpySxXgfbgnlct0PKkV
         Yor6UB46f7LxcwlDzeW7Qf8hBSXGY065B89Yr582O01ARNnZRFnRZ1go7VmaDKKkKdNe
         Txxavd/iH6M+Y1mLnPog15SssjivgIrUFWRse+k/nm6hkgynWux/8bF0cJ1Xup0oKZAA
         W8SNQQjr0y0JmZH+g1xytfUkvVLZ14DoM7WDIGmE/4U/xuQUpMk66VKFH4WMASf1h/bD
         Y3Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6T/gPSM6Tob1Q+HsGf85RqPislMCOa4wYNT++JFjYoM=;
        b=XVhhc7K7l7/kVlAeHKKQLjOj96b0t8kIqS6eTNrIPVfQLL7O+ergSp5ho1JTFXuTc7
         19e99hMTRsQlf97oGgJCHqUyQhVH+QIaOalWKgIH2BI3kY6Yd9uja6G50uR0LINOBWgQ
         uSDvpinMwDk623MxdtBhuhY4XDfZYEcMyEoYm1Ap/A3yk/TGxyThF7AgR7f7rY1vE/wm
         Z6/LmB7LdPl7un+nYazDIQzgfeetqgoOAu5Vu/8TwVorH1Tr3DKWADackdt3nBMcp16n
         v9D0Nb1GTjNzl7zikvUw6tN7Co5aIqQjzCSmWTyX9StGbDD5JjhJa7aJhGcp14EgnVtm
         Wn1A==
X-Gm-Message-State: AOAM531/PZ2irK5XsTsPGuP3coz0fDzG/QB2I5nNeuQhRqC9lfd+shTa
        /NLlaCiwGLrsOYRHcLGoA26S0CFaAIFVsV3mxlU=
X-Google-Smtp-Source: ABdhPJz+EzP+VsrEzbmpQ8oQBsWxf4CupB/NlPnvAKJ615QsbOam9YcEl9WizTVboIO1CE2MguWP/gQHOaHU2945JQU=
X-Received: by 2002:a2e:9dcb:: with SMTP id x11mr1459576ljj.450.1601394801469;
 Tue, 29 Sep 2020 08:53:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200929093039.73872-1-lmb@cloudflare.com>
In-Reply-To: <20200929093039.73872-1-lmb@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Sep 2020 08:53:09 -0700
Message-ID: <CAADnVQLFLAcKrY1ekD4e82xu+UYHirC-ViFgtqHqFobx7wohWw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/4] [PATCH bpf-next v2 0/4] Sockmap copying
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 2:31 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Changes in v3:
> - Initialize duration to 0 in selftests (Martin)

Clearly you didn't rebase.
