Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C03334B3C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 23:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhCJWMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 17:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbhCJWMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 17:12:41 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134EBC061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 14:12:41 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id jt13so41995256ejb.0
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 14:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yRH6K12szUbt2s0Hkf1hkk9WSQ/zw0DkHONjRxFY1aI=;
        b=MtwfMepBnHzWZMeJbL0yqkDHJtcTN1VOBq4dEMXU27e2Cayng/G3cO2Jv7hIKWwDlt
         9ijSWpMUvf8ptkg0tbGyrp6cD2qFh6Rq6FqKe8dytj2uM/hdr1rcYg55yuDLOnPA60iF
         BuhXDQ+TrwQtlx2RoRDk3buGHlb9Weov61ROmHZFJ2y7FCW7xk86zlHre89kqxs+I8lG
         cf47h5eGm8Qk9FVrfY7FUwQaetDuC8xTEXSZmvIDSacfKVE0KeiPpB3CJCqkYFKcusHw
         9jQXoOmcXRHImQX3cccIn5SFxIptTfRswpHWENuUnbcFoJmFpgUike154YpcllsEGauU
         1/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yRH6K12szUbt2s0Hkf1hkk9WSQ/zw0DkHONjRxFY1aI=;
        b=TTXaiKY3kX8bKS8Cy6ZhakzIiQCJpRKSl+rLFHDB14bUXT+0G5BxgpXfi6WPzKVTNA
         QY3Sw/tk4KQlFBddJ5C6VgnBMREcVNAyRgOdN77Djrlg6d2+IasCZaVfSo84VtuBp/BG
         3EpZRpjPdOdLkvoFXKYbqZZ80WOJlQBr7ibX3h+GMQ1nhlcCGHNKwD7dyl6Y8Wa1cb5+
         HwYor4diODn+sH0k8xTDjOEWSAivNmBwQS00W5lnqoFW62rXsgs85bmLyMOE9mi2aEPv
         5pWo4W+BgYYcLGsZVqB3pTxcIgE9AM2TZfP56Uj5GVO7gPWHSh5SqSBaMToZI8h4dd9L
         I2Zg==
X-Gm-Message-State: AOAM533AI3LXHOQ7DupM3sGBM9ELTq33JwGkOaoK2pu/54reD66acThK
        On4J0YOso4AcF6bmWypNkOA=
X-Google-Smtp-Source: ABdhPJzuHwSA/Hz2kcramDtQ/l/D0xwuOGKuBoVwpifhc703MENF0xMZ0fvsXpNE8mWUgRrK3bzZoA==
X-Received: by 2002:a17:906:3c18:: with SMTP id h24mr50506ejg.435.1615414359833;
        Wed, 10 Mar 2021 14:12:39 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id gj26sm338092ejb.67.2021.03.10.14.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:12:39 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 11 Mar 2021 00:12:37 +0200
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 00/15] dpaa2-switch: CPU terminated traffic and
 move out of staging
Message-ID: <20210310221237.nftr4d6kwfrhi34z@skbuf>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
 <YEi/PlZLus2Ul63I@kroah.com>
 <20210310134744.cjong4pnrfxld4hf@skbuf>
 <YEjT6WL9jp3HCf+w@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEjT6WL9jp3HCf+w@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 03:12:57PM +0100, Greg KH wrote:
> On Wed, Mar 10, 2021 at 03:47:44PM +0200, Ioana Ciornei wrote:
> > On Wed, Mar 10, 2021 at 01:44:46PM +0100, Greg KH wrote:
> > > On Wed, Mar 10, 2021 at 02:14:37PM +0200, Ioana Ciornei wrote:
> > > > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > 
> > > > This patch set adds support for Rx/Tx capabilities on DPAA2 switch port
> > > > interfaces as well as fixing up some major blunders in how we take care
> > > > of the switching domains. The last patch actually moves the driver out
> > > > of staging now that the minimum requirements are met.
> > > > 
> > > > I am sending this directly towards the net-next tree so that I can use
> > > > the rest of the development cycle adding new features on top of the
> > > > current driver without worrying about merge conflicts between the
> > > > staging and net-next tree.
> > > > 
> > > > The control interface is comprised of 3 queues in total: Rx, Rx error
> > > > and Tx confirmation. In this patch set we only enable Rx and Tx conf.
> > > > All switch ports share the same queues when frames are redirected to the
> > > > CPU.  Information regarding the ingress switch port is passed through
> > > > frame metadata - the flow context field of the descriptor.
> > > > 
> > > > NAPI instances are also shared between switch net_devices and are
> > > > enabled when at least on one of the switch ports .dev_open() was called
> > > > and disabled when no switch port is still up.
> > > > 
> > > > Since the last version of this feature was submitted to the list, I
> > > > reworked how the switching and flooding domains are taken care of by the
> > > > driver, thus the switch is now able to also add the control port (the
> > > > queues that the CPU can dequeue from) into the flooding domains of a
> > > > port (broadcast, unknown unicast etc). With this, we are able to receive
> > > > and sent traffic from the switch interfaces.
> > > > 
> > > > Also, the capability to properly partition the DPSW object into multiple
> > > > switching domains was added so that when not under a bridge, the ports
> > > > are not actually capable to switch between them. This is possible by
> > > > adding a private FDB table per switch interface.  When multiple switch
> > > > interfaces are under the same bridge, they will all use the same FDB
> > > > table.
> > > > 
> > > > Another thing that is fixed in this patch set is how the driver handles
> > > > VLAN awareness. The DPAA2 switch is not capable to run as VLAN unaware
> > > > but this was not reflected in how the driver responded to requests to
> > > > change the VLAN awareness. In the last patch, this is fixed by
> > > > describing the switch interfaces as Rx VLAN filtering on [fixed] and
> > > > declining any request to join a VLAN unaware bridge.
> > > 
> > > I'll take the first 14 patches now, and then you will have a "clean"
> > > place to ask for the movement of this out of staging.
> > > 
> > 
> > I was about to respond but it seems that you already applied them into
> > the staging tree. By the way, I was expecting a bit of review from the
> > netdev community since these changes are mainly to get the driver in a
> > proper state for the move.
> 
> They are only in my "testing" branch, I can easily drop them right now
> if you want me to.

Well, it seems that I added some checks at the last minute, forgot to
compile-test patch by patch and the checks were added too early in the
series therefore it fails to build now on patches 10 and 11.

Could you please just drop this so that that I can respin them with that
addressed as well as any other review feedback?

Ioana

