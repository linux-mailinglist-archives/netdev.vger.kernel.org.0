Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB6066B456
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 23:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjAOWYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 17:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjAOWYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 17:24:04 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE94D1B559;
        Sun, 15 Jan 2023 14:24:02 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id jr10so16115718qtb.7;
        Sun, 15 Jan 2023 14:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x5CEEjTj94oORQHq8qrFgX/bob7yI66wmS6WvHqiTB4=;
        b=dkS+Ht+o01hyrCEQxbAf2lExqBmh0lmMPaPudTp22CU2rCdJ3jsc3xbXqp1jn/Cxmx
         80E1nrfn+UPrtHu5GN/TWtwxcabNgJ7iI9jRuYQcd/My16elIpSj2IbenN+qy8iYPM/S
         OQ7jgdEAGWRJbldRiv6B7MIFXMs+60J1AN18QFFg7oyZ4zKVaRXVdBIbijHG8kuM5Ayt
         GKuTOY7AAyvcmK9agtYhsiuf0h7gML96HVgtgDWcIlahwX2qDlPQkuqaL5IRUduaJsE9
         qTRbDyc88jD2lWNHQGqPdFPpbmavu7H+7JwzapECfVmZ4ZoZbpj60+qGX7udAF5npphH
         gBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x5CEEjTj94oORQHq8qrFgX/bob7yI66wmS6WvHqiTB4=;
        b=j9WcEVvMjwBKGVDi6yoO9zqA47iSwkNqd31/Uim+2PDhelVD+NnQeL++CbOyGA/1/J
         DPi5ZkJEfJM2eWdQFKt5eJve+NbhSU6zpQKAjhxw+R7U58YzkvN6coh3mM49p6tWcaxJ
         TZsAIzoUJnvFxqCk0FrXWFh5RU8HiOjzZA+XG8maxhsyan7lpVuqsObqkYpckAqJ3Wfx
         uGluI1c+RGiMCte6zzz5n0a4YSb581nDRWnqZSLQDW8QiaNRWwVbD+/HJDRzqgm1JkM5
         YVrJA674mVcHKCxc8gurH28C0xykbNv8Dogz743/A5nDzM7b49D7iFXGXLWsCz5NmgyC
         rmoQ==
X-Gm-Message-State: AFqh2kpDEWnxOk+ZYQU107y4mNgebnwqmho7gdivPxH5B5uZaIukvTmw
        OzvMUqNoRSMJb5Ppg7fJJ69ZPRh/gTPJ6sz3BOE=
X-Google-Smtp-Source: AMrXdXsmn3jks9Tqr0FP87D4jTVpSTsKtmgd3iSTaX5Bp8wgWBjnRxjI2eATyXyVbcvCR/ncXI/fR7SWQ3XQz06V2I4=
X-Received: by 2002:ac8:6b17:0:b0:3a9:90d9:58bd with SMTP id
 w23-20020ac86b17000000b003a990d958bdmr2664524qts.593.1673821442021; Sun, 15
 Jan 2023 14:24:02 -0800 (PST)
MIME-Version: 1.0
References: <20230115213804.26650-1-pierluigi.p@variscite.com> <Y8R2kQMwgdgE6Qlp@lunn.ch>
In-Reply-To: <Y8R2kQMwgdgE6Qlp@lunn.ch>
From:   Pierluigi Passaro <pierluigi.passaro@gmail.com>
Date:   Sun, 15 Jan 2023 23:23:51 +0100
Message-ID: <CAJ=UCjXvcpV9gAfXv8An-pp=CK8J=sGE_adAoKeNFG1C-sMgJA@mail.gmail.com>
Subject: Re: [PATCH v2] net: fec: manage corner deferred probe condition
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pierluigi Passaro <pierluigi.p@variscite.com>, wei.fang@nxp.com,
        shenwei.wang@nxp.com, xiaoning.wang@nxp.com, linux-imx@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eran.m@variscite.com,
        nate.d@variscite.com, francesco.f@variscite.com
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

On Sun, Jan 15, 2023 at 10:56 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Sun, Jan 15, 2023 at 10:38:04PM +0100, Pierluigi Passaro wrote:
> > For dual fec interfaces, external phys can only be configured by fec0.
> > When the function of_mdiobus_register return -EPROBE_DEFER, the driver
> > is lately called to manage fec1, which wrongly register its mii_bus as
> > fec0_mii_bus.
> > When fec0 retry the probe, the previous assignement prevent the MDIO bus
> > registration.
> > Use a static boolean to trace the orginal MDIO bus deferred probe and
> > prevent further registrations until the fec0 registration completed
> > succesfully.
>
> The real problem here seems to be that fep->dev_id is not
> deterministic. I think a better fix would be to make the mdio bus name
> deterministic. Use pdev->id instead of fep->dev_id + 1. That is what
> most mdiobus drivers use.
>
Actually, the sequence is deterministic, fec0 and then fec1,
but sometimes the GPIO of fec0 is not yet available.
The EPROBE_DEFER does not prevent the second instance from being probed.
This is the origin of the problem.
>
>         Andrew
