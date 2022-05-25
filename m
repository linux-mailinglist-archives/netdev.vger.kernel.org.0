Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34F2533579
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 04:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243703AbiEYCvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 22:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243713AbiEYCvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 22:51:36 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2D215A33
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:51:31 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id s5so15578615qvo.12
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Eut9Hh+Us/VNbI9IiG/v+1Zbk7zdy/JsgTvi+Ivycjc=;
        b=UJv5gttjYXjenDyw6EaaIDiUmihQl7eFVdKj8chQPfn0HnaZUSZ9ystOHN+gGI+Jq+
         bLFDrFgorPRENftvhGkY2B1dScTawjdH71PfR/Bm0Jq5e2w4UXjggW5Q7iaFk2rdT1ir
         e2F0g/HDzOvxe4pNqY612Z0jRdGAf/w069w9v5r4wZyOcRT8Dms6q6O0+6x4dY0qibBN
         SdqthGnzwS6lIBFH4T8lqWOgSUPbdJ4Tclcd8sYUKvqS9GACinpSgc1wmLrCCmOpGKlp
         GlSXyxJtJJ59180ufO0wMvcyNUW+bZz7TPFdwYkutoTE6dQSmLnGZUlCGL1wacLP0NOe
         pFVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Eut9Hh+Us/VNbI9IiG/v+1Zbk7zdy/JsgTvi+Ivycjc=;
        b=eXCOV0gStxJP9AE2VCcTWP6edfY3KW8G0eoZkCJ1srpgPsdk5/IXZi5yVm8RTk2JL4
         BnAPTvSIo6aQm8gJk2OuNtmoqCiC0wHT2l6R1KknkmE9gtiw77ehRLOzULI3DS5k6ZKG
         d6oix3FUJEr77yZhLyv5dX328VSaDm3WeGjrs9mqRCfdESPwbEZ6DOcvpbbtfMzxoziC
         dXsUY9deRKCoaSPtvvdAHwlBlfv3pbNPVBKjZX/0ze9WpAC33lmsXchUERInPWiR30gQ
         DmInZ2tppfPcmoBOfLTsfwigefpIu/fkkeqJ/RePY3CBAjKh3EnoBt9ieFa2sWZZfqxv
         VUmQ==
X-Gm-Message-State: AOAM533gY+44VrD7VAUqO9A40F54Etgca9ric04WBV6iWW5Di+63M5ny
        jsjvGHlQyFF8VvffWvfhJQ==
X-Google-Smtp-Source: ABdhPJzOAKWja2VEwSPDaORCxPArQ6cMI11xEwvZVcwolfYZhO/2X8ngQ56qtl0ow31GVImPXWzXgw==
X-Received: by 2002:a05:6214:1cc4:b0:435:b8a0:1fe9 with SMTP id g4-20020a0562141cc400b00435b8a01fe9mr24512732qvd.54.1653447090743;
        Tue, 24 May 2022 19:51:30 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id z23-20020ac84557000000b002f3e153f47csm711586qtn.0.2022.05.24.19.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 19:51:30 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next 0/7] ss: Introduce -T, --threads option
Date:   Tue, 24 May 2022 19:51:15 -0700
Message-Id: <cover.1653446538.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

Hi all,

This patchset adds a new ss option, -T (--threads), to show thread
information.  It extends the -p (--processes) option, and should be useful
for debugging, monitoring multi-threaded applications.  Example output:

  $ ss -ltT "sport = 1234"
  State   Recv-Q  Send-Q  Local Address:Port      Peer Address:Port       Process
  LISTEN  0       100           0.0.0.0:1234           0.0.0.0:*           users:(("test",pid=2932547,tid=2932548,fd=3),("test",pid=2932547,tid=2932547,fd=3))

It implies -p i.e. it outputs all threads in the thread group, including
the thread group leader.  When -T is used, -Z and -z also show SELinux
contexts for threads.

[1-5/7] are small clean-ups for the user_ent_hash_build() function.  [6/7]
factors out logic iterating $PROC_ROOT/$PID/fd/ from user_ent_hash_build()
to make [7/7] easier.  [7/7] actually implements the feature.

Thanks,
Peilin Ye (7):
  ss: Use assignment-suppression character in sscanf()
  ss: Remove unnecessary stack variable 'p' in user_ent_hash_build()
  ss: Do not call user_ent_hash_build() more than once
  ss: Delete unnecessary call to snprintf() in user_ent_hash_build()
  ss: Fix coding style issues in user_ent_hash_build()
  ss: Factor out fd iterating logic from user_ent_hash_build()
  ss: Introduce -T, --threads option

 man/man8/ss.8 |   8 +-
 misc/ss.c     | 230 +++++++++++++++++++++++++++++---------------------
 2 files changed, 142 insertions(+), 96 deletions(-)

-- 
2.20.1

