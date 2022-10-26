Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E444260E378
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiJZOhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbiJZOhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:37:50 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ABAB6036
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:37:50 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso2759804pjc.0
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qshlrn/7P8U8o5NL/ql/XyA7iBxlSu6Y+RJl/Y030OU=;
        b=z2qi19yYiSHB7boZ1hQaJ4K22LHeUS1hQXBJKHsq3sbaAf9TO6jXjywhADJor/h2zZ
         HvY2I/su67CTZTWBmnTUAqTjMHbInH5LoBwtyxYqTa3lYtO4wyv/My9w7gSUdvv8fTHj
         zoDrN1GmSZ8hux5P0Uuo3aKvh/RWTc1f/0LO48k41jMBiP4gwig6R+ByZpB9FZZnv3j5
         OhJUqL2Ykyf9CVq/PUjGum+lxj3rh9a5re7dCMIJjukniAIpETT1vTgbVIou32oOyio3
         7GDK8AB4dB8/7Tu5Qs894PrhHXhS5oUMeRzdtjSO18sW4yAMRE1RrEkWEdy9L25pWCVf
         IynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qshlrn/7P8U8o5NL/ql/XyA7iBxlSu6Y+RJl/Y030OU=;
        b=spDl8P/OXHiDr90Xwlrhr8WYqY0jfPJeRT0hd5oMAbDDtn4E1R/aAdXN7LSilJ8eHy
         2figDAlQYPjlMRaWHIoFFNIKykKaTUh+cPP5ir9DHySB2l6EFHIRM3G5QE5cv39+YAsx
         0cZSht3pWqlk1Hu7Jz0wD2OhqQ8Kyd9hQA4GuVBuWQ0MXtJJEHHUrUkqWhZw/nNoZ90U
         btRjE7PAIjic6OJvD4wGvO+O+qn3KoYLxP4Y9xPS55Al5bxOrnglYsILVA3xB/FmyEKC
         6JDwTl65qHLeOckPRk42QsJZO3t9tmaTo5UQleW5zltJSG1HblNSbYlsRAcKALk+RVHL
         CB/w==
X-Gm-Message-State: ACrzQf3QbDpZh7nqPV7Wf+oBaFpaGOG2QeXRHbrNkwvi4rQJrqLJ5mQK
        WCCRV92y3KcxbdB/lAOBGPjuGQ==
X-Google-Smtp-Source: AMsMyM5ygqN/zcLTG266ob3zuF7owjRo3Z4Wer3zMTS1wISRq/rNr6KLifBZaDnUbTkWzrvGlwDutw==
X-Received: by 2002:a17:90b:350d:b0:20d:5438:f594 with SMTP id ls13-20020a17090b350d00b0020d5438f594mr4701440pjb.216.1666795069580;
        Wed, 26 Oct 2022 07:37:49 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id d185-20020a6236c2000000b0056286c552ecsm3060484pfa.184.2022.10.26.07.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 07:37:47 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 0/5] ionic: VF attr replay and other updates
Date:   Wed, 26 Oct 2022 07:37:39 -0700
Message-Id: <20221026143744.11598-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For better VF management when a FW update restart or a FW crash recover is
detected, the PF now will replay any user specified VF attributes to be
sure the FW hasn't lost them in the restart.

Newer FW offers more packet processing offloads, so we now support them in
the driver.

A small refactor of the Rx buffer fill cleans a bit of code and will help
future work on buffer caching.

v2: simplify call to ionic_vf_start() by removing unnecessary vfid arg
    remove unnecessary function return casts
    remove unnecessary 0 in {} declaration initializer

v3: fix up kdoc complaints in patch 3

Neel Patel (2):
  ionic: enable tunnel offloads
  ionic: refactor use of ionic_rx_fill()

Shannon Nelson (3):
  ionic: replay VF attributes after fw crash recovery
  ionic: only save the user set VF attributes
  ionic: new ionic device identity level and VF start control

 .../net/ethernet/pensando/ionic/ionic_dev.c   |  14 +++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   3 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  45 ++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 113 +++++++++++++++---
 .../net/ethernet/pensando/ionic/ionic_main.c  |   2 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  31 +++--
 6 files changed, 176 insertions(+), 32 deletions(-)

-- 
2.17.1

