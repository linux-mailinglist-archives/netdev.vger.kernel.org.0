Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BBA64B263
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 10:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbiLMJdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 04:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiLMJdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 04:33:53 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E915B65D4;
        Tue, 13 Dec 2022 01:33:47 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so2902044pjj.4;
        Tue, 13 Dec 2022 01:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UnpfW1xsp4JQxXnbwoKCVJJIgdv7OzUs6Zq5mcUTMNk=;
        b=hko9RtDQK1Gx9ojkTyhPcFpx6Mdce78CYWU34PsF9Kt17jTsMQLc2S0/Tl1fKEzsaA
         iQ5wgo39370BdsiYdWjneY41YWSYw1WXiVh2veJpgOJqU0BNg8rHvUrsBdOBET4mjYK+
         u1lu81NlsxAGKeg4SvM+s93bSTjdxA9LiahZFt+XxNI+Iw0DYlx8q34ToeU79qe/aQ6G
         +lBd+4nTOXtzScWv5zXRYrBlPDwgwCt7o7COXgQiqLmWT0i5uX/ocf8KLhPqCuRHp0eJ
         kICyMWUU6LG0LLRnBzI6xsqvK3n+EN8JOaJ1pPhoEgxyaW8mxKW7ZRoHmsdn869/fxqY
         r/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UnpfW1xsp4JQxXnbwoKCVJJIgdv7OzUs6Zq5mcUTMNk=;
        b=Bpcx7cA1txWL3eDVvosEykFcl+kf137dDqEgOpC+X7OC40PAXVBGN8I4b4QoghskAw
         bu/lAY4Hz6uB+DiQ+nCwQ0gF0Gq1vVG7FeypuaxfPoLm3i0+zq3UZ6KGVYgQfioNTmkb
         GLbW0Q4u/NFIsjrPlVNfwfqv/mDiI9+Etrv/m+MtjKnvDdkibXfAKN6sAnLeyRmSF8Cx
         CCrkCVSw8x+U1apzJGb9Yk3+zHJzTNH0mEeW5OqSyrOeRDlAnoV3uO49utEdNZURi8NZ
         eEbIr+lw3ITyw2SYdt5xUz1cF7x2XsjcAnzDbzxVPS65LkjdBi9UG/Uu6LruxU4LLccr
         6tmg==
X-Gm-Message-State: ANoB5pk8RKuNk2lte85HYFyvcFTbfceItLbxoHXrDdPP7NrwdNerJfkS
        Pmr5gelHexa5s0m6MFOT6j0FcsFUNBFIocY7UK0=
X-Google-Smtp-Source: AA0mqf4b4eLkdsoR35SW9T3xnJMefihGGVJe+ilCVs5WoJD45a9eRgPYawa/L0UsH2udMvAYuTfKiNpxpkv5PpTnm+A=
X-Received: by 2002:a17:90a:bc8e:b0:219:720c:86aa with SMTP id
 x14-20020a17090abc8e00b00219720c86aamr178413pjr.172.1670924027348; Tue, 13
 Dec 2022 01:33:47 -0800 (PST)
MIME-Version: 1.0
References: <CAOMZO5AFsvwbC4Pr49WPFmZt7OnKjuJnYSf3cApGqtoZ_fFPPA@mail.gmail.com>
 <CAOMZO5AWRDLu5t0O=AG7CxNLv20HTmMTRh=so=s7+nTH0_qYgQ@mail.gmail.com> <PA4PR04MB96407AC656705A79BF72D2E089E39@PA4PR04MB9640.eurprd04.prod.outlook.com>
In-Reply-To: <PA4PR04MB96407AC656705A79BF72D2E089E39@PA4PR04MB9640.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 13 Dec 2022 06:33:29 -0300
Message-ID: <CAOMZO5AMy_H-zw1phB6MtNdpbCwtXg74BwHrs5YttykN=-wvnQ@mail.gmail.com>
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

On Tue, Dec 13, 2022 at 5:15 AM Jun Li <jun.li@nxp.com> wrote:

> So this disconnect and then connect is you expected behavior?

Yes, correct.

I found a way to get this behavior in both 5.10 as well as 6.1 kernels:
If I remove the USB_OTG2_OC pinctrl entry and pass
'disable-over-current', it works as expected.

On this board, the MX7D_PAD_UART3_RTS_B__USB_OTG2_OC pad goes to 3.3V
via a 10Kohm pullup resistor.

Could you please explain why removing theUSB_OTG2_OC entry makes things to work?

Thanks
