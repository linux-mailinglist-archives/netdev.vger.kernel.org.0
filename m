Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CCA50F361
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344101AbiDZIKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiDZIKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:10:45 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DCB47397;
        Tue, 26 Apr 2022 01:07:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id iq10so4256538pjb.0;
        Tue, 26 Apr 2022 01:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tN8Fv7V1wSS9FUUkH5yob4wTatJoDf357KJgbMmap0U=;
        b=kIR825Y3M66dLlpjb0POyvAd4SCCglXnT1WGVNN/3Vao+7fnolZa+kG7I5xTCo65UP
         y6t2Kk1VBhPOiqmLl8qNRa3I/jaWbP9L7Kl3Y7qOaHOJhi3LB3KdJAl7RszuqoTawZOc
         e3A1JANOBLme/34V4yPT7MtGFtlmpoW8QoVBGL1WoRYYtiTRuYptKyULa3016iOZ2m5o
         k2LrTnVr18+dwKm75p2TqcAVpDwI3tuUBITG1bbelFSXxGHLJJ9SQ6Tmn0zOB9nph7Ij
         0u6jS4ist5xAScrKsaTb0zZgZUto4TRXl22pGNC1O/wXAJgdCLDQk5GXrY9h7NXZIfu2
         GXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tN8Fv7V1wSS9FUUkH5yob4wTatJoDf357KJgbMmap0U=;
        b=TgqaLDcRVELCnamFOGm+1vd+GJHgjVJsAcY40RMOX0wOqaTvtSyrrm/KN9GzOxjYbj
         ErP6EqtzyuhU0rB0kjDFUAjErXKnZ6S2QhlK/Qe9iRf9o04HIqssHP/7VNYTdyp5GFpx
         upQD+SPkUc7UGehkVgnO6nP5m9n9SI0drps0EKaO1O3YI/N6egWz416v4PRUlIrY1X4P
         841II4bbniJSpisqVtFH0Y/8m4Gz2XUS4yEIS4dwzlC+hiaRoaUxIjHC1JegVRcUOYqX
         2H6WU6nhcU6vt6Miz1nFFMG1sk9hmSzZa9gG0yjgYGYw4CXMua4Ia+hGT4e+ZhED8chL
         OtuA==
X-Gm-Message-State: AOAM5338P8ccXm1nfBsh4trxmVvBgLPcWNJnFE2cZ+8eWLmyeW/VcCf9
        MvLpndzbkvAKaMSmNXIiVvpC1YuSZdA=
X-Google-Smtp-Source: ABdhPJyLfboJtLfSoNg3k0eUH0TWjVm0hvDhFtS1Pw6ROm4Ld96n1h0WtefZDR8U+9ifQik9hFC9XQ==
X-Received: by 2002:a17:902:ea0b:b0:15c:fbe1:2cdb with SMTP id s11-20020a170902ea0b00b0015cfbe12cdbmr12300810plg.126.1650960456930;
        Tue, 26 Apr 2022 01:07:36 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l4-20020a056a0016c400b004f79504ef9csm15134951pfc.3.2022.04.26.01.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 01:07:36 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: tcp: add skb drop reasons to connect request
Date:   Tue, 26 Apr 2022 16:07:07 +0800
Message-Id: <20220426080709.6504-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.0
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

From: Menglong Dong <imagedong@tencent.com>

Seems now the reasons of skb drop in TCP layer are almost supported,
except the path of connect requesting. So let's just finish it.

The TCP connect requesting is processed by
'inet_csk(sk)->icsk_af_ops->conn_request()'. Yeah, it's a function
pointer, so it's not easy to add function param to it. Luckily, it's
return value can be reused. For now, 0 means a call of 'consume_skb()'
and -1 means 'kfree_skb()', with a RESET be send. Therefore, we can
free skb with 'kfree_skb_reason()' in 'conn_request()' and return 1.
While 1 is returned, we do nothing outside. This work is done in the
1th patch.

And in the 2th patch, skb drop reasons are added to route_req() in
struct tcp_request_sock_ops by adding a function param to it.

Following new skb drop reasons are added:

  SKB_DROP_REASON_LISTENOVERFLOWS
  SKB_DROP_REASON_TCP_REQQFULLDROP
  SKB_DROP_REASON_SECURITY

Menglong Dong (2):
  net: add skb drop reasons to inet connect request
  net: tcp: add skb drop reasons to route_req()

 include/linux/skbuff.h     |  5 +++++
 include/net/tcp.h          |  3 ++-
 include/trace/events/skb.h |  3 +++
 net/dccp/input.c           | 12 +++++-------
 net/ipv4/tcp_input.c       | 23 ++++++++++++++---------
 net/ipv4/tcp_ipv4.c        | 17 +++++++++++++----
 net/ipv6/tcp_ipv6.c        | 14 +++++++++++---
 net/mptcp/subflow.c        | 10 ++++++----
 8 files changed, 59 insertions(+), 28 deletions(-)

-- 
2.36.0

