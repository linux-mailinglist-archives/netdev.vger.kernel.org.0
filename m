Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFD12C453C
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731918AbgKYQaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730619AbgKYQaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 11:30:22 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C35020857;
        Wed, 25 Nov 2020 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606321821;
        bh=imD1M4w5xL8W2jbuomVFJA7hCMeUik6meIjJybSjeAM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ADAsbDPntmpzkAR/QlIO4hlWtdtnsv+gqSFx35DTLVVV1I7Qle+GWRwjAqfhaBmBB
         NSCAFDmmgoJnlafli2cU0T4PntTonPHOaJ2w+r0Qw2gOIobe4GabCa4Wpnl+Y8Liiw
         r25m4pNYaw855RQW24ZWDE+M6wiS8ouIGyEJ+goQ=
Date:   Wed, 25 Nov 2020 08:30:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net 1/2] devlink: Hold rtnl lock while reading netdev
 attributes
Message-ID: <20201125083020.0a26ec0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB43224995BFBAE791FE75552ADCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201122061257.60425-1-parav@nvidia.com>
        <20201122061257.60425-2-parav@nvidia.com>
        <20201124142910.14cadc35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43224995BFBAE791FE75552ADCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 07:13:40 +0000 Parav Pandit wrote:
> > Maybe even add a check that drivers
> > which support reload set namespace local on their netdevs.  
> This will break the backward compatibility as orchestration for VFs
> are not using devlink reload, which is supported very recently. But
> yes, for SF who doesn't have backward compatibility issue, as soon as
> initial series is merged, I will mark it as local, so that
> orchestration doesn't start on wrong foot.

Ah, right, that will not work because of the shenanigans you guys play
with the uplink port. If all reprs are NETNS_LOCAL it'd not be an issue.
