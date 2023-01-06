Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342626603AE
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjAFPtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjAFPtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:49:50 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7467A92A
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:49:50 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e10so1391417pgc.9
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N4kwD0xGNEfM7SV5a5wxWT11H0xVVzVnjmR4NCYx5Ww=;
        b=ujytYLW4bfRC6RQ15okq7k7zCGI1k6hkOqu5YdkSzfFNuvYTFWKnXwbIPzW79mdnUt
         vruIbeqnwLNWF4GwrPb/75keRMdziACqxGXEeOyWVrxlOJRPo8ppetwmzPzek5H9mocd
         hpIVUAY5zuLywZpy8W2KYJMsA6g9TBLJIwEHQ7LrD3OQcRNRZnEcI6VKAtGx0N+HWq7G
         SJROOoZWE57OMCrHbOTxBVeP8OoKefjAKgiI26dyEM45qcjXyyllggwRQUixiN5sfckV
         KFAWJLRBVmXRz5mPkIXRawnAvk5TXtooctyekZaY49PL79A8grHWxuHq/esTVuWilS2J
         Ru+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4kwD0xGNEfM7SV5a5wxWT11H0xVVzVnjmR4NCYx5Ww=;
        b=hQFw9niNDBbkxDRJpzroZVcRZ4nSpGnKedaPgzv8L0IAgW6WrSyuXUwzj8Lko4LIqw
         SE3FjqQnWxTga09KIOQRe5VFfs4XBim18KTqHeqTax44NNdchc8E3GOVtiE6KAr8qlX9
         w95DzKUZvZdu+d+aQsYawZj+vVkTcZo6zzJhciwUxJDtuK+rFO+gz1gtZ2ewYpICK/ge
         Qlpwy/10hIizSU378Ynu6Ptf0UBixn/xMiVFch5IUwHycD8rd+dU1gWNmGwhrEHmC0YM
         qETvSz8mp14m+5iRducVIgdlC8Gb8a9q5cJjK8ewe/vg9u1ooqKat87boklT96e3Tdwf
         nwKQ==
X-Gm-Message-State: AFqh2ko34fQAV4iwewWy1mrJq7BWhZ6P+EhSLXctzx0f1DB/v8Y4v+C5
        3TD1DQudydLdUjAlmJ27078DpA==
X-Google-Smtp-Source: AMrXdXvvaJnSWo7IuUsuG2D/BgLVIZFHECbm3vGm1E9Ee6pInmXGgSvZIkkosSAW0NGAClPWlcoWFA==
X-Received: by 2002:a05:6a00:d4e:b0:581:a2b6:df19 with SMTP id n14-20020a056a000d4e00b00581a2b6df19mr30124189pfv.14.1673020189696;
        Fri, 06 Jan 2023 07:49:49 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id x28-20020aa78f1c000000b0056b2e70c2f5sm1310533pfr.25.2023.01.06.07.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 07:49:49 -0800 (PST)
Date:   Fri, 6 Jan 2023 16:49:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 0/9] devlink: remove the wait-for-references on
 unregister
Message-ID: <Y7hDGnDcjVKDSuHV@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106063402.485336-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 07:33:53AM CET, kuba@kernel.org wrote:
>Move the registration and unregistration of the devlink instances
>under their instance locks. Don't perform the netdev-style wait
>for all references when unregistering the instance.
>
>Instead the devlink instance refcount will only ensure that
>the memory of the instance is not freed. All places which acquire
>access to devlink instances via a reference must check that the
>instance is still registered under the instance lock.
>
>This fixes the problem of the netdev code accessing devlink
>instances before they are registered.

Nice work. Thanks!
