Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B251652B9B0
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiERMCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbiERMC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:02:29 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A787F5045E;
        Wed, 18 May 2022 05:02:15 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id tk15so3351379ejc.6;
        Wed, 18 May 2022 05:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RkTXbcWfCMbklIjpgn9hftfzFZvNqpDyv/EFjTk6CXI=;
        b=LfnSTfhkryn5/54vWws0Z2jfidwqVhMZvrWyWfScWjAsxO6QrvxOv85Mpw8X9EgUZV
         9O8wG81NavXdJDFPFAbcOICJKTXcTxsM6BD/j6TOTaM5d4s2D5B4ltrssnZXd+rjUpHW
         4uJX3L2E64yjRdOvycdyhOeBBKjmtPhT7yEi9GCkQ7rfTGXrnKMV3Nxe2Qs07laflAOk
         wpmofpbYl8UK4lm+4akJ4ZM0REKAfDqWJq3gfWkQYBXlFV6z/viR2BUHJEoGqeEI4FIz
         zTcRxaZBv7baLTNyKNVe9dkliwSkublfieQ9qV4MzefjMvmdbQOjtnMWhob2yCUOTnkE
         31eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RkTXbcWfCMbklIjpgn9hftfzFZvNqpDyv/EFjTk6CXI=;
        b=vg5I1lxepmYbbv9iwUjirQBcyHVMuEvR46vbaJ42i9bsuYcPYccePsyoNh9bQTUiO+
         Va9/Ti39uXSqvW490vAL4grnkeqmdOCztQghyjfMUJ9UVACiM7fR6jA7Vm3AUP3ey+JY
         WuXwrogUijiCt3rjqPC9mxntdWJU8E6WI5/ca3w91cHqrJLrowSeMoMJZNUzBHBipNcB
         LIsdjrSvPVI+z8mM6c7Q373UMRTfVUMLo56Dpj1ibHlfbeO+3OgwfGjrKPM9JpHy9MJz
         owWFsOQBB7OrM+OiljlH6KRzyOYpONdKiERkBKBqtvstEqNX9EvI98o8TjABL+UvsJn9
         CT8w==
X-Gm-Message-State: AOAM532lbDkIAXsBUB9kU3ePtLj9+47sCl+aizSGumM3kWFY4CwicZZB
        DI0Zy9ZF+tYe7gXa63gJ9NQ=
X-Google-Smtp-Source: ABdhPJwyINr0d+HzLJIOETA6Tjmt/7IOFJBaRXWlnAgBDJSpRvpoVBBJcyElS9FVj6HAQ0mYyalpiQ==
X-Received: by 2002:a17:907:3e97:b0:6f4:a160:3983 with SMTP id hs23-20020a1709073e9700b006f4a1603983mr23545759ejc.283.1652875328594;
        Wed, 18 May 2022 05:02:08 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id de24-20020a1709069bd800b006f3ef214dcesm887276ejc.52.2022.05.18.05.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 05:02:07 -0700 (PDT)
Date:   Wed, 18 May 2022 15:02:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net-next 5/9] net: dsa: microchip: move port memory
 allocation to ksz_common
Message-ID: <20220518120205.xceror7zyopo33qk@skbuf>
References: <20220517094333.27225-1-arun.ramadoss@microchip.com>
 <20220517094333.27225-6-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517094333.27225-6-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 03:13:29PM +0530, Arun Ramadoss wrote:
> ksz8795 and ksz9477 init function initializes the memory to dev->ports,
> mib counters and assigns the ds real number of ports. Since both the
> routines are same, moved the allocation of port memory to
> ksz_switch_register after init.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
