Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AE04F74E6
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 06:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240745AbiDGEov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 00:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240737AbiDGEoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 00:44:44 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318BBA27E6;
        Wed,  6 Apr 2022 21:42:45 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ot30so8264146ejb.12;
        Wed, 06 Apr 2022 21:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=acLDo8DvtRc0LQ4dU1pQe3jeqr8dn2AMIrJhaE36LaE=;
        b=biNJItkBtuQUq6sxZIIxp09bvf7hkNQiHphB1nIIZ4XtB8D4ZGXySxYoNxEgkyw+w1
         VcKHiE3ojnprf43+FQmNutvBiY4rkEYqYNb99n6q9k11DykIJ9xholkyS5X136ShJJIh
         fTx0at4QB+dIxFHcqjN0NjcyzM3s2KfylT3vMd02aLAkXuIcoz7e6rVC0RuxUF56YHey
         o4yB9XNladBaLfx8WCINT3UI5X32sEUkw7rec9IakYK89wsGVl7Zlhjzt7munQ/TCYYa
         mf1rrGEvVOvfKe3jeTGi7olvXRQwMdJqIonZh3lokeTZCrjUOuzlpfL1SDGQrJsZrtBY
         ZwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=acLDo8DvtRc0LQ4dU1pQe3jeqr8dn2AMIrJhaE36LaE=;
        b=c4S9bA5SPUKRHYxAU3NcP3lHYoh+MgveVT3zmEi8cyI8ZkS9ENefjX0FXqrSOyjxs1
         M8I9LzGuX8xnS6UdBnhg5GOyyeCUqyB2h1RnMhXEWUr/IXuBktaKiWcd13UwVoUOFers
         XqtJFw5tL+8HhoKiqJzICICdQ/897WSZypdw6rGsRwsGyDw4URWHG1ySo0tLEF3nFAf6
         rpOL2yRBiStZzJmxTlrJ8H13r397qMSGC6ELTwXj1NlVu7qUcdoEnO33zGA6cCeC5Zta
         4fj3WQ+veTTAGmDGZ6Yat9a4LO4b4zGGUlDrWf/3Kd1Wtiokq/aHdkLS3ZHN/ki6Omwi
         0d0Q==
X-Gm-Message-State: AOAM532iUiJVX2IdHpxyZ/whSfD0D9VcrSsRO5KWjl6JkAgEBHFT7Sfp
        UFWrmLuVa3pmUDonFSKFvwE=
X-Google-Smtp-Source: ABdhPJzdPACgzyhMOYJVL/u/+HkvrlNZrm1s76+STb8mPZmG4bVbVeDYJmfD/ZDL+vp5iXueEEhCGQ==
X-Received: by 2002:a17:906:6a1a:b0:6e1:87a:151f with SMTP id qw26-20020a1709066a1a00b006e1087a151fmr11291245ejc.715.1649306563752;
        Wed, 06 Apr 2022 21:42:43 -0700 (PDT)
Received: from anparri.mshome.net (host-87-11-75-174.retail.telecomitalia.it. [87.11.75.174])
        by smtp.gmail.com with ESMTPSA id e3-20020a170906374300b006e7f060bf6asm4199455ejc.207.2022.04.06.21.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 21:42:43 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH 0/2] storvsc, netvsc: Improve logging
Date:   Thu,  7 Apr 2022 06:40:32 +0200
Message-Id: <20220407044034.379971-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two small (and independent) patches to augment and "standardize" the error
messages.

Thanks,
  Andrea

Andrea Parri (Microsoft) (2):
  scsi: storvsc: Print value of invalid ID in
    storvsc_on_channel_callback()
  hv_netvsc: Print value of invalid ID in
    netvsc_send_{completion,tx_complete}()

 drivers/net/hyperv/netvsc.c | 8 ++++----
 drivers/scsi/storvsc_drv.c  | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

-- 
2.25.1

