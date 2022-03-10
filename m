Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC4A4D4336
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 10:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238047AbiCJJPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 04:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237211AbiCJJPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 04:15:30 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05AA12E9F7
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:14:29 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id h13so6113063ede.5
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xFRnEW7/VUxzuptUGYkO33lTwd4JOXnXb7NxBP3m5To=;
        b=dGEksxpbFbF+dfGlOMWAy4WzQ/CWEDT40rnOfc5UjK/KAIgzLi4/hFzpZnZrbHHZBl
         Ya2AU122e27MV60pzJAv4jUtg+h6+Smo/3sEIT1ts8yvrz5C1jMG0yBNhY2Ed8lLg7jD
         ElVLRRJE8rydwBP2FbAEOUxH+0Vny4Iqb7TV0bNVCE8wuN2B6Z0VG8hCjrfWSWjJegBG
         /5nyXihronrbNSKqiunl7Arqh87DWCEpG2Z788zejWmNPbQ+SZqmrMEPj8bxi0ScEw0E
         LRJkNwreKLOfHEnYZGTO3wIBC+rpEg/JNelFxM/gEF+CPWoHizNCtA535pFvWT6Fk6iA
         f82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xFRnEW7/VUxzuptUGYkO33lTwd4JOXnXb7NxBP3m5To=;
        b=Rj33mIGUODS1gClamPQHJ3RWq09ZcT/BE2ZXV+3aMOOCEI5DdxjXupFa64voV/68Ya
         fgSaCCDfEN7GLdgiw1VoKV9Y2zD7hFzoSLpB9Kdg9ngw1/7nOVKuAOlaWfArxHrUPgRN
         1xcoqAW7GD3vaD/26LNdqGW35Ytl3Tw8/wc8fWwA2BNCnLKP5Ew8YcC2FlLMha9o477Z
         /cPAGcMNsNxFMKjtQxqy1LbWvdbMNAQzLdlgudbF3UFXqAnChIv5anpaHszOgUAOgtd8
         lMxgrsMdjF9Nl/xmHwAPT46NIifGWLhxNkpASkvKTpNd/3LpZZctO187jWagCg2mqdeL
         wf4w==
X-Gm-Message-State: AOAM5306JZLXFWZKv2vq6y5olLINlxeB8HZbT1EkCu1P4GrOFyszQhAu
        NjQ1vofcTEo8/AUQnOvIBDywCQ==
X-Google-Smtp-Source: ABdhPJy6XkOeywe9WfzOVm6YR2n5p0c4ZjZHPGVc56dAISgVc/73H6fW349DsPafV6h5CeeFvJFkeQ==
X-Received: by 2002:a05:6402:190a:b0:416:c2f8:ad22 with SMTP id e10-20020a056402190a00b00416c2f8ad22mr228202edz.144.1646903668236;
        Thu, 10 Mar 2022 01:14:28 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id y14-20020a056402440e00b00416046b623csm1853205eda.2.2022.03.10.01.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 01:14:27 -0800 (PST)
Date:   Thu, 10 Mar 2022 10:14:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <YinBchYsWd/x8kiu@nanopsycho>
References: <20220310001632.470337-1-kuba@kernel.org>
 <20220310001632.470337-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310001632.470337-2-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 10, 2022 at 01:16:27AM CET, kuba@kernel.org wrote:
>It should be familiar and beneficial to expose devlink instance
>lock to the drivers. This way drivers can block devlink from
>calling them during critical sections without breakneck locking.
>
>Add port helpers, port splitting callbacks will be the first
>target.
>
>Use 'devl_' prefix for "explicitly locked" API. Initial RFC used
>'__devlink' but that's too much typing.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> include/net/devlink.h | 11 +++++
> net/core/devlink.c    | 99 ++++++++++++++++++++++++++++++++-----------
> 2 files changed, 86 insertions(+), 24 deletions(-)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 8d5349d2fb68..9de0d091aee9 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1479,6 +1479,17 @@ void *devlink_priv(struct devlink *devlink);
> struct devlink *priv_to_devlink(void *priv);
> struct device *devlink_to_dev(const struct devlink *devlink);
> 
>+/* Devlink instance explicit locking */
>+void devl_lock(struct devlink *devlink);
>+void devl_unlock(struct devlink *devlink);
>+void devl_assert_locked(struct devlink *devlink);
>+bool devl_lock_is_held(struct devlink *devlink);
>+
>+int devl_port_register(struct devlink *devlink,

It is kind of confusing to have:
devlink_* - locked api
devl_* - unlocked api

And not really, because by this division, devl_lock() should be called
devlink_lock(). So it is oddly mixed..

I believe that "_" or "__" prefix is prefered here and everyone knows
with away what it it is good for.

If you find "__devlink_port_register" as "too much typing" (I don't),
why don't we have all devlink api shortened to:
devl_*
and then the unlocked api could be called:
__devl_*
?


[...]


>+bool devl_lock_is_held(struct devlink *devlink)
>+{
>+	/* We have to check this at runtime because struct devlink
>+	 * is now private. Normally lock_is_held() should be eliminated

"is now private" belong more to the patch description, not to the actual
code I believe.

[...]
