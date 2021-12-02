Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51E0465CBA
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355187AbhLBD3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:29:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40160 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355184AbhLBD3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:29:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5B4EB8220E
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 03:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0242FC53FAD;
        Thu,  2 Dec 2021 03:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638415584;
        bh=6P9MpG75u9N/K1EE5Zhpodumgy0E8U6M1YGAwAcXizY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fA9k9xHGOxCwyH/WNa3CKYSm0h5IB+5aW0qGToNI/NDkOxyMvDqtkjz0V3LyT9Tui
         RdYoIG+ipPaa43XOLwBndbIPQ1JaGCXWzPwFupGDgpw+uRB2QCXL7iF6mUKIeKvmiM
         XxXCKQDCJywoaadpsYKm5NN3nC/hOerWN3rTnVO4+hMoIRThbtNQvPcRf5JVGUg9Yq
         haHkAzfQ7DXDOMg4qRKzjd0kY7WyWSRY+DSAxyd6PQzcyg2pFPydiYubmsCr67wA5j
         1YuWsFh2PY1WT2jj58dJOIr18/q9AwmuV0E/lJcFyLEiI3crbtbK3UAw6mCjeKsmq8
         0wGWFMhejc8gg==
Date:   Wed, 1 Dec 2021 19:26:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Michal Maloszewski <michal.maloszewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 2/6] iavf: Fix reporting when setting descriptor
 count
Message-ID: <20211201192622.10a2b139@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211201215914.1200153-3-anthony.l.nguyen@intel.com>
References: <20211201215914.1200153-1-anthony.l.nguyen@intel.com>
        <20211201215914.1200153-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Dec 2021 13:59:10 -0800 Tony Nguyen wrote:
> +	if (new_tx_count != adapter->tx_desc_count) {
> +		netdev_info(netdev, "Changing Tx descriptor count from %d to %d\n",
> +			    adapter->tx_desc_count, new_tx_count);
> +		adapter->tx_desc_count = new_tx_count;
> +	}
> +
> +	if (new_rx_count != adapter->rx_desc_count) {
> +		netdev_info(netdev, "Changing Rx descriptor count from %d to %d\n",
> +			    adapter->rx_desc_count, new_rx_count);
> +		adapter->rx_desc_count = new_rx_count;
> +	}

How is this different than the MTU change msg I _just_ complained about?
Please downgrade to dbg().
