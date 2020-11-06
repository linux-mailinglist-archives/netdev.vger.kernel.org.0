Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199982A9B9A
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgKFSH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgKFSH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 13:07:56 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDEBC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 10:07:56 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id v11so1000440qtq.12
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 10:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sUjFvOcmo3vnT5MuIYSwL/iKpWqDbH4Lnt0nTaTM+WU=;
        b=V/7gG1Bvww/9UhlDhpSe2OP6zugC/cqv4BGTm3eOihfImVQn3/QV0BJZ1jxXne7/ai
         2lzaBYtcrYRygAbb2mEu8+30yrs2rsbfPXSQqFvykaK6eRh2a+/VahdkaZhjN2O21HAm
         RteHMT0gg1PINzuce3URVVNOSkvI/MLKOB/1iWyBaOZvZniIpIFAmnyVzpT3jOLhwTen
         71jcjk3DTzjc3uYDnymSSDBCIL2yog1BH5T0amLzyQ4VrTpc/gxdB7y4LX8vgiG39n3V
         4vjQLT1jVkdnBtYpb28P39LQC1r/yCKIwZ46M4WfpdPdEd7xrvn2zNv0wI/d17eC56Rv
         Kkvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sUjFvOcmo3vnT5MuIYSwL/iKpWqDbH4Lnt0nTaTM+WU=;
        b=B18ffSkvRD3ChCBMN8pGh7khwNentz1OQ0LG8eJ6xDXIAO8+Jwy/FgAvRJemnw3i4S
         DXqRFeRGMpOpN/di/Itb0+Z/23CO2xQTqb2Ybx/x26RzDFePC2T3EDFWwBApHwoNN8y5
         ZMRVh+08Zgp28r7MAyj8GqHGCKZ6ked3YWhoFmDr0G5UJq4no9xQylzDhyhbNlRf8wLP
         UzDlv0t8oH1Kvyu328byxKAF0742GOhD9sIXKJjSUo4RttZoa6jRoBt1SkpenpX8C9p5
         wBkrC3+1DJ5rkevYAGaB6bjnQ/gRo5UtYGCrsiAVsovDg3+ExX3F04ABZK44u98w+VxM
         frpQ==
X-Gm-Message-State: AOAM533KSJe8xhjtbAQYXAxWPz7SOa9nps3OkxWTexVdCjYFgotnXQc4
        Og7NYL6XZlpIjxmV4GCGOY3iaE1Gr+g=
X-Google-Smtp-Source: ABdhPJx6uX3DX5OnADvLCe7Msgkr52k0CcGqZLM5OuNzmr5liw+radldYyh0rNPlcG1swODkDYuxIg==
X-Received: by 2002:ac8:6b8d:: with SMTP id z13mr2664327qts.41.1604686075305;
        Fri, 06 Nov 2020 10:07:55 -0800 (PST)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id r133sm1018660qke.23.2020.11.06.10.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 10:07:54 -0800 (PST)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next 2/2] selftests/net: test max_num_members, fanout_args in psock_fanout
Date:   Fri,  6 Nov 2020 13:07:41 -0500
Message-Id: <20201106180741.2839668-3-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
In-Reply-To: <20201106180741.2839668-1-tannerlove.kernel@gmail.com>
References: <20201106180741.2839668-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Add an additional control test that verifies:
-specifying two different max_num_members values fails
-specifying max_num_members > PACKET_FANOUT_MAX fails

In datapath tests, set max_num_members to PACKET_FANOUT_MAX.

Signed-off-by: Tanner Love <tannerlove@google.com>
---
 tools/testing/selftests/net/psock_fanout.c | 72 +++++++++++++++++++++-
 1 file changed, 69 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/psock_fanout.c b/tools/testing/selftests/net/psock_fanout.c
index 2c522f7a0aec..db4521335722 100644
--- a/tools/testing/selftests/net/psock_fanout.c
+++ b/tools/testing/selftests/net/psock_fanout.c
@@ -56,12 +56,15 @@
 
 #define RING_NUM_FRAMES			20
 
