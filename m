Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C14F5D47
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiDFMG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiDFMFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:05:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A3A47CDF2;
        Wed,  6 Apr 2022 00:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B738B82140;
        Wed,  6 Apr 2022 07:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07510C385A8;
        Wed,  6 Apr 2022 07:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649231330;
        bh=5kdeIYu08lrxcinXo/wn2rGDmkAPiaise7blEAq0ra8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u5nFxI62qds5luCwfiabA3w51nPKdqqjIMBcDMinr/PHt+JWti3y2LkM+z89cdNFP
         IYGef0xODvNkk/Ni/Fdlf++5AuKlIKNvd6egdZqdGWTy7N1Xv57DwKeWyJsZVlmuKS
         wq8x0uZt/9WFgIcuo5V2nzIzlm+OqupK2uKxo5+vVcms9wGYqemQbIn72z91NEBQa1
         jP5miy8EFXkaRB7WqSkWyNdJFDRtJFKFMA8pJ9Ov1VFMdRK7m/6SeeVogLeIidtAeO
         +2qFGdy9YX9CB3xInHWLg5/11szsQVTLBU5G8yu2c1MARrRIDb2E9jAooM/g4zsNDw
         Rz9d/EHKsWaRg==
Received: by mail-wr1-f43.google.com with SMTP id r13so1863164wrr.9;
        Wed, 06 Apr 2022 00:48:49 -0700 (PDT)
X-Gm-Message-State: AOAM533pm8zTIRgXVpQoPw4+BO0J5m1I46SgmBLJ4mkdR8Ace9y7CVH4
        /dPAHnJK2uDCU9vgAG2zUTrfvMCixxYnSzTevqA=
X-Google-Smtp-Source: ABdhPJyT5POylyPh0xGqg/cwaHmEHQNuNvVWSCOrc2ZuVu++yjHmGBoQMupeKZkipi8ZB8yq6SetBZGxhL4xb51Ipy4=
X-Received: by 2002:adf:d081:0:b0:1ef:9378:b7cc with SMTP id
 y1-20020adfd081000000b001ef9378b7ccmr5643198wrh.407.1649231328236; Wed, 06
 Apr 2022 00:48:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220406041548.643503-1-kuba@kernel.org>
In-Reply-To: <20220406041548.643503-1-kuba@kernel.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 6 Apr 2022 09:48:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0N=Rn95T1jZCCcOcF4WiBsMkObw4FLjbZd91wbAi2zww@mail.gmail.com>
Message-ID: <CAK8P3a0N=Rn95T1jZCCcOcF4WiBsMkObw4FLjbZd91wbAi2zww@mail.gmail.com>
Subject: Re: [PATCH net-next] net: wan: remove the lanmedia (lmc) driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, pabeni@redhat.com,
        Networking <netdev@vger.kernel.org>,
        =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
        Andrew Stanley-Jones <asj@cban.com>,
        Rob Braun <bbraun@vix.com>, Michael Graff <explorer@vix.com>,
        Matt Thomas <matt@3am-software.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 6, 2022 at 6:15 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> The driver for LAN Media WAN interfaces spews build warnings on
> microblaze. The virt_to_bus() calls discard the volatile keyword.
> The right thing to do would be to migrate this driver to a modern
> DMA API but it seems unlikely anyone is actually using it.
> There had been no fixes or functional changes here since
> the git era begun.
>
> Let's remove this driver, there isn't much changing in the APIs,
> if users come forward we can apologize and revert.
>
> Link: https://lore.kernel.org/all/20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
