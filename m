Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EE11C6258
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgEEUus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728660AbgEEUus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:50:48 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1C3C061A0F;
        Tue,  5 May 2020 13:50:48 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id r2so2563373ilo.6;
        Tue, 05 May 2020 13:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=hwNuzZYtyem8g+87m1vwNg4yUozJWBItc/GIItu4LnE=;
        b=AmNU3bp1Qd49S+oePW0zNOV6/xaDq4FXXhr6HHEJ1di2fxWb7SghoJNqUhtED5xaZJ
         ht2HC9bfJdE3UT8TtOi+NtgKDDoFFvtuSZi6lYzY+nmXp/FB0VDHbmkSgORLopnnLg7i
         Iq1haAqcaN7+txVojdluandbRn2KEw7IxwtMMUdapkDQzrsief316p/1k979BbxTixxC
         IYqlwYRnqsa0Ez+uQwHRQHB1VguJDByMWbJrjlaOFilhcQq7FGKCqB33yC76MUwwhKKx
         pc5uWE2n6PtBWPI1ifYtkR+sFQsIPncRqhL9C+5oVdT3GnS2p0Hmo6QmV+dhYJi0P0qi
         RjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hwNuzZYtyem8g+87m1vwNg4yUozJWBItc/GIItu4LnE=;
        b=t1NGwOM9YMcHqnNS8kKnZbh6ngOVAsog4ei2mAiKN0MH5VIynTINvPvW+Ei9zkfavW
         R2/ahrSHW0/H86JC8djNvdlF7bVVdzQbkEE70U7L4s5jxoSE5UVB4t9mJMEFgxfcwKOu
         SFo712jK0KLD9gkcZNqccD1Fuh1RzGFm6T1Bv5+UO9zgKpZdxfX8fmdRz27VikVYDmzp
         vJG3S/6RK0sIbiHSpf/aRnmZ25vccVKnBZH8NBknO2fZn/VvKhzwGrSPm/jjKP0JFC5f
         C456JF+8cTBMW9IWdSRkerr1NDJjskJcC1s8gJKm/ikoiG0omvjUG7koLeyFSnOaUSne
         v8fw==
X-Gm-Message-State: AGi0PuYu3pdnIivkfCUX/rY0GmE6xHZQBlLRQWKpHSS0X/wy3im2DE1a
        D858Q0Y5hc3sHgAXeOY91fCEl/47PW0=
X-Google-Smtp-Source: APiQypJ2NwObm/gy4aMYZsABtoDk0qLAb/yz8b2M7QFkO5/c7+HsCmWLmkCrcOuST/W8vtJO/u6ltQ==
X-Received: by 2002:a92:5a54:: with SMTP id o81mr556282ilb.128.1588711847555;
        Tue, 05 May 2020 13:50:47 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v17sm2376771ill.5.2020.05.05.13.50.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 13:50:46 -0700 (PDT)
Subject: [bpf-next PATCH 03/10] bpf: selftests,
 sockmap test prog run without setting cgroup
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Tue, 05 May 2020 13:50:35 -0700
Message-ID: <158871183500.7537.4803419328947579658.stgit@john-Precision-5820-Tower>
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

Running test_sockmap with arguments to specify a test pattern requires
including a cgroup argument. Instead of requiring this if the option is
not provided create one

This is not used by selftest runs but I use it when I want to test a
specific test. Most useful when developing new code and/or tests.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 6bdacc4..a0884f8 100644
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
+				cg_fd, optarg);
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

