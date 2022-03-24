Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47F84E6A18
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 22:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353917AbiCXVGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 17:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353907AbiCXVGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 17:06:44 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7E8427E3;
        Thu, 24 Mar 2022 14:05:11 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id k10so7068727edj.2;
        Thu, 24 Mar 2022 14:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jz8mqrCeINcLuETLQq56jM/2c+bU2W9c5RPQ+bVGK/g=;
        b=KM1I+S0Huz6XlzoIJmCckQ7q4HO9WLvxQ9t3+h+GhZmbA4QI9eKBn+k0D+I6j6B2Gu
         kHvzNk1OigWzVq4FRUFBUWKQeZRonwE8AaniYbwSWixIvLkEPUCQmJ0rRaiQhbqMeXEh
         EPOssxT0E8qFSVEq9uIGLCar7CXxDJ/DRQfXQjnJPy+JRgM4QRk6kKyuCl8c/Wxq7yB9
         TyNUCkYaotcreT4IDepzuSR64vPFywouUIGIwNv7adJu+XevGMBo123iRZ9MUZ03YyHS
         IKpoZDjfIsP+8KnGNF/uDFOWyekcK7x/lo4Xo3U0P8rz0I+47iNPXuB5aY4zXWlx2Z7f
         J3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jz8mqrCeINcLuETLQq56jM/2c+bU2W9c5RPQ+bVGK/g=;
        b=m34AEeU+ZwS5fHlvAjNjMQCl7XNjg519z77uqup0COGkmWU0tcHEW+Tm4Y6E/UhRie
         gNawxschkYWCHkA2facJ/olKSfoxPxjVcyUF2/CfA4ZI1cE/xoVIWP/zVs6FBOqfvWwU
         7WSJmVgeh2ntaZHS65o2Vt0A6+GRzEuBqgGUx2ULUG2D/3CItrbojwIkd4mkzlQAZ6ye
         99qqHm4hQqoNjPP2phETPNDJCGIKSDf7KyhVNcnMEnZYlFyeO7bYz7VRQ+lfKis/lOPG
         0O+AajLVe4SFrVhVXOQrS1t7cYEpvSKZQAbhEmVJJ9Vnz/diyzeJLdG/dmw9jX2j4baV
         P55Q==
X-Gm-Message-State: AOAM533a4Xl+ikKz5JcT6myTuYcWRv6bUkMlJu2m8vCImoVQCb91FuTY
        0piGwIh9VAMox+TaHUMJuulAgE+HHjg=
X-Google-Smtp-Source: ABdhPJxMIJ+57jQlsDPQLkkv4QDTtxzJoXpWPFokvL6BjmJ002dKidGXMXvKtaAxp0qf22ivYas1HQ==
X-Received: by 2002:a05:6402:1385:b0:413:2bc6:4400 with SMTP id b5-20020a056402138500b004132bc64400mr9127888edv.94.1648155910283;
        Thu, 24 Mar 2022 14:05:10 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id m20-20020a056402431400b00419315cc3e2sm1953536edc.61.2022.03.24.14.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 14:05:09 -0700 (PDT)
Date:   Thu, 24 Mar 2022 23:05:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking
 from qca8k_priv
Message-ID: <20220324210508.doj7fsjn3ihronnx@skbuf>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
 <20220322014506.27872-2-ansuelsmth@gmail.com>
 <20220322115812.mwue2iu2xxrmknxg@skbuf>
 <YjnRQNg/Do0SwNq/@Ansuel-xps.localdomain>
 <20220322135535.au5d2n7hcu4mfdxr@skbuf>
 <YjnXOF2TZ7o8Zy2P@Ansuel-xps.localdomain>
 <20220324104524.ou7jyqcbfj3fhpvo@skbuf>
 <YjzYK3oDDclLRmm2@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjzYK3oDDclLRmm2@Ansuel-xps.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 09:44:27PM +0100, Ansuel Smith wrote:
> On Thu, Mar 24, 2022 at 12:45:24PM +0200, Vladimir Oltean wrote:
> > You need the max MTU.
> > 
> > Why calculate it again? Why don't you do what mt7530 does, which has a
> > similar restriction, and just program the hardware when the CPU port MTU
> > is updated?
> >
> 
> I just checked and wow it was that easy...
> Also wonder if I should add some check for jumbo frame... (I should
> check what is the max MTU for the switch and if it can accept jumbo
> frame+fcs+l2)

I'm not following you, sorry. What is your definition of "jumbo frame",
and what check is there to add?

> Wonder if I should propose a change for stmmac and just drop the
> interface and restart it when the change is down.

In the case of stmmac, dev->mtu is considered from stmmac_fix_features()
and from init_dma_rx_desc_rings(), so yes, putting the interface down
before updating the MTU and the device features, and then putting it
back up if it was previously up, should do the trick. Other drivers like
gianfar and many others do this too.
