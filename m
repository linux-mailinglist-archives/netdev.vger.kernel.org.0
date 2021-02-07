Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00F8312420
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 12:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhBGLxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 06:53:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229983AbhBGLxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 06:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612698731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aaAUCBAcr58sGZ9AaXinrBRzX6dEREqyHriRmijDonc=;
        b=cghm05XOlfvVR8vx8dnOAF5SmqwXhuKvBZhlAEQKPWwjynK44mTOXEzJpsHsOyP9YVh6Wa
        QUxFzKEhZvD5+xfb1ENOcI8DuWzU2YPpEV/KxJmBVf38aM5m3MLNBzBo5HKSEJA+QMadd5
        lupiJqLBVi7XyDMdDvoyezqh44LW6Qg=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-d1l9C0sWMY67vBnPKXsOrQ-1; Sun, 07 Feb 2021 06:52:09 -0500
X-MC-Unique: d1l9C0sWMY67vBnPKXsOrQ-1
Received: by mail-yb1-f200.google.com with SMTP id s7so13500769ybj.0
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 03:52:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aaAUCBAcr58sGZ9AaXinrBRzX6dEREqyHriRmijDonc=;
        b=fdHstQVwQZfB+5YeSjcy4OXCCI0MspxTob7PoySBrdur2j5U+LxQc9CVnLD8aGtuNz
         qJK+60EupS7v7/oMszY5RB8wDmWJeJ2skUj5bMFrxEdJjtIPA2OQYFVe93B2xeyljRoC
         JV/kvMcvN5NP4P0cFQ+T+ZlXNJnwvSKlK2txsCJ5uM7qBbo+1DxSTb60snDfgySisg6X
         cnr0SS8LVxcXUqWiAP57TkbgLE6dyoaOqHOvrcwbgcTb7dNMTUTvQavZEwJLDxpPsXf7
         TpJ8YFS3aUDSWUIzh/v/7nV8JMvVfo+FrkPd8CVM0b7br+AMrev5DUG3hgOSuj7PmhvJ
         YLyw==
X-Gm-Message-State: AOAM530ZAiJVAI0S2A9jMMk++vd8/9NbFJzTjQn6Uh8QZ1lC9sq2TjMF
        Krx7nTSO/62aHOvhmI1oWV6Zd3IhHbCUzfXcnSX34ZtqFlA3F9InWVgb6D/tN93TaPQCXExNcrx
        mc+YMoKIst5CnFschn66BO/X3S9iqwJCm
X-Received: by 2002:a5b:702:: with SMTP id g2mr5454695ybq.285.1612698729067;
        Sun, 07 Feb 2021 03:52:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTiyeV6aiIPFuN+mpHm4JqIlX95G+eKQuOh/PjvkfC9N2DO4W1jHGf3U24v2SBwyc0oHub2HP2D2M3LsQuZsk=
X-Received: by 2002:a5b:702:: with SMTP id g2mr5454678ybq.285.1612698728848;
 Sun, 07 Feb 2021 03:52:08 -0800 (PST)
MIME-Version: 1.0
References: <20210205163434.14D94C433ED@smtp.codeaurora.org>
 <20210206093537.0bfaf0db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210206194325.GA134674@lore-desk> <87r1ls5svl.fsf@codeaurora.org> <CAJ0CqmUkyKN_1MxSKejp90ONBtCTrsF1HUGRdh9+xNkdEjcwPg@mail.gmail.com>
In-Reply-To: <CAJ0CqmUkyKN_1MxSKejp90ONBtCTrsF1HUGRdh9+xNkdEjcwPg@mail.gmail.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 7 Feb 2021 12:51:58 +0100
Message-ID: <CAJ0CqmV2Qc6x_T6xQ1eBWc=9F67OWGUmH+nDLGfjSe7m0vW2bw@mail.gmail.com>
Subject: Re: pull-request: wireless-drivers-2021-02-05
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> >
>
> [...]
>
> >
> > So what's the plan? Is there going to be a followup patch? And should
> > that also go to v5.11 or can it wait v5.12?
> >
> > --
> > https://patchwork.kernel.org/project/linux-wireless/list/
> >
> > https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> >
>
> Hi Kalle,
>

Hi Kalle,

> I will post two followup patches later today. I think the issues are
> not harmful but it will be easier to post them to wireless-drivers
> tree, agree?
>

carefully reviewing the code, I do not think the second one is a real
issue, so I have only posted a fix to address Jakub's comment.

Regards,
Lorenzo


> Regards,
> Lorenzo

