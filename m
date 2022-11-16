Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412ED62B833
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 11:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbiKPK2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 05:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbiKPK1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 05:27:54 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CEB2FC27;
        Wed, 16 Nov 2022 02:24:11 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id l11so25885228edb.4;
        Wed, 16 Nov 2022 02:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PQq+ctW/0bZAq1CHRzdd9OvAL7Rb6nTx8X5mbJS1Hbo=;
        b=DHdB+5apex3J+Qxj5yb1BsHt6mPvVuSBotXfJ/VLRqaPY3TdXNW2R8wsVeEUiOpOLN
         H9I/JPVTDvzfAFSd5V/Aa8mHzhExqsvJeliV+IF7Apfv8Lo4O22xjHYepmevAyg6yaYr
         crG4KDitiHVhvhe8iOQ0mxC8+1/hqOIqG3ohLCef4K/UXpHdVhNUGvVciPWGu7CA3PCH
         edR/LLSk4nRvnyIaz8Mru/zr9lfEwnaLHUPv5n6CM7x7WWNEN/Knp4kNcufIxyHTBBAY
         axTd25n2e8Yh8rW85pFF/wchH22++gXfrLumVw6inS0Re2rCKJGi5ODRx2vg+TJr6e78
         Kq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQq+ctW/0bZAq1CHRzdd9OvAL7Rb6nTx8X5mbJS1Hbo=;
        b=jwOChoTQ8zR7y97rpAxOTcAvvq3YW/YoVJA+bK/rWcqLhsrDgTj8JtqgKmqbmb4Dz1
         1OMSU0Ml106MMMTua8mm5seK/TuZmFyifv2nUjQNwc22UKZFpNDESzsiCpmQYcaE+wGd
         yAVa3SmA16Kv5YZHlcelGLwnHcH7LBPr1D9zQb0eqehax0KT/tOIH3ju5w74suH88fyQ
         zuWriZ2yQ7LOapg4QcwKJUoLbPzboGkRtAOHrin/CJx1b6lq5ktO8pFabIK6JoAQOIQV
         FToR8ZEvRgCH+vp1Vnsz8BU4cATZaX55e+VHr7O+JEvIE9ZRdyv8hpMWZGeuOqlKPN0t
         dWZg==
X-Gm-Message-State: ANoB5pkypDR3GIDbuQCF2AC+ziZum+EG8JsAUgiSdlnU9c7Gqn6XWXt3
        3K8mkO9MxlbqBltJC9OdbhY=
X-Google-Smtp-Source: AA0mqf5JFuPzShCJ2pt2pSUwXaZLJwzHOgJnyzEWATdF4+flfGnHxI44oBBY2lNCS3pD8CuMyyZBPg==
X-Received: by 2002:aa7:c691:0:b0:456:7669:219b with SMTP id n17-20020aa7c691000000b004567669219bmr19463966edq.221.1668594250319;
        Wed, 16 Nov 2022 02:24:10 -0800 (PST)
Received: from skbuf ([188.26.57.53])
        by smtp.gmail.com with ESMTPSA id ay26-20020a056402203a00b00461816beef9sm7246517edb.14.2022.11.16.02.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 02:24:09 -0800 (PST)
Date:   Wed, 16 Nov 2022 12:24:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <20221116102406.gg6h7gvkx55f2ojj@skbuf>
References: <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
 <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
 <20221115145650.gs7crhkidbq5ko6v@skbuf>
 <f229503b98d772c936f1fc8ca826a14f@kapio-technology.com>
 <20221115161846.2st2kjxylfvlncib@skbuf>
 <e05f69915a2522fc1e9854194afcc87b@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e05f69915a2522fc1e9854194afcc87b@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 07:40:02PM +0100, netdev@kapio-technology.com wrote:
> So, I will not present you with a graph as it is a tedious process (probably
> it is some descending gaussian curve wrt timeout occurring).
> 
> But 100ms fails, 125 I had 1 port fail, at 140, 150  and 180 I saw timeouts
> resulting in fdb add fails, like (and occasional port fail):
> 
> mv88e6085 1002b000.ethernet-1:04: Timeout while waiting for switch
> mv88e6085 1002b000.ethernet-1:04: port 0 failed to add be:7c:96:06:9f:09 vid
> 1 to fdb: -110
> 
> At around 200 ms it looks like it is getting stable (like 5 runs, no
> problems).
> 
> So with the gaussian curve tail whipping ones behind (risque of failure) it
> might need to be like 300 ms in my case... :-)

Pick a value that is high enough to be reliable and submit a patch to
"net" where you present the evidence for it (top-level MDIO controller,
SoC, switch, kernel). I don't believe there's much to read into. A large
timeout shouldn't have a negative effect on the MDIO performance,
because it just determines how long it takes until the kernel declares
it dead, rather than how long it takes for transactions to actually take
place.
