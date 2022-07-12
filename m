Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B885720BA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbiGLQZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiGLQZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:25:39 -0400
X-Greylist: delayed 1803 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Jul 2022 09:25:37 PDT
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03B3CA6D0;
        Tue, 12 Jul 2022 09:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=3fYK9aLEk4+QTiWncARzWNrEsKD8KVzMmkos5F1PmkE=; b=ETBrD
        ObyYRP1acCvA1v2Xk+F1rfuh1bcGPDlekNgLxXeQywThYUkGAguSb2jIssNRU3xbZKaunKjyo1abp
        QST18cOxcaSxdFjgPc4ZtfDwMpuXDReB/Is0OyhOXqgENfp177oFsPM657gANtc2J7fMrYLV3tq//
        xBXWuS75YGx7iq7jUkb6C6UhWzzLUF0tZDOWahVs7dNSpHokcvbKIJ0NoQeSFuMXy2fAbWvvdqGLL
        kB5Av52kVNYvNj0oRZYAzf/KucbHAaRQA4j9RGZA0m1/VgiiUuQN8AkDDXo8OU6/CsgJXoz5p2mHi
        CtTdv4ashnNp2sMyBCrd9LO3q4Lgg==;
Message-Id: <0a5679aea70e506433887cb67129241dfc32502b.1657636554.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1657636554.git.linux_oss@crudebyte.com>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Tue, 12 Jul 2022 16:31:31 +0200
Subject: [PATCH v5 09/11] 9p: add P9_ERRMAX for 9p2000 and 9p2000.u
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

This could probably be merged with the next patch, on doubt I posted it
separately as squashing is easy. The advantage of a separate patch is
making the discussion of the chosen value of max. 128 bytes more
prominent.

 include/net/9p/9p.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 24a509f559ee..13abe013af21 100644
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

