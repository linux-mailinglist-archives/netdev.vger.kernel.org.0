Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3741E8DF8
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 07:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgE3FR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 01:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3FR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 01:17:27 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A983C08C5C9
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 22:17:27 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id h3so4531750ilh.13
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 22:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3dbGwSV8YE4xtENP3jLs4r2lGOKg13QVXY8/aySxMQI=;
        b=CQqG+HGy05FFpZbSeH3Oz3XX3AiIEyYtO+6kv8FKxfzMiuWeoGENkPn9wg2/4Zbl1P
         kJAkY1l+NRi0ygVIMfsnTgetkvGjAPd0kOXdtMlrCIJEmkchnpUcPtkEcJWzs2JAzvQm
         gBrjMKGlYUlFl41Pxys9NecC7A9MnkkMmed1MOsKoFkQUNw7Dy8Ac1CGakNpH9dD+t1z
         ott1WcHTtmsslO9AEpXIL/dfy5u5gvC0JVPp72BQyhP/y+HiO88Qe9DcRmUqOPdSQJqe
         kaMRHQj4pRlB5s5HBF+nnASOsNEL7xqPc4aMnQ+qe8baD1CtebArkjfRd9+wZuyjgqCz
         g+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3dbGwSV8YE4xtENP3jLs4r2lGOKg13QVXY8/aySxMQI=;
        b=ojb0ZtabAJAH3r8Xa343l3DNozuV0IS63ZfasUnZ8SAj9iDGByIpsTMfCyw8eUo3kx
         lFnpNq0W8ve14bN7zLGSmv85aGQqho7Si2ZTETN2JLS0+abVW+jCLTMyrJS+l9JiPJUX
         VAGE9WotGOPUv/wWrALeoA5P74tnm2poD+DuuxPFywwZJ8gtLvG2yrz5X3jOUKQt9UfS
         wFUTq+0bblL1oM93XYullxm3CVLtfvVbI1wDubwlKpv7SZKuA0zjvCBP++e3K6NidGuz
         XHrwqN3fQ20mW+Q9gP21byG0s+vLuoGgUDTL/ri/1sFyvFTlaeGJQWrLNDkuxljfVfhO
         dJ0g==
X-Gm-Message-State: AOAM5337sT466tvYUQw3N6ja4sVDwvYemTeTYwvUwBloE4YAWF3HUgzT
        hBUFZgyc8TyukLepAjXlmQ9hIHb2M19p6L0TpgA=
X-Google-Smtp-Source: ABdhPJxDKc4phtF2kAS7W4p8Xg0Fx9osF30V7h6muTcSh4kLM4vwSW1p2d2pSkbqSxfYSfDSIX16tbP/8B2bdmHsLhk=
X-Received: by 2002:a92:5b15:: with SMTP id p21mr9569854ilb.22.1590815846688;
 Fri, 29 May 2020 22:17:26 -0700 (PDT)
MIME-Version: 1.0
References: <419fed9287c2b9abbb71cc96ac3253ef0074d63e.1590775205.git.dcaratti@redhat.com>
In-Reply-To: <419fed9287c2b9abbb71cc96ac3253ef0074d63e.1590775205.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 May 2020 22:17:15 -0700
Message-ID: <CAM_iQpVesOZ0kQ2OWHss1kG3O5tvYUYETK4A3LW9doH5ZFQjmw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/sched: fix a couple of splats in the
 error path of tcf_gate_init()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ivan Vecera <ivecera@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 11:10 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> this is caused by hrtimer_cancel(), running before hrtimer_init(). Fix it
> ensuring to call hrtimer_cancel() only if clockid is valid, and the timer
> has been initialized. After fixing this splat, the same error path causes
> another problem:

Hmm, but hrtimer_init() should not be called for an existing action
either, right? If so, we need to move it under ACT_P_CREATED too,
and you do not need to touch tcf_gate_cleanup() any more.

Thanks.
