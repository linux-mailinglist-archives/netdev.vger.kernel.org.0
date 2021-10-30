Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4942E4407CF
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 09:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhJ3HPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 03:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhJ3HPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 03:15:11 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0641C061570
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 00:12:41 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id 62so7862765iou.2
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 00:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lbih99bbeON+4PajSYKSgiIW7e/4Kt8F5lw/8h1fkfA=;
        b=4s0eDnWWDQk+HaQRB09lbdlJefl34Q0yu80okoI0GzYxeza8JrxXLlWfBhgMzuaDD6
         FpCQFfsZar6odEaUHC152SQnnXczyKhQXWp0Ur4EiktrJTJCTQsCw8rauMmjuCnoJLlB
         4Eb1lYolJD1gOrfFaYAop0CKa3Lzr8avuRDxyDqen4PIlHzCZkgFPYk7Qr6PSaZ+x4k4
         ponuQl9P9mziBDkQwCvn4B7Jhuj2sAyXvaXUmXyQ8H+qo4IO6Dj08BSn/twLo1Nhd3hJ
         JCSov40zmpRebUqv21WZFSoWaAddW+JAJZ2VwrHu47/B00rbP/cECawPn8XNmhlVjrC/
         llMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lbih99bbeON+4PajSYKSgiIW7e/4Kt8F5lw/8h1fkfA=;
        b=g7Ojc3IO02w8OcgkRW2vkZvT2pVf8dk1Ehb3zPhoJZVa68cnonxvJGoRKJpFPSGm1Q
         Z2ZMv/XyaMaZ3XAbeVLmwF0aqjhvbWef6ZVsQ1Wyb1fMTFTZxicn99qDfHrYr6ZiXGD3
         oqSFF2k65nOa6vvIyrZTREI11+psZMJ27f52xeNHmk4okP72VFDbK7yrd+BPdMwPjzB0
         ksDz/og1FZGAKTNq9wXTExKyWAcWfsucOvC6NOOvKnUT4NZvqtvw8vnzo11CDlsD6OL1
         jQgbc+vFi0NYr2fabsHKeuWzGEGDt3yepY8qWWD5vBNyTHpCNVyePyv96Adg9y6Nrtmi
         8y+Q==
X-Gm-Message-State: AOAM532msul9905gRkTZ/zuhgBJeX3aHZrUqOqoRusohBuescmSP3fBd
        PUn2cSpFT2BiSE89uX/SbcddPjqNUgIONLB9hSzp8n2h2tbwqaEf
X-Google-Smtp-Source: ABdhPJzg4MO2I/Oe9p+zJwr4OkGpIxCLM7xOkmzPPAiY4vZM57H50Qjx55YdFTK6AlkYWt6WrgjL8fCj3gHzspjv6hI=
X-Received: by 2002:a02:cb58:: with SMTP id k24mr11842557jap.59.1635577961277;
 Sat, 30 Oct 2021 00:12:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211029200742.19605-1-gerhard@engleder-embedded.com>
 <20211029200742.19605-4-gerhard@engleder-embedded.com> <20211029212730.4742445b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211029212730.4742445b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Sat, 30 Oct 2021 09:12:30 +0200
Message-ID: <CANr-f5yBuKd0D4xppyRm+PUmLredFuGA=dM_BSQ9VkSPTfX2Lw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/3] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 6:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 29 Oct 2021 22:07:42 +0200 Gerhard Engleder wrote:
> > The TSN endpoint Ethernet MAC is a FPGA based network device for
> > real-time communication.
> >
> > It is integrated as Ethernet controller with ethtool and PTP support.
> > For real-time communcation TC_SETUP_QDISC_TAPRIO is supported.
> >
> > Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>
> Looks like there is a lot of sparse warnings about endian.
> Please make sure it builds cleanly with W=1 C=1 and repost.

Thank you for the hint! I have not known sparse until now. I'm now using
sparse v0.6.4 and I got warnings about missing __iomem and fixed them.
But there were no endian warnings. I used the following command line:

make M=drivers/net/ethernet/engleder/ W=1 C=1

About endian: I have not considered endian so far, as this driver is used
only for x86 and arm64. Is that ok?

Gerhard
