Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98283E82AF
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbhHJSRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240411AbhHJSPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 14:15:55 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A33C04E093;
        Tue, 10 Aug 2021 10:53:28 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b7so31495027edu.3;
        Tue, 10 Aug 2021 10:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QM3H90oSp2wbFz4Ss9RbrFJEXcRByIUH4Fe/bMzcbEo=;
        b=e32YB+FaC/fXHtxLd1eNUxJjJoNjb9C1/YiTwNqROQinvJ5rS9lTSl/+XQBe1A6aVc
         Kb/kjt4JvmpHNxJht9Ryk6VjP+CXBrBB6hJ0PV+fDL/PQh3OLg+3G5QWdBqf10mhsvRh
         V6TPxLoSi35sUuT5+KuDFDow62iqXGA8skm7R8NfOCG049S06UkWo9n4w+uA3n0P+vb5
         HvgOiGRzGi/pZA+U7X2azFxArlYIvbB6AhjbPO6ED5bhr8PxnbG6DHwOdMsSlPPBqXCv
         6K34V67xddauYia8uA4cbFU1RD315q+BHqzn4oLGrrxz3rd+t8tjZbmXF8HLEmNPTaGH
         Ma6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QM3H90oSp2wbFz4Ss9RbrFJEXcRByIUH4Fe/bMzcbEo=;
        b=UVFRb3PACIt0c2dz0ybQmLTlu52oKWd9PAAUnvBMUFqwCApDTl4f+TEBquzg/Bxh3F
         2VidK8QAuWodW0x8YqdEp7SNgpVpcwFxePaRMFrADKYziZEnpM/a+LnPxP5ak6+v4Owa
         PbM02JipG1mYn/NxoEeZIhixbmhhkdCZYTEXIT5zsDAbxmtnDv9BV3tfxVPBONGMxDZO
         W1rjWkuuA9b7ZUxs6m1ATAljGgZJF/ETfIHnolTB4O4t8mNgMDG4o+NMW3BatFyUVvOA
         slAOOT5Y9rFsgs0oX9qgdLzOsXEwhzJJzJox4p3x9k9PCfFpYz8Z/irATWECgoqNuTEa
         ix1Q==
X-Gm-Message-State: AOAM530gzEAeoYVSOanAzE2amZxHDVbzqknJR1rWS7z9JTWa7o85AFlQ
        Y/21VotY+ZZmh/sHCSg6qIM=
X-Google-Smtp-Source: ABdhPJxOTqCMoM0wWJ0eO0tUOMox8i4MBJbE5kqat3SnZ1/q69HKWPJeRayBdf48ZJkNl3Dg5YBxBA==
X-Received: by 2002:a50:8fe1:: with SMTP id y88mr6326667edy.101.1628618007322;
        Tue, 10 Aug 2021 10:53:27 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id nb39sm7106805ejc.95.2021.08.10.10.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 10:53:26 -0700 (PDT)
Date:   Tue, 10 Aug 2021 20:53:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andre Valentin <avalentin@marcant.net>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>
Subject: Re: [RFC net-next 2/3] net: dsa: qca8k: enable assisted learning on
 CPU port
Message-ID: <20210810175324.ijodmycvxfnwu4yf@skbuf>
References: <20210807120726.1063225-1-dqfext@gmail.com>
 <20210807120726.1063225-3-dqfext@gmail.com>
 <20210807222555.y6r7qxhdyy6d3esx@skbuf>
 <20210808160503.227880-1-dqfext@gmail.com>
 <0072b721-7520-365d-26ef-a2ad70117ac2@marcant.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0072b721-7520-365d-26ef-a2ad70117ac2@marcant.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 07:27:05PM +0200, Andre Valentin wrote:
> On Sun, Aug 08, 2021 at 1805, DENG Qingfang wrote:
> > On Sun, Aug 08, 2021 at 01:25:55AM +0300, Vladimir Oltean wrote:
> >> On Sat, Aug 07, 2021 at 08:07:25PM +0800, DENG Qingfang wrote:
> >>> Enable assisted learning on CPU port to fix roaming issues.
> >>
> >> 'roaming issues' implies to me it suffered from blindness to MAC
> >> addresses learned on foreign interfaces, which appears to not be true
> >> since your previous patch removes hardware learning on the CPU port
> >> (=> hardware learning on the CPU port was supported, so there were no
> >> roaming issues)
>
> The issue is with a wifi AP bridged into dsa and previously learned
> addresses.
>
> Test setup:
> We have to wifi APs a and b(with qca8k). Client is on AP a.
>
> The qca8k switch in AP b sees also the broadcast traffic from the client
> and takes the address into its fdb.
>
> Now the client roams to AP b.
> The client starts DHCP but does not get an IP. With tcpdump, I see the
> packets going through the switch (ap->cpu port->ethernet port) and they
> arrive at the DHCP server. It responds, the response packet reaches the
> ethernet port of the qca8k, and is not forwarded.
>
> After about 3 minutes the fdb entry in the qca8k on AP b is
> "cleaned up" and the client can immediately get its IP from the DHCP server.
>
> I hope this helps understanding the background.

How does this differ from what is described in commit d5f19486cee7
("net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign
bridge neighbors")?
