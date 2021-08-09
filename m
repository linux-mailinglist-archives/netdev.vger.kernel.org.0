Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77A83E4D7D
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhHIT7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235725AbhHIT7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 15:59:51 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F44C061798
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 12:59:30 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f3so7135282plg.3
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 12:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mb5JbXTBEjTbuAmtTDmolVgyxWNhGMSJyE6HjiEsyL0=;
        b=Qa837eeUOfPNPzyv2nakd0+Rnsk3FQZRcz8Jgge0ZIW59X/LeY5og57tHh+J2omnbD
         pKyqM/A+hhSp1UwHp8+iyMlGfCgzOD5vHcITOti5v5QZnjhx1f47dwQNT/ISaEzQy2pg
         5e5IYulQkng6VnGCeL/DQciSj3H95sO5hUdX62K6MClwoqGROt80+mYiw7pqzsYDNnML
         k3XUk2URDH6MkcNQ20sx8S1N32AVYEZ4SA+30W4xaKr+9Jq1zVOzRq2eQPowsixAH/Kt
         bvigVJUj4ISN47RnEiRUyIZjOmYeCkOi3S/6yApldR+Kr0sG6MLIJoKSYziiAFfvZ0LN
         An8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mb5JbXTBEjTbuAmtTDmolVgyxWNhGMSJyE6HjiEsyL0=;
        b=rekY3fT9bsI/P6oN26Zasq8SLGbc1Ccd/q+jbQtxyOPadL/BFPcBK56HPBmw94kDk8
         mkkPJsT9qQtCgrx1YRgLcnvgV5CLa51W3uGXSeTOhaJCBdIucPKiXS9gwWrpuxWlJggs
         Ir3dACb6+Zx9kqa/AH9rfBa/LuetCOmzGCQDTCAp6FKz68UR96+oEQQGm640e2o7r/E7
         NKQYl6KDXzbp7KGfbG8fThWXJeIyhXKfHIY1EsXgfa4NtFQA8tEOanf20a1A7bvMY1UZ
         T0pnofkUUonjPJ/u7ritBz12IpLJnhXUttgLgeu8uXbwd+/30LN9MmfThwQu3cwqVQjq
         JMKA==
X-Gm-Message-State: AOAM5337qBWkt6pH1z7P7k7iV1GWOaWntaT5vJRKw3XIxtRDsZQWyodb
        7qacS6ECK1IgdCWBTGckb9MoIZbaVMOI2p5ntXk=
X-Google-Smtp-Source: ABdhPJwEYwfNSiwn11SsG8zFge/d/P9geCwoOzvHffeNguNpAkDfHV33/su4E/VPm+ajMIc0iMyOKwn8D/dt3/FBkoc=
X-Received: by 2002:a62:ea1a:0:b029:329:a95a:fab with SMTP id
 t26-20020a62ea1a0000b0290329a95a0fabmr20135074pfh.31.1628539169712; Mon, 09
 Aug 2021 12:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210729231214.22762-1-xiyou.wangcong@gmail.com>
 <YQ/wWkRmmKh5/bVA@shredder> <bf87ea8b-5650-6b4d-1968-0eec83b7185d@nvidia.com>
In-Reply-To: <bf87ea8b-5650-6b4d-1968-0eec83b7185d@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 9 Aug 2021 12:59:18 -0700
Message-ID: <CAM_iQpWntEBV3msNct=vH=SsypBLco1epGRA0ywF1g-5yXezDg@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next] net_sched: refactor TC action init API
To:     Mark Bloch <mbloch@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Vlad Buslov <vladbu@nvidia.com>,
        netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 8, 2021 at 8:01 AM Mark Bloch <mbloch@nvidia.com> wrote:
> Hi Ido,
>
> We hit the same issue, I have the bellow patch and it solved the issue for us:
>
> From e4f9b7f0b067bf17fd0f17d6e2b912d4f348718b Mon Sep 17 00:00:00 2001
> From: Mark Bloch <mbloch@nvidia.com>
> Date: Sun, 8 Aug 2021 13:23:08 +0000
> Subject: [PATCH] net/sched: cls_api, reset flags on replay
>
> tc_new_tfilter() can replay a request if it got EAGAIN. The cited commit
> didn't account for this when it converted TC action ->init() API
> to use flags instead of parameters. This can lead to passing stale flags
> down the call chain which results in trying to lock rtnl when it's
> already locked, deadlocking the entire system.
>
> Fix by making sure to reset flags on each replay.

I think this is the right fix. I clearly missed the replay case.

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks for catching it!
