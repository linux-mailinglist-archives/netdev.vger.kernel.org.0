Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2ED4CE70B
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 21:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbiCEUuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 15:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiCEUuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 15:50:08 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819644BBBC;
        Sat,  5 Mar 2022 12:49:17 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id h13so2766632ede.5;
        Sat, 05 Mar 2022 12:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ROeeCFTcB1IMZYAjnJop7c/9sfjisskLwhKEZn4mPfI=;
        b=IZiwDljnfwGfoLRDt0GvXc49mEkThmQg4uJAVhd5xkw2kc33qWaBA8T+7NRNkOSIQk
         sBKm3jYcpmMmIvWxOe0zLjjCGUmwHQw2KMt2qISN86oXCLtHbw3vgSKRG42HqB7lHRyu
         k7cZTXxdqYP9hOgxnNQNqo3TvBo9l2wiIcfj2GO37bfvhABGzUdN/CEhwe9wryZrp0ry
         AobIHz6l/qLsHwQoJWXCo12woeCDiN56h8lw6iW1vazHkbkQsj8+wkSoros/WgO1yPAQ
         SoIhb+rVvqCjAuT/LYZBEH6MCF9OzH9hN2rtHmAKkY6m0nhrzZiEx2N7MtmCJTscPR0K
         F5Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ROeeCFTcB1IMZYAjnJop7c/9sfjisskLwhKEZn4mPfI=;
        b=rxHUiZmPdkrIUvnFV+6FiHXeYSI05DcPd3JMJHhS0NeaUMWzp/2t0CIQtVRbTFctxC
         m31AcCgr+7lwDMSs3WyT4fulRoX6gxOQeL2oY1LjZOcdrDQWJa86HaNGdIrLYTlOE8C1
         fuudHQG25t2bhyVt4xCAnv45nZQNrAnDxdluQjVxJEThELYcoIwN6Oz6MNlajp3FuzbF
         1RnBhAeO8IszaCCvvw6/hNS+kGCgV76pnlPXu0esDB2ubyVtJuxOfM0WJpCAl89nFp9F
         zlAR4ZNN5hr2jHNFuCjUCjGNiXFkZ3AR0/G0/4ZPyveeOiP46cxsBrtilLGzb1FSYLFl
         RCYQ==
X-Gm-Message-State: AOAM532gaGVL8y1fioeeHDBFtMih/+oGoaT5KUVm5PxbWEyC/2KrfoJz
        MGxkGm1hRaZmosnAWzTHB2lzFGewQJ1nbu7GVMA=
X-Google-Smtp-Source: ABdhPJyCA5D0XG70qR3ycdNeGI/egchPmgY+gaZCRQbsSkh7emuCLiyEUM+a9B/yVaFbiTqlhK7tDhETFZRzbpERMSU=
X-Received: by 2002:aa7:d505:0:b0:415:9f06:d4f5 with SMTP id
 y5-20020aa7d505000000b004159f06d4f5mr4377788edq.305.1646513355914; Sat, 05
 Mar 2022 12:49:15 -0800 (PST)
MIME-Version: 1.0
References: <20220305184503.2954013-1-festevam@gmail.com> <YiO5Ayetj9aCRkmR@lunn.ch>
In-Reply-To: <YiO5Ayetj9aCRkmR@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 5 Mar 2022 17:49:03 -0300
Message-ID: <CAOMZO5Dvp-Fqad-snXC79E30rpROQtUygPJ-a5awjBdXVaRrhg@mail.gmail.com>
Subject: Re: [PATCH] smsc95xx: Ignore -ENODEV errors when device is unplugged
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, fntoth@gmail.com,
        Martyn Welch <martyn.welch@collabora.com>,
        netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
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

Hi Andrew,

On Sat, Mar 5, 2022 at 4:24 PM Andrew Lunn <andrew@lunn.ch> wrote:

> Please indicate what tree this patch is actually for. It should be
> against net, since you want it backporting. Please see the netdev FAQ.
> Please also include a Fixes: tag.

Thanks for your review. Fixed in v2.

> I suspect this will result in kasan warnings. The contents of buf is
> probably undefined because of the error, yet you continue to set *data
> to it. You probably need to explicitly handle the ENODEV case setting
> *data to some value.

Good catch. Fixed in v2.

Thanks
