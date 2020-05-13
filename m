Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8A01D1EBC
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390424AbgEMTOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387469AbgEMTOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:14:00 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311D3C061A0C;
        Wed, 13 May 2020 12:14:00 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id r2so819498ilo.6;
        Wed, 13 May 2020 12:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=YR/5vRqoB27a+EJRN+27+tdmNzZrP9YLEj7WLkiIRsk=;
        b=Zzj/rsdgQa3WCjymsjeFUiTDzyx1ZacdwUCBNQvayNvv9yM19XBTQxOvyh70yanoHt
         sFNpzz3Nos/J5lI+UlSO/HtsK//kdcRc7AMQMy5WGbqPFwM6UTP+ZLFkF2c/uepttgJy
         rehVh2biEQZh5s9nu5YckLRKeI2NjTf5xOKwOdC86iIAi+t9nmMdRv35q7CQBXOcMRdv
         i4U8s4JHNFbt3cG0jKH2hRcYT91R/SmXJql1RUYOxFcyXxU4I6yGtcyAMJefHPChhdrC
         VRSZO6LZzI14f/p0NCfiO0Yl72/rF6Vfi2ozo7hlMP6mQpJWKsNsJtwzSJ8svsJlx4uw
         1zrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YR/5vRqoB27a+EJRN+27+tdmNzZrP9YLEj7WLkiIRsk=;
        b=bjkJiQ5lItr97qsOlqQRmItVkjePIHBtET0f9iYm9SGjfxw9TmaHuO+h4IXwJISP/u
         Q97UGMVFXaPPaz4S+DxRKZtswinYUHXsHL6tGmGlXEdUgGs1ryodRg7rj/bd4tIQdDn1
         cZ3c7mCq8E116L1GeCtsgD1iAgE5wpuXGmGch4zLyarEiUqXSymf/qq3088Dqq1nnS/W
         Ob7skM+8v0Y6toDJ89vJpy3CdICN2s1ra+v9Wn6llzEDadU2FBGKWElcZApXADPjH2ub
         tRP2J4ie4YWP4Aq+VV/xcKJMHJq3NJWvHiHmfFBxVBlUK2/WBEkHx220v1VEGWr2WijW
         EkNg==
X-Gm-Message-State: AOAM533/MCtVc6zG4LASf9fzp2h//GyMdrGXUo5iHCyCfJ3oXAW8OIGd
        mg+3zuUXeo3ioXU6oYeuACo=
X-Google-Smtp-Source: ABdhPJykFmTkvhc2YKagaJVTXKnfryLijf5N3iY6rAYcOx/1uR+Ll3WTgnmflTg9/sDaamVlGG6pLQ==
X-Received: by 2002:a92:a053:: with SMTP id b19mr890350ilm.156.1589397239628;
        Wed, 13 May 2020 12:13:59 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l13sm152495ilo.46.2020.05.13.12.13.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:13:59 -0700 (PDT)
Subject: [bpf-next PATCH v2 05/12] bpf: selftests,
 sockmap test prog run without setting cgroup
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Wed, 13 May 2020 12:13:46 -0700
Message-ID: <158939722675.15176.6294210959489131688.stgit@john-Precision-5820-Tower>
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

Running test_sockmap with arguments to specify a test pattern requires
including a cgroup argument. Instead of requiring this if the option is
not provided create one

This is not used by selftest runs but I use it when I want to test a
specific test. Most useful when developing new code and/or tests.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 6bdacc4..5ef71fe 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1725,6 +1725,7 @@ int main(int argc, char **argv)
 	int opt, longindex, err, cg_fd = 0;
 	char *bpf_file = BPF_SOCKMAP_FILENAME;
 	int test = PING_PONG;
+	bool cg_created = 0;
 
 	if (argc < 2)
 		return test_suite(-1);
@@ -1805,13 +1806,25 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (argc <= 3 && cg_fd)
-		return test_suite(cg_fd);
-
 	if (!cg_fd) {
-		fprintf(stderr, "%s requires cgroup option: --cgroup <path>\n",
-			argv[0]);
-		return -1;
+		if (setup_cgroup_environment()) {
+			fprintf(stderr, "ERROR: cgroup env failed\n");
+			return -EINVAL;
+		}
+
+		cg_fd = create_and_get_cgroup(CG_PATH);
+		if (cg_fd < 0) {
+			fprintf(stderr,
+				"ERROR: (%i) open cg path failed: %s\n",
+				cg_fd, strerror(errno));
+			return cg_fd;
+		}
+
+		if (join_cgroup(CG_PATH)) {
+			fprintf(stderr, "ERROR: failed to join cgroup\n");
+			return -EINVAL;
+		}
+		cg_created = 1;
 	}
 
 	err = populate_progs(bpf_file);
@@ -1830,6 +1843,9 @@ int main(int argc, char **argv)
 	options.rate = rate;
 
 	err = run_options(&options, cg_fd, test);
+
+	if (cg_created)
+		cleanup_cgroup_environment();
 	close(cg_fd);
 	return err;
 }

