Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84FE443B82
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhKCCrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhKCCrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:47:45 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB546C061714;
        Tue,  2 Nov 2021 19:45:09 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id b4so1069594pgh.10;
        Tue, 02 Nov 2021 19:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xm3pFLJwHvJiS3bF97GIVP/+VZCNRpTK7zsKq+SCmyY=;
        b=HSo3jYVjRs/FTLbvMkxLXW3X9SBTx/wfZO/RtNhBVdgpOVVRKSmwFjb8/mdwfGLPBS
         4a7i7PALa4x8GGToyDrqC59dJvURwYTB8WcomwOVfmJXOvGP/uzFTZ+aba33HQRkVm5J
         yXNNzlZt6JQlpllUb6SlKZDhIuyv/XKiddvXnvAneMjEU2lpXk2HrgYlgGikMynQCONW
         G9IwK4WScjgRN08Ri0wnzAZQuyMJoOL5Xh9VWEJaaiahuFJF2ltTYgy2XajtSpD8xj3b
         wpjweEdPiAytM6TWsVuabPdjc3usP5KjDccK5CHwRdK5doVEHRyCipAd1TvBXSzrPrXm
         5EgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xm3pFLJwHvJiS3bF97GIVP/+VZCNRpTK7zsKq+SCmyY=;
        b=lwQ1U7RrXAq+kb8hhUEtVxLWyvNcc3oyubOBA9u5m6PZxa/qViqRKU/xiBINcoDOEA
         JpNIiCYqhmC6U4yZEmnRrRVGmqvsI+CDe8CMoWdVlLLYknDYEThayY0dZvdsPRA1E9G5
         TxiDhtd80VXl/arhVeER1pAU9r+9yKSyj/HOcUGRbvxCozgenj1CP9FSr6roNo3Ui4yD
         WrhpZ248Oo/2fUuk0uuQnTV09JS7Q+0NxIpZAjmTPvTdWTDqqaiKwWPl9W6rMLzGmQXi
         N2Kmd7uTP8RHKXRZcyAYzQVk1AkMMktEgyn8Yd2WjZ+AXib/DoK+jfLOA+1pbKj2Dpr4
         bKLA==
X-Gm-Message-State: AOAM5330Fef3GVUZDvUTy86l3QW2zESkdun2skcpzwolfaGHXMFVQ9gx
        w75dcp5yieLD2KQ7Wtgg1kkuTQCqpJU=
X-Google-Smtp-Source: ABdhPJxJFppNjdPwhOrbc3CHFlDQY7cfTBGFDCvEmPZ8Rlk3fBsCdypcFP2uP+l1r5IY2oMoYZoqeg==
X-Received: by 2002:a63:d756:: with SMTP id w22mr26505711pgi.281.1635907509259;
        Tue, 02 Nov 2021 19:45:09 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t13sm348088pgn.94.2021.11.02.19.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 19:45:08 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 0/5] kselftests/net: add missed tests to Makefile
Date:   Wed,  3 Nov 2021 10:44:54 +0800
Message-Id: <20211103024459.224690-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftest to another folder, some tests are missing
as they are not added in Makefile. e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

These pathset add them separately to make the Fixes tags less. It would
also make the stable tree or downstream backport easier.

If you think there is no need to add the Fixes tag for this minor issue.
I can repost a new patch and merge all the fixes together.

Thanks

v3: no update, just rebase to latest net tree.
v2: move toeplitz.sh/toeplitz_client.sh under TEST_PROGS_EXTENDED.

Hangbin Liu (5):
  kselftests/net: add missed icmp.sh test to Makefile
  kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile
  kselftests/net: add missed SRv6 tests
  kselftests/net: add missed vrf_strict_mode_test.sh test to Makefile
  kselftests/net: add missed toeplitz.sh/toeplitz_client.sh to Makefile

 tools/testing/selftests/net/Makefile | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
2.31.1

