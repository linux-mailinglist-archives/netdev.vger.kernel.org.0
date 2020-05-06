Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FDF1C6886
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgEFGWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726438AbgEFGWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:22:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E82C061A0F;
        Tue,  5 May 2020 23:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=81hDLaNsDP1XezBBCmTYO/9RleZtnLgOrYL3Jzc5rEw=; b=UfFMsr6xSvCXGCrvOio6KrmUxi
        d/sfiO1kbxx8K0U5EcYhJoZj89AMYERgq5iIWTq1xJVH1XsLtEdCz4DGIodr08wNYzmGd8PRBdxdQ
        UU+Tqg0tQPE/k946BA/+BkLfSfXHMX2vyYWqPhuDluLdhYD8ujZPuUNj57wkjxeNgHAFd9n0sBvSs
        iJdYEGhZSDnqcey/wzNI26KXIwB4uSDSQpj8Dkou6Ee7eb4au5dnJpBTjLlDRV3UwEKokf4nlEOt1
        ySIX7Q2cPBjexWBgU6vy4mlQGBoRpprJ8IsJwLo9q/N1QTYQrlZO9XcFmZbeL7B1x6Dk4fGXShWqS
        7gnyf2NA==;
Received: from [2001:4bb8:191:66b6:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWDRs-0006K5-Ms; Wed, 06 May 2020 06:22:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/15] maccess: unexport probe_kernel_write and probe_user_write
Date:   Wed,  6 May 2020 08:22:09 +0200
Message-Id: <20200506062223.30032-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200506062223.30032-1-hch@lst.de>
References: <20200506062223.30032-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two functions are not used by any modular code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/maccess.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index 3ca8d97e50106..cf21e604f78cb 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -121,7 +121,6 @@ long __probe_kernel_write(void *dst, const void *src, size_t size)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(probe_kernel_write);
 
 /**
  * probe_user_write(): safely attempt to write to a user-space location
@@ -148,7 +147,6 @@ long __probe_user_write(void __user *dst, const void *src, size_t size)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(probe_user_write);
 
 /**
  * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
-- 
2.26.2

