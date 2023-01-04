Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8524965D6BC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239460AbjADPA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239432AbjADPA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:00:26 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A90B1EACF
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NSY9mRZzARw3mkAQtUEP+bUfkzWjMOknyROvYcB+peU=; b=NONVAxhBPnZakiB2t5Jj1oRC7g
        VewS0SLVMNmFjMNVE0na4uRVXO67tXg4NIt7qaqY6C393MU4cJvtrA8P6Y/EeAOoPTfijkIP76h7q
        ZEmI7th+Jre18Bn5yZUUrs7RwMn9Y+DxmbidTk9qTHi0NLsKy2nVy7ZgQt1UZdWz7zKs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pD5FM-0018ve-Pa; Wed, 04 Jan 2023 16:00:04 +0100
Date:   Wed, 4 Jan 2023 16:00:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hao Lan <lanhao@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, shenjian15@huawei.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: hns3: support wake on lan
 configuration and query
Message-ID: <Y7WUdLFEj9k6UTpD@lunn.ch>
References: <20230104013405.65433-1-lanhao@huawei.com>
 <20230104013405.65433-2-lanhao@huawei.com>
 <Y7TgHS8oGbE656v0@lunn.ch>
 <0087bf43-a78c-7d3c-4ab2-de246afe25f8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0087bf43-a78c-7d3c-4ab2-de246afe25f8@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 08:57:40PM +0800, Hao Lan wrote:
> Hi Andrew,
> Thank you for reviewing our code. Thank you very much.
> You're right, such as WAKE_PHY, WAKE_CAST, these are implemented
> in the kernel, they are ABI, they will never change, we use it
> will directly simplify our code, your advice is very useful, thank
> you very much for your advice.
> However, these interfaces serve as a buffer between our firmware
> and the linux community. Considering our interface expansion and
> evolution, we may add some private modes in the future.

You cannot add private WOL modes, since they will be unusable without
ethtool support. And to add ethtool support, they need to be
public. And to make them public, you just add more WAKE_ macros.  Just
make sure the new modes you add are well described, so other drivers
can also implement them.

	Andrew
