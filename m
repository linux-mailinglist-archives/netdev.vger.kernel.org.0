Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4023725E6F3
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgIEK3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 06:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgIEK3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 06:29:31 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D4DC061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 03:29:30 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id m5so4240575lfp.7
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 03:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OfytdpZheSK+y+bjDtXzMIwEtJPbotC4OoPsQwyfnSA=;
        b=W6LnPu7u3mrZfFvjZG4NihOHg5wyXJ24iZeFzlMpZkQ4E9PIScWf/NvempXlBd+HKr
         u3gSgFXZ+YrTZP+26XePP2pvpAeck+rkzjshfwg47zmcpOB6067oftBohVmY8Bowq2jU
         UzfLjW0iq6BCBVJ7VAqPsXrzadTfWeO6g1caay5sY2Y3AW/dBsPO8Y17wFlD0sBkiq+d
         Jgpnml+JIsInYH2OQXTR75PIkYSJ2VwRPpidnrEpMnWPe5w8225t7PMsD18NuCM1Ln3M
         aHTsclDcL5ZJy58zIHDlFAyJ5k7O0LrOAB/lV1d4NPS/4iy3VofrcQk+aWM9aJXdYp4I
         FScg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OfytdpZheSK+y+bjDtXzMIwEtJPbotC4OoPsQwyfnSA=;
        b=jMCOCCH6QTZyPD/O1Cl0K++t1mB05HV3BUJwsCRYfmYWXvav8c3p03aPGZFplbtp5S
         tRqGaEh/xN0tgo+Bd0iPVR2g/6EwCW9WMmYReHypLaLdwMiy1QCDK3+l/vpH3ERrtTK1
         oSzZWYF3ZBQ5sPAxF7izfDXuf+X8OsbAMi2eyf53uQz69vfFLVresntUAxKBVqWnQzYM
         6FjvfDnZoDELde8wRgs305TDYcXM0KYcdHf0llC7Er7ogYKLruhNojNKa/M6f0kBX6Qi
         5bp7axtWvCK76m09pK6H4J90z/YXIyq/XIibcylAo67J6XxAZoBIGIV2LIVi6cKS1l8v
         UliQ==
X-Gm-Message-State: AOAM533Yqc/9VBHfybyx9FqTukRcQ4HMPVa7Mg4rp5MV0HN9k2lkhc9Q
        AqWSfJoSH975CM40FGa9kJMJBdrHE3JB9+xONFWxcw==
X-Google-Smtp-Source: ABdhPJzGIJg9XLShXb3YAJbKjz9CdCOvn20QzI+VjNbSPOV/6FOQiQWUjcyDPOszrtZ6xllknfzcGCPntS4PjEoi5BY=
X-Received: by 2002:a05:6512:1044:: with SMTP id c4mr5863665lfb.77.1599301767084;
 Sat, 05 Sep 2020 03:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200901190854.15528-1-linus.walleij@linaro.org>
 <20200901190854.15528-3-linus.walleij@linaro.org> <15cda1ef-c145-990b-5318-eac70338c702@gmail.com>
In-Reply-To: <15cda1ef-c145-990b-5318-eac70338c702@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 5 Sep 2020 12:29:15 +0200
Message-ID: <CACRpkdZ2JhxtY1KdAOPafdJF7ApEqJOjjBV98f29X7o_GY9WxQ@mail.gmail.com>
Subject: Re: [net-next PATCH 2/2 v2] net: dsa: rtl8366: Refactor VLAN/PVID init
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 9:14 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 9/1/2020 12:08 PM, Linus Walleij wrote:

> [snip]
>
> > +     /* Update the MC entry */
> > +     vlanmc.member |= member;
> > +     vlanmc.untag |= untag;
> > +     vlanmc.fid = fid;
>
> Is not there a problem with rtl8366_vlan_del() which is clearing the
> entire vlanmc structure when it it should be doing:
>
>         vlanmc.member &= ~BIT(port);
>         vlanmc.untag &= ~BIT(port);
>
> or something along these lines?

You're right, I'll send a separate patch for this.

Yours,
Linus Walleij
