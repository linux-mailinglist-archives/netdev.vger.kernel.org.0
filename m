Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5AD617A65A
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgCEN2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:28:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgCEN2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 08:28:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zarBtZCKOeOKt5lkq8E7M5sTL9A2QjZPsZ6uvCLr0I8=; b=mHM1rkpXLRunUii2BLfesucniA
        +lW/kQtaeeTaJXc6Ee1ElNnnpcaSPtmgl2pgMDoplZHGx8Ic4V5T1GoHteC6gsukT1LqITMdbZbLg
        kg1kjqj79KxnhKqz6O3g2zwhXeDSCHxd672L5aVx1b8m2Vbx8eylxYm1rPRmq88X2mSI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9qWs-0005Y1-Bi; Thu, 05 Mar 2020 14:27:10 +0100
Date:   Thu, 5 Mar 2020 14:27:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, ecree@solarflare.com, mkubecek@suse.cz,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, snelson@pensando.io, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200305132710.GA23094@lunn.ch>
References: <20200305051542.991898-1-kuba@kernel.org>
 <20200305051542.991898-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305051542.991898-2-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 09:15:31PM -0800, Jakub Kicinski wrote:
> Linux supports 22 different interrupt coalescing parameters.
> No driver implements them all. Some drivers just ignore the
> ones they don't support, while others have to carry a long
> list of checks to reject unsupported settings.
> 
> To simplify the drivers add the ability to specify inside
> ethtool_ops which parameters are supported and let the core
> reject attempts to set any other one.
> 
> This commit makes the mechanism an opt-in, only drivers which
> set ethtool_opts->coalesce_types to a non-zero value will have
> the checks enforced.
> 
> The same mask is used for global and per queue settings.
> 
> v3: - move the (temporary) check if driver defines types
>       earlier (Michal)
>     - rename used_types -> nonzero_params, and
>       coalesce_types -> supported_coalesce_params (Alex)
>     - use EOPNOTSUPP instead of EINVAL (Andrew, Michal)
> 
> Leaving the long series of ifs for now, it seems nice to
> be able to grep for the field and flag names. This will
> probably have to be revisited once netlink support lands.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
