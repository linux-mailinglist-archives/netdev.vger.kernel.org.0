Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75E8CE904
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbfJGQVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:21:12 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:46958 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbfJGQVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 12:21:11 -0400
Received: by mail-pg1-f202.google.com with SMTP id f11so10462252pgn.13
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 09:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pFnmwsah0Tqm0ZFor0HGU7ultYypJGX8sasdZScFGlE=;
        b=Gu3PXIhNQzwfMK6sJW67/+E7pdy0OpbpcJEkgLsC12iHawxTITtnKA2Db/xV0sfNwp
         99enlXEswB7xJvOVjxGUyi/MVP9E341EFDuTI4qR1V+jL/4114gjKb71xanfxnyInryL
         kiXOqzk1DDA2KI+OfHq62scPYL2AL1NEtBww53YJ5VUIagXuER19zmeB7qc1CMCD5Ar/
         9jgGbt4XrX+qqSW0rqc7fivsgNMxRw5hayWoM/cjBhbiF5gK9C6BPrJS3Oe3MW+4i0LT
         yAnWTews4gc9KokAjM9Xd/Hksftgd98QEclClFylDInX+fWShcukwXEk6vR9aAqotUXN
         UB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pFnmwsah0Tqm0ZFor0HGU7ultYypJGX8sasdZScFGlE=;
        b=DmpQVgDvMtc0GEEecrksdBUAePw7Awblcm15zhGdkchH3RoOxM1sYMEuxyMl3S3tJ4
         vIiW953sGNDZlMToORVEeqtY6n6wLYOsCho43UhhiU2SDMQv8iUEEP3xPR4HADSQ3PKQ
         uCI76kM9opzewGbyNE0WRsnteqCuTFGhUDGpVIBBhGBVjcSm7CWgMBFVM+kCBDxYYkE2
         dQFk9kx7oP8g6Tpia9ALtTFX2vtB21h3JzUcadR66nrNIFt1TPVn4sUWff/olYHCjTZz
         hnk/r2Iz8rZAvUxzee774KakgPWvcfkBU80QzC/sNVajGgiptr/g7/vFksu9u82JbObQ
         RZcA==
X-Gm-Message-State: APjAAAVkD3FHN+uyrGZp9Ceqe5C6faaQhFaqLPiJ/qr7WUPokb4BqmlD
        twhV03ISAzbUAtgDXS3z0U7/TumnYsCuOv18ersFoWbx+fUnSezZ3tQMHIfvCLO0Ec5FTmzTA8O
        H7WmclLSrXmWM+Wq42x8jXB42f67Uw4RJuJZV/pA0+Uo16AX4IcJu4w==
X-Google-Smtp-Source: APXvYqwP0xh0SLlLotKZodHuCvC/HE0FfJO0egWt7J+F24MroFgUb5zHV1izBrUDEEa54w4j4swaFw0=
X-Received: by 2002:a63:d846:: with SMTP id k6mr31262942pgj.378.1570465270548;
 Mon, 07 Oct 2019 09:21:10 -0700 (PDT)
Date:   Mon,  7 Oct 2019 09:21:03 -0700
In-Reply-To: <20191007162103.39395-1-sdf@google.com>
Message-Id: <20191007162103.39395-3-sdf@google.com>
Mime-Version: 1.0
References: <20191007162103.39395-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH bpf-next v3 2/2] selftests/bpf: add test for BPF flow
 dissector in the root namespace
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure non-root namespaces get an error if root flow dissector is
attached.

Cc: Petar Penkov <ppenkov@google.com>
Acked-by: Song Liu <songliubraving@fb.com>

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/test_flow_dissector.sh      | 48 ++++++++++++++++---
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_flow_dissector.sh b/tools/testing/selftests/bpf/test_flow_dissector.sh
index d23d4da66b83..2c3a25d64faf 100755
--- a/tools/testing/selftests/bpf/test_flow_dissector.sh
+++ b/tools/testing/selftests/bpf/test_flow_dissector.sh
@@ -18,19 +18,55 @@ fi
 # this is the case and run it with in_netns.sh if it is being run in the root
 # namespace.
 if [[ -z $(ip netns identify $$) ]]; then
+	err=0
+	if bpftool="$(which bpftool)"; then
+		echo "Testing global flow dissector..."
+
+		$bpftool prog loadall ./bpf_flow.o /sys/fs/bpf/flow \
+			type flow_dissector
+
+		if ! unshare --net $bpftool prog attach pinned \
+			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			echo "Unexpected unsuccessful attach in namespace" >&2
+			err=1
+		fi
+
+		$bpftool prog attach pinned /sys/fs/bpf/flow/flow_dissector \
+			flow_dissector
+
+		if unshare --net $bpftool prog attach pinned \
+			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			echo "Unexpected successful attach in namespace" >&2
+			err=1
+		fi
+
+		if ! $bpftool prog detach pinned \
+			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			echo "Failed to detach flow dissector" >&2
+			err=1
+		fi
+
+		rm -rf /sys/fs/bpf/flow
+	else
+		echo "Skipping root flow dissector test, bpftool not found" >&2
+	fi
+
+	# Run the rest of the tests in a net namespace.
 	../net/in_netns.sh "$0" "$@"
-	exit $?
-fi
+	err=$(( $err + $? ))
 
-# Determine selftest success via shell exit code
-exit_handler()
-{
-	if (( $? == 0 )); then
+	if (( $err == 0 )); then
 		echo "selftests: $TESTNAME [PASS]";
 	else
 		echo "selftests: $TESTNAME [FAILED]";
 	fi
 
+	exit $err
+fi
+
+# Determine selftest success via shell exit code
+exit_handler()
+{
 	set +e
 
 	# Cleanup
-- 
2.23.0.581.g78d2f28ef7-goog

