Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CCD583AB2
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbiG1Iwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 04:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbiG1Iwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:52:43 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4426065570
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:52:40 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id b11so1974268eju.10
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FqzBIpco+9REM7U8y6zxhn5MuMhFRGjp1tpsdxTGmUY=;
        b=mzGclTVD9lpKjBkPUykLcQ+rSqkbUkytAJ+sD2aaFOi7GO+aDgVHOAlQRqL964v6vh
         uF16IraKaOrLEWpUx54sDlwZuLEqVCxeljxJOJGcieVDfNKmns4I0slukPBZMb+QGGHE
         6RMqaaF6kVit3AOYq9Iqrbf+Xo2VZXjUxp33KaOq6eHlDSkeI/cwLAHiLrjDGtS2F54T
         Icc7qR/puV1KslGo+AsKKHBwUNeFJ4v7qBFHQxvVgUVUgYRtPdFHQSRsBcslSnJje1PL
         E+nlTuHPvSBuBHoYK9hOlx7m8BbmqTSqhZg+G9w/sdf5fBOSufYDagCYs4ymtbxuGxyo
         QC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FqzBIpco+9REM7U8y6zxhn5MuMhFRGjp1tpsdxTGmUY=;
        b=PAcsBxOOZoaLdAxAPMR/0wByy1RyS27EXOXRlYEAl2tDp84c9PxUtro++E50duxeJA
         wtZVpvoBe+f8s0xnu2905AHNOjy29mTj4jjcoO+m38G346nA+5K9rqpVrt6tyRGto3wt
         q7dA/VKmEYAj/V01csruyCCdC9BemBEXqycWgyi2qB0jZT+tKXs2khtwkMjdCyanfk9Y
         qQ5f0kiZonn/LEjuLEufNw1yEM6l/rNCKsvnQl/95vlcoMSyNGszOgQZj7TLUXnE4rcG
         sp3FnKIyCNAZtrBzQarJt2Yg+0FSSMYrA8ljoI+SIa2bYBBPbapNoOLTXWujyqp2PjRR
         8f6g==
X-Gm-Message-State: AJIora97szUgqXWHGrBT/l7VTgH3k/m44vlRwFv2OEw3+p31Q2UYnpWz
        f8rl+6b2A0C+COlimsU5Mum4Rw==
X-Google-Smtp-Source: AGRyM1sT7c6royvlZEvWdPGOb4u+ZmgK75s4K99kon+7UeMAqkDFTZ3CaoPjZ8h68taMGjTu+cTKnw==
X-Received: by 2002:a17:907:a428:b0:72b:6932:2ec7 with SMTP id sg40-20020a170907a42800b0072b69322ec7mr21005469ejc.540.1658998358568;
        Thu, 28 Jul 2022 01:52:38 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o21-20020a1709061d5500b007300d771a98sm165637ejh.175.2022.07.28.01.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 01:52:37 -0700 (PDT)
Date:   Thu, 28 Jul 2022 10:52:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v9 0/2] add framework for selftests in devlink
Message-ID: <YuJOVOrAkb6c7ZGG@nanopsycho>
References: <20220727165721.37959-1-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727165721.37959-1-vikas.gupta@broadcom.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 27, 2022 at 06:57:19PM CEST, vikas.gupta@broadcom.com wrote:
>Hi,
>  This patchset adds support for selftests in the devlink framework.
>  It adds a callback .selftests_check and .selftests_run in devlink_ops.
>  User can add test(s) suite which is subsequently passed to the driver 
>  and driver can opt for running particular tests based on its capabilities.
>
>  Patchset adds a flash based test for the bnxt_en driver.
>
>  Suggested commands at user level would be as below:
>
>changes from:
>v8->v9:
>    Only SOB line fixed in 2/2.

If nothing changes in the patches, you should retain the RVB tags from
previous version.
