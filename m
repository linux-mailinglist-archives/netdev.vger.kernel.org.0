Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C17B23AE5F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgHCUpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgHCUpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:45:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C1602086A;
        Mon,  3 Aug 2020 20:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596487552;
        bh=ewwsrZXrd6GoX4zZrGFLSRzVS3MLfltjGD/S39tlmv8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RP/sNO+SuH3q6wrGWLPiLO2LnX5R3qsG/o6y/KLryUxntYFpc4YUiIVZ+GuzIy2j9
         YMRgS+IXYoBk3wjlG9/oXr6/+KbuTqm19KghELizftwvJw+iUbAOcq6q5exZVbsm2F
         tONJUoTPvRZC4olyD0Zh1UlHDEKpBQzrnJ5gSHWg=
Date:   Mon, 3 Aug 2020 13:45:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wang, Haiyue" <haiyue.wang@intel.com>
Cc:     Tom Herbert <tom@herbertland.com>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>,
        "Liang, Cunming" <cunming.liang@intel.com>
Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Message-ID: <20200803134550.7ec625ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BN8PR11MB3795FA12407090A2D95F97C6F74D0@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
        <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8026dce002758d509b310afa330823be0c8191ec.camel@intel.com>
        <20200722180705.23196cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALx6S36K0kES3b7dWmyigpSLgBmU2jf7FfCSYXBFOeBJkbQ+rw@mail.gmail.com>
        <20200727160406.4d2bc1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795FA12407090A2D95F97C6F74D0@BN8PR11MB3795.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Aug 2020 10:39:52 +0000 Wang, Haiyue wrote:
> > In this case, I'm guessing, Intel can reuse RTE flow -> AQ code written
> > to run on PFs on the special VF.
> > 
> > This community has selected switchdev + flower for programming flows.
> > I believe implementing flower offloads would solve your use case, and
> > at the same time be most beneficial to the netdev community.  
> 
> Jakub,
> 
> Thanks, I deep into the switchdev, it is kernel software bridge for hardware
> offload, and each port is registered with register_netdev. So this solution
> is not suitable for current case: VF can be assigned to VMs.

You may be missing the concept of a representor.

Sridhar from Intel was investigating this, I believe, at some point.
Perhaps sync with him?
