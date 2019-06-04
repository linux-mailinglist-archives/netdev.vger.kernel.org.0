Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F18341AF
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 10:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfFDIV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 04:21:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46645 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbfFDIV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 04:21:56 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hY4hW-0000Zg-O1; Tue, 04 Jun 2019 08:21:46 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next][V2] bpf: remove redundant assignment to err
Date:   Tue,  4 Jun 2019 09:21:46 +0100
Message-Id: <20190604082146.2049-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is assigned with the value -EINVAL that is never
read and it is re-assigned a new value later on.  The assignment is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>

---

V2: reorder variables as recommended by Jakub Kicinski to keep in
    the networking code style.

---
 kernel/bpf/devmap.c | 2 +-
 kernel/bpf/xskmap.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 5ae7cce5ef16..b58a33ca8a27 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -88,8 +88,8 @@ static u64 dev_map_bitmap_size(const union bpf_attr *attr)
 static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_dtab *dtab;
-	int err = -EINVAL;
 	u64 cost;
+	int err;
 
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 22066c28ba61..413d75f4fc72 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -17,8 +17,8 @@ struct xsk_map {
 
 static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 {
-	int cpu, err = -EINVAL;
 	struct xsk_map *m;
+	int cpu, err;
 	u64 cost;
 
 	if (!capable(CAP_NET_ADMIN))
-- 
2.20.1

