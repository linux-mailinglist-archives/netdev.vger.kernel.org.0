Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65D81D1ED5
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390614AbgEMTQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390552AbgEMTP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:15:57 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657EDC061A0C;
        Wed, 13 May 2020 12:15:57 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id f4so183157iov.11;
        Wed, 13 May 2020 12:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=m6ZTIteI+oUC2tBq4SKg6uG6Ssn9HienpBTovGPLIfo=;
        b=AaSSBpj2WcT1+ifNz4QUEsvrYKG91k4lpMOSdRhReWsvbn6hk2mdzNOPlNCUKRWCjU
         v7luLs0hGQo62+n6I0gBjTLcMIgjy0C42Vlh+qWawldeixnfdhnn/TrOXEMu73BNANtx
         NwMTAsIxGKnlXiuAOt4DdlRCmdztBNFJS3y0hLO9E89vKHCs8jx/FFcMrFO1wV4UI023
         IFc0UMEc/KuuXmnC1H6susbich4a5XSNxMYDp2o5U7iqD7pSNTt6eOTcDY9N+0+NG9j2
         Wwr1eF0MqaGQTMiKuSsk5DFP9f7Vk61BDEBtm3PjuITCNWaQIKB9K1looweM0FQwuuO+
         X2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=m6ZTIteI+oUC2tBq4SKg6uG6Ssn9HienpBTovGPLIfo=;
        b=kxYa0k6NRExnTBOEe2BE3ktL0m5oiT/48k8fsALDFiBJaY6MsQhbIMnJL+0X1NcfMH
         hZrUd/aZaIRgYzIjRQsfUTZGhWhqVbRv3RMJhWBjg4OS30DgScg6/TAbvmcF+NiRheUQ
         NvezSe/HWIstsSDImensuk0eK1SGmiGEa8JP6DHsdGzT1tUq525/DkJ55w2p+UD6lnc6
         o22/ApJrfsPhhTkNe6x4yvdfmlN30gYuykC8YOnomzLkcTS8kKQKOBXXnuyhE0CZPw+h
         9jXnJFwnide2TEZejtTgFUVKWB4/4rdOgE15lwO2pur32XmypZmvCViBTcVUJGSHaP23
         NKwQ==
X-Gm-Message-State: AOAM53088QtbyNjbvNvB7qUpxChvubl3pCDsV1A9QlOawpd6pjVSXIzc
        WaZJVh+ytSqvXX/SnMiSfSc=
X-Google-Smtp-Source: ABdhPJx0NWQpbQid72iKBWP49suwP2zN2JC1bvHayBc/VNMwW22zD87mtzpGFsMrRiECszbwSDTdrA==
X-Received: by 2002:a6b:7009:: with SMTP id l9mr700329ioc.158.1589397356863;
        Wed, 13 May 2020 12:15:56 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c84sm167159ila.18.2020.05.13.12.15.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:15:56 -0700 (PDT)
Subject: [bpf-next PATCH v2 11/12] bpf: selftests,
 add blacklist to test_sockmap
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Wed, 13 May 2020 12:15:43 -0700
Message-ID: <158939734350.15176.6643981099665208826.stgit@john-Precision-5820-Tower>
In-Reply-To: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
References: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a blacklist to test_sockmap. For example, now we can run
all apply and cork tests except those with timeouts by doing,

 $ ./test_sockmap --whitelist "apply,cork" --blacklist "hang"

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   33 ++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 1b98e92..2ed2db6 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -108,6 +108,7 @@ static const struct option long_options[] = {
 	{"ktls", no_argument,			&ktls, 1 },
 	{"peek", no_argument,			&peek_flag, 1 },
 	{"whitelist", required_argument,	NULL, 'n' },
+	{"blacklist", required_argument,	NULL, 'b' },
 	{0, 0, NULL, 0 }
 };
 
@@ -389,6 +390,7 @@ struct sockmap_options {
 	int rate;
 	char *map;
 	char *whitelist;
+	char *blacklist;
 };
 
 static int msg_loop_sendpage(int fd, int iov_length, int cnt,
@@ -1641,6 +1643,24 @@ static int check_whitelist(struct _test *t, struct sockmap_options *opt)
 	return -EINVAL;
 }
 
+static int check_blacklist(struct _test *t, struct sockmap_options *opt)
+{
+	char *entry, *ptr;
+
+	if (!opt->blacklist)
+		return -EINVAL;
+	ptr = strdup(opt->blacklist);
+	if (!ptr)
+		return -ENOMEM;
+	entry = strtok(ptr, ",");
+	while (entry) {
+		if (strstr(opt->map, entry) != 0 || strstr(t->title, entry) != 0)
+			return 0;
+		entry = strtok(NULL, ",");
+	}
+	return -EINVAL;
+}
+
 static int __test_selftests(int cg_fd, struct sockmap_options *opt)
 {
 	int i, err;
@@ -1655,7 +1675,9 @@ static int __test_selftests(int cg_fd, struct sockmap_options *opt)
 	for (i = 0; i < sizeof(test)/sizeof(struct _test); i++) {
 		struct _test t = test[i];
 
-		if (check_whitelist(&t, opt) < 0)
+		if (check_whitelist(&t, opt) != 0)
+			continue;
+		if (check_blacklist(&t, opt) == 0)
 			continue;
 
 		test_start_subtest(t.title, opt->map);
@@ -1696,7 +1718,7 @@ int main(int argc, char **argv)
 	int test = SELFTESTS;
 	bool cg_created = 0;
 
-	while ((opt = getopt_long(argc, argv, ":dhv:c:r:i:l:t:p:q:n:",
+	while ((opt = getopt_long(argc, argv, ":dhv:c:r:i:l:t:p:q:n:b:",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 's':
@@ -1769,6 +1791,11 @@ int main(int argc, char **argv)
 			options.whitelist = strdup(optarg);
 			if (!options.whitelist)
 				return -ENOMEM;
+			break;
+		case 'b':
+			options.blacklist = strdup(optarg);
+			if (!options.blacklist)
+				return -ENOMEM;
 		case 0:
 			break;
 		case 'h':
@@ -1823,6 +1850,8 @@ int main(int argc, char **argv)
 out:
 	if (options.whitelist)
 		free(options.whitelist);
+	if (options.blacklist)
+		free(options.blacklist);
 	if (cg_created)
 		cleanup_cgroup_environment();
 	close(cg_fd);

