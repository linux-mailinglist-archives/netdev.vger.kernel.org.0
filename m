Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014775808B3
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 02:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbiGZAR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 20:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiGZAR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 20:17:26 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1EF2497F;
        Mon, 25 Jul 2022 17:17:25 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id mf4so23454034ejc.3;
        Mon, 25 Jul 2022 17:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oegRzPvhEXy0RuRC470612+PNk6XDdhRUUgEKb6Yhw4=;
        b=HWQ1fG98udOeFnE6AU0udN33g8gV72IHhvVYo9k/QK2jVEm0V3p6wyAu4jE2fBlif0
         pR57kKLAAeF1+z7j+Y8We1wOOi1VKwasXWwxbY+uqDu3S+U3q0X0kBAEYajNs6C9V9Mj
         8kE5kV58luSxS/+dNo/HOp/ey0XO6++0M5iUHQPaW2Pn2oEEdACf3n3zoZ8Pc3spWTGO
         RxN3T13JnI1O8xp/WyvxKmMjmgFfRDcpV6o4ezZQBvsPYZYJFkp1qQYr8jMAAuKY+mNN
         /IstELYEeO6R6O851esZUTzRYkYYrRYxIV0BpqSXdJnS7jRjUqKO6wjaUKmG/RH0thx+
         sfZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oegRzPvhEXy0RuRC470612+PNk6XDdhRUUgEKb6Yhw4=;
        b=vj9DlBV90j7l9HIwI/o3uOZq/vsdO5Azv2KjKHvcHNvrxFQnskNdgxNS1CJmvFfyLu
         ogSBWNwJA+Pckqzysor57ZEwhLicAOrnP6IZPk+j3KWoxgksOb1iRn48Jz7nSoEKXGyb
         57YuvPKWKkpS43MN292tTLQMxMQ+ZxR25NYxCAmYkoOT0RE2BfhhhHeTPNGq5Ej3K9aH
         JRi9M3yg4iWOzqxK2U5VINP5f0LLxDY04DhcV3yPrVmFHxSpY+f7jZrZM/3NyoqYY0aD
         ioCWrx+7ToXMw+WL2Y5MLqtT3PO0VheXzXlaT6FDtx6borcQmIoNyP7HB+rdRN+zukJs
         gHaQ==
X-Gm-Message-State: AJIora9ixQOWpb1rTmRE/jL6hA7ENCAu7oZN7JLTy5BFHzeOxNoTnVnM
        pS+7TikkkPqSbVZ502wH+9N+TrYt3NC6xA==
X-Google-Smtp-Source: AGRyM1tkSz7iPceEXBAdwCvJugSsT5xFiZNf6UVIeafmXzAA6CG19dQXYigE2LM59CGI1N5hy3nIJg==
X-Received: by 2002:a17:907:1dce:b0:72b:40c4:deec with SMTP id og14-20020a1709071dce00b0072b40c4deecmr12646645ejc.70.1658794644128;
        Mon, 25 Jul 2022 17:17:24 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id h23-20020aa7c957000000b0043bea0a48d0sm3279112edt.22.2022.07.25.17.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 17:17:23 -0700 (PDT)
Date:   Tue, 26 Jul 2022 03:17:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [net-next PATCH v4 09/14] net: dsa: qca8k: move set age/MTU/port
 enable/disable functions to common code
Message-ID: <20220726001720.d75t26oigcdp2eca@skbuf>
References: <20220724201938.17387-1-ansuelsmth@gmail.com>
 <20220724201938.17387-1-ansuelsmth@gmail.com>
 <20220724201938.17387-10-ansuelsmth@gmail.com>
 <20220724201938.17387-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724201938.17387-10-ansuelsmth@gmail.com>
 <20220724201938.17387-10-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 10:19:33PM +0200, Christian Marangi wrote:
> The same set age, MTU and port enable/disable function are used by
> driver based on qca8k family switch.
> Move them to common code to make them accessible also by other drivers.
> While at it also drop unnecessary qca8k_priv cast for void pointers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
> index a50c21c90e81..7e573827dac6 100644
> --- a/drivers/net/dsa/qca/qca8k-common.c
> +++ b/drivers/net/dsa/qca/qca8k-common.c
> @@ -373,3 +373,91 @@ void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
>  	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
>  		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
>  }
> +
> +int
> +qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)

Same comment about prototypes now fitting a single line. I won't be
making this comment everywhere.

> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	unsigned int secs = msecs / 1000;
> +	u32 val;
> +
> +	/* AGE_TIME reg is set in 7s step */
> +	val = secs / 7;
> +
> +	/* Handle case with 0 as val to NOT disable
> +	 * learning
> +	 */
> +	if (!val)
> +		val = 1;
> +
> +	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL, QCA8K_ATU_AGE_TIME_MASK,
> +				  QCA8K_ATU_AGE_TIME(val));

Maybe now would be a good time to trim this line to 80 characters?
Networking wasn't a huge fan of the 100 character limit increase,
I think this might even be pointed out in the process docs.
