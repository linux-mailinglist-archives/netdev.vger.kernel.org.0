Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1D86BEB3B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjCQO3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCQO33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:29:29 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E4DD5A70;
        Fri, 17 Mar 2023 07:29:23 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x3so21041256edb.10;
        Fri, 17 Mar 2023 07:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679063362;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WbJNlgfkQTcIcyauJojLunW4hotdL0Nx1hjKKHYLlTI=;
        b=oc59BrlN2yrTwiyQOaLLKV1foWciYfkFG3M+xvSoDZ8xJuEjYy2B5kTBe4hCwqWTXJ
         xihpvuVcFhr2TpoAPjQE/SEQe2r4YG7VGLx1ir9mrXRK0EVy0YIbtOr8+fGkMWf10T7r
         +RCDJUSXaEprvmjbWPbb2lPde+rxpjfqGtQLOSkIhYfldaoG5QQ3EPLruMghgJsWxFgq
         FmldHiuf4dAFbPDGYo6dyCSrg3N/NScB48Id2Wg5xG11aYL+A+p+gxvoEbt+jP109cQx
         odIkL6L8fcxIzbLa1ACYDpeWiZz4avAliotV8rebvCWfXuQ5UW9QrquxchvugWdLZu5r
         9e9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679063362;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WbJNlgfkQTcIcyauJojLunW4hotdL0Nx1hjKKHYLlTI=;
        b=crG4krjrH6VfURFkMy2mt1OOQoATe8vDfFVc0LfYTGNCNZShAkiAQ9dcn6fHHy4uKK
         PLks1/TDr+MHgWzGGT4QGXnrkrSSxYfosiYoQKg48hKUHdxshIvzcoUV4oDBTvtIB3A/
         Oxs467O9Q30opNZmBdz72XiNIsxCn4OZlw7oGr2EBZGp52Ozuwm9jFz+QQXtGJe78/vL
         qvuDjZoogQwbIkLycBJkp9ztyrkLvTLE5XhV9Y1YVT6KJSVBsjBwK3n9CjS80xnyFejS
         L8lKZGhtAf1hvU0VsAtYc7KZRbUGdXNhk6Vx19ZK0cT5tid+CycIoFYml2e5QNATaiVS
         JWWw==
X-Gm-Message-State: AO0yUKUFT6vVxKEQ/TY0WXP5XuMJLqU9MEPK3Zuw3fSmcU+++HbCe4NS
        72x8UKGl0AzAkngbVL9TamAc8GFo+uLcuw==
X-Google-Smtp-Source: AK7set86PnzPDdgOAKEnlLnoHq+mEbpGvfPk6cycza1324IuDdfYr0vINgCd/CG8jj2xL8q/RZ9XHg==
X-Received: by 2002:a17:907:1de4:b0:932:4378:b237 with SMTP id og36-20020a1709071de400b009324378b237mr1500641ejc.77.1679063361626;
        Fri, 17 Mar 2023 07:29:21 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id i3-20020a508703000000b004fbd365fb33sm1165721edb.38.2023.03.17.07.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 07:29:21 -0700 (PDT)
Date:   Fri, 17 Mar 2023 16:29:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
Message-ID: <20230317142919.hhjd64juws35j47o@skbuf>
References: <20230317113427.302162-1-noltari@gmail.com>
 <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf>
 <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
 <20230317130434.7cbzk5gxx5guarcz@skbuf>
 <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:17:12PM +0100, Álvaro Fernández Rojas wrote:
> > The proposed solution is too radical for a problem that was not properly
> > characterized yet, so this patch set has my temporary NACK.
> 
> Forgive me, but why do you consider this solution too radical?

Because it involves changing device tree bindings (stable ABI) in an
incompatible way.

> >
> > > But maybe Florian or Jonas can give some more details about the issue...
> >
> > I think you also have the tools necessary to investigate this further.
> > We need to know what resource belonging to the switch is it that the
> > MDIO mux needs. Where is the earliest place you can add the call to
> > b53_mmap_mdiomux_init() such that your board works reliably? Note that
> > b53_switch_register() indirectly calls b53_setup(). By placing this
> > function where you have, the entirety of b53_setup() has finished
> > execution, and we don't know exactly what is it from there that is
> > needed.
> 
> In the following link you will find different bootlogs related to
> different scenarios all of them with the same result: any attempt of
> calling b53_mmap_mdiomux_init() earlier than b53_switch_register()
> will either result in a kernel panic or a device hang:
> https://gist.github.com/Noltari/b0bd6d5211160ac7bf349d998d21e7f7
> 
> 1. before b53_switch_register():
> 
> 2. before dsa_register_switch():
> 
> 3. before b53_switch_init():

Did you read what I said?

| Note that b53_switch_register() indirectly calls b53_setup(). By placing
| this function where you have, the entirety of b53_setup() has finished
| execution, and we don't know exactly what is it from there that is
| needed.

Can you place the b53_mmap_mdiomux_init() in various places within
b53_setup() to restrict the search further?
