Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA64AE4119
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 03:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389094AbfJYBgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 21:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730006AbfJYBgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 21:36:01 -0400
Received: from localhost (unknown [38.98.37.136])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C98E2064A;
        Fri, 25 Oct 2019 01:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571967360;
        bh=XCeKzecQIIglaoewbYNc46ewGAE4hVfr2+RHbU9+vYQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r+Q77euabKymHctLCq2nDvGJO/eq3v2ABu1U3TB6/uXAXMqOvefrA9OaRhaQBJ7S/
         e3UT4vSQbdZVgS1WDSTbc6tP2lfTdzuF4A0JENpSXd0LTxAFHYybaAF68sjlEIRAHp
         YX9zrd8UL2E9vUN46fsK0+H4a43Z59fo4Wle5nbo=
Date:   Thu, 24 Oct 2019 21:30:48 -0400
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Message-ID: <20191025013048.GB265361@kroah.com>
References: <20190926180556.GB1733924@kroah.com>
 <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
 <20190927051320.GA1767635@kroah.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
 <20191023174448.GP23952@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E0C84@ORSMSX101.amr.corp.intel.com>
 <20191023180108.GQ23952@ziepe.ca>
 <20191024185659.GE260560@kroah.com>
 <20191024191037.GC23952@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E1D29@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2B0E3F215D1AB84DA946C8BEE234CCC97B2E1D29@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 10:25:36PM +0000, Ertman, David M wrote:
> The direct access of the platform bus was unacceptable, and the MFD sub-system
> was suggested by Greg as the solution.  The MFD sub-system uses the platform
> bus in the background as a base to perform its functions, since it is a purely software
> construct that is handy and fulfills its needs.  The question then is:  If the MFD sub-
> system is using the platform bus for all of its background functionality, is the platform
> bus really only for platform devices?

Yes, how many times do I have to keep saying this?

The platform bus should ONLY be used for devices that are actually
platform devices and can not be discovered any other way and are not on
any other type of bus.

If you try to add platform devices for a PCI device, I am going to
continue to complain.  I keep saying this and am getting tired.

Now yes, MFD does do "fun" things here, and that should probably be
fixed up one of these days.  But I still don't see why a real bus would
not work for you.

greg "platform devices are dead, long live the platform device" k-h
