Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B51D6C14
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgEQTEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQTEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:04:36 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00297C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:04:35 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id d7so6456883eja.7
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wnLypuPdtL0C61OykHZywljajBtmpW7roP2qVljE5nE=;
        b=B10f4ZayXxWhsyJW8Pk0RGCQXYz1NOafsQBK6cMamYPcqh4mywFLh3iEbyk7VNs13C
         BnkZawDWFsSXXMuKQggjm99qQQ7XUzyeGmtGBbreY8K4OqTSyj1iLA3gtpOq4YjLJxQI
         uLzYfVb7rf7BY7GS5B3fH97uaJZFODdvzNFEFeofhtI7VZ1llhBDbUSMj2QJZNfSsSQZ
         iQCb3LDLdqMBpN9DQU03Pzxo44GIRSjACQGumEzdufXqZDs2HZfdBIt0xHu+aK6NG0dl
         C6nnsT9/XzZmpPABaKu31I58A6bciTa0bfoGHfw+xQYe2RCHIwJSV6/a7fGilrMO2dig
         IHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wnLypuPdtL0C61OykHZywljajBtmpW7roP2qVljE5nE=;
        b=EVy2P/3ZLs8eqrjBZyW2ln7eqODIHtnZkjoeuTuK9xeF7r4ZSj4Kb+skHN8lDpZ/zk
         z4/bh35Hej7qvPDysKfveWVMBYRRjZoGQiEF84aiATZcnUnJVagdIyv8WEM5iuxT1CTF
         v7Z/lwzeAK7m4cRKb9184x6GIe5dTh0Xk5lpl2qefc3IxRVmsKb6N/9fDx/kx5agh1b2
         JwhdxXJh6r+keJMiJqx5cElIzgU0sYGJ9EY/fzRKwCKeQvWhiiykpGz/+AF9ixU9wbug
         hChfEDdajPHEDPlSfDs/5ei+YIvJZQ4QDVpEdbSI02usbis7xSYD4TtJh5+4blCQhu7y
         htqg==
X-Gm-Message-State: AOAM5334AXCVFnRQQ5o0D4168LuEfqNgd451t9AKZz9/gEGZ4DxTd/aJ
        rDVO1FFDxR79nNWN5Co+NS2K05F9qzmG8y2iyRm1urnu
X-Google-Smtp-Source: ABdhPJw2/FqYoj09p4Cfjkysu1L2a8nVyipsr/Rn+x7gzmV3jJmtS2GNHewqNeG3wP9adl8V1756TGUxt2URz6ksf8E=
X-Received: by 2002:a17:907:1002:: with SMTP id ox2mr20792ejb.189.1589742274487;
 Sun, 17 May 2020 12:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
 <20200516.133739.285740119627243211.davem@davemloft.net> <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com>
 <20200516.151932.575795129235955389.davem@davemloft.net> <CA+h21hrg_CeD2-zT+7v3b3hPRFaeggmZC9NqPp+soedCYwG63A@mail.gmail.com>
 <20200517184514.GD606317@lunn.ch>
In-Reply-To: <20200517184514.GD606317@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 17 May 2020 22:04:23 +0300
Message-ID: <CA+h21hqi0dX349dxXz8vrWUGLoHrk-er77S4rvUrj7jM3QAXWQ@mail.gmail.com>
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, 17 May 2020 at 21:45, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, May 17, 2020 at 01:51:19PM +0300, Vladimir Oltean wrote:
> > On Sun, 17 May 2020 at 01:19, David Miller <davem@davemloft.net> wrote:
> > >
> > > From: Vladimir Oltean <olteanv@gmail.com>
> > > Date: Sun, 17 May 2020 00:03:39 +0300
> > >
> > > > As to why this doesn't go to tc but to ethtool: why would it go to tc?
> > >
> > > Maybe you can't %100 duplicate the on-the-wire special format and
> > > whatever, but the queueing behavior ABSOLUTELY you can emulate in
> > > software.
> > >
> > > And then you have the proper hooks added for HW offload which can
> > > do the on-the-wire stuff.
> > >
> > > That's how we do these things, not with bolted on ethtool stuff.
> >
> > When talking about frame preemption in the way that it is defined in
> > 802.1Qbu and 802.3br, it says or assumes nothing about queuing. It
> > describes the fact that there are 2 MACs per interface, 1 MAC dealing
> > with some traffic classes and the other dealing with the rest.
>
> I did not follow the previous discussion, but i assume you talked
> about modelling it in Linux as two MACs? Why was that approach not
> followed?
>
>    Andrew

I don't recall having discussed that option, but I guess that you can
see why, if I quote this portion from IEEE 802.1Q-2018:

6.7.1 Support of the ISS by IEEE Std 802.3 (Ethernet)
Mapping between M_CONTROL.requests/indications and IEEE 802.3
MA_CONTROL.requests/indications is performed as specified in IEEE Std
802.1AC. If the MAC supports IEEE 802.3br (TM) Interspersing Express
Traffic, then PFC M_CONTROL.requests are mapped onto the MAC control
interface associated with the express MAC (eMAC).
If frame preemption (6.7.2) is supported on a Port, then the IEEE
802.3 MAC provides the following two MAC service interfaces (99.4 of
IEEE Std 802.3br (TM)-2016 [B21]):
a) A preemptible MAC (pMAC) service interface
b) An express MAC (eMAC) service interface
For priority values that are identified in the frame preemption status
table (6.7.2) as preemptible, frames that are selected for
transmission shall be transmitted using the pMAC service instance, and
for priority values that are identified in the frame preemption status
table as express, frames that are selected for transmission shall be
transmitted using the eMAC service instance.

_In all other respects, the Port behaves as if it is supported by a
single MAC service interface_ (emphasis mine). In particular, all
frames received by the Port are treated as if they were received on a
single MAC service interface regardless of whether they were received
on the eMAC service interface or the pMAC service interface, except
with respect to frame preemption.

Thanks,
-Vladimir
