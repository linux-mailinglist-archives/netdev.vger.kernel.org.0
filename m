Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1E04FF271
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiDMIqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiDMIqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:46:08 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11EF4F458;
        Wed, 13 Apr 2022 01:43:48 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v12so1377498plv.4;
        Wed, 13 Apr 2022 01:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WXJ0x6B6fscSnw3U9TyMu1fz6RdndgOIc6aGYEspekU=;
        b=A5UEdlb2sTcqbwV2HtfB+uLhHQHyAFhwdjCN3Tz6+lBNarziZOCRVXV74sSQEzU870
         RABQJbnF37Ny5JTuykqxg1FPJDsRi1Kdlu3PpB9ymjKIKb9luu+1y/9UgET8peOEpQTi
         9IoyWfTRCG0F92lWWVucyTmXKaM0c3JAOMSVz/pB5ZenEalc8sFIVHNz3F7cXj+cV3fJ
         3sjMmRZKutveDMEDQNuRgQr3RzXcRtjjjtnPNWCcjiZ3rAv2izQZYpShvX8T+qAv64ir
         mnNkfxW4OkSnNCnxJdH+YjOUNFmk0z7Thuoop3Z6DG/qxQf8tVekgWbV2KM/mykI3Cus
         Coow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WXJ0x6B6fscSnw3U9TyMu1fz6RdndgOIc6aGYEspekU=;
        b=ZHIGzJNsfw9apsn21szXI+cKIG84lu4qrU+y8GYgUut67uheutDt9kfrdah1DJR/My
         m+B5RbT5oad/et3il1EmY++Jnf/gDVW4jg7wzP0Lz/yXAht4DNUBOTh8l/pTYwU6xJtm
         bSqqbMphUq+qKdAn+d3BP3zhIEwdFfShOQJoBfyQcQb4eLJgYVG6334Gcf5lj5tW5goW
         XlyK+prGjbSRvMT23K9UVtFtbNNSPZ4p37U60IKEu/TQcE6H9YB4pBg6VaRAXlg8uPM2
         hu0MFOOohhCX3HhtD9bTKqb8wfLFut6YyY1rD7jQGY41eCosmusZJW21zeTRL6m6Y4Nx
         cT6A==
X-Gm-Message-State: AOAM531oYKY5bgFz0SWGCa4Tfl7vq9BkKBYdch0wAC7B2UjPmXns8vQD
        V2NzZEebA+1s7ptcasa8gYE=
X-Google-Smtp-Source: ABdhPJzerT6Pr78YbDL8k6DjXS6/h7frfnlot8xyPo/lggGRdxCNVvR2digAkLVaqX1MtHe4TSWzDA==
X-Received: by 2002:a17:90b:1c8e:b0:1bf:364c:dd7a with SMTP id oo14-20020a17090b1c8e00b001bf364cdd7amr9482472pjb.103.1649839428272;
        Wed, 13 Apr 2022 01:43:48 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm2410335pgh.65.2022.04.13.01.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:43:47 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/9] net: ip: add skb drop reasons to ip ingress
Date:   Wed, 13 Apr 2022 16:15:51 +0800
Message-Id: <20220413081600.187339-1-imagedong@tencent.com>
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

In the series "net: use kfree_skb_reason() for ip/udp packet receive",
skb drop reasons are added to the basic ingress path of IPv4. And in
the series "net: use kfree_skb_reason() for ip/neighbour", the egress
paths of IPv4 and IPv6 are handled. Related links:

https://lore.kernel.org/netdev/20220205074739.543606-1-imagedong@tencent.com/
https://lore.kernel.org/netdev/20220226041831.2058437-1-imagedong@tencent.com/

Seems we still have a lot work to do with IP layer, including IPv6 basic
ingress path, IPv4/IPv6 forwarding, IPv6 exthdrs, fragment and defrag,
etc.

In this series, skb drop reasons are added to the basic ingress path of
IPv6 protocol and IPv4/IPv6 packet forwarding. Following functions, which
are used for IPv6 packet receiving are handled:

  ip6_pkt_drop()
  ip6_rcv_core()
  ip6_protocol_deliver_rcu()

