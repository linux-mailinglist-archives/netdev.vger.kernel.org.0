Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD50663B3E3
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 22:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbiK1VFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 16:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbiK1VF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 16:05:27 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB372F646;
        Mon, 28 Nov 2022 13:05:19 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s5so17111288edc.12;
        Mon, 28 Nov 2022 13:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T6jpEgonLuVy9eXPUff4zgyLKC9OGDqSxvg6IPy0vmg=;
        b=BqRENArL2HvQ2tP2uCgRu4PTtkMRQ7/JQmbXMRe0Ph8A9ex2ObTE+xr++pixIf1NVb
         iFAij/0OVTDONlsE+m0CDyoFt3QOinm5UMaiF8dH/HL5TelPi3Uq6FNZqLGjTsCNfvb0
         1nhightmGLorW9uSsg31bzVuCcxtmO/Tq+B8zMvt6zPANfuQy4KlldRXUtXbl3uic0ZV
         ZPfSLGGpSe/un1oZOUg5nV3X+eAggQKBVZh9MwP8LW5uZKYBhYFkWQf1rI3xEu1tMtg/
         4orrIkQ7ahVl+WMp6h86LpRtwTQdXOIcsx06BJiMDt6wt2KVY6F00R5sDl5TPAZVghPL
         p6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T6jpEgonLuVy9eXPUff4zgyLKC9OGDqSxvg6IPy0vmg=;
        b=b4rAGRzrp2FXBl0ha4lKdIwdg6Y+TD0DXf+6UEDBOp5v/T3QjSPNsdZw/UXc1ItkFq
         GWFeh6T89CUl/vzrswxdU9Hbo+0hP8Y0m3xCWlm8POjRUIYXDgjdMx/Yag54N3I2s7Ue
         j3tWdOFAKDE/TITP1f5pIMd0+V0Ap78D4aGz9G4EDY0hF5ZR9sjxbOVumALS9WkjUmt3
         wSt+aCqO3hKUU24k/GF1kTqdC7jGcKV8jOW8B3SJgxXQiAUGUIlX6YOs0n7H9jtolSk5
         u7R58XUw+kHZpADajGQCVOIoNCVfkeoG+38JXiNxcWip8UBhBRzjjZq+BPCatb2qVIAH
         5oOA==
X-Gm-Message-State: ANoB5pnsVy3FBhgMQW9a8QWrSgddGPNL+yoZJc1BGmcgPDoXwtCexVhU
        BERL+bo+EDVguSyAPf3WDqc=
X-Google-Smtp-Source: AA0mqf4Zkp4AQgIdgWmtvucjc8ZnQQEDx4kOJEfIiiU0eIj17rT5D+9if6m/tpzMse0bNWAL45I0Tw==
X-Received: by 2002:a05:6402:1857:b0:46b:19aa:cfaa with SMTP id v23-20020a056402185700b0046b19aacfaamr7968618edy.229.1669669517644;
        Mon, 28 Nov 2022 13:05:17 -0800 (PST)
Received: from skbuf ([188.27.185.168])
        by smtp.gmail.com with ESMTPSA id e16-20020a170906315000b0078d793e7927sm5366600eje.4.2022.11.28.13.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 13:05:17 -0800 (PST)
Date:   Mon, 28 Nov 2022 23:05:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Message-ID: <20221128210515.kqvdshlh3phmdpxx@skbuf>
References: <20221128205521.32116-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128205521.32116-1-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 02:55:21PM -0600, Jerry Ray wrote:
>  static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
>  				      uint64_t *data)
>  {
>  	struct lan9303 *chip = ds->priv;
> -	unsigned int u;
> +	unsigned int i, u;
>  
>  	for (u = 0; u < ARRAY_SIZE(lan9303_mib); u++) {
>  		u32 reg;
>  		int ret;
>  
> -		ret = lan9303_read_switch_port(
> -			chip, port, lan9303_mib[u].offset, &reg);
> -
> +		/* Read Port-based MIB stats. */
> +		ret = lan9303_read_switch_port(chip, port,
> +					       lan9303_mib[u].offset,
> +					       &reg);

Speaking of unrelated changes...

>  		if (ret)
>  			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
>  				 port, lan9303_mib[u].offset);

...If lan9303_read_switch_port() fails, should we copy kernel stack
uninitialized memory (reg) to user space?

>  		data[u] = reg;
>  	}
> +	for (i = 0; i < ARRAY_SIZE(lan9303_switch_mib); i++) {
> +		u32 reg;
> +		int ret;
> +
> +		/* Read Switch stats indexed by port. */
> +		ret = lan9303_read_switch_reg(chip,
> +					      (lan9303_switch_mib[i].offset +
> +					       port), &reg);
> +		if (ret)
> +			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
> +				 port, lan9303_switch_mib[i].offset);

Because the same, existing pattern is also used for new code here.

> +		data[i + u] = reg;
> +	}
>  }
>  
>  static int lan9303_get_sset_count(struct dsa_switch *ds, int port, int sset)
> @@ -1017,7 +1061,7 @@ static int lan9303_get_sset_count(struct dsa_switch *ds, int port, int sset)
>  	if (sset != ETH_SS_STATS)
>  		return 0;
>  
> -	return ARRAY_SIZE(lan9303_mib);
> +	return ARRAY_SIZE(lan9303_mib) + ARRAY_SIZE(lan9303_switch_mib);
>  }
>  
>  static int lan9303_phy_read(struct dsa_switch *ds, int phy, int regnum)
> -- 
> 2.17.1
> 
