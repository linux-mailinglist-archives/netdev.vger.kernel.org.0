Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3637D57CDD9
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiGUOjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiGUOjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:39:03 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8881C8689A
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:39:01 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id f9so1321820qvr.2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kwW27VCQ4+JlDB+iPSDhz5O1D0eurbd7dKtxO/dfIvY=;
        b=OnzKBTMKPt8ybqoDKEizFWOIZUwtYD8NVniERJQRrRBD+FC+PRdDYfR9tAPu3M63Wt
         JG3TqJzUoWvMaF0pCE36eey30fVsLVvODRU/er7wla8BCkhleJfMm7QLgdvrEynQfv7f
         D64FKivghTNDU7lIbls+9rYw7bof/BUsEQ8+fzzuudi9b3k4wY3SXlIAk/SxIJOZJVCQ
         TzeoL49vw0ePEWJOK2s1Tu0Tc1DJW173uCXzh3pS7Xigojqp5Ood6OfscacTHVee07jq
         YdRhUB07YqVnhDr/fzI+/qAYhFgZvJyL8yNAyD2VsfUeuUe52gn2DhlXweRSZoq+fOeV
         FLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kwW27VCQ4+JlDB+iPSDhz5O1D0eurbd7dKtxO/dfIvY=;
        b=VzOio07mKUzC8a8riHJY7wYcb6jaouFMx3K25nuaDQdsAF9mXDAMN0fAZt04k04mqB
         SE3QZG9IJsYkncdbGlNOPG/bTXKqB/N+8m9nr48UuEYzvwqGeDC1cOz9IiUGL+2CKqBZ
         9MiwniSHtJ0BrfQYohHTOSG93ynDFMmtQr91m9PCATkBnZDHayOBy8z2di2hiPVh3QdR
         j+rW3jsX2lUmRld4cZ5v8Lavc9lDRlZb6thtco54V0Vm40jXrw54TxuJ6nWOsRDARMy7
         tDo8lvQEVU1oOZtevXPedeWDEAmhn+EP1mVIrM1Gp3XtTpumTAKHfYmCKJ9YDRD3c/i2
         0Sbw==
X-Gm-Message-State: AJIora+tPBZYjx2g6UsOi/basOw5064etIFHsFMqr33eoHhEt9qxSOPQ
        +FPxJy/1L0LlfOLG+ETXjBfiZA==
X-Google-Smtp-Source: AGRyM1uWQJMIGs0cFKjzk6jOPxy6nU58JEm7wrsssEUVgVK/vH4DFVTrvRD0ZbRcmdLePWGA232yJQ==
X-Received: by 2002:ad4:4ea2:0:b0:473:6d91:6759 with SMTP id ed2-20020ad44ea2000000b004736d916759mr34926483qvb.102.1658414340714;
        Thu, 21 Jul 2022 07:39:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id e19-20020a05620a12d300b006b5905999easm1403705qkl.121.2022.07.21.07.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:38:59 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1oEXKM-001wqY-N5; Thu, 21 Jul 2022 11:38:58 -0300
Date:   Thu, 21 Jul 2022 11:38:58 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Long Li <longli@microsoft.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Message-ID: <20220721143858.GV5049@ziepe.ca>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220720234209.GP5049@ziepe.ca>
 <PH7PR21MB3263F5FD2FA4BA6669C21509CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB3263F5FD2FA4BA6669C21509CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 12:06:12AM +0000, Long Li wrote:
> > Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing between
> > devices
> > 
> > On Tue, Jul 12, 2022 at 06:48:09PM +0000, Long Li wrote:
> > > > > @@ -563,9 +581,19 @@ static int mana_cfg_vport(struct
> > > > > mana_port_context *apc, u32 protection_dom_id,
> > > > >
> > > > >  	apc->tx_shortform_allowed = resp.short_form_allowed;
> > > > >  	apc->tx_vp_offset = resp.tx_vport_offset;
> > > > > +
> > > > > +	netdev_info(apc->ndev, "Configured vPort %llu PD %u DB %u\n",
> > > > > +		    apc->port_handle, protection_dom_id, doorbell_pg_id);
> > > > Should this be netdev_dbg()?
> > > > The log buffer can be flooded if there are many vPorts per VF PCI
> > > > device and there are a lot of VFs.
> > >
> > > The reason netdev_info () is used is that this message is important
> > > for troubleshooting initial setup issues with Ethernet driver. We rely
> > > on user to get this configured right to share the same hardware port
> > > between Ethernet and RDMA driver. As far as I know, there is no easy
> > > way for a driver to "take over" an exclusive hardware resource from
> > > another driver.
> > 
> > This seems like a really strange statement.
> > 
> > Exactly how does all of this work?
> > 
> > Jason
> 
> "vport" is a hardware resource that can either be used by an
> Ethernet device, or an RDMA device. But it can't be used by both at
> the same time. The "vport" is associated with a protection domain
> and doorbell, it's programmed in the hardware. Outgoing traffic is
> enforced on this vport based on how it is programmed.

Sure, but how is the users problem to "get this configured right" and
what exactly is the user supposed to do?

I would expect the allocation of HW resources to be completely
transparent to the user. Why is it not?

Jason