+static uint32_t cfg_max_num_members;
+
 /* Open a socket in a given fanout mode.
  * @return -1 if mode is bad, a valid socket otherwise */
 static int sock_fanout_open(uint16_t typeflags, uint16_t group_id)
 {
 	struct sockaddr_ll addr = {0};
-	int fd, val;
+	struct fanout_args args;
+	int fd, val, err;
 
 	fd = socket(PF_PACKET, SOCK_RAW, 0);
 	if (fd < 0) {
@@ -83,8 +86,18 @@ static int sock_fanout_open(uint16_t typeflags, uint16_t group_id)
 		exit(1);
 	}
 
-	val = (((int) typeflags) << 16) | group_id;
-	if (setsockopt(fd, SOL_PACKET, PACKET_FANOUT, &val, sizeof(val))) {
+	if (cfg_max_num_members) {
+		args.id = group_id;
+		args.type_flags = typeflags;
+		args.max_num_members = cfg_max_num_members;
+		err = setsockopt(fd, SOL_PACKET, PACKET_FANOUT, &args,
+				 sizeof(args));
+	} else {
+		val = (((int) typeflags) << 16) | group_id;
+		err = setsockopt(fd, SOL_PACKET, PACKET_FANOUT, &val,
+				 sizeof(val));
+	}
+	if (err) {
 		if (close(fd)) {
 			perror("close packet");
 			exit(1);
@@ -286,6 +299,56 @@ static void test_control_group(void)
 	}
 }
 
+/* Test illegal max_num_members values */
+static void test_control_group_max_num_members(void)
+{
+	int fds[3];
+
+	fprintf(stderr, "test: control multiple sockets, max_num_members\n");
+
+	/* expected failure on greater than PACKET_FANOUT_MAX */
+	cfg_max_num_members = (1 << 16) + 1;
+	if (sock_fanout_open(PACKET_FANOUT_HASH, 0) != -1) {
+		fprintf(stderr, "ERROR: max_num_members > PACKET_FANOUT_MAX\n");
+		exit(1);
+	}
+
+	cfg_max_num_members = 256;
+	fds[0] = sock_fanout_open(PACKET_FANOUT_HASH, 0);
+	if (fds[0] == -1) {
+		fprintf(stderr, "ERROR: failed open\n");
+		exit(1);
+	}
+
+	/* expected failure on joining group with different max_num_members */
+	cfg_max_num_members = 257;
+	if (sock_fanout_open(PACKET_FANOUT_HASH, 0) != -1) {
+		fprintf(stderr, "ERROR: set different max_num_members\n");
+		exit(1);
+	}
+
+	/* success on joining group with same max_num_members */
+	cfg_max_num_members = 256;
+	fds[1] = sock_fanout_open(PACKET_FANOUT_HASH, 0);
+	if (fds[1] == -1) {
+		fprintf(stderr, "ERROR: failed to join group\n");
+		exit(1);
+	}
+
+	/* success on joining group with max_num_members unspecified */
+	cfg_max_num_members = 0;
+	fds[2] = sock_fanout_open(PACKET_FANOUT_HASH, 0);
+	if (fds[2] == -1) {
+		fprintf(stderr, "ERROR: failed to join group\n");
+		exit(1);
+	}
+
+	if (close(fds[2]) || close(fds[1]) || close(fds[0])) {
+		fprintf(stderr, "ERROR: closing sockets\n");
+		exit(1);
+	}
+}
+
 /* Test creating a unique fanout group ids */
 static void test_unique_fanout_group_ids(void)
 {
@@ -426,8 +489,11 @@ int main(int argc, char **argv)
 
 	test_control_single();
 	test_control_group();
+	test_control_group_max_num_members();
 	test_unique_fanout_group_ids();
 
+	/* PACKET_FANOUT_MAX */
+	cfg_max_num_members = 1 << 16;
 	/* find a set of ports that do not collide onto the same socket */
 	ret = test_datapath(PACKET_FANOUT_HASH, port_off,
 			    expect_hash[0], expect_hash[1]);
-- 
2.29.1.341.ge80a0c044ae-goog

