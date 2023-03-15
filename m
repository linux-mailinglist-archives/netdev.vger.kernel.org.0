Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E126BABFA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCOJVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjCOJVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:21:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ECD1D90D;
        Wed, 15 Mar 2023 02:20:57 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id d10so10362038pgt.12;
        Wed, 15 Mar 2023 02:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678872057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d0gqt2xwBEWN7KFuDaD6z1O6+7EY4w/LU3lD9GJPLEo=;
        b=aXtXNgPeGLpvP9xFC6Q5q1dHIy22Ad9lGnUi7Wq+oXdUpVxWBOGwrooKce7eJzmVqN
         TvHd2A8R1sGaQ7nrgpg6yt2YG9Vlk/lVLBD+GvKV/jQs+IFYUHyzHKMiZxIwBVd7a9i/
         qrYh3Xmo+GgJQu1NdQDlDKu7ydrsDeEgIfFMNJ1d+QzqmCnsUwMxCCHcsuugYb9IQpBg
         mKBcBuqhNuj08qN28Tzezh4OZYoK3f6pCRiZ8HqmANiHZWUFLBIB0kHlH/7O2NPCQ4DK
         g9rj3p966au2/IgnJeY7vM+HFyMef3z2rjK2UFS4s21fL/e1CZRX40bOkpfzWRwGe6nM
         3BaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678872057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d0gqt2xwBEWN7KFuDaD6z1O6+7EY4w/LU3lD9GJPLEo=;
        b=risDrBPe+0vDNeOXriS1w5elqF4YP4XiwkSFo0xxhs2vsBE76se3LKaeJzKXMqa/Om
         8MQ+eBZ1mOPXZgM0ZWFCXAxmQ/JI04HtGvYnrhCDDNruww6eN+P/rTzYVMPkArk9YMw3
         1hWAYfBxbp/Oa2H/8JmkrZPQu4neGg8ea6gTY7GFZV+BGzqxZxpbLTTZ6kyybeH7pkRM
         DIv0ZiZnmqCwqB9Fvx5WtRGysioaDxiG/XJyMV44dN2xN1I54jxYRVCqstLttew50ZIt
         o/4kgDenWATdBGpj/98VQ4OvRdzEd5vxZBurCHBQNVy0YFl09vSA5uLcDQ5kG6wzwMMs
         FW0Q==
X-Gm-Message-State: AO0yUKWYQkk0phI7xXmoiYQQO1YH9mOksD/SmhkWodTwi4poWVt6jYJ7
        o4vVcESsAErap9WZqkHd5jk=
X-Google-Smtp-Source: AK7set+mAo5NR+qvj4LGVLQojuIHRbLrK3crbSXxwdhn2w9QgJPENcciTpW/3MzazqIMlsjpuuT7LQ==
X-Received: by 2002:aa7:94a5:0:b0:625:89d5:59db with SMTP id a5-20020aa794a5000000b0062589d559dbmr2297489pfl.28.1678872057214;
        Wed, 15 Mar 2023 02:20:57 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id n3-20020aa79043000000b005ae02dc5b94sm2971815pfo.219.2023.03.15.02.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 02:20:56 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v4 net-next 0/2] add some detailed data when reading softnet_stat
Date:   Wed, 15 Mar 2023 17:20:39 +0800
Message-Id: <20230315092041.35482-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Adding more detailed display of softnet_data when cating
/proc/net/softnet_stat, which could help users understand more about
which can be the bottlneck and then tune.

Based on what we've dicussed in the previous mails, we could implement it
in different ways, like put those display into separate sysfs file or add
some tracepoints. Still I chose to touch the legacy file to print more
useful data without changing some old data, say, length of backlog queues
and time_squeeze.

After this, we wouldn't alter the behavior some user-space tools get used
to meanwhile we could show more data.

Jason Xing (2):
  net-sysfs: display two backlog queue len separately
  net: introduce budget_squeeze to help us tune rx behavior

 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 12 ++++++++----
 net/core/net-procfs.c     | 25 ++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 9 deletions(-)

-- 
2.37.3

