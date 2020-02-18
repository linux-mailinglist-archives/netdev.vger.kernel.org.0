Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813C01626BC
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 14:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBRNEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 08:04:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28990 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726340AbgBRNEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 08:04:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582031054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GIrGFZ0JSlt7bh77UYGwq8VnSNDnywZL5T2KJvjBXIU=;
        b=Bwb3rnDuOjiM4xe0lnEuOrS4ffCFsCYOrbVA4l21oWEBrYdCcm9aARAmOjEX0yXoMVMUMe
        0xUvQGWEepvUHZ7NGsUvmjCQfzwz9w5/X+1DS1RGwGML5MxXLP/NzVbUWJEltFL6vgbiAR
        iuyr+EAbNeaUMR6zDssME3AhdveoGUU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-FHcb0QJ5N-Oc1N5lUhGY5w-1; Tue, 18 Feb 2020 08:04:11 -0500
X-MC-Unique: FHcb0QJ5N-Oc1N5lUhGY5w-1
Received: by mail-lj1-f200.google.com with SMTP id r14so7083172ljc.18
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 05:04:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GIrGFZ0JSlt7bh77UYGwq8VnSNDnywZL5T2KJvjBXIU=;
        b=qFv2edrYJUKUv1+Mrg1vDAahmHxxbOcNXaYbhcmMUHM+nzBGhRUA3fuU0rxZDqr7/Y
         GThQK08M3Rg1kTxt7FusnkdaGWK7gQAqk/WqPqKhokxJPqzToXtJowFUl00/2RyepzQZ
         vVDUuyVODKw4h1CdOhWqg3V4F8X8aucXfhSIEKdFq9KIbvXI0EASkTvslQpyOdHkjgWB
         XqeW/ZDSOPIFXCD28KY+dYPZismcNlK8WYYAf8NEYVrH4mjzdLN+c4KerINjlt9/puAM
         lAarwhMGzrRXJAEYp8/4HDzBLTYD1S+1C+pAhFu45cgjmfbpAFgyArrWdfNO5ErY/p1o
         18CQ==
X-Gm-Message-State: APjAAAVf7yR0CPTvrfP6PnvBmjZ+odqAr+gqp2pyGN7xXs6uPcKhY8Vg
        tIWkCwEd2G1X6C08rsJig0x/gqEF2HjxzVs2AJDfp1an3zggC9Ej5zcz1sp5BIK7znEXrdZlJ56
        6Wr0+RgGwtaNHf0lS
X-Received: by 2002:ac2:4c84:: with SMTP id d4mr10465269lfl.64.1582031049435;
        Tue, 18 Feb 2020 05:04:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqzrC2Z6mY//wkKUZYuZ5mv/ieMoyTzpwX7NytYOPWmRzTueN0cVzKV8fznNuQrf4W6pVPFKPA==
X-Received: by 2002:ac2:4c84:: with SMTP id d4mr10465253lfl.64.1582031049172;
        Tue, 18 Feb 2020 05:04:09 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i4sm2765122lji.0.2020.02.18.05.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 05:04:08 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BA243180365; Tue, 18 Feb 2020 14:04:06 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf v2] uapi/bpf: Remove text about bpf_redirect_map() giving higher performance
Date:   Tue, 18 Feb 2020 14:03:34 +0100
Message-Id: <20200218130334.29889-1-toke@redhat.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The performance of bpf_redirect() is now roughly the same as that of
bpf_redirect_map(). However, David Ahern pointed out that the header file
has not been updated to reflect this, and still says that a significant
performance increase is possible when using bpf_redirect_map(). Remove this
text from the bpf_redirect_map() description, and reword the description in
bpf_redirect() slightly. Also fix the 'Return' section of the
bpf_redirect_map() documentation.

Fixes: 1d233886dd90 ("xdp: Use bulking for non-map XDP_REDIRECT and consolidate code paths")
Reported-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
  - Keep a reference to bpf_redirect() in bpf_redirect_map() text (Quentin)
  - Also fix up 'Return' section of bpf_redirect_map()

 include/uapi/linux/bpf.h | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f1d74a2bd234..22f235260a3a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1045,9 +1045,9 @@ union bpf_attr {
  * 		supports redirection to the egress interface, and accepts no
  * 		flag at all.
  *
- * 		The same effect can be attained with the more generic
- * 		**bpf_redirect_map**\ (), which requires specific maps to be
- * 		used but offers better performance.
+ * 		The same effect can also be attained with the more generic
+ * 		**bpf_redirect_map**\ (), which uses a BPF map to store the
+ * 		redirect target instead of providing it directly to the helper.
  * 	Return
  * 		For XDP, the helper returns **XDP_REDIRECT** on success or
  * 		**XDP_ABORTED** on error. For other program types, the values
@@ -1611,13 +1611,11 @@ union bpf_attr {
  * 		the caller. Any higher bits in the *flags* argument must be
  * 		unset.
  *
- * 		When used to redirect packets to net devices, this helper
- * 		provides a high performance increase over **bpf_redirect**\ ().
- * 		This is due to various implementation details of the underlying
- * 		mechanisms, one of which is the fact that **bpf_redirect_map**\
- * 		() tries to send packet as a "bulk" to the device.
+ * 		See also bpf_redirect(), which only supports redirecting to an
+ * 		ifindex, but doesn't require a map to do so.
  * 	Return
- * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
+ * 		**XDP_REDIRECT** on success, or the value of the two lower bits
+ * 		of the **flags* argument on error.
  *
  * int bpf_sk_redirect_map(struct sk_buff *skb, struct bpf_map *map, u32 key, u64 flags)
  * 	Description
-- 
2.25.0

