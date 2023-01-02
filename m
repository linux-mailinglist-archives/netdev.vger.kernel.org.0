Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBF565B2DB
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 14:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbjABNpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 08:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbjABNpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 08:45:13 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8FE63EA
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 05:45:12 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id y8so26297533wrl.13
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 05:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pWtzgs2QH9e9oPR53orjY+/cAm8ZbB8Hig7RsDcPvYM=;
        b=UGqSdlv4T8iO/AvntBWcFmVu8ywSai+wEjC0IAGeZcxKbgydK7qukxLt5wu4sPy4Cf
         dkytD4rk+3rA5mTW9tvvMCwrQewTidTM8vU3JJd6RugKcnbW4HTZALQXUtny0VOWnAWZ
         KIAFFfLZ9ze+Fv37pJjlDqupT8oCB/Ztz/e3jWiKcRB9/2ZT5oC9H3DCsBS8HcDPyFNg
         L6S81oMudpHpQqHLYm1awPd2TajiZcdr6CJkjRWMcEeDE+Mn+0NK0yKVQOH01+A/loFe
         Spn+lGcdBDvzK9TJ+N/Wd7OHHNvIOkyynCbMtH9BQhFOPHX2JsUlxB+VuJ7GTCV5ON8F
         HTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pWtzgs2QH9e9oPR53orjY+/cAm8ZbB8Hig7RsDcPvYM=;
        b=otqb5/Z4RayV0kd3ggr0tY2LEo7a3pk5L0KwUKAhFlTPfNN/oJwBc53XYx2WPcz0hE
         0YxYVlp6Fbj9AGKbQoCDxFyGtMaByfZtBFctZ33dCXF1DkfAEzW8iJB2NqYq2MhDPIUP
         BelbLVCgMxCBn2Px45wjLcVnGuHfM7t8ZT6N13JCeM1YL7bRJNpMGZOHA1wYIvO3t10b
         pPsoFeGA9bryu90a4/f41bjVkYsOPPLvABTOuPfAQthlXzJHXmDs6GRIJm/4ztbNL0j8
         giFydOLx5RW/vw1JYmQ4pOw/R2eFk6t23cES2YmNAhiGpPdW8+JSLdsx4ioEUUVytKbx
         JL4g==
X-Gm-Message-State: AFqh2kojLCaUQoNBJ3ejJ/6TCQIjIsCrhX6Lv/Y+AkrIAA1Q5IqJ0bpk
        rvxUX1sUXpixTYmjNo8q0OWWfA==
X-Google-Smtp-Source: AMrXdXtP923A00mZ5aV0Dmxsz1JsAgF/Ru5oZR4oCAipUNZz1GalA0bXLAIFfR6t2t5HbCaHp+cs5g==
X-Received: by 2002:a5d:494b:0:b0:27d:59a5:28ae with SMTP id r11-20020a5d494b000000b0027d59a528aemr18076896wrs.27.1672667110808;
        Mon, 02 Jan 2023 05:45:10 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id s16-20020a1cf210000000b003c6bd12ac27sm38237493wmc.37.2023.01.02.05.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 05:45:10 -0800 (PST)
Date:   Mon, 2 Jan 2023 14:45:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 02/10] devlink: update the code in netns move to
 latest helpers
Message-ID: <Y7Lf5WORaN/Ikhvw@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217011953.152487-3-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Dec 17, 2022 at 02:19:45AM CET, kuba@kernel.org wrote:
>devlink_pernet_pre_exit() is the only obvious place which takes
>the instance lock without using the devl_ helpers. Update the code
>and move the error print after releasing the reference
>(having unlock and put together feels slightly idiomatic).

To be prudent, this should be 2 patches as it changes 2 separate things.
Anyway,

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
