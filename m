Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289CF3DBC80
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 17:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhG3PqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 11:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhG3Pp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 11:45:59 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA8EC061765;
        Fri, 30 Jul 2021 08:45:54 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id m9so12948243ljp.7;
        Fri, 30 Jul 2021 08:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fawJYldHWdolrAXivi3QZBGiBpcFEP0a9w0quyUwKgg=;
        b=Mw3YNdZqALvcqSSDyfJu3hRXiVJIQ2Nw4EEYPsD/NtQ4uui/gJ19vEbXkqspQPXWxJ
         pHHLDl0O9qdQT7bpST4PYSMbOvIT9W8FD/vghqRkndNEOeS9j6FQ/RgQbW2uXF0lOBg9
         6nmQ9RHZ1/KyA15CW+htmxqFO9p9qr2oEFiSh12xGBNMyKEcEE/8zz6AECB+P4g8KR5P
         Yi5TFhF2EBD69uf1RqHkm9d9htaWhJuBHoaKWO2Ok4l/ENProie48WcdWtqoIPOEAB20
         2NLOgBXXPvGxQv/vrfFB6xrAIkagxumIsTarzdY1W0FaNS2VYJddsI3N+mAAE1cLKfk0
         2j+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fawJYldHWdolrAXivi3QZBGiBpcFEP0a9w0quyUwKgg=;
        b=OYYV4A9PiRonLOomSYwhZQtE/1dgsJ4UXAunZYAN4iWxDXIuu30noSuUgSuGpWfUFv
         Gr7qB0rIqXdx00ePUssA1gfeSub5rYO+qLJzHH+9NEne6L7bSYRuvedGpjldMkliX33E
         pk6LGI2q50S6TWC+WOajD9Si2lItPcoTRIUsezuBV4Gemz6z9YmTrXP0+fStrCS0mmbJ
         cUU9V7hQJM4K+Bpt5vonsKpsLp6pgzWTB1RA8JLNLmYTJKsenFTDK61YOGED2/CbxOlz
         4q9dMay0OKPF8YKjJHfk8u72GWqj6SyFviQ1TbV2i9ZvaEXGwxwOPPujOBqygoUjqsZy
         gUeg==
X-Gm-Message-State: AOAM53131U+qT76lTtZyX+Fy3Ppn0l1XJMhywXQcNZ4ow57PYz10OdAH
        ZZtTllIg2c9ftkotVDn/l5E5OknvzjzeAV4vQW4=
X-Google-Smtp-Source: ABdhPJxz/WdjDi4lGXhyCZtm24i63rrHi90X5+zc4DeLWMG83ZlGAInQMG/QwUP6GwNdDdJSBSf107Bte0SF5U6V1MU=
X-Received: by 2002:a2e:98d1:: with SMTP id s17mr1956928ljj.457.1627659952804;
 Fri, 30 Jul 2021 08:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210728175327.1150120-1-dqfext@gmail.com> <20210728175327.1150120-3-dqfext@gmail.com>
 <20210729152805.o2pur7pp2kpxvvnq@skbuf> <CALW65jbHwRhekX=7xoFvts2m7xTRM4ti9zpTiah8ed0n0fCrRg@mail.gmail.com>
 <20210729165027.okmfa3ulpd3e6gte@skbuf>
In-Reply-To: <20210729165027.okmfa3ulpd3e6gte@skbuf>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 30 Jul 2021 23:45:41 +0800
Message-ID: <CALW65jYYmpnDou0dC3=1AjL9tmo_9jqLSWmusJkeqRb4mSwCGQ@mail.gmail.com>
Subject: Re: [RFC net-next 2/2] net: dsa: mt7530: trap packets from standalone
 ports to the CPU
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 12:50 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> I have the MT7621 GSW, and sadly this reference manual isn't the best in
> explaining what is and what is not possible. For example, I am still not
> clear what is meant by "VID1" and "VID0". Is "VID1" the inner (customer)
> VLAN tag, and "VID0" the outer (service) VLAN tag, or "VID1" means the
> actual VLAN ID 1?
>
> And the bits 3:1 of VAWD1 (VLAN table access register) indicate a FID
> field per VLAN. I cannot find the piece that you quoted in this manual.
> But what I expect to happen for a Transparent Port is that the packets
> are always classified to that port's PVID, and the VLAN Table is looked
> up with that PVID. There, it will find the FID, which this driver
> currently always configures as zero. In my manual's description, in the
> "Transparent Port" chapter, it does explicitly say:
>
>         VID0 and VID1 will store PVID as the default VID which is used
>         to look up the VLAN table.
>
> So I get the impression that the phrase "the VLAN table is not applicable"
> is not quite correct, but I might be wrong...

Alright, I think I've made some progress.
In the current code, we only use two combinations to toggle user
ports' VLAN awareness: one is PCR.PORT_VLAN set to port matrix mode
with PVC.VLAN_ATTR set to transparent port, the other is PCR.PORT_VLAN
set to security mode with PVC.VLAN_ATTR set to user port.

It turns out that only PVC.VLAN_ATTR contributes to VLAN awareness.
Port matrix mode just skips the VLAN table lookup. The reference
manual is somehow misleading when describing PORT_VLAN modes (See Page
17 of MT7531 Reference Manual, available at
http://wiki.banana-pi.org/Banana_Pi_BPI-R64#Resources). It states that
PORT_MEM (VLAN port member) is used for destination if the VLAN table
lookup hits, but actually it uses **PORT_MEM & PORT_MATRIX** (bitwise
AND of VLAN port member and port matrix) instead, which means we can
have two or more separate VLAN-aware bridges with the same PVID and
traffic won't leak between them.

So I came up with a solution: Set PORT_VLAN to fallback mode when in
VLAN-unaware mode, this way, even VLAN-unaware bridges will use
independent VLAN filtering. Then assign all standalone ports to a
reserved VLAN.
