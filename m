Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4FC6790CC
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjAXG1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbjAXG1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:27:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE8530B17;
        Mon, 23 Jan 2023 22:27:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9135611E8;
        Tue, 24 Jan 2023 06:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04B8C433EF;
        Tue, 24 Jan 2023 06:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674541619;
        bh=0E4Oc7/Z2stBA8qPrvNH0kEWWPBwgaEO48l8pr7o85U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y0C8LuIeZXm8qzNM/0x9oaruuBIALECSGYaMY6JmMXHEt/4OO6fq6+06qZLWrY6i8
         /YYXqNse4w2KUvniABDf9pA3W11MlsCChz5gJvaziaPWU5exQ10jdXHnq18ftwwENJ
         WFWPLGpiW20wYNKbJJEXOqd9nDmLzA81okfyPzqIWTVrb6JlllE262R87ggNDsSftd
         ILWr1fy2sGPKt1lW5713650iPtEhl5Bemos7Ul6Kw5aghe/uDMFQCr1TmgUCJPph8Z
         Xu57x2nxiwSFl/idayA3VSw1jJzKxozO5QYBFU7NORPZvlvN0aI9/owULgjlII7j/5
         tcOXg3V17Py7Q==
Date:   Tue, 24 Jan 2023 08:22:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Corbet <corbet@lwn.net>, oss-drivers@corigine.com,
        linux-doc@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [Intel-wired-lan] [PATCH net-next 09/10] bonding: fill IPsec
 state validation failure reason
Message-ID: <Y895KXqtQgXOytj1@unreal>
References: <cover.1674481435.git.leon@kernel.org>
 <d563de401d6fdc1c52959300eebb2bbb27c6c181.1674481435.git.leon@kernel.org>
 <5064.1674514892@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5064.1674514892@famine>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 03:01:32PM -0800, Jay Vosburgh wrote:
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> >From: Leon Romanovsky <leonro@nvidia.com>
> >
> >Rely on extack to return failure reason.
> >
> >Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >Signed-off-by: Leon Romanovsky <leon@kernel.org>
> >---
> > drivers/net/bonding/bond_main.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index 686b2a6fd674..00646aa315c3 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -444,7 +444,7 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs,
> > 	if (!slave->dev->xfrmdev_ops ||
> > 	    !slave->dev->xfrmdev_ops->xdo_dev_state_add ||
> > 	    netif_is_bond_master(slave->dev)) {
> >-		slave_warn(bond_dev, slave->dev, "Slave does not support ipsec offload\n");
> >+		NL_SET_ERR_MSG_MOD(extack, "Slave does not support ipsec offload");
> > 		rcu_read_unlock();
> > 		return -EINVAL;
> > 	}
> 
> 	Why only this one, and not include the other similar
> slave_warn() calls in the bond_ipsec_* functions?  

Which functions did you have in mind?

The extack was added to XFRM .xdo_dev_state_add() call, which is
translated to bond_ipsec_add_sa() with only one slave_warn() print.

If you are talking about bond_ipsec_add_sa_all(), that function isn't
directly connected to netlink and doesn't have extack pointer to fill.

If you are talking about bond_ipsec_del_sai*() and slave_warn() there, it
will be better to be deleted/changed to make sure what ipsec_list have
only valid devices.

Thanks


> That would seem to make some failures show up in dmesg,
> and others returned to the caller via extack.
> 
> 	-J
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
