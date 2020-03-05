Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3547317AA74
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCEQYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:24:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:38638 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgCEQYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 11:24:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 08:24:08 -0800
X-IronPort-AV: E=Sophos;i="5.70,518,1574150400"; 
   d="scan'208";a="234463743"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 08:24:07 -0800
Message-ID: <c935cb595ad8a036a277a279e9ba34c9f194a491.camel@linux.intel.com>
Subject: Re: [PATCH net-next v3 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     andrew@lunn.ch, ecree@solarflare.com, mkubecek@suse.cz,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, snelson@pensando.io, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org
Date:   Thu, 05 Mar 2020 08:24:07 -0800
In-Reply-To: <20200305051542.991898-2-kuba@kernel.org>
References: <20200305051542.991898-1-kuba@kernel.org>
         <20200305051542.991898-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-03-04 at 21:15 -0800, Jakub Kicinski wrote:
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
> ---

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

