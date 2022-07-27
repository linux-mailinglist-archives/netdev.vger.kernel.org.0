Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21495826A8
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiG0McV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiG0McE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:32:04 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC67E15A1C
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:31:13 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h9so23995094wrm.0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=erHrsw6rx2cxfDpAMMFXOYwGx+RlIoQlrWv6VPVmqBU=;
        b=X4H2JEkXIQu3OQs6tWn6bmgy4abRbCGKqwr0by640V4rrKsqjeBGPm+9LapHJh++la
         caZ/PlWKaU03cxkIL8jgtKTTVgtHtVEksTzmDATeIK5LQFzF47B+tUsn4V7lfqNcfzZ5
         hXqpe9A6T7++B0E90IOQ2b/iIWf0HQYYDznWZXpr66t4opRQiOZTzfX9ycveVY79yBuy
         /TNrXpYzJikxH7Xi5sgOnl51E8VAkSNCKVunHMpPuODAcul5c44prgRD/v4xhyUwVD+H
         MzvEChIVgGT7LCJdfbX8hBA9W9dHCAhdx2fNhGGIJ0mMMsqWWPmBXjSe1DdO+wrl7btX
         9e+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=erHrsw6rx2cxfDpAMMFXOYwGx+RlIoQlrWv6VPVmqBU=;
        b=qe45K75VjhX87ME3kSkuZgArmPwLLbo6Lsqy5kJdRhdCttUWzMfMwjAxtwhWMp5Syb
         EIX7BRGRlsZEPHcVwerNTM/ZOms/s829oxEaxlAAR459foM60svCTg/5OCntFSHrjT7v
         +Z6MTghTlWvauQSfpuDE4VFjKH/icm3ThJS9V4KI6vwP4ZObRL8V67vvrs6QWnhzeq37
         LJqgS8VS1srGazsoEcpndzpqJrqqHs3MJPRnmMvTMyohgWPh0+SCa2lPJS4ZsDU7Qdah
         LVMcYZJSmdCSzxPix3j59mqxu3vQ8wbOyoTHh3eNkLz4WvmD9jNlssFWAk4cWQjMC3Bt
         tOdQ==
X-Gm-Message-State: AJIora9nhyRx7CqYJclVCGDONFbbiyFnuhHoZVvt8s1/UT1s9krKdx24
        6roKULm+lpNI6HHLWLtyTBTjkg==
X-Google-Smtp-Source: AGRyM1uinvlsoh897/QB1bvZSH8+ZWjX1NMSYI1/GyMvRcbtmknUzQnJsv8nyud3rCEMUQX+9GWJ1w==
X-Received: by 2002:a05:6000:2aa:b0:21d:ac4b:95af with SMTP id l10-20020a05600002aa00b0021dac4b95afmr13898546wry.479.1658925070708;
        Wed, 27 Jul 2022 05:31:10 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s2-20020a5d6a82000000b0021eb70e5edbsm3184388wru.97.2022.07.27.05.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 05:31:09 -0700 (PDT)
Date:   Wed, 27 Jul 2022 14:31:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v8 1/2] devlink: introduce framework for
 selftests
Message-ID: <YuEwDO799IHKNoUa@nanopsycho>
References: <20220727092035.35938-1-vikas.gupta@broadcom.com>
 <20220727092035.35938-2-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727092035.35938-2-vikas.gupta@broadcom.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 27, 2022 at 11:20:34AM CEST, vikas.gupta@broadcom.com wrote:
>Add a framework for running selftests.
>Framework exposes devlink commands and test suite(s) to the user
>to execute and query the supported tests by the driver.
>
>Below are new entries in devlink_nl_ops
>devlink_nl_cmd_selftests_show_doit/dumpit: To query the supported
>selftests by the drivers.
>devlink_nl_cmd_selftests_run: To execute selftests. Users can
>provide a test mask for executing group tests or standalone tests.
>
>Documentation/networking/devlink/ path is already part of MAINTAINERS &
>the new files come under this path. Hence no update needed to the
>MAINTAINERS
>
>Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
