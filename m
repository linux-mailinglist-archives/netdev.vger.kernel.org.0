Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE713DDC9E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhHBPmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbhHBPml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 11:42:41 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0017EC06175F;
        Mon,  2 Aug 2021 08:42:29 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id oz16so31547216ejc.7;
        Mon, 02 Aug 2021 08:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zs34S0ZCtslSiHpvRfcfD5NqWXVNRsl0rvFFEe/DzVE=;
        b=MIGbOfeJDOB+6qL0tTWTM19ysoYssZnpbVpku3bSQvbeBHlscK2bSzV8i0sCUwPxEQ
         wzTDYG7b3rtlECbq9g76QGuJHOKBlt2gVbv+mra0DCHa3RfOEzfL+S4kszyH6RUbRieo
         DVAwLrNFlLUPev+NCkX5i98ozIrECRCPCmBu5uulTqvqtnu4vDcV9AbY3LZyT+j+V0jN
         RXxJ0QOhznDzY3t2y5krvZWlbpmq5xOu3KOlWEzpQnYSp/jo9evJG++tyGjfSqW2yek1
         GHg28xXfHoQ3CTL2HeupdvWSA1uobTY2MhfSa23kWcm+D/3xBDBxmhzv7+cP6TesE6nr
         DnfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zs34S0ZCtslSiHpvRfcfD5NqWXVNRsl0rvFFEe/DzVE=;
        b=S8rKBlHJL55Qjklvkanhj7SxwJuQJBNADAvijzQUX4Z0lj2q7RlR5hhb8cMrtgD5CQ
         fD5BQHtDqN/IEN43pNZoAkBcJgt7xwHBssRZ9SDSMeJMD98ZoqxbkrAtMA/LiREXWuQR
         PxGUerxipm0Ok3I/XSN6Qy+r1oYG83NCwm0Gnuw49W0LjyWNJMl+Qz7Fc4vgi1UBL+IW
         sPxV1fGZ8jRNC4uGQE4yQV/sFpcGjeb1IG6xWJ+6OkMOZWP8R0LyY/ZUS2P+aI0VUy+J
         /Ve0xh0wl67d+7KLux4GgVL9Reeuqwn8f2+63fzk1Tjk0CEdbSoYzY65MPqWZ6Xv0LMO
         Nuug==
X-Gm-Message-State: AOAM533UKvArcYBtRyS9vtEkZ+slAAFC1GVxWd+ChnvRTfOYSQTFT6l4
        IeRIjCSnIj2prVwJ+K1slsY=
X-Google-Smtp-Source: ABdhPJyEjvOm7wA4orU4/gnMjfU4LJ5+DLlqavn510nlHLKRnEWzKyJUmKtNZg/IFP3CcCrMiOe41Q==
X-Received: by 2002:a17:907:766c:: with SMTP id kk12mr15603022ejc.525.1627918948585;
        Mon, 02 Aug 2021 08:42:28 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id d22sm4864989ejj.47.2021.08.02.08.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 08:42:28 -0700 (PDT)
Date:   Mon, 2 Aug 2021 18:42:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC net-next v2 3/4] net: dsa: mt7530: set STP state also on
 filter ID 1
Message-ID: <20210802154226.qggqzkxe6urkx3yf@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com>
 <20210731191023.1329446-4-dqfext@gmail.com>
 <20210802134336.gv66le6u2z52kfkh@skbuf>
 <20210802153129.1817825-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802153129.1817825-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:31:29PM +0800, DENG Qingfang wrote:
> On Mon, Aug 02, 2021 at 04:43:36PM +0300, Vladimir Oltean wrote:
> > On Sun, Aug 01, 2021 at 03:10:21AM +0800, DENG Qingfang wrote:
> > > --- a/drivers/net/dsa/mt7530.h
> > > +++ b/drivers/net/dsa/mt7530.h
> > > @@ -181,7 +181,7 @@ enum mt7530_vlan_egress_attr {
> > >
> > >  /* Register for port STP state control */
> > >  #define MT7530_SSP_P(x)			(0x2000 + ((x) * 0x100))
> > > -#define  FID_PST(x)			((x) & 0x3)
> >
> > Shouldn't these macros have _two_ arguments, the FID and the port state?
> >
> > > +#define  FID_PST(x)			(((x) & 0x3) * 0x5)
> >
> > "* 5": explanation?
> >
> > >  #define  FID_PST_MASK			FID_PST(0x3)
> > >
> > >  enum mt7530_stp_state {
> > > --
> > > 2.25.1
> > >
> >
> > I don't exactly understand how this patch works, sorry.
> > Are you altering port state only on bridged ports, or also on standalone
> > ports after this patch? Are standalone ports in the proper STP state
> > (FORWARDING)?
>
> The current code only sets FID 0's STP state. This patch sets both 0's and
> 1's states.
>
> The *5 part is binary magic. [1:0] is FID 0's state, [3:2] is FID 1's state
> and so on. Since 5 == 4'b0101, the value in [1:0] is copied to [3:2] after
> the multiplication.
>
> Perhaps I should only change FID 1's state.

Keep the patches dumb for us mortals please.
If you only change FID 1's state, I am concerned that the driver no
longer initializes FID 0's port state, and might leave that to the
default set by other pre-kernel initialization stage (bootloader?).
So even if you might assume that standalone ports are FORWARDING, they
might not be.
