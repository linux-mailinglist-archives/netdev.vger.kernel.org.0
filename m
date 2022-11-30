Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBF563E262
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 21:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiK3U5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 15:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiK3U45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 15:56:57 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC56837C2;
        Wed, 30 Nov 2022 12:56:55 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vp12so43007131ejc.8;
        Wed, 30 Nov 2022 12:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9jQlZQ+8HHYhpox7WBTyYuGJEtiPdn1BZqHahmN+0t8=;
        b=c/ZbbDLshtsnxHXWxNMYALtyBOztdhBPPQcbQhB4hCZ2jZCh21g9d68kHDpcFXIo3X
         LQUz+0cyyBdKTKGSKgghnblI9XOPJCKjD0psvLzWaFH6YgwGXPfGqO+ruqaYu2IRx3OD
         5ptvNdGsVY9S55xso7HvPOqL/45ZGwNvf1xL8n8Vh37J1UDwjJR2w8JLHCN3gp091Srb
         W+snMQ6rZ/hOWh32gdCkGlfzgfKxsbOffbiuOzMQ90K5m1FCE8ad22KdaKAq5mL6a15I
         zFuDHD8f0M+yKM8BtcerrO0CkT39dXUFwQfdM7qQQGZF0Zqf2DCChS91b/mu78Z5qaVI
         cBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9jQlZQ+8HHYhpox7WBTyYuGJEtiPdn1BZqHahmN+0t8=;
        b=lMLkBUfc1S9S//36jZNPtJJucnFpfMisrQqIGso75obeMpWuFpVKGAPpEby8I+M0H5
         LiJXWA3LErbXFNtPjXXUZFhRFaFsca83A9k6ArLhQejy2TyU6Ax56A3i3zMtn+Whe4yI
         n4t4Qf86+oAsO6vVT9vZulA2/ypm/JxadEJYDLoUZsFsX7ycFkCY6pHwm1etlvYydxSe
         5DsYdZnUVM87/DPlmyTyxiZR3ycj/zk2DjzYv4qyUhi+SkfzlZJ1kN0NlO9GhcA1eYYz
         l6PBleSKmruRdIk+PyeyLVSpdXcl46aO9CKwFRytyDLKYX+krGDvbg27mdGxvQsSPt6H
         sLDw==
X-Gm-Message-State: ANoB5pkNo3QacHIaVJtnUhC6OCsq8hRpyEx5ZLxIO6S1plOXeyEnzSFt
        qZ5y56xzrUWirkCc43FCpLETUhoMO5D80g==
X-Google-Smtp-Source: AA0mqf6Go41vkhjDiWfTbKYo1OqcNmEkIfml37MQwVo4LMApJUE9faSYXhhmGqRXBl+WHGCrTp6eVA==
X-Received: by 2002:a17:907:9854:b0:7bc:30e0:6bea with SMTP id jj20-20020a170907985400b007bc30e06beamr25039204ejc.49.1669841814037;
        Wed, 30 Nov 2022 12:56:54 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id c5-20020a1709060fc500b007ae10525550sm1036407ejk.47.2022.11.30.12.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 12:56:53 -0800 (PST)
Date:   Wed, 30 Nov 2022 22:56:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Message-ID: <20221130205651.4kgh7dpqp72ywbuq@skbuf>
References: <20221130200804.21778-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130200804.21778-1-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jerry,

On Wed, Nov 30, 2022 at 02:08:04PM -0600, Jerry Ray wrote:
>  static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
>  				      uint64_t *data)
>  {
>  	struct lan9303 *chip = ds->priv;
>  	unsigned int u;
>  
>  	for (u = 0; u < ARRAY_SIZE(lan9303_mib); u++) {
>  		u32 reg;
>  		int ret;
>  
>  		ret = lan9303_read_switch_port(
>  			chip, port, lan9303_mib[u].offset, &reg);
>  
> -		if (ret)
> +		if (ret) {
>  			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
>  				 port, lan9303_mib[u].offset);
> +			reg = 0;
> +		}

This part of the change still is unrelated and affects existing code.
Bug fixes to existing code are submitted as separate patches. In some
kernel trees, they are at the very least tagged with a Fixes: tag and
put before other development work. In netdev, they are sent to a different
git tree (net.git) which eventually lands in a different set of branches
than net-next.git. You need to not mix bug fixes with development code.
Andrew also suggested that you separate each logical change into a
separate patch.

This, plus the fact that Jakub asked you to also provide standardized
counters, not just free-form ones, which you found it ok to disregard.

I hope that only a misunderstanding is involved, because if it isn't,
then Jakub will know you, alright, but as the person who disregards
review feedback and expects that it'll just disappear. I think Jakub
has pretty solid grounds to not expect that you'll come back with what
has been requested.

Sorry, this patch has a NACK from me at least until you come back with
some clarifications, and split the change.

>  		data[u] = reg;
>  	}
