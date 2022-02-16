Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D17A4B7EEA
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245021AbiBPDzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:55:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241295AbiBPDzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:55:08 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3156CF47D2;
        Tue, 15 Feb 2022 19:54:57 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id m22so1086442pfk.6;
        Tue, 15 Feb 2022 19:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6eq1s5aVbXuXrOrX4WJMc5fsMdAsAhzLx3+vqs8tUEg=;
        b=KupXQdBsNC+01GxbiFLGn8kZoxshkkkJYNnAD7jkHHPWzH2n4r1QM8ooQwvl9LXSVb
         VWXeGCtu1J1Qgv75/VElj39ein37k41xNx1AsGhYN9QjiK70XZ6cwhFkbJ2D6QxwJ8LZ
         jmQeuk6ToEddTyhNJcEmMROH8Rqm3Vzff63Y0o13hQ/5KxSVA9Q9N7WZ07aW/bcyqyTD
         WKnxNiONFpHajIoiyB4gXSzNu1tE8HRAZ02GJzH1Y+lFGx7YYzmeRI6uikbpR39xl384
         bsRFJV8Tm2OFdpSFQXJ815OM2MpGcdqG/36xj0crtfB6zq0oy4YQqWH25SjIdvplsxPt
         ISlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6eq1s5aVbXuXrOrX4WJMc5fsMdAsAhzLx3+vqs8tUEg=;
        b=UC5IggW68pupnIc3XSrm+KLKbBYXkAZMSxqo1paHgttMj9DmWaqEyNTpAXI2ZqpCHN
         Y5KiIAyupf90tp7s4RHTvcNkCxE8ST5YhJ2nBY7Bxj9Gctityf/e7XOC2KUZhRvgDgU+
         C2HbSKVzw25SImA/I2uy+vPZmU5edRDCA2WCcYrC+U2U7qlF1miGt6cBJbIctQlrEpl1
         Utu6xVhzIRYBesAKUeXxgi8pPqA5yPtpApdVuOicxX0xGHYJqT0fkKLWQgkrp+sB+pIa
         hOHnTo7U0X+/yWBor979kJDo2kWOvs2c/Yk5Rz5Pl1Bx/id2zuCLbGlrWt3rOn+ucD0p
         wmbw==
X-Gm-Message-State: AOAM533c/2nijBUsjdJ74kmCgKGzPF5cSwtHAskH0CW5j/eJ6ysFQx8/
        zulGACgZikugbWvs1zLlqF0=
X-Google-Smtp-Source: ABdhPJzSy67Yia7HMJqdfEBmfurt6kIklj8QlJpcRULKZz3npJnNg4UVLEV4r0ip8Uh1oYq8ABXmZA==
X-Received: by 2002:a05:6a00:134c:b0:4e1:75b:ca4b with SMTP id k12-20020a056a00134c00b004e1075bca4bmr930384pfu.37.1644983696757;
        Tue, 15 Feb 2022 19:54:56 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id nn16sm19099668pjb.2.2022.02.15.19.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:54:56 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next 0/9] net: add skb drop reasons to TCP packet receive
Date:   Wed, 16 Feb 2022 11:54:17 +0800
Message-Id: <20220216035426.2233808-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
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

From: Menglong Dong <imagedong@tencent.com>

In this series patches, reasons for skb drops are added to TCP layer, and
both TCPv4 and TCPv6 are considered.

in this series patches, the process of packet ingress in TCP layer is
considered, as skb drops hardly happens in the egress path.

However, it's a little complex for TCP state processing, as I find that
it's hard to report skb drop reasons to where it is freed. For example,
when skb is dropped in tcp_rcv_state_process(), the reason can be caused
by the call of tcp_v4_conn_request(), and it's hard to return a drop
reason from tcp_v4_conn_request(). So I just skip such case for this
moment.


Menglong Dong (9):
  net: tcp: introduce tcp_drop_reason()
  net: tcp: add skb drop reasons to tcp_v4_rcv()
  net: tcp: use kfree_skb_reason() for tcp_v6_rcv()
  net: tcp: add skb drop reasons to tcp_v{4,6}_inbound_md5_hash()
  net: tcp: add skb drop reasons to tcp_add_backlog()
  net: tcp: use kfree_skb_reason() for tcp_v{4,6}_do_rcv()
  net: tcp: use tcp_drop_reason() for tcp_rcv_established()
  net: tcp: use tcp_drop_reason() for tcp_data_queue()
  net: tcp: use tcp_drop_reason() for tcp_data_queue_ofo()

 include/linux/skbuff.h     | 28 +++++++++++++++++++++++++
 include/net/tcp.h          |  3 ++-
 include/trace/events/skb.h | 10 +++++++++
 net/ipv4/tcp_input.c       | 42 +++++++++++++++++++++++++++++---------
 net/ipv4/tcp_ipv4.c        | 36 ++++++++++++++++++++++++--------
 net/ipv6/tcp_ipv6.c        | 42 +++++++++++++++++++++++++++++---------
 6 files changed, 131 insertions(+), 30 deletions(-)

-- 
2.34.1

