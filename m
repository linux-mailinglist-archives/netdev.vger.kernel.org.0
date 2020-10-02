Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09C3280B7E
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 02:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733085AbgJBAEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 20:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731525AbgJBAEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 20:04:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B247BC0613E2
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 17:04:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s128so641274ybc.21
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 17:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=D/6wuu7G5ipBgz3n+vEqaRzmvPM65gW36ZXpDlR+Izo=;
        b=BlYac3o6Nrij7ij4sxT/qxVzzvCIgoOgTIoyEyHwPpFviC2fY8UVqmI2bDNaD696CI
         wL0L8N9BwDm5Z5uM2q1iA5c/fVZECoJ8Dh6fBoJmFgrEUpZraJsEB2yx2dyfO2elhwYN
         pnRYlozVBpDEU3ruiiND/PBdhwy2BjHh6WBItt4esjY56jxMorivKHNMflM5zpxByFC9
         SnnBagGNorww3Zvq9rAJ6frrQWCKkLe7PxjUxf8nOS5W3IcliTDJYUHk4Z/ipyRrDATg
         rJPofrUMx2fBNFC7YFlWwLl3Mxk+wr4a/pR7YHDzbJbi/xd0xcDA+mU5cIE+PJN4Dsc6
         ohDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=D/6wuu7G5ipBgz3n+vEqaRzmvPM65gW36ZXpDlR+Izo=;
        b=dmeukHaLZp4PeSD5jZOQjLvQa1MtzOekSn6lj/z9bkv2DDc35MYOBpA3XSTLfKxUVd
         ngdQtW+CEhGLAxINuZAzkitvjvuhfl5ONnvwpGshu3I1+DfM1HF14geFCkyaUdTXW8mm
         w0jnp2+t1JbK8LVHXQzNoLQOehOgJVNnq2g36nyfq8BuB97w3wgkCI+4Vgreji6fq2Wh
         gGLItp6zezY4W2ZxTrUjyzJXA3gpksmmWxzobjq0Q7f6uw7WSMoABn1wQCjh3QO5d9eX
         Oo9N/nR171iMbM6w/X7Np7hTFGVAchTgol75gCOSTEagsnSt+GgmmA2XolGrpwvVqsTw
         80sQ==
X-Gm-Message-State: AOAM532kd3klVQmqMVFZoGP4SW9UwHgEKyCp7p6DziHke6B88ctdb78n
        Hf/WbhILbJuBN0jC1h+l2xbyC8T8HmLv2tSJn/pwkCjEQP9+dfwPDJOeujTJXrISW8e6pHO6zVT
        lTRNLsG8yhXte+3XN1hBRDw9V3FRaFRqbWbFbS2i/1Zc3lnpxU8YWzw==
X-Google-Smtp-Source: ABdhPJzQlhHu9gt3HmQUwpsu9kt7xfdMf4F6/oIPnXRHh14wXdedhS/pxawGtdxPaeFk7MmIVfAVSN8=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:c688:: with SMTP id k130mr13341967ybf.51.1601597092792;
 Thu, 01 Oct 2020 17:04:52 -0700 (PDT)
Date:   Thu,  1 Oct 2020 17:04:51 -0700
Message-Id: <20201002000451.1794044-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH bpf-next] selftests/bpf: properly initialize linfo in sockmap_basic
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using -Werror=missing-braces, compiler complains about missing braces.
Let's use use ={} initialization which should do the job:

tools/testing/selftests/bpf/prog_tests/sockmap_basic.c: In function 'test_sockmap_iter':
tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:181:8: error: missing braces around initializer [-Werror=missing-braces]
  union bpf_iter_link_info linfo = {0};
        ^
tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:181:8: error: (near initialization for 'linfo.map') [-Werror=missing-braces]
tools/testing/selftests/bpf/prog_tests/sockmap_basic.c: At top level:

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 4c4224e3e10a..85f73261fab0 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -198,7 +198,7 @@ static void test_sockmap_copy(enum bpf_map_type map_type)
 {
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
 	int err, len, src_fd, iter_fd, duration = 0;
-	union bpf_iter_link_info linfo = {0};
+	union bpf_iter_link_info linfo = {};
 	__u32 i, num_sockets, num_elems;
 	struct bpf_iter_sockmap *skel;
 	__s64 *sock_fd = NULL;
-- 
2.28.0.709.gb0816b6eb0-goog

