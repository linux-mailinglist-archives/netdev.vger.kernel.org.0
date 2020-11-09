Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957C02AB2A1
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgKIIne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgKIIne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 03:43:34 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600B0C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 00:43:34 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id k9so7813853edo.5
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 00:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=azGRjNxM3lY1Vx897AZ7Db+EDWbByWWjOWp7CFeR+tc=;
        b=zemGUMSn1XpFtqAA4tWRawE4tJhaUN1wRVHoIevxzRgBHTJN1zJ52ghXq49lutp3KE
         lHdFXXlUe/pkRZe0A4A9XxCCO3gDKvgXxhXCRBUwIaUSJyX52hnd74R7cMy4e9yEaFH3
         EAfLslPrJwP06dzQ7YHdzXXn2wHGxMQEdQBANszlY+KTqI1W3yX4rBwfSOApezkszu9c
         BCQStudBncnkJAiNSp19y9DDxhTfBcnoCdOO918LDTLVAhwiPfkKwyCwQb78TH82XJ31
         cDpS/MX5cGjC1M3TXKOagGO1/S0T4+QXjnJEeXQFskN/Rnfzd1jrOyHhiL/MuSR6cAVH
         TMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=azGRjNxM3lY1Vx897AZ7Db+EDWbByWWjOWp7CFeR+tc=;
        b=c/gkuj2jxbqMWvW8yHBWNvPTkAIKnos5gWtDdXytTRTa7IT0RHKKUnG5fwLFAZ/LJq
         5gJL4nyGZPPniNOjgFeipVPMrm/v3Nov/0EP0tvHhaZdDDyM/v/X3l84Lv2eEwM88uDP
         QTYME7odMddL2oU+JLq5zo1Go3SMxtUSqI79qZqSrlonpdPLsImXa2cLRCtKtcYvd5l0
         pt2m4pk4Az4nWRwtYIjUQ1RSJ1xWeFNTbRsbt8B3pBSghmf3nqB57CCMX1KWc7saQ/YB
         Btr8Zdvlvr8Vu7Pah3+SJAiaLlqRXWanql3BNNsvUA0UU86ROUo8lxSHtZmV4QSJaADF
         I5cQ==
X-Gm-Message-State: AOAM530arWAGIjqVWkDvo3sJp0g30X/wDkia92lpEwbVEpEA1qoMsj6K
        Pv3NVJhhYn62HKRr31H3AOoo+PxWHR52zpOqVqlsGg==
X-Google-Smtp-Source: ABdhPJy4tGNMIMD9tp0rszvsFtmtMtXk5BNA7HUfENDdRDvSOifXim1bgJhlxuhtWzhxSxGvaJxL+Her45Sbatw6qkw=
X-Received: by 2002:a50:a105:: with SMTP id 5mr6480704edj.165.1604911412947;
 Mon, 09 Nov 2020 00:43:32 -0800 (PST)
MIME-Version: 1.0
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org> <20201107162640.357a2b6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107162640.357a2b6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 9 Nov 2020 09:49:24 +0100
Message-ID: <CAMZdPi-5Qp7jOHDZLZoWKJ4zwU6Sa9ULAts0eY6ObCu91Awx+w@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] net: qrtr: Add distant node support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        cjhuang@codeaurora.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Sun, 8 Nov 2020 at 01:26, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  6 Nov 2020 18:33:25 +0100 Loic Poulain wrote:
> > QRTR protocol allows a node to communicate with an other non-immediate
> > node via an intermdediate immediate node acting as a 'bridge':
> >
> > node-0 <=> node-1 <=> node-2
> >
> > This is currently not supported in this upstream version and this
> > series aim to fix that.
> >
> > This series is V2 because changes 1, 2 and 3 have already been submitted
> > separately on LKML.
>
> Looks like patch 1 is a bug fix and patches 2-5 add a new feature.
> Is that correct?

That's correct, though strictly speaking 2-5 are also bug fix since remote node
communication is supposed to be supported in QRTR to be compatible with
other implementations (downstream or private implementations).

> If so first one needs to go to net and then onto 5.10, and the rest
> to net-next for 5.11.

I'm can split that into two series so that you can dispatch them at
your convenience.

Regards,
Loic
