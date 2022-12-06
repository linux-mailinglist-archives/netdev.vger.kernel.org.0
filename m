Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834D4644472
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiLFNU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiLFNU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:20:56 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837232BDA
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:20:54 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id n20so6246124ejh.0
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 05:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DaeNjBfchE4pQdNiv8Rds2AGox8Thm3h735naSDzry4=;
        b=NXd+tGq3IX9cbkpZZfA5U4Nmj76uyIgm6HEzdi6Orjb4+bdwWzUhYZ7JPbLHPoYFds
         V9eODvulkwoaq0RJHTwxzpMua9K7YFsUSt0cNmBt3aqR5Q4D1E2Ao/gyTLpWagZeAyVn
         Htf0oHFUZRQz3HrNo7LcOkxIRfJa1jbTpD8TCTZY1Oqftu1JvPRa3LeLJWLWfARFguMT
         dM/R/erblzIny3BFgVT0SoXfOelR0l1RP21fftz+8nqYRZjF0x5jqGAlKBhZz57RBb13
         mDtK7tKKLvq0zkC18FwjIChA7VgwxkB90FrjgRp3VKUZR3slL54LtJTmNPckkyhS5vNF
         ddkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DaeNjBfchE4pQdNiv8Rds2AGox8Thm3h735naSDzry4=;
        b=j8p9V0OLtJSygEZNdII1eS0yyG4LVqTo/DbY6/cAW3UCPvmWfXLtPlFhVju3we2Sok
         G0kvsLLYQQ2rxAfX0Fn8ZT9hDkCx50Hlb6nhGFqHDBxQzpM/tWTBg6LTniUQaR2atsON
         kpVeEv6tyoU3uykXqZFv5SLNuyxoEeMWW6ao7YNv7oXsnirVDEFIA3kEw6IWkVYPSzZV
         knqIjajE1ZAxjbqUhg1D7JV8kHfsX7BenyAp1Uv2oN/wPoddgO2gmbFrAe93CnBK+6JA
         /uNFeRcAWy5gMnXCpT4Ox4JAfywsJJ3AmNwww/3HdL4zfD1yAIj+LbvGSMTfx9ciUBwP
         9eoA==
X-Gm-Message-State: ANoB5pnyZGQyJ369Rvs5FnMkdxqFtw9JZ5E+9WHMyl67IkZ3HRzWLBK+
        jtyhs8FztyRDVPPfNmDuXMUOkA==
X-Google-Smtp-Source: AA0mqf7j8Icvsbj2qFcOfDyJvMlXdubV8qRsaWt19L4k8R5zJNIE7YHVUj4xZ2GuglsSkf83DmNb/A==
X-Received: by 2002:a17:906:3c12:b0:7ad:7e81:1409 with SMTP id h18-20020a1709063c1200b007ad7e811409mr73460577ejg.326.1670332852953;
        Tue, 06 Dec 2022 05:20:52 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i5-20020aa7c705000000b00463a83ce063sm947385edq.96.2022.12.06.05.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:20:51 -0800 (PST)
Date:   Tue, 6 Dec 2022 14:20:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     zhang.songyi@zte.com.cn
Cc:     kuba@kernel.org, lars.povlsen@microchip.com,
        steen.hegelund@microchip.com, daniel.machon@microchip.com,
        unglinuxdriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: microchip: vcap: Remove unneeded
 semicolons
Message-ID: <Y49BsMdBfkA/DY68@nanopsycho>
References: <202212051422158113766@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212051422158113766@zte.com.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Dec 05, 2022 at 07:22:15AM CET, zhang.songyi@zte.com.cn wrote:
>From: zhang songyi <zhang.songyi@zte.com.cn>
>
>Semicolons after "}" are not needed.

Cool. But still, you should be imperative to the codebase and tell it
what to do.

>
>Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>

anyway,
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
