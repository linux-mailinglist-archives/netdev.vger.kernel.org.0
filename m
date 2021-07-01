Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5537E3B9437
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbhGAPpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233901AbhGAPpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 11:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B008B61406;
        Thu,  1 Jul 2021 15:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625154159;
        bh=kwYjWpdNMzE1Ze/cIsySoElgLYu6OYO31HDl9lnBGlk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VChIOjbMfG9XR8KU/jJ1vbLVaa76PSrXRIiUnC2oEcv9lZSg59/mp2ioLttJID7Ra
         htwOwxgKlMbRkRA9S2wF7iEhGafqRH68vFltARSY+QnmUQ8foQZxt/XRtmagnAbasY
         NiRNdW6YK5dYXis5if73gBDhaR1klIer/b5M9jdjOYsJjAZhcXfmh445cudoMc9zvZ
         crsFg9I/7PXwTC6tGv4QorAFcY+TqjcGIKZxWN47YbMfyBG6yji8zGEhcgx5N/zXF0
         5+apcxac1iINL+EYgXcbk02AM4T2NeKmuclX0/oG4W2faWlLRdMfRtAsSTbFdcH/UY
         hT43fwUrOxZtg==
Date:   Thu, 1 Jul 2021 08:42:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <michael.chan@broadcom.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <ecree.xilinx@gmail.com>,
        <habetsm.xilinx@gmail.com>, <f.fainelli@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <ariela@nvidia.com>
Subject: Re: [PATCH net-next v2 0/6] ethtool: add standard FEC statistics
Message-ID: <20210701084237.4b27bea3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fc15329d-6f09-edd9-923d-403db6e74b2a@huawei.com>
References: <20210415225318.2726095-1-kuba@kernel.org>
        <b5bb362e-a430-2cc8-291e-b407e306fd49@huawei.com>
        <20210518103056.4e8a8a6f@kicinski-fedora-PC1C0HJN>
        <fc15329d-6f09-edd9-923d-403db6e74b2a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Jul 2021 20:18:15 +0800 huangguangbin (A) wrote:
> On 2021/5/19 1:30, Jakub Kicinski wrote:
> > On Tue, 18 May 2021 14:48:13 +0800 huangguangbin (A) wrote:  
> >> Hi, I have a doubt that why active FEC encoding is None here?
> >> Should it actually be BaseR or RS if FEC statistics are reported?  
> > 
> > Hi! Good point. The values in the example are collected from a netdevsim
> > based mock up which I used for testing the interface, not real hardware.
> > In reality seeing None and corrected/uncorrectable blocks is not valid.
> > That said please keep in mind that the statistics should not be reset
> > when settings are changed, so OFF + stats may happen.
> > .
> >   
> Hi, Jakub, I have another question of per-lane counters.
> If speed is changed, do the lane number of FEC statistics need to follow the change?
> For examples, change speed from 200Gbps to 50Gbps, the actual used lane number is
> changed from 4 to 2, in this case, how many lanes are needed to display FEC statistic?
> Still 4 lanes or 2 lanes?

I'd always report counters for max number of lanes supported by the HW.
Much like you'd do if you were directly exposing the register values,
the registers are still there in HW.
