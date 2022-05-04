Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8C5519DE8
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 13:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbiEDL3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 07:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348730AbiEDL3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 07:29:01 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC4CA187
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 04:25:24 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z19so1321827edx.9
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 04:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5psn8Veh3wTuf+H5SCnyeH5hLbsMy0Ghbel382g1V34=;
        b=hD9j0Bm3E/f+CzwXKZFAJ2Jsej25OzoSLVt7Xa7qI+KimZpPSBvw5/mBC68ZaFLa/+
         SjphL5V9nQGFTlI+vaqPOh8zjuQ1uWKFbbAfWDbpDY67W3/ocY2sCCQII6ZZx/3pfHAR
         RDKj6G4BZAkKtRT/potuIQ000S9FCGm/k31+Md9wnsN39OlPhp1RM+4n9d4rk7Tf9hV2
         Ri+1v1BmuNWnB3FN/0Ww+4ITRbomTnuanR4T4DU2DVOYTD5lLBgiYufpKY3hZjRO4l8f
         kcz14Ldl7TcGDZgTc0gVtfjkguvsQNMa9tpmnSfpk2C9pFqQaEIsQrm3yvXBtyGSW3Pg
         mBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5psn8Veh3wTuf+H5SCnyeH5hLbsMy0Ghbel382g1V34=;
        b=waivbB6Oiyjl6siBzQpexh/oLDl28DJqYmTyrAdWNNThffYacwulaRfvOiGTOsqoTk
         dYHOFX6A+lRssiova6PeQXBGdToP+NUyiN+UncexhZLHZLGgndBShl+6b+F6chXVOQrX
         DrquoIB73jPlcfq/PhGthKPUxuMeNg0da2BAstCTEJfeiNgjCUp0OmKzroF8JlVxF8ai
         94RE9iSFXuVUDJUoj0XNuTkVuR8RMUIlP1RlbJTJiKlZUcjxOofiedGT/G4dLIpZc7sy
         SCNu8BUsRT8MY3rGAs1i9EwFxMFUrCvjHs+9s67T7C2YPn5yTGqsI5GY+ZVH+GuYeaOM
         56MQ==
X-Gm-Message-State: AOAM531NFyFfrpnU7mtlQ4xYuhzc4WiDTH2ncNPmPOkKi8nQSKj9FB0c
        wBStOjWcg6F82XsY8pykbPTmgoh6YcsT7hEyDhg=
X-Google-Smtp-Source: ABdhPJwj6MQ/qE05VARXoAAivrNQpkhlYcJGFqjRksNuCCY1lzLvILZErjYcW7KdvnQfX/TWeML4Rr7SmcPkYsNyl7I=
X-Received: by 2002:a05:6402:34d6:b0:427:cc9d:a130 with SMTP id
 w22-20020a05640234d600b00427cc9da130mr13288032edc.356.1651663523317; Wed, 04
 May 2022 04:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAOMZO5BwYSgMZYHJcxV9bLcSQ2jjdFL47qr8o8FUj75z8SdhrQ@mail.gmail.com>
 <CAOMZO5AJRTfja47xGG6nzLdC7Bdr=r5K0FVCcgMvN05XSb7LhA@mail.gmail.com> <20220504111351.GA2812@pengutronix.de>
In-Reply-To: <20220504111351.GA2812@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 4 May 2022 08:25:14 -0300
Message-ID: <CAOMZO5Dx=1NifFJ1BiWyiFoUm4n=RnCxA556yTNqMcKw4MM87w@mail.gmail.com>
Subject: Re: imx6sx: Regression on FEC with KSZ8061
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>
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

On Wed, May 4, 2022 at 8:13 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:

> Hm.. KSZ8061 do not calls probe, so priv is not allocated.

Yes, correct. This means we cannot call kszphy_suspend/resume
as done in commit f1131b9c23fb ("net: phy: micrel: use
kszphy_suspend()/kszphy_resume for irq aware devices").

I will submit a fix shortly.

Thanks
