Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0053620147
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiKGVgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiKGVgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:36:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069E5DA2;
        Mon,  7 Nov 2022 13:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC264B816AA;
        Mon,  7 Nov 2022 21:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FE5C4347C;
        Mon,  7 Nov 2022 21:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667856987;
        bh=fhSLuMFsDIXZTyGC5V/74ol9l/TQbCSvyukyKs6zDLc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XYph1WMMA0b9TxY1XmamRAgMiZDX4dLtn7hlfCKqpr3XgUBYDHlxOJu5tzbZiEf9Y
         U+96SdOLqUCJFqv6A8z6qROTM33UhGOUo5p92cR7qCtqNhXHVpbCfbU4yRdGT0YhjD
         gw40/B8OC7NooL9jk2Ku/1sFERozCmCtQxctalXbpNNPrNNhGp1IBLIgUKgUtTL7Qi
         wS5ZBKhi6TeGSf1dMV8MXL2vbUoeoMVrHPVK4dpW7GqsZ/yXXi82+xbG0bKXqmxpDA
         wjamJsKLQItFyM9z/jaJZ3PwvS2UE4bZdleN3Dg2S25L1raAXnC4xokiShLpqgBmw6
         gy93X/gjYHK6w==
Received: by mail-lj1-f174.google.com with SMTP id d3so18332255ljl.1;
        Mon, 07 Nov 2022 13:36:27 -0800 (PST)
X-Gm-Message-State: ACrzQf2troSyCfQhGD+fkLs26g7Aj66qLilSWWPTxrFZorZoJj86n0S5
        GCzG1TOMd/8EqFaoa4WsZSzp9KHVBMxr2tuudQ==
X-Google-Smtp-Source: AMsMyM4tx5YQl80AevtfnGWbnhBrN3sG0NTkgJ6voYrQpSySVeZNzfrLe4SOOGqRrTLPdBUeWEHVGVZ4kM920ag340Y=
X-Received: by 2002:a05:651c:114a:b0:25d:5ae6:42a4 with SMTP id
 h10-20020a05651c114a00b0025d5ae642a4mr18168309ljo.255.1667856985359; Mon, 07
 Nov 2022 13:36:25 -0800 (PST)
MIME-Version: 1.0
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221103210650.2325784-9-sean.anderson@seco.com> <20221107201010.GA1525628-robh@kernel.org>
 <20221107202223.ihdk4ubbqpro5w5y@skbuf> <7caf2d6a-3be9-4261-9e92-db55fe161f7e@seco.com>
In-Reply-To: <7caf2d6a-3be9-4261-9e92-db55fe161f7e@seco.com>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 7 Nov 2022 15:36:16 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKw=1iP6KUj=c6stgCMo7V6hGO9iB+MgixA5tiackeNnA@mail.gmail.com>
Message-ID: <CAL_JsqKw=1iP6KUj=c6stgCMo7V6hGO9iB+MgixA5tiackeNnA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 08/11] of: property: Add device link support
 for PCS
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 7, 2022 at 2:50 PM Sean Anderson <sean.anderson@seco.com> wrote:
>
> On 11/7/22 15:22, Vladimir Oltean wrote:
> > On Mon, Nov 07, 2022 at 02:10:10PM -0600, Rob Herring wrote:
> >> On Thu, Nov 03, 2022 at 05:06:47PM -0400, Sean Anderson wrote:
> >> > This adds device link support for PCS devices. Both the recommended
> >> > pcs-handle and the deprecated pcsphy-handle properties are supported.
> >> > This should provide better probe ordering.
> >> >
> >> > Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> >> > ---
> >> >
> >> > (no changes since v1)
> >> >
> >> >  drivers/of/property.c | 4 ++++
> >> >  1 file changed, 4 insertions(+)
> >>
> >> Seems like no dependency on the rest of the series, so I can take this
> >> patch?
> >
> > Is fw_devlink well-behaved these days, so as to not break (forever defer)
> > the probing of the device having the pcs-handle, if no driver probed on
> > the referenced PCS? Because the latter is what will happen if no one
> > picks up Sean's patches to probe PCS devices in the usual device model
> > way, I think.
>
> Last time [1], Saravana suggested to move this to the end of the series to
> avoid such problems. FWIW, I just tried booting a LS1046A with the
> following patches applied
>
> 01/11 (compatibles) 05/11 (device) 08/11 (link) 09/11 (consumer)
> =================== ============== ============ ================
> Y                   N              Y            N
> Y                   Y              Y            Y
> Y                   Y              Y            N
> N                   Y              Y            N
> N                   N              Y            N
>
> and all interfaces probed each time. So maybe it is safe to pick
> this patch.

Maybe? Just take it with the rest of the series.

Acked-by: Rob Herring <robh@kernel.org>
