Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E36643B6C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiLFCp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiLFCp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:45:58 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD5717428
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:45:57 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id v16-20020a62a510000000b005745a58c197so12227237pfm.23
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 18:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7URUgBrKGQOFuDlwYgH7mee65ML5TVjzybnoYHjmOmM=;
        b=I5/Lw17fhc9vXOYi/OJsnQgTZJaqys/GeFO51fPwrlIsiYeJITRci+DqPjfJDk2HXg
         JWeAXs/iV929rIXxW9i2gYoUMt+awNjlli6SsmQ3QkpKC0hzfBdeoPpQ7Ux8RZ2w64CU
         3PwxSDAlKrFzuDxd/xpuNDXE8P9+r4F7Pqm+7Xutiej4aTTmM2M9sZGVMoWiY4rIyDTq
         ediYERVb+XyBRhlgsm+CQyYUbeAXttWIXiJ0IeQqecmiTCu8M2YXCHqAQne0lbxK3eY6
         BE4ZKiRJbB5/JIeoJWhoEQ/DpI1iLvv9VflTBnFBYGCBdu1c5uzMqOp1npAvZmAoq1Fl
         ZoXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7URUgBrKGQOFuDlwYgH7mee65ML5TVjzybnoYHjmOmM=;
        b=U7iWxIdP47b+dFzoFAIDffZ96FaxxSOCZ+YycQiFOY+OUfVbPkACBL6oFCCQzoklQB
         yaVxZ5MxaHYd6OnKgIKDoB0tSnAW/P35FXuSmCB3B32i2egDfRODZJSzucRrDlSjW6Kn
         f10blAWztj8ORTKw2iq5ucjeBfO2rlJUavF1Db4sGVzXBD8XVUorW0/gE75rYnkOPWzg
         bwO2pyTTLVhIRBj0ICGS7ynH3+6BGDKhIMGffpo5oRUV0Z3UN8Yj1ZBVo0r8pOLirDL0
         3AmvNIc5Y/vF2JRtzdPX4U0qrwEiYT4bkVxx9kycqyvdj/p0YmxnEf8FPobccpuIc3uy
         WJOw==
X-Gm-Message-State: ANoB5plxMWNmK9zgEAc4djEfx3GZpSG+HqP73pXSswFahaaFW8s2rhlf
        CpYztpEihqmLcv2snCiMp97yFoc=
X-Google-Smtp-Source: AA0mqf4p2h/2PUlIFQX1WrqE0/czaGBnrfl6K5ORPaeW8AetNwJEA4yNULch3vpqdJrhv3K47x08FcY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:4313:b0:212:e24e:16b3 with SMTP id
 q19-20020a17090a431300b00212e24e16b3mr96814794pjg.69.1670294757435; Mon, 05
 Dec 2022 18:45:57 -0800 (PST)
Date:   Mon,  5 Dec 2022 18:45:43 -0800
In-Reply-To: <20221206024554.3826186-1-sdf@google.com>
Mime-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206024554.3826186-2-sdf@google.com>
Subject: [PATCH bpf-next v3 01/12] bpf: Document XDP RX metadata
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
2.39.0.rc0.267.gcb52ba06e7-goog

