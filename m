Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB5F44BDD2
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 10:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhKJJf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 04:35:57 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:54504 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230456AbhKJJfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 04:35:55 -0500
Received: from localhost.localdomain (unknown [124.16.141.244])
        by APP-03 (Coremail) with SMTP id rQCowAC3v6u1kYthkxehBg--.395S2;
        Wed, 10 Nov 2021 17:32:38 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sunrpc: Remove unneeded null check
Date:   Wed, 10 Nov 2021 09:32:17 +0000
Message-Id: <20211110093217.67301-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowAC3v6u1kYthkxehBg--.395S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZw47AFWDuFykAry7KrWkCrg_yoW3Jrg_G3
        9YvF4Dt3Z7CFZ8ur43J3y7A345ua40kF1xWrnFgF9xGa1rtr1rZrZ5Zr4kAryUCrWrGrZ3
        Ja4ku34Yyw1I9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb28YjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xSY4AK67AK6r4fMxAIw28I
        cxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42
        IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jomhrUUUUU=
X-Originating-IP: [124.16.141.244]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCgcBA1z4kHlyRAAAs0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In g_verify_token_header, the null check of 'ret'
is unneeded to be done twice.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 net/sunrpc/auth_gss/gss_generic_token.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_generic_token.c b/net/sunrpc/auth_gss/gss_generic_token.c
index fe97f3106536..4a4082bb22ad 100644
--- a/net/sunrpc/auth_gss/gss_generic_token.c
+++ b/net/sunrpc/auth_gss/gss_generic_token.c
@@ -222,10 +222,8 @@ g_verify_token_header(struct xdr_netobj *mech, int *body_size,
 	if (ret)
 		return ret;
 
-	if (!ret) {
-		*buf_in = buf;
-		*body_size = toksize;
-	}
+	*buf_in = buf;
+	*body_size = toksize;
 
 	return ret;
 }
-- 
2.25.1

