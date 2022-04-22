Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFA650BDD0
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbiDVREe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiDVREd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:04:33 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50C56A41E;
        Fri, 22 Apr 2022 10:01:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bv19so17559919ejb.6;
        Fri, 22 Apr 2022 10:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dRt/jR85kRicxEUhK1JqoJCyTsq8d1Ddz7419Ukqr3g=;
        b=MwjYZ7qV/qk74QwHLrDpFyYe7qW1bVrrhttKMwYATQVrLQa0vp7MNTURL/BJxQf+H1
         a+ZQ8epUaHzJ7LMDbVecNqQGtdb83QTweuKSDqVY3vfKjEyhvOiMSUTK4EPtW5xdxExQ
         ZsuzWEx5CaPEsTcllmRkeaXG/4YdOOG3OkJ7YkfZ/fjgQxZEzKXSQYNIM6M4yltvbLZj
         1AhKlQzVK0OdqLJbo5TKrklv2PHosgJogPFbHTrgx96W6i10iG0xyRZTe6kO0noEUDvr
         qd9NyMQJARBWVSLFBD9T716TV9UktYneYRZl5XwW2hGVdwxJYxv1nPdQ2blahsbbCgfO
         8hrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dRt/jR85kRicxEUhK1JqoJCyTsq8d1Ddz7419Ukqr3g=;
        b=wkQt8tfSVbYnYpY2RUMLiLyVF/kwB8RlEhnCD8pBoGpLca6r0H/uOew9gq7Fe86kkt
         kifGqxks6FrUZ1Y/R8TglntMxuk2kWxoRKHi/omHlOvP8r9H+MeiiWjF7+p7xOIG9FNn
         sDTpGZbGW8s83jjui2Dgv8j8xirGmBRqSC7oJStfZmoM+hJi8j2jerQ7IGnMHKMaZqCC
         seOCrdJ0wTgpnYx2SbQKcJRZdCeQ2Ei78j+aNhHoCJXYqr6ZndzGrA00mYBLxcLkquiC
         dDbRnS4lStrKYQ12afC23ihAznWqH2w/PYIzXSr2sQkn8l5WQXx5X6ScXvgpqa46R2/W
         hmEg==
X-Gm-Message-State: AOAM531vObH15k0HRnlPTIlwYBoWj5w3uJVMNBXGfQXbUUmw/enMufJ+
        3Ro7bj+nYX1NVCbp+8V0pEs=
X-Google-Smtp-Source: ABdhPJwkloO6wFKF3wsvvFuA3uUm2MnZyAvWSKFcHvW2sdIQ6A9XHVZ2jL0sDhN1Ak6T/k6dbdLaAg==
X-Received: by 2002:a17:906:c2c9:b0:6e8:5ee7:e621 with SMTP id ch9-20020a170906c2c900b006e85ee7e621mr5169389ejb.760.1650646897142;
        Fri, 22 Apr 2022 10:01:37 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id kb9-20020a1709070f8900b006e889aad94esm917423ejc.128.2022.04.22.10.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 10:01:36 -0700 (PDT)
Date:   Fri, 22 Apr 2022 20:01:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [RFC Patch net-next] net: dsa: ksz: added the generic
 port_stp_state_set function
Message-ID: <20220422170135.ctkibqs3lunbeo44@skbuf>
References: <20220420072647.22192-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420072647.22192-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 12:56:47PM +0530, Arun Ramadoss wrote:
> The ksz8795 and ksz9477 uses the same algorithm for the
> port_stp_state_set function except the register address is different. So
> moved the algorithm to the ksz_common.c and used the dev_ops for
> register read and write. This function can also used for the lan937x
> part. Hence making it generic for all the parts.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

If the entire port STP state change procedure is the same, just a
register offset is different, can you not create a common STP state
procedure that takes the register offset as argument, and gets called
with different offset arguments from ksz8795.c and from ksz9477.c?
