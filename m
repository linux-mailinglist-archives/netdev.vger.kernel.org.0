Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9EA645DB9
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiLGPff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiLGPfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:35:34 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF589F63
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:35:32 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vp12so14882117ejc.8
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 07:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ynYOXTDJ+jSbaP4iA8SQ13bAss1f1uhiQjcqDmiTglw=;
        b=WwwNOsjxvwHD6s8xzzPvCkg4ToWiYnoTrCjrr/x7v3+SU2iBeLlffNNchctzk6i5T/
         e8Y/Hu7P2qTCxS8P33notKeHaNpG8nmWSs3Llo3rmlVjJ5/iz2Twkulu7jbeoI/+vo2X
         c21vxk/ozvIGjfy0fKgGn3D861N8fV11IeVhJrG6nJuMyp8gq38XpJB0sZ7v8sjKD2Iw
         +81hq10pKgqAxl4hFkjJEJ3I9Xr8Vh2tsTrlhlaQGEsldI4xzwpi/RQSA15J1g9LWroK
         AqH9yOV+1cWjCvRrL5MU+elO/boWTB6eVUrYvjbFL+EfhvK8tjQWGQum4qYlb6vvKE97
         8BSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynYOXTDJ+jSbaP4iA8SQ13bAss1f1uhiQjcqDmiTglw=;
        b=P4tFU+PPbkKIn9qSDdhqGChPbskWq7Si279SQRvOlo0hAY0UMUurb/qPa9Vp2SQnLk
         yVXKnSHMBh74sDnZVtcDRkLmvq6kx65g0vS8xU7bXPnOrN8MnkmE0j9tfX9Dn6hVTdQN
         EjCFuKsyAoh5bk7YSpXNT8fzA5KGKNRxHq8h1affj+OMaeeL2iw9GpIPTVKPVuGxfVDX
         kUJKSSpqvFQPQA8u5G9zBx79xx/IgLqakoa+pfXUGWtI2QAZaPvMiZy+DDjrvZAOtKQS
         5S1mYy0fm25dIROrm3u8gK3yH28jZ8pUWMwrlHEjoqFFYqmfr3cRtZYzs8Dr0Uw5F+Kt
         6htg==
X-Gm-Message-State: ANoB5pkJ+DNeFcv0h4eDDrqb2NrozxjmEz3l41EIxiOzo8ARsCxUOD0n
        dO4+zTOC+fJ9W4+S0qS+QiaWAGfSpboeiJf9jq0=
X-Google-Smtp-Source: AA0mqf7pgoIqSKjUOJCg7WiXNt9q/UBQJT1tU0hIZvDz/NC3edkqWGaw8gcWN07m6k7uZOEB0ISlcw==
X-Received: by 2002:a17:906:1b48:b0:7c1:706:d63c with SMTP id p8-20020a1709061b4800b007c10706d63cmr7352480ejg.697.1670427331526;
        Wed, 07 Dec 2022 07:35:31 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kx16-20020a170907775000b007c0934db0e0sm8720403ejc.141.2022.12.07.07.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:35:30 -0800 (PST)
Date:   Wed, 7 Dec 2022 16:35:29 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     ehakim@nvidia.com
Cc:     linux-kernel@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, sd@queasysnail.net,
        atenart@kernel.org
