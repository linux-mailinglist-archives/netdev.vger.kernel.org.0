Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585D73D484E
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 17:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhGXOlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 10:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGXOlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 10:41:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBFBC061575;
        Sat, 24 Jul 2021 08:21:38 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so13313130pjb.0;
        Sat, 24 Jul 2021 08:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r1ag42xDJLaVY9xMBOItoSUvNhhk/9cVUCkJzLTzDvQ=;
        b=mM/h6Y0Xp2tak1Q0gjkuodOOFbWbpGPQl2csWweB83zYfGaDkW4/6KwIbZx1EJYeHO
         Uzq/hBGAC0AWmVgmr2gz7r5ZdWPm7vNyOKYRabGFIz/NBj2Gc9ipt/Jr5jbHiNsGjW0S
         S8uGOxVy1BIcBhWDg7D2avedI/8ZW6T7mjr0qeUych064RLL8aCsZMjLTIvB1eNgaes/
         Rcn2GDDRbSWc6swNKRMErxQ5rFVOPhoqVYSgdtn+cKbTMa8gFN7joyDJ1w+cquyRPsZ7
         96QwyoWK3NPc8ugYnZ48U1SmNPAv6P5Rj+1tgP8AGUWOs8rRw/B650bxuclkH2nMoWmD
         X8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r1ag42xDJLaVY9xMBOItoSUvNhhk/9cVUCkJzLTzDvQ=;
        b=Frqot/f3Ja+rg3s/iuumiljs4fsBrwCW3CvdqCQhM1z/+dUyOBX307bN1A2BxGEq/I
         0nIdf+qk7nrsEG134ACgux9ZLT7eR8pHaANz7ATTW/5vBM9Sf5DTzZMytJY2Tz2DG+qy
         Ylw+gJU9S1vQXhtSkThCE6XqWTudc9JlnzJKpBjx8mXMWN4JoXn5DqyiNnjTrQ/KLrvC
         bnA8sOII3Xx2ptyUgHp9cMWLApcCPuLDOYNZt4rhNwBsTK+a70ilHZVukIEd2eqgis0U
         oRA+Sr0h0dab6+ASSIZYip4HOEWEfziZz25JXn4ajv2oLcjivhU9VXFAcz4dU0qzD2Hh
         D9yA==
X-Gm-Message-State: AOAM532KrlGkocIdOcVswDnoI8xCEp0YZoZPsyQwAPh1zTkocB+edZPI
        zwAQwdQiB6iI7jL44omES9M=
X-Google-Smtp-Source: ABdhPJzc3WyvYVYK072FmsaT7J14rCP2CimF9HW8rLoggrzLrngQcfYDmXLWOP/6jm4c7srG//tgzg==
X-Received: by 2002:a63:dd46:: with SMTP id g6mr9953964pgj.347.1627140097789;
        Sat, 24 Jul 2021 08:21:37 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id w22sm36682527pfu.50.2021.07.24.08.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 08:21:37 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [bpf-next 1/2] samples: bpf: Fix tracex7 error raised on the missing argument
Date:   Sat, 24 Jul 2021 15:21:23 +0000
Message-Id: <20210724152124.9762-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current behavior of 'tracex7' doesn't consist with other bpf samples
tracex{1..6}. Other samples do not require any argument to run with, but
tracex7 should be run with btrfs device argument. (it should be executed
with test_override_return.sh)

Currently, tracex7 doesn't have any description about how to run this
program and raises an unexpected error. And this result might be
confusing since users might not have a hunch about how to run this
program.

    // Current behavior
    # ./tracex7
    sh: 1: Syntax error: word unexpected (expecting ")")
    // Fixed behavior
    # ./tracex7
    ERROR: Run with the btrfs device argument!

In order to fix this error, this commit adds logic to report a message
and exit when running this program with a missing argument.

Additionally in test_override_return.sh, there is a problem with
multiple directory(tmpmnt) creation. So in this commit adds a line with
removing the directory with every execution.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 samples/bpf/test_override_return.sh | 1 +
 samples/bpf/tracex7_user.c          | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/samples/bpf/test_override_return.sh b/samples/bpf/test_override_return.sh
index e68b9ee6814b..6480b55502c7 100755
--- a/samples/bpf/test_override_return.sh
+++ b/samples/bpf/test_override_return.sh
@@ -1,5 +1,6 @@
 #!/bin/bash
 
+rm -rf tmpmnt
 rm -f testfile.img
 dd if=/dev/zero of=testfile.img bs=1M seek=1000 count=1
 DEVICE=$(losetup --show -f testfile.img)
diff --git a/samples/bpf/tracex7_user.c b/samples/bpf/tracex7_user.c
index fdcd6580dd73..8be7ce18d3ba 100644
--- a/samples/bpf/tracex7_user.c
+++ b/samples/bpf/tracex7_user.c
@@ -14,6 +14,11 @@ int main(int argc, char **argv)
 	int ret = 0;
 	FILE *f;
 
+	if (!argv[1]) {
+		fprintf(stderr, "ERROR: Run with the btrfs device argument!\n");
+		return 0;
+	}
+
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
-- 
2.27.0

