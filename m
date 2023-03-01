Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C196A6C4F
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 13:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCAM1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 07:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCAM1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 07:27:16 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9476938B4D;
        Wed,  1 Mar 2023 04:27:15 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f13so53046330edz.6;
        Wed, 01 Mar 2023 04:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vjyKzetsdCA/QRujZI9IXa0a4bewWM2RudwPgH7SuU4=;
        b=BGD0N42T/Gof41cFyirO06KlrDz5ljZf4yXNgIdJpxuDNrV/IpPzs1QGorYWZT67P+
         XTpqcABSh58qp97WLtRqSaUj6izIoZ+gSDL2dEluMa4cQndY6qf3C75fF3cwnxIR0Qgr
         ieCTwDzxx61ZMhyUdiIaGV+OG8uwgNnZZMQqzVyw/3yqEJojIrq5h+HZtqR4J2vYBWcb
         uNWhOAr7x8q16N2/av1KRo8uJ6ey4eLEPdGbUcKBpKuAsvzeWFA0Xvb25f+h/9eJcrwG
         v4JbpN0njGKp0ri4K4i39GQxQhzoln0n/n0hd9JxUUWKSYZd7vdaljxHbdWLDyqcRS01
         /eTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjyKzetsdCA/QRujZI9IXa0a4bewWM2RudwPgH7SuU4=;
        b=KvGxNMeF/ExDnOmNv/G6wX8mXrxVBLTMKQMHAmso/IJUMt8SBjl1cmc0SmAUMu3SUg
         aGl3YQXu+bDQDzntPut6I+SzZ5uYyZJ9H6RpffaXhSXhqc9VWUgQFglaCqErT28/hozm
         oRACq6ErpOoU2OsEaGjchjwdbFXtPjiZ/R71PY1xe4gsaA3RCBpo/aA0iP0QHI8vIf6m
         KIgUs8IrvFADhZKxhJ4LW8qJySWRDNl4EHZ2pNeTF0csHGGK/Dl4Zwzfp9ng92BnULS7
         BJqi75JWPrDWf5LzoVes0ABbv0CKPtSs04U7Ju3Ierk+QjckwO1co01xLw48TCgt8nYD
         sRPw==
X-Gm-Message-State: AO0yUKV9BI9sgd/5J09SeaGxCChp2T+oEgS9gx86aqRNPoyb6ipRqvK1
        UBghppCpiGyuaKBgToM+daGCXpOLoru2og==
X-Google-Smtp-Source: AK7set85tCjm3mNjVi+5RAAm0lp7/gT2Fp+7P3Yms5FYEcQDvIVQ4a1mhnZ3+rt+M/p1RyhcDe+IYw==
X-Received: by 2002:a17:907:d489:b0:8f2:62a9:6159 with SMTP id vj9-20020a170907d48900b008f262a96159mr6952583ejc.2.1677673633874;
        Wed, 01 Mar 2023 04:27:13 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id t8-20020a170906178800b008dcf89a72d7sm5852526eje.147.2023.03.01.04.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 04:27:13 -0800 (PST)
Date:   Wed, 1 Mar 2023 14:27:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] net: lan966x: Fix port police support using
 tc-matchall
Message-ID: <20230301122711.2eqlbjplitrpktdj@skbuf>
References: <20230228204742.2599151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228204742.2599151-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 09:47:42PM +0100, Horatiu Vultur wrote:
> When the police was removed from the port, then it was trying to
> remove the police from the police id and not from the actual
> police index.
> The police id represents the id of the police and police index
> represents the position in HW where the police is situated.
> The port police id can be any number while the port police index
> is a number based on the port chip port.
> Fix this by deleting the police from HW that is situated at the
> police index and not police id.
> 
> Fixes: 5390334b59a3 ("net: lan966x: Add port police support using tc-matchall")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_police.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
> index a9aec900d608d..7d66fe75cd3bf 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
> @@ -194,7 +194,7 @@ int lan966x_police_port_del(struct lan966x_port *port,
>  		return -EINVAL;
>  	}
>  
> -	err = lan966x_police_del(port, port->tc.police_id);
> +	err = lan966x_police_del(port, POL_IDX_PORT + port->chip_port);
>  	if (err) {
>  		NL_SET_ERR_MSG_MOD(extack,
>  				   "Failed to add policer to port");
> -- 
> 2.38.0
> 

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

but the extack message is also wrong; it says it failed to add the
policer, when the operation that failed was a deletion.
