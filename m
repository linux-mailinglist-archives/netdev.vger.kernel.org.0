Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD43923C861
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgHEI5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 04:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEI5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 04:57:37 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951B4C06174A;
        Wed,  5 Aug 2020 01:57:37 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k18so15074708pfp.7;
        Wed, 05 Aug 2020 01:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F2G3w7PdTgr3TT96rVAastMovHHJc9pKaM/XEhVPHIc=;
        b=qjYkgIBsi3VeBxcNODR6vDZxrHBGq6NjsSowDj5uEUYV6aQyVYIAk7vM+6NzQQDjzT
         bL43TetMosI4QztLIdp0e60upbdgIM7BqmBBnTK+dEKqmfFHaWBKQZMJDMxUuHgWFBYL
         EYM3ocF7pw6xS3/g0rzpg4sHywbtF+pqCxsSIuWyisZrjxctfCrC+Ql3KMZz0CCHOD/L
         Jc1kFSwba4BtPxMZ0QDpkPf5qOZIjxbYgj9SsZtc28E6mKoqf+9JwU9uepktmoMtA6q0
         n6FntkDYwfjbTYTzt63cOKUYS2c5QPQh5g4SbJkjftBX8NyH0OVuGUiJgCIAAFIL4iMO
         0qOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F2G3w7PdTgr3TT96rVAastMovHHJc9pKaM/XEhVPHIc=;
        b=FcDC7zhPeXQTSsLR/He8/YUAFwvGaCiMoBHls3v5UykNDo8O3C0IITvbzzE6jAD6RD
         qHqhAYeHzxLLg2tL0IRyDvPuDknDR481Hx5H2qftfqMZzjPair06wqSaBdh3Zp6CMNhb
         at/YNrwcGzBOlHaLApSMrxw4knI2n0v9JOARCEUjVxrYjQ7ZFr59flzvmNraKwP51kn8
         UcxayFFxqHMNdBtryI2sz99qyGYPaPWxiMgElzYvw4gAozIeard/ah5J/Qx8hCUIWHQ8
         x73488pl0Dkv77LOc/SehqEft+aQ3KMPozlcPpp7PZWO37lmzWQHkwgO+CiOTUx0t8oi
         GcUg==
X-Gm-Message-State: AOAM532puYG6PSz8saytqjKcpCpJXPE5xZqH431ZWRsVfO3nqem/tawI
        6M6Radj0MZekX3LN61gOD6y/id2udflwZ3Bg9lQ=
X-Google-Smtp-Source: ABdhPJw7v5YUx5vRtVvvk1t/7SUWnOJK9xyezUOg5gl2BcGx6Hhd8wy1DMrsehyT71PANUYovH3skpUzdxoofC9wwDM=
X-Received: by 2002:aa7:9314:: with SMTP id 20mr2244876pfj.65.1596617857186;
 Wed, 05 Aug 2020 01:57:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200802195046.402539-1-xie.he.0141@gmail.com>
 <d02996f90f64d55d5c5e349560bfde46@dev.tdt.de> <CAJht_ENuzbyYesYtP0703xgRwRBTY9SySe3oXLEtkyL_H_yTSQ@mail.gmail.com>
 <9975370f14b8ddeafc8dec7bc6c0878a@dev.tdt.de>
In-Reply-To: <9975370f14b8ddeafc8dec7bc6c0878a@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 5 Aug 2020 01:57:25 -0700
Message-ID: <CAJht_EMf5i1qykEP6sZjLBcPAN9u9oQoZ34dfJ68Z5XL6rKuDQ@mail.gmail.com>
Subject: Re: [net v3] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        netdev-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 10:23 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> > Adding skb_cow before these skb_push calls would indeed help
> > preventing kernel panics, but that might not be the essential issue
> > here, and it might also prevent us from discovering the real issue. (I
> > guess this is also the reason skb_cow is not included in skb_push
> > itself.)
>
> Well, you are right that the panic is "useful" to discover the real
> problem. But on the other hand, if it is possible to prevent a panic, I
> think we should do so. Maybe with adding a warning, when skb_cow() needs
> to reallocate memory.
>
> But this is getting a little bit off topic. For this patch I can say:
>
> LGTM.
>
> Reviewed-by: Martin Schiller <ms@dev.tdt.de>

Thank you so much!

Yes, it might be better to use skb_cow with a warning so that we can
prevent kernel panic while still being able to discover the problem.
If we want to do this, there are 2 more places in addition to
lapbeth_data_transmit that need to be guarded with skb_cow:
lapb_send_iframe and lapb_transmit_buffer in net/lapb/lapb_out.c.
Maybe we can address this in a separate patch.
