Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB8B41AA12
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 09:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239479AbhI1Hva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:51:30 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:58193 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239328AbhI1Hv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 03:51:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 46945580C56;
        Tue, 28 Sep 2021 03:49:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 28 Sep 2021 03:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=W1gTysFUCeHCFA697MxJ7RHRRe/
        6ka4WMwz+p8/IZsg=; b=hEojnP22XPcGnEnxkVQa4yKcHzpbA5C4R8n21q/flzo
        Z7/18QIyEjpb4D70QOmLH6DLs8TgYkPB9aalehoUrc2OHvwD7pOUjJqdWgmh06w1
        C/GLUQqWEhxFjHepQmy0LC/DqFaU+cVoofEFfJCH4KnzF3fdwfVo6gINnv9MUwRa
        MItl2MCT7R0x5/kIIOzQNFdAyc3iQ9NJfDcakjdjuz6Nll+W89XPTH7jph9ziRKL
        TASTIKT+3hNbsIMQZBq0wcGiGvLQ3zjB3nxF79qSm+ofvhBPWZL6ecK9aHITirii
        DquuJLYoen09F7+KGfsp6dl6iSCf12+cbBBOwuqELGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=W1gTys
        FUCeHCFA697MxJ7RHRRe/6ka4WMwz+p8/IZsg=; b=uRdWG9QqQbQi8PgDbRACtw
        kHFp5cFmNnlCIheCsKPpL5H8fLb50fqptgpfkDnfTSI6fvUJ1a1F26eWdumVY2IK
        q/4yJ8gjydEbODr+9OpuJA6oS+zkT+RKbwdrL6LHUQnZskPW/l2iEeeLDgIiQxLr
        O4mUP0NT82prseC1ijBDW8To/s8RqAO8YWkosl+crm8TDivCwhUYsND+eEbVaNox
        kuy9tGYWfqZruXpvLCUQkJ88RwSfNWMT8MdutRfjbwsbpd799Liw3trJY1AIxNut
        3NPuceCXSRjDYzyOxTyItRPa4A8psIbLOqkouoRHaHZe6KJzUL/L6h6huyjI0TmA
        ==
X-ME-Sender: <xms:HMlSYTgfgHC1NMelg3XOGENjEUQTCCwvwWorJsdmDfSG0FGWSdG3Ag>
    <xme:HMlSYQC3L6IKKzfdB9OF6qmwgCgA5MxPzhj8EnASQTo0f4MhgcbLj02Ajh3XJEb4R
    2fqPLI5BrfM5A>
X-ME-Received: <xmr:HMlSYTFDG5i2jDLoEeW2-0xcDtwhGAwzSCEq83zWPEr8vZHUk97I8vwQIlnR4xHDbAANeyhRwZk3o7HA7kGM5UzjLhDy6ztR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudejledguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:HMlSYQQOCfaa1Q4DUgvAIgMU659QePbUU65zRvSepId7Linfkl6cAA>
    <xmx:HMlSYQxUZoTxx9bBPG1zkJna2lup90jKHc-j0HXUC5OOJQ3c_NJr3g>
    <xmx:HMlSYW4tC7MQnQ4J5RvzcN1MPkyFI7JlUf1WO7bndCGnJZCJ1mS5uw>
    <xmx:HclSYRS4PI7qTS6AGin8LTYIYAeF-m3qJu2umnsKShY-JX6Cb7RpkQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Sep 2021 03:49:48 -0400 (EDT)
Date:   Tue, 28 Sep 2021 09:49:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Leon Yu <leoyu@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org
Subject: Re: backport commit ("31096c3e8b11 net: stmmac: don't attach
 interface until resume finishes") to linux-5.4-stable
Message-ID: <YVLJGT7JAVc7rnBx@kroah.com>
References: <20210927104500.1505-1-macpaul.lin@mediatek.com>
 <20210928074349.24622-1-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928074349.24622-1-macpaul.lin@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 03:43:49PM +0800, Macpaul Lin wrote:
> Hi reviewers,
> 
> I suggest to backport 
> commit "31096c3e8b11 net: stmmac: don't attach interface until resume finishes"
> to linux-5.4 stable tree.
> 
> This patch fix resume issue by deferring netif_device_attach().
> 
> However, the patch cannot be cherry-pick directly on to stable-5.4.
> A slightly change to the origin patch is required.
> I'd like to provide the modification to stable-5.4 if it is needed.

Ok, can you please send a properly backported patch so that we can apply
it?

thanks,

greg k-h
