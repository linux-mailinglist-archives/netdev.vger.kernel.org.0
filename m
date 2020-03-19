Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E39DA18B775
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgCSNNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:13:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:27996 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728956AbgCSNNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:13:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584623599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uWJEiu/Z2FQlJcrWSPoV5kXif2wXXa5HAsBAGFtr6yE=;
        b=YE4a3W58KTnWwulu6K7NJZc0Q9av+ENxcGJxQgkmEBs1JRAZTlAL2EeHYS3NGp7j2/RhXp
        +XRuTHVUgNdqUDk8w2iOa8bqscp8jnh/PXUV7e6MDuwdskQqcE2ekPv3YrSP3BuhNFCOLz
        ug68m5Qw3u1H6vcVirvNf2Zpw8he/j8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-wjZ6lfuOMGiMs1RNWF1gGw-1; Thu, 19 Mar 2020 09:13:17 -0400
X-MC-Unique: wjZ6lfuOMGiMs1RNWF1gGw-1
Received: by mail-wm1-f71.google.com with SMTP id m4so681962wmi.5
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 06:13:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uWJEiu/Z2FQlJcrWSPoV5kXif2wXXa5HAsBAGFtr6yE=;
        b=uZCTj88Yhc7exRqn0yxRo0WKto1qPmwEkEwW2isSuCLbyk7PQS2GAA6epN1WXigOl3
         Fpl3L721iU0HkdY1Gt5h6ZWkBxgNKfX4agkapCsfuaLxXxruUhueSHYqxrgoGoSBRm3Y
         /jKa4ZLtVjxUzptlBtXEUqI4sYUBhfEC7D/ki6xxVkkQGof3g588DHWIl0/2qcNG7K4/
         dMCQiiJ3NeO8R0SkBeuh+zoVlCIgUMFziMazUqgxd/PK8vuJrffqaFo3YhTsdQPO/VFk
         C2j625rQJsx7k0gcECmPAl3nY9odmfFYVzMeuJVf5Yxc82lHhTgBkuqvzEApRsafJ41e
         75eQ==
X-Gm-Message-State: ANhLgQ004lr3h4W4xbm7c6Oj+gHYbUnU6X7zEzbhRC1upEgYpyzrCZO1
        CPqfpKxyqyvgm6d8no6QFt/VDux4FP8+yOeAUubQ3aVNm6kWrSwDmCfhZkACYsctkkf0qeSUOHi
        o5hiY2nTwMtoeZKnB
X-Received: by 2002:a1c:6385:: with SMTP id x127mr3647788wmb.141.1584623596257;
        Thu, 19 Mar 2020 06:13:16 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt+Z7JUM/KQLOWds3rAEs1ALcIo+ruqq8ub+P9UEsTFzaY1gCY2UKTJFwmi0Sx1Eeh22JidQg==
X-Received: by 2002:a1c:6385:: with SMTP id x127mr3647765wmb.141.1584623596070;
        Thu, 19 Mar 2020 06:13:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p10sm3563491wrx.81.2020.03.19.06.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 06:13:14 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 493B9180371; Thu, 19 Mar 2020 14:13:14 +0100 (CET)
Subject: [PATCH bpf-next 2/4] tools: Add EXPECTED_FD-related definitions in
 if_link.h
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 19 Mar 2020 14:13:14 +0100
Message-ID: <158462359425.164779.4804283164480162318.stgit@toke.dk>
In-Reply-To: <158462359206.164779.15902346296781033076.stgit@toke.dk>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds the IFLA_XDP_EXPECTED_FD netlink attribute definition and the
XDP_FLAGS_EXPECT_FD flag to if_link.h in tools/include.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/include/uapi/linux/if_link.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 024af2d1d0af..e5eced1c28f4 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -960,11 +960,12 @@ enum {
 #define XDP_FLAGS_SKB_MODE		(1U << 1)
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
+#define XDP_FLAGS_EXPECT_FD		(1U << 4)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
 					 XDP_FLAGS_HW_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
-					 XDP_FLAGS_MODES)
+					 XDP_FLAGS_MODES | XDP_FLAGS_EXPECT_FD)
 
 /* These are stored into IFLA_XDP_ATTACHED on dump. */
 enum {
@@ -984,6 +985,7 @@ enum {
 	IFLA_XDP_DRV_PROG_ID,
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
+	IFLA_XDP_EXPECTED_FD,
 	__IFLA_XDP_MAX,
 };
 

