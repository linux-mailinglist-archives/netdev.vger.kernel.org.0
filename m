Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912A96943CD
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBMLF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBMLF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:05:56 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B04A59CE;
        Mon, 13 Feb 2023 03:05:55 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id hn2-20020a05600ca38200b003dc5cb96d46so10968586wmb.4;
        Mon, 13 Feb 2023 03:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UGKpDQnjHC7Urptl7Q3KiUrKg/ahx4TWIAXabQRXRA8=;
        b=gDCGZbYrSRwaTQ0tkvk/gx5CDElNYeN35kU8CMo20AXmrG//Tvo2WZFZtDybu9RGjt
         aBsK6vXWLmNXgs/PicSByCFZy0u2Rgnmotva6Yl8M1fjkejB6w5Z4uvmB8+WA7UVgC5w
         TB8M2HBh8mrK3tGI+5IQ4S6zR9bbBXzFtr+ko5akmvJosPe5hxtd8u2QJaply/y3a9Ev
         yoUi5fG4dE36eXg8ao8m2Le7lXGW7IN4HTy0YJPhDNGsdh9fL8hgY0xbP93Gn7Q6XAF8
         QPytSsHF0EYPKf75rHY8Jt/1dsxofLI8LbtuReGsszO4podoPOLSdVMxEiNBa2jpJ4Fj
         r86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGKpDQnjHC7Urptl7Q3KiUrKg/ahx4TWIAXabQRXRA8=;
        b=JmzQ1yxwTTmHaxJdltpsKiJCh/1Rr/TNbpLWcIHX///65jNCDDRhnAmZ1DBVP/Mczh
         SNQxzeVfED5tsmaYNxCa4DxAF0fItgjIPUPB84m+9tsygSHchNgU2M2sAtH3qnOllH4l
         D4879Y4PeUadeYibWcyKENFUKaEWVwDd69qStjE4DdSqneJsc7jWrcGEG5PhnSGxvyz3
         HBFqSOgsMw2GmJjVv7ukhG1Fj6vEWa+DrjPFSyVz/QbRPYkWb2tDjS3r/gEVa35DksQV
         OI0PPcGIdFkwzq0jFwlwUI4y8A+y/sHs0lc8qFy/U6hF7Km3dWskCeh3ByJnzTR+3cUw
         9/5g==
X-Gm-Message-State: AO0yUKWvTrevL0GiXOafv8ymiG086psI5bnCdQTqokTeDXV8xq1GgSBa
        1ITpVjltEzatFms58GaQQNU=
X-Google-Smtp-Source: AK7set+mRMhuJpCUO0ku4xxTn19DfYzI5lVjsJUoBa+NlKp1todK3lAAx3VX25Mvg0A+KKaZ8V7uWg==
X-Received: by 2002:a05:600c:491d:b0:3da:2a78:d7a4 with SMTP id f29-20020a05600c491d00b003da2a78d7a4mr18556218wmp.21.1676286354240;
        Mon, 13 Feb 2023 03:05:54 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c2-20020a05600c0a4200b003de664d4c14sm15033481wmq.36.2023.02.13.03.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 03:05:53 -0800 (PST)
Date:   Mon, 13 Feb 2023 14:05:50 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 04/10] net: microchip: sparx5: Use chain ids
 without offsets when enabling rules
Message-ID: <Y+oZjg8EkKp46V9Z@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
 <20230213092426.1331379-5-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213092426.1331379-5-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 10:24:20AM +0100, Steen Hegelund wrote:
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> index 68e04d47f6fd..9ca0cb855c3c 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> @@ -1568,6 +1568,18 @@ static int vcap_write_counter(struct vcap_rule_internal *ri,
>  	return 0;
>  }
>  
> +/* Return the chain id rounded down to nearest lookup */
> +static int vcap_round_down_chain(int cid)
> +{
> +	return cid - (cid % VCAP_CID_LOOKUP_SIZE);
> +}
> +
> +/* Return the chain id rounded up to nearest lookup */
> +static int vcap_round_up_chain(int cid)
> +{
> +	return vcap_round_down_chain(cid + VCAP_CID_LOOKUP_SIZE);

Just use the round_up/down() macros.


> +}
> +

regards,
dan carpenter

