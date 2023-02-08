Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB1968FA08
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 23:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjBHWDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 17:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbjBHWDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 17:03:14 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7E02ED63;
        Wed,  8 Feb 2023 14:03:13 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id p26so936802ejx.13;
        Wed, 08 Feb 2023 14:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C8Oh32imDePBhLM4FeIlT6MIjaRd6r9QbfMQEX0XdGA=;
        b=LE4L94KyO3Xi6Wh1VO3JNCpe9YTWlda3pgOyuFyIclmQ8lfJ66WiiFkqRVDB0gXG92
         ZoPCwb/6M95QyRLd7WjqhszGdPgDNcXEZ0PCvz1VZzqMD+GAHoIhLiyTragF6Ul1SWqj
         PmV255OXP3b5hj55lw3rQK5EOP15jbm2M97x5NJaZRQI64MSdRo9/ZhzUf1uzm/CzMfM
         HmoXqbY8qC8iid+T7UtTe9I3tQ+kKB111kaiDft+8ycnQMX2p+EXafVlqjkemV3eGSVR
         orr1aQwXbgJKS6jOV8wQRjugWER0EcvJHxEDX+JidlWrMJzI6Jqz8WAKOmBiajGot8QS
         ewpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C8Oh32imDePBhLM4FeIlT6MIjaRd6r9QbfMQEX0XdGA=;
        b=QfMnqILyZnFhIu+V4FQzguV2UI8OxSp7uDmqzrFCoj0b19wrIuDciepdJIOc/mNKIg
         46Aq/SaCgmW7/HWWjPgadljaOIxdy4Ex6s/0+wCYwgVz6rJWPJI0/vZavH4JcrOLabIr
         G1pYaVi9KZ5MdYkhSoSMr0SFhHmusfy3+mIhg4y/+1A+atK9K3/FIhWg1jrasJrDEw/i
         xD90zpkO8y1yojTsApF5ICAl3s+fdk4Uqe/cZjAWGFNKXdg3USLwhUI4W5xymzrYALuu
         uQZTdcb9MkRQSafsoq41eXo+3WBJ4IVRG1Vl7yCY85I3yKoq7t4l8JKrC1YK/a8qs7w7
         FzLw==
X-Gm-Message-State: AO0yUKVDqQnbXPWR9pOuJQg6OnfjT4LO9znSu0AXA4Fx/g1Dvf16ixaw
        OOH41MWuj1UcswJR6UGQHeQ=
X-Google-Smtp-Source: AK7set9lc7y4iyg50PnrD4nY3RAsR6cbyBA5LuSB9sC8bNNDMcvCudX9lg80d1kHqFBUtYe/Q44lFA==
X-Received: by 2002:a17:906:584:b0:888:6294:a1fa with SMTP id 4-20020a170906058400b008886294a1famr9417392ejn.14.1675893791875;
        Wed, 08 Feb 2023 14:03:11 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id v16-20020a170906381000b00889a9444e29sm19777ejc.14.2023.02.08.14.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 14:03:11 -0800 (PST)
Date:   Thu, 9 Feb 2023 00:03:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/3] net: dsa: rzn1-a5psw: add vlan support
Message-ID: <20230208220309.4ekk4xpmpx27rkt6@skbuf>
References: <20230208161749.331965-1-clement.leger@bootlin.com>
 <20230208161749.331965-1-clement.leger@bootlin.com>
 <20230208161749.331965-4-clement.leger@bootlin.com>
 <20230208161749.331965-4-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230208161749.331965-4-clement.leger@bootlin.com>
 <20230208161749.331965-4-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 05:17:49PM +0100, Clément Léger wrote:
> +static void a5psw_port_vlan_tagged_cfg(struct a5psw *a5psw, int vlan_res_id,
> +				       int port, bool set)
> +{
> +	u32 mask = A5PSW_VLAN_RES_WR_PORTMASK | A5PSW_VLAN_RES_RD_TAGMASK |
> +		   BIT(port);
> +	u32 vlan_res_off = A5PSW_VLAN_RES(vlan_res_id);
> +	u32 val = A5PSW_VLAN_RES_WR_TAGMASK, reg;
> +
> +	if (set)
> +		val |= BIT(port);
> +
> +	/* Toggle tag mask read */
> +	a5psw_reg_writel(a5psw, vlan_res_off, A5PSW_VLAN_RES_RD_TAGMASK);
> +	reg = a5psw_reg_readl(a5psw, vlan_res_off);
> +	a5psw_reg_writel(a5psw, vlan_res_off, A5PSW_VLAN_RES_RD_TAGMASK);

Is it intentional that this register is written twice?

> +
> +	reg &= ~mask;
> +	reg |= val;
> +	a5psw_reg_writel(a5psw, vlan_res_off, reg);
> +}
