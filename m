Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417955BF261
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiIUApf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiIUApd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:45:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350E578218
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 17:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C95CF6277F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7CFC433D6;
        Wed, 21 Sep 2022 00:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663721131;
        bh=Rp/6BV4OTlUBOKn+nJOgSI1ZrFQQHbOZ4nh8dT1NJS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XTp3Vbgy2l/Q0kSiUVgynuq7Epy6QNsrKmJNdpWEnJCIVP2I0WcdhZenFEACyLoRk
         MvVvpbn6QHOReW/vG7CXWjHoTrWs6KUKhATHfiBEHn+P9pHvi+c2XuZPC5/5iEXrwL
         2d7wrj+LF1e34BiflCNoGTyo2rxP4G+KM0YwdOBX1lnyj3aeUlMWirs1Ww2g+bm3Fc
         /RlHf8XN5HcRg9dd5/ERnWxa4n1mqKH6MIg1UBEqQGFSkRYRfRMPo/UB/SLX5or24w
         JqrRx+u7QYu4jdiuZBGFUbungn/yZLTQ38AMR/N7On3xnKyDwZhegPOPKhwm7xrOOU
         WijcYr12EU32Q==
Date:   Tue, 20 Sep 2022 17:45:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang He <windhl@126.com>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH] net: marvell: Fix refcounting bugs in
 prestera_port_sfp_bind()
Message-ID: <20220920174529.3e8e106d@kernel.org>
In-Reply-To: <20220915040655.4007281-1-windhl@126.com>
References: <20220915040655.4007281-1-windhl@126.com>
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

On Thu, 15 Sep 2022 12:06:55 +0800 Liang He wrote:
> In prestera_port_sfp_bind(), there are two refcounting bugs:
> (1) we should call of_node_get() before of_find_node_by_name() as
> it will automaitcally decrease the refcount of 'from' argument;
> (2) we should call of_node_put() for the break of the iteration
> for_each_child_of_node() as it will automatically increase and
> decrease the 'child'.
> 
> Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
> Signed-off-by: Liang He <windhl@126.com>

Please repost and CC all the authors of the patch under Fixes.
