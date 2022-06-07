Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A229153FFD5
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 15:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244541AbiFGNSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 09:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiFGNSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 09:18:08 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A1967D11;
        Tue,  7 Jun 2022 06:18:07 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id bo5so15526396pfb.4;
        Tue, 07 Jun 2022 06:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pEUfspnU4Q0xYV8O4jrnwA8T8Qz0Rm4rMMQGRXaaEVY=;
        b=lZ90L9piIk3lL/kkGtkHRka/aIQiV2WjQgZJHkux3fy1fqyTPqrZ4ya4GPOia6M9z6
         dMcXDe/6Pca1qk+DEQcz/8pQ3WyR4u6TnG6z4TepPMUJ1rkI7ew76oDJfyFARH+dihNq
         BTjuvKyQUlNcISuqED/RrfAaneg3nWNquhN+EBPiXaEmjpCQB55HkCSRR0/yjKc/kd6N
         on9WB+TPN048+MrhPICItQ2fn1fV+DeDGItoDzdEcTAaVrccp5c40svm+VlESHN3fd15
         /RkQKpe9aQsavoJF/ZIJTUq04di35Grr8/BPDNxktfbGOdUK4YqKeMc4Ts0ZeuDuoYCe
         HoGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pEUfspnU4Q0xYV8O4jrnwA8T8Qz0Rm4rMMQGRXaaEVY=;
        b=XmG+H3CxsZN449+3LuuAreSZSztli6PqFeYBreNqKCzVWXRscXL/jGrGizY/WT+i+X
         q62vtXV3YC1gfybUbNTD5t6f5nRwuP++XrO3DBILCJVlI9GUdECVfEI0yQ5+FX9kE1XY
         04GbwB4XWkmhdolTQrguhKX6Gkov6UGeSVWiycV36Pw+nE0MMhKuDo4X5rbXF9ZzirB+
         UhC1RUoi22pAO/w3egJIM7Yg899dfV2QqhNjp6+tNJqWXuz53cHOHxDPbeDvT1udnjHl
         aMnZQYtj05T13gBoeJWwi105ArWgirY+cfzoeMkOpspBwy3m4rOFFpbjDFwiJlg5mCYQ
         mPkg==
X-Gm-Message-State: AOAM5302jSHRAlejDM5orlLQ59m1khg81hnG5w7cn67ZIgLBT2EL6TAp
        KRbUbYLXCwvjXZUuzwUITsnn6fjiX8lHToWga60=
X-Google-Smtp-Source: ABdhPJycsTwXH8xUByy1rPdgeLJE1lA7z9hSbDXuUbVFW1jS3hqVpM2IbprOGUMcSUD+KSomBS2BfU+6Rrfdmlw3E2Y=
X-Received: by 2002:a63:cc09:0:b0:3fb:aae7:4964 with SMTP id
 x9-20020a63cc09000000b003fbaae74964mr25199375pgf.118.1654607887120; Tue, 07
 Jun 2022 06:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220606134553.2919693-1-alvin@pqrs.dk> <20220606134553.2919693-4-alvin@pqrs.dk>
In-Reply-To: <20220606134553.2919693-4-alvin@pqrs.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 7 Jun 2022 10:17:56 -0300
Message-ID: <CAJq09z4f1DN1b=+QONT7ya5nXVQ6m8ZcMDVemmkduWc9mXSTRg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: dsa: realtek: rtl8365mb: correct the
 max number of ports
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em seg., 6 de jun. de 2022 =C3=A0s 10:46, Alvin =C5=A0ipraga <alvin@pqrs.dk=
> escreveu:
>
> From: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
>
> The maximum number of ports is actually 11, according to two
> observations:
>
> 1. The highest port ID used in the vendor driver is 10. Since port IDs
>    are indexed from 0, and since DSA follows the same numbering system,
>    this means up to 11 ports are to be presumed.
>
> 2. The registers with port mask fields always amount to a maximum port
>    mask of 0x7FF, corresponding to a maximum 11 ports.
>  /* valid for all 6-port or less variants */

It makes sense for the family. The 10-ports variants have 0-7 user
ports and ext0,1,2 declared in rtl8367c driver, although no model I
know does use ext2.

Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
