Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0326A1EA19C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgFAKMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFAKMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:12:32 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78BCC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 03:12:31 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id c11so7432286ljn.2
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 03:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=thUU9LMNQNqJ/3GmQ16EoXMVJf5CkLqhql0lYuanUGk=;
        b=amnq/GGxdHy//AGs6u+F1FgzPxgQnojPGIQGHbk+AQruHpQaDrYTJZaRY+bh6ZtKWe
         spzap3yfU4I8dRlFnriatatfk/NqBBc+IzBG5dyX8AEtY8PmQkaYjc3BNPiz8XZTd8IT
         N13xJnO82nJHTMgVBCFplHFiH6ft+zYqn9B1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=thUU9LMNQNqJ/3GmQ16EoXMVJf5CkLqhql0lYuanUGk=;
        b=Rb3zHvMAfjV6ubXIDyyzRRiA7x8oPitgDnYMgCy4yW3ieCuHHjU/ArthfAkOzPbMrr
         3UWR4GkTQpKit43ZIuAfQCbCatiszHn/c2K8mHcaPkZ/JRUvhAB1q2aFGezEDtJggVT3
         Yal1q4akXOnK04MVTdn0bG3MpOnB3+4DSZ453MH6Dx2KzSrgvEgR/IJn9PjU5OXeMpE3
         AsKQh1WC3n6Roh2a5226FsgLIPjgqqVDkJYiolcCdDBBndkAk156fGbBDtspb6q4sQ9F
         Lf9Z0aa9QJMExT79tl9C7Co3QIxTs5YyJ7++LpqvDR9JUJ5NJmLPheGtf0qlPNFJmuGJ
         /6Hg==
X-Gm-Message-State: AOAM531aYVw07/pXNN5/7tMmaxrwYrBFgVIf+6XafducfasikJwW4T1a
        IvCmlM8WYgwUdR//+E/pOftiR4txl0IaVc21pZdZIw==
X-Google-Smtp-Source: ABdhPJzvtLHM8BjoJhrEO2cD74JrQXGOR06M2+qxOtI0z8iyEPL2wAMPEuJDF3/lIllQfyR4bmkH/da3bRQ/WbHt4bE=
X-Received: by 2002:a2e:7511:: with SMTP id q17mr850344ljc.38.1591006350231;
 Mon, 01 Jun 2020 03:12:30 -0700 (PDT)
MIME-Version: 1.0
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200601095838.GK2282@nanopsycho>
In-Reply-To: <20200601095838.GK2282@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 1 Jun 2020 15:42:18 +0530
Message-ID: <CAACQVJqfKV2n-mCEKgNkwa9G55p7LbSgOrhLabL-0uEHNc2NXw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and
 'allow_live_dev_reset' generic devlink params.
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 3:28 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Sun, May 31, 2020 at 09:03:39AM CEST, vasundhara-v.volam@broadcom.com wrote:
>
> [...]
>
> > Documentation/networking/devlink/bnxt.rst          |  4 ++
> > .../networking/devlink/devlink-params.rst          | 28 ++++++++++
> > drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
> > drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
> > drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
> > drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
> > drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
> > drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
> > include/net/devlink.h                              |  8 +++
> > net/core/devlink.c                                 | 10 ++++
>
> Could you please cc me to this patchset? use scripts/maintainers to get
> the cc list.
>
> It is also customary to cc people that replied to the previous patchset
> versions.
I am sorry. I copied you only on devlink patches. I will keep in mind
to copy on the entire patchset from next time.

Thanks.
>
>
> > 10 files changed, 175 insertions(+), 36 deletions(-)
> >
> >--
> >1.8.3.1
> >
