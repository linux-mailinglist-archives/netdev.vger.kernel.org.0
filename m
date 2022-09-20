Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9EA45BEE47
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiITUMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiITUMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:12:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48520719BE
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 13:12:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 065B7B82CBB
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 20:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B71AC433D6;
        Tue, 20 Sep 2022 20:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663704754;
        bh=urfTC7r6nFR4fXpme6NJiuz/ShtbAS52ue2CklNIU3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vt27tY4piEYxwFvN75yOg5novZlzsX/HoUd6MEEktCR/imTTtB1sGJPbcsKEuB52U
         mq1LjpnNwklBPoK0Gcp2Qm9P0/4Y2a8tfjcw+DYmbBD+eKJH03NPoyBgiSUKbBikkE
         JPxbSiZ+74cGINonqm9OdrO2kM1lDQtGueCQl6S1PWETAsmO1j8dnvaxiiIu+xIRWX
         YsNCMBU3/XsT03XrERsc5fuzVoY+QCi4BsOg0ZqB5Q4gZsCbas7TyxCmABAG9LXzzD
         EWB4aa+AjASHipXZ9Op0JUwYlXBmD2AS5stmL2qZP8U9bcA7sgo/o0xEEmalMP8f0V
         ZlkV4jqAZVzxQ==
Date:   Tue, 20 Sep 2022 13:12:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [RFCv8 PATCH net-next 02/55] net: replace general features
 macroes with global netdev_features variables
Message-ID: <20220920131233.61a1b28c@kernel.org>
In-Reply-To: <20220918094336.28958-3-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
        <20220918094336.28958-3-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Sep 2022 09:42:43 +0000 Jian Shen wrote:
> -#define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
> -				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
> +#define NETIF_F_NEVER_CHANGE	netdev_never_change_features

We shouldn't be changing all these defines here, because that breaks
the build AFAIU. Can we not use the lowercase names going forward?
