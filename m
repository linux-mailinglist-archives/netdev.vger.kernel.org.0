Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52CC66001A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjAFMRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjAFMRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:17:23 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E632CE54
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:17:21 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id n12so1347191pjp.1
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xoQe/Yt0sSeKLILjWIQ4DrEJ3c1zI5Ak6yRGJDwht9Q=;
        b=RbI3xzvtF7lRmok3Nupaddgz0DhM1Dw7sik00w3r7a/2IvVr9SqMA0mIcZxDpWxZBd
         lJ4/UTUkJWjLowig0fCSfXYLyhPXuYQ1KTFw5Tg5MeTAH2pbi2wRJBFJ+Eb1oU00cdg1
         8SfUy9c9k27RFyj1LsW7xGMwF0om3dFmBkWwjh89PHk6KT/Vm0AP4fhITe21Av/HTHje
         ux9oElTeTezyTMpGJ2gSNEWN4flWbO6sv+9kF/Wnuf2/9f6laCVvS5CK4pLduLSLEO1T
         CM06P8nT96LJEnI0vuxpOyR3t0h74omzldZkpRTEu53NhUQncSb7BXWZMx5cMyESGDWZ
         pSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xoQe/Yt0sSeKLILjWIQ4DrEJ3c1zI5Ak6yRGJDwht9Q=;
        b=PbUTwpqig/Md+pDF1SsBoWt4VQhdcIv8sYxfPxzFoc19pyWQKDKcFEJEcph0swJ3QC
         /QMViy+RWWQvZWkWC+IPsWMoCrgouIgKKstCKjEToQJZLcMJI9x32r2BkNUdfY1LN7/+
         3Wa0eFK5k1GxSo7LJ8klTKyarHVPenYopEySPvbvqUrQwTx679vaBoEaNRwJGAn0+I+t
         VCzw7b+bESxsgW7bXaNXqYFBXmBrgSdAuJAEAy9P6S7z+ef4u2q8zlm97Kfi56xwsAUn
         A0GPdICW9WId7sd5fQS0le/Z4Ja+135smaL6+f/Gr3EV5/7U1DPe7i4CuT5Zc+B8P3vM
         2Nhg==
X-Gm-Message-State: AFqh2koEPrt7vx/4uOEWBbW6yt38A9aIsDx6V6k081wgFVZ08ew6TuC5
        JFTj8AHnMAWaH3OxOrNAYXbVMg==
X-Google-Smtp-Source: AMrXdXtNV3vtAdnJ7OSq/9pNULC2rcxgHBo6swmQrI+32nS7zdhjbYqlHyLQAk5fRgk2QHaa6FHqIA==
X-Received: by 2002:a05:6a20:1586:b0:ad:5a5d:3571 with SMTP id h6-20020a056a20158600b000ad5a5d3571mr83845749pzj.4.1673007441391;
        Fri, 06 Jan 2023 04:17:21 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id b29-20020a62a11d000000b00582f222f088sm1005733pff.47.2023.01.06.04.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 04:17:20 -0800 (PST)
Date:   Fri, 6 Jan 2023 13:17:18 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 1/9] devlink: bump the instance index directly
 when iterating
Message-ID: <Y7gRTj3Dfwp/HYUm@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106063402.485336-2-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 07:33:54AM CET, kuba@kernel.org wrote:
>xa_find_after() is designed to handle multi-index entries correctly.
>If a xarray has two entries one which spans indexes 0-3 and one at
>index 4 xa_find_after(0) will return the entry at index 4.
>
>Having to juggle the two callbacks, however, is unnecessary in case
>of the devlink xarray, as there is 1:1 relationship with indexes.
>
>Always use xa_find() and increment the index manually.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
