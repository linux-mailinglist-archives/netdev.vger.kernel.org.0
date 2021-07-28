Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7163D9836
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 00:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhG1WQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 18:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbhG1WQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 18:16:17 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F37BC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 15:16:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mt6so7361371pjb.1
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 15:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VdpUXFYFTBCwhZ0jThe/7G8C1R/D13Bb7JhWrRAjnpk=;
        b=CipDq4FhETwmYRPi6Xgguftb7dCGTlrwG/Fy2RZIb5fS4us/35+JAqH5QjwWg2ph0d
         t5FpYYtMFv7PXqC3ugAwL2Hwi9W5kjNynSgMFj53jb+T5c7+XGhbp4IxK2oTVu7SUMUB
         OFXAve2G1qjGVDs0RioV9wgm6s+MG1ZYlb3/J3Bg2cS1DR0xMUImgDz1V8ZIOVElzFD0
         21zkmlljbMwI1ScH5Os0QkFpypuOSDaCKjXwV8/ve6Z8XbggdihRbsD8uuhuzILjeket
         3dZIKhaS67L2vAGSoIXLopInH65Y376KDcFNNIxEb7Lp98LEpqvGcSORhxH6znS2rmOo
         SpXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VdpUXFYFTBCwhZ0jThe/7G8C1R/D13Bb7JhWrRAjnpk=;
        b=euhh3ODmaiPjs9IxFnncgMnfNr+6nQazmQgmbrZysy7QtqZOZua1shmUO4D8Cxp/Kz
         bfyHK7j7w+YGq2L2su2qhAbucxkKYHi2a0ZIiyverXh//uHx1ngNEo5H8veNVwZy0BEM
         limUpAjP+kTJ7FN19J8E5wiLN5nH7JISKYfrP2RR/pQTAWJXsxDAO8lGcNY386ruQCyv
         wehNxfQGiKmhAi+q/rUk9egF8WdiOtbP6p3JtDDQjfXWfFGFqQsPPyZlicTqCP+VE5cd
         I4oCTjYarbdTNKmF8TP9bva0lL6KLjIzUkMgpYvZbKLqDHkVR/m4eR7+xKreKxXobV9S
         EVmw==
X-Gm-Message-State: AOAM530iSiVKv6TBxDGK02ign1Jilh21jyw4mjp+dWjyGLx6ZTgt8mW/
        zgwaUipka/zjETeDU99MEXRXpeMCBd4n2CkgoY0=
X-Google-Smtp-Source: ABdhPJxnuXVPCg5Su8XO44hERudg2eiWSrQYjmk3pN+t93jFmzkIqTTAeK+YGnf8KH2T48R7WTeNX3SL5lnQBZoDz8w=
X-Received: by 2002:a17:90a:e647:: with SMTP id ep7mr11732326pjb.145.1627510573750;
 Wed, 28 Jul 2021 15:16:13 -0700 (PDT)
MIME-Version: 1.0
References: <cf72f28de22cfb326d4f8f6ea77f2253fcd17aad.1627494599.git.dcaratti@redhat.com>
In-Reply-To: <cf72f28de22cfb326d4f8f6ea77f2253fcd17aad.1627494599.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 28 Jul 2021 15:16:02 -0700
Message-ID: <CAM_iQpU--x8PRprG8W6btdXFBr0bNnYaJF6CorELmK+tOgry=Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: store the last executed chain also
 for clsact egress
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Alaa Hleilel <alaa@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:40 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> currently, only 'ingress' and 'clsact ingress' qdiscs store the tc 'chain
> id' in the skb extension. However, userspace programs (like ovs) are able
> to setup egress rules, and datapath gets confused in case it doesn't find
> the 'chain id' for a packet that's "recirculated" by tc.
> Change tcf_classify() to have the same semantic as tcf_classify_ingress()
> so that a single function can be called in ingress / egress, using the tc
> ingress / egress block respectively.

I wonder if there is any performance impact with this change? As
tcf_classify() now may allocate skb ext (tc_skb_ext_alloc()) too,
right after __tcf_classify().

Thanks.
