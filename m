Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F92C65DF67
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 22:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbjADV74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 16:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbjADV7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 16:59:55 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B0D37520
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:59:53 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id s76-20020a632c4f000000b0049ceb0f185eso8751233pgs.7
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 13:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SBZcX/CX+6eg2RmM1fPvz94TRxZRqhIIj1d7A/c3p4w=;
        b=SgkQBSkjYYRRIcl7qCyErs8dmZOIlnt7Ei7sTd8glgPSydLryhe9W06vV3BIleneag
         wgj8+QIEBk+e2CdZpN+drx5IPE3YjFaoqu19n4mZV8v5sPC9JUFV4NfLRy48oSknKOMI
         kVpxhzAX41YjA59Dac1W9t8Cy2E64nprfNSgyAB9vPqi5juj2OFTM9tYQT0rtwijn72i
         j2pTiGONSST6cv5Gu68T15XOV7PY4UOejrmdtDFa+dHInF2cDxRP/7LZt5XlqOrF1e2b
         fq2pLFslP08zG1bFTlualfnGecC33pGBXHlWkiIPaNaY51YB2LrN5daZJIbSTx84to/s
         71aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SBZcX/CX+6eg2RmM1fPvz94TRxZRqhIIj1d7A/c3p4w=;
        b=OysshNccdw6FQJzj+ISxMEd/xPSicWPbShmDwoOtI82ff+N0ne0VQqQ3eiKtB/5ecT
         8asCEOdK4CCV0kWIqr2ultSTjUxKDqLkqd5d0n9hkl0eaJA6OJexc8UC7Ln3cqX794MG
         wxbsjYhe4QmECs4sgbkWm4ZI0IhIlQojguQ+UuCoszlL0EyQunP2yDdP+Jnh9wcqkjKQ
         Uzi/k1jyJ8N4QHPY2gGYHintGsT5SAl1rr6VVoKe7UCmttan0OrA11ojYm3FHGXieDbP
         KTD9o6E7o+YByHSj7J9QIajAPnvHUrDyj6C//ZPr3bvXbSzpGhIvwd48HBmgUXXrCqgJ
         33mQ==
X-Gm-Message-State: AFqh2krMi4jxT6exh63QTHYG2I/DtXKEBWuUd5fdzh781sHZQySf1Pbk
        2sVl4KGq866F/4rgkRQyVi4NT+8=
X-Google-Smtp-Source: AMrXdXttFN/zSiMfS0ERJ11SVxibZ5mMJytWoRSdkxUxQJdajgFwK8IK2RFlx8zlU9TNawl9XZuoppQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a62:e418:0:b0:581:b93c:bb66 with SMTP id
 r24-20020a62e418000000b00581b93cbb66mr1573518pfh.50.1672869592778; Wed, 04
 Jan 2023 13:59:52 -0800 (PST)
Date:   Wed,  4 Jan 2023 13:59:33 -0800
In-Reply-To: <20230104215949.529093-1-sdf@google.com>
Mime-Version: 1.0
References: <20230104215949.529093-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230104215949.529093-2-sdf@google.com>
Subject: [PATCH bpf-next v6 01/17] bpf: Document XDP RX metadata
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
 Documentation/networking/index.rst           |   1 +
 Documentation/networking/xdp-rx-metadata.rst | 108 +++++++++++++++++++
 2 files changed, 109 insertions(+)
 create mode 100644 Documentation/networking/xdp-rx-metadata.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4f2d1f682a18..4ddcae33c336 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -120,6 +120,7 @@ Refer to :ref:`netdev-FAQ` for a guide on netdev development process specifics.
    xfrm_proc
    xfrm_sync
    xfrm_sysctl
