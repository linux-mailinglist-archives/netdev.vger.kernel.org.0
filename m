Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D8A20B64D
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgFZQwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbgFZQwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 12:52:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E9AC03E97A
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 09:52:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f16so10412434ybp.5
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 09:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=f6Da7523rX1uWkEPLzRoAH+Igij3aUvySfasC0+tw+I=;
        b=L9e0MAvJShBETk20ArQF02ez232dqV2o84ZToF1CZhodWJoLD33GIkiZCRFZoo7eBM
         wXjS/hQ9l/NxubTSKh/++WdG6ruUosLVlGaNPmLWxdxvQ1SQfgB5QiFSfcMhnNSTfLCa
         6rCdR14ZT1jndlE3E9n3Nu1j8HrUDj8pwO4goYwg22hM0CCtHdy8YhXtCLlbPRRTiwqO
         stQ8RbxX90raorfMqF7G0uS8+lCwBJuqNqxWaFBbk4fLN+W0fprq9XYyW8y99LZE0Ipr
         /f97Jqi6np6qXT42dKH6HazqNHXRqm4HglfbUPGGso2X/PJhvmCVQ6IJfoR7qt/X+6++
         8xzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f6Da7523rX1uWkEPLzRoAH+Igij3aUvySfasC0+tw+I=;
        b=YYGjemUi8pVC6xRsBdtqkuuIyAsEL3uz4/7h3YouV2grw9QlOijuZBjvma67O2yU8t
         FMDNfHa5pz6zgMgQnALthap8FGsL3FliJ4tQ75O7nGQ0+/tMPtT0nKnavbSF8oFt4GXi
         AxNNDBOlHWjx9aOF8oB/nPiArnnjdyRHDn56QWSZ5mU7LcENySwaxzs0AB6V4SvP4Ix4
         US3MrhSST5b7FmbuvfR9F04HMnHfGEr44BPyiJmIXTLwSvAjNJWkvu/Eotvkl4wBFjB7
         p+v8iSJKsjsgkFn21W+d1rYJ+1o9rsCMMD/Y2stMctl+0B02JSnDydsQhOqfSHthgneQ
         AJRA==
X-Gm-Message-State: AOAM5333dN56XKkVxy51pXGi4kAK22QXcTPcs8/UnunUtQcVaCyQtSmi
        xDAjtigvTQTvQ3xzPKgXytJyuMnVnpXRa4K0fjhzvNzYC0hARYGy/hQ21LpWkccBDW9tCK4Vim9
        n+bjwTGPDfxbrfQ93XJwp3ZCNH7WO9NIkkpUmjrPkMMtT+LX8u/jzQA==
X-Google-Smtp-Source: ABdhPJwu+wvSSUYejBhERT+998mB3wPdnawJIIxMRc/fJgg73eeQFByoBybA95AIp2ZnHJW0U2FLshA=
X-Received: by 2002:a25:230a:: with SMTP id j10mr6699807ybj.148.1593190357016;
 Fri, 26 Jun 2020 09:52:37 -0700 (PDT)
Date:   Fri, 26 Jun 2020 09:52:30 -0700
In-Reply-To: <20200626165231.672001-1-sdf@google.com>
Message-Id: <20200626165231.672001-3-sdf@google.com>
Mime-Version: 1.0
References: <20200626165231.672001-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v2 3/4] bpftool: support BPF_CGROUP_INET_SOCK_RELEASE
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support attaching to sock_release from the bpftool.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/main.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 5cdf0bc049bd..0a281d3cceb8 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -92,6 +92,7 @@ static const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 	[BPF_CGROUP_INET_INGRESS] = "ingress",
 	[BPF_CGROUP_INET_EGRESS] = "egress",
 	[BPF_CGROUP_INET_SOCK_CREATE] = "sock_create",
+	[BPF_CGROUP_INET_SOCK_RELEASE] = "sock_release",
 	[BPF_CGROUP_SOCK_OPS] = "sock_ops",
 	[BPF_CGROUP_DEVICE] = "device",
 	[BPF_CGROUP_INET4_BIND] = "bind4",
-- 
2.27.0.212.ge8ba1cc988-goog

