Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416D766ADB8
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 21:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjANUgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 15:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjANUgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 15:36:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B404C25
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 12:36:09 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v13so1645956eda.11
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 12:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=denMZSjpsUYhDYO/9sYa7S6R8rMZMyvm8LMm0bMu6Sg=;
        b=eBxLqQf4wkJBxk0H0ASJZ9kgY4IOS0VVPiniDmnDJGBwO1BtkC0sVYSg7ulQhSLSmm
         e4E2ILwpAHnrgjJhNofA5GAsum8IaLUVVIe7LRrK6WwY0/JDpA8jRq6xgbm4XQpofXSD
         haFfeS215PbeMVNBB7oL1cA7MvPanySTLC/YZ5nDQOi9SnB1QNCCeYiXfHC9En088KQq
         JINwOoLW1k6LxV30yHlVhjXqbPIZ1nJ+y9VcfnXf29c1nsAbNYyS7Lbe8/9AzGpQksBQ
         /4QyUFC967+uRIUnKwIWVxXK4x6mqOQ6R5Eomiw8T01NDwTKA0kmvl32DPSnYDtiKtuP
         RuIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=denMZSjpsUYhDYO/9sYa7S6R8rMZMyvm8LMm0bMu6Sg=;
        b=o+hN286gZ+GVmDOOiuLMijcVTcENuvSn7fcX8ADkr2F3CWSqkdyUhP+XcXq6LR2zMD
         qkQ4py2VJCctKMFgGJzRYDi4d5ioC1Amsdo144GjHf5zkVTcj4Ha+3zFmHy+i+zDKFgX
         Vlza7r7rboiSMhAtlhSckEu5XLEB67R3l85mFHrzqyJ6fB4J/4S37v12UBCtJXhCW7s7
         DZGBgZcfZ0JjCq9ljklb+wloidR3qnbQnSssmzFBNM33VqivcBdgFMtjSAu5RvkTBGf4
         LPOgtAmnCkb+jf5JsEfRP+SsEVN+hsNNh2SzKVtaEoGrfKbSaMTms0i+u6/l6fgblw91
         O0qw==
X-Gm-Message-State: AFqh2kqJyCnGYXFG9quCP7m2+DAKzeAHvkacLxieBJ+SL4RaLVbRUgVL
        3NgsMG68mRVhk4UPC6v3Zhg=
X-Google-Smtp-Source: AMrXdXsX49VPyd7t9jtTy2NE/0LNwk0UVfQR6w2okJ6d9dWvtEp1E7rhfUpAGBC/UOzvW5YH2zVCZQ==
X-Received: by 2002:a05:6402:548b:b0:499:ed25:c9f9 with SMTP id fg11-20020a056402548b00b00499ed25c9f9mr13417822edb.27.1673728568111;
        Sat, 14 Jan 2023 12:36:08 -0800 (PST)
Received: from skbuf ([188.27.184.249])
        by smtp.gmail.com with ESMTPSA id w13-20020a170906184d00b00838e7e0354asm9814846eje.85.2023.01.14.12.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 12:36:07 -0800 (PST)
Date:   Sat, 14 Jan 2023 22:36:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: dsa: mv88e6xxx: Enable PTP receive for
 mv88e6390
Message-ID: <20230114203605.gyapleqtadgcumhk@skbuf>
References: <20230113151258.196828-1-kurt@linutronix.de>
 <20230113151258.196828-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113151258.196828-1-kurt@linutronix.de>
 <20230113151258.196828-1-kurt@linutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 04:12:58PM +0100, Kurt Kanzenbach wrote:
> The switch receives management traffic such as STP and LLDP. However, PTP
> messages are not received, only transmitted.
> 
> Ideally, the switch would trap all PTP messages to the management CPU. This
> particular switch has a PTP block which identifies PTP messages and traps them
> to a dedicated port. There is a register to program this destination. This is
> not used at the moment.
> 
> Therefore, program it to the same port as the MGMT traffic is trapped to. This
> allows to receive PTP messages as soon as timestamping is enabled.
> 
> In addition, the datasheet mentions that this register is not valid e.g., for
> 6190 variants. So, add a new PTP operation which is added for the 6390 and 6290
> devices.
> 
> Tested simply like this on Marvell 88E6390, revision 1:
> 
> |/ # ptp4l -2 -i lan4 --tx_timestamp_timeout=40 -m
> |[...]
> |ptp4l[147.450]: master offset         56 s2 freq   +1262 path delay       413
> |ptp4l[148.450]: master offset         22 s2 freq   +1244 path delay       434
> |ptp4l[149.450]: master offset          5 s2 freq   +1234 path delay       446
> |ptp4l[150.451]: master offset          3 s2 freq   +1233 path delay       451
> |ptp4l[151.451]: master offset          1 s2 freq   +1232 path delay       451
> |ptp4l[152.451]: master offset         -3 s2 freq   +1229 path delay       451
> |ptp4l[153.451]: master offset          9 s2 freq   +1240 path delay       451
> 
> Link: https://lore.kernel.org/r/CAFSKS=PJBpvtRJxrR4sG1hyxpnUnQpiHg4SrUNzAhkWnyt9ivg@mail.gmail.com
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Tested-by: Vladimir Oltean <olteanv@gmail.com>

Thanks!
