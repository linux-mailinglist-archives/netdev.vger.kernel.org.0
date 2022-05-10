Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD105521283
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbiEJKtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiEJKtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:49:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A3B2FD
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652179541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=plD3D6fn7skqGXxFWcDHbuLMx2cvK0NKTp6AWvmKD9s=;
        b=Em6jnlEFPxRm3B13MfBm4yN6NHy0pytirY4sBv/y/KeX7fjk4J7D4xYN5ZN0RLofeFeSeM
        k4z1aOAVfCXhO5z/hFhUFLkqpSpjrh72FWUkCsPWjoahFdeepyXg5akeLAwg/kN75BMgOs
        RS6DDbjJba/Kh/Wcab40idpnO3A+5hs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-8ZaZSkF2OSuWyqXITcKP9w-1; Tue, 10 May 2022 06:45:39 -0400
X-MC-Unique: 8ZaZSkF2OSuWyqXITcKP9w-1
Received: by mail-qv1-f72.google.com with SMTP id j2-20020a0cfd42000000b0045ad9cba5deso10562147qvs.5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:45:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=plD3D6fn7skqGXxFWcDHbuLMx2cvK0NKTp6AWvmKD9s=;
        b=rUN97DN/RGD2lMhnxE4YfFvAv9SrB0T0IWdp6vEhT3+CC3OTYNdra113PQVdmlv6FQ
         ACjHgdxjOyB/2LXH8Z36zMOgjnYJ7W7Fw0++hfLOz84+ihHnSKpWUqi6TnorJPMW/wxl
         5PqXBDvH3pfozK8WysjUhlcF9YirIgF+AS+3vIfe0J762ep1A1av+4V0Y1zuCVuJE7z2
         4ar/ctjafWZmQ5g4kuJ5+W0RiF4LyBbDvhsvp8QJL4XyMsb8G88rbiPGyvVRBBRuvk/O
         QjEb2bc5L+QTLbLhKadxhAnIZ+vzqED7tyjhrm74wFdo+Bg6lCTBVwogzOBcTW3Hr1VA
         Glpw==
X-Gm-Message-State: AOAM533cF1GJykDmlyTsjeK+vaLvSCk+KyQGz1poz5/TmJELV4jBF7ih
        vlYyDbUBMJdeI4Sf1ZrP18A0auM7v/lFAumKlJhSdKgWA4l9b5UaqvkgJEaeJf6z5ryfCS29Q2j
        irpyJ6DBahQOmRZHU
X-Received: by 2002:a05:622a:309:b0:2f3:b965:f1d with SMTP id q9-20020a05622a030900b002f3b9650f1dmr18919835qtw.314.1652179539379;
        Tue, 10 May 2022 03:45:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyR5Uhu2AwCz7Oy4Dqs8rtOuP91wrsXY4XMyhccwjX2if879YO7+1zxumI2XDQTs3NI7QU8aQ==
X-Received: by 2002:a05:622a:309:b0:2f3:b965:f1d with SMTP id q9-20020a05622a030900b002f3b9650f1dmr18919824qtw.314.1652179539158;
        Tue, 10 May 2022 03:45:39 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-89.dyn.eolo.it. [146.241.113.89])
        by smtp.gmail.com with ESMTPSA id n19-20020a05620a153300b0069fd57d435fsm8076753qkk.101.2022.05.10.03.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 03:45:38 -0700 (PDT)
Message-ID: <b8e254c50ca23571a640bbc230730ab4219b9308.camel@redhat.com>
Subject: Re: [PATCH v2] net: dsa: realtek: rtl8366rb: Serialize indirect PHY
 register access
From:   Paolo Abeni <pabeni@redhat.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Alvin =?UTF-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        kernel test robot <lkp@intel.com>
Date:   Tue, 10 May 2022 12:45:35 +0200
In-Reply-To: <20220508230303.2522980-1-linus.walleij@linaro.org>
References: <20220508230303.2522980-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-05-09 at 01:03 +0200, Linus Walleij wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Lock the regmap during the whole PHY register access routines in
> rtl8366rb.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reported-by: kernel test robot <lkp@intel.com>
> Tested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Make sure to always return a properly assigned error
>   code on the error path in rtl8366rb_phy_read()
>   found by the kernel test robot.
> 
> I have tested that this does not create any regressions,
> it makes more sense to have this applied than not. First
> it is related to the same family as the other ASICs, also
> it makes perfect logical sense to enforce serialization
> of these reads/writes.

I'm unable to understand if this is targeting the 'net' or the 'net-
next' tree, could you please clarify?

If targeting 'net', adding an additional, suitable 'Fixes' tag would be
nice.

Thanks!

Paolo

