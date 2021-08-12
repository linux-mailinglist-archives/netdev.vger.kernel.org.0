Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986153E9DFF
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 07:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhHLFhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 01:37:47 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:57812
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234339AbhHLFhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 01:37:46 -0400
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 5158D40658
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 05:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628746641;
        bh=lLP3PSQ1cyi3LClcOEB98n6hc5vl9XavCsPRRMlIR60=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=R/RVHvfx3j2arhmzpcvWWxcXNI2ydCP9BDS/LtZZmKrxVoZXWtHyiVTqf2uYiPnld
         HotHtC7ru4TYDVkW2GHB8vqDvsJDGjfTv0ENwsVjxAX4TucRBH2LcqtR+kG69HqORO
         OrAQd85Ua/oQeRFj3t3B+DexoWDl8afbfSZklu/VDlXRUj18OjC8nbZS7oFXEL86D8
         ByTAhpKrRVJGL/dID9b+RqlYHy3tqpdfRXbIZvNgR2bv1qbtdcYQvOM7vKDFA97FQ3
         9wUE98cWBvGiqNgUApg+zu5I4BxQunGcF0fT7oGu+DStqAroaR5f3O/uzgjIlmOWee
         TS9h9+jhQ78Yg==
Received: by mail-oi1-f199.google.com with SMTP id o185-20020acaf0c20000b029025cacdf2ac0so2474095oih.9
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 22:37:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lLP3PSQ1cyi3LClcOEB98n6hc5vl9XavCsPRRMlIR60=;
        b=GY7Tqz2rc05CflADYsV8V/7qNx3ZsBalHY7lSPQ8DWu02+qdiByJ0+PnEgFsJcoBjt
         2X0ppM4Ha52ZhgH/e+M7vYBFD+oxQZmU0mRhWCuvA9JwlRfWhmeTV+eZd6Q2IZJd7bSR
         TJOzoM2ZYwMrscEj9RDI18b2VVPVSeJtMz6QKIyLU6Jqp1Ft7D1nLGNfihmy+CMF6bVK
         1SrPlJARI/HA+AS9EpWLChsQK0Us31ewcTWnoKYf0VaCyafDqOzIokkXGEdv5XurF0hh
         AwLlY/A/cDY+fpeXUhxxY/F3E1xxor/pyGc0q96zLm4AGExiBlB1coEAOdZKk3Mfdwbr
         cncg==
X-Gm-Message-State: AOAM533PwTOSHZLK0kw894HNzH0UF10CeXCuzte1dsqjbffaDaGpMqSm
        9UeY5H1U3+5RCw7Au87GMTGY6kKseoGoywV3rlO6NOMF1PzZuni4QHxoPStE80mtdPeeC1/Yye0
        r2auHSsSrFG3qJTAhWo4LERAukQcJuoUW+eeFQsdtVadpscgWQA==
X-Received: by 2002:aca:34c4:: with SMTP id b187mr2051542oia.139.1628746640188;
        Wed, 11 Aug 2021 22:37:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO0aGh6aGuBGFSPUJ1KmdjnWuWBwT62mHXtoJD+Vh2YxX7I5H1TaPq6pL5kWcNm5a7qcE/GBEKFY/LYmWnVGY=
X-Received: by 2002:aca:34c4:: with SMTP id b187mr2051524oia.139.1628746639935;
 Wed, 11 Aug 2021 22:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210812042305.277642-1-koba.ko@canonical.com> <4374EE78-86B9-43BF-B387-8C51C15CB943@holtmann.org>
In-Reply-To: <4374EE78-86B9-43BF-B387-8C51C15CB943@holtmann.org>
From:   Koba Ko <koba.ko@canonical.com>
Date:   Thu, 12 Aug 2021 13:37:09 +0800
Message-ID: <CAJB-X+W22r8sDhKj0LwtLCu9h2f1f=mX65nQtAN9nr=UujjDSw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: msft: add a bluetooth parameter, msft_enable
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Archie Pusaka <apusaka@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 1:29 PM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Koba,
>
> > With Intel AC9560, follow this scenario and can't turn on bt since.
> > 1. turn off BT
> > 2. then suspend&resume multiple times
> > 3. turn on BT
> >
> > Get this error message after turn on bt.
> > [ 877.194032] Bluetooth: hci0: urb 0000000061b9a002 failed to resubmit (113)
> > [ 886.941327] Bluetooth: hci0: Failed to read MSFT supported features (-110)
> >
> > Remove msft from compilation would be helpful.
> > Turn off msft would be also helpful.
> >
> > Because msft is enabled as default and can't turn off without
> > compliation,
> > Introduce a bluetooth parameter, msft_enable, to control.
> >
> > Signed-off-by: Koba Ko <koba.ko@canonical.com>
> > ---
> > include/net/bluetooth/hci_core.h |  1 +
> > net/bluetooth/hci_core.c         | 16 ++++++++++++++++
> > net/bluetooth/msft.c             | 30 +++++++++++++++++++++++++++++-
> > 3 files changed, 46 insertions(+), 1 deletion(-)
>
> NAK.
>
> This is for the Intel guys to figure out. Otherwise I am going to disable MSFT extension for AC9560 completely. What is your hw_variant for that hardware?
Would you please guide to dump hw_variant? thanks
>
> Regards
>
> Marcel
>
