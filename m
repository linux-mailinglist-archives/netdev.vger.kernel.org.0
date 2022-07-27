Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B5C5828B6
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiG0Obz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbiG0Oby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:31:54 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83C524BC8;
        Wed, 27 Jul 2022 07:31:52 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id b11so31739389eju.10;
        Wed, 27 Jul 2022 07:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ap2eOkNnEPkf5/x99641AFOqaHS8ihdhKYCdB+pyA0c=;
        b=VJ8XpEXQu3r41ZiOBg9RbWnUXGkhz90J7R9Bc74mS+5ok1CeXC8r7qa9/dBjSs6gPm
         LQllETS4TIPRt9xeaAgNTTCPSk/Q1T94ciu9UfSoBUVkNlwOD0fUBHo5IO7Kn0oBmZcJ
         w1h5jS2bsOY/IVijKYAVbj+UD4lcj9yMC6+kU66picS0VpSuaF3l3fh6lEe0t7g9kTYz
         kl/u+53lSW2Dma6OWsMg85lFs6KQix9OAs/tmyuK4qNdMSGKYk3gxpM3Oxsj/7PA5hnb
         82J11tPUHHlkJNZRe1B3+BcQ0yTiaGSurhOrPHsvrDJvI+1oGUYFReO8z1Hka7jnzOCe
         1NOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ap2eOkNnEPkf5/x99641AFOqaHS8ihdhKYCdB+pyA0c=;
        b=JXMZMICZ8t8cG1WF/FiN0IJ44FjLyPBx6FN4jkpaveCBYdGJtqV9fe6GDoCQy/GfWI
         H/rfHTbDW+AljMIPsWoKCZ9bU+6JVTxbI0abqXg72UnZrn9I+KeztUeufEv0/9tRnd6x
         STIWknNL9s5PWRUjzKQnuZIJ8DpkDS71iEB0zW16EZZBXD+lLbptfVFn4WgKB834ZF/4
         Lw3ZrjRAaJle6psIVa+E2DRv2OBNzA8JiPwZQw1fQLcGGNQQ9iVc4R1NPF2dM1jty7jt
         g24rKtaJAFXqskpNfqaCNUWeAwtZ1BFPIOJduggL6XKtzOuKLqGlAqUdS/UXgWd7KOFs
         5yMg==
X-Gm-Message-State: AJIora9MnP8o3WMeidTgLp6EYXqtQzZWkUIXrqqgZndLlztyzZ/U0hat
        wWLXmKZxIAfippzskZeWTfY=
X-Google-Smtp-Source: AGRyM1vAqpsxV5ozYrFXI7H1S3ukpzm6F54jEsTbvfKpUxjlDXmMtVouLVcjMSlQI9v9ZEoC+/ZC2A==
X-Received: by 2002:a17:907:94ca:b0:72b:8f3e:3be0 with SMTP id dn10-20020a17090794ca00b0072b8f3e3be0mr17944032ejc.462.1658932311180;
        Wed, 27 Jul 2022 07:31:51 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id eg47-20020a05640228af00b0043bbcd94ee4sm10311614edb.51.2022.07.27.07.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:31:50 -0700 (PDT)
Date:   Wed, 27 Jul 2022 17:31:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to
 fwnode_find_net_device_by_node()
Message-ID: <20220727143147.u6yd6wqslilspyhw@skbuf>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-7-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727064321.2953971-7-mw@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:43:19AM +0200, Marcin Wojtas wrote:
> A helper function which allows getting the struct net_device pointer
> associated with a given device tree node can be more generic and
> also support alternative hardware description. Switch to fwnode_
> and update the only existing caller in DSA subsystem.
> For that purpose use newly added fwnode_dev_node_match helper routine.
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
> -struct net_device *of_find_net_device_by_node(struct device_node *np)
> +struct net_device *fwnode_find_net_device_by_node(struct fwnode_handle *fwnode)
>  {
>  	struct device *dev;
>  
> -	dev = class_find_device(&net_class, NULL, np, of_dev_node_match);
> +	dev = class_find_device(&net_class, NULL, fwnode, fwnode_find_parent_dev_match);

This needs to maintain compatibility with DSA masters that have
dev->of_node but don't have dev->fwnode populated.

>  	if (!dev)
>  		return NULL;
>  
>  	return to_net_dev(dev);
>  }
> -EXPORT_SYMBOL(of_find_net_device_by_node);
> -#endif
> +EXPORT_SYMBOL(fwnode_find_net_device_by_node);
