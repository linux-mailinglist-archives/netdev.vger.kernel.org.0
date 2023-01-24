Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB1F679D1A
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 16:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbjAXPOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 10:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjAXPOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 10:14:20 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FAC1F496
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 07:14:15 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e10so11469654pgc.9
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 07:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0BgZdct8WsHi5er05cQbLra8sZHOlBMI2c5tJhe+cgo=;
        b=Nznpdgtbiz7aQPltqcD/BzGf44er9/CqARoLzsV5ayVynwSOLohLoyIXDL97156xZ0
         no2CFvZDNLl3Cpkbmb7NNb9zsPouW+sr1T8epQCDFYUtx/ttFoCMDoMVI3I1O18MR72t
         WNCDKZ+ymQ4fz928y2X3gL1MiWe1l6kBG7VDXmUIUmajzgscvY+ifDsGFi945bOwq8zL
         fCnolK79fjd6Ok++zSUlJ2B7qMCo/kD3wjf2Y83Yw//mgK7Dm/hH06TjVcyZSBFwuhoF
         5YbYrntd+4liUa6zBdMisWC3fy57vkGiVFDpPOw68q5weh5jez6bacyiKDS/oZbCGzwV
         FiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0BgZdct8WsHi5er05cQbLra8sZHOlBMI2c5tJhe+cgo=;
        b=SpUCnE++kOqg1oqa2OBpMXet9JUCtyEE6Voy9EUUnqSkPA+KVssCFfd+s1iqpFnJOa
         cz/i5Np7hjR803IqIerRAm9x/IWtekjyn4AVJPnKdLKiWZsaExxQ8O+mRioDaF02p7Bp
         lR4vNgmTES0s8qD0Ah7sVj983Y3wpkGlCEx2uJ+utTIFru/rTJMc2OAgIo971DtPr1Wu
         5L5NPobgFcQhN8BJ4FouBmQqbih9wGWrZmAZLuPXDckdrxOpHlxNSNNiJZIxhQJWqpB+
         XVJcfuqMt9ofqnKVAzCvvoAIE03ELjuCFx040roRZRGbbYewY8QyTmEkv+Utpc1+Gr9v
         7PSQ==
X-Gm-Message-State: AFqh2kozMuwSTjAQt3wsG+7nk+/L6cG0tkgqvlK31eLGZ29EYh94tK4R
        tPQaeU194vfiXPSm8aiclj7nTIDkcW8eJJ+PJY0YUsLfwiI=
X-Google-Smtp-Source: AMrXdXtiRnC9WTOCQAV3c/H9nlcmy6HJIM/WUpw+Qkl1hTPRKbHcID+2vM5c9wk0DOb8FLSYwI+0eaLdxS85xu9vp6E=
X-Received: by 2002:aa7:855a:0:b0:58b:c74b:cb61 with SMTP id
 y26-20020aa7855a000000b0058bc74bcb61mr2777978pfn.14.1674573254569; Tue, 24
 Jan 2023 07:14:14 -0800 (PST)
MIME-Version: 1.0
From:   Aleksander Dutkowski <adutkowski@gmail.com>
Date:   Tue, 24 Jan 2023 16:14:03 +0100
Message-ID: <CABkKHSZV7OmkNnkZRi7dF=-_bJK9i4p_8XLdV_Zd0=Z_O8Jf6A@mail.gmail.com>
Subject: possible macvlan packet loss
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

we are experiencing something, that seems to be packet loss on macvlan
interface.
Input is ~350Mbps of multicasts, scattered over 120 docker containers,
each having macvlan on top of the same mellanox 10G NIC. Each of
macvlans have bcqueuelen set to INT_MAX.
Streams recorded from phys interface have all packets, whereas streams
recorded from macvlan have drops.

I wonder what is the best way to test and measure the queue fulfillment?
We can do simple printf when the queue is full, but maybe there are
some tools or techniques I'm not aware of that we can use?

Thanks
Alex
