Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A122B7E86
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 14:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgKRNrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgKRNrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 08:47:06 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EEEC0613D4;
        Wed, 18 Nov 2020 05:47:06 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id j5so1000835plk.7;
        Wed, 18 Nov 2020 05:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X5ywAJ6hWYCp4zIQL5SFOchJJGT8G6Lmy+RBQsqA3eM=;
        b=KK8hcSyHN1x9BMssreZhy3CV4f3N0K2duxHa7JJjaYsyDEAF34B/nnKLYKQqbr7lGE
         tkeQ+RK9KMuuMWKoL/8kknp3z61Zoa2QrxO+dhdjfXy/YG8+EbhtEXbe3+bTbQaFC6Js
         8p/PHjCx2nSFto/dmiXlvUCzFdBHevcc9PAw3ahUZPPq+nlmMH+aSLyr5ZR/Vpws3g41
         tvXgEK7leAXh88s1wrIH5rEwvi7+Bx2UXM27ULBkk/7QF1fSn1CbmmSPr1NrYCWLS/hJ
         AZjjh+8TTRn6tBfyD3nm/lgXr3Fr5Z53c8oE3yweB5FQFj2OSlOYzB0mo0c4r9ICMEHX
         ALwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X5ywAJ6hWYCp4zIQL5SFOchJJGT8G6Lmy+RBQsqA3eM=;
        b=Sk5ixQZEZAv++v5QyTRqIPOwZgrIU5vSYrpi9hA8sXoRlQlDP79BXlWRy/ztdB+urp
         msS7WMzjWbLAxLogBJnUpi3Xu6sD/xPOwuVI52Szi63QIZgEEU3qF6/Ai0bM+S8sO1Rv
         5zJWgEBYmxI0WuPsYY87/iDWAcsJOhGPhzHJGAAE2Ui5iXLjrIFBFl3XUHSjEAqwjaMP
         MViPsURMWer6WIa601I3KnT6ZivvcrtuCSqGQmSmmfzArNG/UxTj3Q3MtrCLvQ23f1Yq
         Lijb8EpGGDs7vDq++Ent/vGePRvC4j7orFVynwSimjDEz5dYtdLNRxCKDmalspUpe9Zk
         MKqQ==
X-Gm-Message-State: AOAM530H0bLM+ZR2cFVflsVW05NDRGBRA0CfsDBQr5ZDBuFlTAIUFcUU
        X+lppl0DZif1m8cq7CEmLVNZ3L+rFOs+l8dP5IQ=
X-Google-Smtp-Source: ABdhPJxogQlvAx94fQeHfJV/ZRIN+bHPnokd5qtAAE39CaXWWnsSyC8aguiBZNVGXzoy6XMXjiko7djaaLkrnQI+2gg=
X-Received: by 2002:a17:90a:4884:: with SMTP id b4mr97647pjh.198.1605707225568;
 Wed, 18 Nov 2020 05:47:05 -0800 (PST)
MIME-Version: 1.0
References: <20201116135522.21791-1-ms@dev.tdt.de> <20201116135522.21791-6-ms@dev.tdt.de>
 <CAJht_EM-ic4-jtN7e9F6zcJgG3OTw_ePXiiH1i54M+Sc8zq6bg@mail.gmail.com>
 <f3ab8d522b2bcd96506352656a1ef513@dev.tdt.de> <CAJht_EPN=hXsGLsCSxj1bB8yTYNOe=yUzwtrtnMzSybiWhL-9Q@mail.gmail.com>
 <c0c2cedad399b12d152d2610748985fc@dev.tdt.de> <CAJht_EO=G94_xoCupr_7Tt_-kjYxZVfs2n4CTa14mXtu7oYMjg@mail.gmail.com>
 <c60fe64ff67e244bbe9971cfa08713db@dev.tdt.de> <CAJht_EOSZRV9uBcRYq6OBLwFOX7uE9Nox+sFv-U0SXRkLaNBrQ@mail.gmail.com>
In-Reply-To: <CAJht_EOSZRV9uBcRYq6OBLwFOX7uE9Nox+sFv-U0SXRkLaNBrQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 18 Nov 2020 05:46:54 -0800
Message-ID: <CAJht_EMd5iKmdvePgYzWYXnG=5LxQopStzz_Lk9uNSkRyrudqw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/6] net/lapb: support netdev events
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

On Wed, Nov 18, 2020 at 5:03 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Wed, Nov 18, 2020 at 12:49 AM Martin Schiller <ms@dev.tdt.de> wrote:
> >
> > I also have a patch here that implements an "on demand" link feature,
> > which we used for ISDN dialing connections.
> > As ISDN is de facto dead, this is not relevant anymore. But if we want
> > such kind of feature, I think we need to stay with the method to control
> > L2 link state from L3.
>
> I see. Hmm...
>
> I guess for ISDN, the current code (before this patch series) is the
> best. We only establish the connection when L3 has packets to send.
>
> Can we do this? We let L2 handle all device-up / device-down /
> carrier-up / carrier-down events. And when L3 has some packets to send
> but it still finds the L2 link is not up, it will then instruct L2 to
> connect.
>
> This way we may be able to both keep the logic simple and still keep
> L3 compatible with ISDN.

Another solution might be letting ISDN automatically connect when it
receives the first packet from L3. This way we can still free L3 from
all handlings of L2 connections.
