Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52920680183
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 22:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbjA2V20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 16:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2V2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 16:28:24 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F5514481;
        Sun, 29 Jan 2023 13:28:23 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id e8so8545906qts.1;
        Sun, 29 Jan 2023 13:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vvsETFyAWEBQowq6cfHTnP7Iio5EX4ZyEImdco3L9U4=;
        b=e1K8fFc++/gRpxtRWLurMWIVlKZ44/MaW68q2jyzT1NJlIBjCu4+T3u38nxuZ1pyif
         TBKMcxVW9YYszG0sCmnBtzCDiiAiW8JTZmhkRyEH1L/aP2IWS+L+8OnRMkxoOUaaWfUx
         DPgQdgHPMVNrNLACCstxyv2uoAf75HFOlVbiesVGWFOhl9xLHrSMI+nboqVzyTfVtpPQ
         e5Qzd8rsoHXekX5D0d9rkzm5HHJ66I+/rrvCZzDcPCf2yI6k/5z+aVF5cN29D0mw0ZaG
         mCapxaCBWcyPU92yzgTlzM3gX+/0tAOeYHJDTmIAWKLAjqY1hZND45M5M3FEbFw1ERGb
         tqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vvsETFyAWEBQowq6cfHTnP7Iio5EX4ZyEImdco3L9U4=;
        b=ROErI+Chawj3CRyBCmwvMmF8PPMXhYr7LVi4WqfwTCWw5A9lCyHmUm1J9TOqecCWd7
         xYp39DNON5pFoetN5co0MRslEYgDmafvG/yxbG7mXCmn4u1ugI2s6XSnOI0zhAbtrTQg
         0KpcRNVzNs4S0r3N0f0pWTR2B3PbdCXVNVDYtCw/l6xHjtNar8seoT40C81HGA1FjN4L
         7S4jLi0lDU90x9ppMiHk99wCFnq+wV2a4ccUGQqtdXeD4IBx5dSwENhPzJV8PqthygFE
         BPQI7u+38/nMRBSJhWK8xUY9RQ7zmAbwiCQZLClhIQKe0Dow3/lb97K8XX8VaWxrcCaT
         BLJg==
X-Gm-Message-State: AFqh2kqJFJWdXULUtjFmyhpI/x1eMQHbRXGGHEqxEqI5wTckZ8UBM2Dy
        fXfLo3CyP0lmtHyFgAtgyKiQv776RdWbIfXOb/k=
X-Google-Smtp-Source: AMrXdXtvz+/bcPwRJPRwHRp/fsg+vFrqOVg9xu75imb1lMxdG5Up9Mi1ulKxVQevv+9KfeGbTcwUQL4wWCEkIW6yf78=
X-Received: by 2002:a05:622a:183:b0:3b1:c62b:c140 with SMTP id
 s3-20020a05622a018300b003b1c62bc140mr2510656qtw.313.1675027703027; Sun, 29
 Jan 2023 13:28:23 -0800 (PST)
MIME-Version: 1.0
References: <20230129022615.379711-1-cphealy@gmail.com> <Y9akLWJfigajMuQP@lunn.ch>
In-Reply-To: <Y9akLWJfigajMuQP@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 29 Jan 2023 13:28:12 -0800
Message-ID: <CAFXsbZppb5tDxR9tO7RN76=rt04MdAUU16HhyNizJBtAXtq+fg@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: phy: meson-gxl: Add generic dummy stubs for MMD
 register access
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com, Chris Healy <healych@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 8:52 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Jan 28, 2023 at 06:26:15PM -0800, Chris Healy wrote:
> > From: Chris Healy <healych@amazon.com>
> >
> > The Meson G12A Internal PHY does not support standard IEEE MMD extended
> > register access, therefore add generic dummy stubs to fail the read and
> > write MMD calls. This is necessary to prevent the core PHY code from
> > erroneously believing that EEE is supported by this PHY even though this
> > PHY does not support EEE, as MMD register access returns all FFFFs.
>
> Hi Chris
>
> This change in itself makes sense. But i wounder if we should also
> change phy_init_eee(). It reads the EEE Ability register. The 2018
> version of the standard indicates the top two bits are reserved and
> should be zero. We also don't have any PHY which supports 100GBase-R
> through to 100Base-TX. So a read of 0xffff suggests the PHY does not
> support EEE and returning -EPROTONOSUPPORT would be good.
>
This seems like a good change to make in phy_init_eee().  I should be
able to do this.  Can this be done in a subsequent patch or does this
need to be present to land this meson specific PHY patch?

>         Andrew
