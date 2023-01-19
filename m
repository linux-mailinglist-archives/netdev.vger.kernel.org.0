Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D38674612
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 23:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjASWcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 17:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjASWcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 17:32:08 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B072A83BC
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:15:40 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4dedc46e2d5so33102887b3.21
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WqkHn4f0/GKzOk6tgm+fz56hvPkrZ3hzKvvIPQn7yIk=;
        b=sE0+jeRh5nsa7BeD7DBfXx126J+IFMi+/+BmOPXUgyTGcNamYD/3X83LhH27PSqeRB
         vo12orSIl+YcslA+Rh0TC+J/E1VMUX6rie1BEOlD4XjpCO339Bf85IUR9WTVf7yhfLUL
         OnH+VwhcrWky7nSc8AGHfavF8vUpd1ELSUt/vi6NuxBHzZc4TuLUzIUASPuszHHvmLLE
         Me8XeBa8E+rPs4Tu2mF79Dw5K3cg+OEFdtxaJwAEpWp6H9v7OgVQQjIsKcqMuiRxgbqE
         nGwJ4Q6Wxsx4WrM/ibhGibOorZt6wNpknUucKGucbhsLzUDPt8QeeA8sP5E+9KtxVc9F
         Re3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WqkHn4f0/GKzOk6tgm+fz56hvPkrZ3hzKvvIPQn7yIk=;
        b=k9TVdXiXMuw5Wxrt86pHMmtU8BXh0/eOYfeFIH2CZ+75+tSycXmXikLSZcnfRZ8Nrv
         i1blkscxDfyhmE0ZBfAjbwXtVUfHb02EQiPVpzD+3TUKTR2vujIn5+Mi4iCUQ9Ro0spw
         2eZmE+TmcPeHf2/vF+Ss+0zc8o3DuELI7694UBZz7jLP2ZXEd7EHCWN8UKaUOSxAiY8n
         F8fZn8+IK+VNd0ezFDfZdF0QWfrRxnBVsUkeDHuFOPnJibfUlct/4gmByF/fSb11bP8x
         cSpSIKPASSpJi0qlikIL8WxmDDBKyZRgBk+5MgRFr7uE2hKWfHLVZsttdGvalN5HrqXj
         k11Q==
X-Gm-Message-State: AFqh2krif6EV+nqinFmx2Xk60hyAQoglaYQepQOoJiFLbE9eSsKUnn6f
        NqLJYn8OZNFgF98yeoFBFPVWJ3A=
X-Google-Smtp-Source: AMrXdXvZ/86VHHr4hp+xEXZa3ctak3v2rFjJNmXi4ECTEIjKSSNqSRtCcwkGZ28I5vOYwXPXY9ql/Ik=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:3f06:0:b0:7d1:87e:1713 with SMTP id
 m6-20020a253f06000000b007d1087e1713mr1414033yba.102.1674166539291; Thu, 19
 Jan 2023 14:15:39 -0800 (PST)
Date:   Thu, 19 Jan 2023 14:15:20 -0800
In-Reply-To: <20230119221536.3349901-1-sdf@google.com>
Mime-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119221536.3349901-2-sdf@google.com>
Subject: [PATCH bpf-next v8 01/17] bpf: Document XDP RX metadata
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
        netdev@vger.kernel.org, David Vernet <void@manifault.com>
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
Acked-by: David Vernet <void@manifault.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/networking/index.rst           |   1 +
 Documentation/networking/xdp-rx-metadata.rst | 110 +++++++++++++++++++
 2 files changed, 111 insertions(+)
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
index 000000000000..aac63fc2d08b
--- /dev/null
+++ b/Documentation/networking/xdp-rx-metadata.rst
@@ -0,0 +1,110 @@
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
+Within an XDP frame, the metadata layout (accessed via ``xdp_buff``) is
+as follows::
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
+``METADATA_SIZE`` is an application-specific constant (``AF_XDP`` receive
+descriptor does _not_ explicitly carry the size of the metadata).
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
2.39.0.246.g2a6d74b583-goog

