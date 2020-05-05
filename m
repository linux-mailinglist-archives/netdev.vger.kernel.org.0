Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33751C6269
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgEEUwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727785AbgEEUwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:52:47 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3760C061A0F;
        Tue,  5 May 2020 13:52:46 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x2so2392493ilp.13;
        Tue, 05 May 2020 13:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=S0ZluIHLLoY8QlxUnFIV401QRHlifhcIkCObpC9H3pk=;
        b=bm0TIsI4EalU/2zSSktvniDX2t8EPTEwDCIrj3iBijT9/vDgUGiNUX7MwkRlLh4TLi
         cuVy7EUOG8VYtB2GCYf/FwLTmg2v5jhV0YlofcwXHA5cjWNcawNk2hdnzvYa/BELl5V2
         sGWhfyvdRMaD+LH45Tli5j8KlHRdR70E4u17MRjAw02iEMl+7Ifxj6bFuvIyPKHXZwlp
         JPOJZq2C49aAhSEb16243zS1HX/v2dg0KrxeBm5qMhQZ4ang76XwAwnvUufb+k1tNf6y
         /VLx1zjHY6ZDmjGbbN/1+T1TPpQodQIEJGrJ+Lv5YyGGCLwNkM+COrIkm2JYXFBh2QBF
         YJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=S0ZluIHLLoY8QlxUnFIV401QRHlifhcIkCObpC9H3pk=;
        b=gjqfEo6TUE5hugwMlAiOGWNOKWnH1JF3myYqLaM4NvCTB8bE+iStkXpOZ9lLqI3EPX
         QzeVyVAQ61inCa+LVZPi2R+F8IyePTx6v0w4MZuxTkUKVi9TekgiQZ6QH/7LcH2pE+LD
         sSrxQ8hYc96tt+AsVIJ8c9wzao2Epw/hjKtvONHcwu1y9wOTcfCk5RG7M0McHSTdJ3tT
         HWtcw74qF04s3L64lskBBDqCpZTyCWQTPTzmWeGPesQozQQqlZP43E6wXhpUfVPJR9vO
         +ARJtf4RCyzMAs4bkefdg2mv/GNs3vtNCUUuZpo8KxQ16UlppIsxKUWKinA4d7tzWfeX
         BEEQ==
X-Gm-Message-State: AGi0PubH01w6fVVspqHpb2SdTpEQxYF5G3ThgeJsLUqTv3vuMhbCl6xS
        1K6dDuz1KygoJIlNkv5CIAo=
X-Google-Smtp-Source: APiQypLzMhc9BGwi1Ms9Ao5Dh6Y/VzehUi+WuFWtI8uTgHl0+VChvlqJhJjU+UWyPAsTI6rRm0e2Wg==
X-Received: by 2002:a92:ba99:: with SMTP id t25mr5788997ill.84.1588711966268;
        Tue, 05 May 2020 13:52:46 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b77sm2039529iof.29.2020.05.05.13.52.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 13:52:45 -0700 (PDT)
Subject: [bpf-next PATCH 09/10] bpf: selftests, add blacklist to test_sockmap
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Tue, 05 May 2020 13:52:32 -0700
Message-ID: <158871195181.7537.13698754880642910564.stgit@john-Precision-5820-Tower>
In-Reply-To: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
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

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   33 ++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 5e0ab7e..154bcdb 100644
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

