Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9092E642DEC
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiLEQwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiLEQvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:51:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31CABF48
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670258957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MeP0F0l2ivVD7SK1oXYbUrrM9DEwmjD0zsNJt80fRpk=;
        b=OCZu2v7vwaWJHymZ5qThqC42uMhGqSNvGNtB8xSXeeBgghfvS5ws/M+PnY/Y7HUS0kyjj+
        ldUBaA1HGNKF58KIblhdOCa8Qgx5puoHtKJCD8UlksJ8M/D0c0QnTK6O3RZRoxvhhl0XUM
        6aqRiHWeJgW1FDBK9xfqGNNGutIFqLc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-oeRv5yESPf66qvbMUdFfDg-1; Mon, 05 Dec 2022 11:49:12 -0500
X-MC-Unique: oeRv5yESPf66qvbMUdFfDg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9041638164C3;
        Mon,  5 Dec 2022 16:49:10 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED5A51410DD9;
        Mon,  5 Dec 2022 16:49:08 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH HID for-next v2 4/4] selftests: hid: ensures we have the proper requirements in config
Date:   Mon,  5 Dec 2022 17:48:56 +0100
Message-Id: <20221205164856.705656-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20221205164856.705656-1-benjamin.tissoires@redhat.com>
References: <20221205164856.705656-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DYNAMIC_FTRACE_WITH_DIRECT_CALLS is implicit on x86_64 but is still a
WIP on aarm64. Ensure we get it selected to not have any surprises.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 tools/testing/selftests/hid/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/hid/config b/tools/testing/selftests/hid/config
index d4130489c1b1..9c5a55abca6b 100644
--- a/tools/testing/selftests/hid/config
+++ b/tools/testing/selftests/hid/config
@@ -11,6 +11,7 @@ CONFIG_BPF_SYSCALL=y
 CONFIG_BPF=y
 CONFIG_CGROUP_BPF=y
 CONFIG_DEBUG_INFO_BTF=y
+CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
 CONFIG_FPROBE=y
 CONFIG_FTRACE_SYSCALLS=y
 CONFIG_FUNCTION_TRACER=y
-- 
2.38.1

