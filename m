Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A436600B1
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbjAFM5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbjAFM4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:56:43 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FA869B36
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:55:57 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso5163312pjt.0
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lEYk+mZODoO93cG2HIO3aDsjhc6RoXoABRAPTfEB/Z8=;
        b=3mFkSsuvByNdmVJReuv5KJvmxXZuP+l2uFkB7hrZVRPNRYvDSpku5Mg9E00VZAy66I
         R0uENPjzPsMyksg1w3tYM17UZEhd/IOf/8xlKkvJsUWCkHFxSnIwAEb0l1awVgaLwRDB
         Ki90fgfTmrWOFrg1cJIry3x13Jd6a/Do/vUDcx0BUzaZKREbw0cdLd6E1nJleE23RtFT
         s9K7ZHOWmemLGqJNQJQuGgKUWeNjizQbfiwP+xfLufNcW8SDT9VGQxFrpJbG+F6QuQlx
         5Sv75IkFV3imjYXLH11BzTCrf9uNwOaylYgagxccy2dJu2lLpAO/i4LnyC3yFIzf5Af5
         N4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lEYk+mZODoO93cG2HIO3aDsjhc6RoXoABRAPTfEB/Z8=;
        b=eGbMuGFW5bOF02Hwz4zNNHefZZOsrv1KodooGDgezynrhpoVRtaOOX8HljSYuMTd++
         AO1CmCCl4dm1hao8RdhvpuapzeC7iPRPwzZussDm9xM2SoNaJIAz19mvojP+wR3rsFpQ
         CIaMO373K1ttQ7wjmSY37sulOAI8hmO8i/49g9HPi7LyEkf1gWGwQ46lycucQUpPTwJR
         1ZnMX3uzGbSft2cvjgn6FtSSBcy00M6EQohha1d4Az3c+ZVIyDmkqQtprwz9y6AnkJsN
         QfC91g/QIg+2LvAEF4opFjAw8ol3kykNbE9V4NBMX6L4Q4ukN2Cx+4SDB7Q4FyfgKvLF
         eIeA==
X-Gm-Message-State: AFqh2kr3+NRly9+Jih5EH9dJ0rvxD0ulH8O0vg8hrKK55N6acYQ9BM8E
        5MmEukXALkDCXaKyYyomjcMt0w==
X-Google-Smtp-Source: AMrXdXvreS1DYEmViRy5+KZBiB3VYQmWVr/mAZfI1QZ9quJZsofu0RJiSBOcl8DFfskMNUOrU+Rg6w==
X-Received: by 2002:a17:902:a5cc:b0:192:f999:1e73 with SMTP id t12-20020a170902a5cc00b00192f9991e73mr7478849plq.51.1673009757280;
        Fri, 06 Jan 2023 04:55:57 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id b14-20020a1709027e0e00b00193132018ecsm554134plm.170.2023.01.06.04.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 04:55:56 -0800 (PST)
Date:   Fri, 6 Jan 2023 13:55:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y7gaWTGHTwL5PIWn@nanopsycho>
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

This helper would be nice to use on other places as well.
Like devlink_trap_group_notify(), devlink_trap_notify() and others. I
will take care of that in a follow-up.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
