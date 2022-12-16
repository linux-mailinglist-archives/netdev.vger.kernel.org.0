Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F00864EB1A
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 13:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiLPMA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 07:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiLPMAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 07:00:43 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6899B511FB;
        Fri, 16 Dec 2022 04:00:33 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id x2so2044886plb.13;
        Fri, 16 Dec 2022 04:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0Snl7BgVsFmc/5J29TspmwaDCZhYw6tUPa9r4mziXw4=;
        b=RhgC+LBhmLt2RSAqSktOu7ZFqHz4N0Vp3uhEf3qW2nQ4iW7wCrIJ81wp0KaUa05mBv
         SPuc91Dxe4jCcFpFVY6S1fOad5pq+5X5arL2IiKuy1UPf6Rg9PAv6mxH1ZRJSLDwE7H5
         LoPZ28GzTlGJ64wOzwGiUTQHpoOMVEQBsFCdPe0qOU/AkQIWIMCDL5/QJ2vdjI5E+FkC
         Pyk77L9Iaw00MUm4pS3SqTbJ/G/BMV84YPQGayaw5G+//dBNzZWaHvUCtzOabl02qENZ
         0Iatj29KinYcfTjbIw9dvsqEP1AsBoDLrfht3cZsDAXOK2qJkIHhLcGDGhIT87bJW7lo
         7r8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Snl7BgVsFmc/5J29TspmwaDCZhYw6tUPa9r4mziXw4=;
        b=ElpZbhma3+FOchTnmByYF5UM4urdv4qrppahR2noOn+yd86gJ+8UTanHNvX2vC4u4o
         ewkBE6SYJMLqdFBo5XfoxtlwEZAO77Ekb8FOjI+AEZYCeB/sOPB4gPNI7Sb0YNa4ZpgI
         CFHBNfxDQhX+GiL/AXoILhKn9lYrIuJSro9xPKX/1oa7E3OVSNtGgk/zvauuLIucgF1i
         PN/ITbi1Qg9XFjgp1uhd+/MnwBQYbeMN/kUyB3F2ZCW15qRLWIdm3n+/ZCBlatgI5SEr
         jsCY8pLMvA5hrlVXcErxNvumGf439D/vWnXp1F9FcMvjkljSN6fMuFv3cRYJNsXvbnOp
         TVbQ==
X-Gm-Message-State: AFqh2kr6KaI6yRuXmFDotVsPsdoFFcujR5V6C6vPI2xUwVVwB5GuMRor
        gSJDWG4BWhLdoJjCPYCoGrBy0LXp7oDDQBToEEU=
X-Google-Smtp-Source: AMrXdXsmay9yD3lb98nl7gf6xnfVfSOdLoQEcPmD5FPjUhryisMF2XJmX4NHqZfifvVsVlGXk09xn0GyjmecbdeUNw8=
X-Received: by 2002:a17:90a:46c9:b0:219:c691:9933 with SMTP id
 x9-20020a17090a46c900b00219c6919933mr600907pjg.195.1671192032852; Fri, 16 Dec
 2022 04:00:32 -0800 (PST)
MIME-Version: 1.0
References: <CAOMZO5AFsvwbC4Pr49WPFmZt7OnKjuJnYSf3cApGqtoZ_fFPPA@mail.gmail.com>
 <CAOMZO5AWRDLu5t0O=AG7CxNLv20HTmMTRh=so=s7+nTH0_qYgQ@mail.gmail.com>
 <PA4PR04MB96407AC656705A79BF72D2E089E39@PA4PR04MB9640.eurprd04.prod.outlook.com>
 <CAOMZO5AMy_H-zw1phB6MtNdpbCwtXg74BwHrs5YttykN=-wvnQ@mail.gmail.com> <PA4PR04MB9640B1C33E8D5704885A9A3B89E39@PA4PR04MB9640.eurprd04.prod.outlook.com>
In-Reply-To: <PA4PR04MB9640B1C33E8D5704885A9A3B89E39@PA4PR04MB9640.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 16 Dec 2022 09:00:15 -0300
Message-ID: <CAOMZO5AhUrYSesz9PC3o7T9Uum-X_QjmO=zjPAWkt25tbzJFSA@mail.gmail.com>
Subject: Re: imx7: USB modem reset causes modem to not re-connect
To:     Jun Li <jun.li@nxp.com>
Cc:     "bjorn@mork.no" <bjorn@mork.no>,
        Peter Chen <peter.chen@kernel.org>,
        Marek Vasut <marex@denx.de>, netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>
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

Hi Li Jun,

On Tue, Dec 13, 2022 at 8:17 AM Jun Li <jun.li@nxp.com> wrote:

> What's the OC polarity config in your SW, active low, or active high?
> Basically if the OC condition is active, the host mode cannot work
> well.

Yes, if I keep the OC pinctrl definition and pass
'over-current-active-low;' the problem
does not happen.

Thanks a lot,

Fabio Estevam
