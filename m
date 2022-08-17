Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E10C59759B
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiHQSRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240315AbiHQSRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE238E0D5;
        Wed, 17 Aug 2022 11:16:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7159961365;
        Wed, 17 Aug 2022 18:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3F1C433C1;
        Wed, 17 Aug 2022 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660760217;
        bh=2AU+aXr4gpTlrYogH+hMCzUzgzTMhcv+G9mn9jrpKrU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hLWcXxEtFJM498cjzzLPqnrP02B1XN/pCmuCJ7qyv6p8ujY2ptstVTWCfFrvh/EXs
         uGlKJbEC7PN767lZ7/I7CEOCpZpNYot6QJ3TNJAFDeeXnlgWQz9QlA7SN286bPQ2+d
         zIrcRZbxNrgAB6+8XyDqP5qbD0QHXb/DJKiZLlvec0nBO4PFbzQh6mibmI5YeZMsrf
         UQCKYfYagOG349IUY8hiYekVziHmmwktf5yWZGeb4MrQ4CbBufocIiDp7rl43ldDLA
         USC6ztqtuxfEQJiA4hbmXV1uJLLd2iKZ6l4mrUK6Sd7G8joUm5H9zFbDm3EcTdX3ye
         OWdhyUC2FMHeQ==
Date:   Wed, 17 Aug 2022 11:16:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <idosch@nvidia.com>,
        <linux@rempel-privat.de>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>
Subject: Re: [PATCH net-next 0/2] net: ethtool add VxLAN to the NFC API
Message-ID: <20220817111656.7f4afaf3@kernel.org>
In-Reply-To: <20220817143538.43717-1-huangguangbin2@huawei.com>
References: <20220817143538.43717-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 22:35:36 +0800 Guangbin Huang wrote:
> This series adds support for steering VxLAN flows using the ethtool NFC
> interface, and implements it for hns3 devices.

Why can't TC be used for this? Let's not duplicate the same
functionality in two places, TC flower can already match on 
tunnel headers.
