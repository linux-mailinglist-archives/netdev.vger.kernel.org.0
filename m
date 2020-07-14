Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C27E21F936
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgGNSYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:32870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgGNSYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 14:24:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B9A223C6;
        Tue, 14 Jul 2020 18:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594751063;
        bh=to57dTBa4CcYcLuyl7Nu7iniMj78qR4k2P1LMQf5ClI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BIrKK45Ys7qtMVlcIZwhuxY5GjpfNJPOwpW8aS5Hcc7WNw0hTVOzH+U4jJdo1C3ZT
         5TRopj7DC0SD1Q4voX73M/+ywTlhwPFsmYr597r+v9gEfA+KI4WtlIlcr4pxoV6jmy
         0N8dIM3sEwavZeaxRcUTbEmTmshpLl2oZ4paWYyU=
Date:   Tue, 14 Jul 2020 11:24:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wang, Haiyue" <haiyue.wang@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Message-ID: <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
        <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 01:29:40 +0000 Wang, Haiyue wrote:
> > On Mon, 13 Jul 2020 10:43:16 -0700 Tony Nguyen wrote:  
> > > From: Haiyue Wang <haiyue.wang@intel.com>
> > >
> > > The DCF (Device Config Function) is a named trust VF (always with ID 0,
> > > single entity per PF port) that can act as a sole controlling entity to
> > > exercise advance functionality such as adding switch rules for the rest
> > > of VFs.  
> > 
> > But why? This looks like a bifurcated driver to me.
> 
> Yes, like bifurcated about flow control. This expands Intel AVF virtual channel
> commands, so that VF can talk to hardware indirectly, which is under control of
> PF. Then VF can set up the flow control for other VFs. This enrich current PF's
> Flow Director filter for PF itself only by ethtool. 

Could you say a little more about the application and motivation for
this?

We are talking about a single control domain here, correct?
