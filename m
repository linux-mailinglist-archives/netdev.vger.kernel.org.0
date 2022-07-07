Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25B856A11B
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbiGGLfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbiGGLfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:35:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B808326EA
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 04:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657193707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iR0TS1rdC3FNDtz2eTB0475ADyLRcoJ2o6s9EpnIbtI=;
        b=G2H//MoUlqhU0fzXJssWKxi09XZLcwqf0AgZA6XJ8OeUReMoasO0bknhHlaPnD/y2K/0KM
        9ba7245GeI/DfpAzCS89IAuKLa5iGyBUouESqreNxWCiFuy8/GI1lFKA0ZWUbkdKHyYhbg
        6QT6PeUJ6SF6nt294mJqiQDu2Qz17Ms=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-I_hhwyMZMvOvQE5GLD05ig-1; Thu, 07 Jul 2022 07:35:05 -0400
X-MC-Unique: I_hhwyMZMvOvQE5GLD05ig-1
Received: by mail-wm1-f69.google.com with SMTP id m20-20020a05600c4f5400b003a03aad6bdfso7975633wmq.6
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 04:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=iR0TS1rdC3FNDtz2eTB0475ADyLRcoJ2o6s9EpnIbtI=;
        b=fCfYI782X/qaNth4ADPVpjiST3ZQrG5UI594afmqBe6N4BOg7o4rBoG+MCdt0dp3WB
         9MhvRzej7cCyJKXWksdIzsuQnB2ap7M48gU61U5pp1kzKbnuao6Z2umzvvnHB2DuqQIw
         fvM3d0WLwP5RW6crSq5ZtHcD9MDX4acbYUvfarCvt1wvTqy/SOncu9uuJvXQKnLnirvV
         1P8/AiFejFaLSsyOpjLoCQDIasq0T0du1K2+zTKsxlwokNmyDBUju6nmZxJ4H0jL4uS8
         JPPM+X9zCLZ7m7kA+SKTq80T5rC31KKbGblw9qiPUKNChG1hETI8NcM9c9MEl4SPvLmO
         U83w==
X-Gm-Message-State: AJIora+KQxLXNqb55hOZACb16QtkyszSaoVg2QcrDJ9PUnBSMk96cjVw
        jGPeVVv6U+TOSQ2aUVwBo8aZs3xKqI1NaQi0CEdZ58/MYZhyw4wJSRpZEclXf0k2OvxpjOLqaHJ
        MovPmgkTYBYi5k1fj
X-Received: by 2002:adf:fbc6:0:b0:21d:3fc3:99e with SMTP id d6-20020adffbc6000000b0021d3fc3099emr36304139wrs.550.1657193704582;
        Thu, 07 Jul 2022 04:35:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t15sMd6i1XfxQwEkr60GDGWRAtRhcRRPtx84aoNyLkcHeIr2MlpQD4oPg0UNU5SC7GGAzqaA==
X-Received: by 2002:adf:fbc6:0:b0:21d:3fc3:99e with SMTP id d6-20020adffbc6000000b0021d3fc3099emr36304105wrs.550.1657193704250;
        Thu, 07 Jul 2022 04:35:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id b10-20020a5d4d8a000000b0021d4aca9d1esm20916457wru.99.2022.07.07.04.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:35:03 -0700 (PDT)
Message-ID: <0c5fdfc7dbe3c48b884640c57857248e47794b6a.camel@redhat.com>
Subject: Re: [PATCH net v3] net: ethernet: ti: am65-cpsw: Fix devlink port
 register sequence
From:   Paolo Abeni <pabeni@redhat.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, vigneshr@ti.com, grygorii.strashko@ti.com
Date:   Thu, 07 Jul 2022 13:35:02 +0200
In-Reply-To: <5d06687a-17f1-4d5c-7d3f-83d11e5ec2e7@ti.com>
References: <20220706070208.12207-1-s-vadapalli@ti.com>
         <e454f6de32de3be092260d19da24f58635eb6e49.camel@redhat.com>
         <5d06687a-17f1-4d5c-7d3f-83d11e5ec2e7@ti.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-07-07 at 14:41 +0530, Siddharth Vadapalli wrote:
