Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A91645DB3
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLGPdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLGPdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:33:17 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD4E113D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:33:15 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id d14so20447799edj.11
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 07:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LwrUVb9xSURXqii8hhhP6vjXiWv8GEEp5vfAQ1wLtCk=;
        b=QuaimEhCdfsub+L2H5uXjfZi+XE6U9sSBvyt8pqyP1McpoPW3Of7RAiBdotiqP+ohm
         eeXuS4XeNOmTyGtCwffJVhZv4DotkrmsEOhu1cr2kqRWHq+PylSAENYSiXTdIj4NDbBz
         R1+WTIT6ueiARDqNTaEFocunpxSqxtRIkoLFBym52RKVtBhJdSjg0bjhdE21itfPV7jz
         o7Crq5vsapbf2ZlH3gURsWW2coe9vo0tcU6QWi3d9APVQ1GMcdZKNuuK0ORHBfKOiTIj
         /p/uYFF9P0pwExq73u9JLjdtGAJf93KNifYFlz4Eht1uHG7SAliXu9qK0FmVbQjbIfb7
         BXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwrUVb9xSURXqii8hhhP6vjXiWv8GEEp5vfAQ1wLtCk=;
        b=VfTSYLRxNkbW1wlBusq3sGIJal94iXwHWBw1/6I/2uaMZcuRSL/9R/EB0nE83HCW+e
         9mkwAkzsHKjDLsX7Wf1xGH7wj0bV9jw3QWd1bRXumFBL+hrYejoVLFLB30ZBl9tt1pDe
         ThdKimuk5Q+NsLVBZWME0jiphx9Fu86Envloli6J4nyfq+vXxxNMTKpMQ+akBbeG/N0t
         PaVD1lHWPy+6jFh8fvZueoHhbNEqmbVn2tHorKysLkGvLYhERE+Sa44Mo3/XcQpRCC7w
         q+w7FI9N2+zyQTuwlCKg6LJ7G0qpUrYdinxFroSb12pQUZEWPta/DHCSVPSEj7rWbf07
         DldA==
X-Gm-Message-State: ANoB5pkLSoIfYB2bfE71v6cES0J/66YDShmWpdgMRdoFOI/8cL19faYn
        o7IoARyPz9X6isfi53wMuSbKcQ==
X-Google-Smtp-Source: AA0mqf67dVTwYV80bONLAbvxjUes+JRylYF8m9rIg+bo8mtFry9R7QBMuxs3i5LYQH5UdFCBACZvNA==
X-Received: by 2002:a05:6402:48d:b0:461:c3d9:c6a3 with SMTP id k13-20020a056402048d00b00461c3d9c6a3mr64263633edv.154.1670427194077;
        Wed, 07 Dec 2022 07:33:14 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s26-20020a056402015a00b00461bacee867sm2337366edu.25.2022.12.07.07.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:33:13 -0800 (PST)
Date:   Wed, 7 Dec 2022 16:33:12 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     ehakim@nvidia.com
Cc:     linux-kernel@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, sd@queasysnail.net,
        atenart@kernel.org
Subject: Re: [PATCH net-next 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute
 as part of macsec dump
Message-ID: <Y5CyOLlsB0/ZdyDS@nanopsycho>
References: <20221207101017.533-1-ehakim@nvidia.com>
 <20221207101017.533-2-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207101017.533-2-ehakim@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 11:10:17AM CET, ehakim@nvidia.com wrote:
>From: Emeel Hakim <ehakim@nvidia.com>
>
>consider IFLA_MACSEC_OFFLOAD in macsec's device dump,

Sentense starts with capital letter.


>this mandates a change at macsec_get_size to consider the
>additional attribute.

I'm unable to understand what you mean by this description. What should
the codebase consider and why?

Code looks fine.

>
>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
>---
> drivers/net/macsec.c | 11 +++++++++--
> 1 file changed, 9 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
>index 1850a1ee4380..0b8613576383 100644
>--- a/drivers/net/macsec.c
>+++ b/drivers/net/macsec.c
>@@ -4257,16 +4257,22 @@ static size_t macsec_get_size(const struct net_device *dev)
> 		nla_total_size(1) + /* IFLA_MACSEC_SCB */
> 		nla_total_size(1) + /* IFLA_MACSEC_REPLAY_PROTECT */
> 		nla_total_size(1) + /* IFLA_MACSEC_VALIDATION */
>+		nla_total_size(1) + /* IFLA_MACSEC_OFFLOAD */
> 		0;
> }
> 
> static int macsec_fill_info(struct sk_buff *skb,
> 			    const struct net_device *dev)
> {
>-	struct macsec_secy *secy = &macsec_priv(dev)->secy;
>-	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
>+	struct macsec_tx_sc *tx_sc;
>+	struct macsec_dev *macsec;
>+	struct macsec_secy *secy;
> 	u64 csid;
> 
>+	macsec = macsec_priv(dev);
>+	secy = &macsec->secy;
>+	tx_sc = &secy->tx_sc;
>+
> 	switch (secy->key_len) {
> 	case MACSEC_GCM_AES_128_SAK_LEN:
> 		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 : MACSEC_DEFAULT_CIPHER_ID;
>@@ -4291,6 +4297,7 @@ static int macsec_fill_info(struct sk_buff *skb,
> 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
> 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
> 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
>+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
> 	    0)
> 		goto nla_put_failure;
> 
>-- 
>2.21.3
>
