Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8861D2ECD90
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 11:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbhAGKLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 05:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbhAGKLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 05:11:31 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4C9C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 02:10:50 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id x16so8906897ejj.7
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 02:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iLD7ERyttF3Husc/s5Hu3Z0Bfk1HmxCPfjW8mzpqly4=;
        b=qsn8YDyaqzmBc+gO2QsfdT+ZE4+e2JG2fkni47BYfdYJjZ2Y8YVsSiwCrlcHriTkOY
         fIvkG5k2+VFUVIovxARbaDjM32coPV6K6ab1GKPcxB7R2lHUhMCy8eqTHC8C8N6M+O8r
         k12a/SuBzJWCCBstLvCSbmcDrk/yAy4FncIbM4MlP+XGsaW6WIjWE4Xnl/Dwrfs9WP5h
         OLmtlAlpb87ChAtnp4DsZcnNV4qYcsL2RNXy9rx0MWeZz/lAIVAZpU+g6cLULrcjSy1r
         aA2phka7ZefV9B/BAtCFQChaiuv+ww6AhG8jw4E6cra3J0NoV8YVoUswo5igwkA1jW71
         lwOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iLD7ERyttF3Husc/s5Hu3Z0Bfk1HmxCPfjW8mzpqly4=;
        b=YWYf8wuK/4Gp2C5+N3nQ27HJXgvK2XoxuBZSFcM2AMXT1IGUCXOu3xfZe9JrLW+QlJ
         ncxgWvZ1Gr4lGk5hNN5bVEq5Zzlvs1W6UqfnhJzemHklgLOfrtDC5MznmiVXilqtDiXq
         L0MDJGxmJVD3uKJGk6dq3Czx/ZT54xl98gW6oPOttCcFKGalyflbwI/WRxKTNk0O9CcG
         UJahNIye/BkRu5+jrNCeRzR3Y1e1aWrDePMM478p3lMNa7nglzcNe54PGFupQ9PIzqkU
         DLe0zN9GJVYo11es4xoBD99hxTS31KBtAyElJfKAvkxdh0+mqdw/PjtKw6tapo8Me6fk
         BxQQ==
X-Gm-Message-State: AOAM530N571NDb2yt3rgsE8Qu6D4dB9rQJDs6f5feCkcXpycc7lBhIxe
        wWgzCYUMJXwGe0Wrmg1B81I=
X-Google-Smtp-Source: ABdhPJyuU66fJcO7jPuMJS6eYrSR0BcSFmmw/3TyB97p/nBpG4eVC88s1ppozFcyQ0oW+vx5HxQ85A==
X-Received: by 2002:a17:906:4443:: with SMTP id i3mr5480015ejp.133.1610014249351;
        Thu, 07 Jan 2021 02:10:49 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rl7sm2261665ejb.107.2021.01.07.02.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 02:10:48 -0800 (PST)
Date:   Thu, 7 Jan 2021 12:10:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v3 net-next 01/11] net: switchdev: remove vid_begin ->
 vid_end range from VLAN objects
Message-ID: <20210107101047.ugnak7rx5g4urk3z@skbuf>
References: <20210106231728.1363126-1-olteanv@gmail.com>
 <20210106231728.1363126-2-olteanv@gmail.com>
 <87h7ntw70l.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7ntw70l.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 08:17:14AM +0100, Kurt Kanzenbach wrote:
> [snip]
> 
> > --- a/drivers/net/dsa/hirschmann/hellcreek.c
> > +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> > @@ -353,9 +353,8 @@ static int hellcreek_vlan_prepare(struct dsa_switch *ds, int port,
> >  		if (!dsa_is_user_port(ds, i))
> >  			continue;
> >  
> > -		for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
> > -			if (vid == restricted_vid)
> > -				return -EBUSY;
> > +		if (vlan->vid == restricted_vid)
> > +			return -EBUSY;
> 
> `u16 vid' is not used anymore:
> 
> drivers/net/dsa/hirschmann/hellcreek.c: In function ‘hellcreek_vlan_prepare’:
> drivers/net/dsa/hirschmann/hellcreek.c:359:7: warning: unused variable ‘vid’ [-Wunused-variable]
>    u16 vid;
>        ^~~

Thanks, I noticed now. I also noticed I did not update dsa_loop. Sorry.
https://patchwork.hopto.org/static/nipa/410259/12002471/build_32bit/stderr
