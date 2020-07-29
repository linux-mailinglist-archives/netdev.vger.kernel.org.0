Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CCA2326A1
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgG2VLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgG2VLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:11:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D029206D4;
        Wed, 29 Jul 2020 21:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596057080;
        bh=wtkGbGxbhVZMyldtal6tTzTwU0JwVbA3bYw42/D3B8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IxVF08G0I8v/o0Qu3gUdv6gJSfvIvBLA3zqx8cMQucC6nnMhAgqv8IFFjeGeJgq4y
         R3vZ/DLYdqK31OoAunLXz75rJ7psxqvFeuV/0EdbEZADWZRGpPHeqUUsIZPyepbdpC
         Rvo/wAzq2GBCsVn05D94K9gnFUSwbJ0F56uaqSc0=
Date:   Wed, 29 Jul 2020 14:11:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC 02/13] devlink: Add reload levels data to
 dev get
Message-ID: <20200729141117.0425ad12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <448bab04-80d7-b3b1-5619-1b93ad7517d8@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
        <1595847753-2234-3-git-send-email-moshe@mellanox.com>
        <20200727175842.42d35ee3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <448bab04-80d7-b3b1-5619-1b93ad7517d8@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jul 2020 17:37:41 +0300 Moshe Shemesh wrote:
> > The fact that the driver supports fw_live_patch, does not necessarily
> > mean that the currently running FW can be live upgraded to the
> > currently flashed one, right?  
> 
> That's correct, though the feature is supported, the firmware gap may 
> not be suitable for live_patch.
> 
> The user will be noted accordingly by extack message.

That's kinda late, because use may have paid the cost of migrating the
workload or otherwise taking precautions - and if live reset fails all
this work is wasted.

While the device most likely knows upfront whether it can be live reset
or not, otherwise I don't see how it could reject the reset reliably.

> > This interface does not appear to be optimal for the purpose.
> >
> > Again, documentation of what can be lost (in terms of configuration and
> > features) upon upgrade is missing.  
> 
> I will clarify in documentation. On live_patch nothing should be lost or 
> re-initialized, that's the "live" thing.

Okay, so FW upgrade cannot be allowed when it'd mean the device gets
de-featured? Also no link loss, correct? What's the expected length of
traffic interruption (order of magnitude)?
