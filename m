Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0789C525B1F
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 07:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377131AbiEMFrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 01:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377127AbiEMFre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 01:47:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4FF4C402
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 22:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EE3161B8F
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 05:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E30C34100;
        Fri, 13 May 2022 05:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652420852;
        bh=YsgL1I9t2EMaw1F+ImkOdOX0X71ecmG8hE1TuD6mlmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PoKBBGhNm65xRzHfVOpupQrpzZzeAlK1Xw4eikDfZ6sd2ZhM/xvjoHxHZNBg51c5D
         sX1/0VI8vTCBTUCoqg+kQTkq6x07zYyJ1V+VCnV6A5lJV8A94ZaHyDQoWTbxD3ePs3
         IUCXZDGZSscw21VxwBWnpEMZGcuaPWFQyo670z/iDep0PUBkV4PMFmw4r7quQ99NB9
         4h3c3+B7PnY56wnW835Sm3W+WjdegmrZOKGRe2Pj5FGP/W5jFoSzNsXw2eIqTtpfBm
         Rd0lZJBed7c/OVNIvOcWZwSIrQnpZvp4ICPDGc3b6ALjEeIgovhiMU0yduk4+xXnFP
         evBfDCFWwA9gw==
Date:   Fri, 13 May 2022 08:47:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        johannes@sipsolutions.net, pablo@netfilter.org,
        laforge@gnumonks.org, Jason@zx2c4.com
Subject: Re: [RFC net-next] net: add ndo_alloc_and_init and ndo_release to
 replace priv_destructor
Message-ID: <Yn3w8M3PuKUdzQYI@unreal>
References: <20220511191218.1402380-1-kuba@kernel.org>
 <20220511234328.GO49344@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511234328.GO49344@nvidia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 08:43:28PM -0300, Jason Gunthorpe wrote:
> On Wed, May 11, 2022 at 12:12:18PM -0700, Jakub Kicinski wrote:
> > Old API

<...>

> I would be happier if netdev was more like everything else and allowed
> a clean alloc/free vs register/unregister pairing. The usual lifecycle
> model cast to netdev terms would have the release function set around
> alloc_netdev and always called once at free_netdev.
> 
> The caller should set the ops and release function after it has
> completed initializing whatever its release will undo, similare to how
> device_initialize()/put_device works.

Exactly, it will give much clearer picture of netdev life cycle than it
is now.

Thanks
