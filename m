Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EEC52248C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240809AbiEJTPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240391AbiEJTPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:15:17 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9344B439
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:15:15 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id n10so34867938ejk.5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NIwfk4Ay1HtbUzGrUHqyuqynYHjUo3zbLynCCeWeUBU=;
        b=FFDMkkRW+QRfdoa+lKkwcutGBlzKjc5AvcBYNpFotPnCenUIyqAK8mW2x3lfqzRa2x
         +rW3A0tVf+WXaLmY+FS2iFrewhlgDsJJMbSY+PrjzSTIigVFU3QoM4j25839+QcI/3vE
         OZAMzJlODwyYepIegsjhfw7iJ11KQ4U0t5DLfg2YpH51s6TtJUwmZMUtT7hAo6A5pT5Y
         00cdO7RWc49ZA+YxJHF0KWDXpr4mBI+UrwhBD6QvjH3Jre3z1VCc9V7blT86qrAVC+rE
         F2ndkyScMd0XNMP+aFHUfHEYrB56Zy/lrr23f7X0bLVZ46Gvz8a/WiTN2EQzrb1++Snc
         uWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NIwfk4Ay1HtbUzGrUHqyuqynYHjUo3zbLynCCeWeUBU=;
        b=1lHJPKwd5CdhNzNDDh+kWsuT99fO3rtvdiiNDpMU+brkEyEBhx48fSF/qOVxIz+IR/
         /Edvi+yoNiIFpr2kFKfcd4kTl+RkDMJ27mXJv9EqssAfjklqCJac75UBDug94rguL4n9
         6Hm7K3LtS9/nJfXUVTniD5nFQ+PMz4J3VLUCYo8OwktAbI11QMpZg7RutZieWPidbk47
         sJjX2V64NUY8ljwkoGIrYC4oFMeMF5edgkSMJsabhTMrF9wkJPa9A9Sk8KJzF+3ff0BT
         006a2H2/btTZhEl6PmaSqAUa0ae17rnKpw9LvTd8VIoLyoJpumxlTM5n3udR+H2O92dR
         xBcA==
X-Gm-Message-State: AOAM533Ihu3dwogQna/tmgTT+uzCggyf/bW8YR+THqZHLGQXU+3O6s9h
        TFQIJLVuJ5jQTmhTO4WxR+/hlCQDHI24sXsrR1o=
X-Google-Smtp-Source: ABdhPJxGx6qDSJBbrWe+8PXwSqKoFjcaojQ5Bltas2MiwaBS5D6ZD3Lai/MppLXrPBw1GJG631rSEo/RYL5qkZPE7eE=
X-Received: by 2002:a17:907:72c4:b0:6f4:ad52:b9fd with SMTP id
 du4-20020a17090772c400b006f4ad52b9fdmr20891370ejc.128.1652210114407; Tue, 10
 May 2022 12:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com> <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
 <2a338e8e-3288-859c-d2e8-26c5712d3d06@nbd.name> <04fa6560-e6f4-005f-cddb-7bc9b4859ba2@gmail.com>
 <YnUXyQbLRn4BmJYr@lunn.ch> <391ca2d1-6977-0c9b-588c-31ad9bb68c82@gmail.com> <CAA93jw5=Dh9w6x_EQtuWdAbWVUF00M+5x3idFz-XOvAzG5dMQw@mail.gmail.com>
In-Reply-To: <CAA93jw5=Dh9w6x_EQtuWdAbWVUF00M+5x3idFz-XOvAzG5dMQw@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 10 May 2022 12:15:02 -0700
Message-ID: <CAA93jw5P=QeNGin-Jf4g9ystDRNv4jnTHPjPc46L+cu-uR43bQ@mail.gmail.com>
Subject: Re: Optimizing kernel compilation / alignments for network performance
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Felix Fietkau <nbd@nbd.name>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

while I'm kibitzing kind of randomly on this thread... Richard Site's
just published book, "Understanding software dynamics", is the first
book I've been compelled to buy on paper in many years, due to the
extensive use of useful color graphs and analogies, as well as
explaining the KUtrace tool, and so many other wonderful modern things
I'd missed.

https://www.amazon.com/Understanding-Software-Addison-Wesley-Professional-Computing/dp/0137589735
