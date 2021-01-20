Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A225E2FD819
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 19:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbhATSNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 13:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404186AbhATSIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:08:30 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05ECC061757
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 10:07:46 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id z1so20313718ybr.4
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 10:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3sKoHeHtvidllaw4i/r4rlPwbE9ZkoLOg4RSYBuxf78=;
        b=XZ4b+C3dAeSkchRsmcokaBD0/56DQD01qEcF3wExjR8Sr7o35aJZhbxCYxupa0DZp3
         0+1dQ7EWf6iKJjpU2m2ODJHZegJ4egTmKV7mp1apg4xoAS3RcFwjELXu/v7P/KT2923l
         2RgyrJmz2b7ugdKu4NWtHGMa8n1F9AM2rnVYHwUDS6iu+nTS5fJ/jei/yrohDCMBFdPA
         QWcTCKt+eUpIiy2apETOYWXNxbt8HaufXmPynxEB69hdgu+XZcbML9nmFuHGwD6risep
         KrlhHZwbNGzPVUAWWNyosiRUEsTmRDyXqXbMzC691UaiFdfuHPnYFmG5vAI0MdXWiACm
         FNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3sKoHeHtvidllaw4i/r4rlPwbE9ZkoLOg4RSYBuxf78=;
        b=I4uaqMktIeC36rdRGMC38hSALjRz/Rq5fjNbS6nEBj6ClCP5B4Qjm1Qr0OYRLRCHBP
         bOBhHpbIXFxGx6S7bW+X0HD22COvL3hR+dYifuozlxC08Mx0nV33IEYhFNKIWFDVwxDD
         mu2+ETiPbbEX5tS7hYmxTwvBx4vWIEd/KFOCkLvEDwQ+kfEZsTNqYp/8w5Hyd1kfdwF5
         mkAcYKizKyXCCjJZXKKwIBkRMV9OyDbAVBpYf6oAkLVGkZV0rr89DymxOel31fMeyZLh
         z6xxBO0w2S3lETopiaBsnEsdEdX7OkAewxqU9aR/9oee1HNfo3R7qUu1m0fl2AMuOP19
         Lv/w==
X-Gm-Message-State: AOAM531OfAb/sHA9RmGHKgoMT3FCe2yMsDW2TKgnzZSWkbqX87KSJriW
        nSZkNx2hHb/rOLZeT542NTP1GFKQ6c75rncJ96F9cQ==
X-Google-Smtp-Source: ABdhPJwCXTYFqijO5gKa0pNGUpgX5rKRMGliQHkaQvNeaYl1pQbry0OsqRYxQS2F94cDSGTYIKT4EcrKrf1TZ/0FakU=
X-Received: by 2002:a25:bb8f:: with SMTP id y15mr15115934ybg.139.1611166065958;
 Wed, 20 Jan 2021 10:07:45 -0800 (PST)
MIME-Version: 1.0
References: <20210120033455.4034611-1-weiwan@google.com> <20210120033455.4034611-4-weiwan@google.com>
 <e5714161-d8ca-d5dd-f12c-a6b206558cf9@gmail.com>
In-Reply-To: <e5714161-d8ca-d5dd-f12c-a6b206558cf9@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 20 Jan 2021 10:07:34 -0800
Message-ID: <CAEA6p_CspzSmX5tv5DjmopXBiEVpHyEduABjmSJsMrQyGbt8CQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 9:29 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 1/19/2021 7:34 PM, Wei Wang wrote:
> > This patch adds a new sysfs attribute to the network device class.
> > Said attribute provides a per-device control to enable/disable the
> > threaded mode for all the napi instances of the given network device.
> > User sets it to 1 or 0 to enable or disable threaded mode per device.
> > However, when user reads from this sysfs entry, it could return:
> >   1: means all napi instances belonging to this device have threaded
> > mode enabled.
> >   0: means all napi instances belonging to this device have threaded
> > mode disabled.
> >   -1: means the system fails to enable threaded mode for certain napi
> > instances when user requests to enable threaded mode. This happens
> > when the kthread fails to be created for certain napi instances.
> >
> > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Co-developed-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Wei Wang <weiwan@google.com>
>
> Can you document the new threaded sysfs attribute under
> Documentation/ABI/testing/sysfs-class-net?
OK. Will do.


> --
> Florian
