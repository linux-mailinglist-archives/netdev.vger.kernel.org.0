Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA0B4EFEBE
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 07:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238343AbiDBFCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 01:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiDBFC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 01:02:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FA717665D;
        Fri,  1 Apr 2022 22:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 664EA60B8D;
        Sat,  2 Apr 2022 05:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBFDC34112;
        Sat,  2 Apr 2022 05:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648875636;
        bh=Hz7kYmvNHLmUo+Fbdi0YWMcptfDXOGSuYlcfxuUkStc=;
        h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
        b=lU0hiw/4HgFogs4Ag8R004CYeWmnJbioSL+0u13uzyw6ZsGgrruW/dybMTuqMZkmg
         jmuLe0dIwFkdsYNbfryNalUZBA3dAa9ELbzvCHftsOKfQQGOH7xuaqlwNGZ0ewuIn/
         Hb062xB37iPEQ63gB3HAEw3rqfRM3XZEziVXjAdrrgkwv0qfsGIBxLlCbb1g8QRaQZ
         5cv3J4Hio5BlMUQ0FAQFxRIrILLqp/5kfKVU1/jp34lqIVuMWzGFldTxPawcUvvCET
         hRJeH2Qz/YLGTeDTDomGhJNzeVSdlynNIyIWbCrvUtxg6WHfKhI0HHzoKgofa9t+lx
         32pqv/RITubDA==
Received: by mail-vs1-f54.google.com with SMTP id i10so4483142vsr.6;
        Fri, 01 Apr 2022 22:00:36 -0700 (PDT)
X-Gm-Message-State: AOAM532HSIwI/AikuvPYcJ+yX49OB13HL9G/FUyUVlNtu5cDuXrL1IjC
        98SJ8xqOsQNXp3Zuc6YCD6N9Q+KFycGJggT6FaA=
X-Google-Smtp-Source: ABdhPJycmGstAuCXAQsD2Nsc99K3qy+1EqIeB5p1HI2zgeQm3shBqWqwPW/yuzIYB8e5JHRRSrZwLuoSs2Jc5fvfGlc=
X-Received: by 2002:a67:c383:0:b0:327:2c5:d483 with SMTP id
 s3-20020a67c383000000b0032702c5d483mr1957242vsj.42.1648875635613; Fri, 01 Apr
 2022 22:00:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220331184832.16316-1-wens@kernel.org> <20220401214158.7346bd62@kernel.org>
In-Reply-To: <20220401214158.7346bd62@kernel.org>
Reply-To: wens@kernel.org
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Sat, 2 Apr 2022 13:00:36 +0800
X-Gmail-Original-Message-ID: <CAGb2v647CqCbd4ZK7OpbG0YihUjviUB-4cM4P5g0LFuQJbzoSA@mail.gmail.com>
Message-ID: <CAGb2v647CqCbd4ZK7OpbG0YihUjviUB-4cM4P5g0LFuQJbzoSA@mail.gmail.com>
Subject: Re: [PATCH RESEND2] net: stmmac: Fix unset max_speed difference
 between DT and non-DT platforms
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
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

On Sat, Apr 2, 2022 at 12:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  1 Apr 2022 02:48:32 +0800 Chen-Yu Tsai wrote:
> > From: Chen-Yu Tsai <wens@csie.org>
> >
> > In commit 9cbadf094d9d ("net: stmmac: support max-speed device tree
> > property"), when DT platforms don't set "max-speed", max_speed is set to
> > -1; for non-DT platforms, it stays the default 0.
> >
> > Prior to commit eeef2f6b9f6e ("net: stmmac: Start adding phylink support"),
> > the check for a valid max_speed setting was to check if it was greater
> > than zero. This commit got it right, but subsequent patches just checked
> > for non-zero, which is incorrect for DT platforms.
> >
> > In commit 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
> > the conversion switched completely to checking for non-zero value as a
> > valid value, which caused 1000base-T to stop getting advertised by
> > default.
> >
> > Instead of trying to fix all the checks, simply leave max_speed alone if
> > DT property parsing fails.
> >
> > Fixes: 9cbadf094d9d ("net: stmmac: support max-speed device tree property")
> > Fixes: 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
> > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >
> > Resend2: CC Srinivas at Linaro instead of ST. Collected Russell's ack.
> > Resend: added Srinivas (author of first fixed commit) to CC list.
> >
> > This was first noticed on ROC-RK3399-PC, and also observed on ROC-RK3328-CC.
> > The fix was tested on ROC-RK3328-CC and Libre Computer ALL-H5-ALL-CC.
>
> This patch got marked Changes Requested in pw, but I can't see why,
> so I went on a limb and applied it. LMK if that was a mistake,
> otherwise its commit c21cabb0fd0b ("net: stmmac: Fix unset max_speed
> difference between DT and non-DT platforms") in net.

I don't remember anyone asking for any changes.

Thanks
ChenYu
