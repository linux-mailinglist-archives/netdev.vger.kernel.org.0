Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F93D2CF430
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgLDSgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbgLDSgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:36:05 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A490C061A53
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 10:35:19 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id b12so3674609pjl.0
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 10:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DR6em0xTx/wXQ7IaD8PIXYOj8qv6Du+fO82+FBS5lNw=;
        b=sf5l4P5L5ozL9cXc18I3/GVwAl7P5spyz6KrvDncFtdVetVqzEsS8WGYPfmLRyj2BR
         wQRAjkb4WSQpf5GemY1Fsg578oAuEnaHNYp6esPOveocsWSRjV0o78MbTF2WTLuaI7en
         lxr1cAwkBLOw7IxrPi7cu9+LFCL0BqHMvbsbzkp/z+gazt9tYDEqh03mh+5+169zvQxs
         ifrpmEBeEs9qwo/WLxMTaFWFMky9vh1pLBqFsCT/ROx+vmq/JnQJXnnR1lmxF5m7f4XI
         2Imm1Xk6tHM3aRveYoqnr7hvI0x4Uk1JwgJnVwjR5XJ983r7SVp+HUeMABZabVOKhjPD
         Su4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DR6em0xTx/wXQ7IaD8PIXYOj8qv6Du+fO82+FBS5lNw=;
        b=M0xCL2JPuZAE30PVTyBp+zZYbg52SwXMDnO73rYGQXCnIFsJU+0sn1hCci3S8Nnbyz
         rMLU8/1RvSZpeZbQaH1QEF+pQ77kk+UMB/pdBf2jJ6SyXLAfo3R+WVyoNJGC3EHZNATL
         ZjNA8YjVoTY7Saj0lNDVHP2qoAVq1rV+XxylbCfWaCMRM/mfw2dUSEpt8bI0sBPB77kt
         G+i4qaxinkKBkDLtbGh9C7sG6PGptH/7MT6DP9kHV1TsopyI/nn5l6qusgL5CIT1p1mF
         KKuapTAUSgFAHDnXvybjjcYp/X9hyufllq3y+DwXMPtg8J7NrrchTdCtJdwVNvPzPMJK
         yBpw==
X-Gm-Message-State: AOAM531M74dYVRqIjR299dyiUBoRChS4OUi2ce5w7zRfdLkICA2G4+aN
        K4YlDJMbrO18atNvsrj3Ek0+dHzC3RnB51io+YnlyxjhcHMhXA==
X-Google-Smtp-Source: ABdhPJxuoIALHhFP3jTVABBYFLaeaKLDKmlBL592dFO6ikck7v2IuEDi6Hwu8jJiSiE5SBsllHdT1sGlzozTTPIJxys=
X-Received: by 2002:a17:90a:ae13:: with SMTP id t19mr5357351pjq.52.1607106918685;
 Fri, 04 Dec 2020 10:35:18 -0800 (PST)
MIME-Version: 1.0
References: <2e78e01c504c633ebdff18d041833cf2e079a3a4.1607020450.git.dcaratti@redhat.com>
In-Reply-To: <2e78e01c504c633ebdff18d041833cf2e079a3a4.1607020450.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 4 Dec 2020 10:35:07 -0800
Message-ID: <CAM_iQpWf4CS_fR69JQfa2pEV9Yd26p=neZ+nu_1rOLvbbn=TiA@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: fq_pie: initialize timer earlier in fq_pie_init()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 10:41 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> with the following tdc testcase:
>
>  83be: (qdisc, fq_pie) Create FQ-PIE with invalid number of flows
>
> as fq_pie_init() fails, fq_pie_destroy() is called to clean up. Since the
> timer is not yet initialized, it's possible to observe a splat like this:
...
> fix it moving timer_setup() before any failure, like it was done on 'red'
> with former commit 608b4adab178 ("net_sched: initialize timer earlier in
> red_init()").
>
> Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
