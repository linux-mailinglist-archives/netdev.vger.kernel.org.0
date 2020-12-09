Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95CC2D3E0F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgLIJCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgLIJCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:02:03 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ABEC061793;
        Wed,  9 Dec 2020 01:01:22 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id t6so599052plq.1;
        Wed, 09 Dec 2020 01:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4rpxUTzufCBNH+H443ssFvPa1VAOqL2A+09wFH4lKh0=;
        b=F3F81rp1cViSLFdGeG2bug5lkQlam3ZHbEAUyzrcWeM/gI0NEtEZZXHyrwJ3Ulkosn
         jVgolld4KbCsggi7SOrMYNXOscoEvfTxYUkfezHpuU4amZfIS65HvXWIpVQP8xMgLN6E
         fEn6sPNfqD/NtOaSKfSca+RuXE717Gys8spVQWWeFcTn/jhU7Nj9uzUPhixUToCSbCJv
         Y91q3KMRmXIA7dJ4hbGqrXzJaL7zP+jh6MB2kzsG9/TmdCleVtTlIzhCBwTKDmeCg0Ju
         wadrJaXDxo5p3XgwY255Uzh83K8UeWFbisbOXq1B8XvHK5FXWcRxf/TJZ0/mIe0m0vP5
         qhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4rpxUTzufCBNH+H443ssFvPa1VAOqL2A+09wFH4lKh0=;
        b=fFdAEivD6uUYF/AnSgoTuhOR3kDPFxOdhjlZocK5gXYEKjlvvYGDTJ2YH28eDXKEM7
         iKsEorzm/C/7ZvGeqznRBxeQts8Za6B9wN3Zvc3CWRVwq9pAv/jog6O0DkIED8GKOaJ9
         fttJwhqRMSKqfq9pqrzxiwWkb+LUBZTpKS8BJSOz/MiF4A20nERVrvr+lw2vy0G5ATNY
         ya1mpeq9YA9OUY7TAJ3SS7fsJaTtCqT6SOYOZy+TlZap7Rtm7sqlmH2sAZuOYwZYJ1qy
         wNYwMwfOey2EneHTZDE4MmyTe1B7esBXilleV2KYRqnc87Hj6FgGVoJtm5wHGF5CCltX
         GU9A==
X-Gm-Message-State: AOAM531afNa4VeBaLU8U48O2TPkJc6Zq1krqayWxLhMDCeCRMEe7Gq3m
        DeS7x/4amqvE8rncYFgBhQM62wVg+Yt19bv/pvUWub2zJSU=
X-Google-Smtp-Source: ABdhPJya6CPNDm6u6Q88+qkHSL+3Hd7CtAzbVrhtsbLS6TnqWcBtx5PjcO3KK3KTEpgU3UPBZzHxtgG9NTvvnyM9IwA=
X-Received: by 2002:a17:902:aa4b:b029:d8:f87e:1f3c with SMTP id
 c11-20020a170902aa4bb02900d8f87e1f3cmr1127419plr.23.1607504482489; Wed, 09
 Dec 2020 01:01:22 -0800 (PST)
MIME-Version: 1.0
References: <20201126063557.1283-1-ms@dev.tdt.de> <20201126063557.1283-5-ms@dev.tdt.de>
In-Reply-To: <20201126063557.1283-5-ms@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 9 Dec 2020 01:01:11 -0800
Message-ID: <CAJht_EMZqcPdE5n3Vp+jJa1sVk9+vbwd-Gbi8Xqy19bEdbNNuA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 4/5] net/x25: fix restart request/confirm handling
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 10:36 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> We have to take the actual link state into account to handle
> restart requests/confirms well.
>
> @@ -214,8 +241,6 @@ void x25_link_established(struct x25_neigh *nb)
>  {
>         switch (nb->state) {
>         case X25_LINK_STATE_0:
> -               nb->state = X25_LINK_STATE_2;
> -               break;
>         case X25_LINK_STATE_1:
>                 x25_transmit_restart_request(nb);
>                 nb->state = X25_LINK_STATE_2;

What is the reason for this change? Originally only the connecting
side will transmit a Restart Request; the connected side will not and
will only wait for the Restart Request to come. Now both sides will
transmit Restart Requests at the same time. I think we should better
avoid collision situations like this.
