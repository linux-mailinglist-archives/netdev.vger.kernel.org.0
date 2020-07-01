Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696E2211319
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 20:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgGASyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 14:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgGASyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 14:54:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38B382082F;
        Wed,  1 Jul 2020 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593629645;
        bh=arBC5kWWmGGAhW6RNfJv8Y2OBNwQSad7ArFxPPrM1oc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CrsVPpcE017F4ZIljB1ve0ssfLcCe9U/yI2GOH6Q3ykBlrtwcM6mQXbS05SNg8HXp
         cmvAJIddOH4fYuQGDbTIDFWtiQoYXCcSHJ4NBugHRed71tPW36eLlM2DBt4R5XVcC1
         EtI20F4FtzPWJgHfoeCiCtmhneIG+M69FIODibHw=
Date:   Wed, 1 Jul 2020 11:54:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        snelson@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 5/9] devlink: Add a new devlink port lanes
 attribute and pass to netlink
Message-ID: <20200701115403.75b13480@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200701143251.456693-6-idosch@idosch.org>
References: <20200701143251.456693-1-idosch@idosch.org>
        <20200701143251.456693-6-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Jul 2020 17:32:47 +0300 Ido Schimmel wrote:
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 8f9db991192d..91752b79bb29 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -68,10 +68,13 @@ struct devlink_port_pci_vf_attrs {
>   * struct devlink_port_attrs - devlink port object
>   * @flavour: flavour of the port
>   * @split: indicates if this is split port
> + * @lanes: maximum number of lanes the port supports.
> + *	   0 value is not passed to netlink and valid number is a power of 2.

Why power of two? what about 100G R10?

>   * @switch_id: if the port is part of switch, this is buffer with ID, otherwise this is NULL
>   */
>  struct devlink_port_attrs {
>  	u8 split:1;
> +	u32 lanes;
>  	enum devlink_port_flavour flavour;
>  	struct netdev_phys_item_id switch_id;
>  	union {
