Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0395A665C57
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbjAKNVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjAKNVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:21:15 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D4625E9
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:21:12 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id u9so36831824ejo.0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Um+jovtrYOL/VC+88e8hdkm2Z0cFc/2S3U4eakgjUI=;
        b=7XlFHYcYEGSjl7tHZd7xTKPWAhEyqGw1MmEVqQI5OZU+2gVGXQub5pMTw6gJQKpSO4
         Hw1AIAp2k+JBhz1Nv7GGMTwP8lxmn9w60qLXotcm/KzAOdzdhJBYHUb1yIizA/92WYS6
         o49fPicUq3d5gnGPnCK0Hujqgr9PDvSbUqjHAXfaNyu7SAVlPkojxS1WGV/I8ZTDu7hw
         2G24VJ2BPfFMF5VYPcB6uZiy4V7gBGHzlvh56HZ8gDrqoTVCn9QZHuYJam259J8TpzIt
         wMGwDNiTli3thnQNYLCGgp+wq4/mH4SoKVmobhLsSIKwDUUe5c6754lC6LWWly9pvPSo
         Pong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Um+jovtrYOL/VC+88e8hdkm2Z0cFc/2S3U4eakgjUI=;
        b=IiMT09X8EeTb9yQFJ+YQ/C8CXtz0FLAtT1GRMhdWDW5fiWlVc7EOw51oaaKwXBBJDI
         My6no6YJ/FOPH036rf2l4QcYuOT4yS65Dh7Si7StoKKV9Am0maHInnOZI1dRIGn1WAjy
         hPuVPr1PuZRFU01ZW9ITqjhdYTX0jaoxzE684l7jGeBMn45jhgVM9HKJID788ufHo9Zw
         m9nMRhnTa+XdSDlaXRKrPY0mgAyXg/Bi/0PJ0p+3STihFTps8mxuQbeejjkUgY0mtI3l
         HDIBhiHBNk99eq1RBzXJDkUnD5EmUn9P9IBrxDm378Go8B38TAXPVPGI0vSKqErLVDSk
         P74g==
X-Gm-Message-State: AFqh2krdFO8ZaqhHcT8NHEazSK/IirtOBMECySv+ut6P1VuElmQg8BTr
        bzVTt8czFPngOGihNoJcLAg4rw==
X-Google-Smtp-Source: AMrXdXtaDACzDrhDPbQsau0RBhVdDXfixYu6IySxr+EGnwrPMRd0Im7IdaVRI0eQ1V54jgzjiYzOuQ==
X-Received: by 2002:a17:906:1c89:b0:7c0:b3a3:9b70 with SMTP id g9-20020a1709061c8900b007c0b3a39b70mr67479450ejh.62.1673443271355;
        Wed, 11 Jan 2023 05:21:11 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id s5-20020a170906c30500b008552bc8399dsm2243823ejz.172.2023.01.11.05.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:21:10 -0800 (PST)
Date:   Wed, 11 Jan 2023 14:21:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y763xcz5fdpZnod3@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106063402.485336-8-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 07:34:00AM CET, kuba@kernel.org wrote:
>It's most natural to register the instance first and then its
>subobjects. Now that we can use the instance lock to protect
>the atomicity of all init - it should also be safe.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> net/devlink/leftover.c | 22 +++++++++++-----------
> 1 file changed, 11 insertions(+), 11 deletions(-)
>
>diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
>index 491f821c8b77..1e23b2da78cc 100644
>--- a/net/devlink/leftover.c
>+++ b/net/devlink/leftover.c
>@@ -5263,7 +5263,13 @@ static void devlink_param_notify(struct devlink *devlink,
> 	WARN_ON(cmd != DEVLINK_CMD_PARAM_NEW && cmd != DEVLINK_CMD_PARAM_DEL &&
> 		cmd != DEVLINK_CMD_PORT_PARAM_NEW &&
> 		cmd != DEVLINK_CMD_PORT_PARAM_DEL);
>-	ASSERT_DEVLINK_REGISTERED(devlink);
>+
>+	/* devlink_notify_register() / devlink_notify_unregister()
>+	 * will replay the notifications if the params are added/removed
>+	 * outside of the lifetime of the instance.
>+	 */
>+	if (!devl_is_registered(devlink))
>+		return;
> 
> 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> 	if (!msg)
>@@ -10915,8 +10921,6 @@ int devlink_params_register(struct devlink *devlink,
> 	const struct devlink_param *param = params;
> 	int i, err;
> 
>-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);

Hmm, params list is not protected by any lock. The protection it used
was that it is static after registration. You changed it but didn't add
the lock. All param register/unregister functions need to be renamed to
devl_* and assert instance lock. I will fix this.

[..]
