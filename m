Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054434BCD14
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbiBTHIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:08:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiBTHIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:08:04 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247BD4CD60;
        Sat, 19 Feb 2022 23:07:42 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u12so10403411plf.13;
        Sat, 19 Feb 2022 23:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SHub7UdaikiOm/0EhLP2n+OzibioXxKQjInJvVseBg0=;
        b=CLrlLW9e2tGnwWGcR7bub65RzTdsIutbT7l+IQuhSmZeVy+4faZaz6A1HDsCYyweiC
         xh4AS5yo6YuiLxElW1/h1nbrWDGfzUIo9qLEN1Lw3wfKDV/jegdCROnV0DiYVoLX3AFd
         6CW5Kbn6EckrebLvKcJSr34QPYCKt87CYikpWh5KucTK/Z44RCTVT5qudslc7ocTcePY
         IQ3mKKyZj+WwK0hOtgZL5vIGACYkCF0ArANTUnveikkEA6TeAKtMAkFDJDOhmN8euup1
         E/JGulKnJUhTYBWgWpiG6DxZGNolotToE/j7BXPIF8ikidJth5M44b0eG+LfNIkZk/dv
         PGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SHub7UdaikiOm/0EhLP2n+OzibioXxKQjInJvVseBg0=;
        b=p+t9lItdhTdjNlaomh/VAqorbQr5d9xwcg6nlCbJWX9+D+OTGDbjdrG5o9z/fhwRSw
         rihdIWE6SXgNQm7XiUTydONufigtxgOHittbhe0HdpSAvpNhX8XOQyoS0XnFvij1SgQK
         yVfogscnvyqq3i2OjqKCXmO0XoxBvuFbY4z7QbVBaVjcPqRD2lB5iH7Wn8lWXy09vHN7
         HhhQyrS4QbGi/TLYIjklCQ5aJwcL1ARFI1C4h4UIqcKD4GqUAWWmgeXq0w/xzbiLXPuP
         IkG5K+VjFN12upSLDAKPBNBSb//ELoyxaLQPwOvxH9ysBcBUWhYBaVrjMsCHadItZQAL
         S5pA==
X-Gm-Message-State: AOAM532K16r2nWJWtluuvMIp0cCaFxtTr3sV/mqp3BPG7oGhyI3bg5Bl
        kAFggH2EUna1Ks29FP3QYs0=
X-Google-Smtp-Source: ABdhPJzNc6s9bgaL9R/+J+tbPmHRl7yw+oQ9dNLDsacG24aptDohTx9Kq7AeIiSew/p/9YfOnxVqDA==
X-Received: by 2002:a17:902:d892:b0:14e:e074:7ff7 with SMTP id b18-20020a170902d89200b0014ee0747ff7mr14146814plz.29.1645340862430;
        Sat, 19 Feb 2022 23:07:42 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id p1sm8351326pfo.212.2022.02.19.23.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 23:07:41 -0800 (PST)
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        flyingpeng@tencent.com, mengensun@tencent.com
Subject: [PATCH net-next v3 0/9] net: add skb drop reasons to TCP packet receive
Date:   Sun, 20 Feb 2022 15:06:28 +0800
Message-Id: <20220220070637.162720-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
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

In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()"),
we added the support of reporting the reasons of skb drops to kfree_skb
tracepoint. And in this series patches, reasons for skb drops are added
to TCP layer (both TCPv4 and TCPv6 are considered).
Following functions are processed:

tcp_v4_rcv()
tcp_v6_rcv()
tcp_v4_inbound_md5_hash()
tcp_v6_inbound_md5_hash()
tcp_add_backlog()
tcp_v4_do_rcv()
tcp_v6_do_rcv()
tcp_rcv_established()
tcp_data_queue()
tcp_data_queue_ofo()

The functions we handled are mostly for packet ingress, as skb drops
hardly happens in the egress path of TCP layer. However, it's a little
complex for TCP state processing, as I find that it's hard to report skb
drop reasons to where it is freed. For example, when skb is dropped in
tcp_rcv_state_process(), the reason can be caused by the call of
tcp_v4_conn_request(), and it's hard to return a drop reason from
tcp_v4_conn_request(). So such cases are skipped  for this moment.

Following new drop reasons are introduced (what they mean can be see
in the document for them):

/* SKB_DROP_REASON_TCP_MD5* corresponding to LINUX_MIB_TCPMD5* */
SKB_DROP_REASON_TCP_MD5NOTFOUND
SKB_DROP_REASON_TCP_MD5UNEXPECTED
SKB_DROP_REASON_TCP_MD5FAILURE
SKB_DROP_REASON_SOCKET_BACKLOG
SKB_DROP_REASON_TCP_FLAGS
SKB_DROP_REASON_TCP_ZEROWINDOW
SKB_DROP_REASON_TCP_OLD_DATA
SKB_DROP_REASON_TCP_OVERWINDOW
/* corresponding to LINUX_MIB_TCPOFOMERGE */
SKB_DROP_REASON_TCP_OFOMERGE

Here is a example to get TCP packet drop reasons from ftrace:

$ echo 1 > /sys/kernel/debug/tracing/events/skb/kfree_skb/enable
$ cat /sys/kernel/debug/tracing/trace
$ <idle>-0       [036] ..s1.   647.428165: kfree_skb: skbaddr=000000004d037db6 protocol=2048 location=0000000074cd1243 reason: NO_SOCKET
$ <idle>-0       [020] ..s2.   639.676674: kfree_skb: skbaddr=00000000bcbfa42d protocol=2048 location=00000000bfe89d35 reason: PROTO_MEM

From the reason 'PROTO_MEM' we can know that the skb is dropped because
the memory configured in net.ipv4.tcp_mem is up to the limition.

Changes since v2:
- remove the 'inline' of tcp_drop() in the 1th patch, as Jakub
  suggested

Changes since v1:
- enrich the document for this series patches in the cover letter,
  as Eric suggested
- fix compile warning report by Jakub in the 6th patch
- let NO_SOCKET trump the XFRM failure in the 2th and 3th patches

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

 include/linux/skbuff.h     | 34 ++++++++++++++++++++++++++++++
 include/net/tcp.h          |  3 ++-
 include/trace/events/skb.h | 10 +++++++++
 net/ipv4/tcp_input.c       | 42 +++++++++++++++++++++++++++++---------
 net/ipv4/tcp_ipv4.c        | 32 +++++++++++++++++++++--------
 net/ipv6/tcp_ipv6.c        | 39 +++++++++++++++++++++++++++--------
 6 files changed, 132 insertions(+), 28 deletions(-)

-- 
2.34.1

