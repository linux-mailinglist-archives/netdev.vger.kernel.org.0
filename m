Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C04D4348
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 10:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240693AbiCJJSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 04:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbiCJJSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 04:18:50 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D83B12E16F
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:17:45 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qx21so10587053ejb.13
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QEHGF3hFnWhrmvyYM9T5YXNVJEbx/ibuH5D8nPbNzOs=;
        b=tld1SrlNpBvdoi+kwKveWhKVY+tltFfLydnEh+b8E40hiDUqlTfA8qkoE136QcCYBZ
         u0LJR7VkaBJd6dPJdZupfCR91stco+6HAZv1NyUwc+fM0Rmz/hr8tJsjpQDrodVU/XW9
         R4nw6eGtqLt3xPgUqywCSbUVJVeLLn2ngI3gDxXXUiecLKDcMAki6O7rQodWV7R0hUKA
         HNe8jqk0XsgY7qpIsGjOVR8CgzLFI/W75PqxbNCJIg3pRY5STnxlYP5T6miWTSQzJm4t
         /5ypauZQDeDcHJv/0xmmKGqS8HA09lpZdPD7MyWarbydIM1GY28URo2aXPKsy+ISIip+
         ntYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QEHGF3hFnWhrmvyYM9T5YXNVJEbx/ibuH5D8nPbNzOs=;
        b=0o4dLwLlO8QTr0pZP8I7Y6dh9ffCfT380T5uW3Gphgz7ns+cn5csmftNglWii5hydI
         aDBX5u/2gOAyfjmP6L3w5uYMvwN8HxuTuGOjF+CXrO/uFlLWNwYNRJIcfUPzAz9PniS2
         rDqFf4T0cW+NF+6dSHj5oqD9BwuGGcVkDQ+P15/Jas7FDwpKKiIf4+8o/S9YuLnA9pqZ
         WU8eIuuRdCClMC1ZBmM5gUduaJHLlfk6CxF+j44BkTUnf5lJOGWN6CEmaUNh2OCuP9++
         UxEP7NwqNYdzrlwzgs+6+Hd3cYQaFDlgPk+Z7AbejfBvRrEXJs3c5r59syJpFGB+uNWr
         Z6dg==
X-Gm-Message-State: AOAM531TwHokBDIF01fi/83vnVOqfHhSeOQbDnOsw9IUKjw31GeGfIxz
        2XqnMAOl1nNcU7BHEa2m2Sox0Q==
X-Google-Smtp-Source: ABdhPJwvbOtbjAWFDI1HpVDj+MH2qFL15oHdD10hSMTD58H/hS2mT0df/ZaGg9Pk7+VgkiMR+mUaDQ==
X-Received: by 2002:a17:906:1294:b0:6ce:51b:f213 with SMTP id k20-20020a170906129400b006ce051bf213mr3216493ejb.303.1646903863856;
        Thu, 10 Mar 2022 01:17:43 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id ce12-20020a170906b24c00b006da824011eesm1584773ejb.166.2022.03.10.01.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 01:17:43 -0800 (PST)
Date:   Thu, 10 Mar 2022 10:17:42 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com
Subject: Re: [RFT net-next 4/6] eth: mlxsw: switch to explicit locking for
 port registration
Message-ID: <YinCNuQO3p0Bkv05@nanopsycho>
References: <20220310001632.470337-1-kuba@kernel.org>
 <20220310001632.470337-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310001632.470337-5-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 10, 2022 at 01:16:30AM CET, kuba@kernel.org wrote:
>Explicitly lock the devlink instance and use devl_ API.
>
>This will be used by the subsequent patch to invoke
>.port_split / .port_unsplit callbacks with devlink
>instance lock held.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Looks fine. I was about to propose a helpers for the lock/unlock that
would take mlxsw_core, but I see you are removing most of them in the
next patch :)
