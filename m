Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07F55AA3F
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 12:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfF2KhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 06:37:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:32904 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbfF2KhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 06:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uTDlF+zQKXMUALgYYRdQdcgqMwwJihOMPPoyN3PeAAs=; b=S0QWx/dVE6Hbq+h69nxAh2nr1
        RDel5rtPeupzI1mnh1c/WGyUQXfiIMe8jsINY/NsObqeKAGt+u59zb4i/unrCOh4wtBSsu3Ra+5wi
        9MILaMxJ3/H639Mn2Rgao9ZUhWSHAIAhde3ZSDNlVs2CJ5WQ7CES4deBkBS0KVJpGxOoU9qshC194
        66xa3FNglpH4d/QD4tME4TNi4QcSqeQb4BEEZCHXcNkEbc63g436Guu3adiSnTPdLylfnypUmwdip
        BsGenvD5R+dIwBfSRwDTyktnpFTFWjLpq1hurBH7YioCOZNo560nlM2TtFwyUWla/rJ9Mm2qCvqbW
        O5mr+rsAw==;
Received: from [187.113.3.250] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hhAjC-0002eX-54; Sat, 29 Jun 2019 10:37:06 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hhAjA-0006lM-84; Sat, 29 Jun 2019 07:37:04 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] docs: packing: move it to core-api book and adjust markups
Date:   Sat, 29 Jun 2019 07:37:02 -0300
Message-Id: <46cb79dbc4bbff3e5a4e77b548df1e92c105ed0f.1561804613.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packing.txt file was misplaced, as docs should be part of
a documentation book, and not at the root dir.

So, move it to the core-api directory and add to its index.

Also, ensure that the file will be properly parsed and the bitmap
ascii artwork will use a monotonic font.

Fixes: 554aae35007e ("lib: Add support for generic packing operations")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/core-api/index.rst              |  1 +
 .../{packing.txt => core-api/packing.rst}     | 81 +++++++++++--------
 2 files changed, 50 insertions(+), 32 deletions(-)
 rename Documentation/{packing.txt => core-api/packing.rst} (61%)

diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index d1e5b95bf86d..aebb16d7771f 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -25,6 +25,7 @@ Core utilities
    librs
    genalloc
    errseq
+   packing
    printk-formats
    circular-buffers
    generic-radix-tree
diff --git a/Documentation/packing.txt b/Documentation/core-api/packing.rst
similarity index 61%
rename from Documentation/packing.txt
rename to Documentation/core-api/packing.rst
index f830c98645f1..d8c341fe383e 100644
--- a/Documentation/packing.txt
+++ b/Documentation/core-api/packing.rst
@@ -30,6 +30,7 @@ The solution
 ------------
 
 This API deals with 2 basic operations:
+
   - Packing a CPU-usable number into a memory buffer (with hardware
     constraints/quirks)
   - Unpacking a memory buffer (which has hardware constraints/quirks)
@@ -49,10 +50,12 @@ What the examples show is where the logical bytes and bits sit.
 
 1. Normally (no quirks), we would do it like this:
 
-63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
-7                       6                       5                        4
-31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
-3                       2                       1                        0
+::
+
+  63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
+  7                       6                       5                        4
+  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
+  3                       2                       1                        0
 
 That is, the MSByte (7) of the CPU-usable u64 sits at memory offset 0, and the
 LSByte (0) of the u64 sits at memory offset 7.
@@ -63,10 +66,12 @@ comments as "logical" notation.
 
 2. If QUIRK_MSB_ON_THE_RIGHT is set, we do it like this:
 
-56 57 58 59 60 61 62 63 48 49 50 51 52 53 54 55 40 41 42 43 44 45 46 47 32 33 34 35 36 37 38 39
-7                       6                        5                       4
-24 25 26 27 28 29 30 31 16 17 18 19 20 21 22 23  8  9 10 11 12 13 14 15  0  1  2  3  4  5  6  7
-3                       2                        1                       0
+::
+
+  56 57 58 59 60 61 62 63 48 49 50 51 52 53 54 55 40 41 42 43 44 45 46 47 32 33 34 35 36 37 38 39
+  7                       6                        5                       4
+  24 25 26 27 28 29 30 31 16 17 18 19 20 21 22 23  8  9 10 11 12 13 14 15  0  1  2  3  4  5  6  7
+  3                       2                        1                       0
 
 That is, QUIRK_MSB_ON_THE_RIGHT does not affect byte positioning, but
 inverts bit offsets inside a byte.
