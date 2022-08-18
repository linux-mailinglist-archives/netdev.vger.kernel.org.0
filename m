Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43B0597DCB
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbiHRFBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242683AbiHRFBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:01:35 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2162495E77
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 22:01:34 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u9so682279lfg.11
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 22:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=r4rJdvHK9Uejgurp/zzqjNfe8hbrR+MHgAvSS9UTA+A=;
        b=jJx0XeBwUX04oH+nMocHYwHkcVLGMr2iOq4E5u+1KRGBiAi9ICcn2TXNCYec3F/PRr
         PANX2SiNceJlQkAj42Vq+l19WKcX2rFvu66jLO9ngUmOUwxnvOpQRPW89yiRPG7Tmro2
         nf2RD3rNpVZ2is7WOw4qPRvkAZvP3ZgIP9EIPMmZF1rQ4Ll5XgdkXizGfauBT1ukKUYO
         GgljTpDXRtPwcwFG/1n4ebPOYe8DNsYcAN3bXKjRWgYw/GpJo1mR0MewwkLCtvYRO0DB
         1RG2lfghhXXTDzQGTlIo8cGEB/qJjNAwXm5XGJQtRHDyvMShPWOc3V9ZPnz0PDD5CCL3
         ZNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=r4rJdvHK9Uejgurp/zzqjNfe8hbrR+MHgAvSS9UTA+A=;
        b=kItiM4uqC0u7s7t1mF3ftvFrb2AJAJmHrvy15X7C0OZQ8MH6FHDbtS3nL3aTnhBSXP
         AV8Z8jzjmlLlYwEQcQXs0kG4lauXB6rGYkCzu3E9uN80ugxKjcN/ERwIYS6BA96wengB
         a5c8bY7f39/HqugIQ41mNo8oZwFKEl31xR1JM2yXXyqDsdy4QSQ/BtpSEaxSBFKol8my
         WDPnNp6usetPyiawnhBxv/akYw2bCwgRCYQme+q3BRlADU9VbbUAJ2cvqXtOnZoaED7d
         Z6+N5oV9GZbCn3F0yEpBeQNOdONHksW5LAFSIIkJZQfmefVGqp7XeeBhnONvmTZzs2eG
         d/aQ==
X-Gm-Message-State: ACgBeo13FtqdjC2HkKeiCDKHsoEZaHRYM+Oby3QUeE3RKFLqFq+X/O9Y
        K9OnRCQZiQDouhaoLd3dD3IKw9N/u4Hec1gOBA0=
X-Google-Smtp-Source: AA6agR4HkqVa3ZVJ8+4jlx1JF+zxWWDG6Zaks1ax8/M/BHZYH/orv/EMMbIX217INMOKoaliy8cUJhd3jw9K8sBxvFg=
X-Received: by 2002:a05:6512:3e1d:b0:492:b9b1:bc1 with SMTP id
 i29-20020a0565123e1d00b00492b9b10bc1mr397355lfv.278.1660798892408; Wed, 17
 Aug 2022 22:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220816102537.33986-1-chenfeiyang@loongson.cn> <Yv2hlkIpd8A66+iP@lunn.ch>
In-Reply-To: <Yv2hlkIpd8A66+iP@lunn.ch>
From:   Feiyang Chen <chris.chenfeiyang@gmail.com>
Date:   Thu, 18 Aug 2022 13:01:20 +0800
Message-ID: <CACWXhK=YF+z0wofjDAo7XW8cSV2NZgHpAK3u5=rkvvKTd8MjFQ@mail.gmail.com>
Subject: Re: [PATCH] stmmac: pci: Add LS7A support for dwmac-loongson
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, Feiyang Chen <chenfeiyang@loongson.cn>,
        zhangqing@loongson.cn, Huacai Chen <chenhuacai@loongson.cn>,
        netdev@vger.kernel.org, loongarch@lists.linux.dev
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

On Thu, 18 Aug 2022 at 10:19, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Aug 16, 2022 at 06:25:37PM +0800, Feiyang Chen wrote:
> > Current dwmac-loongson only support LS2K in the "probed with PCI and
> > configured with DT" manner. We add LS7A support on which the devices
> > are fully PCI (non-DT).
>
> Please could you break this patch up into a number of smaller
> patches. It is very hard to follow what you are changing here.
>
> Ideally you want lots of small patches, each with a good commit
> message, which are obviously correct.
>

Hi, Andrew,

OK, I will have a try.

Thanks,
Feiyang

>       Andrew
