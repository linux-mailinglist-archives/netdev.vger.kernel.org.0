Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC65F44D7C0
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhKKOEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:04:44 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47210 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhKKOEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 09:04:42 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4604B1F770;
        Thu, 11 Nov 2021 14:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636639312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PombuJM8RL7E0FROtDAMwpbx4fuaWwnUJtU+DAOHsBE=;
        b=U6fSnwbccRPFM/tkgrtG5NtE145dLcqfzKxXpojjkLtJ6F8Yg17Q0dyg2XvOZ+l+6ugNF5
        LeqRB8Zd6+HBWPAOmfOPUDg2WV9Ri4UrD5SgtMqCUUOFAjgMqZ1SsrxlssGx8+P0CJNgCI
        KAB6J7fWtwkU4BX+iS24NEFyZuePRoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636639312;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PombuJM8RL7E0FROtDAMwpbx4fuaWwnUJtU+DAOHsBE=;
        b=EI9uGlbylpouuTv2UtYsUCSvWQFcF09ngVtmbTNVqNRhu56rqBktWNu1MUDIjldUo6Iuxa
        yhG+wwrw/Air4qCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6C40813DBA;
        Thu, 11 Nov 2021 14:01:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id o1HqFU8ijWFkQQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Thu, 11 Nov 2021 14:01:51 +0000
Subject: Re: [PATCH] net: stmmac: socfpga: add runtime suspend/resume callback
 for stratix10 platform
To:     Meng Li <Meng.Li@windriver.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211111135630.24996-1-Meng.Li@windriver.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <499952a2-c919-109d-4f0a-fb4db4ead604@suse.de>
Date:   Thu, 11 Nov 2021 17:01:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211111135630.24996-1-Meng.Li@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/11/21 4:56 PM, Meng Li пишет:
> From: Meng Li <meng.li@windriver.com>
> 
> According to upstream commit 5ec55823438e("net: stmmac:
> add clocks management for gmac driver "), it improve clocks
> management for stmmac driver. So, it is necessary to implement
> the runtime callback in dwmac-socfpga driver because it doesn’t
> use the common stmmac_pltfr_pm_ops instance. Otherwise, clocks
> are not disabled when system enters suspend status.

Please add Fixes tag
> 
> Signed-off-by: Meng Li <Meng.Li@windriver.com>
> ---
>   .../ethernet/stmicro/stmmac/dwmac-socfpga.c   | 24 +++++++++++++++++--
>   1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> index 85208128f135..93abde467de4 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> @@ -485,8 +485,28 @@ static int socfpga_dwmac_resume(struct device *dev)
>   }
>   #endif /* CONFIG_PM_SLEEP */
>   
> -static SIMPLE_DEV_PM_OPS(socfpga_dwmac_pm_ops, stmmac_suspend,
> -					       socfpga_dwmac_resume);
> +static int __maybe_unused socfpga_dwmac_runtime_suspend(struct device *dev)
> +{
> +	struct net_device *ndev = dev_get_drvdata(dev);
> +	struct stmmac_priv *priv = netdev_priv(ndev);
> +
> +	stmmac_bus_clks_config(priv, false);
check the return value?
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused socfpga_dwmac_runtime_resume(struct device *dev)
> +{
> +	struct net_device *ndev = dev_get_drvdata(dev);
> +	struct stmmac_priv *priv = netdev_priv(ndev);
> +
> +	return stmmac_bus_clks_config(priv, true);
> +}
> +
> +const struct dev_pm_ops socfpga_dwmac_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(stmmac_suspend, socfpga_dwmac_resume)
> +	SET_RUNTIME_PM_OPS(socfpga_dwmac_runtime_suspend, socfpga_dwmac_runtime_resume, NULL)
> +};
>   
>   static const struct socfpga_dwmac_ops socfpga_gen5_ops = {
>   	.set_phy_mode = socfpga_gen5_set_phy_mode,
> 
