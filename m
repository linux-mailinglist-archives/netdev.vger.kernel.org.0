Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B2D51F42D
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 08:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbiEIFnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 01:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbiEIFjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 01:39:52 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EBE36140
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 22:36:00 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id a191so11130298pge.2
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 22:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7nBBBAMQ5zeS5mQiQ5KVjRlcsKmvLYnDcbFR0E1QZHs=;
        b=jkffVrbDU2zCBrIFOOyBRPqACQnMVKcHRCdY17qI8mbf/vJvti0f3SO2RVnPipsvwI
         AmDx2neA/ar43RU0rg7dzbSmgx0aewVGj2zJBWvMmQ6wm5qJp2RPc6iYD3yblNQ0zKEo
         yO6X9q8lhwqRHKmHRZSlYgN6weIe15QJLrjhzgsfzlVd/Eabgl+lFu1I/IGG10GLG/v9
         v5BveheSqbKc3wKAxgt2Aizq1poJkT4+3e7XWoo61uA/JPgPv24ypTeAYDSGHt0wm0v8
         pCtQOCkn4lnidndjU4QtWmLdS58pEO4A8/+1OQQWUHx1UHtzyW2OFP0KDYwkTNPs4lrO
         XRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7nBBBAMQ5zeS5mQiQ5KVjRlcsKmvLYnDcbFR0E1QZHs=;
        b=uW9mJ2lmbuDfF0vgZuijGLRCqonDdJufB107nme/I+69J/iHBsLsgY9m7J9zMHIb2e
         WssWLHwSi2mMUrWs7lIZm4J872QsZDQvQRWuPWOsazPaZQx2owH8AxSv1KiA6LxVn30U
         i1+aRQEMb9S/IshO+xxMr7aEjuHOfCzIwixZJStdItFPC2eU+klFJaiMM2y9cKpSoGSb
         MbmT+TBqOXfLEmJXdjaqyDV77+GdXGmMdH05HpiGldfUH/BIECYj8AZ8rRgiMRBTw+/M
         52KzjXbArE1cNpC37J3Kq26NopWnqZjHdDaLb0K0UEvHLs5Y8qVMFDdJ9iQZX9lbnQky
         Hb/w==
X-Gm-Message-State: AOAM5332WnXTCqVGoi9HNAqroRGNrPO0WdmrGeGV9lCyIvEpecuQ6rE0
        N50AifswngL3vRq0/fdYTsOByIC5SZB2IBcymWo=
X-Google-Smtp-Source: ABdhPJy+iKcaVJRHLwia1W/1YwHbbGaC/MOnkKkE3OTEo3tGAbhnmbcHh72B/HCDtM1h7SIcqsdyk5GWVslKJWz86Ik=
X-Received: by 2002:aa7:9109:0:b0:50a:78c8:8603 with SMTP id
 9-20020aa79109000000b0050a78c88603mr14238840pfh.77.1652074559579; Sun, 08 May
 2022 22:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220508152713.2704662-1-vladimir.oltean@nxp.com> <20220508152713.2704662-7-vladimir.oltean@nxp.com>
In-Reply-To: <20220508152713.2704662-7-vladimir.oltean@nxp.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 9 May 2022 02:35:48 -0300
Message-ID: <CAJq09z7AUCA9ya+8JJXGV_2NAFZ4W2jjq_OemkVokhOPBXxM_g@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 6/8] net: dsa: remove port argument from ->change_tag_protocol()
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu_index,
> +static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds,
>                                          enum dsa_tag_protocol proto)
>  {
>         struct realtek_priv *priv = ds->priv;

For the rtl8365mb family, tag protocol is not a per-port property.

Acked-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
