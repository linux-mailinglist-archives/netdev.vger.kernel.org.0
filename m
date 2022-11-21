Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322A6632C08
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiKUS0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiKUSZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:25:57 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABA1CFE98
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:25:56 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id c7-20020a170903234700b0018729febd96so9831665plh.19
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HOzG/5dEM9DkbawI2NlOgkggkIO8cF5opRTpWfNApEg=;
        b=CSFHoG6gVZh4SBZCczWClLOJPtmruLeP1CVP4tX94SUl4kZuItSp3nkuM9V+pa4dUC
         Gim9gX92dMmq4n0R3k7w2ucPQQTGI9MUeok2ruJWffbwNRWCAfnXw+3hlYkyt1GmCDj1
         DiDsj46t4OZ1/sEuKpRr+j/nt27flowaV+qpaLje5Q2coskhopWg40G2QmnNWED3gWaU
         89LQ5MSr0YqpSrvlDXQsQJXhBZA0IvR01S7XWpQEgAPZBtcqy+KfIFBnI3oquvknnxzO
         8F9StkDvJo9iX40ZMZT3K74lAMyJUgngpvaen+Svsqd/pLkdfwWnK+lokaY/uI11XWjf
         wMvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HOzG/5dEM9DkbawI2NlOgkggkIO8cF5opRTpWfNApEg=;
        b=lYVGz+eWt5wR8NXWT1wZcpKfjnyX4e0h0314nRy1Wh+A0mabHNOPdiYssOqYArSgyB
         sd77JcyfQGf3671tCZi+RIRw/hvYoI2XVzrf+M11duDFbLV7flzGZkxOTwAB0D26u6GA
         IBzO7FvsErUFJAD88wux49N/T13CModBQ7i9Ym5C3IZdHTBpwthLGFfRd8zOfTQikGgM
         FWbyHOZpQzsvcNWkHTWmusr1yQtvpduAeqwJHDlc+UzBHR3tMOW38uh4VRJhjHHm2o0q
         6PYahwpZRQMCpfhTJ+eyLwz4QEqrQN3W7EcNBeA+MK2qCtCY6Bwir8+xkkIk1fg9woy4
         jdVQ==
X-Gm-Message-State: ANoB5pn2ktO1HdGWlrQ4+K3rFDL4YSowG18P8Ziczr6AD3vIg76SgKdV
        rWrWyJwb4eCbukJo4ImLW9EC4uA=
X-Google-Smtp-Source: AA0mqf4MB+oLIG61MneSZIxhA4uojAGlFL2tQV0bErJVWZ3UtpqMf1lMDnr+HVx2A3R6bARGixRNhjA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:df8c:b0:20a:fee1:8f69 with SMTP id
 p12-20020a17090adf8c00b0020afee18f69mr1872407pjv.0.1669055155656; Mon, 21 Nov
 2022 10:25:55 -0800 (PST)
Date:   Mon, 21 Nov 2022 10:25:45 -0800
In-Reply-To: <20221121182552.2152891-1-sdf@google.com>
Mime-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221121182552.2152891-2-sdf@google.com>
Subject: [PATCH bpf-next v2 1/8] bpf: Document XDP RX metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document all current use-cases and assumptions.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/xdp-rx-metadata.rst | 90 +++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)
 create mode 100644 Documentation/bpf/xdp-rx-metadata.rst

diff --git a/Documentation/bpf/xdp-rx-metadata.rst b/Documentation/bpf/xdp-rx-metadata.rst
new file mode 100644
index 000000000000..498eae718275
--- /dev/null
+++ b/Documentation/bpf/xdp-rx-metadata.rst
@@ -0,0 +1,90 @@
+===============
+XDP RX Metadata
+===============
+
+XDP programs support creating and passing custom metadata via
+``bpf_xdp_adjust_meta``. This metadata can be consumed by the following
+entities:
+
+1. ``AF_XDP`` consumer.
+2. Kernel core stack via ``XDP_PASS``.
+3. Another device via ``bpf_redirect_map``.
+4. Other BPF programs via ``bpf_tail_call``.
+
+General Design
+==============
+
+XDP has access to a set of kfuncs to manipulate the metadata. Every
+device driver implements these kfuncs. The set of kfuncs is
+declared in ``include/net/xdp.h`` via ``XDP_METADATA_KFUNC_xxx``.
+
+Currently, the following kfuncs are supported. In the future, as more
+metadata is supported, this set will grow:
+
+- ``bpf_xdp_metadata_rx_timestamp_supported`` returns true/false to
+  indicate whether the device supports RX timestamps
+- ``bpf_xdp_metadata_rx_timestamp`` returns packet RX timestamp
+- ``bpf_xdp_metadata_rx_hash_supported`` returns true/false to
+  indicate whether the device supports RX hash
+- ``bpf_xdp_metadata_rx_hash`` returns packet RX hash
+
+Within the XDP frame, the metadata layout is as follows::
+
+  +----------+-----------------+------+
+  | headroom | custom metadata | data |
+  +----------+-----------------+------+
+             ^                 ^
+             |                 |
+   xdp_buff->data_meta   xdp_buff->data
+
+AF_XDP
+======
+
+``AF_XDP`` use-case implies that there is a contract between the BPF program
+that redirects XDP frames into the ``XSK`` and the final consumer.
+Thus the BPF program manually allocates a fixed number of
+bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
+of kfuncs to populate it. User-space ``XSK`` consumer, looks
+at ``xsk_umem__get_data() - METADATA_SIZE`` to locate its metadata.
+
+Here is the ``AF_XDP`` consumer layout (note missing ``data_meta`` pointer)::
+
+  +----------+-----------------+------+
+  | headroom | custom metadata | data |
+  +----------+-----------------+------+
+                               ^
+                               |
+                        rx_desc->address
+
+XDP_PASS
+========
+
+This is the path where the packets processed by the XDP program are passed
+into the kernel. The kernel creates ``skb`` out of the ``xdp_buff`` contents.
+Currently, every driver has a custom kernel code to parse the descriptors and
+populate ``skb`` metadata when doing this ``xdp_buff->skb`` conversion.
+In the future, we'd like to support a case where XDP program can override
+some of that metadata.
+
+The plan of record is to make this path similar to ``bpf_redirect_map``
+so the program can control which metadata is passed to the skb layer.
+
+bpf_redirect_map
+================
+
+``bpf_redirect_map`` can redirect the frame to a different device.
+In this case we don't know ahead of time whether that final consumer
+will further redirect to an ``XSK`` or pass it to the kernel via ``XDP_PASS``.
+Additionally, the final consumer doesn't have access to the original
+hardware descriptor and can't access any of the original metadata.
+
+For this use-case, only custom metadata is currently supported. If
+the frame is eventually passed to the kernel, the skb created from such
+a frame won't have any skb metadata. The ``XSK`` consumer will only
+have access to the custom metadata.
+
+bpf_tail_call
+=============
+
+No special handling here. Tail-called program operates on the same context
+as the original one.
-- 
2.38.1.584.g0f3c55d4c2-goog

