Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D926A6C3433
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 15:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjCUO2R convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Mar 2023 10:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCUO2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 10:28:16 -0400
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7632350705;
        Tue, 21 Mar 2023 07:27:51 -0700 (PDT)
Received: by mail-qt1-f181.google.com with SMTP id c18so18026405qte.5;
        Tue, 21 Mar 2023 07:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679408835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pwf8rQVzZz9UeH+SyAgm4VBiDO8a7YgTXmFKX3lcsqE=;
        b=pqUXyAIjGq93itskI+ReynPgX9qqPAU10lSnicl5CzK9fsU7zT/jDcqJ42SRUdNzAa
         kVZ85uwzUTJyAdA1xhnThQ/av/FApE1ORTqNPuMNa1JhL56DFwNFmZQnTVErsad8/9kR
         gxFu1zN3MM/SqZqdthTGeMUHrO4bFJdD5r0Zned5Im0y4/RP5FryG7wPTy6vV52Z3WXH
         p7xXrRh1SdllN6pHmTyvtfxNtoju6Af9YDrJRC5Tp5U6k335J6eou4wSy16EsCm6P2NL
         fR7O61b0FdMpd3ouGX7H8t78PUJjTs4y5tyxlFL7hEvHA54gDC4ipY5Hy8tNF8LMVGno
         IXYA==
X-Gm-Message-State: AO0yUKU+WWrLbkBdAswInsyfCfFajdWRak4RWaJSi/crKBBf+tO9P7TL
        eRK09SlVqsxhcQsdPcjDsOGGE2dsQh2neA==
X-Google-Smtp-Source: AK7set85cEj8TSZdffh4vJC4L8y3Cfuan4aRIvfHei90WFDYc+D4OqWQfNBxYSnWoa4V3yFPrT9Jtg==
X-Received: by 2002:a05:622a:40e:b0:3bf:db21:8c87 with SMTP id n14-20020a05622a040e00b003bfdb218c87mr4660412qtx.60.1679408835116;
        Tue, 21 Mar 2023 07:27:15 -0700 (PDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id c20-20020ac86614000000b003e1080e0f8csm3951266qtp.16.2023.03.21.07.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 07:27:14 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-53d277c1834so283311787b3.10;
        Tue, 21 Mar 2023 07:27:14 -0700 (PDT)
X-Received: by 2002:a81:ac62:0:b0:541:a17f:c779 with SMTP id
 z34-20020a81ac62000000b00541a17fc779mr1183143ywj.4.1679408834245; Tue, 21 Mar
 2023 07:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230321114721.20531-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230321114721.20531-1-wsa+renesas@sang-engineering.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Mar 2023 15:27:02 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXrvdUPTs=ExXJo-WM+=A=WgyCQM_0mGKZxQOrVFePbwA@mail.gmail.com>
Message-ID: <CAMuHMdXrvdUPTs=ExXJo-WM+=A=WgyCQM_0mGKZxQOrVFePbwA@mail.gmail.com>
Subject: Re: [PATCH net-next] smsc911x: remove superfluous variable init
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram,

On Tue, Mar 21, 2023 at 12:50 PM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> phydev is assigned a value right away, no need to initialize it.
>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Thanks for your patch!

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/drivers/net/ethernet/smsc/smsc911x.c
> +++ b/drivers/net/ethernet/smsc/smsc911x.c
> @@ -1016,7 +1016,7 @@ static void smsc911x_phy_adjust_link(struct net_device *dev)
>  static int smsc911x_mii_probe(struct net_device *dev)
>  {
>         struct smsc911x_data *pdata = netdev_priv(dev);
> -       struct phy_device *phydev = NULL;
> +       struct phy_device *phydev;
>         int ret;
>
>         phydev = phy_find_first(pdata->mii_bus);

Nit: perhaps combine this assignment with the variable declaration?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
