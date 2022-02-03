Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24474A7F54
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 07:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241827AbiBCGfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 01:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiBCGfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 01:35:42 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4FFC061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 22:35:41 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id c19so5957308ybf.2
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 22:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vjrhQ6Bso+tDVqavTEuY5QggmTm3bcZzqA0ycwHcU6g=;
        b=gbpscmGFdnMY7ZJSHJ5+sVtIHXTuZXyjrqGyt96jE6elVNlzXb2YAS33YOaBuF/74d
         ZVIQTksBOclckcId8pufm8dV9/kJHZNW2wlD3mf0+1EfD/aJuZnYZRH5y9/iBRJ9Dxrg
         SOtE8kyy87luoeWP3BgxvD9AtsApuyZw8Yn1Cao5tQJS5KJskihEGhxM0/tBP8QMtE/1
         /KS1X5tXBQtGopm1YeF0PguI4fjR5W4JSmFUcmlKM2wn6RQAtSIg1xk5xhAcUQxyAAU8
         iuNLnbB7hXcEifmdwSeLRF1aGe/A8YoRsiOtViitKxIJeCNSA7XtZo9eeh+r6bddOspS
         VaEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vjrhQ6Bso+tDVqavTEuY5QggmTm3bcZzqA0ycwHcU6g=;
        b=sHjD+IGQ8j5LFxJoGA7zeORTMCkRKMDKiNsYO27rOqfwenXPosnA025arEtuYzCDG5
         PdvJ1tbzN9jjXtsyc2ib2CSUEkiiUKuKeBkqeoxvaF8JEUR+LR6PnKkkWs6JvB+1RKGR
         Uif5H3nVsxoGWV1aYgFGZ31BSecvT8sttK+OdMwsufJBrA6/EXWS8OZvXJA48PLINDrf
         TwZxdmtnDY0Fsks51pH5XWv4dLS0HoJ4WECzQfLz7hEiMj6fU/7u+yUM2L0kVjHcT0Vj
         0YWn80vaQcK0PG+2tdiHLWj3JjpRQX1Wf/8x1ZB3lA1uSe5BuLZCmKQHqNbAdO2ioFvw
         qFog==
X-Gm-Message-State: AOAM5327alRu6RdT/smylnpn+g5LYtnXTf/wzqJAKTUVcOqJR6+giNp8
        6gIzGxf3LXn3okPhy9RBJl7vYrXPMAuor3+MY0pgPw==
X-Google-Smtp-Source: ABdhPJxqtzkoXALVLLbnju2OO+RKIq6WwTLNhi8Ju4bRI9rpSrfrL/WdyEcyHe+FhGkMrB1jCyOF53hwKc1o8zGnN88=
X-Received: by 2002:a25:d80f:: with SMTP id p15mr47152025ybg.753.1643870140789;
 Wed, 02 Feb 2022 22:35:40 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-10-eric.dumazet@gmail.com>
 <202202031206.1nNLT568-lkp@intel.com> <CANn89iJAkBXdmnU4FTO3MU2T+PxqkhFxKUpvp-q2uODurT6Wxw@mail.gmail.com>
 <20220202213136.2890d767@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220202213136.2890d767@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Feb 2022 22:35:29 -0800
Message-ID: <CANn89iKasispZdZNv5ztSfN=LhoU1JQ07WOE1g_Ea=QNYMKvrQ@mail.gmail.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kernel test robot <lkp@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 9:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 2 Feb 2022 21:20:32 -0800 Eric Dumazet wrote:
> > Not clear why we have this assertion. Do we use a bitmap in an
> > "unsigned long" in skmsg ?
> >
> > We could still use the old 17 limit for 32bit arches/builds.
>
> git blame points at me but I just adjusted it. Looks like its
> struct sk_msg_sg::copy that's the reason. On a quick look we
> can make it an array of unsigned longs without a problem.

Oh right, thanks for the pointer.
