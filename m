Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E343333F97
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 14:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhCJNsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 08:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhCJNrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 08:47:48 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4C1C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 05:47:47 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id e19so38869964ejt.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 05:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=msVVtMlf9pKpfXqd+wH7oSL+c/vRPqAxgfYl+7wYbLo=;
        b=YHDCMnHJFmYylebZYNGCzWJchw7QoJLuYesinJJTqQZ5dk4puhl8uvB99w6WBgA3Bx
         zFqvYDqkSoV5aU0nMJslqQ7EP2+3RxSpEpzfTwzYAQXSnR+POblXMSVW4oO3KFHEwm6L
         2fskRLOdhel0yRUGv9TJH+5uQWNQ/6NRzecQUi2Q+mHliwe6qjpyfrf+Q39zPY1I5l4r
         6Xgc3qMLQyqKw5lo9zQrD31l1/oW5gSF52XZIlrPz7fHEo7dISN/kbnuzOXjRRD4LLpn
         hhoa7k+ZFL6f6rSVX/0aBiahpRiB01/e8tie/T9qd9TKMwmd9fjjbvDz4K+azqwIax3T
         H70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=msVVtMlf9pKpfXqd+wH7oSL+c/vRPqAxgfYl+7wYbLo=;
        b=mSu/ubYH/GIRvo5mYyP3XkXYC4VhN9RQlwS8FALVaL5lgfmMzhqaKQEK5HpAaRFBi3
         CzKKM1lF+T/11pFl6Wi/nAAceOQhVg6IfHqKtD7uOayb/p64jIi1dLfID8Konpv9s1tY
         hTMdmoc7O2AXIRU3evBPJn04xKfoAFZeBBhhwmgF3ppM8xgsUp3A+lo6nQu3DKo1K/iO
         DX0jftCQvjhS8wqmZuJZmqt9TERy8HU5UqB53Q2zPtthoZKIww6MygGrMHGdQXUVZbEG
         tLVP1R0ML52CjOo3C71ljV8wwA+ZeZEu2P3a17n82BlW0PEhkTEvcw0sKya4ZWUAzxJ8
         psbw==
X-Gm-Message-State: AOAM532NwOLv1jTGg+i1nbrxzj2rmlMm+JmtwYs3ceExdrNtP09H1vZO
        7MDIbBw2mLsvPrcQgbWyhGQ=
X-Google-Smtp-Source: ABdhPJzROeI96IPagG6NOhY7IaIwzXUcIL/OD30hopIDgSz7DHIg+JIDyUJCmk9RoggJGwQ2sP3ceg==
X-Received: by 2002:a17:906:1fd6:: with SMTP id e22mr3816266ejt.481.1615384066465;
        Wed, 10 Mar 2021 05:47:46 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v22sm10050498ejj.103.2021.03.10.05.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 05:47:46 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Wed, 10 Mar 2021 15:47:44 +0200
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 00/15] dpaa2-switch: CPU terminated traffic and
 move out of staging
Message-ID: <20210310134744.cjong4pnrfxld4hf@skbuf>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
 <YEi/PlZLus2Ul63I@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEi/PlZLus2Ul63I@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 01:44:46PM +0100, Greg KH wrote:
> On Wed, Mar 10, 2021 at 02:14:37PM +0200, Ioana Ciornei wrote:
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > 
> > This patch set adds support for Rx/Tx capabilities on DPAA2 switch port
> > interfaces as well as fixing up some major blunders in how we take care
> > of the switching domains. The last patch actually moves the driver out
> > of staging now that the minimum requirements are met.
> > 
> > I am sending this directly towards the net-next tree so that I can use
> > the rest of the development cycle adding new features on top of the
> > current driver without worrying about merge conflicts between the
> > staging and net-next tree.
> > 
> > The control interface is comprised of 3 queues in total: Rx, Rx error
> > and Tx confirmation. In this patch set we only enable Rx and Tx conf.
> > All switch ports share the same queues when frames are redirected to the
> > CPU.  Information regarding the ingress switch port is passed through
> > frame metadata - the flow context field of the descriptor.
> > 
> > NAPI instances are also shared between switch net_devices and are
> > enabled when at least on one of the switch ports .dev_open() was called
> > and disabled when no switch port is still up.
> > 
> > Since the last version of this feature was submitted to the list, I
> > reworked how the switching and flooding domains are taken care of by the
> > driver, thus the switch is now able to also add the control port (the
> > queues that the CPU can dequeue from) into the flooding domains of a
> > port (broadcast, unknown unicast etc). With this, we are able to receive
> > and sent traffic from the switch interfaces.
> > 
> > Also, the capability to properly partition the DPSW object into multiple
> > switching domains was added so that when not under a bridge, the ports
> > are not actually capable to switch between them. This is possible by
> > adding a private FDB table per switch interface.  When multiple switch
> > interfaces are under the same bridge, they will all use the same FDB
> > table.
> > 
> > Another thing that is fixed in this patch set is how the driver handles
> > VLAN awareness. The DPAA2 switch is not capable to run as VLAN unaware
> > but this was not reflected in how the driver responded to requests to
> > change the VLAN awareness. In the last patch, this is fixed by
> > describing the switch interfaces as Rx VLAN filtering on [fixed] and
> > declining any request to join a VLAN unaware bridge.
> 
> I'll take the first 14 patches now, and then you will have a "clean"
> place to ask for the movement of this out of staging.
> 

I was about to respond but it seems that you already applied them into
the staging tree. By the way, I was expecting a bit of review from the
netdev community since these changes are mainly to get the driver in a
proper state for the move.

Ok, I am mainly interested in getting all these patches into net-next as
well so that other general switchdev changes do not generate conflicts.

I assume that the next step would be to get acks from the netdev
maintainers especially on the last patch, merge the move in the staging
tree and then get all these changes into net-next through some kind of
cross-tree merge?

Ioana

