Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514371B33CC
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 02:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDVAGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 20:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgDVAGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 20:06:43 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72306C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 17:06:42 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id y19so90503qvv.4
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 17:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WYy7G32x1Q5njrkNj7u8nyAGK+dMK8HXv1g8Lbf3Ifo=;
        b=GM+sMUt+ymjWe6jHxY3XQ9LTMg5FiNwixWJNmRg1W7Lw9I7fR6g9IUFJK798L8iKIT
         oyO3V1aahQ6JmrL1rGyVvqJR499QywP2ZAOKdAZqka9e/M4/ZsHmLqTQzE9v144kCEER
         sVzXaJNMUd2D+KJ2FO1GIEwOKQO85xfWGlVeSqPUhcs25NSO62E1RxyRylVtm8SMFz1r
         QaeHJsb33C7KfYSle7ToCeXRtMuxFBOuROq/sRbL/doef7g3NqQZhcqtk2H75hjAZDzE
         6O5JnX0E1qco6ThLTapjPuJqferIReYF9X0ldLhb/MwSiKftS1gTHuMwqRPXq5sAvxfz
         c7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WYy7G32x1Q5njrkNj7u8nyAGK+dMK8HXv1g8Lbf3Ifo=;
        b=hJGsACErJXN7uXcxGBvhEQyhoQpULjcuRCjLCfal3hvFp5/Qmxn41Sg4hv/a0U/X3R
         GBD9CWWT4qfRYGhLO0ru+jxKKG9pN8wU2daqU+s/cwcP6wSlX7arDz74fzipvzbiCaPb
         I5wAMLqNERU9ouGppxS1RryHwXX6wJZTiLshbfu84VI1x6mCFrFEbqiZNiH/VJbsx9uz
         ehsn/lJHNy/q917+WdsxWCNh8bbXIyKglXwKpoyk4Y2HdRmXVsisYFkJcF2ENE9Z0G9N
         +xD3Gwt60iL++QCxcelwwPnU6bNgkTKhtir+X5e5RNJzGyXywjdJOjE/B+dfKgPl0AH3
         qlAA==
X-Gm-Message-State: AGi0Puahsg4+04OyXrALyUOFq3uG4aV7m577rcDcWFNZyF4wpRek47+v
        /P0+ku7NzdI1onAHhrbbaj5l4Q==
X-Google-Smtp-Source: APiQypJ8NlNdXfOCEKcYh/wkIuZPqvWZ3Eefro6kyW6+LN421MQeAhozKTaGJY5ur5ou26JDYZ6gfw==
X-Received: by 2002:ad4:49d3:: with SMTP id j19mr21605317qvy.78.1587514001680;
        Tue, 21 Apr 2020 17:06:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id y72sm2741779qkb.86.2020.04.21.17.06.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Apr 2020 17:06:41 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jR2uW-0008CT-Ek; Tue, 21 Apr 2020 21:06:40 -0300
Date:   Tue, 21 Apr 2020 21:06:40 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
 definitions
Message-ID: <20200422000640.GU26002@ziepe.ca>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-13-jeffrey.t.kirsher@intel.com>
 <20200417203216.GH3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD485B7@fmsmsx124.amr.corp.intel.com>
 <20200421073044.GI121146@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4C042@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD4C042@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 12:02:14AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
> > definitions
> > 
> 
> [...]
> > > > > + * irdma_arp_table -manage arp table
> > > > > + * @rf: RDMA PCI function
> > > > > + * @ip_addr: ip address for device
> > > > > + * @ipv4: IPv4 flag
> > > > > + * @mac_addr: mac address ptr
> > > > > + * @action: modify, delete or add  */ int irdma_arp_table(struct
> > > > > +irdma_pci_f *rf, u32 *ip_addr, bool ipv4,
> > > > > +		    u8 *mac_addr, u32 action)
> > > >
> > > > ARP table in the RDMA driver looks strange, I see that it is legacy
> > > > from i40iw, but wonder if it is the right thing to do the same for the new driver.
> > > >
> > >
> > > See response in Patch #1.
> > 
> > OK, let's me rephrase the question.
> > Why can't you use arp_tbl from include/net/arp.h and need to implement it in the
> > RDMA driver?
> > 
> 
> The driver needs to track the on-chip arp cache indices and program the
> index & entry via rdma admin queue cmd. These indices are specific to our hw
> arp cache and not the system arp table. So I am not sure how we can use it.

Why does an RDMA device respond to ARPs? Or do you mean this
synchronizes the neighbour table so the HW knows the MAC? This is for
iwarp only then?

Jason
