Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D972B3BF257
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 01:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhGGXRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 19:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhGGXRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 19:17:50 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E330C061574;
        Wed,  7 Jul 2021 16:15:09 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l2so5698041edt.1;
        Wed, 07 Jul 2021 16:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hiqmU7ZYFmC5qBB3mvHvn8V7nMpjIpKM26FEZSkngpA=;
        b=QyqgU8lUT4i25prlzDFORgjBnNZ0TJymrLOsABQ3kiGyl5xYqPi/3dDQ7DVv5uWNFe
         1FvPlG/kyMEoZEeRnoW7JgOxq33yWROcWWFinfSvnp6Sgq3l47gkdOUswVGBjFa1/aXz
         o0FDTzylSxQz+bjdWU/zkMEo+Q7pM6Ef6PU4hltEjeLOMvmqpWE50Fd9df9ciYKCoG5V
         ig8ijLtj+MFLKdC+JKCDQ+7DzHhoJldjp5iI019geJ/kQE9q6NmbgOjPS5AX1y4ApB4O
         R2I8/918UqxFCCKecdGW42g88n0OW42kGqQVWNN0I7rQEzJtmNzgMYT3SmPuZEsQN/BN
         gjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hiqmU7ZYFmC5qBB3mvHvn8V7nMpjIpKM26FEZSkngpA=;
        b=pBzREpQDTX8U8q9mQqQUj5+Dihw5UL51eP2rQ74ZWJkJx4ZZqc5OeAzZO4ip9XNHoL
         omlYyzv6b39IGIFoqAL/eM8ECw6gI0vTD7bwvu4rSU9pNBfG9fp1tBVbIh0neE8/sHcO
         xTD2WBb/ynBZbCcG6K4xcMykeT41ABpNZ3aWPI5ZDDVDwyA7GKsll5hZXVWLcJCh4RQr
         3+YAFC9+Y+i5Jpn3OnZXZulja91cS6iASr0kp7QpYKMksA3ou61TtBkqucsNTWicqsJ/
         h+1EH1V/Fg0Q3/5wWBPZyRJoWYabuWGKuYgCMLTTxQqjU4bTlzYxCgR3ABUfcw9Q8Rt8
         zsWA==
X-Gm-Message-State: AOAM5331b31HqfcUKSw+zjO/DeZPJX9LN2N5OLQgr8iht0i6z8zwL4vs
        VaEVh9Vr9AkuWWDUR/JaHGka2oXmedRR+75tZtY=
X-Google-Smtp-Source: ABdhPJw/QbhV7h2OucqiPsRQSIVXrfzpuEnQfIfgy7HXMh8oF5X4ZWORAx+hBOUdZV12jG/IRC8Ucy2VnIMn4NFYo68=
X-Received: by 2002:a05:6402:3507:: with SMTP id b7mr33896051edd.66.1625699708103;
 Wed, 07 Jul 2021 16:15:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210707155633.1486603-1-mudongliangabcd@gmail.com>
 <CAD-N9QWZTRWv0HYX9EpYCiGjeCPkiRP1SLn+ObW8zK=s4DTrhQ@mail.gmail.com> <CAB_54W6VkOQ+Cf4gmwzJyQpjyK5MRqsGXkQD3fPa2UC2iLudtQ@mail.gmail.com>
In-Reply-To: <CAB_54W6VkOQ+Cf4gmwzJyQpjyK5MRqsGXkQD3fPa2UC2iLudtQ@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 8 Jul 2021 07:14:42 +0800
Message-ID: <CAD-N9QXZWA2rEYQV=E7ifqVTGA_ZLZJp=EA8GMLKufD7CMoyjQ@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: fix GPF in hwsim_new_edge_nl
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 2:55 AM Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Wed, 7 Jul 2021 at 12:11, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > On Wed, Jul 7, 2021 at 11:56 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > >
> > > Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
> > > must be present to fix GPF.
> >
> > I double-check the whole file, and there is only one similar issue
> > left in Line 421.
> >
>
> What about "hwsim_del_edge_nl()" line 483, I think it has the same issue?

Eric already submitted a patch [1] to fix this function and the patch
is already merged in the mainline.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0303b30375dff5351a79cc2c3c87dfa4fda29bed

>
> - Alex
