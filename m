Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C0A31537F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhBIQMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbhBIQLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:11:51 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D748C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 08:11:11 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id m76so18727398ybf.0
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 08:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zegi1/02lAykMG36iq8Jw9Il0zImHIJfyDBroQxzT2M=;
        b=sqC8wjIaT8efrpTZgvQF6OH2H/JOyGEp6aLFL4TeDPy21taW6BgEOOKvSyLlx8XESo
         JSkIevfXZVnAPkwvCua0eZXosbf3nKVcEvQEHc35A8uKwAIYVVyS4QKGHr5xtd1JjdBH
         nMwsC32hnED+UmZSaSxW82E4d56sut4futzQxXNT8WIF3qGwrt4oym6DI5OkK3g5C7Ep
         7fhj507DmlQ+/puUI+aue8SJwzovi0OVZkFaK2o+gE65LNyQ5wsr3OccxVLLuEhNWQiX
         kPIGYjnJdgE/NlhaJgQtURABQInDramUMsbWkVe5JxlucrJeJBxDLJd/xUjJH2p30OVo
         iAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zegi1/02lAykMG36iq8Jw9Il0zImHIJfyDBroQxzT2M=;
        b=PC+SCX3lWTzDlR0gghrnRP4eTND//T53CY/tmq7pgi8lIJs637naqitbs/uzYsvgjh
         Z1eHKzTqiO2A39Cjm7Bx0iTOI3L4xHc5oDcRBv3QUygttHEEsdb5Zn71e1RFmzU9UWSf
         peOTTIF9zd9TQly1t7oSTiEX7qdSMoS0KfC+I3RXFIuzwCcwrFh4kcH6KfjmkC9M0YmX
         +l9FOHHsHjUSU6OCN5jg70+l5vZOH5Rju7hvwHc1mmVC451UOHSfGx89pUdmCVuywTGU
         qxwaA2AIr7H12+MlIWuAI5Ko7VJETBZ2q+voeDrHFHQU3H4zy4LeQQOBZwig73qOHP8p
         mj2Q==
X-Gm-Message-State: AOAM5336Xcjt1EEKDVmlJgaLkSrQ0kZEYRQYaJ/gkvQ49guoafvXFeRG
        R3dlnt8Gq2XAdG7vm9VEigVsSjWpu2WVEK8iN+E=
X-Google-Smtp-Source: ABdhPJxnI03mzFQlAvFBIZuzPEZ9cm0K5GoTRLvuXb84Cjmbu1QxvniXPkopZAQGOdzR/E30j7alJJFpAVEvFb6OaMs=
X-Received: by 2002:a25:ba13:: with SMTP id t19mr34074743ybg.129.1612887070856;
 Tue, 09 Feb 2021 08:11:10 -0800 (PST)
MIME-Version: 1.0
References: <20210206050240.48410-1-saeed@kernel.org> <20210206050240.48410-2-saeed@kernel.org>
 <20210206181335.GA2959@horizon.localdomain> <ygnhtuqngebi.fsf@nvidia.com>
 <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <ygnho8gtgw2l.fsf@nvidia.com>
In-Reply-To: <ygnho8gtgw2l.fsf@nvidia.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 9 Feb 2021 18:10:59 +0200
Message-ID: <CAJ3xEMhjo6cYpW-A-0RXKVM52jPCzer_K0WOR64C7HMK8tuRew@mail.gmail.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source port
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 4:26 PM Vlad Buslov <vladbu@nvidia.com> wrote:
> On Mon 08 Feb 2021 at 22:22, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 8 Feb 2021 10:21:21 +0200 Vlad Buslov wrote:

> >> > These operations imply that 7.7.7.5 is configured on some interface on
> >> > the host. Most likely the VF representor itself, as that aids with ARP
> >> > resolution. Is that so?

> >> The tunnel endpoint IP address is configured on VF that is represented
> >> by enp8s0f0_0 representor in example rules. The VF is on host.

> > This is very confusing, are you saying that the 7.7.7.5 is configured
> > both on VF and VFrep? Could you provide a full picture of the config
> > with IP addresses and routing?

> No, tunnel IP is configured on VF. That particular VF is in host [..]

What's the motivation for that? isn't that introducing 3x slow down?
