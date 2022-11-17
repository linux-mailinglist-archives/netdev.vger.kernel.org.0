Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8312E62D1E8
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 04:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiKQD60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 22:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiKQD6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 22:58:25 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAA4F43;
        Wed, 16 Nov 2022 19:58:24 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d9so1239493wrm.13;
        Wed, 16 Nov 2022 19:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J+s5q3b8+PYlz42oQnRKnwhrGKCMt1VK++v69AYnjg0=;
        b=ONNIwuFBUzFkCoMFZF0onlDZieASK1hmVW3baMjhJcvvHFD74kOcNo7FuMTKNOgo1b
         +gPhwwITgFh1Y7KxiX1OiPhJbaaSrzuxQ67Gq6sqIYe05l3haO+QMJ9Mv+rxj6cBZmf1
         2VHgof0XjO8FHiZF2TzaXnCfXm9w4Rh7D+JIPRkNCDbqWwh5DAFGpVncq3bU9/ZJtN4+
         zmnmIiAJr9ReSRrJB1ZXQeVPs3ELrqmzD9hy8depgdawF9ALAqcsP3EUlgGmbrVmSr/t
         IdeZlEGtMwv7S8pcVfmQCN3vhsgxXqst9INOkHrJ9DSI+Kxw96F73deIQRqw2t6ePaDj
         GJAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+s5q3b8+PYlz42oQnRKnwhrGKCMt1VK++v69AYnjg0=;
        b=lWvhAg+M0DMdi4brQa8B1cmnf63ifrSBZ/nw2ox3JPY0Bx+WGSvSP6ndGRTq2J6Qd9
         JpoOsK2uGkmzVjJqk5G+2Iz7Nx4pyoK12LhEEUN+vbxLCnv1mPz8fv+Dld7PKgWIsS6T
         CHZ8z8CEwT9ceFbAs115G3peJDN5zCyPB+wQvAliojR0yBQxZfj8i/vLOyO802DPnniU
         iBtHUKw8SbWAYx1YAsFUg4Dq3uy6rDomoXgv9IN8uIzy9ITa/nhL+AXtFns56vTAEN8Q
         80yCn6+XNvvqX/9dRNQ4tr5ZSLCk1Ta1NIa7Owkd00a1IEdXauYXC0x7JiZ+WWaGrbbs
         NuyA==
X-Gm-Message-State: ANoB5plLJb7KrCTj9nhQ/DMvnqH2O6HaDmSVXaMqHXBS6dpKs/ibOcGs
        WX9Te9sRxVhCZJ/SddY4Ku8=
X-Google-Smtp-Source: AA0mqf6TLrjTMien8QoyKcL77VuP2G62kEewWt7SD8X3mmHKPPXcNTNrNlwuWp/EeQAmorEMpwkdHg==
X-Received: by 2002:a5d:4c91:0:b0:236:6d6b:fb56 with SMTP id z17-20020a5d4c91000000b002366d6bfb56mr276272wrs.198.1668657503131;
        Wed, 16 Nov 2022 19:58:23 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id y20-20020a7bcd94000000b003cfe6fd7c60sm3824278wmj.8.2022.11.16.19.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 19:58:22 -0800 (PST)
Date:   Thu, 17 Nov 2022 06:58:19 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Message-ID: <Y3WxW1Whoq3brPim@kadam>
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
 <Y3Vu7fOrqhHKT5hQ@x130.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Vu7fOrqhHKT5hQ@x130.lan>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 03:14:53PM -0800, Saeed Mahameed wrote:
> On 16 Nov 08:55, Yoshihiro Shimoda wrote:
> > Smatch detected the following warning.
> > 
> >    drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
> >    '%pM' cannot be followed by 'n'
> > 
> > The 'n' should be '\n'.
> > 
> > Reported-by: Dan Carpenter <error27@gmail.com>
> > Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> 
> I would drop the Fixes tag, this shoiuldn't go to net and -stable.

Some maintainers would want a Fixes tag for this and some wouldn't...
But either way Fixes doesn't really have to do with -stable.  In fact
sometimes the Fixes tag let's you automatically filter out fixes to code
which is newer than the -stable tree so it can mean the opposite of
-stable.

regards,
dan carpenter

