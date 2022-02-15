Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6D24B6AD1
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbiBOLaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:30:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiBOLaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:30:03 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D182107DB6;
        Tue, 15 Feb 2022 03:29:53 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id m22so15154352pfk.6;
        Tue, 15 Feb 2022 03:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AHEUnxWDrYKT+0lFAhXezK7cHzDJoi1Ki75zEXrCe38=;
        b=GU2eLCAXKv4tzRImKxl6hjK1DRVJM2tTTHmmKRzMaEu9gMJeSHByLhphsK2U2OC27m
         svXqUnAcLmHPHel0UIQxuBWFV/eYIyBjMRR1FSXoK9FEUpUr6Aui9ci+Z7mZfgvIqep9
         Q7n7ORH2KcOofyBOEZrhNd1P3FN4YQ7l6go5aAWuOhPE3X00QcM8TVGbvn6Wc74T9s6T
         xySbVkOSHxIg5bG/u3rnWL/FGvqK0ORbCPhq2K8b/peP/7mQXhx+JH8kWw0XjBs6FlKN
         RiRs14mVMwVrl1eWXHptqzWlzeHgHQbSIQGcq7szdb8FHthrIU+yVmx8j5rKFboZDz9R
         SQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AHEUnxWDrYKT+0lFAhXezK7cHzDJoi1Ki75zEXrCe38=;
        b=Lu1BpSIIcEpvQz6diF7o5HHTyBdy87yq6yBlcUhiBmCikULGXBVYgOqcqh3PDI0yip
         gPd1ljjQFtZbHFU96mXlqKfcD3rK/cydHN9FgqIzpp9Lytbt/mLMOggvueROutSI1bwI
         1/x+at2VBjQYd0NCgHWHXWL1p65wVugpnVxb+E4QMFcu2+vFgGbnFt+2qUszxCvv+voo
         eLbeLLBf64I27z4aTfqOSfHEJl8sIncSH4vLtsP+3+RpPd0OY6xeuEo+6vDYdEpJ/orO
         VLPb9o6ehs6jC08Rxbh9NyTrgfd8iYfFqSo4MKtMb7eMtL+X/UOsJw8UXlQ1UQ8ffvXv
         m8sQ==
X-Gm-Message-State: AOAM5320FmGTy7Za67p2P9nYT+EvivghrrFBbpfecHJ3z0geU5CnMjSa
        HypLBicsqFFsDxlsrWaKU00=
X-Google-Smtp-Source: ABdhPJw9ACwli4oOx2sHEXwF+FQYjoY3hh+x5L6dJXhanXpmD3mrqsEgWYsxUX2VKq/1afHYn4nYVA==
X-Received: by 2002:a63:5424:: with SMTP id i36mr3066866pgb.413.1644924593065;
        Tue, 15 Feb 2022 03:29:53 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:29:52 -0800 (PST)
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
Subject: [PATCH net-next 00/19] net: add skb drop reasons for TCP, IP, dev and neigh
Date:   Tue, 15 Feb 2022 19:27:53 +0800
Message-Id: <20220215112812.2093852-1-imagedong@tencent.com>
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

In this series patches, reasons for skb drops are added to TCP, IP, dev
and neigh.

For TCP layer, the path of TCP data receive and enqueue are considered.
However, it's more complex for TCP state processing, as I find that it's
hard to report skb drop reasons to where it is freed. For example,
when skb is dropped in tcp_rcv_state_process(), the reason can be caused
by the call of tcp_v4_conn_request(), and it's hard to return a drop
reason from tcp_v4_conn_request(). So I just skip such case for this
moment.

For IP layer, skb drop reasons are added to the packet outputting path.
Seems the reasons are not complex, so I didn't split the commits by
functions.

For neighbour part, SKB_DROP_REASON_NEIGH_FAILED and
SKB_DROP_REASON_NEIGH_QUEUEFULL are added.

For link layer, reasons are added for both packet inputting and
outputting path.

The amount of patches in this series seems a bit too many, maybe I should
join some of them? For example, combine the patches of dev to one.

Menglong Dong (19):
  net: tcp: introduce tcp_drop_reason()
  net: tcp: add skb drop reasons to tcp_v4_rcv()
  net: tcp: use kfree_skb_reason() for tcp_v6_rcv()
  net: tcp: add skb drop reasons to tcp_v{4,6}_inbound_md5_hash()
  net: tcp: add skb drop reasons to tcp_add_backlog()
  net: tcp: use kfree_skb_reason() for tcp_v{4,6}_do_rcv()
  net: tcp: use tcp_drop_reason() for tcp_rcv_established()
  net: tcp: use tcp_drop_reason() for tcp_data_queue()
  net: tcp: use tcp_drop_reason() for tcp_data_queue_ofo()
  net: ip: add skb drop reasons during ip outputting
  net: neigh: use kfree_skb_reason() for __neigh_event_send()
  net: neigh: add skb drop reasons to arp_error_report()
  net: dev: use kfree_skb_reason() for sch_handle_egress()
  net: skb: introduce the function kfree_skb_list_reason()
  net: dev: add skb drop reasons to __dev_xmit_skb()
  net: dev: use kfree_skb_reason() for enqueue_to_backlog()
  net: dev: use kfree_skb_reason() for do_xdp_generic()
  net: dev: use kfree_skb_reason() for sch_handle_ingress()
  net: dev: use kfree_skb_reason() for __netif_receive_skb_core()

 include/linux/skbuff.h     | 82 +++++++++++++++++++++++++++++++++++++-
 include/net/tcp.h          |  3 +-
 include/trace/events/skb.h | 21 ++++++++++
 net/core/dev.c             | 25 +++++++-----
 net/core/neighbour.c       |  4 +-
 net/core/skbuff.c          |  7 ++--
 net/ipv4/arp.c             |  2 +-
 net/ipv4/ip_output.c       |  6 +--
 net/ipv4/tcp_input.c       | 45 ++++++++++++++++-----
 net/ipv4/tcp_ipv4.c        | 36 ++++++++++++-----
 net/ipv6/ip6_output.c      |  6 +--
 net/ipv6/tcp_ipv6.c        | 42 ++++++++++++++-----
 12 files changed, 227 insertions(+), 52 deletions(-)

-- 
2.34.1

