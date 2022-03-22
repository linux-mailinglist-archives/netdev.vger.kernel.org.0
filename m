Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CE24E4815
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 22:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiCVVJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 17:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiCVVJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 17:09:10 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B066151
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:37 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v2-20020a7bcb42000000b0037b9d960079so4139720wmj.0
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DyfX+ImwpyLQbZQr2Zygm4V+RaFhNJWViCq3pXT6Mzg=;
        b=sYceid/4EdWSvvLSVnVy8vZwS74UEPn03DZXJIehRfm3dR3QKyDuAgODV6zIXf8C4S
         6hXRO2ybXuKMSn71pqibtPmJ4lwIqL6B+LAkdEGcLlFtoqX0gcyq2B0nFl9GXccvwWDs
         d1gw9AtuYMWUpQD8bF7Nszd/m/HjSfP9GWgfSXJyBbWoieGgUzNQYpU+I0z5sQBnWoBW
         f+WqfyadaIz1vuy/Aglf2AaD/PA3ccvv6rQpQj0WCUUfcih6Hu3oAKZLjxxfa7viRKUT
         j/4G5O/Uu3w4d9j8qQFxcsN2VvIxJPjIuEnWqMYNvBfEZUPbuMTbGlSnR7zldXx3cfME
         y4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DyfX+ImwpyLQbZQr2Zygm4V+RaFhNJWViCq3pXT6Mzg=;
        b=76hPlpM5kJjfhKgCktizwcdoRHnN78o5NHh1SWuDsWAxE9LRWVJmmpg2VK6lA3KNuJ
         VicRnnu3k8p4CiqaciCiSwDrc+FkBx7lp7r9B93gn//xsb2QxTOnfXoCI5oZPlykm1XR
         CwwXAuZ0Lhiv61i46G8Yl+sVW65tIjhmmKiKvOnNhzaBxMmB+Nc1Zg669N7ve4gs1rTS
         VB14eUYRvVjAqQeNnFNTNeVylaizRFmbg2MzU+he2vz7fSAfDkVNfdBgXuIm94WrdZ4l
         rA9B+UxungZCUqeILksDNptTik49fCmiBp+RxGz9FBcGcm0wFgWeWUW3b+HjLP7MQQS+
         nFwQ==
X-Gm-Message-State: AOAM532BhZjoS5c7f8wlpzZu5G3RqZDJ/b1+2/+j0wkZhB04fFBFFRqP
        4R5oL65FP3c06mSUEudC+vtb21D7SnrOFspp
X-Google-Smtp-Source: ABdhPJy6e8vIxJR7p+T0xHPAPMUqgEUqd6wvpXL8CrynN9Fw4if1a+szqerAzesAlgmGrWHlaicIgA==
X-Received: by 2002:a1c:3bd5:0:b0:38c:9b9f:1b24 with SMTP id i204-20020a1c3bd5000000b0038c9b9f1b24mr5761781wma.129.1647983256169;
        Tue, 22 Mar 2022 14:07:36 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id c7-20020a5d4f07000000b00203db8f13c6sm16281805wru.75.2022.03.22.14.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 14:07:35 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v1 0/6] ptp: Support hardware clocks with additional free running time
Date:   Tue, 22 Mar 2022 22:07:16 +0100
Message-Id: <20220322210722.6405-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp vclocks require a clock with free running time for the timecounter.
Currently only a physical clock forced to free running is supported.
If vclocks are used, then the physical clock cannot be synchronized
anymore. The synchronized time is not available in hardware in this
case. As a result, timed transmission with TAPRIO hardware support
is not possible anymore.

If hardware would support a free running time additionally to the
physical clock, then the physical clock does not need to be forced to
free running. Thus, the physical clocks can still be synchronized while
vclocks are in use.

The physical clock could be used to synchronize the time domain of the
TSN network and trigger TAPRIO. In parallel vclocks can be used to
synchronize other time domains.

One year ago I thought for two time domains within a TSN network also
two physical clocks are required. This would lead to new kernel
interfaces for asking for the second clock, ... . But actually for a
time triggered system like TSN there can be only one time domain that
controls the system itself. All other time domains belong to other
layers, but not to the time triggered system itself. So other time
domains can be based on a free running counter if similar mechanisms
like 2 step synchroisation are used.

Synchronisation was tested with two time domains between two directly
connected hosts. Each host run two ptp4l instances, the first used the
physical clock and the second used the virtual clock. I used my FPGA
based network controller as network device. ptp4l was used in
combination with the virtual clock support patches from Miroslav
Lichvar.

v1:
- comlete rework based on feedback to RFC (Richard Cochran)

Gerhard Engleder (6):
  ptp: Add cycles support for virtual clocks
  ptp: Request cycles for TX timestamp
  ptp: Pass hwtstamp to ptp_convert_timestamp()
  ethtool: Add kernel API for PHC index
  ptp: Support late timestamp determination
  tsnep: Add physical clock cycles support

 drivers/net/ethernet/engleder/tsnep_hw.h   |  9 ++-
 drivers/net/ethernet/engleder/tsnep_main.c | 27 ++++++---
 drivers/net/ethernet/engleder/tsnep_ptp.c  | 44 ++++++++++++++
 drivers/ptp/ptp_clock.c                    | 58 +++++++++++++++++--
 drivers/ptp/ptp_private.h                  | 10 ++++
 drivers/ptp/ptp_sysfs.c                    | 10 ++--
 drivers/ptp/ptp_vclock.c                   | 18 +++---
 include/linux/ethtool.h                    |  8 +++
 include/linux/ptp_clock_kernel.h           | 67 ++++++++++++++++++++--
 include/linux/skbuff.h                     | 11 +++-
 net/core/skbuff.c                          |  2 +
 net/ethtool/common.c                       | 13 +++++
 net/socket.c                               | 45 +++++++++++----
 13 files changed, 275 insertions(+), 47 deletions(-)

-- 
2.20.1

