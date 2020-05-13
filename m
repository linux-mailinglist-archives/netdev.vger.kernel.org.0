Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41561D1A76
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389637AbgEMQCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389239AbgEMQAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:00:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3F4C061A0C;
        Wed, 13 May 2020 09:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FhwjB9eDi0xwZgnRZDImeNjcc9cNIZkOcwQVq4y1nSU=; b=lOm9ncVZZ4LTAXKO6MEmgtDQ8Q
        rynKHnIgLrP3eW7KtIkS/ngpPCJy/SCXJgvjYuoLtr/z+Jg15+5cPWcjzq8kQ4qKkbATI+kUAFhuK
        8ibPJOjJ5wWaGe41UFRqJyoQu7uPKO1EaBkliPcdbiv6QMKBaJ+hJHwyRBZ4E+qhSlkbNIs92pgpD
        D0V0bJjoaxCrQuSnSzlUOu2Eqnh1VrBV34CZBVgj03CrYM+yo42vlR43DXhVpr2frrh6XoHMadw0h
        Y47CvUD+JPfjfcQ2TgtnCi9/zYhgKNuoGYFr2iSPKeuUUcMoStYpLqfozzivuWWQbGaEmFiYvf8tx
        oOs+q3mg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYtoL-0004go-Sc; Wed, 13 May 2020 16:00:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] maccess: remove various unused weak aliases
Date:   Wed, 13 May 2020 18:00:22 +0200
Message-Id: <20200513160038.2482415-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513160038.2482415-1-hch@lst.de>
References: <20200513160038.2482415-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

maccess tends to define lots of underscore prefixed symbols that then
have other weak aliases.  But except for two cases they are never
actually used, so remove them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uaccess.h |  3 ---
 mm/maccess.c            | 19 +++----------------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 67f016010aad5..a2c606a403745 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -324,7 +324,6 @@ extern long __probe_kernel_read(void *dst, const void *src, size_t size);
  * happens, handle that and return -EFAULT.
  */
 extern long probe_user_read(void *dst, const void __user *src, size_t size);
-extern long __probe_user_read(void *dst, const void __user *src, size_t size);
 
 /*
  * probe_kernel_write(): safely attempt to write to a location
@@ -336,7 +335,6 @@ extern long __probe_user_read(void *dst, const void __user *src, size_t size);
  * happens, handle that and return -EFAULT.
  */
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
-extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size);
 
 /*
  * probe_user_write(): safely attempt to write to a location in user space
@@ -348,7 +346,6 @@ extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size
  * happens, handle that and return -EFAULT.
  */
 extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
-extern long notrace __probe_user_write(void __user *dst, const void *src, size_t size);
 
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
diff --git a/mm/maccess.c b/mm/maccess.c
index cf21e604f78cb..4e7f3b6eb05ae 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -79,11 +79,7 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
  * Safely read from user address @src to the buffer at @dst. If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-
-long __weak probe_user_read(void *dst, const void __user *src, size_t size)
-    __attribute__((alias("__probe_user_read")));
-
-long __probe_user_read(void *dst, const void __user *src, size_t size)
+long probe_user_read(void *dst, const void __user *src, size_t size)
 {
 	long ret = -EFAULT;
 	mm_segment_t old_fs = get_fs();
@@ -106,11 +102,7 @@ EXPORT_SYMBOL_GPL(probe_user_read);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-
-long __weak probe_kernel_write(void *dst, const void *src, size_t size)
-    __attribute__((alias("__probe_kernel_write")));
-
-long __probe_kernel_write(void *dst, const void *src, size_t size)
+long probe_kernel_write(void *dst, const void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
@@ -131,11 +123,7 @@ long __probe_kernel_write(void *dst, const void *src, size_t size)
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-
-long __weak probe_user_write(void __user *dst, const void *src, size_t size)
-    __attribute__((alias("__probe_user_write")));
-
-long __probe_user_write(void __user *dst, const void *src, size_t size)
+long probe_user_write(void __user *dst, const void *src, size_t size)
 {
 	long ret = -EFAULT;
 	mm_segment_t old_fs = get_fs();
@@ -171,7 +159,6 @@ long __probe_user_write(void __user *dst, const void *src, size_t size)
  * probing memory on a user address range where strncpy_from_unsafe_user() is
  * supposed to be used instead.
  */
-
 long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
     __attribute__((alias("__strncpy_from_unsafe")));
 
-- 
2.26.2

