Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A431C266571
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgIKRB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgIKPEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:04:16 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1EDC06135D
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:31:06 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e23so14106642eja.3
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8voqPtdkbS5RYnHXaRVOj2SC1jKq1kvwIX4dEXxo6Mc=;
        b=qySYWhW0yC42rPW/IoqWQolhYfXTLM21q7M2YytnHh2yQU4RoGj86gmZePTxz8sAjT
         GFnqtUFKRVnNvFFSoku5JBmqgqWLDyp3MH8ip3utZK5/D9/Q5oyLP69h10p78VRSCZL4
         CjxstQ5GyKsCPPsHl+CbtPcFPb7vjpkHd29RXhjIRjBEWV+X8wVZQMmDOV0ELwoDcLmz
         HrVgononjhPjTIsOluxMQICFWXylrDWQkjYNSlCBsEJOszmzHOOjtdqU3VA0Jdd7dB1w
         X8H0violb+3GZwx8SNphe81iv+N5lCd4hWhgNDxulNEkayJY2qBM/9ftAQY8iAf/gPHo
         GyDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8voqPtdkbS5RYnHXaRVOj2SC1jKq1kvwIX4dEXxo6Mc=;
        b=KXtg6y2afko3hqSiELpLZPsUuPfOZCVmP1u42a3u8zGhCarys20mD1PkjgscRXTFUp
         ysetn6NtrCnYHTat2dRrEgcFr3Lacsb6vTLcL271NNxpZIaNWccfDiAwsMikLx4q8IM3
         lhwHDV92qPOvgygYOd/8WD8oXtciOO9bDVpKslq+f1jysraBecLlDSPLooBduv1kE105
         dwXA23RJacGhu+oenfU/Bvc8MZnYkz4LGUAtfDe+sYOM7YA9pGgtK7vtEdDvTtsmhg6r
         9dtQiWuRANjXPa6DJ9xbqEmlRb6Sph8jCIEYwnvaGUXHE3N20DN2jUXdP57KQPWl+OqI
         0SMQ==
X-Gm-Message-State: AOAM533udMyM0dan5aqm6TQAa/MNkkZ9Kl5/x24lmtCXTduxrz9PynnX
        Vf8DPZxgeXzkHJ2hNJFBsGI5mQ==
X-Google-Smtp-Source: ABdhPJx9aD+LYlhca0oVerMVXjMsebdQaEZZyd5ADDx85BMSztyKMmeinroRPPOAzwBmwtoOQ65huA==
X-Received: by 2002:a17:906:5206:: with SMTP id g6mr2404464ejm.292.1599834665328;
        Fri, 11 Sep 2020 07:31:05 -0700 (PDT)
Received: from localhost.localdomain ([87.66.33.240])
        by smtp.gmail.com with ESMTPSA id y21sm1716261eju.46.2020.09.11.07.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 07:31:04 -0700 (PDT)
From:   Nicolas Rybowski <nicolas.rybowski@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Cc:     Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 2/5] mptcp: attach subflow socket to parent cgroup
Date:   Fri, 11 Sep 2020 16:30:17 +0200
Message-Id: <20200911143022.414783-2-nicolas.rybowski@tessares.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been observed that the kernel sockets created for the subflows
(except the first one) are not in the same cgroup as their parents.
That's because the additional subflows are created by kernel workers.

This is a problem with eBPF programs attached to the parent's
cgroup won't be executed for the children. But also with any other features
of CGroup linked to a sk.

This patch fixes this behaviour.

As the subflow sockets are created by the kernel, we can't use
'mem_cgroup_sk_alloc' because of the current context being the one of the
kworker. This is why we have to do low level memcg manipulation, if
required.

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
---
 net/mptcp/subflow.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index e8cac2655c82..535a3f9f8cfc 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1130,6 +1130,30 @@ int __mptcp_subflow_connect(struct sock *sk, int ifindex,
 	return err;
 }
 
+static void mptcp_attach_cgroup(struct sock *parent, struct sock *child)
+{
+#ifdef CONFIG_SOCK_CGROUP_DATA
+	struct sock_cgroup_data *parent_skcd = &parent->sk_cgrp_data,
+				*child_skcd = &child->sk_cgrp_data;
+
+	/* only the additional subflows created by kworkers have to be modified */
+	if (cgroup_id(sock_cgroup_ptr(parent_skcd)) !=
+	    cgroup_id(sock_cgroup_ptr(child_skcd))) {
+#ifdef CONFIG_MEMCG
+		struct mem_cgroup *memcg = parent->sk_memcg;
+
+		mem_cgroup_sk_free(child);
+		if (memcg && css_tryget(&memcg->css))
+			child->sk_memcg = memcg;
+#endif /* CONFIG_MEMCG */
+
+		cgroup_sk_free(child_skcd);
+		*child_skcd = *parent_skcd;
+		cgroup_sk_clone(child_skcd);
+	}
+#endif /* CONFIG_SOCK_CGROUP_DATA */
+}
+
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 {
 	struct mptcp_subflow_context *subflow;
@@ -1150,6 +1174,9 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 
 	lock_sock(sf->sk);
 
+	/* the newly created socket has to be in the same cgroup as its parent */
+	mptcp_attach_cgroup(sk, sf->sk);
+
 	/* kernel sockets do not by default acquire net ref, but TCP timer
 	 * needs it.
 	 */
-- 
2.28.0

