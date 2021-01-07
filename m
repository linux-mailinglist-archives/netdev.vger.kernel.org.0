Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771B82ED56A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbhAGRVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:21:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbhAGRVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:21:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD3F222C9F;
        Thu,  7 Jan 2021 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610040068;
        bh=U3BrOqsRFBQkm0dtMKf9zcqCsXLNHe/WlIE5FaVmUQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=azYC9bwqvi4NGWd7GDsUUT2HSkwXsej1S+VSAC4A1koUMIJXbZSFtrKxUERfnuQ8Y
         etlco3iF2k29MSD7oyCb06hkBYMSivhyB97dsT0sEqZvZjwO6l0eRXZl9sON+uid1I
         WqccUa6fGQDwvxioOUcwKen90Cva3W1rL4yGEeIowBdDA+PQWoFU73gOquz0Jy0Ykj
         CEL5HvlaAcnW5RZVEsMGbh0RlNCBvAq6QVnXzpCNtvRhlfd72/RDD+eHj8GLzacQW4
         ijnGZUeNNF2zvH9SJ3TlfPeBAdgG8LhZQEBywrA4TCpbTD1P23ukkEvSkhwCdxb8iv
         QqjpMNi2YpRvw==
Date:   Thu, 7 Jan 2021 09:21:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Doug Berger <opendmb@gmail.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Timur Tabi <timur@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH net-next 2/2] net: broadcom: share header defining
 UniMAC registers
Message-ID: <20210107092106.012e6721@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <362ccb19-8f58-6bb6-a49b-c9eea93a5366@gmail.com>
References: <20210106073245.32597-1-zajec5@gmail.com>
        <20210106073245.32597-2-zajec5@gmail.com>
        <284cc000-edf1-e943-2531-8c23e9470de1@gmail.com>
        <ed92d6bd-0d07-afbb-6b53-23180a5abae9@gmail.com>
        <362ccb19-8f58-6bb6-a49b-c9eea93a5366@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 09:14:17 -0800 Florian Fainelli wrote:
> > I can reproduce that after switching from mips to arm64. Before this
> > change bgmac.h was not using BIT() macro. Now it does and that macro
> > forces UL (unsigned long).
> > 
> > Is there any cleaner solution than below one?  
> 
> Don't use BIT(), if the constants are 32-bit unsigned integer, maybe
> open coding them as (1 << x) is acceptable for that purpose.

No objections from my side, I think we already have a number of drivers
open coding the shifts for that very reason already.
