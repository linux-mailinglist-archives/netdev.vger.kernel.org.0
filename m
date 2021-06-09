Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C803A1619
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhFINvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:51:40 -0400
Received: from mail-ej1-f53.google.com ([209.85.218.53]:44973 "EHLO
        mail-ej1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbhFINvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:51:35 -0400
Received: by mail-ej1-f53.google.com with SMTP id c10so38598579eja.11;
        Wed, 09 Jun 2021 06:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oX2BbZy3phYMqo60pEOB/Bur67OS3OOGNSyTUQXA+oc=;
        b=ljbF8cqutd9zcNe/8N9uNdzCv1sGxkJl7gZuKTyTnjuVEcgYIMtu3nY1Bn1SapkRfk
         bb9/ZKVn4nJQtTSq8boBuql5SQWL3l4C/B3uLWryV5nbui9yOSO9nygBZn+IUZ37wtOL
         S5XAb7dlavaypyVyPJ7spBiKm26yvxUOAlZPfSr3Ld6oyeMf1tmjudoIk6NZrQG7TGp7
         dkiTIeLiG4PLxJ+833JanpdsWyc7wW2RNuhu6Hti86cKMdQjCOWboXIpKM3hkiACXFUG
         dtFgKbakjCZhoWhFYBlLJsRLJo6yu5Gsd45wET3IuoucpRd8+FMXLuhk0fSBKEz8nYw3
         iTGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oX2BbZy3phYMqo60pEOB/Bur67OS3OOGNSyTUQXA+oc=;
        b=I6TflRyEZIAuXUGkVFkN2zhqzt5SXrmwzmsxriaeboHMw2D9HRvYPn20JNwz/RVgiQ
         sqr5WbCqklw/w1pxqPBQbfsFlYKV3uQenELv7scMpW0azjLwNsF8yFYTDm4K5SuEsTGs
         B5QgsyPP1tO2yQywYxmR+1JQN3GC5zissgcF637hBJWKsRJol0EJXq+II/Qyu3Mvbh58
         mCaQPSssvgKedOt/eMaldlmge/V78oysPT/Q/Ooo7uy+LPoLjD8X1E6suMzjQ2JMEDYr
         Y4xnXKPJJc/p1zUtLKTky8FXhW5GIk16wiT1z8P7PscopQajsUWmXZ92m/qddCYBNaZh
         Zjtw==
X-Gm-Message-State: AOAM5314mR+gsKJSGxtPuywMozeP1R2SCUjxzPVT6MotdVfrLeHO1PC3
        2kjxOZp6/9cM6Tfngi1zYq59jl9ZihI=
X-Google-Smtp-Source: ABdhPJyMwwbOcfo89A/O2Eb9/HAKAKRttQNL/3ifDPyTpfWPclouYGW6FyblNrkJHlClS7tbU+DBjg==
X-Received: by 2002:a17:907:948c:: with SMTP id dm12mr29007706ejc.484.1623246511379;
        Wed, 09 Jun 2021 06:48:31 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id lb23sm1157772ejb.73.2021.06.09.06.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 06:48:30 -0700 (PDT)
Date:   Wed, 9 Jun 2021 16:48:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2 net-next] net: dsa: qca8k: check the correct variable
 in qca8k_set_mac_eee()
Message-ID: <20210609134829.jill2lt7s2asq4cw@skbuf>
References: <YMCPTLkZumD3Vv/X@mwanda>
 <YMCPf8lVosAYayXo@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMCPf8lVosAYayXo@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 12:53:03PM +0300, Dan Carpenter wrote:
> This code check "reg" but "ret" was intended so the error handling will
> never trigger.
> 
> Fixes: 7c9896e37807 ("net: dsa: qca8k: check return value of read functions correctly")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
