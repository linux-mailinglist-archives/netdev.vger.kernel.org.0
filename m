Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDACE58ABBF
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 15:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239543AbiHENmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 09:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiHENmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 09:42:43 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02C7DF44;
        Fri,  5 Aug 2022 06:42:42 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x21so3464617edd.3;
        Fri, 05 Aug 2022 06:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zR8kV+Ky5vMH8Hg8w39JvJp5Ei2dq8QJt1JHJ8EJ8nQ=;
        b=jKoXyh6nzm1JwAImGdyzJn1CbSx2EzKCsuCF7s+dz16FQbpN6zXz+aT4vQgqtZc/Gj
         +bmg+DRVCm9CSAcghRU7DM0KQ1QKctX1bsYuwWWH9UAeJmXUCepQQOtgrNEEV5pzKhUq
         vHXFmJthphoODQicEHrmjuhlohpev3cZ+lfOhrBRZCRSaGbfkzikuxNdp4oI9kMmoRJk
         l1SNquPDUflXKfnr06KcD7SnyeVu4yVSyP3jCY+rHCILv/ObtcA4h1wul+118HPmyJQU
         h0U7HutY8Ln0tn8Gwh4N5gH8XFdFeUATfG75KxRA59HIEVgTWZDvfzYjchy4hGwrb1Tc
         /lvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zR8kV+Ky5vMH8Hg8w39JvJp5Ei2dq8QJt1JHJ8EJ8nQ=;
        b=Bau6Nwl0GZpWfyjDiR5SPxaIQS4t5yTpuX6p2RGMrdKIWaUlDzKT+cVT/Jeo/jgE9f
         TDK1YQX1kEBFyBX3jVBee+tVLyzaeOUBGk2FbaKDUD7eeouqR9l51Amp7YPF1gzdL/Qi
         1WE6Ez1O0eyl707E8UDAemBsDU3VLVWw+ycVwDdniRqjMRLdCYrMZFqX/3Q18N99Tx3T
         wSy9Payg32SS2ndIs8W9l8VAZ3jTzR2w15gJiFqLV0mkR63uJtPXHdjGUOzo0aWjNe7g
         4EWQJjOKc4odxv1xeP4rSCDWGth68wGF/8ma+PKpz9s1uQrIDaIpeZSHTYR6XYpyGtnU
         zR2Q==
X-Gm-Message-State: ACgBeo3px+azOzAZRW+5AKYbHBHOGSKSiFGpx+696/gY642Nz89bVKW+
        3OD0BwdU4S63NZ75/BgLKyQ=
X-Google-Smtp-Source: AA6agR4mtKE+SpCBscnn3VO5LGsA6rFAtKm12WarCYsCusp7zyqRujQs/lyJRJerTifwX4MLRVCyRA==
X-Received: by 2002:a05:6402:42d5:b0:43b:5cbc:eeba with SMTP id i21-20020a05640242d500b0043b5cbceebamr6592407edc.3.1659706961219;
        Fri, 05 Aug 2022 06:42:41 -0700 (PDT)
Received: from skbuf ([188.26.185.84])
        by smtp.gmail.com with ESMTPSA id f17-20020a056402005100b0043ceb444515sm2131357edu.5.2022.08.05.06.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 06:42:38 -0700 (PDT)
Date:   Fri, 5 Aug 2022 16:42:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 07/10] net: dsa: microchip: warn about not
 supported synclko properties on KSZ9893 chips
Message-ID: <20220805134234.ps4qfjiachzm7jv4@skbuf>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-8-o.rempel@pengutronix.de>
 <20220802113633.73rxlb2kmihivwpx@skbuf>
 <20220805115601.GB10667@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805115601.GB10667@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 01:56:01PM +0200, Oleksij Rempel wrote:
> Hm, if we will have any random not support OF property in the switch
> node. We won't be able to warn about it anyway. So, if it is present
> but not supported, we will just ignore it.
> 
> I'll drop this patch.

To continue, I think the right way to go about this is to edit the
dt-schema to say that these properties are only applicable to certain
compatible strings, rather than for all. Then due to the
"unevaluatedProperties: false", you'd get the warnings you want, at
validation time.
