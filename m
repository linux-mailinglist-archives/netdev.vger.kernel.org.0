Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCC9641FC3
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 22:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiLDVP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 16:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLDVP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 16:15:56 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FE511A39;
        Sun,  4 Dec 2022 13:15:55 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id n20so23558760ejh.0;
        Sun, 04 Dec 2022 13:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N5myqd35peHqRERs7SmCBzUjy0wB0kxxoMubeKrt2TY=;
        b=ATY1DPJCFZqkeMnAEGSp93oAPvjniFLiMEYs88vBr9/r64UsR1p3BDUP5ffo3fmIa8
         c8rsTo6ENU18EL09G/IUgvFJ6FqKv7CsCN1vTSIOMEnuvX6fBD/kwm5Pjfey0daigRTS
         gdHkXYjgGEYg2joO5msm5DHP+L2iEduA09RZe4pdnOMMTjXAqNcmZF62j+K4OmJl7ICE
         KoDCGWxLrB7MmJ8KjEtawA1FXpGRBK5zF51y14YFotuPshhrXBNC2vwSFzzoLzb+Jmh2
         4NLj7ye3A05K52XSQdgrKczL64HNLoUDuZ92OL2NB1KBbWd0jhlmdhkhk5pwVLByvuls
         CX/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5myqd35peHqRERs7SmCBzUjy0wB0kxxoMubeKrt2TY=;
        b=pFCSZxzN5GXVMqzX7YmLWYpVpc+ht9rjcv34dIyfxs1HvOMIfFAnddAnJpzCx05nqg
         jrO4OHYVR2QmRlSFQZqWeovKVRrkV29mfvXBGy8QAjFh4rqIdN6bErcP8+v/EWWhRQKb
         32+q8f7711mqiKvJ0L5cwWRM/0yGF1xY3rIMMHZHrPQf1HYBbo9OKUf0fouwOZx3eGfH
         CSkx2yW1iqtLWhGX9heKnCRlSnrOedT9EOkW8MTFcX6PEmglgYPXVDUYsQ605R4mEsIC
         C/2DlR790YP6wQB9WaJKRR+6wUTVvZMWOHQt89I2GsarwDDDa/rfQphovQfEX+qjWYwX
         8UUw==
X-Gm-Message-State: ANoB5plVoiMY7cAmeCF8P5LT/X8Oe9NwQVWzwizfCL9tcaJ/FQ8G1yga
        I3eEicBpTBxVR+PXJ9OxvmA=
X-Google-Smtp-Source: AA0mqf4DRSiZgoJ3b9GddzakpIr3VKP2LhrCT0ROq909oX2idu93YHvR0ROf0XDAZWzAW8A6EVOO+g==
X-Received: by 2002:a17:907:591:b0:7c0:a997:2298 with SMTP id vw17-20020a170907059100b007c0a9972298mr15424761ejb.430.1670188553765;
        Sun, 04 Dec 2022 13:15:53 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709063d2900b0073d71792c8dsm5468226ejf.180.2022.12.04.13.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 13:15:53 -0800 (PST)
Date:   Sun, 4 Dec 2022 22:16:01 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     mkubecek@suse.cz
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 1/2] ethtool: update UAPI files
Message-ID: <Y40OEbeI3AuZ5hH2@gvm01>
References: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
 <0f7042bc6bcd59b37969d10a40e65d705940bee0.1670121214.git.piergiorgio.beruto@gmail.com>
 <Y4zVMj7rOkyA12uA@shell.armlinux.org.uk>
 <Y4zduT5aHd4vxQZL@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zduT5aHd4vxQZL@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Michal,
I was wondering if you could help me with the issue below.

In short, I'm trying to add a new feature to netlink / ethtool that
requires changes to the UAPI headers. I therefore need to update these
headers in the ethtool userland program as well.

The problem I'm having is that I don't know the procedure for updating
the headers, which is something I need to build my patch to ethtool on.

I understand now this is not a straight copy of the kernel headers to
the ethtool repository.

Should I use some script / procedure / else?
Or should I just post my patch without the headers? (I wonder how we can
verify it though?)

Any help on the matter would be very appreciated.

Kind Regards,
Piergiorgio

On Sun, Dec 04, 2022 at 06:49:45PM +0100, Andrew Lunn wrote:
> On Sun, Dec 04, 2022 at 05:13:22PM +0000, Russell King (Oracle) wrote:
> > On Sun, Dec 04, 2022 at 03:38:37AM +0100, Piergiorgio Beruto wrote:
> > 
> > NAK. No description of changes.
> 
> Hi Piergiorgio
> 
> Look at the previous examples of this:
> 
> commit 41fddc0eb01fcd8c5a47b415d3faecd714652513
> Author: Michal Kubecek <mkubecek@suse.cz>
> Date:   Mon Jun 13 23:50:26 2022 +0200
> 
>     update UAPI header copies
>     
>     Update to kernel v5.18.
>     
>     Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> 
> > > diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
> > > index 944711cfa6f6..5f414deacf23 100644
> > > --- a/uapi/linux/ethtool.h
> > > +++ b/uapi/linux/ethtool.h
> > > @@ -11,14 +11,16 @@
> > >   * Portions Copyright (C) Sun Microsystems 2008
> > >   */
> > >  
> > > -#ifndef _LINUX_ETHTOOL_H
> > > -#define _LINUX_ETHTOOL_H
> > > +#ifndef _UAPI_LINUX_ETHTOOL_H
> > > +#define _UAPI_LINUX_ETHTOOL_H
> 
> Maybe ask Michal Kubecek how he does this. It does not appear to be a
> straight copy of the headers.
> 
> 	 Andrew
