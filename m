Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B0EDDFA5
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfJTRHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 13:07:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38968 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfJTRHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 13:07:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id p12so6183053pgn.6;
        Sun, 20 Oct 2019 10:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XctxpsmH04LYAq9WgHg+9E0PoY+xS1FvDl3lkgy7Py8=;
        b=uiGX7Fa6jkw9jaMvT1N9aYHq6RJ87nVEY2tRGdC10we5yLZh1nhR+IYEcUgx+fRX2Y
         vujMyCZ2ST/xKI2BJt7ZHauoVPh7jBNn9f/fPhPOkciHuGuMveadyFaRxMIC0R/p0CMH
         cK+ZlL3N92jOX/nvaUNz5OWW0EFIHB6aSG0I0+hI+5kFxO2qoqRUhLWPHFXv8D2nSJny
         9CX/wQQryqXTcY1X78UTkNDKHJ4g8Wa/D3XHOpAHaJRsR+YimsOneXmcxnNOcE9PNPXz
         rdxufxhSLH6qVYVf+jkcMhKo37yPEjWvoecRC1PGbgPyDCKosRo5pIpkkRh9vAlcHmLJ
         dUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XctxpsmH04LYAq9WgHg+9E0PoY+xS1FvDl3lkgy7Py8=;
        b=pRyjpgM+KYGI2gwFNiUYlZ9+jR9iHmCrkK7tVu/XiWBHOXc08UILDPpKxgZPZshUNQ
         cHuXQ3WT2M0jXrRKoIBKFF6H+R+XKw9SIWb2qz0y+eytn3DlK7QJMPj3h5YB6ZGV9XrI
         gVWcVd7cgFGLcxww2+NY74aEQCbWn8Iy1RjRuNKraYZNY6SUR2lDUz6kRada+cpA/I7j
         gNgCOLpIhbl1zXn6K9ke5Bm3dZ1mq7FvjZLg/BlpcsBmgQuPwzdcjBx562br10Nw3Po0
         aRdlGkrBXnQUJxK/p0TkDvQdEifT/5iIEbYMUK8c7dzm25rNhelD7VVPWotTQwISohgg
         215A==
X-Gm-Message-State: APjAAAW1siyiP5BBDVRqEeFTGQJBCuXrZm7fFvuXaH8tKaiDysN53O0o
        +n17vpqHg2FW7Dv8d1UAyWRhRlWYBzs=
X-Google-Smtp-Source: APXvYqy+oa+Wg/7TkIRpXSWGt26Om7+b1X9j+71p8xQGTZMa+OUseW1xu6jQ1IWlC6WxCQzpWIbS8A==
X-Received: by 2002:a62:4ed6:: with SMTP id c205mr17623065pfb.170.1571591251752;
        Sun, 20 Oct 2019 10:07:31 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id y8sm15938996pgs.34.2019.10.20.10.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 10:07:30 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, toke@redhat.com,
        sridhar.samudrala@intel.com
Subject: [PATCH bpf-next] libbpf: remove explicit XSKMAP lookup from AF_XDP XDP program
Date:   Sun, 20 Oct 2019 19:07:11 +0200
Message-Id: <20191020170711.22082-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

In commit 43e74c0267a3 ("bpf_xdp_redirect_map: Perform map lookup in
eBPF helper") the bpf_redirect_map() helper learned to do map lookup,
which means that the explicit lookup in the XDP program for AF_XDP is
not needed.

This commit removes the map lookup, which simplifies the BPF code and
improves the performance for the "rx_drop" [1] scenario with ~4%.

[1] # xdpsock -i eth0 -z -r

Suggested-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/xsk.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index b0f532544c91..8e35de3cb443 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -278,29 +278,15 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 	 *
 	 *     // A set entry here means that the correspnding queue_id
 	 *     // has an active AF_XDP socket bound to it.
-	 *     if (bpf_map_lookup_elem(&xsks_map, &index))
-	 *         return bpf_redirect_map(&xsks_map, index, 0);
-	 *
-	 *     return XDP_PASS;
+	 *     return bpf_redirect_map(&xsks_map, index, XDP_PASS);
 	 * }
 	 */
 	struct bpf_insn prog[] = {
-		/* r1 = *(u32 *)(r1 + 16) */
-		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 16),
-		/* *(u32 *)(r10 - 4) = r1 */
-		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_1, -4),
-		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
-		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
-		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
-		BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
-		BPF_MOV32_IMM(BPF_REG_0, 2),
-		/* if r1 == 0 goto +5 */
-		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
-		/* r2 = *(u32 *)(r10 - 4) */
+		/* r2 = *(u32 *)(r1 + 16) */
+		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 16),
 		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
-		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_10, -4),
-		BPF_MOV32_IMM(BPF_REG_3, 0),
+		/* r3 = XDP_PASS */
+		BPF_MOV32_IMM(BPF_REG_3, 2),
 		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
 		/* The jumps are to this instruction */
 		BPF_EXIT_INSN(),
-- 
2.20.1

