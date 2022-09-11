Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A125B4F35
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 15:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiIKNx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 09:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiIKNx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 09:53:28 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021281B798
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 06:53:27 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z97so9203517ede.8
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 06:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=TLvABQ4zCRYIo1vS2NhYmm9pXhvmHGN5YkReyJSPonM=;
        b=fdWfspi4OZJotRAhfpVYE4SZZz/nLZB9iooxh79Ijrjnv7dxgKAw67/ch0/xkeOVvB
         PLtjSdmoY6cxZ0gAnnBZgbMn9nO/VkUSKYATSc6G3Cd2iPYHenQlk5/6zLDIcbKP4EBN
         qSJJbxPbn23a2TVYII5eRfi1N68xrA6n4oL+yD+i1CsA2eqxgelo4wbaiKX+r48Ke9UD
         A7D5FY/sYz4v52ERqijvt2coCw3hT37sOJmxmzKLuYGXMzRqebfPuv12tFoR3kq+y/YB
         WPuH9aad78fCP6BRKpFLYTaOV0E2CAsAWC2ft4YwZWyyjp57qv1r7ObbNBj/12ICJjQu
         8ZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=TLvABQ4zCRYIo1vS2NhYmm9pXhvmHGN5YkReyJSPonM=;
        b=Z916M50O/YdPahe8meMwQJPCFkkerIoexjuWqn4smdGchM6I8pcWe43zXGmco9OWzp
         3zF0Mq20tcKQjB4Ivp75ou5iGDogscYkdO+sPe7mQ4ZAdFisfbhwkqyAdQq7zbkbTu5E
         Il2gwPXfTguwwV0y5wv9YJMubQnc8psjoW/KCBiSC8yHQmLm4yswUvLsKaoZiSfn8j9s
         YYRR18hXeO7sQTrlqF4w2YaGqZ0CC0XqhCjoChsaLaBB+ddCJo0wInhoyhS36zG5pRHd
         GtVCpBfb7V+0FddzZMG4N7sNIsTLptM5d7AdPrrG+Xg0mLIcJt87oSBjbZssnC4FNzII
         C+vg==
X-Gm-Message-State: ACgBeo234VJaDjWD3rt/vgxsTBBzFrvt5/zZQMMaz8QrMBF4SUTqdL47
        zt0h3abG5o42VBXbPcFGOdQ=
X-Google-Smtp-Source: AA6agR62Vh3VpTFBvnPdDZVlITAb8HJplZVZu2Zq7rv+CR7KS0/mO/qyH7o3MeaZcnG/TCIV6cuGeg==
X-Received: by 2002:a05:6402:24a4:b0:440:8c0c:8d2b with SMTP id q36-20020a05640224a400b004408c0c8d2bmr18390744eda.311.1662904405470;
        Sun, 11 Sep 2022 06:53:25 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id g22-20020a170906539600b0076fa6d9d891sm3003258ejo.46.2022.09.11.06.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 06:53:23 -0700 (PDT)
Date:   Sun, 11 Sep 2022 16:53:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v7 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Message-ID: <20220911135320.h5nl75ajcwjiulf6@skbuf>
References: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
 <20220908132109.3213080-5-mattias.forsblad@gmail.com>
 <YxqYjoZeGhYIZ29b@lunn.ch>
 <0121f604-e8b9-2551-7881-c1fd64c434e2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0121f604-e8b9-2551-7881-c1fd64c434e2@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 08:37:17AM +0200, Mattias Forsblad wrote:
> >> +	chip->rmu.rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;
> >> +
> >> +	if (chip->info->ops->rmu_disable)
> >> +		return chip->info->ops->rmu_disable(chip);
> > 
> > Why is a setup function calling disable?
> 
> So Vladimir Oltean commented before:
> "I think it's very important for the RMU to still start as disabled.
> You enable it dynamically when the master goes up."

This, plus the fact that mv88e6xxx_rmu_setup() already exists in the
tree, and calls chip->info->ops->rmu_disable(). It seems like that
doesn't need to change. Mattias is moving it around, and makes it seem
as if something is being changed. Maybe simple code movement could be
split into a separate change.
