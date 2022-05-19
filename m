Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEAD52DC77
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241044AbiESSMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiESSMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:12:12 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888BAD9E99;
        Thu, 19 May 2022 11:12:08 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id i27so11452867ejd.9;
        Thu, 19 May 2022 11:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=u/tcYoj2hMWWn+ILOkjsnv4kELdrMc9duXiMdanlIBY=;
        b=PAlpax32REnGBe6UM04nc6urxKhuusKlKTgi6NDQN9/oquyirQk9mZTpXGTesve3OO
         YsQUThm1QciGzNS0ld94BtwjwItVDsRJ5U05fGU87A8M71xu/NYj0y7FDLnEl2kvJ9Bv
         wLdxlIT7zwfXJxn9OJubjb2oHHFSW0QpZEDo50Ar1qecyymkMWCYAGEiqTErFxDkBS9s
         CVI9S8f937yV2ui0YkJwP3+g443ROi4SsTfXk+2ZgE6qYRFv8eTVRh+C9VsBDupgEoQ1
         jm/hA1nApaPe/NOIF7yo0nt5C5stW6QK689jO5p4Y8gahS1APZRmkCWb44rmYn2TM9Gh
         BeuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=u/tcYoj2hMWWn+ILOkjsnv4kELdrMc9duXiMdanlIBY=;
        b=U+KDknF/qvkiZTM6QN4xvGo1SQJuARIa5kBtj9/qQATmRigHcdoNRT1BEXQ9NLLi0t
         JeOxvWdTljhSbZ8/MVJ6IBm/eS5pqtm9J8rE6pWaO/dJc47zQcTaxuhTVvkcmbfGh4fE
         6hNUEF6ONNTmUWKqPb2euBRBGhN2U6B4Rw0uSJ+LmPTVqw59PyoA9u7/V7wcwJBrunIG
         ZOJtfVPBcMTWtDhgs07Iuty0HKgqM2Iq4xeFq2Ty0pbXTf6TN1sVP85KKmr5b1TnvJL7
         bbG3UFIEOxv2wN8hqQTadoGDqWvo382YqUDFDHdfRsO/uoetRx1+bawzj8BtibVJJ9WB
         SLzQ==
X-Gm-Message-State: AOAM5334ekFRlzEIHnXnaEjNjawhMJr9It0grbyiY0NQaJfXB8j/Dy+P
        pdUQp9iWkDOm/R87f8hZ4SA=
X-Google-Smtp-Source: ABdhPJyRVrG3sgWlBnZuIziGhVQd7wYkwfNvSovYObVhB6EfnQAVv5rDkVsYJ4VEGD/a93SIfLvaPA==
X-Received: by 2002:a17:907:6d87:b0:6f8:95d2:6814 with SMTP id sb7-20020a1709076d8700b006f895d26814mr5555032ejc.232.1652983927138;
        Thu, 19 May 2022 11:12:07 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id ml13-20020a170906cc0d00b006fe90a8459dsm1656189ejb.166.2022.05.19.11.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:12:06 -0700 (PDT)
Date:   Thu, 19 May 2022 21:12:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 09/13] net: dsa: rzn1-a5psw: add FDB support
Message-ID: <20220519181204.7c6zjn6xqcgvyaup@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-10-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220519153107.696864-10-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 05:31:03PM +0200, Clément Léger wrote:
> +static int a5psw_port_fdb_dump(struct dsa_switch *ds, int port,
> +			       dsa_fdb_dump_cb_t *cb, void *data)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	union lk_data lk_data;
> +	int i = 0, ret;
> +	u32 reg;
> +
> +	for (i = 0; i < A5PSW_TABLE_ENTRIES; i++) {
> +		reg = A5PSW_LK_ADDR_CTRL_READ | A5PSW_LK_ADDR_CTRL_WAIT | i;
> +		mutex_lock(&a5psw->lk_lock);

It might be more efficient to lock the lookup table only once, outside
the for loop, rather than 8192 times (plus the fact that when you run
plain "bridge fdb show", this gets repeated for each switch user port,
which is a nuisance of its own).

> +
> +		ret = a5psw_lk_execute_ctrl(a5psw, &reg);
> +		if (ret) {
> +			mutex_unlock(&a5psw->lk_lock);
> +			return ret;
> +		}
> +
> +		lk_data.hi = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_HI);
> +		/* If entry is not valid or does not contain the port, skip */
> +		if (!lk_data.entry.valid ||
> +		    !(lk_data.entry.port_mask & BIT(port))) {
> +			mutex_unlock(&a5psw->lk_lock);
> +			continue;
> +		}
> +
> +		lk_data.lo = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_LO);
> +		mutex_unlock(&a5psw->lk_lock);
> +
> +		ret = cb(lk_data.entry.mac, 0, lk_data.entry.is_static, data);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
