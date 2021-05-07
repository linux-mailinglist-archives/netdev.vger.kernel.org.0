Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC242376265
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhEGIwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhEGIwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:52:17 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A10CC061574;
        Fri,  7 May 2021 01:51:15 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l7so9317567edb.1;
        Fri, 07 May 2021 01:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v4OVEHXIUJUnnRCVPZ5jVMDub0uFCijk3eqlvzXzNlY=;
        b=N6IZWL7Tbl94Vsl0PYuGQu/0sKDx4Pkmbomo6tG5UzG311S4hlTLbjSYmqYGylVDo7
         mZfZAxHqXKLgf1TC19okBc1BCKUhb/u6/JNf8tJW1uF8vnY4C4qck8O68vX6eyLoMYGc
         osl1VjLsabDopM7o/LOh+7RrF1Y/0xu4pjP93Q2QWjz31PUMOeEB/pP5Bq+Nd4VvTaP5
         lWm6SFEKjtTT9WzkOTH2/SJQSfxl3hPDRoVMVw1zKOI+2qsPTuqtmaRppWR97+JDhpLt
         4bXsL+nudck+tyVv192w0uuGokArwRUkfvG0/B631uy9/7JYgjpUvimiabHw23ZTu7rE
         IlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v4OVEHXIUJUnnRCVPZ5jVMDub0uFCijk3eqlvzXzNlY=;
        b=R4WTyyHk/UjXPF0h7dzv8ino+mplwg+QLmmIJgpJlncHi0auWQztWq+/35f1SP7YdD
         0ZzK1lK4C8o56RrsiZ2iYEuqGAaLQBlw3uj5viNj2Y80OlpM/lwQcH/MRukDNXuyWrfL
         DgmPTg9khllGjo363S9oR8PN2VfRMnoggGWqo9niOT0vwU4/1AZm0U9UQLw+TIOmTwa7
         D43002Cz+f4iwEJ6PvPr87PyBkxPVct7yMph5QZv5JbAtAumY5p3rcPXQoLFjAcL3sbS
         uMy6FOgDCqmDHXDZniLnGBjb6waQE2mKUetkm/q9w55GMHaHjw+RVqdK3rQ7nXW4fiFI
         zHEw==
X-Gm-Message-State: AOAM530oqP2ObdWC4Iqf8NaF3x5lLCEwHGEBeesmS0LLQFqL9MCtmPXD
        xfb3f3762w7hh/eKtusWyVg=
X-Google-Smtp-Source: ABdhPJyAGzROKPTYcwlX/l6VKfiBPpjvoz7F0zgguQwZLfbIMdvFffJ9jTsiwUw8tvcBLznZCso22w==
X-Received: by 2002:a05:6402:6d4:: with SMTP id n20mr9895289edy.134.1620377473679;
        Fri, 07 May 2021 01:51:13 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id x7sm3030115ejc.116.2021.05.07.01.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 01:51:13 -0700 (PDT)
Date:   Fri, 7 May 2021 11:51:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 13/20] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <20210507085112.2n4dx5phgbjczc4r@skbuf>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-13-ansuelsmth@gmail.com>
 <20210506111033.w4v4jj3amwhyj4r3@skbuf>
 <YJRlYAOtFHaaIguW@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJRlYAOtFHaaIguW@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 11:53:36PM +0200, Ansuel Smith wrote:
> On Thu, May 06, 2021 at 02:10:33PM +0300, Vladimir Oltean wrote:
> > On Wed, May 05, 2021 at 12:29:07AM +0200, Ansuel Smith wrote:
> > > The legacy qsdk code used a different delay instead of the max value.
> > > Qsdk use 1 ps for rx and 2 ps for tx. Make these values configurable
> > > using the standard rx/tx-internal-delay-ps ethernet binding and apply
> > > qsdk values by default. The connected gmac doesn't add any delay so no
> > > additional delay is added to tx/rx.
> > > 
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > ---
> > >  drivers/net/dsa/qca8k.c | 51 +++++++++++++++++++++++++++++++++++++++--
> > >  drivers/net/dsa/qca8k.h | 11 +++++----
> > >  2 files changed, 55 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > > index 22334d416f53..cb9b44769e92 100644
> > > --- a/drivers/net/dsa/qca8k.c
> > > +++ b/drivers/net/dsa/qca8k.c
> > > @@ -779,6 +779,47 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
> > >  	return 0;
> > >  }
> > >  
> > > +static int
> > > +qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
> > > +{
> > > +	struct device_node *ports, *port;
> > > +	u32 val;
> > > +
> > > +	ports = of_get_child_by_name(priv->dev->of_node, "ports");
> > 
> > Consider falling back to searching for the "ethernet-ports" name too,
> > DSA should now support both.
> >
> 
> The function qca8k_setup_mdio_bus also checks for ports node. Should I
> also there the fallback correct?

Yes, ideally the entire driver should work fine with "ethernet-ports"
and not just pieces of it.
