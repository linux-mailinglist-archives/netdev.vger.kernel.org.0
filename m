Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC2746E89A
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237490AbhLIMqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhLIMqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 07:46:10 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42915C061746;
        Thu,  9 Dec 2021 04:42:37 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id m19so3652544vko.12;
        Thu, 09 Dec 2021 04:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B99doplKMhCF3/NI+gmHfnS9FII0vd0OCqQprdWAKGw=;
        b=cyf0yHemDemISmOvVy+aopA4fi2LoydNrrkxsO/dk0BXNerSGHZF509VK4BHayIJjC
         fUfr2j+YMMMPHDeBH8Slw8ikVrUcpZnHS6gqeo1XIVLKf4DacsGXUhNxkCY7MseMjWOS
         GyuiRvkTFtEKcloYUUWM2yYtnR6N0uiinPu1Es0L0nN2ChPWZR91l4O7HcsD0wPQNJT/
         B4Sj7abwy8G9NORm28sAlu1S61ejA3KyRlUigd5JR1HselBFQNlUXVTMLMlvKPGuNVVu
         MiW380fJZ/J/1VRrffTnQupdJqCfrn+jUkJNcDEWOQsnesUlZyFYcwp25G3SyPrxwKED
         IB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B99doplKMhCF3/NI+gmHfnS9FII0vd0OCqQprdWAKGw=;
        b=6s5ddKTtVJVv8xzJlnB9ejWOr7lMZw8A7buBWLQuivCeeNtGglcYFEGBbXhiXg6e5e
         r5VghTD2iFgTdj9tjgFPfwSTJOAPaXjeljGkAqM4RGKqU8t9xcqrw5NoU5GhvcKcBZZy
         livRW0L+3eOmovaOyzmuEEX/MsgTa+uPA4ycAlz04G1BZooJuScEp4jDZKEIli4EYdnP
         qnfDgMXn6cWUu9Dcg+rcAjCVqwq61rz4SuZoOApD9K8atuXxNhVwa9yeujrJwtzkfhXV
         4EmLxG+Mm+UeE2+7CYo7Ao0om5u54HefIX4438OZbqAHxMiptSCTCrkPfEz0TZ7xiIL0
         sA7Q==
X-Gm-Message-State: AOAM530KyKZXH94WMysmI7tjg6BKtgLqofokFNdRYuuNkf1zsTqoLdKW
        n9YYk9SIka1yA2IW7dpju5w=
X-Google-Smtp-Source: ABdhPJx3lgyOD6ZeYYjqxmbuMSNvFbZ+0T6h79BGDGCI48zAjIY0NPzSMHB7GiHOIv4UE5mMT2mTKw==
X-Received: by 2002:a1f:cd47:: with SMTP id d68mr8595660vkg.33.1639053756428;
        Thu, 09 Dec 2021 04:42:36 -0800 (PST)
Received: from t14s.localdomain ([177.220.172.101])
        by smtp.gmail.com with ESMTPSA id t5sm3810985vsk.24.2021.12.09.04.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 04:42:36 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 43C72ECD4C; Thu,  9 Dec 2021 09:42:34 -0300 (-03)
Date:   Thu, 9 Dec 2021 09:42:34 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] sctp: Protect cached endpoints to prevent possible
 UAF
Message-ID: <YbH5um3HVQbSecx4@t14s.localdomain>
References: <20211208165434.2962062-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208165434.2962062-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:54:34PM +0000, Lee Jones wrote:
> To prevent this from happening we need to take a reference on the
> to-be-used/dereferenced 'struct sctp_endpoint' until such a time when
> we know it can be safely released.
> 
> When KASAN is not enabled, a similar, but slightly different NULL
> pointer derefernce crash occurs later along the thread of execution in
> inet_sctp_diag_fill() this time.

Hey Lee, did you try running lksctp-tools [1] func tests with this patch?
I'm getting failures here.

[root@vm1 func_tests]# make v4test
./test_assoc_abort
test_assoc_abort.c  1 PASS : ABORT an association using SCTP_ABORT
test_assoc_abort passes

./test_assoc_shutdown
test_assoc_shutdown.c  1 BROK : bind: Address already in use
DUMP_CORE ../../src/testlib/sctputil.h: 145
/bin/sh: line 1:  3727 Segmentation fault      (core dumped) ./$a
test_assoc_shutdown fails
make: *** [Makefile:1648: v4test] Error 1

I didn't check it closely but it would seem that the ep is beind held
forever. If I simply retry after a few seconds, it's still there (now the 1st
test fails):

[root@vm1 func_tests]# make v4test
./test_assoc_abort
test_assoc_abort.c  1 BROK : bind: Address already in use
DUMP_CORE ../../src/testlib/sctputil.h: 145
/bin/sh: line 1:  3751 Segmentation fault      (core dumped) ./$a
test_assoc_abort fails

1.https://github.com/sctp/lksctp-tools

  Marcelo
