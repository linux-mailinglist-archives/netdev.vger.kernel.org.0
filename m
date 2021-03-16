Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2F033E068
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhCPVVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232433AbhCPVVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:21:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 584DB64FA6;
        Tue, 16 Mar 2021 21:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615929674;
        bh=su/a4cJXKkStHlw0Xv6RaaQR/ej+nELTe/a2v5ZVifY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ls+CiT1rDuu0/020yQNXMyP2EEGdd9tNmW+kVHPmWtJ+PknQ6RpzBiJLaN9fGZlF5
         SsBWH/k4HVb5+FzKdDe2t7Ts9xj6H3AD+MvDRZ9U4pgiNYHjkdIeUsRx0zTvSW4vb9
         czxtJsbfrwJVmmgL4qHh9R4Ykn9jadnw16nflBaRsNnrkz2sXh9J5hh2VUySY8AlOp
         oPBF7HIPB7sxJrie0K88Y2byZzXwXNrIuPvm0FIVOX/gbCh1+p6oFdGUmbnCm6q7sB
         klqBhD8p4rMRS9uoOAiz30GzIEdjKZiD6v/cN2f6NwOS8o6HFxEwWZNHCOQj9J6rX3
         tcpWNiprO/D5Q==
Date:   Tue, 16 Mar 2021 14:21:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: Re: [RESEND v1 net-next 2/5] net: stmmac: make stmmac_interrupt()
 function more friendly to MSI
Message-ID: <20210316142113.40fd721f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316121823.18659-3-weifeng.voon@intel.com>
References: <20210316121823.18659-1-weifeng.voon@intel.com>
        <20210316121823.18659-3-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 20:18:20 +0800 Voon Weifeng wrote:
> +	if (unlikely(!dev)) {
> +		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
> +		return IRQ_NONE;
> +	}

Where did this check come from? Please avoid defensive programming 
in the kernel unless you can point out how the condition can arise
legitimately.
