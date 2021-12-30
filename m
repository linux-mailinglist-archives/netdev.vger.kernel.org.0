Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B409481D3A
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240213AbhL3Om0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:42:26 -0500
Received: from lizzy.crudebyte.com ([91.194.90.13]:59481 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240346AbhL3Om0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:42:26 -0500
X-Greylist: delayed 1810 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 09:42:25 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=7rxL+vVkRtDypNlhYjU20nqnGaFCHwV4VaWOzz8KKMM=; b=NQfff
        V9vMFphX1kMzXuSR3poklB7Vz+H+CSH0BlqZJOc0Ud+axB9zRLMJK5i42CHu1mkAxXmS6m/3Y2KUY
        kvS7fdqzzwH+ItfsyVsfDs14ul/GetOZ1LkMJ/qSuIa0CPh+TXur/y3QRVF3IIgkAYQpAo5TUeia+
        2k7m4SNn+Ydx6XR7tazOvIiqiFqhYwXc6Yzex1aw5VEOHVmZRoz74EqNBKiyvN37jMHN0vFL0Dzxe
        WLHluCS5vRZmPs3vvIiCpKnTXXabljPizwA9gigb9ndQ+wUwQBlEIG+vXnkt2+Q3SEf2PsGEL/yr5
        BblsVky48VejvDHi0BOSqum3zQxPQ==;
Message-Id: <7cb10547a122c32fdafd68c77f0625f9a4d9a8bf.1640870037.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1640870037.git.linux_oss@crudebyte.com>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 30 Dec 2021 14:23:18 +0100
Subject: [PATCH v4 10/12] 9p: add P9_ERRMAX for 9p2000 and 9p2000.u
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add P9_ERRMAX macro to 9P protocol header which reflects the maximum
error string length of Rerror replies for 9p2000 and 9p2000.u protocol
versions. Unfortunately a maximum error string length is not defined by
the 9p2000 spec, picking 128 as value for now, as this seems to be a
common max. size for POSIX error strings in practice.

9p2000.L protocol version uses Rlerror replies instead which does not
contain an error string.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 include/net/9p/9p.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 9c6ec78e47a5..a447acc55b02 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -331,6 +331,9 @@ enum p9_qid_t {
 /* size of header for zero copy read/write */
 #define P9_ZC_HDR_SZ 4096
 
+/* maximum length of an error string */
+#define P9_ERRMAX 128
+
 /**
  * struct p9_qid - file system entity information
  * @type: 8-bit type &p9_qid_t
-- 
2.30.2

