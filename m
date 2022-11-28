Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC74163AB23
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiK1OhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbiK1Og5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:36:57 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5978A1E3C9;
        Mon, 28 Nov 2022 06:36:57 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id y17so2430988plp.3;
        Mon, 28 Nov 2022 06:36:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2tfGJ688yw66/5+c/tC+iEpvYaVIiyqra5EJQGq6yW0=;
        b=THpMDmRnWZdTY5f6irzQmpEPD4/tR78MeeDpj6DaraTF9WmnyroYnsN4AcWMnxfp/5
         USigBlCRaoG9FmiL6IOXP8u88gUMl+lg8EmE5MAD4WN+VED72B7XOo1nDo2hPtsKZr0V
         4Qdj9kSXKbXHeOrQKEINVSbX6mcnUIqrW1QLA2RWqh4d0gMDDOVx0AS3UZNG7r9GEVXB
         RQ3qkFGq3vi9G1PZ2d5U3pBfqVvfjbTWyArW4RfzFPJtg1x8T6jMAqj9lZspyu4hWhou
         kl656nLBoCeB+vyNOetbyI2Lm51sSPj65Xn0F6GkDEcBAzACH8LF+WUllN2vKK0TG5ou
         h4Pw==
X-Gm-Message-State: ANoB5pnUEaO30OYoLT7+vkHFJsMOdSWIx1QTLJ7iNmAz0KFDyNYvpjqD
        Rp3cHX5crWUkBBT9lrltMlvfC96B12xuKETaR7TZ4ah01oLO7Q==
X-Google-Smtp-Source: AA0mqf71NiCmueKGbVL7eIHIYR822P/A0exOdsRXjEcjJAEpb2yA2syOqwKfhDRGpYN4qf3CBZi4D5hSrudyEHiFHAg=
X-Received: by 2002:a17:90a:77cc:b0:219:1747:f19c with SMTP id
 e12-20020a17090a77cc00b002191747f19cmr13715759pjs.222.1669646216859; Mon, 28
 Nov 2022 06:36:56 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-5-mailhol.vincent@wanadoo.fr>
 <Y4S7LB0ThF4jZ0Bj@lunn.ch>
In-Reply-To: <Y4S7LB0ThF4jZ0Bj@lunn.ch>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 28 Nov 2022 23:36:45 +0900
Message-ID: <CAMZ6RqJjq795FyvSSuro1y+x2z+K6o6aasPTgajxKC1b4ECOLg@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] can: etas_es58x: remove es58x_get_product_info()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 28 Nov. 2022 at 22:47, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sun, Nov 27, 2022 at 01:22:09AM +0900, Vincent Mailhol wrote:
> > Now that the product information is available under devlink, no more
> > need to print them in the kernel log. Remove es58x_get_product_info().
> >
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> There is a slim chance this will break something paring the kernel
> log, but you are not really supposed to do that.

Greg made it clear that this should disappear:
  https://lore.kernel.org/linux-can/Y2YdH4dd8u%2FeUEXg@kroah.com/
and I agree.

I do not recognize the kernel log as being a stable interface to the
userland that we should not break.

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thank you!
