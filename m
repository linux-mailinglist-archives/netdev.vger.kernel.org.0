Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA306BDD43
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCQAAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCQAAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF79DC091;
        Thu, 16 Mar 2023 17:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDA44B82140;
        Fri, 17 Mar 2023 00:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16AEC433D2;
        Fri, 17 Mar 2023 00:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679011214;
        bh=W4U2BfVaQ0aO+oyBYlt3Jue0ripQY6SGpEmF8ls7mEY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H5OtqcsX5HfJTH3128KYYQibr1vGA7nrxZcQkyf67dMwbO5S0Sr1gX+fDd+2gPQDh
         RDU5CmrzjF4xoEHdXnKgEFmPYzlsTldrw0z/uXODxCifxAZN1j3Oexrtw6yYi7+JjJ
         rIZMrjaJWb9MM3DGJK7CfOcx877YLH5yKDGFjwjeVYZ+SXobysufainCMf4Qofi47r
         /u0DOUpB8fPA9LgR8hAakSwX28tnzCQYRvKBa7pSUI5OhaPVsdGuBmbQPDsqM6dWKo
         zVYMaPqSKQtCUFMCBlaCJZjYxwhnhNj5nyrWg3w2E5dHrm5v84O7X2dx9axKwgJ1l4
         boEaMFn7ve5UQ==
Date:   Thu, 16 Mar 2023 17:00:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v2 1/2] net: stmmac: fix PHY handle parsing
Message-ID: <20230316170013.4681d0f3@kernel.org>
In-Reply-To: <20230314070208.3703963-2-michael.wei.hong.sit@intel.com>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
        <20230314070208.3703963-2-michael.wei.hong.sit@intel.com>
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

On Tue, 14 Mar 2023 15:02:07 +0800 Michael Sit Wei Hong wrote:
> +		fixed_node = fwnode_get_named_child_node(fwnode, "fixed-link");
> +		fwnode_handle_put(fixed_node);

fwnode_property_present() ?

