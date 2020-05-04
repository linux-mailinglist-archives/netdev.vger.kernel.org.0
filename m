Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFFB1C488D
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgEDUt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgEDUt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:49:58 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBE5C061A0E;
        Mon,  4 May 2020 13:49:56 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d16so14827280edv.8;
        Mon, 04 May 2020 13:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q7L4B/gaHgFnBxED0brVOKXanT1Bbb8OHNvzGehf/HY=;
        b=pRa8YNTVAoMCIiHLagX6utqSDmIjZ6LkSA6LaoNS28G484lIPlbtAvo5VBmaXwzwCE
         cPE6QonvLeSTG/X5uRj8OcMXJNogyvxvYx5Az1eNFZ7TdANIQrAkMpeHylN12qS8OaYR
         Sj7HSFw37DwuujRAQKCn+F/4EWg9QmwZLGcBe2tj8S1hmDcE/DbcXfe59ekfx7FE6gUo
         8I/t1WubAlJPtGiX/JEd3mNmeVFRxziOLpuGamOTgQ+grdjcld82YsDC7/frH2J48bTG
         MRNO4XBrWrutq5NMzCdqyfesG0iW0+wJ9n1Ldgfqfyzu14miFEwkOvAJc77Bm0oakLTO
         M/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q7L4B/gaHgFnBxED0brVOKXanT1Bbb8OHNvzGehf/HY=;
        b=qTDIydbChH4FxUVpA+fnX+kFurFbush9/zM7oTAw92iDb74A7ltY2PFphLoOK8SQqm
         OiXmr8dodW5oyH3z/2p6FHdYik12fSSENBQzqIA3UcWvtuDmNxDqD6JBm2zbO69XVIu5
         oPm0ReZ8P8rohirBBBZm6EY9r3ewJk6ac2KprsquuKI+dx2pN1sLIrmi4NRLZTInfgvr
         UtO8kT4V6khrS/JVCjzwM94K6XDxQhr8Iqvi8zIFKhYl3XnKQBi3gOD8fYTkYtYpIehO
         0IB3kCQX+9FeTFTiBsJ2tr8NP+FMeu9+1B4hs7B9vmb+9sUuqbCx+P+J1mE5DgDCbp+f
         yuLQ==
X-Gm-Message-State: AGi0PubpGsnEYX7Mb8FYOHgdFUyBqTTQ3lZ3Fqh4yPxQLj4Lh0Oez3Lw
        Jj29G9nQDVTyWJFzzhMV0nbZcG0w2/+3RNKOCFA=
X-Google-Smtp-Source: APiQypJmnREIeOlbNsDjt6heZ3r3doPjenzdbFCihgL1iyJHHO9R/sqhDz60Org12nkqRsfKqbLzQzcxrDNhkzBpDPQ=
X-Received: by 2002:a05:6402:6c4:: with SMTP id n4mr16683368edy.368.1588625395124;
 Mon, 04 May 2020 13:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200504201806.27192-1-f.fainelli@gmail.com> <CA+h21ho50twA=D=kZYxVuE=C6gf=8JeXmTEHhV30p_30oQZjjA@mail.gmail.com>
 <b32f205a-6ff3-e1db-33d1-6518091f90b4@gmail.com>
In-Reply-To: <b32f205a-6ff3-e1db-33d1-6518091f90b4@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 4 May 2020 23:49:44 +0300
Message-ID: <CA+h21hpObEHt04igBBbX40niuqON=41=f35zTgYNOTZZscbivQ@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: Do not leave DSA master with NULL netdev_ops
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, allen.pais@oracle.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 May 2020 at 23:40, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/4/2020 1:34 PM, Vladimir Oltean wrote:
> > Hi Florian,
> >
> > On Mon, 4 May 2020 at 23:19, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >> When ndo_get_phys_port_name() for the CPU port was added we introduced
> >> an early check for when the DSA master network device in
> >> dsa_master_ndo_setup() already implements ndo_get_phys_port_name(). When
> >> we perform the teardown operation in dsa_master_ndo_teardown() we would
> >> not be checking that cpu_dp->orig_ndo_ops was successfully allocated and
> >> non-NULL initialized.
> >>
> >> With network device drivers such as virtio_net, this leads to a NPD as
> >> soon as the DSA switch hanging off of it gets torn down because we are
> >> now assigning the virtio_net device's netdev_ops a NULL pointer.
> >>
> >> Fixes: da7b9e9b00d4 ("net: dsa: Add ndo_get_phys_port_name() for CPU port")
> >> Reported-by: Allen Pais <allen.pais@oracle.com>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >> ---
> >
> > The fix makes complete sense.
> > But on another note, if we don't overlay an ndo_get_phys_port_name if
> > the master already has one, doesn't that render the entire mechanism
> > of having a reliable way for user space to determine the CPU port
> > number pointless?
>
> For the CPU port I would consider ndo_get_phys_port_name() to be more
> best effort than an absolute need unlike the user facing ports, where
> this is necessary for a variety of actions (e.g.: determining
> queues/port numbers etc.) which is why there was no overlay being done
> in that case. There is not a good way to cascade the information other
> than do something like pX.Y and defining what the X and Y are, what do
> you think?
> --
> Florian

For the CPU/master port I am not actually sure who is the final
consumer of the ndo_get_phys_port_name, I thought it is simply
informational, with the observation that it may be unreliable in
transmitting that information over.
Speaking of which, if "informational" is the only purpose, could this
not be used?

devlink port | grep "flavour cpu"
pci/0000:00:00.5/4: type notset flavour cpu port 4
spi/spi2.0/4: type notset flavour cpu port 4
spi/spi2.1/4: type notset flavour cpu port 4

Thanks,
-Vladimir