@@ -74,10 +79,12 @@ inverts bit offsets inside a byte.
 
 3. If QUIRK_LITTLE_ENDIAN is set, we do it like this:
 
-39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56
-4                       5                       6                       7
-7  6  5  4  3  2  1  0  15 14 13 12 11 10  9  8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
-0                       1                       2                       3
+::
+
+  39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56
+  4                       5                       6                       7
+  7  6  5  4  3  2  1  0  15 14 13 12 11 10  9  8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
+  0                       1                       2                       3
 
 Therefore, QUIRK_LITTLE_ENDIAN means that inside the memory region, every
 byte from each 4-byte word is placed at its mirrored position compared to
@@ -86,18 +93,22 @@ the boundary of that word.
 4. If QUIRK_MSB_ON_THE_RIGHT and QUIRK_LITTLE_ENDIAN are both set, we do it
    like this:
 
-32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
-4                       5                       6                       7
-0  1  2  3  4  5  6  7  8   9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
-0                       1                       2                       3
+::
+
+  32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
+  4                       5                       6                       7
+  0  1  2  3  4  5  6  7  8   9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
+  0                       1                       2                       3
 
 
 5. If just QUIRK_LSW32_IS_FIRST is set, we do it like this:
 
-31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
-3                       2                       1                        0
-63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
-7                       6                       5                        4
+::
+
+  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
+  3                       2                       1                        0
+  63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
+  7                       6                       5                        4
 
 In this case the 8 byte memory region is interpreted as follows: first
 4 bytes correspond to the least significant 4-byte word, next 4 bytes to
@@ -107,28 +118,34 @@ the more significant 4-byte word.
 6. If QUIRK_LSW32_IS_FIRST and QUIRK_MSB_ON_THE_RIGHT are set, we do it like
    this:
 
-24 25 26 27 28 29 30 31 16 17 18 19 20 21 22 23  8  9 10 11 12 13 14 15  0  1  2  3  4  5  6  7
-3                       2                        1                       0
-56 57 58 59 60 61 62 63 48 49 50 51 52 53 54 55 40 41 42 43 44 45 46 47 32 33 34 35 36 37 38 39
-7                       6                        5                       4
+::
+
+  24 25 26 27 28 29 30 31 16 17 18 19 20 21 22 23  8  9 10 11 12 13 14 15  0  1  2  3  4  5  6  7
+  3                       2                        1                       0
+  56 57 58 59 60 61 62 63 48 49 50 51 52 53 54 55 40 41 42 43 44 45 46 47 32 33 34 35 36 37 38 39
+  7                       6                        5                       4
 
 
 7. If QUIRK_LSW32_IS_FIRST and QUIRK_LITTLE_ENDIAN are set, it looks like
    this:
 
-7  6  5  4  3  2  1  0  15 14 13 12 11 10  9  8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
-0                       1                       2                       3
-39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56
-4                       5                       6                       7
+::
+
+  7  6  5  4  3  2  1  0  15 14 13 12 11 10  9  8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
+  0                       1                       2                       3
+  39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56
+  4                       5                       6                       7
 
 
 8. If QUIRK_LSW32_IS_FIRST, QUIRK_LITTLE_ENDIAN and QUIRK_MSB_ON_THE_RIGHT
    are set, it looks like this:
 
-0  1  2  3  4  5  6  7  8   9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
-0                       1                       2                       3
-32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
-4                       5                       6                       7
+::
+
+  0  1  2  3  4  5  6  7  8   9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
+  0                       1                       2                       3
+  32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
+  4                       5                       6                       7
 
 
 We always think of our offsets as if there were no quirk, and we translate
-- 
2.21.0