And following functions that used for IPv6 TLV parse are handled:

  ip6_parse_tlv()
  ipv6_hop_ra()
  ipv6_hop_ioam()
  ipv6_hop_jumbo()
  ipv6_hop_calipso()
  ipv6_dest_hao()

Besides, ip_forward() and ip6_forward(), which are used for IPv4/IPv6
forwarding, are also handled. And following new drop reasons are added:

  /* host unreachable, corresponding to IPSTATS_MIB_INADDRERRORS */
  SKB_DROP_REASON_IP_INADDRERRORS
  /* network unreachable, corresponding to IPSTATS_MIB_INADDRERRORS */
  SKB_DROP_REASON_IP_INNOROUTES
  /* packet size is too big, corresponding to
   * IPSTATS_MIB_INTOOBIGERRORS
   */
  SKB_DROP_REASON_PKT_TOO_BIG

In order to simply the definition and assignment for
'enum skb_drop_reason', some helper functions are introduced in the 1th
patch. I'm not such if this is necessary, but it makes the code simpler.
For example, we can replace the code:

  if (reason == SKB_DROP_REASON_NOT_SPECIFIED)
          reason = SKB_DROP_REASON_IP_INHDR;

with:

  SKB_DR_OR(reason, IP_INHDR);


In the 6th patch, the statistics for skb in ipv6_hop_jum() is removed,
as I think it is redundant. There are two call chains for
ipv6_hop_jumbo(). The first one is:

  ipv6_destopt_rcv() -> ip6_parse_tlv() -> ipv6_hop_jumbo()

On this call chain, the drop statistics will be done in
ipv6_destopt_rcv() with 'IPSTATS_MIB_INHDRERRORS' if ipv6_hop_jumbo()
returns false.

The second call chain is:

  ip6_rcv_core() -> ipv6_parse_hopopts() -> ip6_parse_tlv()

And the drop statistics will also be done in ip6_rcv_core() with
'IPSTATS_MIB_INHDRERRORS' if ipv6_hop_jumbo() returns false.

Therefore, the statistics in ipv6_hop_jumbo() is redundant, which
means the drop is counted twice. The statistics in ipv6_hop_jumbo()
is almost the same as the outside, except the
'IPSTATS_MIB_INTRUNCATEDPKTS', which seems that we have to ignore it.


======================================================================

Here is a basic test for IPv6 forwarding packet drop that monitored by
'dropwatch' tool:

  drop at: ip6_forward+0x81a/0xb70 (0xffffffff86c73f8a)
  origin: software
  input port ifindex: 7
  timestamp: Wed Apr 13 11:51:06 2022 130010176 nsec
  protocol: 0x86dd
  length: 94
  original length: 94
  drop reason: IP_INADDRERRORS

The origin cause of this case is that IPv6 doesn't allow to forward the
packet with LOCAL-LINK saddr, and results the 'IP_INADDRERRORS' drop
reason.

Menglong Dong (9):
  skb: add some helpers for skb drop reasons
  net: ipv4: add skb drop reasons to ip_error()
  net: ipv6: add skb drop reasons to ip6_pkt_drop()
  net: ip: add skb drop reasons to ip forwarding
  net: icmp: introduce function icmpv6_param_prob_reason()
  net: ipv6: remove redundant statistics in ipv6_hop_jumbo()
  net: ipv6: add skb drop reasons to TLV parse
  net: ipv6: add skb drop reasons to ip6_rcv_core()
  net: ipv6: add skb drop reasons to ip6_protocol_deliver_rcu()

 include/linux/icmpv6.h     | 11 +++++++++--
 include/linux/skbuff.h     | 21 ++++++++++++++++++++
 include/trace/events/skb.h |  3 +++
 net/ipv4/ip_forward.c      | 13 ++++++++++---
 net/ipv4/route.c           |  6 +++++-
 net/ipv6/exthdrs.c         | 39 +++++++++++++++++++++----------------
 net/ipv6/icmp.c            |  7 ++++---
 net/ipv6/ip6_input.c       | 40 ++++++++++++++++++++++++++------------
 net/ipv6/ip6_output.c      |  9 ++++++---
 net/ipv6/route.c           |  6 +++++-
 10 files changed, 113 insertions(+), 42 deletions(-)

-- 
2.35.1

