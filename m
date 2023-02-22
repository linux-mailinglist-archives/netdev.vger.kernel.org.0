Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC7569F74E
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 16:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjBVPCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 10:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjBVPCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 10:02:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D8638E8D;
        Wed, 22 Feb 2023 07:02:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E05E61494;
        Wed, 22 Feb 2023 15:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA16C433D2;
        Wed, 22 Feb 2023 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677078133;
        bh=WXJJwxDpfuNfynwusS+lCOBN45tortTJC870IL8d2ig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cr2uXw76lSK/J7NLlNVll4olMCTR5jTEnNiTh5PDAjgt+Fw+Jk7I+Z1j1SaL9g7M4
         CX2F8EU0Kv89ZiRd+KIDJBec6syLpqRn8PLnVpoBgdZ6DvVpvNhy3YFkOXhd/Pqaba
         TdDP0G/UwAQnXUmJbNO+hswMp4u7F+jOVN4B07YHy0VsNQVE4mI/sN/X7BtxLepuI5
         OItGzvso7HqCPj1mPUcsn29HXKqfW5WpdxhoR/C2cFkiQVOoOGk7Szt/t7VofImj1M
         y0L9fCTRIUUHattoRRdZd3MSKYbVeD9kXJLZIHXzNtRWALvxQ2lEVwTMsdjYG5Rp62
         qm2GvVjrnuQTw==
Date:   Wed, 22 Feb 2023 15:02:04 +0000
From:   Lee Jones <lee@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v8 00/13] Adds support for PHY LEDs with offload triggers
Message-ID: <Y/YubNUBvQ5fBjtG@google.com>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <Y++PdVq+DlzdotMq@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y++PdVq+DlzdotMq@lunn.ch>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Feb 2023, Andrew Lunn wrote:

> On Thu, Feb 16, 2023 at 02:32:17AM +0100, Christian Marangi wrote:
> > This is another attempt on adding this feature on LEDs, hoping this is
> > the right time and someone finally notice this.
> 
> Hi Christian
> 
> Thanks for keeping working on this.
> 
> I want to review it, and maybe implement LED support in a PHY
> driver. But i'm busy with reworking EEE at the moment.
> 
> The merge window is about to open, so patches are not going to be
> accepted for the next two weeks. So i will take a look within that
> time and give you feedback.

Thanks Andrew.  If Pavel is still unavailable to conduct reviews, I'm
going to need all the help I can get with complex submissions such as
these.

-- 
Lee Jones [李琼斯]
