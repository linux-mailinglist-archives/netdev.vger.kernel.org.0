Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4589A4E7881
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 16:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358528AbiCYQAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354373AbiCYQAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:00:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5188140A03
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 08:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E30C1B828FA
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 15:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66E6C340E9;
        Fri, 25 Mar 2022 15:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648223940;
        bh=kSzqHnM8m0+WEsObFPeEQHTR8sQy5b/SkP2BFN+Fq5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KYQFwkgITzczNd5CJEeRfo3pvN72DdRH16rT3sgV6vLU8bqnRwJhL7HzXoIojn+yw
         ZlEUKMdRJgtBpyYZeL623eHgrDO9i+mp92EWxVfrfv5eRK1NWEROiJiJw90BeDgQSv
         hmwoYco2vIf8ysX+xM3NID9Zj3DoDP6QsRMnwwcC9yH5uAF5Xid/Tc/mffGgyV9uTX
         D1YYFOT0vqWhba/5O3poieiUaR6n21rp8BaDaZL1ZzBXFs9Kg5ZDPUGg1w9kJ7X9vF
         uKYvOfYXrid5Ky1AxvBZZtPJfSrz8UO3bK1gmcQU0SYxAZDaTOuFg78YzP1thOpcXY
         pUTGiSM4qg3Ag==
Date:   Fri, 25 Mar 2022 08:58:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "shenjian (K)" <shenjian15@huawei.com>, davem@davemloft.net,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com,
        alexandr.lobakin@intel.com, saeed@kernel.org, leon@kernel.org,
        netdev@vger.kernel.org, linuxarm@openeuler.org,
        lipeng321@huawei.com
Subject: Re: [RFCv5 PATCH net-next 01/20] net: rename net_device->features
 to net_device->active_features
Message-ID: <20220325085858.21176341@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yj3lPVqrN1APvp1X@lunn.ch>
References: <20220324154932.17557-1-shenjian15@huawei.com>
        <20220324154932.17557-2-shenjian15@huawei.com>
        <20220324175832.70a7de9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220324180331.77a818c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2c493855-4084-8b5d-fed8-6faf8255faae@huawei.com>
        <20220324183549.10ba1260@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yj3lPVqrN1APvp1X@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Mar 2022 16:52:29 +0100 Andrew Lunn wrote:
> > Here _hw_ makes sense. But i think we need some sort of
> > consistency. Either drop the _active_ from the function name, or
> > rename the netdev field active_features.  
> 
> So i suggested an either/or. In retrospect, the or seems like a bad
> idea, this patch will be enormous. So i would suggest the other
> option, netdev_set_active_features() gets renamed to
> netdev_set__features()

SGTM! Just clarify if you meant the double underscore or it's a
coincidence? :)
