Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50746E7F58
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 18:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbjDSQOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 12:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbjDSQOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 12:14:44 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12FB3593;
        Wed, 19 Apr 2023 09:14:42 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u3so31176952ejj.12;
        Wed, 19 Apr 2023 09:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681920881; x=1684512881;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M5cwJ0UmCYArDsKBv05I7BkZrL0WgHeOIlgOTNM8h1M=;
        b=PIOuCXQikALwZjhYwOzEXVtrq8sHXxLDIrvxY4661QPnS83FREhv0Usz9dziDf3kk3
         9YamjbKA+Z0Njtd7jv7XDpdjo9VOktQWi0+3mVYw+qDXUnwWpd8lu5cszVSBpG5Vuj1R
         xXoQLMULOCf04qMdmkCLRoKr3sPNSvODC4vWx55VBRT/xCXuST9N9iCJA1RJdqUvFnXz
         rGAel1L6OfC+g7kA3FAekIMl0DxXAqDsQjtlM3VzHS/z2XKOLmC/rISKuMOwuvDzssit
         Ut3yyWDgJETeeZG4lYPQlnKL2daY4EbCGTft6MYWXuKoQTC4ZTyPhSf+Tpau7XSgW3Pu
         CuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681920881; x=1684512881;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M5cwJ0UmCYArDsKBv05I7BkZrL0WgHeOIlgOTNM8h1M=;
        b=PzZSbg45A6jpoOCgbkmvHs1v4AL8GA/b49b0gSiSjWvMyUtsg0RXdVSPTr7BEDOFlv
         ZsR90MnUESsTtZggkdfy7AT5OPnOtASYb8rxP75HYxfFbaKPCyCSqafoee52DfzTTrOl
         xNB+RMg2fYpAeg/owoSsbqnyTkBgmNLyGWbIjck5P3hJZM4/ppJlf+sVDczece1YyqgO
         r5CgDXM6ST7hzDoIVWSmZH5eTlfwaGjbZ0kKsHGTHKdbXPbQKs+UWyo1z0sqVhmU1Ogu
         AbiOkn6Dvb1L97AbXvM0N/DPAWKJ+83ki9dCCMlnLhfNVZaaZe2xNRKzghnd1ylHLIai
         /Svg==
X-Gm-Message-State: AAQBX9cCBEsExNu8w62cwDeumv2yQrYB4wnVDiWJEcvj+0qhk+9YKRoD
        5/4wE+3epX0GfTnvwic/WSc=
X-Google-Smtp-Source: AKy350Yqw2aIathrGyjGnmUW1U4n2MeS1w8MmXVb/utKcOpm+RBnyEpkE3yuEZplw2i8N5+CHoIlcw==
X-Received: by 2002:a17:906:e2cd:b0:94a:6de2:ba9 with SMTP id gr13-20020a170906e2cd00b0094a6de20ba9mr14004683ejb.68.1681920880956;
        Wed, 19 Apr 2023 09:14:40 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id b17-20020a1709063f9100b00953331b086csm1795401ejj.91.2023.04.19.09.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:14:40 -0700 (PDT)
Date:   Wed, 19 Apr 2023 19:14:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: microchip: ksz8795: Correctly handle huge
 frame configuration
Message-ID: <20230419161438.lasmfqboy77evbn3@skbuf>
References: <43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 08:19:33PM +0200, Christophe JAILLET wrote:
> Because of the logic in place, SW_HUGE_PACKET can never be set.
> (If the first condition is true, then the 2nd one is also true, but is not
> executed)
> 
> Change the logic and update each bit individually.
> 
> Fixes: 29d1e85f45e0 ("net: dsa: microchip: ksz8: add MTU configuration support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Untested.
> ---
>  drivers/net/dsa/microchip/ksz8795.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 23614a937cc3..f56fca1b1a22 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -96,7 +96,7 @@ static int ksz8795_change_mtu(struct ksz_device *dev, int frame_size)
>  
>  	if (frame_size > KSZ8_LEGAL_PACKET_SIZE)
>  		ctrl2 |= SW_LEGAL_PACKET_DISABLE;
> -	else if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
> +	if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
>  		ctrl1 |= SW_HUGE_PACKET;
>  
>  	ret = ksz_rmw8(dev, REG_SW_CTRL_1, SW_HUGE_PACKET, ctrl1);
> -- 
> 2.34.1
> 

After checking with the datasheet, the change looks indeed correct.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
