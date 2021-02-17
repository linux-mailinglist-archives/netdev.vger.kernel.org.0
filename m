Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201EE31D7CD
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 12:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhBQLB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 06:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbhBQLB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 06:01:57 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BF0C061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 03:01:17 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id u4so15495832ljh.6
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 03:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s49hSKyEz1i92CpeTBAunKs7ljY4dzNn7VojQkhT6ng=;
        b=J0ECRXZeqLsbJr9QqxkcIFjnVTneSZgzJptt2km3aU17mpBJYgahP4/NIvCAL3UUxZ
         nd9FiOSyGFCo35WNxsl5ZA9ZfcWrztGFyIAhWqy/ILMi1Y3PC+R6OU6aU3xMTPpPm96r
         i87Ck2KLG7YwHsftp5SQIYxqhkcTM4H0WfCS2FYpfs6dGO3NctnmxfD9Zqgqa088o3+W
         r45kPTPWenMdKnMsoKWsJ3QJfAqnj0VkH14nUGV9b3x0x9hpGRCZggSEtmdp+7cqewpG
         2Rb3TdGs2nymfa8AuEe6SpRZKk+4Zt4mZ+BYIbBWekrUZv9eI5tjEPbcFnAOA0duYR4y
         XZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s49hSKyEz1i92CpeTBAunKs7ljY4dzNn7VojQkhT6ng=;
        b=Rq6nmzzfF3htjM9ABFDv5jpAQghP3y8D41UDox0WJFD5IpKVWHzOKww+iJss8hlJkQ
         8MFaqAwZ8pB+iFx1IHWQtmowQfiMUy5dsgz6LP1yNbusce4UpgUb3XghCIun1Ti0/CuN
         QzQuu6ai1sh1uS1mU+c5GBLtCKt1SwHHU0gVDZD89fQuuKDKanFpVCMWAybVn2mR5rj2
         EwHc7PNs2rNoXqDOD24drgJdDq6Nx3x6D/RnlybxjcTh7fOSMTfU4zEEHg7ATaoARUy/
         ieR2QtD1Q6zVo4nRIdZcTDDYCMvVgLJDX9Z1vpnWFPIIoInrufPVVMz+nGleZ1+B6Hbo
         h49A==
X-Gm-Message-State: AOAM532LsZkRqSh2xJTyLtlVeAJkIY46bVK8N6MLvwxDfzxE4qHBZIHE
        DLlD4vF5KDRfn0tUbQVuhqXcD6sXEC2E82oyJ2VuJQ==
X-Google-Smtp-Source: ABdhPJzM5NXo5Urq010RcaKvXmLBowSm24Ucpv8kKHv26dvKe9kPfMuCHXbdzIZVICU3zMM01WTaHL1Eoonaw89YI5Q=
X-Received: by 2002:a2e:9041:: with SMTP id n1mr12452444ljg.273.1613559675701;
 Wed, 17 Feb 2021 03:01:15 -0800 (PST)
MIME-Version: 1.0
References: <20210217062139.7893-1-dqfext@gmail.com> <20210217062139.7893-2-dqfext@gmail.com>
 <e395ad31-9aeb-0afe-7058-103c6dce942d@gmail.com>
In-Reply-To: <e395ad31-9aeb-0afe-7058-103c6dce942d@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 17 Feb 2021 12:01:04 +0100
Message-ID: <CACRpkdYQthFgjwVzHyK3DeYUOdcYyWmdjDPG=Rf9B3VrJ12Rzg@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] net: dsa: add Realtek RTL8366S switch tag
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 8:08 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:

> > +#define RTL8366S_HDR_LEN     4
> > +#define RTL8366S_ETHERTYPE   0x8899
>
> I found this protocol referenced as Realtek Remote Control Protocol (RRCP)
> and it seems to be used by few Realtek chips. Not sure whether this
> protocol is officially registered. If yes, then it should be added to
> the list of ethernet protocol id's in include/uapi/linux/if_ether.h.
> If not, then it may be better to define it using the usual naming
> scheme as ETH_P_RRCP in realtek-smi-core.h.

It's actually quite annoying, Realtek use type 0x8899 for all their
custom stuff, including RRCP and internal DSA tagging inside
switches, which are two completely different use cases.

When I expose raw DSA frames to wireshark it identifies it
as "Realtek RRCP" and then naturally cannot decode the
frames since this is not RRCP but another protocol identified
by the same ethertype.

Inside DSA it works as we explicitly asks tells the kernel using the
tagging code in net/dsa/tag_rtl4_a.c that this is the DSA version
of ethertype 0x8899 and it then goes to dissect the actual
4 bytes tag.

There are at least four protocols out there using ethertype 0x8899.

Yours,
Linus Walleij
