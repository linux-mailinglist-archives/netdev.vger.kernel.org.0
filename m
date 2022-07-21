Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E207F57C404
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 08:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiGUGAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 02:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiGUGAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 02:00:22 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E1B7A523
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 23:00:02 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id x23-20020a05600c179700b003a30e3e7989so248572wmo.0
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 23:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7OKacVE8hhVc+YL/joMwbiRK3zn2jMskpw9Aih4Kqk4=;
        b=fUCYUaU2RUuAnuFHHActrWP1EPytPIzlV3PBx6xK8P2JKg6oMWHy8saLQtGzwhWSkP
         op/j9ctcjF55qBpsd1PltMQO1icHykNWjKJLzBH8ls+rLqSenUuAhNuJLnk0WZgt/zi6
         xmYAho+zkqmWH//2Qf7qiP7g6srt9HRLILIK72OZkAweBpZA5ciO8OZoTFpOLIXJ+0V/
         i04V+k0qJwpIejxStccd08YrOwACD2JEkOgCnO74znfK3iplP7meR1s42eTrM1Tw330U
         RUGXF/vGcSPTFLcOZSnrdX9dtNGUv2p57kV0fSIA9TM4JQrAp4vfeXqRF0h+sePkn8Yh
         iJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7OKacVE8hhVc+YL/joMwbiRK3zn2jMskpw9Aih4Kqk4=;
        b=ARNJxh2nISm2kCDa5L0QSGfIx2AN+x5xHySXmfwI2NAhqn3Ls22hOqMtVa58k/xcK/
         hf8r1gPIHvKQF426l9xujxXWWI9GxZeZdnY5CsMx5spveUPdG29SuXbUwzLQwriJ+lJQ
         ntvZHHpjIxJyyfqKrVMC/lkrccd8cghMx4tURyu+6yJ2U6OqXXl/a8U/urYYOOyfDvet
         U4EIH5xo2zlkRUYCp7KR+uxp9luHEQcxGVaB/G0/GtUd59VEwuUCv8vd4OJKU4EG+a7n
         xbukGIDBHddtZcxBOvVKAVnCNGWdfmv5DCf6BYoHTdAMNuNS/+gVeWyGi5TRw0kbL4yJ
         KSkA==
X-Gm-Message-State: AJIora/Vt330PFFp3lm1/vXjFjn/8Ugroer6wK9ZxR8YLa5f4XTk57GA
        1K5O3gYLu5VYDMUk3mQQymTXVA==
X-Google-Smtp-Source: AGRyM1ug+oligV9o9bLZsz0BB+ZZcQW/teUsiRniDVHIJO6cgD1hyP9oXvg5lrzXKGQMKQIb453TMg==
X-Received: by 2002:a05:600c:1548:b0:3a3:2896:6b86 with SMTP id f8-20020a05600c154800b003a328966b86mr5765910wmg.109.1658383201352;
        Wed, 20 Jul 2022 23:00:01 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k13-20020a5d66cd000000b0021d888e1132sm813127wrw.43.2022.07.20.23.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 23:00:00 -0700 (PDT)
Date:   Thu, 21 Jul 2022 07:59:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [iproute2-next PATCH 0/3] devlink: support dry run attribute for
 flash update
Message-ID: <YtjrX7fGD1egQcXj@nanopsycho>
References: <20220720183449.2070222-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720183449.2070222-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You are missing iproute2 maintainers in the cc.
