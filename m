Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4C91B006B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 06:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgDTED3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 00:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgDTED3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 00:03:29 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88C3C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 21:03:28 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f19so9459528iog.5
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 21:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4yoSRAAq6ByLw23273SotPtzJ6Q/E4R2A/SjkRQDriw=;
        b=YXPZyWlH9RSSgnW5j4iBJYF58R50FLIv94XzPhsCL6y80GnIplmbo8VNoGUnNVX1Go
         q/RLTVUCtpjzdgWr8DqtYQXjJqiPUZKMk5EH11tX4xMI0VUtBICfyyWP7XoQfjzlWF1x
         MUSMdiYcJwUcGTW58A0DeGjHS6bbV16Z3Bvd/Xmr7O6ZqkIsgX+PEdjnwUAMeQSa33FV
         QcvCAKO550XbIg5IuuSpIrjH2CGQcHtR8QJlHR8l8UthPCOIM9xr82JA2t1b2UARa/NG
         RxNOCms/KgmbjQAnvWmhEQxJP9qeHQ13fnJkk5XxCF9nX1URKTmNnjQ1/xNK3AfTSfTZ
         eOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4yoSRAAq6ByLw23273SotPtzJ6Q/E4R2A/SjkRQDriw=;
        b=lgL06Ez//hsQTXIO0oG7nuvgbyTbi80XZbVbn5UckgLXPkAA5mHJ9an9UoM3Zq5f60
         oThAdP7YIzxNbqEQtC9xaqFw+gffTCua6KKLVp0rtCZqvsnApJztzZO1cb1hU1xOH9r6
         bAJIcCGSh/IrwP8zetp4X/5qGnFCCMU+TU3oKtbB2ptbWKv1K8I2+i5eAjo2h1YhqVck
         uelh1JSqj1hxnRfO8V+85zVk89QONU5G7kl25MbXlQDHkmR6TWDQqB9zVQm0+kW1HRsi
         TJ7k/Kb7az5LE4dkIRP70STy69Ny3HaxnMmhaphKFWrhdzrbcfj2SnY+PvxVDOyk6N5X
         iA9A==
X-Gm-Message-State: AGi0Pua6b9reu2+vosMFR4cmEwCqdB7NzTQSSmGcCeNcCU9ycD6fy4Tr
        JtPN3FmKdkYJfnLHPwM9H1Ehonf5bG7pACMEak4=
X-Google-Smtp-Source: APiQypJMt4EucyO5DjUhF21hrpwcxMWTMsFBN0PMmm/20bhWcTZAWzgIBuDBRsg9osY03LII7y3mPwdP13o0g/rMcKw=
X-Received: by 2002:a6b:8b05:: with SMTP id n5mr13906481iod.68.1587355407594;
 Sun, 19 Apr 2020 21:03:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200419161946.19984-1-dqfext@gmail.com> <20200419164251.GM836632@lunn.ch>
In-Reply-To: <20200419164251.GM836632@lunn.ch>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Mon, 20 Apr 2020 12:03:17 +0800
Message-ID: <CALW65jYmcZJoP_i5=bgeWpcibzOmEPne3mHyBngE5bTiOZreDw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: bridge: fix client roaming from DSA
 user port
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 12:42 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Apr 20, 2020 at 12:19:46AM +0800, DENG Qingfang wrote:
> > When a client roams from a DSA user port to a soft-bridged port (such as WiFi
> > interface), the left-over MAC entry in the switch HW is not deleted, causing
> > inconsistency between Linux fdb and the switch MAC table. As a result, the
> > client cannot talk to other hosts which are on that DSA user port until the
> > MAC entry expires.
> >
> > Solve this by notifying switchdev fdb to delete the leftover entry when an
> > entry is updated. Remove the added_by_user check in DSA
> >
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > ---
> > I tried this on mt7530 and mv88e6xxx, but only mt7530 works.
> > In previous discussion[1], Andrew Lunn said "try playing with auto learning
> > for the CPU port" but it didn't work on mv88e6xxx either
>
> Hi Deng
>
> We should probably first define how we expect moving MAC to work. Then
> we can make any core fixes, and driver fixes.
>
> For DSA, we have assumed that the software bridge and the hardware
> bridge are independent, each performs its own learning. Only static
> entries are kept in sync.
>
> How should this separate learning work for a MAC address which moves?

When a client moves from a hardware port (e.g. sw0p1) to a software port (wlan0)
or another hardware port that belongs to a different switch (sw1p1),
that MAC entry
in sw0's MAC table should be deleted, or replaced with the CPU port as
destination,
by DSA. Otherwise the client is unable to talk to other hosts on sw0 because sw0
still thinks the client is on sw0p1.

Discussion in OpenWrt GitHub:
https://github.com/openwrt/openwrt/pull/2798#issuecomment-602221971


>
>     Andrew
