Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BFF60E545
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 18:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbiJZQK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 12:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbiJZQKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 12:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFBC8996D;
        Wed, 26 Oct 2022 09:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5103E61E9B;
        Wed, 26 Oct 2022 16:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5C0C433D6;
        Wed, 26 Oct 2022 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666800616;
        bh=wFCMxxHvKqWuqoHF9YS6mZ/ksC272I+9n4RYkTpDTjs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sv7Of0YLjRFV2H5BcKjSFC87wu/lW7q7dUjYeVOpRn3Ihgp0+iEvmr1bFCRu/wmv/
         sz5H6owjirPtk6ykGB0rJbnkBMSK4/DBfH6IapXkfpTHVA90e1/2UJnHxULVrnAwno
         Wd3Ih6SrHjdQSQpUzrRhBueCSAtAiEoTPW8tx1R9+AqO7QAcvOpWgR300lefa5qO+9
         6Gyo/GN095q4ZjUI6opaqrMd5v6jVxlT6OcQiEWSnYfOT2zXzbGt9Lr5V6lapDjyCC
         n+pBbPfPBV1WzI8iSyXrsgeIu9+99m+vbxzsO4l5LSlrNuxttT0VtLfWfMzyf0cVSJ
         79RhPhvaLxwAw==
Date:   Wed, 26 Oct 2022 09:10:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, corbet@lwn.net,
        michael.chan@broadcom.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moshet@nvidia.com,
        linux@rempel-privat.de, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <20221026091015.643b3e8f@kernel.org>
In-Reply-To: <Y1klvBsXfEXd4y8M@lunn.ch>
References: <20221026020948.1913777-1-kuba@kernel.org>
        <Y1klvBsXfEXd4y8M@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 14:19:08 +0200 Andrew Lunn wrote:
> You might want to consider a generic implementation in phylib.

Would bumping a counter in phy_link_down() be suitable?
I'm slightly unsure about the cable test behavior but 
I think increments during cable tests are quite fair.

> You should then have over 60 drivers implementing this, enough
> momentum it might actually get used.

Depends on your definition of "get used", I can guarantee it will 
get used according to my definition :)
