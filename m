Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8964BB435
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiBRIci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:32:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiBRIch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:32:37 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DAA24BC2;
        Fri, 18 Feb 2022 00:32:21 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so11735535pja.3;
        Fri, 18 Feb 2022 00:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G7Ky4SPAlAvxQVW1XgAzBzd0oAgipp9etDINBP4Dccw=;
        b=DOXIakKeYJ28VPnZCTl23gZ92xN/6waD/OMSqByV5Gr4pIx9HE0JLfy/pTBbERvWne
         PqablyCQuaITKY70Zg44VnDYkDWI+M2bRMNXfhDUaASnfycaVShrq54baaIzIE8mNIca
         76deyc8vIyIsd38a+s+NcW8j82lBVKtJcaSkFvWGXWU6sNqs3Y9ZEAfRRey8PWOSks+F
         Da+8WFvWHQKitmiMdFWhh9Pojijh2TSB0t/4p4D+EcmfcL+qEpF7mWo8jwsO3KcleCRU
         HiWU1JrHiYfB8Gb17s7ZTMtak4RKA5CmJPTOmEdmzVtIE8MwZhkS9c3IG8pfKZQO/4py
         UZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G7Ky4SPAlAvxQVW1XgAzBzd0oAgipp9etDINBP4Dccw=;
        b=b3Mf/P/LkEt4cgTxLs++YROuDkR+LioMCZt4wN7M3JF/WFvWf23ZtL4tIP2OhdHFs/
         mqrqPPwhHR+DSrLv0CLMfMKhdMdh7EQuLmrfBSiVjW3VNdjjgCZMxHkHEEDxAelHI+HS
         cBR/tTN02ThVQWrcasuyOrgxscmrdq8j4BIIOE3MNKMi3pWZ7KdWkhpCFhd8I+Pj+UkR
         mNmRwXzNjIlj2v9yZcIbYWOAdIsPYujpO4a0hgV5yduUTSk4EXw/oQxRNaT6TD38PY4z
         LudnLG6eeSYqLxfFsILXatXx0o5AFbnujwnbq17tPkk0iR7OTr3mZe0our/X6qBflc5K
         oZqw==
X-Gm-Message-State: AOAM532eP2ylrnJHERykLV+tohT80HmCHX08zIuJRJlu1+2YqkTy7nbM
        gpx/PBdxggkM4gTQL1ThwsA=
X-Google-Smtp-Source: ABdhPJwzCiP+JnZXK7MaG65yb9kIWl7yRZ80SbRxQkGGnKO9/JCJq8VPWd7Vm6pvOOFNsGt6tBG/fA==
X-Received: by 2002:a17:90a:1202:b0:1b9:b7e7:1652 with SMTP id f2-20020a17090a120200b001b9b7e71652mr7349527pja.1.1645173140816;
        Fri, 18 Feb 2022 00:32:20 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id m23sm1963530pff.201.2022.02.18.00.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 00:32:20 -0800 (PST)
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
Subject: [PATCH net-next v2 0/9] net: add skb drop reasons to TCP packet receive
Date:   Fri, 18 Feb 2022 16:31:24 +0800
Message-Id: <20220218083133.18031-1-imagedong@tencent.com>
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

