Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957D1527D04
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 07:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiEPFSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 01:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbiEPFSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 01:18:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F090A14D1B
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 22:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8921460F13
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 05:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6F5C385AA;
        Mon, 16 May 2022 05:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652678279;
        bh=Vh5qpVTS6967+ZQQ5TQn4YiWeTpTb7JQfsjnFo7gqpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cP2HmsJp1NMbl11/BbF13LrG1hK48YvPEL9xtYUi4TzqeMh2WcPK4+UF095GYbQ0C
         nZeOXnE3vTML2wBSpgcffpAiLoiJCre5jeg5gm1LKjXdLOdrfCvKPoh9IQu/DDAlwm
         se1cj/CMOMKy8R9vzKToBKTRiLkzrlP7AwW5pMTAlAyAlEN48SyHavLpcnFjKS/GbD
         WxHJRUtfWq570Y3dJO64hhfCUw1v3MqN3d6YxpkEPDygERO8dNED9HPgUTPxovl7iN
         NJ5GfTkc1xXwd3zNqs10z8BhmF3DekzMdMu4++pd3RE/C9BzAwaHfBgHY54PsrWqqq
         +OL9gTD/mrLcg==
Date:   Mon, 16 May 2022 08:17:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH ipsec-next 6/6] xfrm: enforce separation between
 priorities of HW/SW policies
Message-ID: <YoHedr67PscgzhTo@unreal>
References: <cover.1652176932.git.leonro@nvidia.com>
 <3d81ef1171c464d3bad05c7d9a741e12c4c160a7.1652176932.git.leonro@nvidia.com>
 <20220513150702.GN680067@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513150702.GN680067@gauss3.secunet.de>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 05:07:02PM +0200, Steffen Klassert wrote:
> On Tue, May 10, 2022 at 01:36:57PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Devices that implement IPsec full offload mode offload policies too.
> > In RX path, it causes to the situation that HW can't effectively handle
> > mixed SW and HW priorities unless users make sure that HW offloaded
> > policies have higher priorities.
> > 
> > In order to make sure that users have coherent picture, let's require to
> > make sure that HW offloaded policies have always (both RX and TX) higher
> > priorities than SW ones.
> 
> I'm still not sure whether splitting priorities in software and hardware
> is the right way to go. I fear we can get problems with corner cases we
> don't think about now. But OTOH I don't have a better idea. So maybe
> someone on the list has an opinion on that.

I see this patch as aid to catch wrong configurations of policy
priorities, at least for simple users. I didn't have a goal to
create full featured validator to don't add complexity where it
is not necessary.

Thanks
