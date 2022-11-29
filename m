Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFE063C876
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbiK2Te7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236410AbiK2Te5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:34:57 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A24F12D18
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:34:56 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id d186-20020a25e6c3000000b006f384608ed4so10964503ybh.14
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HOzG/5dEM9DkbawI2NlOgkggkIO8cF5opRTpWfNApEg=;
        b=kyEORXpwSQDMFCjolSPocDw5PPUY6szQrRJyab47gvH47zqLX5OlxBNKsGyxKBL+Rp
         csbPZ3pa/qJ/+IsuxaqCe4mtx7Q4f9ERBKDp2/P/5WXTClzxWFsmsyaxFE1y+FM7wdMf
         XPvm3IpuABH5BTA8vvktg0hlscH3G90TwaekMWkwIjR6qh5cOi+8rt9yXYbxGN76tI8U
         5iH6Uws+jCN5fZFginUA6teWP+i3pNmokNzrsnONh0ILKh8VNGO04KntrKW3fp8u0bPO
         /BmEOXcdffhvDlK1lES2Tk4mURW0KyIYrZcBm8m2glB1p5H06gNtreuVx4qfpnzTkiyt
         AyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HOzG/5dEM9DkbawI2NlOgkggkIO8cF5opRTpWfNApEg=;
        b=VyG6Z3SbthVKpqBeHYkzUlIkFOBf7XPBKephCb+okYhGPQFrBa+NY4r9vmZi/xQomP
         fElKaEKBfPp41i24RCP100c0sT28qMnhIrrxLqjpWA88OQoeVmgfpemWLd0vh6c+nm7f
         n9xURZgTDusKv6qrncL6ga7Zw0/TkzjHInP65TKY0VKa3PZDNoNmUDLlRgt89DdYuPWZ
         S5oXEtxKbftcIuHmWnYs0XWBcwynAtg5028Nrfw6bYHsinLj3iBZMfMNUmgE/7QYVvpX
         VCocu/MFFleYz2OZdaOPHLj6DYXTPd1EsUr12p7/u7haJljbeQNkRRZHEau9ZwXubmf+
         sHuA==
X-Gm-Message-State: ANoB5pmibrvJFy44vy16ZMyWT1j9VhH9nLK4sGuNMg1pGYplL5/NfokW
        5B0Vw+LmOewohy6lQWzadg1kGT8=
X-Google-Smtp-Source: AA0mqf6PqHpJFnmBi4gAC5rxxSvz27MVgWdCpOpxvuZULapB3rClacSJVA6wlIp/dJglPth3I7z6fZc=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:69d2:0:b0:6f9:7bf9:9034 with SMTP id
 e201-20020a2569d2000000b006f97bf99034mr2528106ybc.584.1669750495620; Tue, 29
 Nov 2022 11:34:55 -0800 (PST)
Date:   Tue, 29 Nov 2022 11:34:42 -0800
In-Reply-To: <20221129193452.3448944-1-sdf@google.com>
Mime-Version: 1.0
References: <20221129193452.3448944-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129193452.3448944-2-sdf@google.com>
Subject: [PATCH bpf-next v3 01/11] bpf: Document XDP RX metadata
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
2.38.1.584.g0f3c55d4c2-goog