Subject: Re: [PATCH net-next v3 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <Y5CywXgUaNMtLBGx@nanopsycho>
References: <20221207101017.533-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207101017.533-1-ehakim@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 11:10:16AM CET, ehakim@nvidia.com wrote:
>From: Emeel Hakim <ehakim@nvidia.com>
>
>Add support for changing Macsec offload selection through the
>netlink layer by implementing the relevant changes in
>macsec_change link.
>
>Since the handling in macsec_changelink is similar to macsec_upd_offload,
>update macsec_upd_offload to use a common helper function to avoid
>duplication.
>
>Example for setting offload for a macsec device:
>    ip link set macsec0 type macsec offload mac
>
>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
>---
>V2 -> V3: - Split the original patch into 3 patches, the macsec_rtnl_policy related change (separate patch)
>			to be sent to "net" branch as a fix.
>		  - Change the original patch title to make it clear that it's only adding IFLA_MACSEC_OFFLOAD
>		    to changelink
>V1 -> V2: Add common helper to avoid duplicating code 
>
> drivers/net/macsec.c | 102 +++++++++++++++++++++++++++----------------
> 1 file changed, 64 insertions(+), 38 deletions(-)
>
>diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
>index d73b9d535b7a..1850a1ee4380 100644
>--- a/drivers/net/macsec.c
>+++ b/drivers/net/macsec.c
>@@ -2583,16 +2583,45 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
> 	return false;
> }
> 
>+static int macsec_update_offload(struct macsec_dev *macsec, enum macsec_offload offload)
>+{
>+	enum macsec_offload prev_offload;
>+	const struct macsec_ops *ops;
>+	struct macsec_context ctx;
>+	int ret = 0;
>+
>+	prev_offload = macsec->offload;
>+
>+	/* Check if the device already has rules configured: we do not support
>+	 * rules migration.
>+	 */
>+	if (macsec_is_configured(macsec))
>+		return -EBUSY;
>+
>+	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
>+			       macsec, &ctx);
>+	if (!ops)
>+		return -EOPNOTSUPP;
>+
>+	macsec->offload = offload;
>+
>+	ctx.secy = &macsec->secy;
>+	ret = (offload == MACSEC_OFFLOAD_OFF) ? macsec_offload(ops->mdo_del_secy, &ctx) :
>+		      macsec_offload(ops->mdo_add_secy, &ctx);
>+
>+	if (ret)
>+		macsec->offload = prev_offload;
>+
>+	return ret;
>+}
>+
> static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
> {
> 	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
>-	enum macsec_offload offload, prev_offload;
>-	int (*func)(struct macsec_context *ctx);
> 	struct nlattr **attrs = info->attrs;
>-	struct net_device *dev;
>-	const struct macsec_ops *ops;
>-	struct macsec_context ctx;
>+	enum macsec_offload offload;
> 	struct macsec_dev *macsec;
>+	struct net_device *dev;
> 	int ret;
> 
> 	if (!attrs[MACSEC_ATTR_IFINDEX])
>@@ -2629,39 +2658,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
> 
> 	rtnl_lock();
> 
>-	prev_offload = macsec->offload;
>-	macsec->offload = offload;
>-
>-	/* Check if the device already has rules configured: we do not support
>-	 * rules migration.
>-	 */
>-	if (macsec_is_configured(macsec)) {
>-		ret = -EBUSY;
>-		goto rollback;
>-	}
>-
>-	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
>-			       macsec, &ctx);
>-	if (!ops) {
>-		ret = -EOPNOTSUPP;
>-		goto rollback;
>-	}
>-
>-	if (prev_offload == MACSEC_OFFLOAD_OFF)
>-		func = ops->mdo_add_secy;
>-	else
>-		func = ops->mdo_del_secy;
>-
>-	ctx.secy = &macsec->secy;
>-	ret = macsec_offload(func, &ctx);
>-	if (ret)
>-		goto rollback;
>-
>-	rtnl_unlock();
>-	return 0;
>-
>-rollback:
>-	macsec->offload = prev_offload;
>+	ret = macsec_update_offload(macsec, offload);
> 
> 	rtnl_unlock();
> 	return ret;
>@@ -3803,6 +3800,29 @@ static int macsec_changelink_common(struct net_device *dev,
> 	return 0;
> }
> 
>+static int macsec_changelink_upd_offload(struct net_device *dev, struct nlattr *data[])

Only data[IFLA_MACSEC_OFFLOAD] is used there. Pass just this attr.


>+{
>+	enum macsec_offload offload;
>+	struct macsec_dev *macsec;
>+
>+	macsec = macsec_priv(dev);
>+	offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
>+
>+	if (macsec->offload == offload)
>+		return 0;
>+
>+	/* Check if the offloading mode is supported by the underlying layers */
>+	if (offload != MACSEC_OFFLOAD_OFF &&
>+	    !macsec_check_offload(offload, macsec))
>+		return -EOPNOTSUPP;
>+
>+	/* Check if the net device is busy. */
>+	if (netif_running(dev))
>+		return -EBUSY;
>+
>+	return macsec_update_offload(macsec, offload);
>+}
>+
> static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
> 			     struct nlattr *data[],
> 			     struct netlink_ext_ack *extack)
>@@ -3831,6 +3851,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
> 	if (ret)
> 		goto cleanup;
> 
>+	if (data[IFLA_MACSEC_OFFLOAD]) {
>+		ret = macsec_changelink_upd_offload(dev, data);
>+		if (ret)
>+			goto cleanup;
>+	}
>+
> 	/* If h/w offloading is available, propagate to the device */
> 	if (macsec_is_offloaded(macsec)) {
> 		const struct macsec_ops *ops;
>-- 
>2.21.3
>
