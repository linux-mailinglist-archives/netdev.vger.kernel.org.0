Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8DA61065D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 01:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbiJ0X0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 19:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiJ0XZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 19:25:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5843C31355
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 16:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sqgipsUXhEyWYT28cm6lJFgb+/SXP9IhlS4U3rPBvgg=; b=QD9hzY2EB3cw/PJBubUbGJpX0/
        YfG572xr7OHDF5qmqnT/SiZZLII8YcP+MKwIfWyGdkXzjZmtAITxHR/S2CCqq1c3SuSEUjVyTC5cq
        3IX4wpDpr4ryOU2C0D2MQV7zVmozzpSKcelWmLGjlbKJN9wdwTBfl233LPVR4JzyJh1Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ooCFn-000lDZ-IL; Fri, 28 Oct 2022 01:25:39 +0200
Date:   Fri, 28 Oct 2022 01:25:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v1 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <Y1sTc8zJ7bCN85bK@lunn.ch>
References: <20221027220013.24276-1-davthompson@nvidia.com>
 <20221027220013.24276-4-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027220013.24276-4-davthompson@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +mlxbf_gige_clm_init[] = {
> +	{.addr = 0x001, .wdata = 0x0105},
> +	{.addr = 0x008, .wdata = 0x0001},
> +	{.addr = 0x00B, .wdata = 0x8420},
> +	{.addr = 0x00E, .wdata = 0x0110},
> +	{.addr = 0x010, .wdata = 0x3010},
> +	{.addr = 0x027, .wdata = 0x0104},
> +	{.addr = 0x02F, .wdata = 0x09EA},
> +	{.addr = 0x055, .wdata = 0x0008},
> +	{.addr = 0x058, .wdata = 0x0088},
> +	{.addr = 0x072, .wdata = 0x3222},
> +	{.addr = 0x073, .wdata = 0x7654},
> +	{.addr = 0x074, .wdata = 0xBA98},
> +	{.addr = 0x075, .wdata = 0xDDDC}
> +};
> +
> +#define MLXBF_GIGE_UPHY_CLM_INIT_NUM_ENTRIES \
> +	(sizeof(mlxbf_gige_clm_init) / sizeof(struct mlxbf_gige_uphy_cfg_reg))

ARRAY_SIZE() ?

You have a lot of completely undocumented black magic here. And these
tables are quite large. I'm wondering if it really should be
considered firmware, and loaded on demand from /lib/firmware ?

	   Andrew
