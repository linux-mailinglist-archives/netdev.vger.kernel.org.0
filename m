Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C39F527D05
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 07:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiEPFSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 01:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbiEPFSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 01:18:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B3E35A9E
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 22:18:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E9C6B80E7D
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 05:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80431C385B8;
        Mon, 16 May 2022 05:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652678300;
        bh=bZKuirXbdRT+42w0VWYtpuhaPyJUMhg+aPcqDgkUc74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bfg98k5G9Quj4tQh/oF+QbMF9jq+H12igTaAw8vfNedIaJtgH28VJB0dPQE2Qlsuc
         pwGc/Hm2GmnsuyQhz5U8Gu9bljY55yhF2138C/nAInL05ZHr+mARPCgVfbgJYh3Dm/
         zUnV89TLHSQKPYermzbxWiUJO5uVDjX0shmIWkqynuxhG8ma4AiOp6Jq5UN2nU/XG3
         TYTNU9GbQdYaXBLIANAdXc4LJATw75tH428eAqH49JOvZ4gaaMfPjkxa5+unDm6JVo
         n7HnakObMiwMitieDrlTJk6GQeM3WnEm86BsZtKMrPJFdkz3B30MtLxjDCaEhD+Or7
         L1qHCwAL4cGbw==
Date:   Mon, 16 May 2022 08:18:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH ipsec-next 3/6] xfrm: add an interface to offload policy
Message-ID: <YoHel1LqqtNe0U01@unreal>
References: <cover.1652176932.git.leonro@nvidia.com>
 <66ec5e0b1ac8c5570391830473bc538650be04e0.1652176932.git.leonro@nvidia.com>
 <20220513144432.GK680067@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513144432.GK680067@gauss3.secunet.de>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 04:44:32PM +0200, Steffen Klassert wrote:
> On Tue, May 10, 2022 at 01:36:54PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >  
> > +int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
> > +			struct xfrm_user_offload *xuo, u8 dir)
> > +{
> > +	struct xfrm_dev_offload *xdo = &xp->xdo;
> > +	struct net_device *dev;
> > +	int err;
> > +
> > +	if (!xuo->flags || xuo->flags & ~XFRM_OFFLOAD_FULL)
> > +		/* We support only Full offload mode and it means
> > +		 * that user must set XFRM_OFFLOAD_FULL bit.
> > +		 */
> > +		return -EINVAL;
> 
> Minor nit: Please add the comment before the 'if' statement or
> use braces.

Sure, will do.
