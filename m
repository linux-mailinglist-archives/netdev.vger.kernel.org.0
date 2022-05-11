Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92556523734
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343750AbiEKP0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343676AbiEKP0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:26:12 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D85817A8E
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:26:10 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id i19so4740714eja.11
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3LPstGboLtvtSq6oKCrLPM6+MAaG+ogNKHhjFbWNXjU=;
        b=A2OQV8ZiT5MUwjlnTPnTMkBovaKETn3WlUbKI6gOrSUmRUOMjGP/ah+WAhlkGiF7fF
         uCmLTpVvw01XPD2Ml2UC0CH4jcI6/ZwXNgx5Ox33NbwMRB8RxUs0tVRoCfJrAT6YqNlv
         B3FBoTBjIkwdHg3ktzbB2hPmkRPC/b7rtGy8VWRaEdpNj4gOXpewau0o6U9IWQSQXFsy
         pkDgxk3NN07svqNyMlzko+4P08xCB0cD5qUEj05G4TGUFnimomzP3eQHUU6/Xymz+OC1
         jW+sTyt5e1wmrN5OkiOAMz3CX0RblpxM1EAFwW5NW5KIJRM/8HaHPARf5p5lxFxL7o+S
         Szkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3LPstGboLtvtSq6oKCrLPM6+MAaG+ogNKHhjFbWNXjU=;
        b=Z7DPbWWOh6Xca44MG2X7InEc1YZT2I7U9AKX2LqdWCajM3+B0FcDaOuI11tiWLMCyQ
         KSPACfE8hIDUmpdPopn6GHWMuIlHN9QGfGCnsji8LGkskSXvnl+18Tsmw8LrWr0DjqDi
         6oNRuAceG39j0OYIJHbFNTfRqPyxjrAyl7phKswJO+/gJbh7O/n9cPSk1gTkU3DxuZM4
         lUwd7daGmgA4C0JfdImsENPVz0DZUrC9JhEOAXwQrwxymevapv3M0pUIOxaL/PNUfVxo
         2UtjaLgI1YanQgphNwuBUpsjI5TZgtQydtHj1TM03WqCZG5nk2W/X522iwzt0qTCg5r2
         IScQ==
X-Gm-Message-State: AOAM532RHckPqkDsHR8WPEeJld5VXG3MedMEYWKQZJr22pYp4G3o50F+
        IQDJS7Vg3tXNP/nVfl8jlrQ=
X-Google-Smtp-Source: ABdhPJz4UpQO17YicGTcBkCwq0Yo16ghrMmytJCtotMtcY065p80I9gmULcAsrzJI9YVoK2INmT0BQ==
X-Received: by 2002:a17:906:8306:b0:6f3:da72:5ca1 with SMTP id j6-20020a170906830600b006f3da725ca1mr25201829ejx.606.1652282768959;
        Wed, 11 May 2022 08:26:08 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id bg25-20020a170906a05900b006f3ef214e5asm1086169ejb.192.2022.05.11.08.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 08:26:08 -0700 (PDT)
Date:   Wed, 11 May 2022 18:26:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 0/5] Simplifications for Broadcom and Realtek
 DSA taggers
Message-ID: <20220511152606.msapr4plfor4a26i@skbuf>
References: <20220511151431.780120-1-vladimir.oltean@nxp.com>
 <a979d044-428e-f793-1437-01336530c910@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a979d044-428e-f793-1437-01336530c910@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 08:23:08AM -0700, Florian Fainelli wrote:
> On 5/11/2022 8:14 AM, Vladimir Oltean wrote:
> > This series contains the removal of some "if" conditions from the TX hot
> > path in tag_brcm and tag_rtl4_a. This is made possible by the fact that
> > the DSA core has previously checked that memory allocations are not
> > necessary, so there is nothing that can fail.
> 
> I would like to test those before they get merged, please give me a day to
> test those, thank you!
> -- 
> Florian

Sure.

RFC RFC RFC RFC RFC RFC RFC RFC RFC RFC RFC RFC RFC RFC RFC RFC RFC RFC
