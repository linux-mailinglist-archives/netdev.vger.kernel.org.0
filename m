Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C2C4566CB
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 01:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhKSADD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 19:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhKSADD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 19:03:03 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E1BC061574;
        Thu, 18 Nov 2021 16:00:02 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y13so34470341edd.13;
        Thu, 18 Nov 2021 16:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M1g96wvk2fScmlQSqAqL2X6S00BnYHNLyt+afv0QIyo=;
        b=f4hMsNyqdGbMXPCmS7JBsFq5cINp+XBRNmd+Ngv+5KFE8Cts4wsg8Cph4EUvQHOxjm
         WpLQx/zxTxK58pk7EDJtnn6cY0jBbMeS8wCyKd9AwOfaijBLuO211kp1Zg0izgyO7IfG
         tMs7cUFxYE6Awm8qjPO6VoJ0EOFZGymjcDVlTttVw+hbKDwPwdYjFRaqhpKVaWVNT0Rs
         NktUwqVisrFf6fCgDgklOfwWga2KLZQ2OLwmf1YBTxveujJTGrIv4rJZx24KG8v8XUUz
         yIUFuK1nRr/t972kNf8R9AFKw1NmdITTR2Vn4T57sOQlKzxXDE67bzAAQm0aFp0xEH3V
         4vAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M1g96wvk2fScmlQSqAqL2X6S00BnYHNLyt+afv0QIyo=;
        b=1w+M8I0DFCw0uWxiJ5vGbgsmgKcc2ZNltkENTcP3vA4Vx0Ke01S62sJcXboEOqWl3t
         sE3cMkpDa1eH6fGQDfV0F6QXt0PgF4r1Ppdiw7UFjq2QqaXwRQHn5XDNcYsSIYw8hrn0
         JZo1s2yYUhZfaP0K/GhI8FbaSaQ9xQcMOgmLsoswa/KRuIiOVnc4LKZwKupdxY0YBhcF
         gw2IzuLvA/dyHpUDv+bBa914ufMDvHpQOVlEOA5RmvN8xg6lPHP5fO3Ge1P+0zmFQlJo
         GHrtn5ZZ/CI2oKdSJVJ3gPx1P/YYqeuvNxQviGXu/22A6FiWGD1TaeZXHufB11p3tQCw
         j4eQ==
X-Gm-Message-State: AOAM531n/VKnAwqkUeD/gLomRR6arsQ8pN9PAOAgeRrA9D1X3NftYLYm
        FJjaSYxZZlfuZAj5ON5UEFuIT8Zpb7w=
X-Google-Smtp-Source: ABdhPJwXQm9GW8Bslhks3s+dd8TXkWn3/JGGMaJAGtolwirXi/bEsG0qoA3BRG3j5KCeRdfIrD2AbA==
X-Received: by 2002:a05:6402:2551:: with SMTP id l17mr14848060edb.142.1637280000795;
        Thu, 18 Nov 2021 16:00:00 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id s12sm643476edc.48.2021.11.18.15.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 16:00:00 -0800 (PST)
Date:   Fri, 19 Nov 2021 01:59:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [net-next PATCH 02/19] net: dsa: qca8k: remove redundant check
 in parse_port_config
Message-ID: <20211118235958.ojpquokxwrh3zvji@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-3-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:34PM +0100, Ansuel Smith wrote:
> The very next check for port 0 and 6 already make sure we don't go out
                                               ~~~~
                                               makes
> of bounds with the ports_config delay table.
> Remove the redundant check.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/qca8k.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a429c9750add..bfffc1fb7016 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -983,7 +983,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
>  	u32 delay;
>  
>  	/* We have 2 CPU port. Check them */
> -	for (port = 0; port < QCA8K_NUM_PORTS && cpu_port_index < QCA8K_NUM_CPU_PORTS; port++) {
> +	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
>  		/* Skip every other port */
>  		if (port != 0 && port != 6)
>  			continue;
> -- 
> 2.32.0
> 
