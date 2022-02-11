Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0584F4B2315
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 11:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbiBKK2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 05:28:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236403AbiBKK2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 05:28:43 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9D5E88
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 02:28:43 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id y129so23427627ybe.7
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 02:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ry9ycITC8oAUIhioPhktpO9Ofjd+lcNABWUsP0eruAA=;
        b=MQ5WRM0qZRe5F+qGf5Fo13VS4VI4PSfIXNHKI7vQXJJHC1NqUyN3mjZWIzdo/3SrXB
         EJMRnA2gMlwYFgcEYQhlYxxyxiCTYVMc4YpogJoeyr6ATb1XEhmDooPwSpdXRZQzmmR7
         MYaQiSh/RMrFN+1xAqKl1cDczPItxyzJEGQT/6VAVrzzOdAczA6rzIiO5Aj0Cldkqgtv
         fGH8HKLhoObC7VEreWR0zGIDfMRjiQHcnDCNX8Fb2X6wLcG6KlocQUbcDfNk3JcWw5k2
         NoA0RK4fGYAOiyw/LUOw2eRWjgmOa9HgAZ6rgNVliWvEVMAkR3SodRUH+d/aqgr84qmh
         N2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ry9ycITC8oAUIhioPhktpO9Ofjd+lcNABWUsP0eruAA=;
        b=f/WNdAHxfe4UCNxhmlaFu57HAQW12gfhf50QFq0DjZiPDmX35qw9SVdyqWzGdfFLPT
         rDfuJ2dV7PD0H4x318WcFIVO+3V7ZgaCgB3ewHLKspcd8js/JiUiAP4Aa/DYi7WYK5SF
         ymsOi9F7LTckPiEH6Q4Jstz6i6N6G0yHRbRZUB5TrUTPA+8T0qTB0D1poqeuS680OQXI
         MWnAif6zl+2JB07v1VdCNtpM/rbdqvkM+4V08HZIjV5PiHnNGDh6CQQbbufiEk8dLyZ2
         MYDcb2EMnpsjpz7Xo2o3q6vikwagO1lQ6PaMoMrwCxPUhVoL0rub2AsQQAiY0mdu98V8
         r+nA==
X-Gm-Message-State: AOAM533w9PcRGs2GtsQAj+0Y4w/inks5eP59Z+Y0cKiHcMOJ5DFNMKSS
        i8q5VInxTSA5D+gIoe2Aghndf6sywOW7a2vrU8qCgQ==
X-Google-Smtp-Source: ABdhPJw87S6dZQcEik5IJQ2AIqFqQU8EiTznfzofQZOI1zfmAh1j0SfmQ9XBgaSyQ05RaSPf2+0wAGHrWIiafaeQVzc=
X-Received: by 2002:a81:4402:: with SMTP id r2mr942092ywa.126.1644575322273;
 Fri, 11 Feb 2022 02:28:42 -0800 (PST)
MIME-Version: 1.0
References: <20220211051403.3952-1-luizluca@gmail.com>
In-Reply-To: <20220211051403.3952-1-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 11 Feb 2022 11:28:30 +0100
Message-ID: <CACRpkdYfNhENWBcDXxshT_AS4s_t+B4bequRPAUsz1m=T0HSCA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: realtek-mdio: reset before setup
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, ALSI@bang-olufsen.dk, arinc.unal@arinc9.com,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 6:14 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> Some devices, like the switch in Banana Pi BPI R64 only starts to answer
> after a HW reset. It is the same reset code from realtek-smi.
>
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Looks good to me!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
