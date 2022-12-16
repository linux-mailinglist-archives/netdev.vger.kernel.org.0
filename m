Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B38664F42A
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 23:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLPWcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 17:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiLPWcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 17:32:23 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45A110063
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 14:32:21 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id n4so3706408plp.1
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 14:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PohvDG4yvRSuWoQOX7llLlU0hZEwFC/v0T6w+21Ixrc=;
        b=V89aypgqPm0an4Ps9lm9Vu52+zsr9PFnfZmSfSVn7OHhzQd8zr+HCbHb2vsPfTtelH
         0JUEU7Zpg3y59KWH/dvz2ZglNHoY8fJtIaYhz0dXR9ZOKecGFSN8/utLZutX5ZDWG2V5
         ZpLETJIInb0PeQ2RxO+2xNCni652AfMrZEED8DoI7Wwk+cms1r9YFgvx8h0N3rwFnOsr
         Ov7WQdV+gcLXInbulTB850akNd65zbEn9cFJso25bjN0edm44ycV9ZjpnwKZ81fDeuPx
         aHzs88ifTwXYeGsGVsW7wtlm6vlSvvDDBGerfrIWyhQXUYXmftqUEKNPatXWJmHQ2oIn
         OR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PohvDG4yvRSuWoQOX7llLlU0hZEwFC/v0T6w+21Ixrc=;
        b=Zn64duyD+wWIO7wpn7HBFEH6Qrz0m42sdqwYH6sljJHCj+RFeBfJcalG7dPHef9aid
         +QqP0SpIJPGAqD1Us1ypSgu2YkUoLdDlAVZ3OJWNrGiDxKON3aCnp1URjjOPk2Zxftjw
         tdvaIkQZ+Bbwi0ZQP1P5ZHL8MSSjjpnDj8FT/Q250Oh/vkNTXPGnw8AuS4HimN0Lsaae
         Bun8WYH7DQ0g4ywcWI2lNdJed9gUKApBJ5OJ2T5VUilbEZMFKkA7xlbUumum52TFJGga
         actjbUBiswZlxM44GT176xJKxnJRrSSx+zf5YCUZOlSWPb2sDATq8pu7aksbUIF5t051
         iysA==
X-Gm-Message-State: ANoB5pmMWT3J3njZgcfPhidPsxDJuXWSYjDiLSArUMxl0wHrj+cTG8U4
        ZjL2Bt4jEwa99lmW2MGqtEg=
X-Google-Smtp-Source: AA0mqf72A8juWY0uKad1H3iS0o/0PXtwgqsZbfS2lwu0mjT7C0GHlKzTm46UFFMf2YCFvpZ4KAKVpw==
X-Received: by 2002:a17:902:ab8d:b0:187:467f:c76c with SMTP id f13-20020a170902ab8d00b00187467fc76cmr30501556plr.51.1671229941038;
        Fri, 16 Dec 2022 14:32:21 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:211:6b31:5f6:6aef])
        by smtp.gmail.com with ESMTPSA id t11-20020a170902e84b00b00183e2a96414sm2116753plg.121.2022.12.16.14.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 14:32:19 -0800 (PST)
Date:   Fri, 16 Dec 2022 14:32:16 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Marek Vasut <marex@denx.de>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Geoff Levand <geoff@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@nvidia.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: Re: [PATCH] net: ks8851: Drop IRQ threading
Message-ID: <Y5zx8F508bzyy32A@google.com>
References: <20221216124731.122459-1-marex@denx.de>
 <CANn89i+08T_1pDZ-FWikarVq=5q4MVAx=+mRkSqeinfb10OdOg@mail.gmail.com>
 <Y5zpMILXRnW2+dBU@google.com>
 <7a50a241-0a93-3e44-bcc7-b9e07c62d616@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a50a241-0a93-3e44-bcc7-b9e07c62d616@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 11:19:27PM +0100, Marek Vasut wrote:
> On 12/16/22 22:54, Dmitry Torokhov wrote:
> > On Fri, Dec 16, 2022 at 02:23:04PM +0100, Eric Dumazet wrote:
> > > On Fri, Dec 16, 2022 at 1:47 PM Marek Vasut <marex@denx.de> wrote:
> > > > 
> > > > Request non-threaded IRQ in the KSZ8851 driver, this fixes the following warning:
> > > > "
> > > > NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
> > > 
> > > This changelog is a bit terse.
> > > 
> > > Why can other drivers use request_threaded_irq(), but not this one ?
> > 
> > This one actually *has* to use threading, as (as far as I can see) the
> > "lock" that is being taken in ks8851_irq for the SPI variant of the
> > device is actually a mutex, so we have to be able to sleep in the
> > interrupt handler...
> 
> So maybe we should use threaded one for the SPI variant and non-threaded one
> for the Parallel bus variant ?

I do not think the threading itself is the issue. I did a quick search
and "Non-RCU local softirq work is pending" seems to be a somewhat
common issue in network drivers. I think you should follow for example
thread in https://lore.kernel.org/all/87y28b9nyn.ffs@tglx/t/ and collect
the trace data and bug tglx and Paul. I see you are even on CC in that
thread...

Thanks.

-- 
Dmitry
