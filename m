Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A53548D28F
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 08:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiAMHDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 02:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiAMHDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 02:03:05 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2BFC06173F;
        Wed, 12 Jan 2022 23:03:05 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo9754587pjb.2;
        Wed, 12 Jan 2022 23:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9YiylcqzBMt89XYpqqW+JVelsZs+NS+1Uj8U2luc+c=;
        b=E4ZSdbA0INbaYUj/8z3UQdcHV3vS8hRH3govnpbUuRHsUsT0u/E06Dc9AIEYZE0G+Y
         t5jea3HnE8grm26Poo7uXsc17jcu9g0BvjyBiF/ijpaR/DCzyA2dbVdKmOmaYkLjZ3Is
         q89YPeKs2FB5u67VKVFet3YA9fF/lxKbxJ/IqV74CS3aXvRuk8OlrKR4x0EU46O+v6LK
         4pSAEPaDRNcBLqPNRMABJnYAftYmlcO1d8Yf9rfJlZ7ul+YppebYkemcFsu8eQd2TtHr
         +UkJYVO+aX2XLGwDwQEnbIw1qQh+vl+kWVY9LR2XSUUiLqA1ukMfwKRQqfF1kVpCKgDc
         T5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9YiylcqzBMt89XYpqqW+JVelsZs+NS+1Uj8U2luc+c=;
        b=M6mduMqnJARnlxhdNZIufdO7n0sKeM7e9xSGLnZtjC9BmgBAiYJrSY3jaBG6BfAO//
         1kRuGbcwHEy/SBIA2yxiBRoIFklT0A5djpeL50z+NhPun1JJu6+5OcQsWnU/0NA4Z6rm
         mz/Lw7ZxtAoClutcri1DBDdxLtzJufMQmrsgj6NCOb7KW6zvwihaAMftu8Ih3+NKUKRp
         83pjMRE0rdTWHWlGDxceMgnafMVnuQcSKgrHRCLCID4/eDQnDnnbg6DBE3oe9nOfTNgf
         HXk/+z+cT3xNaKVEyi66jqMG9HM5/dQQXXg2KDauQzL1KtRAm4rtsYhzWh9Ae68mwKFS
         U/Uw==
X-Gm-Message-State: AOAM531hdngwleHrYHwwYSFMgc1GrJCiCqwhx7iEONkeHNH14LZ6kQUl
        Sbs5Zn/Kp2te1Rz+2ZQEs4o=
X-Google-Smtp-Source: ABdhPJwgglElab1mEpYnI9eZBUfcHqlZTfeG/+5IhzX1cUsYiFujXx9qzDeo0Fr1BSve/UkRQi7cJw==
X-Received: by 2002:a05:6a00:134e:b0:4bf:5086:2332 with SMTP id k14-20020a056a00134e00b004bf50862332mr3194025pfu.9.1642057384718;
        Wed, 12 Jan 2022 23:03:04 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id z4sm1613097pfh.215.2022.01.12.23.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 23:03:04 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, mengensun@tencent.com,
        flyingpeng@tencent.com, mungerjiang@tencent.com,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct bpf_sock'
Date:   Thu, 13 Jan 2022 15:02:45 +0800
Message-Id: <20220113070245.791577-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

The description of 'dst_port' in 'struct bpf_sock' is not accurated.
In fact, 'dst_port' is not in network byte order, it is 'partly' in
network byte order.

We can see it in bpf_sock_convert_ctx_access():

> case offsetof(struct bpf_sock, dst_port):
> 	*insn++ = BPF_LDX_MEM(
> 		BPF_FIELD_SIZEOF(struct sock_common, skc_dport),
> 		si->dst_reg, si->src_reg,
> 		bpf_target_off(struct sock_common, skc_dport,
> 			       sizeof_field(struct sock_common,
> 					    skc_dport),
> 			       target_size));

It simply passes 'sock_common->skc_dport' to 'bpf_sock->dst_port',
which makes that the low 16-bits of 'dst_port' is equal to 'skc_port'
and is in network byte order, but the high 16-bites of 'dst_port' is
0. And the actual port is 'bpf_ntohs((__u16)dst_port)', and
'bpf_ntohl(dst_port)' is totally not the right port.

This is different form 'remote_port' in 'struct bpf_sock_ops' or
'struct __sk_buff':

> case offsetof(struct __sk_buff, remote_port):
> 	BUILD_BUG_ON(sizeof_field(struct sock_common, skc_dport) != 2);
>
> 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, sk),
> 			      si->dst_reg, si->src_reg,
> 				      offsetof(struct sk_buff, sk));
> 	*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->dst_reg,
> 			      bpf_target_off(struct sock_common,
> 					     skc_dport,
> 					     2, target_size));
> #ifndef __BIG_ENDIAN_BITFIELD
> 	*insn++ = BPF_ALU32_IMM(BPF_LSH, si->dst_reg, 16);
> #endif

We can see that it will left move 16-bits in little endian, which makes
the whole 'remote_port' is in network byte order, and the actual port
is bpf_ntohl(remote_port).

Note this in the document of 'dst_port'. ( Maybe this should be unified
in the code? )

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/uapi/linux/bpf.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b0383d371b9a..891a182a749a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5500,7 +5500,11 @@ struct bpf_sock {
 	__u32 src_ip4;
 	__u32 src_ip6[4];
 	__u32 src_port;		/* host byte order */
-	__u32 dst_port;		/* network byte order */
+	__u32 dst_port;		/* low 16-bits are in network byte order,
+				 * and high 16-bits are filled by 0.
+				 * So the real port in host byte order is
+				 * bpf_ntohs((__u16)dst_port).
+				 */
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
-- 
2.34.1

