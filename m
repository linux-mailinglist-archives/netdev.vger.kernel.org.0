Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC20584ADE
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 06:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiG2E4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 00:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbiG2E4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 00:56:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBAF7B795
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 21:56:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07888B82660
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 04:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF70C433C1;
        Fri, 29 Jul 2022 04:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659070574;
        bh=jdbyNrbxXaKXqdk31zezUQG0I2zvKJciVusNARSMjCE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E3Wy69x6jvVAtTflWm1K3d9voj1idXCGZm55zaHn2yiE+r3kXlQ5PstrQpPWP+hZH
         ZR5Fib7Hue3Vx0Hp1W4z4ClXlVoe+WJSKFzBQWDm5jvm2HWLmXqb2QgYrdZudbUN3G
         l+RXp4+YaVdnAU2+nMriIuROrOF6nuQQtWfPhB4d0K7O4HUCv+RgKKjZyvlL7U3ixD
         U1CY46d9xdLwsdKIOgY2sJSE7I6jCJHBEFj3l2l6XzoP4zwYWbUyROwRgvaPMdiaK0
         g9G770t2wP8R9fe5hYTKYgaSxfCTVjoIcP4KwJKc4mweUO4FNeBoKSsqe7ZogHqfQk
         Um8HZLkQe1+7g==
Date:   Thu, 28 Jul 2022 21:56:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net-next V3 2/6] net/tls: Multi-threaded calls to TX
 tls_dev_del
Message-ID: <20220728215613.3dfa0ac9@kernel.org>
In-Reply-To: <20220727094346.10540-3-tariqt@nvidia.com>
References: <20220727094346.10540-1-tariqt@nvidia.com>
        <20220727094346.10540-3-tariqt@nvidia.com>
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

On Wed, 27 Jul 2022 12:43:42 +0300 Tariq Toukan wrote:
> +	flush_workqueue(destruct_wq);
> +	destroy_workqueue(destruct_wq);

IIRC destroy does a flush internally, please follow up.
