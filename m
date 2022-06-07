Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3500A54001E
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 15:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244759AbiFGNex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 09:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244748AbiFGNeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 09:34:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A6FC0E3E;
        Tue,  7 Jun 2022 06:34:50 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso20833668pjl.3;
        Tue, 07 Jun 2022 06:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nlxHI5pyaLrlB7ND0VC51Zbr/G9/jKlDBRHH2ZyX0cU=;
        b=Q3yelo7VfE2k3ouw+w2afUY5Q6RURvSjC4ozP/UX7PT8C0Ppl6SsKeWkXRVsCkjE+F
         Iyakr1Br88UFYCwhpw0G+g0I6PiGuiBD5JIDUsO5iaZ+Oejt5c5/MSkzpXuzTQi3vtve
         OGfF+hn+X/MDbqL2lHwE8fFDwlRl5C2x3c6QFqWWTMIGZMOSiwxC4L7UuF//CnF7nwfm
         ZL4UvQ4YU0qBMqFOh7df7fgnsKmOxyaJOGwtSMLtBPzsH9wcFU3QPwEf013sESwb2Iaj
         QQH74ELVmhb1c9pTS+QRLRbzdL/Nvfsl/xE9ryPLv/qMinWZwqBWBPAuVltVH6QhKM1l
         4Uag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nlxHI5pyaLrlB7ND0VC51Zbr/G9/jKlDBRHH2ZyX0cU=;
        b=1a0skkl9rVgv/HZZItm7kPzdCOO6f6uhpwzR0IxcvWQXUo4fvlxPqr3RIH69GVlCi+
         zxkfVpxisvIqP6eZRHP3E5q1KnO98EXCy0/0nC3Wp+2arSJSBd8I6p5COSewKSOdLicI
         K/thQFeWC3s7KhkBHqhOWBVHFTx71pce1HFsIPG5D7VNCWsuT8XCjzQo6ZN2uKMv/hfO
         CkBl6lhnGOcqTIods5ENeqYs9rTDFbHTrf6taTZeR3resKZc1mqJKmMvoPnEsB/SojWu
         QWoFBZfZdk2DPvQvptzIkcAKZ/6CacKZ2fyoUU3VXmANCBU9t86IApNPM6Lr4XONcov3
         TDUA==
X-Gm-Message-State: AOAM532Yuqq13TDIPq1xDVxiRXpUpMNtG1Q8JhnB9O9ET4fhCCPLP4Le
        m/AUVK8i1qvo1wesgIS6YZlVw2EtmDz+YMZuGRo=
X-Google-Smtp-Source: ABdhPJwrY5Tczaplh0YoEL0T8UbCazQFQjnHacHc+CWbN3xEK80kwyqx6j70Qa458CD23YBVe2ts9gUpTaoelQhyYpQ=
X-Received: by 2002:a17:903:22cb:b0:167:992f:60c3 with SMTP id
 y11-20020a17090322cb00b00167992f60c3mr2175720plg.59.1654608889474; Tue, 07
 Jun 2022 06:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220606134553.2919693-1-alvin@pqrs.dk> <20220606134553.2919693-3-alvin@pqrs.dk>
In-Reply-To: <20220606134553.2919693-3-alvin@pqrs.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 7 Jun 2022 10:34:38 -0300
Message-ID: <CAJq09z6TDWSFZCFHTSevao4-fsiVavUYtmBFVttMhYqsOobg9g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] net: dsa: realtek: rtl8365mb: remove
 port_mask private data member
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> There is no real need for this variable: the line change interrupt mask
> is sufficiently masked out when getting linkup_ind and linkdown_ind in
> the interrupt handler.

Yes, it was currently useless as well as priv->num_ports (it is a constant).

I wonder if we should really create irq threads for unused ports
(!dsa_is_unused_port()). Some models have only 2+1 ports and we are
always dealing with 10/11 ports.
If dsa_is_unused_port() is too costly to be used everywhere, we could
keep port_mask and iterate over it (for_each_set_bit) instead of from
0 til priv->num_ports-1.

Regards,

Luiz
