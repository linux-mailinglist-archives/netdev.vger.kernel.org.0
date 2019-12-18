Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E50A124124
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLRIMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:21 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40598 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:20 -0500
Received: by mail-pg1-f193.google.com with SMTP id k25so848392pgt.7
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q9bJsY3z2kyATyAaL+NSBHkt58yW1QvQynFeadGngaw=;
        b=iOOXdj27Kgb2k7bElOvp1szy2u/7uooLe0jgIrLWIerGX7xm3GwoaR5hC/mbxx6reI
         mZWIYomnXmSNXlgER9dZuZ1nxLllxFFpZqXa+oA/l02hbMAYnpA0pGeE2B1+46y//3P1
         zZh/DQ0Yv2p3/Z5Y5+BwggNPYsKEwjHqcqruQeRMxpYGxsFcq3QStg72+ioz7QnSiKqw
         62Iov16Zz000PCN9HeHWUcysdJ1U6DE68VB4UurS4BaiWIJCg3RsTiH1zsdSFQv9I8lm
         Tmg8hBbgLqoAlvG44PUufhcb7S6RF1MPGm7EgZMRejGDylNMcKXXEtWu+DUyt73lq2DT
         lNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q9bJsY3z2kyATyAaL+NSBHkt58yW1QvQynFeadGngaw=;
        b=PSaxEKtgJIA/+b5UtRGKsCVg+UrdSUP9ZT/vQKYmBIRcVKB2US6sXKP7lGdpJY6f1/
         EHsa/kz8HUxxsnDJaYLBhz0PlYOfDhmVIg722153SB+dl5YtAzTbPbYqZY66ryAQiqMK
         mO4fPU9pcEnM4tiUK59+QtHL+QlBJl8zi6t26sATkK3YD1bF6EqAT64UsjmsFdUYg/T5
         edliE4uUY1eMGZZe2WngzrYxyOl+VBpLHdlmcFjPoETEKYbh9jcPe5gmiB0nIbuD4ilZ
         zD+SCj2z0jr+xc/b6IpLAOzK0AWAvUHENsRVmLljtbjcHxeBxUEvReghKpjj2qonwJve
         7HCA==
X-Gm-Message-State: APjAAAXcYbulSXC4Um1dG8b5JEc09rzkB7sEcVN+hbYbAEA0zC9b07eA
        q3ewvN6xjlYUkSv1pJf4LV4=
X-Google-Smtp-Source: APXvYqyMSjsYu0g1V5Ux0m0S9vvyJBs8z/sUSU5h6LiX0r34DLIncbafdXEf2uOHdtQeiVEfh1bl0w==
X-Received: by 2002:a62:e210:: with SMTP id a16mr1673087pfi.123.1576656740422;
        Wed, 18 Dec 2019 00:12:20 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:20 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC net-next 02/14] tools: sync kernel uapi/linux/if_link.h header
Date:   Wed, 18 Dec 2019 17:10:38 +0900
Message-Id: <20191218081050.10170-3-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if_link.h was out of sync. Also it was recently updated to add
IFLA_XDP_TX attribute.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 tools/include/uapi/linux/if_link.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 8aec8769d944..be97c9787140 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -169,6 +169,8 @@ enum {
 	IFLA_MAX_MTU,
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
+	IFLA_PERM_ADDRESS,
+	IFLA_XDP_TX,
 	__IFLA_MAX
 };
 
-- 
2.21.0

