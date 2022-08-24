Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B51859FE9A
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239680AbiHXPlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239762AbiHXPlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:41:12 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60DB4B0EB
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:40:56 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id w197so19824694oie.5
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UhlPI/jsKsR0i6K9Z7/EgBHG71zEf6eVqkOOniCtnEY=;
        b=gFaPrTI39NKUeoJX3MIkPgSG7w0vZwyoQAQlZAsU2UmH7X2+/ylHFPey5MS9nOLUMS
         qOfO1fb21BwAc1m9Q+8JFVUO6TvfzYH3bDa5+JdDONrB6Yb+M/oCjlLatWaaAqoSclLJ
         jK6EtFXwc57KXrU1xDw2BIDhZNYEfEZuNzQ0MvTVhPOJd8mCISG2TRn62zNrdoyXwkz2
         nRxkUT0mFTkBpwCcnbWVVDQaRc7M7qCKxxK/gc0cqOIBTY8WFcqpGT8Ryi/CnbhnmtBi
         TBHImPa50zUNMD4fSZC3/QNOhyieyfT4Hs7/NArdlN1ZB4PmLtLJVrfebnRlabpnxDh+
         bmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UhlPI/jsKsR0i6K9Z7/EgBHG71zEf6eVqkOOniCtnEY=;
        b=8E5E2CksZ1R7UjQlm6IT/h0WlrcNdygfze7XtH3fi8fS5GajWuSXjXyAhKTS4rI6a4
         BYAsDWfIcbrpfARfIqfwRng673j3SUD6lbPYNFk2D8oM1VFC5Wpz/I4mmPooXu56n5ST
         ZF7sFOXngPk04wv3azj1pQQQ6ONdiya/76Ue6vdcdfEqby6ogklojjS/CSp3avOoSwH8
         O+fq8LKx5SOMSSPlVn8VYPXD4eRgyD+BVtS5ZU64DblEZuaDEZ0cfl5jrhEp5UNjzB/S
         JM3kgWmYC4eMwdVDtBugsIe5nOOH8YSunL2mEvN1y6Yr/E50fTVZtleMcFsjKpaJtorS
         YNaA==
X-Gm-Message-State: ACgBeo02p2CXcrathoXJ8VCEabrAVmf1z5ruEMsTk72/Ddfx2OmcNcQx
        zsobHuzPWjpPSLSZWiA//8jYiTJSwuec64afREw=
X-Google-Smtp-Source: AA6agR4bYhMvAKVeXJijFKU9bWALjRaUgV6Nf9QaJlKNXxm9mXLwGAkmbeA1j3dIWC92Rqz1EJ/ZWP2BLzxDkbbXROc=
X-Received: by 2002:a05:6808:2026:b0:343:616f:94ba with SMTP id
 q38-20020a056808202600b00343616f94bamr3363977oiw.212.1661355656101; Wed, 24
 Aug 2022 08:40:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220824151724.2698107-1-saproj@gmail.com> <YwZEmo9sVds8CJdD@lunn.ch>
In-Reply-To: <YwZEmo9sVds8CJdD@lunn.ch>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Wed, 24 Aug 2022 18:40:44 +0300
Message-ID: <CABikg9z4n75TdoUd-9Q-W2Ahr5-yTszKVxq09uHB9kyhQkhTng@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ftmac100: add an opportunity to get ethaddr
 from the platform
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, tangbin@cmss.chinamobile.com,
        caizhichao@yulong.com
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

On Wed, 24 Aug 2022 at 18:32, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Aug 24, 2022 at 06:17:24PM +0300, Sergei Antonov wrote:
> > This driver always generated a random ethernet address. Leave it as a
> > fallback solution, but add a call to platform_get_ethdev_address().
> > Handle EPROBE_DEFER returned from platform_get_ethdev_address() to
> > retry when EEPROM is ready.
>
> Hi Sergei
>
> This is version 2 correct, you added -EPROBE_DEFER handling?

No, that's v1 for drivers/net/ethernet/moxa/ftmac100.c driver and
-EPROBE_DEFER handling is present from the start.
I previously submitted an analogous patch for another driver:
drivers/net/ethernet/moxa/moxart_ether.c. And yes, there were v1 and
v2.
