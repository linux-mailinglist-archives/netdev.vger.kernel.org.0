Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87078293B7B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 14:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405861AbgJTMZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394317AbgJTMZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 08:25:34 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B344C061755;
        Tue, 20 Oct 2020 05:25:34 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h20so1761911lji.9;
        Tue, 20 Oct 2020 05:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ML5uAkCXg7BuNZzIK/5oJSDtl2w2jDqYSwb3Wy6qgRo=;
        b=EN2dgWsaEbWsTqxnHNLP/4yVmb9Xsku29Dn9P97JnSm57jrFWVcGIf1tVPjH3Vop1X
         WYBX779xvz6VaDNpWQufeY5mJxTCqpyGpHftTBTfK3wl+DbdMEFeM+V082QwXakiVoJz
         0AUcjpEw5FuBmPj+GyWNtzE2DWGm9u0DEO56o+I7EDCd5gzaIv69fQhrMuJv8qoM93nM
         ZXuXIbshfnD2J9Pk5uQL8GgRGonjdNjTQhjihahycKyR4KZKbz4qVGuEtqx6thztOvLw
         sQgQXowiD0bClO6P1LXXoSYG7PzbyCjRa7JHmpJ/Us3I9XGKF5Ani/Cs9ZoWU4s4pwds
         AqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ML5uAkCXg7BuNZzIK/5oJSDtl2w2jDqYSwb3Wy6qgRo=;
        b=Beb6CmszOZWkOR58UB0q49emfykjJJPRARFEx/iDQUhjalKiZ1e4O7q36UBcX3oWcy
         HhLmCdYjzCesjW4JeZlKSjk3snF11M1FS2g7yusjhHbzcdpVfr5fLHx7n/P94Bny0le0
         /GwQAq6AxAfdEI2QmpVG7BbW1Dd+f/k3Zf0TnrpO0+1ca2XPcPf5zDMFdSRGk0MZ6e8C
         sN91IZJlAtgUUkgX342pAI7Anp4dFwNtzHdzuLkRM2zJc9hkm8uycNWMeURTIro1zqfk
         FndPi85zdMZHwiJKI/9jABaKOwMnbxhJUMQyG5MEH+UUDtX1kPGt/otEn/Iy6sHGIdER
         4sVw==
X-Gm-Message-State: AOAM5305r4OwdZcK31ZNKjpXX07QSWblEG3PzfK6V0Wfjsdl/gQCqYu4
        y/LEDkaE5Lfan9MJFM+m25SyPi89RXZk05tcgw==
X-Google-Smtp-Source: ABdhPJxCfBQ6bdmOhdx4GH2VRVDFLUiGSOzY4fw/kjcUoUR25aNPPq1QlCXg34SenUnbHVFHi9gDJq8f1/QJHbCqek8=
X-Received: by 2002:a2e:b4d0:: with SMTP id r16mr1068673ljm.470.1603196733039;
 Tue, 20 Oct 2020 05:25:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201015082119.68287-1-rejithomas@juniper.net>
 <20201018160147.6b3c940a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA8Zg7Gcua1=6CgSkJ-z8uKJneDjedB4z6zm2a+DcYt-_YcmSQ@mail.gmail.com> <20201019091702.5b26870c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019091702.5b26870c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Reji Thomas <rejithomas.d@gmail.com>
Date:   Tue, 20 Oct 2020 17:55:20 +0530
Message-ID: <CAA8Zg7FQL6Ong+70qpbh23ooORJ0C5_mZGCP_Tjw2zYHQBKxAw@mail.gmail.com>
Subject: Re: [PATCH v2] IPv6: sr: Fix End.X nexthop to use oif.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Reji Thomas <rejithomas@juniper.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        David Lebrun <david.lebrun@uclouvain.be>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 9:47 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> If we can save the device lookup and still be semantically correct,
> that's probably better.
I am afraid we need to do a device lookup if I am looking up the
neighbor. neigh_lookup
apis expect dev to be passed. If I go through the current lookup ie
ip6_pol_route() I can
drop the dev lookup at risk of returning a non neighbor route as it
exists today.
