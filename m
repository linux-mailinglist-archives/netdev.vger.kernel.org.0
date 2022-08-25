Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D2E5A1A9E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbiHYUyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242246AbiHYUyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:54:53 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB419764A;
        Thu, 25 Aug 2022 13:54:50 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b44so7380367edf.9;
        Thu, 25 Aug 2022 13:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=7Hk1aiGo05mEPEIQqocmEiNz0AXKLp4/P3R/nTNhcwE=;
        b=TdiyDdAc98fn1QCISp4HkOBoa7grbpQ3WUoA46SkE2imywp1y/6MegXE6P/5n3/kau
         LgaycYOnoXx3K6rrj/F9SIiaioah/GxOzw3OZXQXzWefcYm2b0nWtPlAZsXLpLVchLSB
         BIDEWwaXiq0CObxUatAsvtXzX3t4VKM2PT6thkXi8IzYlIimGNlTejvkxjtStKenfqQr
         3/RtlWAVToO4xSfLJHZfSgTO73cimU7xs2OkgddLjErOJkAKa2c6cYZcsntZk9x/Y0zK
         9WYWsSHFkEhJvC45b/Z6zFZRg6KfMftfZWMZFwLCQSFvVNKLcDCrdex915wq3oqxNPa2
         Ab0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7Hk1aiGo05mEPEIQqocmEiNz0AXKLp4/P3R/nTNhcwE=;
        b=Q855ihKK9fxGvYMnvqKS0oZjS1PhiXufEXoSAbwGpsBK6tQ0WMtkmTNXKhMUExqG1+
         QNwDfh5zrF1J679gXwmwEewqn/bzFSq22wFboZYsj//Vx+hRjjhN/QgIvQCB4Kg22/05
         /6cj2OY3ISMFTOVN/oNYCSSLDwjnlGh/vZuFbHWHUVJIQq6bQ5JZRkhj2QVxVppWg3OJ
         Z7bOODwKypujy2zlo6OZRpabnPIPWHGbHLfPVIKpcHMZEiRQWLd5obUlRxKQlYfh+NtU
         Q0S+sQ6xT976i5hf6lUWutgKjBr0qssQliOaWzRDp3j4e55yVdTOSpayxPUpCmmKLBq1
         ThdA==
X-Gm-Message-State: ACgBeo1ecwjuCogxdU2lSa+jhG4QrQduzMHCk+RV2bURbwBTZpJzN/KN
        3A6CxqciuTk+WyiwySUT/1I=
X-Google-Smtp-Source: AA6agR7B3yJoAgnu3JhwoLmDLFrioe3g2KEfDakIR1vL99dDt21YKFKtV13xQAcXmsYdVkNfl2P0gA==
X-Received: by 2002:a05:6402:280f:b0:447:17c0:4193 with SMTP id h15-20020a056402280f00b0044717c04193mr4602928ede.423.1661460889333;
        Thu, 25 Aug 2022 13:54:49 -0700 (PDT)
Received: from skbuf ([188.27.185.241])
        by smtp.gmail.com with ESMTPSA id l1-20020a1709063d2100b0073d69e8299dsm91999ejf.52.2022.08.25.13.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 13:54:48 -0700 (PDT)
Date:   Thu, 25 Aug 2022 23:54:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: [PATCH net-next v3 15/17] net: dsa: microchip: ksz9477: remove
 unused "on" variable
Message-ID: <20220825205407.jayiksjrnccpknoj@skbuf>
References: <20220823080231.2466017-1-o.rempel@pengutronix.de>
 <20220823080231.2466017-16-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080231.2466017-16-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 10:02:29AM +0200, Oleksij Rempel wrote:
> This variable is not used on ksz9477 side. Remove it.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz9477.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index bfefb60ec91bf..609bd63f4cdb1 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -1070,7 +1070,6 @@ void ksz9477_config_cpu_port(struct dsa_switch *ds)
>  
>  			/* enable cpu port */
>  			ksz9477_port_setup(dev, i, true);
> -			p->on = 1;
>  		}
>  	}
>  
> @@ -1080,7 +1079,6 @@ void ksz9477_config_cpu_port(struct dsa_switch *ds)
>  		p = &dev->ports[i];
>  
>  		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
> -		p->on = 1;
>  		if (dev->chip_id == 0x00947700 && i == 6) {
>  			p->sgmii = 1;
>  		}
> -- 
> 2.30.2
> 

And it seems like it's not used on ksz8 either. The reason I'm saying
that is that ksz8_flush_dyn_mac_table() is the only apparent user of
p->on, and that only for the case where flushing the FDB of all ports is
requested (port > dev->info->port_cnt). But ksz8_flush_dyn_mac_table()
(through dev->dev_ops->flush_dyn_mac_table) is only called from DSA's
ds->ops->port_fast_age() method, and that will never be requested
"for all ports" (and to my knowledge never was in the past, either).
Badly ported SDK code would be my guess. So there are more
simplifications which could be done.
