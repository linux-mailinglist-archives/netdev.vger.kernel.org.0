Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C2A3F621B
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbhHXP6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236565AbhHXP6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 11:58:50 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D5CC061757;
        Tue, 24 Aug 2021 08:58:06 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id z2so46598487lft.1;
        Tue, 24 Aug 2021 08:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pebXoQmUWBzlSnu9s+ZDsnyoaDKmmttwsIKNnt3weIE=;
        b=Q9jhvSUqhX4lkX2eoeELlFAvl6kH+1JR7rYZ70PDorFWAptKs27wemZX6u7svTpdNi
         CQZNEsfniIV6d6WzPb8J7yhbOdzMtA5DOYaA5EKxM1vJhU8ZsxUmndRdY+EzVlKU+W8w
         Rm9Lbcsw3p1hnRA996p40sb5DwjklycrpqSZ/b+oVZ0KHu3GYiUBBRFs5mK+Gcg0B8g0
         9JaskRUdVbEFtWMRx2qwC8zni6l0aLf8bq8hynPFCSg9xduGOuSe5DWyLiR4DIkf3ECP
         1VDS3ZeN449pq3V8mdMrBV2QsqSrBloBUL2lZQlmqzPi7XtP1aCEQTe+EGu6mBW507dU
         Rs/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pebXoQmUWBzlSnu9s+ZDsnyoaDKmmttwsIKNnt3weIE=;
        b=oIPB3GJfJ/TR0ruEsQG2LiGvZ/QmprSzLCPcFtfh1VhR/sxvZ28CA2mf4y7X3vOojp
         NXR9+hMuJZn88YcvR+esGWBmhUkv2h7F805nnmxI+UfwTVvUOgAmb+9xnGK2+UiyCZn4
         KBum56GM9owknjQKbsCXafh+nAymTQsuRyWGj385CjQFUJe/VcGDDkM/MVGUF7UaBYNG
         OBoiZ2Yn7XZ9vCthY+rHEQMUMIVaVfRs95cWld0pC4mjyKMZhIRCfshltL96VWxMsFUb
         dPEuze/oym3QLhQbVmX9BO3EFHt/knuKs4hMLSXVYecy8AExVeU38EVsXHudgycODfkm
         YeTg==
X-Gm-Message-State: AOAM533U+HI0ocEXtBktAsIxRctcc/kKxl8hEbgDp8WINeyIo9d4iZvg
        St3IXnNvomxc/WogVg1cTtny2KWIpF74Waau1o6HMQSYlqnm6zm1
X-Google-Smtp-Source: ABdhPJweeFB0/46GdTiQUi5WpATivrTK3DsqcsNXnsmBkdTL+2KZ4sgT2Ov+HDFZhbevcaMt0c1LJEJaFOfF4svpZsM=
X-Received: by 2002:a05:6512:3f8e:: with SMTP id x14mr28533152lfa.389.1629820684972;
 Tue, 24 Aug 2021 08:58:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210824055509.1316124-1-dqfext@gmail.com> <YSUQV3jhfbhbf5Ct@sashalap>
In-Reply-To: <YSUQV3jhfbhbf5Ct@sashalap>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 24 Aug 2021 23:57:53 +0800
Message-ID: <CALW65ja3hYGmEqcWZzifP2-0WsJOnxcUXsey2ZH5vDbD0-nDeQ@mail.gmail.com>
Subject: Re: [PATCH 4.19.y] net: dsa: mt7530: disable learning on standalone ports
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Tue, Aug 24, 2021 at 11:29 PM Sasha Levin <sashal@kernel.org> wrote:
> What's the reasoning behind:
>
> 1. Backporting this patch?

Standalone ports should have address learning disabled, according to
the documentation:
https://www.kernel.org/doc/html/v5.14-rc7/networking/dsa/dsa.html#bridge-layer
dsa_switch_ops on 5.10 or earlier does not have .port_bridge_flags
function so it has to be done differently.

I've identified an issue related to this.

> 2. A partial backport of this patch?

The other part does not actually fix anything.

>
> --
> Thanks,
> Sasha
