Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007C733C775
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhCOUKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbhCOUJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 16:09:42 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A26C06174A;
        Mon, 15 Mar 2021 13:09:42 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id mj10so68428124ejb.5;
        Mon, 15 Mar 2021 13:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XFZxaapEfrnceu1DR1QvIoySAx6HSdaqEW24Vu33n7o=;
        b=dOVrq4x9RRGKeAZWpe0l6ucz5AeUQM7VDOh2ZWfjnRiPbT2yn2dKYXq5KwqqY47S4i
         T2anIK/nBWZyUyZE/zAOwzdBDLRI42837cM6YIxU050itPRlkKly2qRNITaaen86ZiUS
         M1aQsDJ+hcPGmkKyfRf+XEOPS9HUtSX+4Ed5bhBnHX7xxgpFamBaZaAOflVlt8xOt21s
         2w8irqDcrmPyybrj57acXyGq6AHPbLTH1DdZRXyZBjlnJOJWjNVlJcyGfzlfKzW9JWa8
         /wZ2wyJM4AQeqfq48fK0EdNaAcsYrYFOPiKdm0AybyQK72dNcliSiuQijvpDWpfJ3Vei
         9PiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XFZxaapEfrnceu1DR1QvIoySAx6HSdaqEW24Vu33n7o=;
        b=S/Wm2M02ze2OaTZ0KQuVe4GvijM5T0UE2fZL5QSCW5jUbwxC/BTVfarWsNeKMYKtKD
         MJ6m3Kb6Q87mhYff+CitT5LKTMAHepDUEysOiGSxNS55snOQ110rDca5VqOVXjiCQ9Iy
         +riX7FqCeErhchgJQ3wWhtcsjEPCzJjVltK45bfVLmI0LntEmMM0HznaG52l9n3JVoKl
         jGeZ0VJmHzzJ1YRVayC+9DCrfa8zddkQ1cwubLiwJGdv6imMznd0lAPjBWR2OHIv0vn2
         ZU5fDLKU77tDNzjIdvnPg9CHke/7VSKe4rUn8hyEq5hxErmZhHIHBuq5Bvar1UCpUck9
         vJ3A==
X-Gm-Message-State: AOAM530oTcZcYmgUpKTfW8NwFGO3KosMXPSSzaU9911aWf0osgCHyxcp
        WIVBV0dl6bhjvi/dxJ1+NYA=
X-Google-Smtp-Source: ABdhPJwMRUIBF5tThWFDvF1cvUf3QS3BRDtqjRPx8hgfPLPM8Na+4GdEa3fdfpEQizG7fxOz+AVQEA==
X-Received: by 2002:a17:906:2786:: with SMTP id j6mr9901004ejc.157.1615838981122;
        Mon, 15 Mar 2021 13:09:41 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id r5sm8839502eds.49.2021.03.15.13.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 13:09:40 -0700 (PDT)
Date:   Mon, 15 Mar 2021 22:09:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: support MDB and bridge flag
 operations
Message-ID: <20210315200939.irwyiru6m62g4a7f@skbuf>
References: <20210315170940.2414854-1-dqfext@gmail.com>
 <892918f1-bee6-7603-b8e1-3efb93104f6f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <892918f1-bee6-7603-b8e1-3efb93104f6f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 01:03:10PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/15/2021 10:09 AM, DENG Qingfang wrote:
> > Support port MDB and bridge flag operations.
> > 
> > As the hardware can manage multicast forwarding itself, offload_fwd_mark
> > can be unconditionally set to true.
> > 
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > ---
> > Changes since RFC:
> >   Replaced BR_AUTO_MASK with BR_FLOOD | BR_LEARNING
> > 
> >  drivers/net/dsa/mt7530.c | 124 +++++++++++++++++++++++++++++++++++++--
> >  drivers/net/dsa/mt7530.h |   1 +
> >  net/dsa/tag_mtk.c        |  14 +----
> >  3 files changed, 122 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index 2342d4528b4c..f765984330c9 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -1000,8 +1000,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
> >  	mt7530_write(priv, MT7530_PVC_P(port),
> >  		     PORT_SPEC_TAG);
> >  
> > -	/* Unknown multicast frame forwarding to the cpu port */
> > -	mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
> > +	/* Disable flooding by default */
> > +	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
> > +		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
> 
> It's not clear to me why this is appropriate especially when the ports
> operated in standalone mode, can you expand a bit more on this?

We are in the function called "mt753x_cpu_port_enable" here. It's ok to
apply this config for the CPU port.
