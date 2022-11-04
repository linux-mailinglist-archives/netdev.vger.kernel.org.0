Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844F5619BE9
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiKDPky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiKDPkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:40:52 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF25B31F9C
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:40:51 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b2so14282054eja.6
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 08:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rdh0Wx9Wru7j1tW5FzcgL1Yz1dikOnBOzhP8dIEjUFY=;
        b=71gLpWVJmWLvPB6Nwsg4jbskn6wcGH6hXXzcVxUPHvmspKDNQnfJkoWKkGAawrGu0G
         doi/eoYsIM+/gGhvH24B+LdKS3AT+JcutqlQuLHZFdVaqYXUfkCgRA57zdPAZ5/v7VMq
         EWyWP2s9M1sug06ZEe2aYUu/jp9LLyGoF26ivI23sp55/f+1SoXoK5yd5AUd+m/fsrqp
         S/uEQU/OW1jWxpEJ7hp2vrWdvFtU7CoEetyx3raSX5Y9TlXItz04JXMvoEKVnnmP3pKj
         20gTExAr1kivfml75qp7wuaCzZjY2sBewLi21oMyC/GZ+jzy8qN4QUOa1o1zqulEuCkO
         2krg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rdh0Wx9Wru7j1tW5FzcgL1Yz1dikOnBOzhP8dIEjUFY=;
        b=IV6NO97yoXbXpwQ4+0jlzdDvkHFL6NzmnanY+cEVsfeevb52/0p6u+m6Ut6i9a12sn
         tTVPY0qerKIqh8rdOiToHxrvag3UwYHIPz513hqGBKY5dVAqXTljQ2ImAxsmSupIlGFz
         1iXQEvIbupDV781wd2lv4QP7UanWm1TjEc4GcAHIQWXw80FAyYK6/peV/owJ0OPxCT3E
         Lbd8rDLdPKNjDatRG9Qv4NaU244G3Qt2H+KHnZs3vyGvScWxbZiw3CB7wq0DgJshA1O5
         wv5KEZZ7Qe5D99yLrmWkowreRPDwU1JWFUL2hKkJCXIkRJyso8o+AWkGpkZZKWSYNBRA
         rtQg==
X-Gm-Message-State: ACrzQf0jtKz5eqZI6TNJK2lz0PefBFtu5zw92LSfB8UtuYLGlcVJHUrx
        G8va1Oghh2eHQLTM2sP8DltCYA==
X-Google-Smtp-Source: AMsMyM5+aD2B4OImBoE43h+r+v4FRLcu3sR20kddz+MPVhPwomhLMNi/iLGJPnqFDJF+xjfMNlQxog==
X-Received: by 2002:a17:906:eb09:b0:7ad:d271:e5aa with SMTP id mb9-20020a170906eb0900b007add271e5aamr27629684ejb.182.1667576450176;
        Fri, 04 Nov 2022 08:40:50 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f5-20020a17090631c500b0078128c89439sm1942874ejf.6.2022.11.04.08.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:40:49 -0700 (PDT)
Date:   Fri, 4 Nov 2022 16:40:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v9 5/9] devlink: Allow to set up parent in
 devl_rate_leaf_create()
Message-ID: <Y2UygD8UmjyaQ9l8@nanopsycho>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104143102.1120076-6-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104143102.1120076-6-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 04, 2022 at 03:30:58PM CET, michal.wilczynski@intel.com wrote:
>Currently the driver is able to create leaf nodes for the devlink-rate,
>but is unable to set parent for them. This wasn't as issue, before the
>possibility to export hierarchy from the driver. After adding the export
>feature, in order for the driver to supply correct hierarchy, it's
>necessary for it to be able to supply a parent name to
>devl_rate_leaf_create().
>
>Introduce a new parameter 'parent_name' in devl_rate_leaf_create().
>
>Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
