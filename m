Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD3B1D1A6A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389322AbgEMQAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730291AbgEMQAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:00:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B4AC061A0C;
        Wed, 13 May 2020 09:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=LNedO/lL6g8P+QsVFWLVScVEptUSGiGTZWf8H0Q1tZA=; b=ts6e9NT3V8yWz+LtzMv4rkdZ9o
        XbzoWSyGT3XedYSLPIj2l6bU4/dtfPsyiiWLH7hDxVoGc5UARJtUkqtzIeGq49lKa+AH0Y5npVY+C
        GVBD8kLvOcKLvEv9Cs4LZ9gdVRDBPbJ2xsSV6iwElSwImuy3J/L600ewA46WTY+x6LUru76Dld5Z4
        RdH5Amf2Zyhi+L13cBm+CM2uPPF/6wtVYe3dcqbZJGJZnPKhOsMNYAFD5VOJeLWv72DTVTzbyEc+g
        o1JJZVtP60V/kezBLynuXYzyh58pSRH1z5B4gCAc0iAV811dyi8ZT2p1mJhHS9+p0s/rjnGeRe5gO
        4bAHy9Kw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYtoO-0004hf-FL; Wed, 13 May 2020 16:00:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] maccess: remove duplicate kerneldoc comments
Date:   Wed, 13 May 2020 18:00:23 +0200
Message-Id: <20200513160038.2482415-4-hch@lst.de>
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

Many of the maccess routines have a copy of the kerneldoc comment
in the header.  Remove it as it is not useful and will get out of
sync sooner or later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uaccess.h | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index a2c606a403745..5a36a298a85f8 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -301,50 +301,12 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
 	return 0;
 }
 
-/*
- * probe_kernel_read(): safely attempt to read from a location
- * @dst: pointer to the buffer that shall take the data
- * @src: address to read from
- * @size: size of the data chunk
- *
- * Safely read from address @src to the buffer at @dst.  If a kernel fault
- * happens, handle that and return -EFAULT.
- */
 extern long probe_kernel_read(void *dst, const void *src, size_t size);
 extern long probe_kernel_read_strict(void *dst, const void *src, size_t size);
 extern long __probe_kernel_read(void *dst, const void *src, size_t size);
-
-/*
- * probe_user_read(): safely attempt to read from a location in user space
- * @dst: pointer to the buffer that shall take the data
- * @src: address to read from
- * @size: size of the data chunk
- *
- * Safely read from address @src to the buffer at @dst.  If a kernel fault
- * happens, handle that and return -EFAULT.
- */
 extern long probe_user_read(void *dst, const void __user *src, size_t size);
 
-/*
- * probe_kernel_write(): safely attempt to write to a location
- * @dst: address to write to
- * @src: pointer to the data that shall be written
- * @size: size of the data chunk
- *
- * Safely write to address @dst from the buffer at @src.  If a kernel fault
- * happens, handle that and return -EFAULT.
- */
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
-
-/*
- * probe_user_write(): safely attempt to write to a location in user space
- * @dst: address to write to
- * @src: pointer to the data that shall be written
- * @size: size of the data chunk
- *
- * Safely write to address @dst from the buffer at @src.  If a kernel fault
- * happens, handle that and return -EFAULT.
- */
 extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
 
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
-- 
2.26.2

