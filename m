Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F121263AEF
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgIJB7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 21:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbgIJBfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 21:35:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E675321D40;
        Thu, 10 Sep 2020 00:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599699348;
        bh=jOnm7/txZOkn8Wc4FlgRNkk6DyAnIUHd3oAOL3yRBgQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B70V9+/9RwOQcSaOQBceIxslmx1KuED43nGz463e36OQXgsMD1bOABLTMsRWYr81o
         q3/hEB2Cw9Zq2eiUhQQlw/0IrSFk54VIEvMom9ILW44bQzngnKjMUDZgJcj7tn69ch
         1FDysCB0uEL2ButWUaMy4E3GMB7uWBw0G/01R4Vg=
Date:   Wed, 9 Sep 2020 17:55:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [net-next v4 2/5] devlink: convert flash_update to use params
 structure
Message-ID: <20200909175545.3ea38a80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909222653.32994-3-jacob.e.keller@intel.com>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
        <20200909222653.32994-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Sep 2020 15:26:50 -0700 Jacob Keller wrote:
> The devlink core recently gained support for checking whether the driver
> supports a flash_update parameter, via `supported_flash_update_params`.
> However, parameters are specified as function arguments. Adding a new
> parameter still requires modifying the signature of the .flash_update
> callback in all drivers.
> 
> Convert the .flash_update function to take a new `struct
> devlink_flash_update_params` instead. By using this structure, and the
> `supported_flash_update_params` bit field, a new parameter to
> flash_update can be added without requiring modification to existing
> drivers.
> 
> As before, all parameters except file_name will require driver opt-in.
> Because file_name is a necessary field to for the flash_update to make
> sense, no "SUPPORTED" bitflag is provided and it is always considered
> valid. All future additional parameters will require a new bit in the
> supported_flash_update_params bitfield.

I keep thinking we should also make the core do the
request_firmware_direct(). What else is the driver gonna do with the file name..

But I don't want to drag your series out so:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
