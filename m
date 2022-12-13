Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F18764ADA9
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbiLMCgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiLMCgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:36:10 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37E51A83A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:09 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l10-20020a170902f68a00b00189d1728848so11875832plg.2
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B1MU/P2BiLvl4DKV0cW5ZfQOjZsyBYnRPN2mipW5caI=;
        b=emobRxwiVGi40jGlmJ1WyeLeIDyY7r7EBZCYOJHtIB6ev+9ozAiVIOnWIH2lkIrPa/
         Lgp72l3NkwdKny0QyJHWXzfrUoXDv0+gw56qItGwCHf7Rj4B/rlyzxbJPx/CXywB61hA
         axeUnQkZYQkdDHpOtc6ml7svoT1Pwvo9EwFGZUQXJxV1aYcRhP7VmA8DmLN1mOriL9zD
         1LaRYln4AbJCn4NyPoceWcErb7X31JJueNFpNumdvf9BC9Ke2HBn7NTovKGW7snopgUs
         AX7Pi5oy7MiA1Zl7V+nI89f+5vYc4p6FnYSx33dn3SADuhbSxA/aDTY7FSrN92RewO7c
         C+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B1MU/P2BiLvl4DKV0cW5ZfQOjZsyBYnRPN2mipW5caI=;
        b=hXakZKivHWSpOaTYuI5vr4SXYnEflbGpKHCoVzGCsc+oQx/f7r4G0dq3T1wQSAbO0I
         Fnbz+9vWQuik9e5b3GXi6gq9uIPbzjs0ZLlhO4T/RzSz6pz8ME76E1BmgiLp0m3bzIcu
         d05KfF/liIBI9iFG8ZSwt4PX/QkCt2L6X39Nq/56Z6E+TyGiouOlmcys+BJlLYkKWnBG
         YHyrBxlbWLaZvkQymZLKMmmSMALWvQTLToj3V9avjRz7ydcrIPsXuapMNYtHlDiPyLsJ
         oqbShg/3YMYK7m8tPDWOVMUSihi2I9nQoLmqjfd/jRseV3Y5W9xzzEu7aL1Oc2c7BQ6Z
         rsYg==
X-Gm-Message-State: ANoB5pkHs1Ro/qLNreuJijsbq0Ue5Ae2Adzbxq/MjFTm99JQkHoQTChG
        nevlgSuuq7oA1WNq2cB6mtJBPlE=
X-Google-Smtp-Source: AA0mqf6/AkpE1jTjiTXbmukoaL8S0mTA3M64Qh2Hei+vJVWPYqe42Rr4lWaUA9tIXsWcKj/GDMmyzGU=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:e194:b0:189:56ab:ab68 with SMTP id
 y20-20020a170902e19400b0018956abab68mr70587525pla.144.1670898969258; Mon, 12
 Dec 2022 18:36:09 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:35:51 -0800
In-Reply-To: <20221213023605.737383-1-sdf@google.com>
Mime-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213023605.737383-2-sdf@google.com>
Subject: [PATCH bpf-next v4 01/15] bpf: Document XDP RX metadata
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
2.39.0.rc1.256.g54fd8350bd-goog

