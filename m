Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F3318FAF6
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgCWRJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgCWRJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 13:09:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 660BF2074D;
        Mon, 23 Mar 2020 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584983383;
        bh=1dnvyJOrvMFxDje/OdG35CnwFZtIRCLPyyaglUPRwsI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P7VPgRxXxxZMnimbKmXg5NTzZNecbejqgJU71NTDISVgBA7GoofIH/FWfqL0Maypv
         TRegBTUHtplm59lpiwVzvJi7sTFC5ZTq/SAxRDZW6wem7J4NcuILyDr04ZdnxG0+ED
         j3z0jq6dCzU7h5vrj/8IvgSJuwWQbwmSRMJpApwc=
Date:   Mon, 23 Mar 2020 10:09:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 6/9] ice: enable initial devlink support
Message-ID: <20200323100941.2043b224@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200321081028.2763550-7-jeffrey.t.kirsher@intel.com>
References: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
        <20200321081028.2763550-7-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Mar 2020 01:10:25 -0700 Jeff Kirsher wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> Begin implementing support for the devlink interface with the ice
> driver.
> 
> The pf structure is currently memory managed through devres, via
> a devm_alloc. To mimic this behavior, after allocating the devlink
> pointer, use devm_add_action to add a teardown action for releasing the
> devlink memory on exit.
> 
> The ice hardware is a multi-function PCIe device. Thus, each physical
> function will get its own devlink instance. This means that each
> function will be treated independently, with its own parameters and
> configuration. This is done because the ice driver loads a separate
> instance for each function.
> 
> Due to this, the implementation does not enable devlink to manage
> device-wide resources or configuration, as each physical function will
> be treated independently. This is done for simplicity, as managing
> a devlink instance across multiple driver instances would significantly
> increase the complexity for minimal gain.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks for posting these!
