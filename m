Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A7A34A5DF
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCZKw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:52:59 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55653 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230147AbhCZKwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:52:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D3155C0417
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:52:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 26 Mar 2021 06:52:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=y2bM9dRopkzoEk8lqZkxxBzci4
        WE3q4rVkAPN6fxBu4=; b=GkS61G1P15h4plo25xeOLGZhOYMLWKFJ1EvNP5JiVk
        HGPm0Sj7lzztpGHLF5cjk91jn26eFjyKagwSlDMswJGRRJYcHN060K3R4PB3wTZO
        VsTLVABZgo2AhHV2w1xMwAymu3Py2njYWZUobQeH35nCzxoa7ucwRPsajF02WIGH
        xvErP26UvHHK1tp7JaCxmoobvPBxUFW0miauwE52tlaU1ycPdrnJ9+Tn8qszNSUJ
        FN2cpQsVyAZiz+n3Avp+j3yAdovGhiVhbrKE/RPByR6EqsJIwFCMA+DdkNp90COh
        0ND+MMfdWQ+2JJQFFYoGsQdifJt/otW5NOv3vs1LyODw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=y2bM9d
        RopkzoEk8lqZkxxBzci4WE3q4rVkAPN6fxBu4=; b=GRUNmnuOLKOuIDXMT9r5bt
        rj1+fuv3PmveHPbOsWuoma4Gjx3pVCRgkekNPRHRln2snycHnvt7GCbwodoKtIwK
        t77NYTQF1E7TCcwlRLgSLc4s+6ie4fSMr9Q0+mY2ZSfNJBTWOXqIW5tqG2or3WqZ
        CcoqA/b20yDuwL+CWLAbkQ69H5DENdmVdP+mxKvVnnDEXNm2NERNc65WdGQSHl1C
        uiL1ynktZXvUWVIp0OLqnm2uwAitUeZUSv0O8LLPf9o0A4+79DvbAikyLww1o47F
        Xxh2uOr1OuEPQgWXvRi+eBM4/nnulm4/smeC0zhjVqNeXeTv5ws1wmjPHB0TfJ4A
        ==
X-ME-Sender: <xms:8bxdYK2eAluZKdwoc2_WHDZg9wIyiVPUsS_T0XW2kk10OeB3JXlpYQ>
    <xme:8bxdYNEZH7CENWFwji2R-Eee_94nZ_s4zTb1sxWh8xM8HGSynROVN4lWO1icFBLGJ
    1PVEytUUJKNXU7duQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehvddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvffftggfggfgsehtjeertd
    dtreejnecuhfhrohhmpeevhhhrihhsthhophhhvghrucfvrghlsghothcuoegthhhrihhs
    sehtrghlsghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepieeitdevveegje
    euveeflefhhfeffeeijeffffeiteeifffhveeigeeghfevffdunecukfhppeejvddrleeh
    rddvgeefrdduheeinecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomheptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:8bxdYC4cfPCF0WO7G2lqC8DG4BdvxKfTYCA92isSjDKc7BPw4mH-lw>
    <xmx:8bxdYL2_dAkRK6NjjeFZGBtHt8d9epVJ78dt2qsrUO7BXU4yB1Q9Rg>
    <xmx:8bxdYNE1ec9n--t7njPX9V1V-trMiPrsH_ebblQXWNKLFcu95CO1eQ>
    <xmx:8bxdYBRSNUoKAwIrGxvlORujXHZtrOovwO-GCwaeUjsMMiAkpMnpIg>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 011BE24005A
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:52:32 -0400 (EDT)
Message-ID: <dada9dfe9b84c03acdb50c9d36f43af5d51813f9.camel@talbothome.com>
Subject: [PATCH 8/9] Allow Maintainer mode to compile without -WError
From:   Christopher Talbot <chris@talbothome.com>
To:     netdev@vger.kernel.org
Date:   Fri, 26 Mar 2021 06:52:32 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this, compiling in maintainer mode errors out.

---
 acinclude.m4 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/acinclude.m4 b/acinclude.m4
index 329c6a9..314dbb1 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -15,7 +15,7 @@ AC_DEFUN([COMPILER_FLAGS], [
                CFLAGS="-Wall -O2 -D_FORTIFY_SOURCE=2"
        fi
        if (test "$USE_MAINTAINER_MODE" = "yes"); then
-               CFLAGS+=" -Werror -Wextra"
+               CFLAGS+=" -Wextra"
                CFLAGS+=" -Wno-unused-parameter"
                CFLAGS+=" -Wno-missing-field-initializers"
                CFLAGS+=" -Wdeclaration-after-statement"
-- 
2.30.0

