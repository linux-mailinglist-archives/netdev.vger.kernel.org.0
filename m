Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60986B8194
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 20:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjCMTR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 15:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjCMTRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 15:17:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B5214EA2
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 12:16:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A422B81150
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 19:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57F4C433D2;
        Mon, 13 Mar 2023 19:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678735005;
        bh=JWl1LraVHF8ABtgYuwqDNXqrDd+I6ILt8uJE5FbD2kk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l22n7dU4AUDTfInXbhfwgqYPQb/XoudFJ5CJaBH9VROhZceMX8L+AGmK2Qu0pJpjC
         MgswTT3zI3lHPTTMdzdUIzyuqGIlVPRpc+5fqr8Dc/uK0mepj1jriL0DCzUNumXokt
         tzFjRKM+MidtkcQGlCv7/mzSrHYGswgO58EKPCm1JTrYr18qPohuuPYF2fJKOcjOUU
         ZaDaKQ+HL28JJn9NU7jC/jmUZ1ukLRRz8rC+oT7n3Do6roVVk9lfueDh0olIHxszXJ
         K/XK0XCdJCt2demXg19NYBKIv/Qon5h76QYc1w/rXsUxHCbyKmBRXrT1X6b05/3yBN
         ttxnXr2ZMntkQ==
Date:   Mon, 13 Mar 2023 12:16:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hao Lan <lanhao@huawei.com>
Cc:     Simon Horman <simon.horman@corigine.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>, <alexander.duyck@gmail.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>, <wangjie125@huawei.com>
Subject: Re: [PATCH v3 net-next] net: hns3: support wake on lan
 configuration and query
Message-ID: <20230313121644.5f3bf4c7@kernel.org>
In-Reply-To: <3e2be728-cb68-36cf-0dd4-a62ba5601cea@huawei.com>
References: <20230310081404.947-1-lanhao@huawei.com>
        <ZAxw3PWVLiGQtTMS@corigine.com>
        <3e2be728-cb68-36cf-0dd4-a62ba5601cea@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 16:05:55 +0800 Hao Lan wrote:
> Thanks for your suggestion. Generally I follow the reverse xmas tree style
> for readability. But for this case, whether it looks a bit bloated ?

It only appears so because the driver has too many indirection layers.
Add a helper to go from netdev to the local struct.

Reminder: please don't top post and trim your replies.