+   xdp-rx-metadata
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
new file mode 100644
index 000000000000..b6c8c77937c4
--- /dev/null
+++ b/Documentation/networking/xdp-rx-metadata.rst
@@ -0,0 +1,108 @@
+===============
+XDP RX Metadata
+===============
+
+This document describes how an eXpress Data Path (XDP) program can access
+hardware metadata related to a packet using a set of helper functions,
+and how it can pass that metadata on to other consumers.
+
+General Design
+==============
+
+XDP has access to a set of kfuncs to manipulate the metadata in an XDP frame.
+Every device driver that wishes to expose additional packet metadata can
+implement these kfuncs. The set of kfuncs is declared in ``include/net/xdp.h``
+via ``XDP_METADATA_KFUNC_xxx``.
+
+Currently, the following kfuncs are supported. In the future, as more
+metadata is supported, this set will grow:
+
+.. kernel-doc:: net/core/xdp.c
+   :identifiers: bpf_xdp_metadata_rx_timestamp bpf_xdp_metadata_rx_hash
+
+An XDP program can use these kfuncs to read the metadata into stack
+variables for its own consumption. Or, to pass the metadata on to other
+consumers, an XDP program can store it into the metadata area carried
+ahead of the packet.
+
+Not all kfuncs have to be implemented by the device driver; when not
+implemented, the default ones that return ``-EOPNOTSUPP`` will be used.
+
+Within an XDP frame, the metadata layout is as follows::
+
+  +----------+-----------------+------+
+  | headroom | custom metadata | data |
+  +----------+-----------------+------+
+             ^                 ^
+             |                 |
+   xdp_buff->data_meta   xdp_buff->data
+
+An XDP program can store individual metadata items into this ``data_meta``
+area in whichever format it chooses. Later consumers of the metadata
+will have to agree on the format by some out of band contract (like for
+the AF_XDP use case, see below).
+
+AF_XDP
+======
+
+:doc:`af_xdp` use-case implies that there is a contract between the BPF
+program that redirects XDP frames into the ``AF_XDP`` socket (``XSK``) and
+the final consumer. Thus the BPF program manually allocates a fixed number of
+bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
+of kfuncs to populate it. The userspace ``XSK`` consumer computes
+``xsk_umem__get_data() - METADATA_SIZE`` to locate that metadata.
+Note, ``xsk_umem__get_data`` is defined in ``libxdp`` and
+``METADATA_SIZE`` is an application-specific constant.
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
+into the kernel. The kernel creates the ``skb`` out of the ``xdp_buff``
+contents. Currently, every driver has custom kernel code to parse
+the descriptors and populate ``skb`` metadata when doing this ``xdp_buff->skb``
+conversion, and the XDP metadata is not used by the kernel when building
+``skbs``. However, TC-BPF programs can access the XDP metadata area using
+the ``data_meta`` pointer.
+
+In the future, we'd like to support a case where an XDP program
+can override some of the metadata used for building ``skbs``.
+
+bpf_redirect_map
+================
+
+``bpf_redirect_map`` can redirect the frame to a different device.
+Some devices (like virtual ethernet links) support running a second XDP
+program after the redirect. However, the final consumer doesn't have
+access to the original hardware descriptor and can't access any of
+the original metadata. The same applies to XDP programs installed
+into devmaps and cpumaps.
+
+This means that for redirected packets only custom metadata is
+currently supported, which has to be prepared by the initial XDP program
+before redirect. If the frame is eventually passed to the kernel, the
+``skb`` created from such a frame won't have any hardware metadata populated
+in its ``skb``. If such a packet is later redirected into an ``XSK``,
+that will also only have access to the custom metadata.
+
+bpf_tail_call
+=============
+
+Adding programs that access metadata kfuncs to the ``BPF_MAP_TYPE_PROG_ARRAY``
+is currently not supported.
+
+Example
+=======
+
+See ``tools/testing/selftests/bpf/progs/xdp_metadata.c`` and
+``tools/testing/selftests/bpf/prog_tests/xdp_metadata.c`` for an example of
+BPF program that handles XDP metadata.
-- 
2.39.0.314.g84b9a713c41-goog

