Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF23673477
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfGXRAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:00:32 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:33014 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfGXRAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 13:00:32 -0400
Received: by mail-pg1-f201.google.com with SMTP id a21so21804407pgv.0
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 10:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5PMPzWIi54TuG8trdkiDS7NRHXm1UpJoF4P7uSxvOC8=;
        b=ZkfjP79fQlugj9oRiKGTXzOIt7HG4wTkP4ttxamQ1H2fXL12z0W4v3jLA8+JOLFCLp
         jjPyQhq7+OqufH9UwSObbCma6xYUlYUQKsZqwMCQBdaqV0FpuwytWHLQtRxzYLtZG0Pm
         LhXYjAd1tfD3+Bxxlc1tnZOL9wW5goycfiL9fHsO0ZB30ekAMk/OwtB0REelQqkPZrhr
         50u6TVifj4khG4VGjYuvk7wxY092rWQxzfvnaYqTeHxa/Kkzlc6Y2oPCuxs3IS8uEc1Z
         St/qco1Pet2w8ISFGdtncwLWi888LCfJCh6QfbFEtANjgiidP78hVp2azC2uTx5ipF5P
         LXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5PMPzWIi54TuG8trdkiDS7NRHXm1UpJoF4P7uSxvOC8=;
        b=fScbZqQaBumnt6DmvH666u/WEPpPwUis7AVzVNgMKy6TzUbK/guoE4DVXlELPHAD9V
         jxx7tyN7to/+Pnvm49/YjjMV8ZG3arX0QZK9QGgXVHI4nFez7/Obqo8/gKkyVRPOsxHW
         TRBeygq+poJn/YkUqzYAYQzM6F+i382Z5wJEKu4mK5Uyhh7bx4zT7VrFo+rHydkvSknt
         Bv4xW90tb8DI+zr07ELr0PMEsHfvDqpqraCsW43tleOjymVqFdcsynx8g2h6zb7lZTZ5
         Ftle2XUBLW5Zevnogt3Ist8XhfPIVBkP+ZssSKfwBYNTiGeHEmhCCeCUXYy6TpT6euyD
         RU3g==
X-Gm-Message-State: APjAAAUKFrz0pxHq/Z7jRd4/lw93lIC2mi8GMd3/WMNWR9md88fRBRfI
        m1DMeVQIW6VSYX+NxASeuYP676Aep2u8XdrH1TMEBJVIoPGcr396sKbxXfrljZka9FnTNH5Y3md
        7MjFZhBrkEkTIzbX7qNy/yCizczZlBA4nIO1eIFUGe1mBUiPSXGDtMA==
X-Google-Smtp-Source: APXvYqxwinw/JzYT/Sfh5yugln/Pl+rujP5HPMle4krOX1orqcd5Sptnnw4VwpGrpVkNsFkFGbyNM64=
X-Received: by 2002:a63:e306:: with SMTP id f6mr80983714pgh.39.1563987630889;
 Wed, 24 Jul 2019 10:00:30 -0700 (PDT)
Date:   Wed, 24 Jul 2019 10:00:15 -0700
In-Reply-To: <20190724170018.96659-1-sdf@google.com>
Message-Id: <20190724170018.96659-5-sdf@google.com>
Mime-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next 4/7] tools/bpf: sync bpf_flow_keys flags
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export bpf_flow_keys flags to tools/libbpf/selftests.

Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4e455018da65..a0e1c891b56f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3504,6 +3504,10 @@ enum bpf_task_fd_type {
 	BPF_FD_TYPE_URETPROBE,		/* filename + offset */
 };
 
+#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG		(1U << 0)
+#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	(1U << 1)
+#define FLOW_DISSECTOR_F_STOP_AT_ENCAP		(1U << 2)
+
 struct bpf_flow_keys {
 	__u16	nhoff;
 	__u16	thoff;
@@ -3525,6 +3529,7 @@ struct bpf_flow_keys {
 			__u32	ipv6_dst[4];	/* in6_addr; network order */
 		};
 	};
+	__u32	flags;
 };
 
 struct bpf_func_info {
-- 
2.22.0.657.g960e92d24f-goog

