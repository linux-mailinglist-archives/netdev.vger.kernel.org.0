Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E558A685DAA
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 04:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjBADE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 22:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjBADE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 22:04:26 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFB413D;
        Tue, 31 Jan 2023 19:04:25 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id h9so8514957plf.9;
        Tue, 31 Jan 2023 19:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=URQSWiZd0luec1SvypDIlEKZ6z90vAUo3qcy5qaD0EY=;
        b=dfhX+3MunRY/Pi+jDfesNkoQKATP8Tn9zpYihpBw00PlSGpPSeLL4+dKaljIVGlnm8
         pV459bICG10Bi/Xs+1qtDAI7cP9fP/FUbd3k8LDTR3Wvu32ENj+Wbu2t8Zf4WnnHFTIk
         uxinFSBrWaqWmg3kYRyHipp4LfL492Ut3YDJBG7hYe2QsOG2JoZuNV1U6wa7OPVJFfUw
         zTYtBc5tOy75L23Zhe/ZOC/kiv328538ocXucB63WEJQW7MUUMxll2U9rVGFOCDZgs8h
         4qOJ+N43UG+ImJomiKaYqoHere8y34Ie7FhE4qWGDXzXbKP+9WTLC7uXLfnlFRCyT9sC
         JzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=URQSWiZd0luec1SvypDIlEKZ6z90vAUo3qcy5qaD0EY=;
        b=XaK7O9LYKS5vjJV58IHcJZvIJblZJXfM2uNINtciL+9qE/VkPnb6VMd0YEs8zHcOz+
         5Q35C4M20JIwAAGbmPEHew2ctj5IyyuGEr1cbn4oXtN9xjK/dsGDq2tNd5Gpp+aEU+in
         i87pzPxAPoyhJnBf7oSjrXZv9Z76SVDTuhoAz0Rtth0grAFyeLFYdWGqud3J6aZ9AsVp
         LO+gJmWZ4VyruyGOubENg1k4PrgsaiESv6KjAmFIOSQvv3t+Ygq+Re9c9eRo76XzzWnF
         BW5GvaqXbI3eevWDPAIlNpkm10OJu07EaH6QMMAUtuexeiZc4XZhCZSeRqwdxrG0s6La
         NMhQ==
X-Gm-Message-State: AO0yUKUdl4uqZ1ixQax8CiyhtPoI+SpTN2InRCVkl21NSiJvtvW722B0
        br+QRROiMqQhMwseHBv3wGg=
X-Google-Smtp-Source: AK7set9roMBat1D4UaLrspl4qhFXZnY22EtVlcQIGo8nORvmj46G0lUGOIC/OJE+QpAxXQhjN9fR7Q==
X-Received: by 2002:a17:90b:1811:b0:22c:832:98ec with SMTP id lw17-20020a17090b181100b0022c083298ecmr485159pjb.27.1675220663924;
        Tue, 31 Jan 2023 19:04:23 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:ce3a:44de:62b3:7a4b])
        by smtp.gmail.com with ESMTPSA id x9-20020a17090a530900b0022bffc59164sm172806pjh.17.2023.01.31.19.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 19:04:23 -0800 (PST)
Date:   Tue, 31 Jan 2023 19:04:19 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: fix conversion to gpiod API
Message-ID: <Y9nWs+JXPHbE7SPo@google.com>
References: <Y9mar1COtT5z4mvT@google.com>
 <Y9nA4Mmi5hv5OzBh@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9nA4Mmi5hv5OzBh@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Feb 01, 2023 at 02:31:12AM +0100, Andrew Lunn wrote:
> On Tue, Jan 31, 2023 at 02:48:15PM -0800, Dmitry Torokhov wrote:
> > The reset line is optional, so we should be using
> > devm_gpiod_get_optional() and not abort probing if it is not available.
> 
> > Also, gpiolib already handles phy-reset-active-high, continuing handling
> > it directly in the driver when using gpiod API results in flipped logic.
> 
> Please could you split this part into a separate patch. There is some
> history here, but i cannot remember which driver it actually applies
> to. It might be the FEC, it could be some other Ethernet driver.
> 
> For whatever driver it was, the initial support for GPIOs totally
> ignored the polarity value in DT. The API at the time meant you needed
> to take extra steps to get the polarity, and that was skipped. So it
> was hard coded. But developers copy/pasted DT statement from other DT
> files, putting in the opposite polarity to the hard coded
> value. Nobody noticed until somebody needed the opposite polarity to
> the hard coded implementation to make their board work. And then the
> problem was noticed. The simple solution to actually use the polarity
> in DT would break all the boards which had the wrong value. So a new
> property was added.
> 
> So i would like this change in a separate patch, so if it causes
> regressions, it can be reverted.

The quirk for the gpiod API to take into account "phy-reset-active-high"
for FEC driver is already in mainline:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/gpio/gpiolib-of.c?id=b02c85c9458cdd15e2c43413d7d2541a468cde57

This is limited only to devices matching compatibles handled by FEC
driver and is being considered automatically as soon as gpiod API is
used.


> 
> > While at this convert phy properties parsing from OF to generic device
> > properties to avoid #ifdef-ery.
> 
> We also need to be careful here. If you read fsl,fec.yaml, there are a
> number of deprecated properties. These need to keep working for OF,
> but we clearly don't want them exposed to ACPI or anything else. So if
> you use generic device properties, please ensure they are only for OF.

OK, if this is a concern I'll drop this from the patch and keep of_*
APIs since we need to keep #ifdef CONFIG_OF anyway.

Thanks.

-- 
Dmitry
