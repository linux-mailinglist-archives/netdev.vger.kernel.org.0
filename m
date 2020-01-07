Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0BC132F08
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgAGTKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:10:22 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36964 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728540AbgAGTKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 14:10:22 -0500
Received: by mail-ed1-f66.google.com with SMTP id cy15so520671edb.4
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 11:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IIQ4JlPt9a7iYCz+uzk9y+EatUp6lxMzKRk020R+QDA=;
        b=TBDLsyWvHHBL7+GPXUkc0vmrhfsoSPCOF1GNhZGdQp7CNRBtwjZDGwYRrQ1rJqMSI+
         vpGIxGujii+4RXW6MAPOcaZ83m7LYDbr05+NPceh+IzWosSJri6ieRb9SU5TK0xJQU9S
         AcZAIVM1QsYErTEKyXk0PvX9LmIpNf+B8EepJizW+f+5RJcVXK3YwZflkjAfTsxF0kca
         U3siDS38bPWfvvIC1oDxxbBYUfW1VhLjr3rgtS86xJxZGCDmS3bQTpCtdj8Fiul6/0zL
         8zVTTuBCILQ6Vfk7wzJZb6d9gdVSfRTNb7SN0VhrVonV4KhgLWHvmLhwKTC1wQn13Yrv
         E8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IIQ4JlPt9a7iYCz+uzk9y+EatUp6lxMzKRk020R+QDA=;
        b=sA8t1og2bf27ZHBAGhzUcT7tDQLin5qKiAJknNXpwHJRL36JcYYlHSIPp+htGEVUIY
         kl+EIGx17AwMByKy9zdKtLEAmK8ygl5DL72D+a+22LCAdO/4Mc8CheybZbc7ghF/IpEk
         JsdArBw2MUhe2UXhYXWW8MVoN0WW2vvuU5kK/L68+li5Xjakk5krI7q7FNoi4/9HJk3W
         GxhmWsnXIGwDHDEkcbGgehh/YGiRgj73wT3Qo3hSKZIuEHZ4p4yiAaUslvFgSTxttpUZ
         TihmHvL/Y9gFquQOtvZ941Vuyt/ewMo2UgbfE8o4BmGXoc3507K+tAKBW8YgXkgCV7yC
         iSHQ==
X-Gm-Message-State: APjAAAX8+HUiEaS3O5rGHQrNOPYvRWO5IIrt6TwPwhFOEVvbU8lihBKB
        dfY9yC5MaBB+X0fhh6PQiFOVB4WOfaoKvKAlX6M=
X-Google-Smtp-Source: APXvYqyESbCxeRvEDA4LTwZwaxNCLmXJ5FFff02JEt3S1/PSSq1LgKQsOy039IhTL8pXWXDNG0iKFKVI/oao/gB0XzQ=
X-Received: by 2002:a05:6402:64a:: with SMTP id u10mr1495377edx.147.1578424220150;
 Tue, 07 Jan 2020 11:10:20 -0800 (PST)
MIME-Version: 1.0
References: <20191219205410.5961-1-cforno12@linux.vnet.ibm.com>
 <20191219205410.5961-2-cforno12@linux.vnet.ibm.com> <CA+FuTSeJ_3T5K3NrZnqcG6qadOHsoqKRt_ZMPM=fqUqJknDP_Q@mail.gmail.com>
 <87200f46-b04a-2741-dbe7-fa9260adfb79@linux.vnet.ibm.com>
In-Reply-To: <87200f46-b04a-2741-dbe7-fa9260adfb79@linux.vnet.ibm.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 7 Jan 2020 14:09:44 -0500
Message-ID: <CAF=yD-JehTcskgPO53k=SgLr1AxQ7Ymx5DcF7vHqoOvN-rsGFA@mail.gmail.com>
Subject: Re: [PATCH, net-next, v3, 1/2] ethtool: Factored out similar ethtool
 link settings for virtual devices to core
To:     Cristobal Forno <cforno12@linux.vnet.ibm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, haiyangz@microsoft.com,
        sthemmin@microsoft.com, Sasha Levin <sashal@kernel.org>,
        tlfalcon@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 12:46 PM Cristobal Forno
<cforno12@linux.vnet.ibm.com> wrote:
>
> Thanks for your suggestions Willlem. I have a question on one of your
> suggestions for the ethtool_virtdev_get_link_ksettings function below.

> >> +static int
> >> +ethtool_virtdev_get_link_ksettings(struct net_device *dev,
> >> +                                  struct ethtool_link_ksettings *cmd,
> >> +                                  u32 *speed, u8 *duplex)
> > No need to pass by reference, really. Indeed, the virtio_net caller
> > passes vi->speed and vi->duplex instead of &vi->speed and &vi->duplex.
> Agreed.
> >
> > More fundamentally, these three assignments are simple enough that I
> > don't think a helper actually simplifies anything here.
>
> Although the function is simple, it does achieve the goal of this
> version of the patch series which is to eliminate duplication of code
> throughout the virtual devices. I think it's best to leave it like this,
> but I am open to more suggestions.

As said, I don't think three assignments warrant the effort of adding
a new callback.
