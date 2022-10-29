Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106AD612325
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 15:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJ2NLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 09:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJ2NLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 09:11:04 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B0467159;
        Sat, 29 Oct 2022 06:11:03 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so6775530pji.0;
        Sat, 29 Oct 2022 06:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A9kU2QGc/0/ct5xSbAsmcvV4JkwDQsSv77UPsHyGLgg=;
        b=K8MHO0bwXeJg5od0MtZYgwV6otQlasdfjhSkUFzZwwpzrv9ZmWPnvpRm4sG9CPAfq9
         IjkhYKDMuKHtk/wS3e5yjapgEwJfL7i+p6IVaWXHf8rBXi51Pt+IW3oTTIzrckFEaQ2Z
         yq9PnSbHTYqbxsfdQJKTnb0FyigiA/5xBNgOCJAn0e+WfpbVriy4LbewgZ3Mc3vZNlA9
         B0hj8i88RBH3ObhguFzPBibmIfKQ97HjOgHD71VuHskrtBJ1UJlJvLFvbfTnBL+eCNQ0
         izr4cQIKbodv7Tbs/WTT8rEfD+YIdpWPUPNszqjtt6KcfKxLW2mTp3zrzu0xkU4JEXqz
         Rr7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A9kU2QGc/0/ct5xSbAsmcvV4JkwDQsSv77UPsHyGLgg=;
        b=d5nDXNwzmw7Pvs0M6baIdauqri7nOymkwjY2jrdeYGc3KlrAMNHIqDcSPo1BnfG37z
         rkFbyjW4s430SikZsftDCRVwOJD+Jin6pEseibE7hbcEbjuZoPCIiYB97Otc3xE1HA90
         T3FB0WjlNZbgxS2FmO8fTbkq2ohpxfEyMRKkIF7AHDmvvPU0UrT2lT5QlJJvrgn1ei/T
         a/ZuQC4LD78IdmtsYtA4Ua3YGNKosp8NLspzsjUPZgL8kvCk4fdeMK4ulg6jsB8QJgu7
         SEsnoqk4ehDMFfLib1W1sc9F/dHEas3+h/Z7T7sI1+GojHG6D23BYPrsqfRnPI+qy2tJ
         YgQA==
X-Gm-Message-State: ACrzQf0jASvd6A6LepKlis96tXFfDypx7XC3JbURRCOjo2HFK1DfDoSa
        1/vAwsFgK7IKCzZngHYr5X4=
X-Google-Smtp-Source: AMsMyM5BmBBuQ/Lnv7Dw6CSGiN9gP5S97MWakTVvYwc+K1Iqc7Fpuj6o61qPRkDPKoOf54V0V8t4Xw==
X-Received: by 2002:a17:90a:74cb:b0:213:9b4c:ecc2 with SMTP id p11-20020a17090a74cb00b002139b4cecc2mr4756680pjl.154.1667049062614;
        Sat, 29 Oct 2022 06:11:02 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001811a197797sm1244069plp.194.2022.10.29.06.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 06:11:01 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/9] net: tcp: add skb drop reasons to tcp state process
Date:   Sat, 29 Oct 2022 21:09:48 +0800
Message-Id: <20221029130957.1292060-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.37.2
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

For now, the skb drop reasons have not fully be supported by TCP
protocol on the code path of TCP connection state change. The function
call chain is a little complex, which makes it hard to get the reason
that why skb is dropped.

However, I have a idea now: store the drop reason in the tcp_skb_cb,
which means that we need to add a 'drop_reason' field to the struct
tcp_skb_cb. Luckily, this struct still has 4 bytes spare space for this
purpose.

In this way, we need only to initialize to 'TCP_SKB_CB(skb)->drop_reason'
to SKB_DROP_REASON_NOT_SPECIFIED in tcp_v4_rcv()/tcp_v6_rcv(). When the
skb needs to be dropped, the value of this field should be the drop
reason or SKB_DROP_REASON_NOT_SPECIFIED. Meanwhile, the value also can be
SKB_NOT_DROPPED_YET. On such case, try_kfree_skb(), which we add in the
1th patch, should be called.

Hi, Eric, do you like it? In this way, we almost don't need to change the
exist code, and won't mess the code up.

In this series, the skb drop reasons are added following functions:

  tcp_rcv_synsent_state_process
  tcp_timewait_state_process
  tcp_conn_request
  tcp_rcv_state_process

And following new drop reasons are added:

  SKB_DROP_REASON_TCP_PAWSACTIVEREJECTED
  SKB_DROP_REASON_TIMEWAIT
  SKB_DROP_REASON_LISTENOVERFLOWS
  SKB_DROP_REASON_TCP_REQQFULLDROP
  SKB_DROP_REASON_TCP_ABORTONDATA
  SKB_DROP_REASON_TCP_ABORTONLINGER
  SKB_DROP_REASON_LSM

Menglong Dong (9):
  net: skb: introduce try_kfree_skb()
  net: tcp: add 'drop_reason' field to struct tcp_skb_cb
  net: tcp: use the drop reasons stored in tcp_skb_cb
  net: tcp: store drop reasons in tcp_rcv_synsent_state_process()
  net: tcp: store drop reasons in tcp_timewait_state_process()
  net: tcp: store drop reasons in tcp_conn_request()
  net: tcp: store drop reasons in tcp_rcv_state_process()
  net: tcp: store drop reasons in route_req
  net: tcp: use LINUX_MIB_TCPABORTONLINGER in tcp_rcv_state_process()

 include/linux/skbuff.h   |  9 +++++++++
 include/net/dropreason.h | 43 ++++++++++++++++++++++++++++++++++++++++
 include/net/tcp.h        |  3 +++
 net/ipv4/tcp_input.c     | 29 ++++++++++++++++++++++-----
 net/ipv4/tcp_ipv4.c      | 26 ++++++++++++++++++++----
 net/ipv4/tcp_minisocks.c | 15 ++++++++++++--
 net/ipv6/tcp_ipv6.c      | 31 +++++++++++++++++++++++------
 7 files changed, 139 insertions(+), 17 deletions(-)

-- 
2.37.2

