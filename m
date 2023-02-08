Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B0168F0FC
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjBHOkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjBHOkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:40:24 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772B322A2F
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 06:40:19 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ud5so51752226ejc.4
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 06:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s9SqKFTGfsUhK0VGlIsx60gznbUo1PU0OFbxtN+0yhY=;
        b=jlgyWpaKF22lnEWRYaSMF+UNOB3z0G1RMdUbmlRI+Sn+XY7EcL2OaAXMRtthMX0cGA
         VcfB5lzzmIVNPdBYBoMGkDDarSXgB05dS39oTh3whI2tVG2moG3YBcbyvzOANJc3YYWs
         ZYPzZH+qVHzYuZtHwjVRcGrBvHR8meM3Xk1HCy2l0ltsqqN9VjLm9fvdd6FR2bEDrR/K
         OiFg/G3RkI5an3wnecmurwZg3szYm8hS8lRv+N0R72MFFcz2qiyRW0Zcdv7g9fJva6LF
         NLwEQNCbzhoFWxd2UmK0JHzTH1gH0LCg4rQ1TCu262/HIY1FvTuAPT2ZmvqlmbwxqQEX
         Vmhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s9SqKFTGfsUhK0VGlIsx60gznbUo1PU0OFbxtN+0yhY=;
        b=U6KhJVzRQ3AvIOnW+rfc7x9X44O6OjfeRh9fhrBjJdBrUR7L9trdOq9gRY59DB46Nd
         8RCKWtuqb4Jr5VO1opXG6WyfAfuR6wSbqMW0nkRSkfQD8lG5w0Hn3oBmVjKia/0j52VC
         f3CBwMW6/FIkgbvkUsdEOaArPN+yFFJ8xNrJEDbtz8LQ/UrzVnz5VxzVJpdW++iK+U6D
         ckU/M5M4BaRAUHX+WMw96MVvi4Ovv3sqdp0fW80VjYKPrOstE5Qz16XJXVqAlbHABooX
         47OXXxUPdQF4da798lORfB1RaM2lp4xFVm7m/f5rsbh8N4NcPL08FxRycMdGi+mn5GKD
         xUIQ==
X-Gm-Message-State: AO0yUKVII95VwiCWyutXQnJiz4uOp8ed1/E5QFWYGv7zaoqgYKpMqK0w
        VaNrtfD8CBP2SxOJNmVdTyaS2w==
X-Google-Smtp-Source: AK7set/0gSIA4pnaYhxPIic71u2qEnu5SyAeHnJiEtpWOHAq/G7JK0KqaH8e6Q582tOxHN4nPJPDsA==
X-Received: by 2002:a17:906:8d0e:b0:8ae:30bb:a12c with SMTP id rv14-20020a1709068d0e00b008ae30bba12cmr2281175ejc.28.1675867217938;
        Wed, 08 Feb 2023 06:40:17 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fp3-20020a1709069e0300b008aea5e0938esm654244ejc.183.2023.02.08.06.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 06:40:17 -0800 (PST)
Date:   Wed, 8 Feb 2023 15:40:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
Subject: Re: [PATCH v6 net-next 8/8] sfc: add support for devlink
 port_function_hw_addr_set in ef100
Message-ID: <Y+O0UE2Drm3iyZE/@nanopsycho>
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-9-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208142519.31192-9-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 08, 2023 at 03:25:19PM CET, alejandro.lucero-palau@amd.com wrote:
>From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>
>Using the builtin client handle id infrastructure, add support for
>setting the mac address linked to mports in ef100. This implies to
>execute an MCDI command for giving the address to the firmware for
>the specific devlink port.
>
>Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
