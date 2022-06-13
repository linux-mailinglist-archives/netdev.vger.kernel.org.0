Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD2A5483A3
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 11:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiFMJbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiFMJbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:31:20 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D5C183BD;
        Mon, 13 Jun 2022 02:31:19 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id n10so9992784ejk.5;
        Mon, 13 Jun 2022 02:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Nr0gFbuhYjG8KTX8QKnFSEdUb/+rTFcUGozeabqOWE=;
        b=mx2ItKYffmKzgXjYfRHKyDW7j1FcDGadMiQckYa8b0B7ZEpnMTEPvxTXszwidDjulL
         xYvjTAUAw+j73XF0phdiIry3achr1t9MUD6gkuNzQ7AuLr8IgE3CMWmV5Pf6iao8dniw
         EUmTfAokn1c1GkLj3tj4xCD4qrXCRbzejKQdamHbCClg3ixF49+nStUnuaj4HoRU0xPu
         GSTovEXJtpFp+/Y92nxbXubz3XifetHTLYR5l493u/7/LH/Y9TAc7UTl2wLoZKGpFVJw
         PS6EOfqUbi11rO0dpnSVaVsG3XtWUpdnzAC5t7CYGthz7jPgE4Sx2lHlRUfvNZiR18Fd
         raQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Nr0gFbuhYjG8KTX8QKnFSEdUb/+rTFcUGozeabqOWE=;
        b=QU38f2lNxtIueXx3csqBYpegSr1FTnkdulHVjyFgloSY00w6ARc4CA0SM0kxN6sTO/
         7n+DnSJhMsntXqxBMP+yLx9gMSMOtGODqWsTvskhDlJHTyvio91/16EtqmL8Ij4rOgOK
         MlCKx21EuGrA9tHWMZ9pqGAOkYzODqPgmqo7gKmP/3C30a0CZ+Mv0HdKxKTyTNUZ0kXZ
         u/y7/WODa9y2C8VO+VhWyfCMaie+d3fZPXhMqgtLAiqmBDoCuttDgEN+LQIBfFCf3iz9
         8iGh+1apCIm4nHX1S8hbh9sDixJylWNgZbR42edazkv31nk3uSIorC6PGjEiZIvpA/63
         W8qA==
X-Gm-Message-State: AOAM532VybJR5ss9hVOb8Y1G8WjQDWd95wXmRgEJf8YT6ZjQwLtRm6TG
        avBFjqozHd2BHXlTJgfi6n0=
X-Google-Smtp-Source: ABdhPJzj+qZa0AWWbp/fSe3FscftBmjhTfrxx880qe/hW1Y5cKf2K42zYGF5AoE7fkSuZ1Uvkq4geA==
X-Received: by 2002:a17:906:39d1:b0:6fa:8e62:c8a2 with SMTP id i17-20020a17090639d100b006fa8e62c8a2mr52889103eje.487.1655112678024;
        Mon, 13 Jun 2022 02:31:18 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id e11-20020a056402190b00b0043120d5f3dcsm4567524edz.14.2022.06.13.02.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:31:17 -0700 (PDT)
Date:   Mon, 13 Jun 2022 12:31:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC Patch net-next v2 06/15] net: dsa: microchip: get
 P_STP_CTRL in ksz_port_stp_state by ksz_dev_ops
Message-ID: <20220613093116.2gc3mc5uvzoy5jrf@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-7-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-7-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:48PM +0530, Arun Ramadoss wrote:
> At present, P_STP_CTRL register value is passed as parameter to
> ksz_port_stp_state from the individual dsa_switch_ops hooks. This patch
> update the function to retrieve the register value through the
> ksz_dev_ops function pointer.
> And add the static to ksz_update_port_member since it is not called
> outside the ksz_common.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz8795.c    |  9 +++++----
>  drivers/net/dsa/microchip/ksz9477.c    | 10 +++++-----
>  drivers/net/dsa/microchip/ksz_common.c |  9 +++++----
>  drivers/net/dsa/microchip/ksz_common.h |  5 ++---
>  4 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 8657b520b336..e6982fa9d382 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -920,9 +920,9 @@ static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
>  	ksz_pwrite8(dev, port, P_MIRROR_CTRL, data);
>  }
>  
> -static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
> +static int ksz8_get_stp_reg(void)
>  {
> -	ksz_port_stp_state_set(ds, port, state, P_STP_CTRL);
> +	return P_STP_CTRL;
>  }

Since there's nothing dynamic about get_stp_reg(), can the STP register
location stay in struct ksz_chip_data?
