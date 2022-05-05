Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E5C51C525
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381997AbiEEQeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381473AbiEEQeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:34:19 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E82A4B1D4;
        Thu,  5 May 2022 09:30:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ks9so3342073ejb.2;
        Thu, 05 May 2022 09:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uWtgKKcajdz2BPJdKiwyTVbFB4omDy6DEJqy2lfeeqQ=;
        b=hkFRRzh9WGqFiiEo6JXUDGQShvw+35UMlB1e48yZYL74nqgUp4F6N77zk7wy8fwGMU
         06gFBKaka/bekg+u6rGJY15zZi/8VlqzmcSCYNaGOrOtq0oV/JXDW6JD4LtozAcAALg8
         6qXMWhUo8xw2085Ytqj/3ds32GixLQVZc4r8skTAnJqkj/+4e86l3CYAvy6uD3IOmV+5
         Op+yFcEdOAoC35xx+rXa7keTNiLNOij2so3hiiC5JjTPe4BX5aq5DUD4xq6QXJ2L/zdF
         G2y7yJPWVfmKQyjc1VxIS/CiM8Pd/FHPehthhPo8THoNvaozDKUKPEsxX2wz/hkkXxl6
         /bTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uWtgKKcajdz2BPJdKiwyTVbFB4omDy6DEJqy2lfeeqQ=;
        b=OpS95CFFU3xG2zwkup0W83jtk+jE1ZpLQsdttDJeVfaaV9u7H3pdXaA/j5Yq3kTyO9
         YiHo4lfp2sI2WlFhMyQY9HlDvtP0QgkbWxNp0t3ky9fYSM1tAg+scnXtXWoaz4+S9MiK
         YKKWWf+zkvz55YLSyrLjQM32R1+nuf2sSD2Ghl3pl0LoK+IUdNYYUw4A5oQ8oOWBsfGf
         z3dQBlOkE3EvnGXeUQVRQvlxawKuTRj577anpO0uX+H+27aiGGqNi96Qa4b8X/Hzk1JL
         1+NKJL8L/nOD1c2hqsHO2Os9KZVavlG++OT+Eq0Ca4z/17D/d5EZJnekGZ3mvM6K8NFk
         naYw==
X-Gm-Message-State: AOAM531sdOXCyUm9kAVh3Wusix60KnyhY4D4+7AbPl+FKfnhpRS/vq13
        IfWcPaO4G0CCcedBpL6aW/k=
X-Google-Smtp-Source: ABdhPJwBr27HFxzPJMx0nDaKSh9v9aTcDqMdXyURyBRGkHhqFvQBwM7hybPN+cL10Oaq1xuUGtuyfw==
X-Received: by 2002:a17:906:29c2:b0:6f3:da29:8304 with SMTP id y2-20020a17090629c200b006f3da298304mr27312343eje.569.1651768236826;
        Thu, 05 May 2022 09:30:36 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id gx13-20020a1709068a4d00b006f3ef214e6asm918877ejc.208.2022.05.05.09.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 09:30:35 -0700 (PDT)
Date:   Thu, 5 May 2022 19:30:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 08/12] net: dsa: rzn1-a5psw: add FDB support
Message-ID: <20220505163033.3n744lm2ipsjmrlt@skbuf>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
 <20220504093000.132579-9-clement.leger@bootlin.com>
 <20220504162457.eeggo4xenvxddpkr@skbuf>
 <20220505154431.06174a04@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220505154431.06174a04@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:44:31PM +0200, Clément Léger wrote:
> Indeed, I'll simply remove these error message. Should I still return
> an error value however ? Seems like I should not to avoid triggering
> any error that might confuse the user.

The error code will not be propagated to the bridge driver anyway, but
will trigger prints in dsa_slave_switchdev_event_work() however.

You have to choose between 2 alternatives
(a) keep the FDB entry around until it gets removed from all VLANs
(b) delete the FDB entry as soon as it gets removed from the first VLAN

Both options are going to raise eyebrows. (a) will result in "huh, why
did my packet get delivered to this port when the address wasn't in the
FDB?", while (b) will result in "huh, why was my packet flooded when the
address was in the FDB?"

And since (b) is of lower complexity than (a), I'd just silently exit,
maybe add a comment explaining why, and hope for the best.
