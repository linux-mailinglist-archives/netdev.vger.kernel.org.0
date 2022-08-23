Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A673059E86C
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343631AbiHWRBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245753AbiHWQ7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:59:11 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3632C12C2;
        Tue, 23 Aug 2022 07:13:38 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso9662790wma.2;
        Tue, 23 Aug 2022 07:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc;
        bh=bqjGhCzqJoRd5SclG24HkMY2cZxZIgAn3sZCXv9qqK8=;
        b=X5TgaS79xM4Tzn0iH9DHyEFdlS7s2169NrwW03futdoc7NII01gXMmgzXDJehfT3BO
         IcBc9jgZNLxtiei8i4ahqLlzu92n0RwXRiv0hSO9ZQkvtsILA0eXo0MJUnsTtbJ2MxkJ
         ktWFItgm1j8aZZRgZzXRANBHLdkdLBJEXuv63473cvXVwi+O5AohRM42HvgPGUiS0en0
         I5J5eFSoJZpySYUkZ/dx8YDxdurAFZf5W+3CpZMvtn2TYLol5Z+Hn1xYqSNeJXf+CKap
         f9/P2zw5wSv6vA2dNjGHZCJUocuKnm627WK/HPl1sgWSRGmgLb/3PM8MeqGdGkR+rlZO
         64Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=bqjGhCzqJoRd5SclG24HkMY2cZxZIgAn3sZCXv9qqK8=;
        b=7hs1UvlBp3/EClRlSUCjvYDkDnEKOTx/jP9BgmY0DWVZn5HndAOGt06qiCtXq9TiIO
         p6YnB5+O2eomBuVYaiMi9rMkQIlMxuPazJOkzFNaxSBkZ2WvMvJBMurUwvhrVQFwBhgP
         12QgaV5uJALAIgYaO1+TquWVfdZ5DDqr4Me8IIoQ/qBMF153R5KYn0vHHRBLn7iKeIO2
         yqNkqE972skLQFKLEL+8S2HMad0tq5i/ltKsWdEKJx4eXr8f0sM7vf1VcTSRq6YCO67T
         5cgVaeLq6mR+wRHxbK1uUS5pL6yop1hhCKttB1jvUNHPWQHKsjsgl8UsqRDfx+erFAtN
         btcA==
X-Gm-Message-State: ACgBeo2XOTHDoCqOuqjxaBEwhZU3kbXe+qt+WyeQgDSZafpog3QwKmVu
        nBjwbYaj8sQQ2pqhCHWVeY+8+UK3ZyY=
X-Google-Smtp-Source: AA6agR5QoEDFu44MK68GarzKjy+3LspY+kSVsjSJj8GYqXzXFdcFwjEpCsI4HJJdHhX/+mVOyaNafw==
X-Received: by 2002:a05:600c:58a:b0:3a6:4a1:78d1 with SMTP id o10-20020a05600c058a00b003a604a178d1mr2418266wmd.78.1661264017372;
        Tue, 23 Aug 2022 07:13:37 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id w7-20020adfd4c7000000b002216d6f8ad6sm14251748wrk.2.2022.08.23.07.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 07:13:37 -0700 (PDT)
Date:   Tue, 23 Aug 2022 15:13:35 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Ravi Gunasekaran <r-gunasekaran@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: build failure of next-20220823 due to d04807b80691 ("net: ethernet:
 ti: davinci_mdio: Add workaround for errata i2329")
Message-ID: <YwTgj0bcMhVhxqlY@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

The builds of arm davinci_all_defconfig, keystone_defconfig and
omap2plus_defconfig have failed to build next-20220823 with the error:

arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdio_remove':
davinci_mdio.c:(.text+0x200): undefined reference to `free_mdio_bitbang'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdiobb_read':
davinci_mdio.c:(.text+0x824): undefined reference to `mdiobb_read'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdiobb_write':
davinci_mdio.c:(.text+0x8d4): undefined reference to `mdiobb_write'

git bisect pointed to d04807b80691 ("net: ethernet: ti: davinci_mdio: Add workaround for errata i2329").
And, reverting that commit has fixed the build failure.

I will be happy to test any patch or provide any extra log if needed.


--
Regards
Sudip
