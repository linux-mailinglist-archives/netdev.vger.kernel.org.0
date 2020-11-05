Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530E72A7CD3
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 12:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgKELXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 06:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgKELXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 06:23:01 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124F3C0613CF;
        Thu,  5 Nov 2020 03:23:01 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id 7so2107812ejm.0;
        Thu, 05 Nov 2020 03:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wNkTbLtgTkgkkwaoSGq4NvVRmI6B4VMBCAOlXrDC7QI=;
        b=Qd7hxCdbA5cftuIXF4iuhYJNaqsn+6RmN4/oEpjdIWdXF/axEOKcwizmcG+rSGvRvn
         fwlKPAlaMZoX+ct0lGfDGMS+oTRESZ1miFc8Xs8UpPe8Kg3SnCQEhvT52wev+BYSK6g9
         l/fnp7z1UBUHKbaqLEXaMgOKg/dYQJnV3j84tncM7I6nV2dvcotW9UZI0BB3LL9PynYC
         4yMR2gauRFCLp8uKbmD9maQEqANqP+KnkY29b5kyk26yqIdNOlTnqljSQu1WPMT+m9zs
         boOAQ6p9Lov3ScSmUiYFEJUSoYeVYw0dvIKyShpxal8U9Q0BSzAtlYG79XvYoH+ZHWAh
         ppjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wNkTbLtgTkgkkwaoSGq4NvVRmI6B4VMBCAOlXrDC7QI=;
        b=EboXoapp2aiRPIqgUALW4gFluSGSvAGJsJKDJwLVKbwrAsnOoxiB7bFqi2wkohFn9K
         jP5otdNepOGmdoJAILak6biSnc4zBk+Y/ZktSvQ5TjZHLESaZr4vxeydzpOXkj+qe1pP
         F91NTy7rRV2qd+SYoM6eB1YpILrHVQxbDFd2y2J43LjGcg/4OgdIiMNnZ7nGp8PeZlul
         fzOxT4jdiqie0gDrP/UEhMaYKighumhB+f8D3D4mig4mQEDSw5tzTZ1MpiLoyU3ehsMV
         9LDSj3gmCH4QqsWN1Hx3Pgs8Y82XM/dMuWg0t99UEaMJOXArce4Xu1MuUhl6HT2Hq3kX
         rxBw==
X-Gm-Message-State: AOAM530rsUOFZL/CGfFieH9epD2fCwoieOBqeFjgceThZKUjrc7cGiq/
        I+Utlq3tNp1WYHitO51svjE=
X-Google-Smtp-Source: ABdhPJxp3DxDOEGh9l3/p1vbrMhDkbEnqT6kfRg6eISqxHGZD+4xtRD2vHMPIWH2Ln5BWUL/cBNOKA==
X-Received: by 2002:a17:906:c206:: with SMTP id d6mr1684783ejz.239.1604575379746;
        Thu, 05 Nov 2020 03:22:59 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id e9sm685614edn.30.2020.11.05.03.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 03:22:59 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 5 Nov 2020 13:22:58 +0200
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC 5/9] staging: dpaa2-switch: handle Rx path on control
 interface
Message-ID: <20201105112258.sgbr2fq66u47vokr@skbuf>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
 <20201104165720.2566399-6-ciorneiioana@gmail.com>
 <20201105004516.GG933237@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105004516.GG933237@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 01:45:16AM +0100, Andrew Lunn wrote:
> > +/* Manage all NAPI instances for the control interface.
> > + *
> > + * We only have one RX queue and one Tx Conf queue for all
> > + * switch ports. Therefore, we only need to enable the NAPI instance once, the
> > + * first time one of the switch ports runs .dev_open().
> > + */
> > +
> > +static void dpaa2_switch_enable_ctrl_if_napi(struct ethsw_core *ethsw)
> > +{
> > +	int i;
> > +
> > +	/* a new interface is using the NAPI instance */
> > +	ethsw->napi_users++;
> > +
> > +	/* if there is already a user of the instance, return */
> > +	if (ethsw->napi_users > 1)
> > +		return;
> 
> Does there need to be any locking here? Or does it rely on RTNL?
> Maybe a comment would be nice, or a check that RTNL is actually held.
> 

It relies on the RTNL. I'll add an assert on the RTNL lock and a comment
to go with that.

> > +
> > +	if (!dpaa2_switch_has_ctrl_if(ethsw))
> > +		return;
> > +
> > +	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
> > +		napi_enable(&ethsw->fq[i].napi);
> > +}
> 
> > +static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
> > +			    const struct dpaa2_fd *fd)
> > +{
> > +	struct ethsw_core *ethsw = fq->ethsw;
> > +	struct ethsw_port_priv *port_priv;
> > +	struct net_device *netdev;
> > +	struct vlan_ethhdr *hdr;
> > +	struct sk_buff *skb;
> > +	u16 vlan_tci, vid;
> > +	int if_id = -1;
> > +	int err;
> > +
> > +	/* prefetch the frame descriptor */
> > +	prefetch(fd);
> 
> Does this actually do any good, given that the next call:
> 
> > +
> > +	/* get switch ingress interface ID */
> > +	if_id = upper_32_bits(dpaa2_fd_get_flc(fd)) & 0x0000FFFF;
> 
> is accessing the frame descriptor? The idea of prefetch is to let it
> bring it into the cache while you are busy doing something else,
> hopefully with something which is already cache hot.
> 

I'll check w and w/o the prefetch but, most probably, it doesn't help.
Thanks.

Ioana
