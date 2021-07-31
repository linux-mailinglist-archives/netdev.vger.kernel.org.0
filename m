Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035833DC227
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbhGaA4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbhGaA4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 20:56:50 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD54C06175F;
        Fri, 30 Jul 2021 17:56:44 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id z3-20020a4a98430000b029025f4693434bso2920237ooi.3;
        Fri, 30 Jul 2021 17:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4I3sfRH5c1qD7pcvAmdOAVZq247JJaOlPdDXsBkGJVo=;
        b=ePI09i2bpo2YPJWdPQb/QyYlqRI+5DeVdB9MuwfnpYuxP+/QNVeIB6FaakuodQZTkc
         CBbIu6gfXy6JnZ3A8aZBA3RL9qkltsvuc5dKP8EH6l8GrDR84+5wECbzjBFdSuiZKKUH
         ELA4CwtHt3LJ1LR3PSp8hMN05vDQZJuM87NTKzoEijtq9D5VKCUYe/XQat4quuq8ad8I
         dLZOgxTCb6VaFIYSSmCC5iDsZQxxwoDzvFnsVDAoVCK7Sc5J6701BDRw7AFiovdF3IJb
         b75pYp4o2WBzvCJugtInU8UZ++fRjKV0j3NazSiatL4nXZck6KBSF0TEISQsKsSXEZsx
         pYew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4I3sfRH5c1qD7pcvAmdOAVZq247JJaOlPdDXsBkGJVo=;
        b=TAouX7ng3SldTzz+EkgXHZsWljKWGDhyC4ntzyOq83UWARyt1pH+H8iC9C9BM8TRMY
         cXB8A3qIDnZnkRJm7aBAlaTF7CxhKoIMRerl/xNUvRy0AUZRWAv1uaKK3tEXYhE8Q11+
         ZkbuGp0csAYLBfeM10naCQtDIbZ7Im3mpEQfDAvPP8MvoU5/TNA+RfJKHd09Kn/BwRaa
         D3EqCP70Lf2RbgDgvWcFUjnlxeIJYlIcYbisqP0r4NolmGwZcPDHWa8287PWOb36qx0B
         nSKmaU02hIpV3d7+18sk51qD/ZrSi4nbxn1j06x8SNz4WHaXZ36EfCi3cO3LnSUcKimG
         zunQ==
X-Gm-Message-State: AOAM532j2v4Qvd1MhmRVrPO7DkdYfzXKk+zf2kgrFCwdeqwTWZgkc4pD
        funSjAMTdXQRSxMY31sAtb6tDGbpsIf24A==
X-Google-Smtp-Source: ABdhPJxm5TUERunhOkcXMvDJv8MwzDzJ6uuPZ3avpd0l2fWXxFE17D9tHU35lS0+orEuCdoA1CvkCQ==
X-Received: by 2002:a4a:bf11:: with SMTP id r17mr3645698oop.29.1627693003731;
        Fri, 30 Jul 2021 17:56:43 -0700 (PDT)
Received: from localhost.localdomain (ip98-171-33-13.ph.ph.cox.net. [98.171.33.13])
        by smtp.gmail.com with ESMTPSA id c26sm592804otu.38.2021.07.30.17.56.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Jul 2021 17:56:43 -0700 (PDT)
From:   Matthew Cover <werekraken@gmail.com>
X-Google-Original-From: Matthew Cover <matthew.cover@stackpath.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] samples/bpf: xdp_redirect_cpu: Add mprog-disable to optstring.
Date:   Fri, 30 Jul 2021 17:56:32 -0700
Message-Id: <20210731005632.13228-1-matthew.cover@stackpath.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program
on cpumap") added the following option, but missed adding it to optstring:
- mprog-disable: disable loading XDP program on cpumap entries

Add the missing option character.

Fixes: ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program on cpumap")
Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
---
 samples/bpf/xdp_redirect_cpu_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index d3ecdc1..9e225c9 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -841,7 +841,7 @@ int main(int argc, char **argv)
 	memset(cpu, 0, n_cpus * sizeof(int));
 
 	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:",
+	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:n",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
-- 
1.8.3.1

