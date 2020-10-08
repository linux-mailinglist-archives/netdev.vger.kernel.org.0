Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828D1286C74
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 03:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgJHBmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 21:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbgJHBmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 21:42:50 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E33AC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 18:42:49 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b2so4240600ilr.1
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 18:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=83ySpvqV5gFUnQZcQCmMD2CO2gRY14MfiLuSTGuy8c0=;
        b=hyNUg4ANCZFve+TC/Sy0327FUcDTPl9OWfXbaBmH/DauMQgAWLko4QL1Rqi96KW2yx
         PS/od/lVL4HHnG8KM4hVAV3lOfLGMFG9+UdYBI19JaGIV++vQ+vLR979Rv6IyNcyh8Cy
         gUXwDxAxw+YpMNY4JXjodBaKm6VepdcJluGxuTHb1jF8xH9pF7tYALVFlbHjLfAF3+n5
         RNLSrzJn1RUov7FAgfXlzmaWMS9pUerNG6/mgOpg/CPXG0Irh2SnPHpLafdZuWVXQ0jI
         ecatTjPeptKUdF63HEMX7XuhBindxfbOQ6MqGApkse+Nr+DRbZyNg83CQybX6kzU7LT9
         5+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=83ySpvqV5gFUnQZcQCmMD2CO2gRY14MfiLuSTGuy8c0=;
        b=NzC9g75ZtrlmkXfrgdLZhTkjBtB5h2FIqHgFohIkW3UTuxNNIpRSfDbnlCl3HU+TQm
         cu+zWh7oPDSYTY8yb/Z2Zc7vKvLTMHfTDi93GXJpaw24YozWj0Sh9F3KUUErHln6t7EO
         b8+HMb+WC2IuMdSHovcs4QazffDpc28pyeNmWSuUSuX93J6pVhddPhapl3p2jFP/XD/N
         ciQOTV9IxXvwxjHgrM/s7qnXhCqnWEuVSjPXljRjbKhym3+HY9n4OmWiR80HJ5d7hYY3
         wG++vMRSG4Z5vbGjpyyM8lYJZfnQp6PLW6/9b11PT858pMhik/zeleQIu8yLABXR4919
         OXHw==
X-Gm-Message-State: AOAM530gAQEaPtFNiinr69hExZ5ejIFmQ5GBHW1974BP13o3Zh4I8tkp
        dWayamzN3iaBklFjTY29uxwJv3S0o21JyaqAeqA=
X-Google-Smtp-Source: ABdhPJwm6eXpFhdRlmN+QVPcuCNn2oVFfnHGwXvA2yHiCjWRajkQPra9yU5RwgsQYo4CqYmAjqRCFbS9lR3YLCUEeRs=
X-Received: by 2002:a92:7751:: with SMTP id s78mr2383792ilc.144.1602121368439;
 Wed, 07 Oct 2020 18:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201007165111.172419-1-eric.dumazet@gmail.com>
In-Reply-To: <20201007165111.172419-1-eric.dumazet@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 7 Oct 2020 18:42:37 -0700
Message-ID: <CAM_iQpXgjDwF0bO+vtJx7zqyApFRwkkL-qtakNCvwOp7c9pu3g@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: get rid of qdisc->padded
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Allen Pais <allen.lkml@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 9:51 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> kmalloc() of sufficiently big portion of memory is cache-aligned
> in regular conditions. If some debugging options are used,
> there is no reason qdisc structures would need 64-byte alignment
> if most other kernel structures are not aligned.
>
> This get rid of QDISC_ALIGN and QDISC_ALIGNTO.
>
> Addition of privdata field will help implementing
> the reverse of qdisc_priv() and documents where
> the private data is.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Allen Pais <allen.lkml@gmail.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
