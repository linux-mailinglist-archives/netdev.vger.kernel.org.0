Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6910D2E04BE
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 04:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgLVD1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 22:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgLVD1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 22:27:37 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A6CC061793
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 19:26:56 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id y19so28537929lfa.13
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 19:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3DuYh69TS1gggLotCn6ERQcD55cxnc82V29wS9VHcJs=;
        b=WdJDWBFZxJ1uV3TfY51XO/idtHjYEIQPxRxDXv6oiW9yM6d7H70ZTkUAINBtJEzQHa
         vJS8JXiyFU76yxGYTeo8/QLRtGgsyUzN5GQzt5Lbe6xnNEQ/POe9PIjNdi2qqsjzyxJp
         YragRbGE+erGUY/5wZsROIPbKDen6IicXMsxDkCD0q4jx2fuJSuQNqJ7Co3ZTAg4P6lC
         DU/t21uYsSJXoKdqxbf0r2x/2enmPhpop4f+5Q2rDUx+E96cspGugwxSjmvuA9RsLPM4
         l1E4GrOj7hrOFWKM2OU5O/97vCKDQg4M7Cch3HQ9jlaDypfKHokibzBoeIv7Gukxs5/Z
         OY0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3DuYh69TS1gggLotCn6ERQcD55cxnc82V29wS9VHcJs=;
        b=PV0SE88fJEb8Eb7jTgvoP4i3K0HXvpeP14TaJ8Fvu+S4EIVn/LakgTo7e0AHzV1SGt
         MvvAyQXAa2E4Ngmf7lEIc/nuBMCfnm5+4mTdSFCxzqZ8IHWEXdEjosMH85NtD8wvn9me
         ZR+ML9PFIh8Mpcv8GDunxvgYrirtZTFTM+aDnYmIb0dAxe3DcU37J0UoEE1lG7hpiSeQ
         LW3atq30cbi6DLUK2doH5BJQCs/jFAccT4VckjQy/U5qTD7psxCogaUHtEk5smqxk2Pt
         IWQ5nHg5XpBKEl9tbGglNSvo8drsdPZ4YG8tmS+P1RqyRrA2f9jLnR6i139cWe3vvXqD
         bJFQ==
X-Gm-Message-State: AOAM531ENvnAdv+NLGTvslrlW5tfaKS5lC1ekWHyJ9uaL4UezHxah+1M
        k2uN8h15hJJrF4EszuLkYK0HrDP0s23AVH4z3zJamw==
X-Google-Smtp-Source: ABdhPJyydnV50sAF97g4pkHQR5JB1TgCTbhsPNMp+KFO7FBqrNHPukIGxBtqgi+y+1PLSGMSyPHdJvYMBUw1iSbyhzs=
X-Received: by 2002:a2e:9053:: with SMTP id n19mr5967972ljg.283.1608607615185;
 Mon, 21 Dec 2020 19:26:55 -0800 (PST)
MIME-Version: 1.0
References: <20201216043335.2185278-1-apusaka@google.com> <20201216123317.v3.4.I215b0904cb68d68ac780a0c75c06f7d12e6147b7@changeid>
 <73E2D097-F8D4-4BFA-8EC1-C04B079F1BFC@holtmann.org>
In-Reply-To: <73E2D097-F8D4-4BFA-8EC1-C04B079F1BFC@holtmann.org>
From:   Archie Pusaka <apusaka@google.com>
Date:   Tue, 22 Dec 2020 11:26:44 +0800
Message-ID: <CAJQfnxHrvnsLRDHNFWAN9uPJmWiTpE6x4YAmgs77KO6QQBFW7w@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] Bluetooth: advmon offload MSFT handle controller reset
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Mon, 21 Dec 2020 at 17:12, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Archie,
>
> > When the controller is powered off, the registered advertising monitor
> > is removed from the controller. This patch handles the re-registration
> > of those monitors when the power is on.
> >
> > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> > Reviewed-by: Yun-Hao Chung <howardchung@google.com>
> >
> > ---
> >
> > (no changes since v1)
> >
> > net/bluetooth/msft.c | 79 +++++++++++++++++++++++++++++++++++++++++---
> > 1 file changed, 74 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> > index f5aa0e3b1b9b..7e33a85c3f1c 100644
> > --- a/net/bluetooth/msft.c
> > +++ b/net/bluetooth/msft.c
> > @@ -82,8 +82,15 @@ struct msft_data {
> >       struct list_head handle_map;
> >       __u16 pending_add_handle;
> >       __u16 pending_remove_handle;
> > +
> > +     struct {
> > +             u8 reregistering:1;
> > +     } flags;
> > };
>
> hmmm. Do you have bigger plans with this struct? I would just skip it.
>
This struct is also used in patch 5/5 to store the "enabled" status of
the filter.
Suspend/resume would need to enable/disable the filter, but it is not
yet implemented in this patch series.

Thanks,
Archie
