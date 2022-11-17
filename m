Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8495362D228
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 05:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbiKQELC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 23:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiKQELA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 23:11:00 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906C331DD5;
        Wed, 16 Nov 2022 20:10:59 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 5so483728wmo.1;
        Wed, 16 Nov 2022 20:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=telxDsGXzS3B1dQZ1ucH1absDeztSSjzIeBKsmfqs7E=;
        b=ncEHdkPY7FD9vGJ0EJkbMmTqdxmU83sOhfmDNVypII6vH2WzZefE6stjKC4woufqAq
         t444v7sk1FqlDRWtnWYs1Dp0qmgZBo8HzIqSV+VyhwFMF12cXDmy8HLTjH4FfELqV7mT
         nkCCSuHNvlX3ZD5cS5xa9jaCwRrD7wgfWtyQzjgdxKcG51Fkem8oGXbPKDyRaVhUcQtb
         UAgyEW3qzX5JiE8X8cr9GTwnda81dIrZjR7JFZxXvshE8rk3STrxCuFUhDukbzyy76lE
         +ocmOcUixWhjFAS3V6FLa/q4GJRwLMLimpoiDvaxH7DHj3sZ3gXkLrhEgmnIEE++mnIy
         qb7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=telxDsGXzS3B1dQZ1ucH1absDeztSSjzIeBKsmfqs7E=;
        b=Lri7LIQEwINJHFuOkeBu4bFUJ+sGie2KW7cVK8f2Hk+CXv+rFm8nG6Q7ZcAb1NUNea
         r/KLbK7i4618GcUBXtooOGsm6lkkRmXazeLo55kNVXF8MuSNTdzb/lOwGfuBUGP8KdxN
         U3Km3+UF1XkX2HHzxaZI5nvb0NPmWHWug91hA9hMlRTr8EtLKRb7D1gllv5yLSlirfWc
         Aa2GHlLCPL2FV56DQ7f0vlPEwSEaYoClGTGVIuDYS+JYkzmI0buUQFTges5QguWfjnTg
         TZbWi/MqG8rNKjlEGNgFJBU8vSMGz/4UfaSKsOWD5V1C7BmyiVVDBMQyOur5jxIqgrle
         1NkQ==
X-Gm-Message-State: ANoB5pmrs/AlESxZrgsJxloJ6R37+iKXoW+6SZ6U3pvljc7Zp/LzrKFk
        s6dwMcNHLOKiU76ao/ExXxE=
X-Google-Smtp-Source: AA0mqf6d3CmOtmZJyOaeRJ/hV/09DPfyoJ1w2wtGQXB4xyGZ7G+UEDBjeLsbF5xip8RdntukJH4K/g==
X-Received: by 2002:a05:600c:35c4:b0:3cf:9668:e8f8 with SMTP id r4-20020a05600c35c400b003cf9668e8f8mr3896835wmq.195.1668658258081;
        Wed, 16 Nov 2022 20:10:58 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id u12-20020adfdb8c000000b002417ed67bfdsm13601234wri.5.2022.11.16.20.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 20:10:57 -0800 (PST)
Date:   Thu, 17 Nov 2022 07:10:51 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Message-ID: <Y3W0SwFS9uDtzHm3@kadam>
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
 <Y3Vu7fOrqhHKT5hQ@x130.lan>
 <Y3WxW1Whoq3brPim@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3WxW1Whoq3brPim@kadam>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 06:58:19AM +0300, Dan Carpenter wrote:
> On Wed, Nov 16, 2022 at 03:14:53PM -0800, Saeed Mahameed wrote:
> > On 16 Nov 08:55, Yoshihiro Shimoda wrote:
> > > Smatch detected the following warning.
> > > 
> > >    drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
> > >    '%pM' cannot be followed by 'n'
> > > 
> > > The 'n' should be '\n'.
> > > 
> > > Reported-by: Dan Carpenter <error27@gmail.com>
> > > Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> > 
> > I would drop the Fixes tag, this shoiuldn't go to net and -stable.
> 
> Some maintainers would want a Fixes tag for this and some wouldn't...

Immediately after I sent this email a different maintainer asked me to
add a Fixes tag to a patch removing an unnecessary NULL check to silence
checker warning about inconsistent NULL checking.

Generally I would have put a Fixes tag here because the typo gets to the
users but I wouldn't put a Fixes tag for typos in the comments.

regards,
dan carpenter

