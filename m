Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A9A560615
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiF2Qn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiF2Qn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:43:58 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A5C1FCEB
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:43:57 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id c7so5281398uak.1
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ECxWJ8+hcunFxEee4Dm/hI3ca5o+3lf6Z2+XxRk9iBU=;
        b=E/1rhnxb5jmKeWAf/UFFnGn+xd+IJDqdcY6Kj8Vi0SwVStH37AnTzug/UaFlZsTici
         lrCc+f2LxQBxDn7jq7NhqOOH63yXTiUn4pPZ2Kq3JIjJEmeOBk/SMT67l6fF0/RWfqzi
         08DDF8hd4TFKSb4pCrh7jfnrhwfOqxfQ+eLHNlFm2/j6RI00XEW31xQJMDTuNRtcoLs6
         MPDUie1BlOWPqSdpAcb0nlk9zxFDZPdVmzatoMYURtLqVCess4SHXOBCavYFxW32zgwI
         bLNTbD5uJ0iresciyaTkUySy3m6uMtEuogK188usZAOgrYDrsFlyHPgoS3XaZzgI3RmR
         Ke4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ECxWJ8+hcunFxEee4Dm/hI3ca5o+3lf6Z2+XxRk9iBU=;
        b=22aBVSIOsRoVWIFWCv+hZJxN6aJ96NzsMIemtCvl0WfCLR0P+TqQfJ+Fulhuupig4G
         wtOeZpho/7bKOKwfhmceMovXyCcGZokyF/SGAZB3Z58dFtXQ/l/loZ2dCERDBgP81bJR
         j+U2ZxCnQ80SqgP14xnlv3Et1OI2c8Ue2BPUYX+sdH38dlLK36SxdLBM1m27fbjy4b8H
         5RKXyZIVK4V2tqGfVEgwNqnppsGnqCYsITSEt72KPrxKsTeXxzMaUsdJNxSCKQ/fto0Z
         RV9AurI9+m6lkNStfi5i/Ek45a7wgopklC3Yfsb2hLyVpsSNwAap3GoD6No+dbZOYovV
         niUw==
X-Gm-Message-State: AJIora/M4gf0N+PjEoOtXogqrFpagtMFBCSabOgNv/X3IiEB9/V38xbr
        ABTTqNXQ9IJjpM6RkXTiiiJmH3Nd562x8mvDqs0PmS8tSX8=
X-Google-Smtp-Source: AGRyM1vA/Ued5rxPy7nJKDwc0yDOhWbBXnVEUgEP+sypSLTdDETAkBWqomXbJFqY6ckBSFqgjiLBAxl2W8yRGYoNiUM=
X-Received: by 2002:ab0:1430:0:b0:37f:315b:8802 with SMTP id
 b45-20020ab01430000000b0037f315b8802mr2512484uae.90.1656521036578; Wed, 29
 Jun 2022 09:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220629035434.1891-1-luizluca@gmail.com>
In-Reply-To: <20220629035434.1891-1-luizluca@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 29 Jun 2022 13:43:45 -0300
Message-ID: <CAJq09z44SNGFkCi_BCpQ+3DuXhKfGVsMubRYE7AezJsGGOboVA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave MII
To:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, krzk+dt@kernel.org,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
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

This RFC patch series cleans realtek-smi custom slave mii bus. Since
fe7324b932, dsa generic code provides everything needed for
realtek-smi driver. For extra caution, this series should be applied
in two steps: the first 2 patches introduce the new code path that
uses dsa generic code. It will show a warning message if the tree
contains deprecated references. It will still fall back to the old
code path if an "mdio"
is not found.

>
> The last patch cleans all the deprecated code while keeping the kernel
> messages. However, if there is no "mdio" node but there is a node with
> the old compatible stings "realtek,smi-mdio", it will show an error. It
> should still work but it will use polling instead of interruptions.
>
> My idea, if accepted, is to submit patches 1 and 2 now. After a
> reasonable period, submit patch 3.
>
> I don't have an SMI-connected device and I'm asking for testers. It
> would be nice to test the first 2 patches with:
> 1) "mdio" without a compatible string. It should work without warnings.
> 2) "mdio" with a compatible string. It should work with a warning asking
> to remove the compatible string
> 3) "xxx" node with compatible string. It should work with a warning
> asking to rename "xxx" to "mdio" and remove the compatible string
>
> In all those cases, the switch should still keep using interruptions.
>
> After that, the last patch can be applied. The same tests can be
> performed:
> 1) "mdio" without a compatible string. It should work without warnings.
> 2) "mdio" with a compatible string. It should work with a warning asking
> to remove the compatible string
> 3) "xxx" node with compatible string. It should work with an error
> asking to rename "xxx" to "mdio" and remove the compatible string. The
> switch will use polling instead of interruptions.
>
> This series might inspire other drivers as well. Currently, most dsa
> driver implements a custom slave mii, normally only defining a
> phy_{read,write} and loading properties from an "mdio" OF node. Since
> fe7324b932, dsa generic code can do all that if the mdio node is named
> "mdio".  I believe most drivers could simply drop their slave mii
> implementations and add phy_{read,write} to the dsa_switch_ops. For
> drivers that look for an "mdio-like" node using a compatible string, it
> might need some type of transition to let vendors update their OF tree.
>
> Regards,
>
> Luiz
>

I might have forgotten to add a new line after the subject. It ate the
first paragraph. I'm top-posting it.

Regards,

Luiz
