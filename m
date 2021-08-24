Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B593F6C51
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhHXXsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhHXXsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 19:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E381E61212;
        Tue, 24 Aug 2021 23:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629848851;
        bh=SH5Z0I94oakJnVKdkh9AL9GwjcqWTK9lpkjNT/sh8XM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UQYWZO1o57EQ94iAESLffaEP6yP8vG5zBOslT+mk0ZwJvykg4yu+b5xk8dYdrGmTz
         xxfkqgRs0mrRaqWNXeM7+dUrUPHu/OOSxn/O+vgnC6x6j3RSJYEeEHUxq6YIej9U7W
         DF6Tv4IhgUxWyBxakbmRyl74jjz2Dd1a/snHUjBsHRMDDgZj/JPqVhUY2wR5jxl2BB
         WPlBI3U/gzB4Sa/h5RmmVF3n4zsQsPR02QRUavX6klwLGy86Ee/jeNbH7VxyZzJDtO
         RKFraVPUVmn5ohp185lgkGUzNhj/HliUujATpI//XkXpdVzYBv9WNOPtTTPGi45bQF
         pQp++YPcxSW3Q==
Date:   Tue, 24 Aug 2021 16:47:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <20210824164730.38035109@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CO1PR11MB5089F1466B2072C6AD8614F1D6C59@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210824130344.1828076-1-idosch@idosch.org>
        <20210824130344.1828076-2-idosch@idosch.org>
        <20210824161231.5e281f1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB5089F1466B2072C6AD8614F1D6C59@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 23:18:56 +0000 Keller, Jacob E wrote:
> > > + * @mode_valid: Indicates the validity of the @mode field. Should be set by
> > > + * device drivers on get operations when a module is plugged-in.  
> > 
> > Should we make a firm decision on whether we want to use these kind of
> > valid bits or choose invalid defaults? As you may guess my preference
> > is the latter since that's what I usually do, that way drivers don't
> > have to write two fields.
> > 
> > Actually I think this may be the first "valid" in ethtool, I thought we
> > already had one but I don't see it now..
> 
> coalesce settings have a valid mode don't they? Or at least an "accepted modes"?

That's a static per-driver bitmask 'cause we don't trust driver writers
to error out on all the unsupported fields. The driver code doesn't
operate on it in the callbacks.
