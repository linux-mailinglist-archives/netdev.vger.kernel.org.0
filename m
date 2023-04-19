Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FB86E7A7A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbjDSNTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbjDSNTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:19:44 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAFE146E5;
        Wed, 19 Apr 2023 06:19:42 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id fy21so38616433ejb.9;
        Wed, 19 Apr 2023 06:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681910381; x=1684502381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yagTkb97tOSUXUO/i6exQTb0DLsglQm8kN/R51CoLeM=;
        b=DbTAYMvEn3V6b4ELhVhXKtZpsyLJCQqOzTlkzgZZ5CKABJ9YHPEQyWnXLNDjrNZA8F
         OrMeCHM57zL6i9PqJ2EJWMOZXz4C66rRh7RXmfrmD2smi7cef2luVIxsUf8IAViZZMND
         o+uJ3Yu9eEDiNYsSx+V/B2hEbJqR5cPXKstjgTtNdpO2ggsEod9ulXUc6MPN8ZybCjMx
         QyPqxjeLFFVI9it6H5Ji/8TOIlvH83VnM48ZJBK3G+t3w4J4oKYUgH9QJVadzQpnQdC0
         OTXFbDEFvD4hM17FYHU2Tz1Dt0uBMae7u2hom3TcdDCWj7ir44M75U1nYCkkjkTJmZA7
         3ixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910381; x=1684502381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yagTkb97tOSUXUO/i6exQTb0DLsglQm8kN/R51CoLeM=;
        b=Fjk1i6dATGdaWhwYLX3YedGrQI/iIz7GwJhS2CqD3DWeXuNVzgMu2WUGThNY33Ne8c
         TcMv7/Wm1qF5T+H0qxRPvGeemNcZCQDsFzax7RdR5qCAN6aQGHrvEZDNncTtHuJQ3xlJ
         l9WQwpcqRsUKPQxkCujCz+rMkjZ87EjiGjAgZ+jF4RDOo7oAgboDuth8PHRPZOFqRbXZ
         xgimZtLteRB1wffEoLlx+cWjeExrX5KGEGpFuRyuusf57Q4OQlBGhRHk8+NgHPJrDxwW
         CytkWvDLcsQ1nf8ZLI5/Af3YlnAfY8M3NfB0C2tlmKH9entSOU/OkC9fhNADffjGrK9y
         LzJw==
X-Gm-Message-State: AAQBX9cSa2YVA5HUkiROydU68s9tr2w3FCI8kU5Nc+Smk/WcXvLqd95n
        l1/dzFVbhqjFu9GrY1N6Jik=
X-Google-Smtp-Source: AKy350Z1uvhTYg3923FLT4wTcoOrjylzfF1/2Ek+wyeLeIKqIC+Ry3JHCxOUkJEOK6fuEP3wCzbMoA==
X-Received: by 2002:a17:907:a2cc:b0:953:603e:e939 with SMTP id re12-20020a170907a2cc00b00953603ee939mr1724194ejc.69.1681910381040;
        Wed, 19 Apr 2023 06:19:41 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id j25-20020a1709062a1900b0094f614e43d0sm4911174eje.8.2023.04.19.06.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:19:40 -0700 (PDT)
Date:   Wed, 19 Apr 2023 16:19:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jose Abreu <Jose.Abreu@synopsys.com>
Subject: Re: [PATCH net-next v3 6/8] net: pcs: Add 10GBASE-R mode for
 Synopsys Designware XPCS
Message-ID: <20230419131938.3k4kuqucvuuhxcrc@skbuf>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-7-jiawenwu@trustnetic.com>
 <20230419082739.295180-7-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419082739.295180-7-jiawenwu@trustnetic.com>
 <20230419082739.295180-7-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 04:27:37PM +0800, Jiawen Wu wrote:
> Add basic support for XPCS using 10GBASE-R interface. This mode will
> be extended to use interrupt, so set pcs.poll false. And avoid soft
> reset so that the device using this mode is in the default configuration.

I'm not clear why the xpcs_soft_reset() call is avoided. Isn't the
out-of-reset configuration the "default" one?

> +static int xpcs_get_state_10gbaser(struct dw_xpcs *xpcs,
> +				   struct phylink_link_state *state)
> +{
> +	int ret;
> +
> +	state->link = false;
> +
> +	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT1);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & MDIO_STAT1_LSTATUS)
> +		state->link = true;
> +
> +	if (state->link) {

It seems pointless to open a new "if" statement when this would have
sufficed:

	if (ret & MDIO_STAT1_LSTATUS) {
		state->link = true;
		state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
		...
	}

> +		state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
> +		state->duplex = DUPLEX_FULL;
> +		state->speed = SPEED_10000;
> +	}
> +
> +	return 0;
> +}
