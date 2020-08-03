Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB87323AF82
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 23:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgHCVNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 17:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbgHCVNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 17:13:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57C9322BF3;
        Mon,  3 Aug 2020 21:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596489186;
        bh=wrBml3ZlgFAgge4kMgW6wvPJ9wcmxk5NA/oRqTV2P8U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ayCVzn3Ge6kswydHMxffWscRNlnxBLkOWl1TSF12Df2KAUDYOQlVPpDcF8r6AnLIu
         AFS0MYrHabwGgSwrNGm2R039hJS66+RXPVd2GQ962jevuUBs1CnN7kJgMrglMIbUGf
         UtUnHuL900SKhzIm6tqWZPHxJEsys/7YvV1VwbVg=
Date:   Mon, 3 Aug 2020 14:13:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     Ganji Aravind <ganji.aravind@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, vishal@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add support to flash firmware config
 image
Message-ID: <20200803141304.79a7d05f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200802171221.GA29010@chelsio.com>
References: <20200730151138.394115-1-ganji.aravind@chelsio.com>
        <20200730162335.6a6aa4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200731110904.GA1571@chelsio.com>
        <20200731110008.598a8ea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200731211733.GA25665@chelsio.com>
        <20200801212202.7e4f3be2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200802171221.GA29010@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Aug 2020 22:42:28 +0530 Rahul Lakkireddy wrote:
> The config file contains very low-level firmware and device specific
> params and most of them are dependent on the type of Chelsio NIC.
> The params are mostly device dependent register-value pairs.
> We don't see users messing around with the params on their own
> without consultation. The users only need some mechanism to flash
> the custom config file shared by us on to their adapter. After
> device restart, the firmware will automatically pick up the flashed
> config file and redistribute the resources, as per their requested
> use-case.
> 
> We're already foreseeing very long awkward list (more than 50 params)
> for mapping the config file to devlink-dev params and are hoping this
> is fine. Here's a sample on how it would look.
> 
> hw_sge_reg_1008=0x40800
> hw_sge_reg_100c=0x22222222
> hw_sge_reg_10a0=0x01040810
> hw_tp_reg_7d04=0x00010000
> hw_tp_reg_7dc0=0x0e2f8849
> 
> and so on.

I have no details on what you're actually storing in the config, 
and I don't care what your format is.

If it's a configuration parameter - it needs a proper API.

If it's a low level board param or such - it doesn't need a separate
flashable partition and can come with the rest of FW.

I know the firmware flashing interface is a lovely, binary, opaque
interface which vendors love. We'll not entertain this kind of abuse.

Nacked-by: Jakub Kicinski <kuba@kernel.org>
