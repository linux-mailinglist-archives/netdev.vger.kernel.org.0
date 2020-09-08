Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A7B260DC9
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 10:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgIHIlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 04:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729564AbgIHIlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 04:41:09 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD35C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 01:41:08 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id y194so8567059vsc.4
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 01:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WRTNSAPWPCI5iQTaMgS28e7ZlEiCgAQz9GOhoqHIZ8c=;
        b=dEc205CC8/4AIZ8O0GSYBNX7L5fb8sHXU5jEhBMJScwpGfMVei74/KwzvqX0QW349P
         85kuC0osIJECUKgljnPnnZE1WvIGKtL4W7GLWDPrpsAuYBGgq2FlCI/dXKE93aCZ964w
         0o6rlIfF/xRlcygOaU6HJtORZ/LZE6mhwADhuasXUBA7Xnyx2QbTrPX8LkgidS500DbM
         WdP/dSQEtuy/mwGgtiyhhuWrLX6PZ+AOgTTGItFwMsOb7vXbC8Krk5JPQnsX4hMLtmCK
         0OVobASijrwcRYvu7tik2WhEQRnXeklYoPH0LJ5FDKX0m1WjW0SvXJqT+i3MMVnav8/0
         FI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WRTNSAPWPCI5iQTaMgS28e7ZlEiCgAQz9GOhoqHIZ8c=;
        b=jLSyxGBHmnb3+jK0LC8IaIjllzkzgVc2wIGeNB3Z29lX82+7Ol78qM23NEHi2laqan
         xj9aODn4JaKiot9UKs/TkSPHHm6UepY41Mg1+028603nBMG++wGcDHtGhgwOjaxqEUTi
         W8zgLyYW0brG0V778ZIzehQMyVcLWepo59uqhi+TeCkLhgCesZnHH6l8fjNf3NqAt+n0
         ilgikp9H823ok5RgejHppYasceqUkr/oeNuxO0OnLW1neypJdQF2ob/ZP0NC8J2Ms2m7
         ThisQ+SinC0lb3pUGNRcfxGiiLLRh3pxrFoMZ/KjRlGENImp14bgfR++xw+mpzfZnJUQ
         vSTQ==
X-Gm-Message-State: AOAM533kNIq0wUyVvuzhhCVznSG1tXKrR9NYjzX4hszwaYepoRneXoOm
        CNkKT+EHwYjrKnB9ZqK5SDAxWv0OiJR02A==
X-Google-Smtp-Source: ABdhPJx6Nj3JVN7T19nc38cDubpjYvp8zd3nLlHY30LOv9ho9oxV44/988OQYIkouq1pjJbO/bXJzQ==
X-Received: by 2002:a67:6952:: with SMTP id e79mr13500184vsc.11.1599554467181;
        Tue, 08 Sep 2020 01:41:07 -0700 (PDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id o198sm2858536vkd.43.2020.09.08.01.41.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 01:41:06 -0700 (PDT)
Received: by mail-vs1-f46.google.com with SMTP id q67so8566393vsd.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 01:41:06 -0700 (PDT)
X-Received: by 2002:a05:6102:150:: with SMTP id a16mr12591106vsr.99.1599554465860;
 Tue, 08 Sep 2020 01:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_EOu8GKvdTAeF_rHsaKu7iYOmW8C64bQA21bgKuiANE5Zw@mail.gmail.com>
 <CAJht_EP=g02o2ygihNo=EWd1OuL3HSjmhqgGiwUGrMde=urSUA@mail.gmail.com>
 <CA+FuTSdm35x9nA259JgOWcCWJto9MVMHGGgamPPsgnpsTmPO8g@mail.gmail.com> <CAJht_EPEqUMXNdQLL9d5OtzbZ92Jms7nSUR8bS+cw2Ah5mv6cQ@mail.gmail.com>
In-Reply-To: <CAJht_EPEqUMXNdQLL9d5OtzbZ92Jms7nSUR8bS+cw2Ah5mv6cQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Sep 2020 10:40:28 +0200
X-Gmail-Original-Message-ID: <CA+FuTSeJS22R2VYSzcEVvXiUhX79RYE0o3G6V3NKGzQ4UGaJQg@mail.gmail.com>
Message-ID: <CA+FuTSeJS22R2VYSzcEVvXiUhX79RYE0o3G6V3NKGzQ4UGaJQg@mail.gmail.com>
Subject: Re: Question about dev_validate_header used in af_packet.c
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 11:17 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Mon, Sep 7, 2020 at 2:06 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > The CAP_SYS_RAWIO exception indeed was requested to be able to
> > purposely test devices against bad inputs. The gmane link
> > unfortunately no longer works, but this was the discussion thread:
> > https://www.mail-archive.com/netdev@vger.kernel.org/msg99920.html
> >
> > It zeroes the packet up max_header_len to ensure that an unintentional
> > short packet will at least not result in reading undefined data. Now
> > that the dust has settled around the min_header_len/max_header_len
> > changes, maybe now is a good time to revisit removing that
> > CAP_SYS_RAWIO loophole.
>
> Thank you for your explanation! I can now understand the logic of
> dev_hard_header. Thanks!
>
> Do you mean we can now consider removing the ability to bypass the
> header_ops->validate check? That is what I am thinking about, too!
>
> I looked at the link you gave me. I see that Alan Cox wanted to keep
> the ability of intentionally feeding corrupt frames to drivers, to
> test whether drivers are able to handle incomplete headers. However, I
> think after we added the header validation in af_packet.c, drivers no
> longer need to ensure they can handle incomplete headers correctly
> (because this is already handled by us).

Which header validation are you referring to?

The intent is to bypass such validation to be able to test device
drivers. Note that removing that may cause someone's test to start
failing.

>  So there's no point in
> keeping the ability to test this, either.

I don't disagree in principle, but do note the failing tests. Bar any
strong reasons for change, I'd leave as is.
