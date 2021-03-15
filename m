Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F5833C855
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhCOVQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhCOVPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:15:45 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16755C06174A;
        Mon, 15 Mar 2021 14:15:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id bf3so19012084edb.6;
        Mon, 15 Mar 2021 14:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qwnbwanU2MY7jCvFVBwRSp3WXlaw+EiV14zRrhqaSu0=;
        b=Lt+eVhbnXOgmfLt8THwaBgDraGpxApiQbIVUYLqclrwyuCKUwMl3PC4uUCe43Q7780
         fOZ+p0IkmU5Rdb3qF+uru0em7rgkNck6zDK4Tuigl3wFKLElfOTARmrZiMpADAxyx5Gd
         mKSAVjgtlOQ2N9FTAdGxknLLlbbRNkNDtlqbIi23JTermQIYCq7Jz60Xa8yL6txZRJUI
         1zqBb9hnwlOnX+UhD7Bi5OGNF2yxC+avG/DdUOizyrbqAixk+9kOKEO/qGLSfhspDrb1
         AZ0DZULmbOORr12r2AZ9bFq/8L6N22UeIngoLQKgtboWt+YGljxUwjvrzxQnuIdr4F37
         5XOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qwnbwanU2MY7jCvFVBwRSp3WXlaw+EiV14zRrhqaSu0=;
        b=seCWGnGL+avUp7PHyneTeVD56WUajNxKgonzu49ZIT22myO701CWUVGDZ2L+/AYYVF
         DBssGYjyQlNnwupJ47th5thQk7bn5jspCk/FE5CxXsWDnhw5jKYuiUMBBGI3EwICV3h4
         9DJt0Bj0cReJYxKg//vOMzxZ2H5uXAI7hief8o2KF2AikxEkjcfHCACpBrC/rCf3HBjr
         v0stADwGHl3x4SauuQMNhaqR62XogoqWyInNs571eD+fg4F1szHQqjGDAVbYyrBsP7hO
         8zUaafQxE1IVkt9qC6qDWJ67xyPN1zo+JHwdSfSpa4y8DjhjRUj8aPqpTXxL4qdufUwf
         zqsg==
X-Gm-Message-State: AOAM533TM7hnpFvTew9Zqezv1LULBK456ROEx5rBj2LGOONK2mUqWDq1
        fDZJvxyd4YA1Tld16w+3G9w=
X-Google-Smtp-Source: ABdhPJyxFmzPQdIpHLDHNyRn+rWF8FayJG6KOvHNVBAgNs2PIula+AmyaWzcw2zv5Ouksj3jqtc24g==
X-Received: by 2002:a05:6402:1283:: with SMTP id w3mr31971754edv.340.1615842943862;
        Mon, 15 Mar 2021 14:15:43 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id j14sm8800785eds.78.2021.03.15.14.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:15:43 -0700 (PDT)
Date:   Mon, 15 Mar 2021 23:15:41 +0200
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
Message-ID: <20210315211541.pj5mpy2foi3wlhbe@skbuf>
References: <20210315170940.2414854-1-dqfext@gmail.com>
 <892918f1-bee6-7603-b8e1-3efb93104f6f@gmail.com>
 <20210315200939.irwyiru6m62g4a7f@skbuf>
 <84bb93da-cc3b-d2a5-dda8-a8fb973c3bae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84bb93da-cc3b-d2a5-dda8-a8fb973c3bae@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 01:44:02PM -0700, Florian Fainelli wrote:
> On 3/15/2021 1:09 PM, Vladimir Oltean wrote:
> > On Mon, Mar 15, 2021 at 01:03:10PM -0700, Florian Fainelli wrote:
> >>
> >>
> >> On 3/15/2021 10:09 AM, DENG Qingfang wrote:
> >>> Support port MDB and bridge flag operations.
> >>>
> >>> As the hardware can manage multicast forwarding itself, offload_fwd_mark
> >>> can be unconditionally set to true.
> >>>
> >>> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> >>> ---
> >>> Changes since RFC:
> >>>   Replaced BR_AUTO_MASK with BR_FLOOD | BR_LEARNING
> >>>
> >>>  drivers/net/dsa/mt7530.c | 124 +++++++++++++++++++++++++++++++++++++--
> >>>  drivers/net/dsa/mt7530.h |   1 +
> >>>  net/dsa/tag_mtk.c        |  14 +----
> >>>  3 files changed, 122 insertions(+), 17 deletions(-)
> >>>
> >>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> >>> index 2342d4528b4c..f765984330c9 100644
> >>> --- a/drivers/net/dsa/mt7530.c
> >>> +++ b/drivers/net/dsa/mt7530.c
> >>> @@ -1000,8 +1000,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
> >>>  	mt7530_write(priv, MT7530_PVC_P(port),
> >>>  		     PORT_SPEC_TAG);
> >>>  
> >>> -	/* Unknown multicast frame forwarding to the cpu port */
> >>> -	mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
> >>> +	/* Disable flooding by default */
> >>> +	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
> >>> +		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
> >>
> >> It's not clear to me why this is appropriate especially when the ports
> >> operated in standalone mode, can you expand a bit more on this?
> > 
> > We are in the function called "mt753x_cpu_port_enable" here. It's ok to
> > apply this config for the CPU port.
> 
> Because the user ports will flood unknown traffic and we have mediatek
> tags enabled presumably, so all traffic is copied to the CPU port, OK.

Actually this is just how Qingfang explained it:
https://patchwork.kernel.org/project/netdevbpf/patch/20210224081018.24719-1-dqfext@gmail.com/

I just assume that MT7530/7531 switches don't need to enable flooding on
user ports when the only possible traffic source is the CPU port - the
CPU port can inject traffic into any port regardless of egress flooding
setting. If that's not true, I don't see how traffic in standalone ports
mode would work after this patch.
