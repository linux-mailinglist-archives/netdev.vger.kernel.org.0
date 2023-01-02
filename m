Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A2665B42B
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbjABPZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbjABPZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:25:32 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3E3A1A5
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:25:21 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id z8-20020a05600c220800b003d33b0bda11so15347606wml.0
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 07:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CDTjitWO+s2E/hhaXqHm6fIzEJXWwu2UfqREY+PW0L8=;
        b=1V3UWq6CVakcxv7LE7x13hdYL/AubFfUhio1floeZYnXfgpuqQ5/h9GKRHvpeqfDlw
         5R5CgaXSchmnPxoCMuyH+jXDJSksb8L7wbt9mXUMpXALPIb1opEd2o/UM+UIf6a9m3Z/
         0KRZT7Ssv2wgbvfFCGPLqanm/sagkgKQHK91aSeAe1uXcrV6A3nWY4e1nOebG13SRg17
         2+4LJgVNeYhdfwj0RQwv2jonNPRNFaa0nYBQk+3YGXw6UgyNEjFDmk8gAFDvQwJbmW2R
         paXhyto+ePs6t5FUdg2hFBcl4OAp++2hLKa9GluVEathksHhdz6KLJRwKJq3P6hRZ774
         TPWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CDTjitWO+s2E/hhaXqHm6fIzEJXWwu2UfqREY+PW0L8=;
        b=JsrqlcMrTQxUCNj8BNQTwpZbgl/TjOHMrYQNdtxaLu2YEgZdWGmPRA2uwC4EHLEeeh
         nSMrFPv+K6slW7dk1ESW6ZDYwl8fe8e7LKbnQay2oGocbOOxdmvUHHkpLzUQIuXlc5Ej
         HIYwHKeWVsQMk2w4S/CaZuP6YOLuPrLn9gHv01mKZsnvGykNGIQ+oKPnehdsWat4mCGP
         8le465aYwYOz37O23fPB1u/7445TrHt+Ct2bJP/yvIUWOgY2rQAo/HfxWRw3PdVYEoLy
         hP+Nz7pyJRgB6xHjAMvr0UuCI1I9Ab3bPxRkyyX1KbzABGE8ZBsog85Gw6o5nlQj/nYy
         hrig==
X-Gm-Message-State: AFqh2kr9kAWaWGa1fdn1t8GZMyxDK4CYHuJaetTsBajalmNHl0xgO0Hl
        n1g1bQawhFiVozn3KYu9Zl6dvw==
X-Google-Smtp-Source: AMrXdXu90aea0Zan7IEL7/A9+KCxqgsz2LiU8971BickEOvAZnPhe2iUO1fS/mQYh6bmEK5eQekxew==
X-Received: by 2002:a05:600c:2d91:b0:3cf:735c:9d54 with SMTP id i17-20020a05600c2d9100b003cf735c9d54mr28627228wmg.1.1672673119943;
        Mon, 02 Jan 2023 07:25:19 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v13-20020a05600c444d00b003d998412db6sm19240123wmn.28.2023.01.02.07.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 07:25:19 -0800 (PST)
Date:   Mon, 2 Jan 2023 16:25:18 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 06/10] devlink: don't require setting features
 before registration
Message-ID: <Y7L3Xrh7V33Ijr4M@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217011953.152487-7-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Dec 17, 2022 at 02:19:49AM CET, kuba@kernel.org wrote:
>Requiring devlink_set_features() to be run before devlink is
>registered is overzealous. devlink_set_features() itself is
>a leftover from old workarounds which were trying to prevent
>initiating reload before probe was complete.

Wouldn't it be better to remove this entirely? I don't think it is
needed anymore.


>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> net/devlink/core.c | 2 --
> 1 file changed, 2 deletions(-)
>
>diff --git a/net/devlink/core.c b/net/devlink/core.c
>index 413b92534ad6..f30fc167c8ad 100644
>--- a/net/devlink/core.c
>+++ b/net/devlink/core.c
>@@ -131,8 +131,6 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
>  */
> void devlink_set_features(struct devlink *devlink, u64 features)
> {
>-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
>-
> 	WARN_ON(features & DEVLINK_F_RELOAD &&
> 		!devlink_reload_supported(devlink->ops));
> 	devlink->features = features;
>-- 
>2.38.1
>
