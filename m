Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0622C2343
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 11:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732184AbgKXKss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 05:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbgKXKsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 05:48:47 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E773C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 02:48:47 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id i18so21456266ioa.3
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 02:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rx1FisacXRP5Wc4IDBBQGYRr6shsYH3RafNx145VOsE=;
        b=NedJElcq37srUExAk02DLF1nLKgnpH+YFIwVg0z1jel/kW5+MxOwPtzqWO2rrfiZa3
         CumnQOEmj0EAj8Rtnn88gezrYYM0l67oJaytKdYHxz+PVlGLnbg2rbp93cD2OUHXOwj+
         bUULKxd7GTJOQCGXLMKBJW04wuTe/PpRNCZyPCH39+GyxbgUls2Q4ENZ0418akkY+kJm
         rQJvBk9bN8JnZWEndo9ZdcFceKrSW3FbDaC9EwQ2j16cyAvG83nZT7FU421/T8OY2AW+
         ILA3rejWbmS0uHo7b8mASmbpccx9+czBq+Q9pFPwQzEzJIBWIgtbiYjQztuZQ01yyfYx
         lmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rx1FisacXRP5Wc4IDBBQGYRr6shsYH3RafNx145VOsE=;
        b=BCXwU+UNRms0r514+id8MMRFS/UOdWRVHaMseQ2t9gLBiIOxzVjv3sx0Sr+RKt6FZI
         FNabF3CArAO0r7hvZVE0LJJqPLz59BmP41z/If34KGeZQk6XDBxrbObzkD7HbqY7CUCO
         plxP+tkVTZX3cPxg3xq8RPk210jSfM+7t0uKoJWZCSQ84l2r25WVA1cHfBDNpHST6AaI
         8xOM9UgvZUlRpbTpj3VFNyq7pxPNelDrd9XYl4KkuinwLY8CgOnwTjEN5WnJrJ1Tf4Zq
         pZ34R4+P3Qs/TuL6svvALgt06sjuCMn/mCUQ+4N2USqXy5xcX85KoI3kCEbj3Mymg7Ue
         hoOQ==
X-Gm-Message-State: AOAM533LtlXZ8YH36FKdM9LGF72g8WbvmPaeH4uR96lvvRw/c/ZOJ8ip
        hw7nRBlzjAOHY0VWh86gZxsgcSSDVUzE2Rk3gcc1CQ==
X-Google-Smtp-Source: ABdhPJwzGnMwpxNf4/Arx743yC7oSa3PH1asHkF6zUYJUmnc4OCj3JouIwuunzm1BKAe9OWprqhedXhVWiZZ7gkYL+4=
X-Received: by 2002:a02:2c3:: with SMTP id 186mr3838748jau.34.1606214926671;
 Tue, 24 Nov 2020 02:48:46 -0800 (PST)
MIME-Version: 1.0
References: <20201123141256.14208-1-tariqt@nvidia.com> <CANn89iKRVyTZg-tNQvo_Ub-RZ_A+OOQQY8Py3J9fx=NOZXF9Qw@mail.gmail.com>
 <9bf8ba40-cd40-2af6-d358-48dd98526434@gmail.com>
In-Reply-To: <9bf8ba40-cd40-2af6-d358-48dd98526434@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 Nov 2020 11:48:35 +0100
Message-ID: <CANn89iK8MXp0QmZbBKdMDHxi7A4afrVdBtgQq7cSY5SRefwraA@mail.gmail.com>
Subject: Re: [PATCH net] netdevice.h: Fix unintentional disable of ALL_FOR_ALL
 features on upper device
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 5:15 PM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
>
>
> On 11/23/2020 4:55 PM, Eric Dumazet wrote:
> > On Mon, Nov 23, 2020 at 3:13 PM Tariq Toukan <tariqt@nvidia.com> wrote:
> >>
> >> Calling netdev_increment_features() on upper/master device from
> >> netdev_add_tso_features() implies unintentional clearance of ALL_FOR_ALL
> >> features supported by all slaves.  Fix it by passing ALL_FOR_ALL in
> >> addition to ALL_TSO.
> >>
> >> Fixes: b0ce3508b25e ("bonding: allow TSO being set on bonding master")
> >
> > I think you should give more details to your bug report, because
> > netdev_add_tso_features() is used from different
> > places.
> >
> > Thanks.
> >
>
> Right. I'll include these in the re-spin:
> Fixes: 247f6d0f8667 ("team: allow TSO being set on master")
> Fixes: f902e8812ef6 ("bridge: Add ability to enable TSO")

I was more thinking about what exact issue you had, and how we can
reproduce it, and test the fix.

>
> I wonder though if netdev_increment_features() is expected to clear
> features that are not part of the mask.

Well, the 'increment' part was suggesting the function was adding
flags, not removing them.

We might ask Herbert Xu if we :

1) Need to comment the function, or change its name to be more descriptive.
2) Change the behavior (as you suggested)
3) Other choice.
