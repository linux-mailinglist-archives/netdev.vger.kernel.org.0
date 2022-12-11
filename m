Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB22F6493FD
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiLKLnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiLKLnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:43:14 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91DF63FF;
        Sun, 11 Dec 2022 03:43:09 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r26so9091030edc.10;
        Sun, 11 Dec 2022 03:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CHMEobRY5ll+WuvWbOgxBlhmh0THSxHsS/XXUodOfVs=;
        b=prsRjnu5gqWDp4fkGtPHarWDz+35N6YQjtRQ6Bm/v+50bmd6rGtNfVJg9CiCBeOt2E
         roO0gN5g+QUbE9ofTjxpwyWcLs9AyGLYYNboNpLiErjtglgfAYbas2+hbSHBzwL//wXc
         zjKMEIdaGP6YQx/JcURp+sZRgFnQUHXQnfTc4Lp6NWZ59TiucTt1SnGKo4QcqGTmzhi0
         2Y5ugAJVXpnMHtFRtmWalUA+mvknXRQhU/ec6iX1pOl2sN5Q+PhDroXxGh2a3g6IUTwj
         cFYymJZVq6k4yx5I11z+CI4loOuamJ9lCNGJ/RrSrqrjynG5fXwlx4JI2ZiKxKWSoUWa
         O22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHMEobRY5ll+WuvWbOgxBlhmh0THSxHsS/XXUodOfVs=;
        b=ucahqvW8qmu4u/C7lEIj98kDcKPJu3RCqX055dRqUzYAyOAJ83XFkjvcFjussIyzmh
         i71pc0YXY611OoaXHTtd4JaxeD3gG7Uy015lQosmbJrn8wawWf5V3nV+34jieq895qVw
         4BwbJTCWmdYhH0FYFV+kBNB8CZfdIwIbBAm80/8M9stOaRjZLc0X1VqY4WE3FCPgal0S
         cq+Vl208L29LqBxHeJLoIlM5fWX718eO93d1SRTt2KVFbr9zMqEmPQwbUb/OQANcPqHc
         LCLj4UML5Xiwx2wkZJqv+ImiuWC4kkMqHP+R2iicZR1W1JiDgiYMiRqG2QMPqUA1nRmj
         ix+g==
X-Gm-Message-State: ANoB5pmMs1iY4ZGUY7qJc93qfvNta0qnT20JgQCLl7lzV0XgSxj0/mMU
        24BadBGm+C5SIPQ3mm2LGHE=
X-Google-Smtp-Source: AA0mqf5eNU+mJV6hbAFnwFHc4zk90BUTecI/bJ/AOkiVaJah+7bA9pmVSX4TXedO23DwGjJ6XlKWnQ==
X-Received: by 2002:a05:6402:12c9:b0:46c:55ef:8d50 with SMTP id k9-20020a05640212c900b0046c55ef8d50mr10881357edx.24.1670758988481;
        Sun, 11 Dec 2022 03:43:08 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id n13-20020aa7d04d000000b00457b5ba968csm2592471edo.27.2022.12.11.03.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 03:43:08 -0800 (PST)
Date:   Sun, 11 Dec 2022 12:43:06 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y5XCSocOIMQ9KuDq@gvm01>
References: <Y5CQY0pI+4DobFSD@gvm01>
 <Y5CgIL+cu4Fv43vy@lunn.ch>
 <Y5C0V52DjS+1GNhJ@gvm01>
 <Y5C6EomkdTuyjJex@lunn.ch>
 <Y5C8mIQWpWmfmkJ0@gvm01>
 <Y5DR01UWeWRDaLdS@lunn.ch>
 <Y5DfDYr2egl/dZoy@gvm01>
 <Y5DokI3lm8U2eW+G@lunn.ch>
 <Y5IY6FLtndqXqzMn@gvm01>
 <Y5W7F0mX1VvRsWjD@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5W7F0mX1VvRsWjD@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 11, 2022 at 12:12:23PM +0100, Andrew Lunn wrote:
> > Given what I just said, what would you suggest to do?
> 
> I would return just the version part, not the whole register contents.
> 
> The nice thing about netlink is you can add extra attributes without
> breaking the ABI. If that 0xA ever gains a meaning and more values, an
> attribute for it can be added.
TBFH, this time I cannot say I fully agree with that. However, if this
is something you require to approve the changes, would you like me to
change the attribute VERSION down to an u8 or just masking the 0x0A?

Thanks,
Piergiorgio
