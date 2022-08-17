Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544FA5974CD
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiHQRKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbiHQRKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:10:09 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BD561D42
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:10:07 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id w197so16052921oie.5
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=liA8sIEE7LH4n5y05JVSRt5VQvO59ez/QUOReNCYsxM=;
        b=f2OI8WfPdjKXAcs7paiG1HY5d6s404gX5B2dmkrKi6Y1PmLUXQZqVDymiRkxmq8e2d
         dnTbDnioaV35aVMkMkNARzS8f4kx4grLBod+u8RI0fV6HAy8fPATuFwBgdSqMjdd8cpW
         swXiOjg9sw5y05vYJeuoI0hEW65clZFLkkPtJqVoMRhY0p836vKSkTKSB8UZka/sPEPE
         eRm/uOx3LNWnkUiqiZ4RLe1Yrgk/qQjlgnZiOnbv4ZJRUpYs7lzCcvrJsKeX4lHGhQtY
         evv/9A1dNvCTJ0JDGyKAShDlhCG0/yrNe5y2EoCKBcXOKKGIpNVF/Fph5XHKNuU0iFKA
         xVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=liA8sIEE7LH4n5y05JVSRt5VQvO59ez/QUOReNCYsxM=;
        b=aMglipafr2Ove05vr2C6TbGleUMsjaZhDyFbb0FQziYCgolgUAips+DbewP/tv+QML
         cjDVO+JQRIgE3A9go2G3swgVsSGOqHv4SfBmEaMMzfOZvbvvrt52AnBVEYQSpRsRYb28
         IdSOlc2aleE74pX6e9jsVTKRBsK6jGs04KoJApzdqFOvZVaEqFlytCc+y30PRkKdm8/c
         prl5TIXSuE8GHWynErHkD5moD+4V7l+KBua9tqXdr+NTO88+szXWkq2JUtneEXHBwSjU
         Qf/MgG8K7S3Iwn9eHbAsq8Myo9EmC2hRyL6sP0t7ZtjR9vr+pbMscvEmRuz3dAICX/QK
         Zt+A==
X-Gm-Message-State: ACgBeo1eSti1H1OH/q+WQ1kwmKUSMc9DGsUdiITiXWjHKUQKASXjckju
        baiiaz1CTbPu0/QGirtSOZgB0Gvivs+hO2wejbI=
X-Google-Smtp-Source: AA6agR5Qe8nmbumnDA95mXGcBIWwDmfDo75zi0sHAf0F+xqlmC20F7fQowqOdBBUS0V84t45cD8bcv/3N/1n3IhHxV0=
X-Received: by 2002:a05:6808:1b25:b0:342:ff09:2c32 with SMTP id
 bx37-20020a0568081b2500b00342ff092c32mr2006228oib.26.1660756206848; Wed, 17
 Aug 2022 10:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220810082745.1466895-1-saproj@gmail.com> <20220810100818.greurtz6csgnfggv@skbuf>
 <CABikg9zb7z8p7tE0H+fpmB_NSK3YVS-Sy4sqWbihziFdPBoL+Q@mail.gmail.com>
 <20220810133531.wia2oznylkjrgje2@skbuf> <CABikg9yVpQaU_cf+iuPn5EV0Hn9ydwigdmZrrdStq7y-y+=YsQ@mail.gmail.com>
 <20220810193825.vq7rdgwx7xua5amj@skbuf> <CABikg9wUtyNGJ+SvASGC==qezh2eghJ=SyM5hECYVguR3BmGQQ@mail.gmail.com>
 <YvUOSWxZPXa2JX8o@lunn.ch>
In-Reply-To: <YvUOSWxZPXa2JX8o@lunn.ch>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Wed, 17 Aug 2022 20:09:55 +0300
Message-ID: <CABikg9x4LbOR25aLJ_=EE5SxDQJXj5_dod6rCgmeQXxmKAR+SA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6060: report max mtu 1536
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
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

On Thu, 11 Aug 2022 at 17:12, Andrew Lunn <andrew@lunn.ch> wrote:
> > The driver does not know its MAC address initially. On my hardware it
> > is stored in a flash memory chip, so I assign it using "ip link set
> > ..." either manually or from an /etc/init.d script. A solution with
> > early MAC assignment in the moxart_mac_probe() function is doable. Do
> > you think I should implement it?
>
> I would suggest a few patches:
>
> 1) Use eth_hw_addr_random() to assign a random MAC address during probe.
> 2) Remove is_valid_ether_addr() from moxart_mac_open()
> 3) Add a call to platform_get_ethdev_address() during probe
> 4) Remove is_valid_ether_addr() from moxart_set_mac_address(). The core does this
>
> platform_get_ethdev_address() will call of_get_mac_addr_nvmem() which
> might be able to get your MAC address out of flash, without user space
> being involved.

Great suggestions! So I am submitting a patch named
"net: moxa: MAC address reading, generating, validity checking"
