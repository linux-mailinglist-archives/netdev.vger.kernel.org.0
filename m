Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF94D61A6D1
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKECK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKECK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:10:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B52C644
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39D9FB82CD4
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C23C433C1;
        Sat,  5 Nov 2022 02:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667614222;
        bh=a9XTTdJlI8Zv+2sC3dHHiR8Mq4sCgU63wvrYASfnZmk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cx6bdnnZBVVh86bzu8rs2J37pMZlJabhnIHWbAGb2Tufctj9mujOqZTZZu7glVncE
         ZZ9wCN4EURHFX83AdGhz5EM7731rLu2+RCoEjGWr8jbsUUncFptiUKU4xvnvprqIaU
         rMwmvTPxZYdB6/OoW6vt68UAONGswaYsd4+aV1xsdPjRV5LLDgG9RSjXAA4jI/y/bQ
         oYG81ENY23AOZqtANTxHheYqfo4QaACFKyT6twfUnClcAqErtl+YRuXLSq9fqBDljw
         lcQgzXCi2784oUNMl+FEet7Z65lpoiF4iKm/GIfSb5LDePSQu1dco9LD4DNqZTFndi
         DpEwsnCJKgWkg==
Date:   Fri, 4 Nov 2022 19:10:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        ecree.xilinx@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v9 1/9] devlink: Introduce new attribute
 'tx_priority' to devlink-rate
Message-ID: <20221104191021.588acef2@kernel.org>
In-Reply-To: <20221104143102.1120076-2-michal.wilczynski@intel.com>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
        <20221104143102.1120076-2-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Nov 2022 15:30:54 +0100 Michal Wilczynski wrote:
> +		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_leaf_tx_priority_set) {
> +			NL_SET_ERR_MSG_MOD(info->extack,
> +					   "TX priority set isn't supported for the leafs");

Please point to the attribute - NL_SET_ERR_MSG_ATTR().

I'm not entirely sure why we keep slapping the _MOD() on the extacks,
but if you care to keep that you may need to add the _MOD flavor of 
the above.
