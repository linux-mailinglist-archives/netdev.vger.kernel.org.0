Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B514E6E877B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjDTBeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDTBeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:34:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEF8173D;
        Wed, 19 Apr 2023 18:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9819F643BD;
        Thu, 20 Apr 2023 01:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E285C433D2;
        Thu, 20 Apr 2023 01:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681954451;
        bh=Bz3SmqPY3Bp5TqUZ8g55TCzoOthL+wAyFHtvrZ3YLqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fljOA0ox1NgS5xkn6OQq/DUyKs1ShdG+WDImgikgS9Dn5SwQS/F5pao1Y0HcTK/f1
         V5LxPupfC9K83NUbcLU2ab+2EuMF6mJC28dpHhmk8o6nZz0W3HoVVlpgsg+uODNd/j
         XxR/X+DMf1Wuh9qCskCy6NT88hkVoDzD5y1M9VPtH+U7NSJCqOHU/KYwTlB4CwuuA4
         rXLYt0l8fwQuIbO/wfbSl1lO9G82kYrYedKXmV7QNf/0jMGW2tpTOLivSnRMmvHCmZ
         h6H8B0kB3cZ/SxaRn37Z/o/M3tpBuK2xOVnt7Sc8QWPDt7ASayp2MuJpP8uQ3r3+6N
         K8Nwi7UYh6FyA==
Date:   Wed, 19 Apr 2023 18:34:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Louis Peens' <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>
Subject: Re: [PATCH net v2] nfp: correct number of MSI vectors requests
 returned
Message-ID: <20230419183409.1fba81b7@kernel.org>
In-Reply-To: <36322e3475804855a28c7e91a7ccdf3e@AcuMS.aculab.com>
References: <20230419081520.17971-1-louis.peens@corigine.com>
        <36322e3475804855a28c7e91a7ccdf3e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 15:37:57 +0000 David Laight wrote:
> > Before the referenced commit, if fewer interrupts are supported by
> > hardware than requested, then pci_msix_vec_count() returned the
> > former. However, after the referenced commit, an error is returned
> > for this condition. This causes a regression in the NFP driver
> > preventing probe from completing.  
> 
> I believe the relevant change to the msix vector allocation
> function has been reverted.
> (Or at least, the over-zealous check of nvec removed.)
> 
> So this change to bound the number of interrupts
> isn't needed.

Great, thanks, I was about to ask!
-- 
pw-bot: cr
