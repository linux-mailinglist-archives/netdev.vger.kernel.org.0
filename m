Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0473E592E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240131AbhHJLf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhHJLf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 07:35:57 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5D6C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 04:35:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id b15so10714155ejg.10
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 04:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FqpR9Ta+WV1cMua5lhkmA9GT+tyAXLYo8Gw19nqNUrc=;
        b=htpkh6/uIiwBu8WFThgZclu+OHEycBDblmk+SfM4bYIMX+s+I6TS5hxHWdcfC/laPz
         jwFXqoZR6M/xGH3MXGQkMqebuTprtAjPxm9Zo2vMYe3djdCmpohRYl/z4R8EdawGj00g
         zgnmYn0Z1zJPxSCJnQT3tcVZ+Emi1WWUJcS6IwnYkAY9WR4e4vRoZ+vMem6TK8MB09wA
         a3t+qImnat0FGrg23j4zBjJY4EXJ87SgTjgT7bkrPEG5H260QYYOQ4r4nwSWZTZcdaIT
         k1Jtcr1EV8OesaABE0NvCUxs6xZ5rsA7cUn1YybZgGzSbuU8mRCHpJTxbO7T0mb1Mbub
         dpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FqpR9Ta+WV1cMua5lhkmA9GT+tyAXLYo8Gw19nqNUrc=;
        b=O3qYt+VSRu4Z/5rOaELXV206DdmWMGLxlNrzj9x0glKjxmX0iHhC4Y9TScykV81juO
         aQkn+4YJaTVRA+WvzanrXi1iHUPZm/jT/6V458ve/UniZzOL6/OwtCWI7oW6lV5nGx51
         WQnd6RtLtQcgEcPlxltfkk4C6MRF1qaQrIX05f/rEPhJ+9WYqxe16iJp1nB0r6mjeT0r
         VJAllt0E75R40sLMPsA32kHVkUb4anRyWQ1W6vMZSNip+E1g1lU3dKi+Od48v/aqRcCy
         nhnZZ0Zw6z/JtnRCQ9QJ4fKqezZ1hcBB5cucjZnc5KldFnN+hLoXHeSyHbCrNnT+ax8w
         GXug==
X-Gm-Message-State: AOAM532cTxgBEPO7WkicHuMH5C59H1h9V9TMmkUxSId0tlY/XRRjEh1l
        s26Nhp1yXNxMDbWhwSWP0jE=
X-Google-Smtp-Source: ABdhPJzWHCrAer0SGu07KcPGaAM4gA2ej5keQq8T4wwG/jSa/JU2mVkvvdnYE8vXNzeh9xH2KZLxXg==
X-Received: by 2002:a17:906:134a:: with SMTP id x10mr26644322ejb.70.1628595333895;
        Tue, 10 Aug 2021 04:35:33 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id g26sm3107837ejr.48.2021.08.10.04.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 04:35:33 -0700 (PDT)
Date:   Tue, 10 Aug 2021 14:35:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: remove the "dsa_to_port in a
 loop" antipattern from the core
Message-ID: <20210810113532.tvu5dk5g7lbnrdjn@skbuf>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
 <20210809190320.1058373-3-vladimir.oltean@nxp.com>
 <20210810033339.1232663-1-dqfext@gmail.com>
 <dec1d0a7-b0b3-b3e0-3bfa-0201858b11d1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dec1d0a7-b0b3-b3e0-3bfa-0201858b11d1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:41:07AM -0700, Florian Fainelli wrote:
> On 8/9/2021 8:33 PM, DENG Qingfang wrote:
> > On Mon, Aug 09, 2021 at 10:03:18PM +0300, Vladimir Oltean wrote:
> > > Ever since Vivien's conversion of the ds->ports array into a dst->ports
> > > list, and the introduction of dsa_to_port, iterations through the ports
> > > of a switch became quadratic whenever dsa_to_port was needed.
> > 
> > So, what is the benefit of a linked list here? Do we allow users to
> > insert/delete a dsa_port at runtime? If not, how about using a
> > dynamically allocated array instead?
> 
> The goal was to flatten the space while doing cross switch operations, which
> would have otherwise required iterating over dsa_switch instances within a
> dsa_switch_tree, and then over dsa_port within each dsa_switch.

To expand on that: technically dsa_port_touch() _does_ happen at
runtime, since multiple switches in a cross-chip tree probe
asynchronously. To use a dynamically allocated array would mean to
preallocate the sum of all DSA switch ports' worth of memory, and to
preallocate an index for each DSA switch within that single array.
Overall a list is simpler.
