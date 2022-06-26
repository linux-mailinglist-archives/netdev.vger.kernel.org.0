Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD6E55B28E
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 17:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiFZPI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 11:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiFZPIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 11:08:23 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B32B7C4;
        Sun, 26 Jun 2022 08:08:19 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 25QF7g7c557702;
        Sun, 26 Jun 2022 17:07:42 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 25QF7g7c557702
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1656256063;
        bh=LGPEL3i9mnlk6FgAfOfRBqIGs5jo7TW+YPJ67QMMXIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BIUVc5AF5YRFb3yPeWm89XIry5JW3ZNWeY1kzxMGDcoIxpa+GNBtXckhgoI+8w/fT
         1zNSoT7AhlDKKL1+hJJ9wFYsFVokCC3OED9ewkcWHzMLq9mtOTl6XSS7BmkN+iuLc4
         Tw5zK1ax5+kc3BzaPYqljWwhrPK7mxYp4p+lxqZg=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 25QF7dLd557701;
        Sun, 26 Jun 2022 17:07:39 +0200
Date:   Sun, 26 Jun 2022 17:07:38 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Yilun Wu <yiluwu@cs.stonybrook.edu>
Subject: Re: [PATCH] epic100: fix use after free on rmmod
Message-ID: <Yrh2Om1c7ins9VrK@electric-eye.fr.zoreil.com>
References: <20220623074005.259309-1-ztong0001@gmail.com>
 <YrQw1CVJfIS18CNo@electric-eye.fr.zoreil.com>
 <20220624114121.2c95c3aa@kernel.org>
 <CAA5qM4Aq_2HSxCgaHUgZX9C3E0OCPT4tN-61-MZP1iLXCbF-=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA5qM4Aq_2HSxCgaHUgZX9C3E0OCPT4tN-61-MZP1iLXCbF-=Q@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tong Zhang <ztong0001@gmail.com> :
[...]
> Looks like drivers/net/ethernet/smsc/epic100.c is renamed from
> drivers/net/epic100.c and this bug has been around since the very
> initial commit.
> What would you suggest ? Remove the fix tag or use
> Fix: 1da177e4c3f4 ("Linux-2.6.12-rc2")

'Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")' has already been signed-by or
directly used by maintainers, including netdev ones. See:

$ git log --grep='^Fixes: 1da177e4c3f4'

The patch will require some change for pre-5.9 stable kernels due to
63692803899b563f94bf1b4f821b574eb74316ae "epic100: switch from 'pci_' to 'dma_' API".

-- 
Ueimor
