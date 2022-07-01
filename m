Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41005639A0
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiGATTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiGATTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:19:16 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BED10FC8;
        Fri,  1 Jul 2022 12:19:15 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k7so4494287wrc.12;
        Fri, 01 Jul 2022 12:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+btLS9OBdLthxpmSH7aEjgmKx+CA2SmFIV+Z3Abyo6M=;
        b=QznS/Ul5921zyvr7SGAdAjWJPyFl2OnDgcIfaLZLbgOj5P3FmBayBT22F3dC904OxK
         2LjBN65VV3yNIjbw5IVk6bLyPQF3quWXEWK4rthqK8dAUMoF7eJGlDt3Na9FpJ03fuAD
         sbLkUpDNaVWpQbRENJBqM0Lyc4wPR6XeqsVqauKwh2OFzPBYXIee1Td2qPbLEiQBnAXd
         WOI51HHCnxygVHYRg99A4rnOoakY7Hkrbl/Y+I/TJ5Sl7i60mprbdEw7lKwTG6kiSNA2
         kBfY29HpCxd/Dv8acARD/L4jA36kimazdLCiJZZ0NXdhUx/3tkX5WY9eN6l/YFeW4x8s
         7SUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+btLS9OBdLthxpmSH7aEjgmKx+CA2SmFIV+Z3Abyo6M=;
        b=kKw2HFtwfWHOYrJ/nO25TYGa8Fo8kT3dx+3qIZnR//TzBvVhrqIv4eXMjgeENT4NzX
         rmuOrRRYLVMDWMZtV7/6PaT3m+RDteTiQfmfxD5DbRobMq/yngrPC9c53b2GB0eGl1gP
         FgV+/2BXWvNUOADrtD4npbx9XJ2KFHYPB7uUrTv09IfyuP7QhSRwY+4LkGNuP1dujee7
         7eHzDRVIbzrycIjGV9HLeL1sZriEimZ5BggvtBlHmtamZfLh5EvwmF5SoxCWgnnRWqj7
         qU8wScztid8tMQl7JbhlAhnLUqe++Npidf99xw/eG9fRg1CCKx7wHUKRifwsON0jYLjB
         fIhw==
X-Gm-Message-State: AJIora/C8NBC2VqHOKSJQwVH1ni1E6sn8kj1mTr64jRizHLyFqjeWrnB
        HgusrZ7uzkzVF/XKNSDH3/UjP2fQj53dwt9uTLnW1szifIE=
X-Google-Smtp-Source: AGRyM1tR5cJUPzpwFIGhhOg00Q2nOLkIS0YH+W4KE5ofW3LFFWMYxDBQyfdtKh5qXZUHPJ1X2A4wY5bcHurN8K6O4Zo=
X-Received: by 2002:a05:6000:12d0:b0:21b:a248:9a2e with SMTP id
 l16-20020a05600012d000b0021ba2489a2emr15868624wrx.437.1656703154192; Fri, 01
 Jul 2022 12:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder> <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder> <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <Yr8oPba83rpJE3GV@shredder>
In-Reply-To: <Yr8oPba83rpJE3GV@shredder>
From:   Hans S <schultz.hans@gmail.com>
Date:   Fri, 1 Jul 2022 21:17:27 +0200
Message-ID: <CAKUejP4_05E0hfFp-ceXLgPuid=MwrAoHyQ-nYE3qx3Tisb4uA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 7:00 PM Ido Schimmel <idosch@nvidia.com> wrote:
>
> On Fri, Jul 01, 2022 at 06:07:10PM +0200, Hans S wrote:
> > There is several issues when learning is turned off with the mv88e6xxx driver:
>
> Please don't top-post...

Sorry, I am using gmails own web interface for a short while now as my
other options are not supported anymore by Google (not secure apps)

>
> >
> > Mac-Auth requires learning turned on, otherwise there will be no miss
> > violation interrupts afair.
> > Refreshing of ATU entries does not work with learning turn off, as the
> > PAV is set to zero when learning is turned off.
> > This then further eliminates the use of the HoldAt1 feature and
> > age-out interrupts.
> >
> > With dynamic ATU entries (an upcoming patch set), an authorized unit
> > gets a dynamic ATU entry, and if it goes quiet for 5 minutes, it's
> > entry will age out and thus get removed.
> > That also solves the port relocation issue as if a device relocates to
> > another port it will be able to get access again after 5 minutes.
>
> You assume I'm familiar with mv88e6xxx, when in fact I'm not. Here is
> what I think you are saying:
>
> 1. When a port is locked and a packet is received with a SA that is not
> in the FDB, it will only generate a miss violation if learning is
> enabled. In which case, you will notify the bridge driver about this
> entry as externally learned and locked entry.

Right.

> 2. When a port is locked and a packet is received with a SA that matches
> a different port, it will be dropped regardless if learning is enabled
> or not.

I would think so.

> 3. From the above I conclude that the HW will not auto-populate its FDB
> when a port is locked.

Right, and it should not as the locked port feature is basically CPU
controlled learning.
(yes it is an irony to have CPU controlled learning and learning
turned on, but that is just how it is with the mv88e6xxx series :-) )

> 4. FDB entries that point to a port that does not have learning enabled
> are not subject to ageing (why?).

Sorry if I said so. Dynamic ATU entries will age I am sure, but they
will not refresh unless there is a match between the ingress port and
the Port Association Vector (PAV).
But an age out violation will not occur, and the HoldAt1 (entries age
from 7 -> 0) feature will not work either as it is related to the
refresh mechanism.

>
> Assuming the above is correct, in order for mv88e6xxx to work correctly,
> it needs to enable learning on all locked ports, but it should happen
> regardless of the bridge driver learning configuration let alone impose
> any limitations on it. In fact, hostapd must disable learning for all
> locked ports.

To have hardware induced refreshing I would say learning should be on
also for 802.1X (hostapd). This relies of course on user added dynamic
ATU entries, which is what my follow-up patch set is about. Besides it
is perfectly feasible to have both 802.1X and Mac-Auth on the same
port.
