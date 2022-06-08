Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C27543613
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiFHPJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbiFHPJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:09:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C0F41C2B3;
        Wed,  8 Jun 2022 07:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 693F9B8284C;
        Wed,  8 Jun 2022 14:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EABC34116;
        Wed,  8 Jun 2022 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654700309;
        bh=/L6Z0/s3Qk30K+HFd4XuKvY7Ku6Ad/XQ0r4A3ePbSwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R24PkBKLGmeLQF3YM2t6LP6LgKCzFTf30qZTsbef97EW2IaN6fUIXn3aaWjXlW8PD
         JEBs5XlkemP80qwBoVx/bQ4CHugVs+gA1+nKPYSdNnYqkp+mQY4RxAUg3acGKu6pYg
         Xbfh5dKIEvfo4Jn2yi0rUA+N/QgloWZdll6IxFq6GyxAy+AH9AYqjSTFpq3nK9ggGh
         qYLUI+UxElpb0LKNyRwxKIaQtpcw7OqqqpqgJRsOQ8+4SlJCG+MUa0is+9rdnkLavU
         jFpCDBhynxgcooRtT7wuSb+9tc0eP9fqvZC2bfD44QU1aKDRz4eLqGea919fdxRMt6
         FX9UnRTJP4ApQ==
Date:   Wed, 8 Jun 2022 07:58:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, dsahern@kernel.org,
        steffen.klassert@secunet.com, jreuter@yaina.de,
        razor@blackwall.org, kgraul@linux.ibm.com, ivecera@redhat.com,
        jmaloy@redhat.com, ying.xue@windriver.com, lucien.xin@gmail.com,
        arnd@arndb.de, yajun.deng@linux.dev, atenart@kernel.org,
        richardsonnick@google.com, hkallweit1@gmail.com,
        linux-hams@vger.kernel.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net-next] net: rename reference+tracking helpers
Message-ID: <20220608075827.2af7a35f@kernel.org>
In-Reply-To: <YqBdY0NzK9XJG7HC@nanopsycho>
References: <20220608043955.919359-1-kuba@kernel.org>
        <YqBdY0NzK9XJG7HC@nanopsycho>
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

On Wed, 8 Jun 2022 10:27:15 +0200 Jiri Pirko wrote:
> Wed, Jun 08, 2022 at 06:39:55AM CEST, kuba@kernel.org wrote:
> >Netdev reference helpers have a dev_ prefix for historic
> >reasons. Renaming the old helpers would be too much churn  
> 
> Hmm, I think it would be great to eventually rename the rest too in
> order to maintain unique prefix for netdev things. Why do you think the
> "churn" would be an issue?

Felt like we're better of moving everyone to the new tracking helpers
than doing just a pure rename. But I'm not opposed to a pure rename.

> >diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> >index 817577e713d7..815738c0e067 100644
> >--- a/drivers/net/macsec.c
> >+++ b/drivers/net/macsec.c
> >@@ -3462,7 +3462,7 @@ static int macsec_dev_init(struct net_device *dev)
> > 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
> > 
> > 	/* Get macsec's reference to real_dev */
> >-	dev_hold_track(real_dev, &macsec->dev_tracker, GFP_KERNEL);
> >+	netdev_hold(real_dev, &macsec->dev_tracker, GFP_KERNEL);  
> 
> So we later decide to rename dev_hold() to obey the netdev_*() naming
> scheme, we would have collision.

dev_hold() should not be used in new code, we should use tracking
everywhere. Given that we can name the old helpers __netdev_hold().

> Also, seems to me odd to have:
> OLDPREFIX_x()
> and
> NEWPREFIX_x()
> to be different functions.
> 
> For the sake of not making naming mess, could we rather have:
> netdev_hold_track()
> or
> netdev_hold_tr() if the prior is too long
> ?

See above, one day non-track version should be removed.
IMO to encourage use of the track-capable API we could keep their names
short and call the legacy functions __netdev_hold() as I mentioned or
maybe netdev_hold_notrack().
