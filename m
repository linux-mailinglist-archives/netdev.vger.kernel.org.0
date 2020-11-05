Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BC82A774F
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 07:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgKEGF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 01:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729731AbgKEGEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 01:04:50 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDA2C0613CF;
        Wed,  4 Nov 2020 22:04:50 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id o11so617475ioo.11;
        Wed, 04 Nov 2020 22:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TmCofzCj9lKvR+P/ENMeSaUEMVenaNbJ49Oabt188RM=;
        b=U0fpqSgGPJgRzVH6h5D3dFF6/dEJaAv6oxkug5V+SBkABtbEyjBuEdZsfUSy98+PQF
         u1bWsn2zbm5OkGQ4PN86FXC4YQFqsY6v0h1jjAYIt+rKhAcmAyopVQsiyqVc8XOnS65n
         99YFqCyYhQ8l0R0/+JQ/lBFf47OudWWNMC9jq6QmJ365MUZT0pOuTKPBvpk79U7kTTE0
         Wui/fbVmPF8GhljduRk1Bgzg0hj3woJxZIKhHU/CUrrx2DKEDx5wmI1ek1sAcu2cfBWC
         jcGAiuK9SRzAYSX6S2LB3gZFJbL7xNqtwfS9OvrpQsXmbbzlYbJ1YxIRu9nt58hnspnE
         CkmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TmCofzCj9lKvR+P/ENMeSaUEMVenaNbJ49Oabt188RM=;
        b=MIQh4rlKMuCByf30eQ7Ghjf6DovqwAh2LGRNrFrqME1dtVPNHtLTJ1l7r8HVa4sR1/
         7DXZX43jMKbb8qbXs4bAuRZj2A7/9tXPAbVnZy56+C5c28M8Otdo5NmX08WOA+ffr4Xa
         JLp97XJ2/3OaIOeDpxEh4A1vv7BelOEhhG6uvBb0kYMPwbrROK4tnZ/QFhVtwY2S9e/G
         4snOvXP3Q3MiCjfXNkH22Gti8D/203h0PFKwFrNU//Yj5mkJkOQIiH0e5mTGZJVkocIN
         rT4cbcAAXaFdNKuTeLzNGtSQ08fYLU1RMZoP5dhYkCTNzUb7SCTMin9Dt9bu88m5BqOA
         Pf0w==
X-Gm-Message-State: AOAM5323KicAn1Pmb69W3o7mlELz0EFl8GoYgD6c8zJrTTXIr9tVKM2M
        AO1OsmoeriUJUWSOCkT5N5gh8Gcrq5x4c1dT9mU=
X-Google-Smtp-Source: ABdhPJyOBUcUrXmMH74O3Hau4bdmA85viAdeGhkLnGnTBPKyrlkbVG5giWgowy032RFwGqvRp//o9rOBlXsOm0bYCgw=
X-Received: by 2002:a05:6638:d7:: with SMTP id w23mr882665jao.131.1604556289475;
 Wed, 04 Nov 2020 22:04:49 -0800 (PST)
MIME-Version: 1.0
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com> <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
 <1f8ebcde-f5ff-43df-960e-3661706e8d04@huawei.com> <CAM_iQpUm91x8Q0G=CXE7S43DKryABkyMTa4mz_oEfEOTFS7BgQ@mail.gmail.com>
 <db770012-f22c-dff4-5311-bf4d17cd08e3@huawei.com> <CAM_iQpUBytX3qim3rXLkwjdX3DSKeF8YhyX6o=Jwr-R9Onb-HA@mail.gmail.com>
 <5472023c-b50b-0cb3-4cb6-7bbea42d3612@huawei.com>
In-Reply-To: <5472023c-b50b-0cb3-4cb6-7bbea42d3612@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 4 Nov 2020 22:04:38 -0800
Message-ID: <CAM_iQpVGm_Mz-yYUhhvn+p8H7mXHWHAuBNfyNj-251eY3Vr9iA@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 11:24 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >> From my understanding, we can do anything about the old qdisc (including
> >> destorying the old qdisc) after some_qdisc_is_busy() return false.
> >
> > But the current code does the reset _before_ some_qdisc_is_busy(). ;)
>
> If lock is taken when doing reset, it does not matter if the reset is
> before some_qdisc_is_busy(), right?

Why not? How about the following scenario?

CPU0:                   CPU1:
dev_reset_queue()
                        net_tx_action()
                         -> sch_direct_xmit()
                           -> dev_requeue_skb()
some_qdisc_is_busy()
// waiting for TX action on CPU1
// now some packets are requeued
