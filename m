Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BC3633485
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiKVErL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKVErK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:47:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDBF26AD6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:47:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 755E9B81673
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A7EC433D6;
        Tue, 22 Nov 2022 04:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669092426;
        bh=0Bqvekd8cN7nULzn1XJoxGYicSbo6xeVE6e9JwjnE7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hk0N7oPNVUCKwkKQUvHGWihI7004cfFcaj5a9Xk55lxgmnTCgFY/QvSoN4mONF/Ab
         hbNSB9PFDW5okUVFbUWIdyGsa0e350xtXvFrOkdaG5iOpG61fJXbYgLMzftybutiNG
         q8qNMqsCnaOaKUBkaX+zAazEdxyaRrH4bYRvFlA0F1b6a9o6WuYJaEtameyJNG8yfm
         jmf/aXOhknbGtt8jkX/bftG5mpS0hx0esGhugnTRUy4wPKqIBR1zy2KbTCVPbS0cKP
         aJK4a4Lnfpu9zNT78aAWI+wd781pVU8nAgwg8PUiuVUnfG1eYBep/tGLR6H2BiwaAe
         y2VJ0P3I2LjrA==
Date:   Mon, 21 Nov 2022 20:47:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [PATCH net resend] ixgbe: fix pci device refcount leak
Message-ID: <20221121204703.021b31bd@kernel.org>
In-Reply-To: <20221119064155.1395173-1-yangyingliang@huawei.com>
References: <20221119064155.1395173-1-yangyingliang@huawei.com>
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

On Sat, 19 Nov 2022 14:41:55 +0800 Yang Yingliang wrote:
> As comment of pci_get_domain_bus_and_slot() says, it returns
> a pci device with refcount increment, when finish using it,
> the caller must decrement the reference count by calling
> pci_dev_put().
> 
> In ixgbe_get_first_secondary_devfn() and ixgbe_x550em_a_has_mii(),
> pci_dev_put() is called to avoid leak.
> 
> Fixes: 8fa10ef01260 ("ixgbe: register a mdiobus")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> Cc all pepole in the maintainer list.

still missing the intel-wired-lan list
