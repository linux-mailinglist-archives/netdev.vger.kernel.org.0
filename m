Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40C82D2D64
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgLHOog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbgLHOof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:44:35 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA73C061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 06:43:55 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id r5so17792304eda.12
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 06:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XKvvprvUTbShWbGuH/h3LIL/Gm/FHou1qL3AWgbrPJM=;
        b=BRRXgpSCgNMiWAKuXVtUyKaWAgPH1Nom9mM4ghs29YKQCPH6YeOMrf9JRKglLrAeXH
         eIUNVZqewgIF6DV4IdGbtH1Z/Ih8fm2/KDzfPxCnYx59Z6REjZQb3j6afiwxg4Bu0hE/
         G25sv8psQmBGSOC0THO1dxqtVumRp7umX5gC8zVZCRvVK92kamVthCcCNElrjBLO7ScK
         X1LiD7zgoMQJIlWlZd0VoV8TAMSRF/kvVx/tE4UtMtSINEYg4jtX7xwEL4BEqWnU5Hef
         vcAn2iJpmAoOmsQyjWhgGdIv8z+o1EB33b22zpgyLICdm6RUmgDl3QoQdHqjk9U4tgrW
         fL9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XKvvprvUTbShWbGuH/h3LIL/Gm/FHou1qL3AWgbrPJM=;
        b=JQkp9Xj6EN/AeL/AsfPnJKQPALwAaRvo4NtmhAv2JfphWCHctADwqo3uqZFSRlKRba
         YaNpFtHKKNr+cRi1oFtXQburp9dWPtF894r+6jteFIRC9ha14DEj4C6Yko0RSBK+Za9Y
         3xwQXi2H0er47cM30siypx5pDFcgjKbwmmnytLR6v55Vp+iDQ1b/uqxRk2hu44+IP20x
         wqewthhuMEKQ0xZOhcD5lXmCQIMkeHGkeH7m47X9ss7EvJczWlpeoNp4Ny3c1h5OBH6q
         Cf+EHfYovKs5KBkLxEGWHVfBhPwyEWuGOYnNHOqXnswrKBg648R2pKTPLS++9qrJhrpi
         9rVQ==
X-Gm-Message-State: AOAM530nqygC2eY+v9rGT7YkIlvi1U0NhZTMNuTZfgGpTuSX+MfWP9GY
        A5pFz9vNWbBN/fBUPaBxb77wGM70AB/oEtsSN4lQ5Q==
X-Google-Smtp-Source: ABdhPJyeUp71DQPXJ9lWV1wwGeF7EDuN2XWoXRR8lib4rsWndsk7AYIuw9VxWbNSBvPmSQOH6ygFC88U+yk7iwWCYqc=
X-Received: by 2002:a05:6402:1597:: with SMTP id c23mr15427977edv.212.1607438634080;
 Tue, 08 Dec 2020 06:43:54 -0800 (PST)
MIME-Version: 1.0
References: <1607017240-10582-1-git-send-email-loic.poulain@linaro.org>
 <3a2ca2c269911de71df6dca2e981f7fe@codeaurora.org> <CAMZdPi-Nrus0JrHpjg02QaVwr0TKGU=p96BjXAtd4LALAvk2HQ@mail.gmail.com>
 <20201207121654.17fac0ef@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <c7be03c227efc3405f4c9cd14e52d061@codeaurora.org>
In-Reply-To: <c7be03c227efc3405f4c9cd14e52d061@codeaurora.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 8 Dec 2020 15:50:15 +0100
Message-ID: <CAMZdPi9S-dgH+=q_ZP3BM6QdDkGgJR6o0ndSrRMTBAJVT7EjkQ@mail.gmail.com>
Subject: Re: [PATCH] net: rmnet: Adjust virtual device MTU on real device capability
To:     subashab@codeaurora.org
Cc:     Jakub Kicinski <kuba@kernel.org>, stranche@codeaurora.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Subash,

On Tue, 8 Dec 2020 at 09:19, <subashab@codeaurora.org> wrote:
>
> >> What about just returning an error on NETDEV_PRECHANGEMTU notification
> >> to prevent real device MTU change while virtual rmnet devices are
> >> linked? Not sure there is a more proper and thread safe way to manager
> >> that otherwise.
> >
> > Can't you copy what vlan devices do?  That'd seem like a reasonable and
> > well tested precedent, no?
>
> Could you try this patch. I've tried addressing most of the conditions
> here.
> I haven't seen any issues with updating the MTU when rmnet devices are
> linked.

Thanks, could you submit it as new regular patch, I'll give you my tested-by.

Regards,
Loic
