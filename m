Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3279721B737
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgGJNwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:52:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21626 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726908AbgGJNwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594389173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7qcXPpiSrLrqAMWO1T/RAmkvaM7OPcYHB3FU2MBgqI=;
        b=QOWfniwD/kMV+VkdgxpofXVK8n3G9s7IFfoQ6hIJHcrnQiTLTP8s1OboO8BiDtswNG0Vev
        a98b+eGPphbJh6Qo+0gw76cjGNXbPF6wVcVikkf6WqRJf8Q2I2DivaHTOejJDzgGrEEFR3
        xjC7fz5yoikAaG4JsPED1bL1E2H8nr8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-ygiOFRyTOEGnEsf6lcbg1A-1; Fri, 10 Jul 2020 09:52:51 -0400
X-MC-Unique: ygiOFRyTOEGnEsf6lcbg1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 624C01083E81;
        Fri, 10 Jul 2020 13:52:50 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 696D86FEEA;
        Fri, 10 Jul 2020 13:52:49 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 1/2] include: update mptcp uAPI
Date:   Fri, 10 Jul 2020 15:52:34 +0200
Message-Id: <5a90a19ba5b977351393c1088660ba93e4860374.1594388640.git.pabeni@redhat.com>
In-Reply-To: <cover.1594388640.git.pabeni@redhat.com>
References: <cover.1594388640.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This pulls-in diag info definition

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/uapi/linux/inet_diag.h |  1 +
 include/uapi/linux/mptcp.h     | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index f009abf1..cd83b4f8 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -65,6 +65,7 @@ enum {
 	INET_DIAG_REQ_NONE,
 	INET_DIAG_REQ_BYTECODE,
 	INET_DIAG_REQ_SK_BPF_STORAGES,
+	INET_DIAG_REQ_PROTOCOL,
 	__INET_DIAG_REQ_MAX,
 };
 
diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 009b8f0b..32181230 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -86,4 +86,21 @@ enum {
 	__MPTCP_PM_CMD_AFTER_LAST
 };
 
+#define MPTCP_INFO_FLAG_FALLBACK		_BITUL(0)
+#define MPTCP_INFO_FLAG_REMOTE_KEY_RECEIVED	_BITUL(1)
+
+struct mptcp_info {
+	__u8	mptcpi_subflows;
+	__u8	mptcpi_add_addr_signal;
+	__u8	mptcpi_add_addr_accepted;
+	__u8	mptcpi_subflows_max;
+	__u8	mptcpi_add_addr_signal_max;
+	__u8	mptcpi_add_addr_accepted_max;
+	__u32	mptcpi_flags;
+	__u32	mptcpi_token;
+	__u64	mptcpi_write_seq;
+	__u64	mptcpi_snd_una;
+	__u64	mptcpi_rcv_nxt;
+};
+
 #endif /* _MPTCP_H */
-- 
2.26.2

