Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E392A846E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 18:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731499AbgKERH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 12:07:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730447AbgKERH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 12:07:26 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2526B206F9;
        Thu,  5 Nov 2020 17:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604596045;
        bh=92lLMj3nZ+N80CAl49XYHHRZncQilSNLr8At/FZYmG0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V4iRWI/uRwYIlE3yQWmTv24k93/ER7T3e9KMcwtpupCCewDT4RnmAaE9klQKguN5A
         Vfzddx8q4BkW82YTQ0jiuIk+AS/e6KKho1TFo9x5v2JQIItUIYvDOcVnPNVNTSvDR9
         BVT8uIBVTdeIUZM6rYBn7+A1eYMwtqK1L1sqGTv0=
Date:   Thu, 5 Nov 2020 09:07:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Cherian <gcherian@marvell.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-af: Add devlink health
 reporters for NIX
Message-ID: <20201105090724.761a033d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BYAPR18MB2679EC3507BD90B93B37A3F8C5EE0@BYAPR18MB2679.namprd18.prod.outlook.com>
References: <BYAPR18MB2679EC3507BD90B93B37A3F8C5EE0@BYAPR18MB2679.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 13:36:56 +0000 George Cherian wrote:
> > Now i am a little bit skeptic here, devlink health reporter infrastructure was
> > never meant to deal with dump op only, the main purpose is to
> > diagnose/dump and recover.
> > 
> > especially in your use case where you only report counters, i don't believe
> > devlink health dump is a proper interface for this.  
> These are not counters. These are error interrupts raised by HW blocks.
> The count is provided to understand on how frequently the errors are seen.
> Error recovery for some of the blocks happen internally. That is the reason,
> Currently only dump op is added.

The previous incarnation was printing messages to logs, so I assume
these errors are expected to be relatively low rate.

The point of using devlink health was that you can generate a netlink
notification when the error happens. IOW you need some calls to
devlink_health_report() or such.

At least that's my thinking, others may disagree.
