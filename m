Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17FE645E86
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 17:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiLGQRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 11:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGQRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 11:17:19 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965F129C9D;
        Wed,  7 Dec 2022 08:17:18 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id fc4so15122207ejc.12;
        Wed, 07 Dec 2022 08:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vexo47SWu18SUJUmhkZ6FDikOo7U0Q9P4r9hjmuRqO0=;
        b=GIhImnhPXyK3YwyYO1hLrgSvqw2DQyvnyROXiTjgKZSdhI9OVCuQldSvYOHQo3bC/B
         KNUhCXYdRYKX3B0iAXyT6gFk4q5YbsH5K8jmCmSK6KfpZQL/6Go/rC/OX8Wrzd23Fbxh
         wQLEWpoN7Mcxg3zrFgnwPc2FiJdEm6ZRnAkIxiVFfeoqD6sgzr6q0+OpGG1rjCu+m3ly
         pCWBD5EMyz3Ad92j/zs568mjIGf644oT4+4AJr0Yg4tHkHOR3scEylbBc+tIEk2lbJKj
         jTKWjU8+s5o/ciKZriAuywvVx4yFL4UJ6mqPAhv9AGbt1w2uNHeRWapXlCGvcpiR6o3e
         TNCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vexo47SWu18SUJUmhkZ6FDikOo7U0Q9P4r9hjmuRqO0=;
        b=3lBTYbetuKisEXUH+zrudjvmtZKSSpH0oWiwBRZII+FGH8OP20e8Nw/MrYufhTakYL
         dYA47+Wq44QOQdqYxJkYl9jU6G/1TH0Tms87y3fa0jqPHALS0rOuKn4QZwctgbTePX9O
         yd0qEgEKJh2nXo1ks7TojsoYVcTV0atxGsEz3weLe5rjm6h29oI5AzGyZFeYFxeXKpn4
         yWsUG96EuGIggYZ6kCGuSExQRZASYNYUhQNk+yz+T+OKIO15SGssHziotiyW7sKM+nr7
         /1FHjIqZr5glxTIKxYwQP7dHTnMq7ZKGQarEf/joL0+9VhERulhenSZZOX7/KdwuTfod
         UNMA==
X-Gm-Message-State: ANoB5pka1E+4Xr6bNxxQdTjE1dUgWwEFjntazfwFSuTDlekQK+lN1WUL
        EOvlXYfvfnZyLCg47RJgfQY=
X-Google-Smtp-Source: AA0mqf6UYzg36G+moICbHOZwIfnlXACn/TE0whPJbX87BMYc+rgMGNYT+xr0xIwDmDLg0DmG9lDPwg==
X-Received: by 2002:a17:907:8c8e:b0:78d:4167:cf08 with SMTP id td14-20020a1709078c8e00b0078d4167cf08mr29399838ejc.337.1670429837027;
        Wed, 07 Dec 2022 08:17:17 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id l13-20020aa7c3cd000000b00467960d7b62sm2410225edr.35.2022.12.07.08.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 08:17:15 -0800 (PST)
Date:   Wed, 7 Dec 2022 17:17:28 +0100
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
Message-ID: <Y5C8mIQWpWmfmkJ0@gvm01>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
 <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
 <20221206195014.10d7ec82@kernel.org>
 <Y5CQY0pI+4DobFSD@gvm01>
 <Y5CgIL+cu4Fv43vy@lunn.ch>
 <Y5C0V52DjS+1GNhJ@gvm01>
 <Y5C6EomkdTuyjJex@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5C6EomkdTuyjJex@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 05:06:42PM +0100, Andrew Lunn wrote:
> On Wed, Dec 07, 2022 at 04:42:15PM +0100, Piergiorgio Beruto wrote:
> > On Wed, Dec 07, 2022 at 03:16:00PM +0100, Andrew Lunn wrote:
> > > > > TBH I can't parse the "ETHTOOL_A_PLCA_VERSION is reported as 0Axx
> > > > > where.." sentence. Specifically I'm confused about what the 0A is.
> > > > How about this: "When this standard is supported, the upper byte of
> > > > ``ETHTOOL_A_PLCA_VERSION`` shall be 0x0A (see Table A.1.0 — IDVER 
> > > > bits assignment).
> > > 
> > > I think the 0x0A is pointless and should not be included here. If the
> > > register does not contain 0x0A, the device does not follow the open
> > > alliance standard, and hence the lower part of the register is
> > > meaningless.
> > > 
> > > This is why i suggested -ENODEV should actually be returned on invalid
> > > values in this register.
> > I already integrated this change in v5 (returning -ENODEV). Give what you're
> > saying, I can just remove that sentence from the documentations. Agreed?
> 
> And only return the actual version value, not the 0x0A.
About this, at the moment I am reporting the 0x0A to allow in the future
possible extensions of the standard. A single byte for the version may
be too limited given this technology is relatively fresh.
What you think of this?
