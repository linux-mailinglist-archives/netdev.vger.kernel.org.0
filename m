Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2480A40764F
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 13:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhIKLpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 07:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhIKLpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 07:45:46 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC165C061574;
        Sat, 11 Sep 2021 04:44:33 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id i21so9869315ejd.2;
        Sat, 11 Sep 2021 04:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2VF7BSxil8ySiiRZzPeUc3n5QfyIdcKimzYCRdR6uxg=;
        b=fgCH9oC1cx3EMTWHtJESgMvm6Bzc/H8YmCEo5yFK5sNM8hjzZ48e3nc9KNw2Zs1Og/
         iPzvi9W1cT3pS1Z9sb2f2PU+s7/VRds2Z84qmd/x4XkwciFpaVIgmEaKh2Gly26TrO2n
         9QGjWQTBx/CUaQBYB3qc1ZMInDKq8a+w6ET72JUtfK7b6MKKAgsnoViqWH1B5NyfaMv1
         NiD7XZmWbV8nDJ62HkSNMv7KEP0iNsSBgt91JpdTqu05rHo4vAbxSAgcOTk2RsYJL0Vo
         bur2uazzr+uu6ddpKyAvWgdQF90oqvM2TUy7cHVp5Gnu78GwBLY+rEsXOQVGb2QgPWNO
         ZYRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2VF7BSxil8ySiiRZzPeUc3n5QfyIdcKimzYCRdR6uxg=;
        b=prFjCv3xfpbmhuiUjn7AV3WI5INcoT6Lia8aEU/sWWSSGyXPphWKtuWdBUlgSU2eSK
         QvUYdOHG2JHAysbbtKlMa8+Y/F4PSOrrsu4OqAafwFbKDvoCZXLSWtMu86Ax9K3Ooiy1
         WizMUcPMBkZf7kzKAykMWX9oQjJWSft4WnA1vOfNnEn4OwLr0jwMdVkPgTzZ8fnFLgxT
         kSXAXMldg8+1pcMyC1tTmeCqB5I0P4BYf9dPovhhcwI9I7mPhht7iKDBdiXjAeVECAfp
         jGWe1LxH6rz0fyB7IkgdN0JLa02ysWoIDSi8aLt0IpBz294s4+t0BgXMQkiwQdBqvsx8
         Czog==
X-Gm-Message-State: AOAM5313zhSlJIrtcmi1jy40njWH+2YpdQROmdj2G+Evy0bJSy6sDC1U
        10ZjHSmfpJVqs1UwWCMDZX8=
X-Google-Smtp-Source: ABdhPJxiShNiV9iwq0EFWikNNtSkQWobiLzhdGJ9x6MbyX+W+TPXgMHMq5r4h3RU6HWoAb9brwz7Mw==
X-Received: by 2002:a17:906:912:: with SMTP id i18mr1471958ejd.257.1631360672314;
        Sat, 11 Sep 2021 04:44:32 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id o12sm812610edv.19.2021.09.11.04.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 04:44:31 -0700 (PDT)
Date:   Sat, 11 Sep 2021 14:44:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210911114430.rvlee7cyes2xhzws@skbuf>
References: <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
 <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
 <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
 <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com>
 <YTtG3NbYjUbu4jJE@lunn.ch>
 <20210910145852.4te2zjkchnajb3qw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910145852.4te2zjkchnajb3qw@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 05:58:52PM +0300, Vladimir Oltean wrote:
> On Fri, Sep 10, 2021 at 01:51:56PM +0200, Andrew Lunn wrote:
> > > It does not really scale but we also don't have that many DSA masters to
> > > support, I believe I can name them all: bcmgenet, stmmac, bcmsysport, enetc,
> > > mv643xx_eth, cpsw, macb.
> > 
> > fec, mvneta, mvpp2, i210/igb.
> 
> I can probably double that list only with Freescale/NXP Ethernet
> drivers, some of which are not even submitted to mainline. To name some
> mainline drivers: gianfar, dpaa-eth, dpaa2-eth, dpaa2-switch, ucc_geth.
> Also consider that DSA/switchdev drivers can also be DSA masters of
> their own, we have boards doing that too.
> 
> Anyway, I've decided to at least try and accept the fact that DSA
> masters will unregister their net_device on shutdown, and attempt to do
> something sane for all DSA switches in that case.
> 
> Attached are two patches (they are fairly big so I won't paste them
> inline, and I would like initial feedback before posting them to the
> list).
> 
> As mentioned in those patches, the shutdown ordering guarantee is still
> very important, I still have no clue what goes on there, what we need to
> do, etc.

So to answer my own question, there is a comment above device_link_add:

 * A side effect of the link creation is re-ordering of dpm_list and the
 * devices_kset list by moving the consumer device and all devices depending
 * on it to the ends of these lists (that does not happen to devices that have
 * not been registered when this function is called).

so the fact that DSA uses device_link_add towards its master is not
exactly for nothing. device_shutdown() walks devices_kset from the back,
so this is our guarantee that DSA's shutdown happens before the master's
shutdown.

So these patches should be okay. Any other comments? If not, I will
formally submit them tomorrow towards the net tree.
