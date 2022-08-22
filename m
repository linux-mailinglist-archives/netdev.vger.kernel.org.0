Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8707859BBEF
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiHVIq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiHVIq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:46:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957EE2CE11
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:46:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46EF0B80EA8
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 08:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68355C433C1;
        Mon, 22 Aug 2022 08:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661158011;
        bh=0eGyP9d1eyKas1crMx8dl2htkKyc58DSUmkeRs+nThU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W1vr8X/DeCXQ8XUylQdYx0RnIpGP7nsY5E39R5o9/4fV4as7np969rECVXvWLbnSc
         3YI4NfzH46s1yYLuWYTGYzRfnGtml3b6Y+uiwgkgruni2RkPi0eb8hJ2+MfCx8zB4B
         oLCfMrShSVkUxHTtcKyUb9s1x05a3kpwRIflxYCpFCqmXFkBMzUqYSwOP9xGzTbobu
         gGt0TcPWvmStxsMy8+Mq3niRWFPZUzZ4FXsvWY/5f6EXqRYb+qG6QTyH+oVloZnqAp
         X6Td5rzEH3E2ja/MXliYEqBMDxxmrmZZCeEtyEF8hzdkEudf9jQnaN8g1zDN32s29J
         abVCMqsuhU9fQ==
Date:   Mon, 22 Aug 2022 11:46:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 2/6] xfrm: allow state full offload mode
Message-ID: <YwNCd2zp6lstaeQf@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <de9490892eefc33723c1ae803adf881ad8ea621a.1660639789.git.leonro@nvidia.com>
 <20220818101220.GD566407@gauss3.secunet.de>
 <Yv4+bFE3Ck96TFP3@unreal>
 <20220822080108.GE2602992@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822080108.GE2602992@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 10:01:08AM +0200, Steffen Klassert wrote:
> On Thu, Aug 18, 2022 at 04:28:12PM +0300, Leon Romanovsky wrote:
> > On Thu, Aug 18, 2022 at 12:12:20PM +0200, Steffen Klassert wrote:
> > > On Tue, Aug 16, 2022 at 11:59:23AM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Allow users to configure xfrm states with full offload mode.
> > > > The full mode must be requested both for policy and state, and
> > > > such requires us to do not implement fallback.
> > > > 
> > > > We explicitly return an error if requested full mode can't
> > > > be configured.
> > > > 
> > > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > This one needs to be ACKed by the driver maintainers.
> > 
> > Why? Only crypto is supported in upstream kernel.
> 
> Because it touches code hat is under their maintainance.
> They should at least be CCed on this patch.

No problem, will do.

Thanks
