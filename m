Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E85644185
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiLFKse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiLFKsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:48:32 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAB3225;
        Tue,  6 Dec 2022 02:48:31 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id d14so14736185edj.11;
        Tue, 06 Dec 2022 02:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4SaDoYpKy8Pz2qitUMQLvwrZeZcLwL+BKMR9jLZDlo0=;
        b=aH1DdEhqSjTxFKkR5p4zfb7+pyTWa0UMQ3qeWnmhVYS9Sun9eI7yxGNxRwg4HLocdQ
         79yW7eaEA6X+IxPLbqOvJYpltwZIpTXznWkU5i58Crgq5D1eovHbc60MNyCL0glfFBA6
         q/3JMv8ZGaJAqqBe4Su5sN2b37sdphSCLlgJDzT65JVVRjFibwXCRgz4CZtlibp/x27W
         orYcgMZ0lguiPAPfk3YZnTp6AMPkIlBGQyZCRNBEqqF5tzPmO2aRKfXGeVWHXK8g+DmP
         MyGuzxwFpfyjfrmSmcSrMSElBOZ5M/CVA2N9Cme/YI3XBbsk5/jFQs5E/r889KZxlm1H
         OdkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4SaDoYpKy8Pz2qitUMQLvwrZeZcLwL+BKMR9jLZDlo0=;
        b=UHk6L+wcPRc3m85Z4DnVCJ47GhDXbQlUchYgg5HY2/RwoW+n7kTl6oZmOOlfUIthnG
         gqF3diepAeS5leO+aQzt255CNJZM/ellITkErrxqdfgiLp0oQiKTGQgHt2yepHglkuCU
         4IDT+DdHnUuoD/UEWVEjMES4BsWLJd2gy2moyOrA8nLj0x5lWQcWzN46abB530xaiovN
         nZ5DruvUjsWunm/b6ymi+H/kkdjq6wZodgIrk8CU6F+oMnGTuMUagefi+JqD+luPpoxz
         sPQeG9SkZoxevFyR7lPzYZVEphh81SnfHXp4Vh07TKfTBywAS7rJixi1jtqPelLGKvzm
         iBFg==
X-Gm-Message-State: ANoB5pnfMtA1vk6OOqNyIM7A/GdPWdhWVSahawHGowGWxo1v47tUMiat
        V4Mb6O42DuKtQJjQe6yAbzp9F6fgC+o0NQ==
X-Google-Smtp-Source: AA0mqf5QpqtVzqcm5qwpNii1uiuSPOCxFEfHLFQf8AsZhcmqhbT37+fc7Ze7o9yhBwRiiDG9sHZcjQ==
X-Received: by 2002:aa7:db18:0:b0:46c:304d:843f with SMTP id t24-20020aa7db18000000b0046c304d843fmr15338214eds.231.1670323709986;
        Tue, 06 Dec 2022 02:48:29 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id va11-20020a17090711cb00b007c0f45ad6bcsm2300366ejb.109.2022.12.06.02.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 02:48:29 -0800 (PST)
Date:   Tue, 6 Dec 2022 12:48:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com
Subject: Re: [Patch net-next v2 01/13] net: dsa: microchip: ptp: add the
 posix clock support
Message-ID: <20221206104827.corkkthxmypegja7@skbuf>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
 <20221206091428.28285-2-arun.ramadoss@microchip.com>
 <5892889.lOV4Wx5bFT@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5892889.lOV4Wx5bFT@n95hx1g2>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 11:37:26AM +0100, Christian Eggers wrote:
> > v1 -> v2
> > - Deleted setting 8021_1as bit and added P2P bit in ksz_ptp_clock_register()
> 
> did I miss the discussion about this change? I thought that the first goal is
> to use KSZ switches as a boundary clock which implies using the 802.1AS feature.
> 
> Using the KSZ in P2P transparent clock mode IMHO requires writing the peer delays
> into switch registers (which needs to be implemented in a companion 
> application/script for ptp4p).
> 
> As far as I remember, there is also no support using ptp4l with 1-step transparent
> clock switches.

If it was in response to something I said, I just asked to add a comment
as to what the 802.1AS bit does, not to delete it...
