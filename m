Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CA72D4B77
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 21:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbgLIUR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 15:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388353AbgLIUR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 15:17:27 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2672CC0613CF;
        Wed,  9 Dec 2020 12:16:47 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c79so1808353pfc.2;
        Wed, 09 Dec 2020 12:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Gb52rLFb1PoO6DXkpk5zljkzOIofHR52NXCKENCFa4=;
        b=kehc2ECdte20dcviA2sV5xZ+n4UnvafAMyDlCabErXP1uJWSICsH9t++c5icoDpNi9
         6rZYh6ltHdQLf9Z6mllOQPSis08jMwvjqG0QjbvByKrqo8TcDZJ2XNbLtGNS5cQnniRi
         /atttUalbx6kjjwpQN4oePMgYOjEd5LpRKl84ht2vGfJJ5dRs3s4I1HeEXpdw+EHzWqR
         qfGOGSILO+68813rMDjYYMziIlDf1u0T83ZarRi9dGEGvbAyn4yPvbt9aYo33trQtowm
         VSo+R5xDwBzItoPz4G+0/LJYePQjW0TSk1d6RZN9khZD2/LOySBAAsbbRWiL5JwscLpM
         cJKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Gb52rLFb1PoO6DXkpk5zljkzOIofHR52NXCKENCFa4=;
        b=EnFVIpRczONx4Uj2H0mqBoRiv/SrWCirGqPLGE6jPH595xrUCtcYQKC0VKMA0vWGcH
         yakUBYpIseb8/4WnSRqZFn4lzhdD4jbb2BYlXQgZPezU2AVqgM28qAUT+Rn+lAA/63o6
         EIFrgDfY+K3fyngyamLWOnlZU9mT82MXQOcUf3T7qg8Rh/5qBjqPQcStRdMNmGoR3+M6
         5eC101epyiW2YyQxfgK8wUDAYeIIOqoNEWWlPSCAj3062K3tiAGo8kixjal076F3cEkk
         BM9JuVSTjav8asU6LHb2nXemFjd0ZbLsjNl4C5c/8QkAtyc88TGbp1fZNhRmmOUakL/t
         v9Kg==
X-Gm-Message-State: AOAM530ZiPdbGBoAUjtRAAQO7PVa7NC9TxXMdRDIulTV6b7RBEqspe+Z
        4RBEoQvbQt1rRDXHLFl4hOsyPVyWI44dxyUdJdg=
X-Google-Smtp-Source: ABdhPJz/aOF4GeS39n75c1q1nNxSyZ9i0t1HDZUpqvPZbEXooO6+WxHvYOXA1hAynAphTeORR8rwu4IuMtheOB4YnoM=
X-Received: by 2002:a17:90b:1987:: with SMTP id mv7mr3776215pjb.66.1607545006673;
 Wed, 09 Dec 2020 12:16:46 -0800 (PST)
MIME-Version: 1.0
References: <20201209081604.464084-1-xie.he.0141@gmail.com>
 <7aed2f12bd42013e2d975280a3242136@dev.tdt.de> <dde53213f7e297690e054d01d815957f@dev.tdt.de>
In-Reply-To: <dde53213f7e297690e054d01d815957f@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 9 Dec 2020 12:16:35 -0800
Message-ID: <CAJht_EPk4uzA+QeL0_nHBhNoaro48ieF1vTwxQihk5_D66GTEA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: x25: Fix handling of Restart Request and
 Restart Confirmation
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 2:31 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> >> 1. When the x25 module gets loaded, layer 2 may already be running and
> >> connected. In this case, although we are in X25_LINK_STATE_0, we still
> >> need to handle the Restart Request received, rather than ignore it.
> >
> > Hmm... I've never loaded the X.25 module after the interface is UP, but
> > in this case we really have to fix it.
> >
>
> This seems to be a regression caused by moving the Layer2 link handling
> into the lapb driver, which wasn't intended in my original patchset.
>
> I also have another patch on my todo list which aims orphan packet
> handling in the x25_receive_data() function. Maybe it is better to catch
> the whole thing there.

OK..

Currently it's not clear to me what your future patches would be.
Maybe we can first have this patch applied? Because based on the
current code I think this patch is necessary. When you are ready to
submit your patches, you can replace my code and we can discuss
further.
