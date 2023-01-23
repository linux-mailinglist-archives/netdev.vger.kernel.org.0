Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB27F678278
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbjAWRC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjAWRCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:02:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AB4D3;
        Mon, 23 Jan 2023 09:02:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D3FDB80BA2;
        Mon, 23 Jan 2023 17:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6F9C433EF;
        Mon, 23 Jan 2023 17:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674493370;
        bh=N50BI0eAmKLyjzAgI2VcGiyz4oyDgkoQN9/RlfmJQ9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g8lMhEHWsshNL4zKOk9nAg2yTrPyeUIAoqur5h7IY9O+Xu/yeqLKrDaRpDPfHEKlA
         O9b0S8d0aMfBF4hs+p8h8OTTD6RhVX29cZ8lmhjhMBk44lnEkYC7C2QQS/TCYMJsCh
         2Q17QM/4AykEFk7NAvhkQUJVk4HeWAimyaCTWCJSpFbLJ8e1g+fC6ZC8KtmHIn7I+m
         Zj2EBxvuIEu4ChmAbD1NKEnXo8Fs3uGhB6TNpVHQV1mWuULrdW+9pNcoIak83EL03h
         3xDS4mNwVU8sUHzSKEvMv3+IbtxsCW8i8Zd7dyGqhU0F9QtfFQajKwNMEOUxdqRBnZ
         334Ir4u3bWiCw==
Date:   Mon, 23 Jan 2023 18:34:26 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next 06/10] nfp: fill IPsec state validation failure
 reason
Message-ID: <Y863Eg9XKcxzZET+@unreal>
References: <cover.1674481435.git.leon@kernel.org>
 <99049389f2f4fb967aac8026bd05f36ea13c47aa.1674481435.git.leon@kernel.org>
 <Y86jIClrwWJsPk9v@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y86jIClrwWJsPk9v@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 04:09:20PM +0100, Simon Horman wrote:
> On Mon, Jan 23, 2023 at 04:00:19PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Rely on extack to return failure reason.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leon@kernel.org>
> 
> One minor suggestion below, but regardless this looks good to me.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> > ---
> >  .../net/ethernet/netronome/nfp/crypto/ipsec.c | 38 +++++++++----------
> >  1 file changed, 19 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
> > index 41b98f2b7402..7af41cbc8c0b 100644
> > --- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
> > +++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
> 
> ...
> 
> >  	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
> > -		nn_err(nn, "Unsupported xfrm offload tyoe\n");
> > +		NL_SET_ERR_MSG_MOD(extack, "Unsupported xfrm offload tyoe");
> 
> While we are here, maybe s/tyoe/type/ ?

Sure, will fix.

Thanks

> 
> ...