> Hello Paolo,
> 
> On 07/07/22 13:00, Paolo Abeni wrote:
> > On Wed, 2022-07-06 at 12:32 +0530, Siddharth Vadapalli wrote:
> > > Renaming interfaces using udevd depends on the interface being registered
> > > before its netdev is registered. Otherwise, udevd reads an empty
> > > phys_port_name value, resulting in the interface not being renamed.
> > > 
> > > Fix this by registering the interface before registering its netdev
> > > by invoking am65_cpsw_nuss_register_devlink() before invoking
> > > register_netdev() for the interface.
> > > 
> > > Move the function call to devlink_port_type_eth_set(), invoking it after
> > > register_netdev() is invoked, to ensure that netlink notification for the
> > > port state change is generated after the netdev is completely initialized.
> > > 
> > > Fixes: 58356eb31d60 ("net: ti: am65-cpsw-nuss: Add devlink support")
> > > Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> > > ---
> > > Changelog:
> > > v2 -> v3:
> > > 1. Add error handling to unregister devlink.
> > > 
> > > v1-> v2:
> > > 1. Add Fixes tag in commit message.
> > > 2. Update patch subject to include "net".
> > > 3. Invoke devlink_port_type_eth_set() after register_netdev() is called.
> > > 4. Update commit message describing the cause for moving the call to
> > >    devlink_port_type_eth_set().
> > > 
> > > v2: https://lore.kernel.org/r/20220704073040.7542-1-s-vadapalli@ti.com/
> > > v1: https://lore.kernel.org/r/20220623044337.6179-1-s-vadapalli@ti.com/
> > > 
> > >  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 17 ++++++++++-------
> > >  1 file changed, 10 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> > > index fb92d4c1547d..f4a6b590a1e3 100644
> > > --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> > > +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> > > @@ -2467,7 +2467,6 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
> > >  				port->port_id, ret);
> > >  			goto dl_port_unreg;
> > >  		}
> > > -		devlink_port_type_eth_set(dl_port, port->ndev);
> > >  	}
> > >  	devlink_register(common->devlink);
> > >  	return ret;
> > > @@ -2511,6 +2510,7 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
> > >  static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
> > >  {
> > >  	struct device *dev = common->dev;
> > > +	struct devlink_port *dl_port;
> > >  	struct am65_cpsw_port *port;
> > >  	int ret = 0, i;
> > >  
> > > @@ -2527,6 +2527,10 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
> > >  		return ret;
> > >  	}
> > >  
> > > +	ret = am65_cpsw_nuss_register_devlink(common);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > >  	for (i = 0; i < common->port_num; i++) {
> > >  		port = &common->ports[i];
> > >  
> > > @@ -2539,25 +2543,24 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
> > >  				i, ret);
> > >  			goto err_cleanup_ndev;
> > >  		}
> > > +
> > > +		dl_port = &port->devlink_port;
> > > +		devlink_port_type_eth_set(dl_port, port->ndev);
> > >  	}
> > >  
> > >  	ret = am65_cpsw_register_notifiers(common);
> > >  	if (ret)
> > >  		goto err_cleanup_ndev;
> > >  
> > > -	ret = am65_cpsw_nuss_register_devlink(common);
> > > -	if (ret)
> > > -		goto clean_unregister_notifiers;
> > > -
> > >  	/* can't auto unregister ndev using devm_add_action() due to
> > >  	 * devres release sequence in DD core for DMA
> > >  	 */
> > >  
> > >  	return 0;
> > > -clean_unregister_notifiers:
> > > -	am65_cpsw_unregister_notifiers(common);
> > > +
> > >  err_cleanup_ndev:
> > >  	am65_cpsw_nuss_cleanup_ndev(common);
> > > +	am65_cpsw_unregister_devlink(common);
> > 
> > It looks strange that there is no error path leading to
> > am65_cpsw_unregister_devlink() only.
> > 
> > Why we don't need to call it when/if devm_request_irq() fails? 
> 
> am65_cpsw_nuss_register_devlink() is invoked after devm_request_irq() and
> devm_request_irq()'s associated error handling.

Whoops, I misread the exact location were
am65_cpsw_nuss_register_devlink() is located after this patch.  

That error path now LGTM.

> > 
> > Not strictly related to this patch, but it looks like there is another
> > suspect cleanup point: if a 'register_netdev()' call fails, the cleanup
> > code will still call unregister_netdev() on the relevant device and the
> > later ones, hitting a WARN_ON(1) in unregister_netdevice_many().
> 
> Thank you for pointing it out. I will look at it and address it in a separate
> cleanup patch.

Thanks!

Paolo

