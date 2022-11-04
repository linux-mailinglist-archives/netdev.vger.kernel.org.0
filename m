Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A0061A387
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiKDVpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKDVpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:45:20 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA902D9E;
        Fri,  4 Nov 2022 14:45:19 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id k4so3904071qkj.8;
        Fri, 04 Nov 2022 14:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qr1qi8YtH2YFS0bbmYdGFeAZc0f44dYZlNmZ1vaRsHw=;
        b=RdmOMb0nJ9KfWRmBNIXoY89vpRXyG7/ZskjVA0Brik2TGYwmTFIoB93gUSOhD2rA+6
         MVxe1eRy1O89pqfXgDWl/d49Ob045uHN/8+AUHegRjVABFgXfGJGV2h3EsDWuXqYHX/a
         0PzU8HWj6HWXwLI8xMbTZqXZJJWbtcbveHw+D7Bx0fCHLYwOHPsQWE7lrN9qWuMnH+Z5
         xxSalQ72IhCczAlOf8NJ4Ir4cXbouObvzcoYi5SaKFbfEuBa/bepbVjg1yJKmnBFddpt
         XbuaJdnYnNHRnwITmvbac2vR87o76MCADdhZWBW1XF9sIuexYJMiZDcx1/vGoLzghsnf
         Df6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qr1qi8YtH2YFS0bbmYdGFeAZc0f44dYZlNmZ1vaRsHw=;
        b=T5R5ul6+1CcHwtHHqJi2dfpJPNZkRi77ZvKy6O7qRNw4xITpfBGVlsBMlMmcCwbp64
         LzJVXRGG4krSXCAD8OaarDN+/tgunYHBnju+umte5wQglb2iM3uG8mt2UddLJo8AYjV4
         F2iiEPnS53FwAISGRR++az6SfEdgxab4BwQ9gTKhLLDMS9xaEDsxz+RScM1YQiDC/ous
         oC3grsAIJj73Ht+4Pg0ID2LYb0LtDttEbyFwDtEaLBV7Df+UysrtpJErrIw+QBTvnn5i
         JpOZOShVtQkMpXE3GdqG38j5h7iSOYyyBwK+1iIl0yN6n2cjZ+7ZaxodA68p8bVMooEM
         GzIQ==
X-Gm-Message-State: ACrzQf1cC6pEHNmvqIlg/Uy1TSDFIIm7sKQI9wp5cI6sqs2VOILknhBx
        dlQaTjOeQdyhXGsbiyiBXuPK7tyGDbIYcQ==
X-Google-Smtp-Source: AMsMyM73b8USHN5aSEr65FwfckfLImG6mhFcZeClethT1UtKMi2m/uGhfv8hCYQi2Ltt0A3TcNzegw==
X-Received: by 2002:a05:620a:2282:b0:6f9:fe6d:1090 with SMTP id o2-20020a05620a228200b006f9fe6d1090mr27124789qkh.477.1667598318589;
        Fri, 04 Nov 2022 14:45:18 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id k1-20020ac81401000000b003434d3b5938sm366185qtj.2.2022.11.04.14.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 14:45:18 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, chenzhen126@huawei.com,
        caowangbao@huawei.com
Subject: [PATCH net 0/2] sctp: fix a NULL pointer dereference in sctp_sched_dequeue_common
Date:   Fri,  4 Nov 2022 17:45:14 -0400
Message-Id: <cover.1667598261.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

This issue was triggered with SCTP_PR_SCTP_PRIO in sctp,
and caused by not checking and fixing stream->out_curr
after removing a chunk from this stream.

Patch 1 removes an unnecessary check and makes the real
fix easier to add in Patch 2.

Xin Long (2):
  sctp: remove the unnecessary sinfo_stream check in
    sctp_prsctp_prune_unsent
  sctp: clear out_curr if all frag chunks of current msg are pruned

 net/sctp/outqueue.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
2.31.1

