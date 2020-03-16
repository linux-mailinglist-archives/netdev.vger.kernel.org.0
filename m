Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A809186511
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 07:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgCPGgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 02:36:18 -0400
Received: from mail.wangsu.com ([123.103.51.198]:36210 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728302AbgCPGgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 02:36:18 -0400
Received: from 137.localdomain (unknown [218.107.205.216])
        by app1 (Coremail) with SMTP id xjNnewDn7Q1cHm9ew20FAA--.217S2;
        Mon, 16 Mar 2020 14:36:13 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, ncardwell@google.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH RESEND net-next v2 0/5] tcp: fix stretch ACK bugs in congestion control modules
Date:   Mon, 16 Mar 2020 14:35:06 +0800
Message-Id: <1584340511-9870-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: xjNnewDn7Q1cHm9ew20FAA--.217S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZF1fuF1kWry8GF4rXrW3Awb_yoWDKFbEyF
        92ga98Gr1UXFWDXayIkrn8Ar90yrWjyr1UXF4Dt3yDt347t34UGr4DtrW8urn7Xa1q9Fy8
        WrnxtrW8Aw47JjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbO8Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
        II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7
        xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84AC
        jcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrV
        ACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8GwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
        F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8AwCF04
        k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4U
        MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
        AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0
        cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcV
        C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
        nUUI43ZEXa7VU00PfPUUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"stretch ACKs" (caused by LRO, GRO, delayed ACKs or middleboxes)
can cause serious performance shortfalls in common congestion
control algorithms. Neal Cardwell submitted a series of patches
starting with commit e73ebb0881ea ("tcp: stretch ACK fixes prep")
to handle stretch ACKs and fixed stretch ACK bugs in Reno and
CUBIC congestion control algorithms.

This patch series continues to fix bic, scalable, veno and yeah
congestion control algorithms to handle stretch ACKs.

Changes in v2:
- Provide [PATCH 0/N] to describe the modifications of this patch series

Pengcheng Yang (5):
  tcp: fix stretch ACK bugs in BIC
  tcp: fix stretch ACK bugs in Scalable
  tcp: stretch ACK fixes in Veno prep
  tcp: fix stretch ACK bugs in Veno
  tcp: fix stretch ACK bugs in Yeah

 net/ipv4/tcp_bic.c      | 11 ++++++-----
 net/ipv4/tcp_scalable.c | 17 +++++++++--------
 net/ipv4/tcp_veno.c     | 47 +++++++++++++++++++++++++----------------------
 net/ipv4/tcp_yeah.c     | 41 +++++++++++------------------------------
 4 files changed, 51 insertions(+), 65 deletions(-)

-- 
1.8.3.1

