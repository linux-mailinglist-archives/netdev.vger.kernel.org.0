Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC032FE234
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbhAUGBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbhAUGB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 01:01:27 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D3BC061757;
        Wed, 20 Jan 2021 22:00:43 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s15so668169plr.9;
        Wed, 20 Jan 2021 22:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=nm/d5EhZ/OB8dy9RYltdCSlYB2STRBBjiHimEPU8NOw=;
        b=oD+OZniXZxdd2Cw+nAnP8VWLSUTfEFYCyR5mej2IGW5/W8u/E8BvWsvX4uEi9N6yjZ
         6FHjvrxSsGGFQpO3qZ8nrIZt1Vhk1j/nlSrqyqMJNB0WmvAdEG2G+ibbcZqQqGQwWm5u
         I+SpRqJLK1bzWHLAuLTqqm4Y4Ho9doYEIX2lSwazWKVoE4qMH9IeVEN5jrfGsYjt/Na9
         yu8GorLbx8AxJR8OZRCXFAbYYpvwhOskya9gKHyhx2LGQq2R4SWtpeM9KQWLnopQ2jFo
         JacczzMS4deT2l/5w/aRjDkn3Fq5QREZr1y0yDQr7sqowxySmefspXy6T7/PtejWQuDc
         awog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=nm/d5EhZ/OB8dy9RYltdCSlYB2STRBBjiHimEPU8NOw=;
        b=DfEq0+d9G6R1pVqVuQ1yIMt3wXxT3PmD0CC3Uh1WaPl59AuwYCThNdniIlnF+NKx/B
         PLSxV9RdU0nASWYSHwRIfYyxJ3/+mLsDi2+hRemNbAM/rYTQZpCCNMEUmqVujJtKxTEB
         Xv8CBrTT5dMfTUXR698EGRvbmFA1cCEBOn5IKhqFY4FoijOPWpy9g1mSJHJltY9RLtYQ
         3W2SdIcgAWLmf0+X5/LJwsQqeL/Igjw6gboXdUZFM3hyA99WraO+dFH6/yUgUwg9uW0f
         25T6/iNwPAEEZOd0wdHNedVBgl53xQFkSOtkb9ehl4n9pqCBNN4xUEGUlOUw6sW48JTm
         a8pA==
X-Gm-Message-State: AOAM530J9QQ6xSVpPVZxzNkXs8oLsiPeZXGWokDPZMXZf4tmPvbizMih
        WLpxMk/GEtMbSHn0oVNA+HICVY+TkTQ1ceMp/zG9etpeCqI=
X-Google-Smtp-Source: ABdhPJydWax2/fugoXpsWOXPL01l7yleuBY5u23KrpMyhc/IQf/3F5aX/FL17gNJlX/FYGjZX7GiSH/t/sdYO//bk+M=
X-Received: by 2002:a17:90a:9a83:: with SMTP id e3mr9984025pjp.210.1611208842977;
 Wed, 20 Jan 2021 22:00:42 -0800 (PST)
MIME-Version: 1.0
References: <20210120102837.23663-1-xie.he.0141@gmail.com> <CAJht_EOdpq5wQfcFROpx587kCZ9dGRz6kesyPVhgZyKdoqS8Cg@mail.gmail.com>
In-Reply-To: <CAJht_EOdpq5wQfcFROpx587kCZ9dGRz6kesyPVhgZyKdoqS8Cg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 20 Jan 2021 22:00:32 -0800
Message-ID: <CAJht_ENjV3k_d7TyeJmKopSPoVeGZb0s5PnkTeX_2hCOXNsWwg@mail.gmail.com>
Subject: Re: [PATCH net v4] net: lapb: Add locking to the lapb module
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 12:42 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> With this patch, there is still a problem that lapb_unregister may run
> concurrently with other LAPB API functions (such as
> lapb_data_received). This other LAPB API function can get the
> lapb->lock after lapb->lock is released by lapb_unregister, and
> continue to do its work. This is not correct.
>
> We can fix this problem by adding a new field "bool stop" to "struct
> lapb_cb" (just like "bool t1timer_stop, t2timer_stop"), and make every
> API function abort whenever it sees lapb->stop == true after getting
> the lock.
>
> Alternatively we can also require the callers (the LAPB drivers) to
> never call lapb_unregister concurrently with other LAPB APIs. They
> should make sure all LAPB API functions are only called after
> lapb_register ends and before lapb_unregister starts. This is a
> reasonable requirement, because if they don't follow this requirement,
> even if we do the fix in the LAPB module (as said above), the LAPB
> driver will still get the "LAPB_BADTOKEN" error from the LAPB module.
> This is not desirable and I think LAPB drivers should avoid this from
> happening.
>
> So I think this problem may not need to be fixed here in the LAPB
> module because the LAPB drivers should deal with this problem anyway.

Never mind, I have sent a v5 to deal with this problem. In v5, I made
lapb_unregister wait for the "lapb" refcnt to drop, so that we can
make sure all other API calls have finished. Please see my v5.
