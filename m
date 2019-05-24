Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C296F2A14D
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404378AbfEXW27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:28:59 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:41854 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404308AbfEXW27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:28:59 -0400
Received: by mail-yb1-f201.google.com with SMTP id q185so9571916ybc.8
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qMovpOHh9UtpX8EWlQ95Jzm7k03iPOrye3cAHpJ3zYQ=;
        b=KfgHzn9r8xCSmWgerdWxC8Ns29cWdiSikWuFUwitGwmhONaLHS8vDzNGD8UqZpU7IS
         CiXXVjqxt/wNr6RibGUY6Q8gfwCNm0DDp8fR8EjUA/fFGkWXNMWEXcZ3ETWDIzFHW2Oc
         ckEZH43uNfspsOS+/EdsCpVNhE/y0GPrma8tiYmDoo+cC1u9+FTszylquvZvDmVLu+Ph
         eLKAjqXauuarecZ8q+nqjDRKbHaHA+O9zK9i+g4fpGULddgX9PDKgyFIpnKj2OJWZH2L
         xcmjJPYUM3dkdpWfVt9o8Fti563DgSjfbfSoN+Ep852SM9gmbf6wJP1erHU1NXAjn0Lj
         gR8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qMovpOHh9UtpX8EWlQ95Jzm7k03iPOrye3cAHpJ3zYQ=;
        b=NPQtnI8iklTFgvkNj4k7xaoFrWDw85RPip/j3rQlxg9GvLKiz5VG9+cPAmnmpTQXUx
         u+skIHGco9rW+1v4i5Ja/3hq69LKx9i5YJTtH9VQAb37/URpKRn1ATvMGVWsWala64bT
         vqohGmhBGyjOUed/lLLY8eoDqI18E0lFz1J32tCr+wtS8DnQeViSq1Q7vCdqoMbx9jLH
         bSzPwplo/0iKjsB9Gf3IGKR3gp6dyfHc4nmyq/gGyZAWLZXe19vXf9MZ9pFq8jrz5IrQ
         C8L+E6Toj0PRRXNmFbz5uzb0/tbZbsU1sZnehreRbqsy5/1YSu2/gr1gGGhemqpWd6Xk
         +UDg==
X-Gm-Message-State: APjAAAVXOsV0Lk3A2VgPs0sWUrU3CssIiEkzNEHVUjs8hNh+zjK5e+XR
        PeVIN4O8ntlTrQ9gvmAH8BfmVusRsg5Xr4BsMnxQTyXQznSkflR22MydEYxu6yFli0hsquxWAon
        Uqm6N/sUTUgX5WyCXCQMPy6OSjA1DQRWUwGRWr6woyJBg+hnnQvnBOg==
X-Google-Smtp-Source: APXvYqwvw2SZ5X/QNkZ6/+2TCJlkZZPZce/COZVnliwqSeRGjFGUS4SdX93WAElCjn8NvDmGmjp5zJk=
X-Received: by 2002:a25:2487:: with SMTP id k129mr9156184ybk.91.1558736938114;
 Fri, 24 May 2019 15:28:58 -0700 (PDT)
Date:   Fri, 24 May 2019 15:28:56 -0700
Message-Id: <20190524222856.60646-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH bpf-next] selftests/bpf: fail test_tunnel.sh if subtests fail
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now test_tunnel.sh always exits with success even if some
of the subtests fail. Since the output is very verbose, it's
hard to spot the issues with subtests. Let's fail the script
if any subtest fails.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_tunnel.sh | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_tunnel.sh b/tools/testing/selftests/bpf/test_tunnel.sh
index 546aee3e9fb4..bd12ec97a44d 100755
--- a/tools/testing/selftests/bpf/test_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tunnel.sh
@@ -696,30 +696,57 @@ check_err()
 
 bpf_tunnel_test()
 {
+	local errors=0
+
 	echo "Testing GRE tunnel..."
 	test_gre
+	errors=$(( $errors + $? ))
+
 	echo "Testing IP6GRE tunnel..."
 	test_ip6gre
+	errors=$(( $errors + $? ))
+
 	echo "Testing IP6GRETAP tunnel..."
 	test_ip6gretap
+	errors=$(( $errors + $? ))
+
 	echo "Testing ERSPAN tunnel..."
 	test_erspan v2
+	errors=$(( $errors + $? ))
+
 	echo "Testing IP6ERSPAN tunnel..."
 	test_ip6erspan v2
+	errors=$(( $errors + $? ))
+
 	echo "Testing VXLAN tunnel..."
 	test_vxlan
+	errors=$(( $errors + $? ))
+
 	echo "Testing IP6VXLAN tunnel..."
 	test_ip6vxlan
+	errors=$(( $errors + $? ))
+
 	echo "Testing GENEVE tunnel..."
 	test_geneve
+	errors=$(( $errors + $? ))
+
 	echo "Testing IP6GENEVE tunnel..."
 	test_ip6geneve
+	errors=$(( $errors + $? ))
+
 	echo "Testing IPIP tunnel..."
 	test_ipip
+	errors=$(( $errors + $? ))
+
 	echo "Testing IPIP6 tunnel..."
 	test_ipip6
+	errors=$(( $errors + $? ))
+
 	echo "Testing IPSec tunnel..."
 	test_xfrm_tunnel
+	errors=$(( $errors + $? ))
+
+	return $errors
 }
 
 trap cleanup 0 3 6
@@ -728,4 +755,9 @@ trap cleanup_exit 2 9
 cleanup
 bpf_tunnel_test
 
+if [ $? -ne 0 ]; then
+	echo -e "$(basename $0): ${RED}FAIL${NC}"
+	exit 1
+fi
+echo -e "$(basename $0): ${GREEN}PASS${NC}"
 exit 0
-- 
2.22.0.rc1.257.g3120a18244-goog

