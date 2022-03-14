Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE9A4D85FB
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 14:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241790AbiCNNeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 09:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241809AbiCNNed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 09:34:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E2625C6E;
        Mon, 14 Mar 2022 06:33:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so14562345pjl.4;
        Mon, 14 Mar 2022 06:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=idHjkRIltp8O+8vjJJH3tivjjSy+7Uw6dAGEkWyyqls=;
        b=jIf+ImYJ6sIVPX6By/Flor8u44P3yt80KgXyTwADNV9LeAtplx1xircpTp47Kwz8gM
         HJOHFSD6xHVubuX1qUCi2hbdA5qJTI31kuu+bkWPCWIlS3W1nxZrp6C+gSdxx0mY/PWk
         /Wj3Mn0hWECzyab7ZFM+D1Y59JN8ndfF5FERhityrTbySAWa4vPm9FPtwqGUwAjzw4xL
         qzvgCup+4/qd5ZN8mqYv6hZAd7WK03PU/8H7ohfmv8tIiaI6uE0ndCYMo4fV9sft6qj4
         mFc98iyAtcLcER84HkGb7QfVynxDW62EyA5ituNwDpalSn0IzItGF6UGmS8Xrc3gp7m8
         0Q4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=idHjkRIltp8O+8vjJJH3tivjjSy+7Uw6dAGEkWyyqls=;
        b=qD6lUotgf9OxkR22+cMw0HJCIGMzSt/hU6GbmwalG+SGOpaljZ9bnTwYcO9XhjCnBD
         wkaqmWv12Bh2hb80t87GI6wsMs9to6q5J7cSdv4zFo3KGqLq71PFkyFm8c7yjOQwgqus
         NDmZbE1PiACIa1Wu/KVeXc4FUYKix21HknRxOj34/vFPVP4KE/V1cpN9b3S34zzYDOWN
         gMsZNqw0fPwjpBPqe6mcePuku+ZmlUdzw1YKzxB9qE+yzgQWJDK0cxl8rRlbCUTcxWKb
         gTtc9FkJGOl3ajfQJdz6PRrKuEWBJj+pvRJfo3gb4aezw5avLp0Lab+sCWumpDutlua/
         DkaA==
X-Gm-Message-State: AOAM533IWg/1xaUUa6lXFoC3KZ26+edIxGwWT/OLv/w+nHp4cTMk1avM
        /NowvcVYPaWMRDtaKBdUc1s=
X-Google-Smtp-Source: ABdhPJzERhjcfIeWCK6ca4JdxfygufBCgTMns1MKWkUniqAGhWfcDDx5kFN/dQOh9UVO/9OuSYscyQ==
X-Received: by 2002:a17:902:6ac7:b0:150:24d6:b2ee with SMTP id i7-20020a1709026ac700b0015024d6b2eemr23946345plt.168.1647264801508;
        Mon, 14 Mar 2022 06:33:21 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm22118722pfu.202.2022.03.14.06.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 06:33:20 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net: gre: add skb drop reasons to gre packet receive
Date:   Mon, 14 Mar 2022 21:33:09 +0800
Message-Id: <20220314133312.336653-1-imagedong@tencent.com>
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
to gre packet receiving path.

gre_rcv() in gre_demux.c is handled in the 1th patch.

In order to report skb drop reasons, we make erspan_rcv() return
PACKET_NEXT when no tunnel device found in the 2th patch. This may don't
correspond to 'PACKET_NEXT', but don't matter.

And gre_rcv() in ip_gre.c is handled in the 3th patch.

Following drop reasons are added(what they mean can be see in the
document for them):

SKB_DROP_REASON_GRE_VERSION
SKB_DROP_REASON_GRE_NOHANDLER
SKB_DROP_REASON_GRE_CSUM
SKB_DROP_REASON_GRE_NOTUNNEL

Maybe SKB_DROP_REASON_GRE_NOHANDLER can be replaced with
SKB_DROP_REASON_GRE_VERSION? As no gre_protocol found means that gre
version not supported.

PS: This set is parallel with the set "net: icmp: add skb drop reasons
to icmp", please don't mind :)

Menglong Dong (3):
  net: gre_demux: add skb drop reasons to gre_rcv()
  net: ipgre: make erspan_rcv() return PACKET_NEXT
  net: ipgre: add skb drop reasons to gre_rcv()

 include/linux/skbuff.h     |  6 ++++++
 include/trace/events/skb.h |  4 ++++
 net/ipv4/gre_demux.c       | 12 +++++++++---
 net/ipv4/ip_gre.c          | 30 +++++++++++++++++++-----------
 4 files changed, 38 insertions(+), 14 deletions(-)

-- 
2.35.1

