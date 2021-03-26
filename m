Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3148234A5CE
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhCZKug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:50:36 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36819 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229832AbhCZKuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:50:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 02C605C0004
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:50:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 26 Mar 2021 06:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=2r86slXb62o417xfxLF4ITtW5+
        mCk4lgJBrKurWE6xw=; b=fefvthoh+BUSLca6s5cYeBrvYDFpIKH+mzQnp0Gd+q
        YZKqO1pRKyI3BHm7WjqaqfvVIlfzOw7JP/DVlVqGaT/5ZarHoIkWAL5smLUEh5zI
        a3xl8EVimlqyzGMDe/d/tmV6XAGFVtyI3gmbHOLiG6CNCCoZExTGlX1Hdp5jioas
        3LJGVnRfsn5pNnHmvsYhLqN4Yc7r9Td1xsFuVrIbdo34KnaK68q9Wt9ISP8dUrz7
        8E0ArBKzjSA/81P93nJ6spVOyt+osDEeL6Io96e8z4ORXJucDuqukAk2yG3j+p1m
        +BqpE9XqHXw7meLlw3heEKN2mG+80IY0x2FPUZ04A+RA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2r86sl
        Xb62o417xfxLF4ITtW5+mCk4lgJBrKurWE6xw=; b=MRySTrHmLulIqh/aTSetze
        L6qqOpHx+5I3kUwU8JiqXTSFT6He3pdDCypZyXHfi/OYeKfNsMiFCecWbQANLHeW
        ZCwhYVXa3RD3zP0/3/015jw9aMlMH6cUXgv7wL1RCWYqt3JT3ayOaHOAkhuMB7zB
        43fPnYNQKe/wnO4ThSTY/L6pXuKjExD4RZaWt2BJG/7PoOA+BhYm4ggMA6x1jyVN
        RXeJ/p8XPXjmhu+D+0akWw9b3YbXvc3STa+oyIvtGMapbXiRzSPMTzpc6EdfI0CG
        EkdSPC+gVjoOaBL5mRmtA5hJQHdNJPi3n4SOHEySV9/Sy9+6+U+Aq8/XdRrX96IQ
        ==
X-ME-Sender: <xms:XLxdYOZZro7NRB55oRFLmidUc_hNFA54rD9WCXAO4kT3yttgVNAdMg>
    <xme:XLxdYBYH_wB8Zh6XbYDmmjrYDSbogoqko2auyjurDXYRglHaMBkiWNrsaHVV-dxcn
    nR7O5w5QLNvjZVdDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvffftggfggfgsehtjeertd
    dtreejnecuhfhrohhmpeevhhhrihhsthhophhhvghrucfvrghlsghothcuoegthhhrihhs
    sehtrghlsghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepieeitdevveegje
    euveeflefhhfeffeeijeffffeiteeifffhveeigeeghfevffdunecukfhppeejvddrleeh
    rddvgeefrdduheeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomheptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:XLxdYI8gnCDMVtPtl7vEhNBAp20ARidlUJohibjp9zTHZ8bHsikTew>
    <xmx:XLxdYArDcXINclbDuDMWn3wg9JZmD4FPKyqdoAO1cQaBhbthAnaf0w>
    <xmx:XLxdYJrLJqUP2NJENaOx9uKFiM_z5akObvqOewwcuXA0xt_uKTuxLg>
    <xmx:XbxdYG3b3RLGf5vxpJrNBNVhBMvo4HNNdGWJm1S7DFdfpowPcDJk8Q>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id CD37F240067
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:50:04 -0400 (EDT)
Message-ID: <082ccadaf9654e1580540e73cc8defc522d97b2d.camel@talbothome.com>
Subject: [PATCH 2/9] Ensure Compatibility with Telus Canada
From:   Christopher Talbot <chris@talbothome.com>
To:     netdev@vger.kernel.org
Date:   Fri, 26 Mar 2021 06:50:04 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


mmsd decodes a header that is not in the standard.
This patch allows this header to be decoded
---
 src/mmsutil.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/src/mmsutil.c b/src/mmsutil.c
index 5fcf358..9430bf1 100644
--- a/src/mmsutil.c
+++ b/src/mmsutil.c
@@ -732,10 +732,9 @@ static header_handler handler_for_type(enum
mms_header header)
                return extract_text;
        case MMS_HEADER_INVALID:
        case __MMS_HEADER_MAX:
+       default:
                return NULL;
        }
-
-       return NULL;
 }
 
 struct header_handler_entry {
@@ -781,8 +780,17 @@ static gboolean mms_parse_headers(struct
wsp_header_iter *iter,
 
                handler = handler_for_type(h);
                if (handler == NULL) {
-                       DBG("no handler for type %u", h);
-                       return FALSE;
+                       if(h == MMS_HEADER_INVALID) {
+                               DBG("no handler for type %u", h);
+                               return FALSE;
+                       } else if (h == __MMS_HEADER_MAX) {
+                               DBG("no handler for type %u", h);
+                               return FALSE;
+                       } else {
+                               /*  Telus has strange headers, so this
handles it */
+                               DBG("type isn't a part of the standard?
Skipping %u", h);
+                               continue;
+                       }
                }
 
                DBG("saw header of type %u", h);
-- 
2.30.0

