Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8B7233E72
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 06:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgGaEos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 00:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgGaEos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 00:44:48 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2278AC061574;
        Thu, 30 Jul 2020 21:44:48 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w17so16250123ply.11;
        Thu, 30 Jul 2020 21:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0m2yM6Cpg0UMGl3JBQ2zB0c8Tu//2IzjG9Zoo6ooaqY=;
        b=hhzBOePGn+ma9oANopuKPFKyVnWTCROJvTFIWKIg+Xqaq5kTw1qad0OqKUKO0yEBSA
         XZtE3/VK2wQHKXopvsveJfyJMOmkUhUJHZ8rooShHKA3F9ArTAWFBJGQ1DZdI6j5V1Di
         Vjt9QY7XhAXpFW67bTCgoR+SUQJ/ikmjbsN3pweNd3qEO+Xjm9IFyo9Lwl+63bMKbw3L
         cSfs4kU+IifQyXiPn0C2XgvPqF2VTmco5iyGcfR8EOWetXpUYze9fuTzsVq1tM9iJNJv
         Lv+pC9TKLh4/uJkCHXTDyWGmF72NLPsK2Er4s8Kc4+V7wi0WxOPulBF1EYC3O5U/UbxU
         gjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0m2yM6Cpg0UMGl3JBQ2zB0c8Tu//2IzjG9Zoo6ooaqY=;
        b=Jfdq01m98jxf6vQglxNGAZzakYdyi4lZ56EwNMK8ux/AWKZ8/Zpb4RobwwuzvHcxkh
         z1rRTXnvva371IpL1jL6U8mUVCrcU25KP4Yg4FaHzatcT16VvgU9iC5PQ/LYf8KEt0Cj
         TZq70bIRH5yvx8Kf+mpff2s4eP2MfIpgHrzvE1kCLhUbe73i5QNsI2y9Rc8txY9Ky6KM
         ri3wpREatBpH00zPz6r64kO6ZhFbKETHZKTNsCd9apMCyup0GfZPw6xG13x9BKj9pQVl
         Nz6GMATFTdSGPlAXdQ7IdvZdHpMMqKtemg5kUycd/2vAGZ/vtoFeaem9i169+RKvBHNE
         YE/w==
X-Gm-Message-State: AOAM531BvH4A0wh3yd7kO0t2xCHtL3wrTp4kd22QK0xSKKq18+a/QCZI
        RqjGFfrbBK7fnLfofAfZHqkwA2oQ
X-Google-Smtp-Source: ABdhPJzn0klKnpGXg9duE13S4iK7KOxGO4DDrmWAptlpFD3w+ps0taZ72vn3pQDp97OPm1/XtgYSQg==
X-Received: by 2002:a62:2ad6:: with SMTP id q205mr2063865pfq.316.1596170687650;
        Thu, 30 Jul 2020 21:44:47 -0700 (PDT)
Received: from dali.ht.sfc.keio.ac.jp (dali.ht.sfc.keio.ac.jp. [133.27.170.2])
        by smtp.gmail.com with ESMTPSA id x6sm2329573pfd.53.2020.07.30.21.44.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 21:44:47 -0700 (PDT)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        bpf@vger.kernel.org
Subject: [RFC PATCH bpf-next 0/3] Add a new bpf helper for FDB lookup
Date:   Fri, 31 Jul 2020 13:44:17 +0900
Message-Id: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a new bpf helper for doing FDB lookup in the kernel
tables from XDP programs. This helps users to accelerate Linux bridge
with XDP.

In the past, XDP generally required users to reimplement their own
networking functionalities with specific manners of BPF programming
by themselves, hindering its potential uses. IMO, bpf helpers to
access networking stacks in kernel help to mitigate the programming
costs because users reuse mature Linux networking feature more easily.

The previous commit 87f5fc7e48dd ("bpf: Provide helper to do forwarding
lookups in kernel FIB table") have already added a bpf helper for access
FIB in the kernel tables from XDP programs. As a next step, this series
introduces the API for FDB lookup. In the future, other bpf helpers for
learning and VLAN filtering will also be required in order to realize
fast XDP-based bridge although these are not included in this series.

Patch 1 adds new function for access FDB in the kernel tables via the
new bpf helper.

Patch 2 adds the bpf helper and 3 adds a sample program.

Yoshiki Komachi (3):
  net/bridge: Add new function to access FDB from XDP programs
  bpf: Add helper to do forwarding lookups in kernel FDB table
  samples/bpf: Add a simple bridge example accelerated with XDP

 include/linux/if_bridge.h      |  11 ++
 include/uapi/linux/bpf.h       |  28 ++++
 net/bridge/br_fdb.c            |  25 ++++
 net/core/filter.c              |  45 +++++++
 samples/bpf/Makefile           |   3 +
 samples/bpf/xdp_bridge_kern.c  | 129 ++++++++++++++++++
 samples/bpf/xdp_bridge_user.c  | 239 +++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |   1 +
 tools/include/uapi/linux/bpf.h |  28 ++++
 9 files changed, 509 insertions(+)
 create mode 100644 samples/bpf/xdp_bridge_kern.c
 create mode 100644 samples/bpf/xdp_bridge_user.c

-- 
2.20.1 (Apple Git-117)

