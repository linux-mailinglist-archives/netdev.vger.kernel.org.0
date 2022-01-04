Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AEA484186
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiADMKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:10:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232909AbiADMKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:10:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641298233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=e23GvwFEUXHbUBSCX1HU3wptIv1SCmph2aHQnK4TxcA=;
        b=LbxljXck+0TuwPMqRzBKVxd2zyjYzhj9ceGyeTeZRk+2Em62BcBx7CRYpU96fQmQH2lGZx
        8OYVEpj9zIlBSY9989USTCGf05XqnngYihjYCQken4EfYnN4/vlRCyEPT7X0xzsJ9/1W2R
        M+RWWMz0284eG0Eu3oeYwMNEpBsCuCI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-5eiQ8_ofMNOiGBM1dIASUQ-1; Tue, 04 Jan 2022 07:10:32 -0500
X-MC-Unique: 5eiQ8_ofMNOiGBM1dIASUQ-1
Received: by mail-wm1-f70.google.com with SMTP id j8-20020a05600c1c0800b00346504f5743so3010783wms.6
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 04:10:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e23GvwFEUXHbUBSCX1HU3wptIv1SCmph2aHQnK4TxcA=;
        b=0eKLZkQP/IwUUUNcGEaD8+lUVDcNZsQYm9H63BI5Y8v9tF3OIgVNjfe/rUhn1jfrFV
         r9yg+qrdmvStbvprUBdTvU2RAWPPYMRn23SzReQuwqpYD+pF1NXbS0qUE85jPTD5Z+a6
         StQI017W8tvEPE4wMwDDvOBZKR7U6zMaRM/O/ogdwkQrP2+BPLOXisrSr3QIVAmJjg9P
         OrBma+9YvXDxxHBfdN2AvS8Hv5SK6czDDFjWzWadix5Cw6RJudjSWAKXqGDSm0C9AfOJ
         DrSk2f5cLQwEmUIR4yGxQwem+0m5IOAMOyv1y9Vvejx7av3Pgyi34ZxJ8iNjeK08vt51
         ro5w==
X-Gm-Message-State: AOAM531V7MA5hjp3rcR6fRl8DLT17psmTl4jXSGhI687HB2oi9ZtmgkB
        GCocG+zh1uwcr26ypYE9ZTMinYdQerHphTdnErPPkvFK6oHjSKxeqTyehBMzphHxJOJN7s8+rCv
        8rTv2LFolA9cPAvMw
X-Received: by 2002:a05:600c:3657:: with SMTP id y23mr42035060wmq.160.1641298231346;
        Tue, 04 Jan 2022 04:10:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzoMiXH8X2tDQsRX9319UAmIiBDBaixOkpfg3ScIJMlw9L8taNLaIkYq9NCFQt4cVSN5EKCcQ==
X-Received: by 2002:a05:600c:3657:: with SMTP id y23mr42035045wmq.160.1641298231147;
        Tue, 04 Jan 2022 04:10:31 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b19sm42835575wmb.38.2022.01.04.04.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 04:10:30 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Jussi Maki <joamaki@gmail.com>, Hangbin Liu <haliu@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH] bpf/selftests: Fix namespace mount setup in tc_redirect
Date:   Tue,  4 Jan 2022 13:10:30 +0100
Message-Id: <20220104121030.138216-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tc_redirect umounts /sys in the new namespace, which can be
mounted as shared and cause global umount. The lazy umount also
takes down mounted trees under /sys like debugfs, which won't be
available after sysfs mounts again and could cause fails in other
tests.

  # cat /proc/self/mountinfo | grep debugfs
  34 23 0:7 / /sys/kernel/debug rw,nosuid,nodev,noexec,relatime shared:14 - debugfs debugfs rw
  # cat /proc/self/mountinfo | grep sysfs
  23 86 0:22 / /sys rw,nosuid,nodev,noexec,relatime shared:2 - sysfs sysfs rw
  # mount | grep debugfs
  debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)

  # ./test_progs -t tc_redirect
  #164 tc_redirect:OK
  Summary: 1/4 PASSED, 0 SKIPPED, 0 FAILED

  # mount | grep debugfs
  # cat /proc/self/mountinfo | grep debugfs
  # cat /proc/self/mountinfo | grep sysfs
  25 86 0:22 / /sys rw,relatime shared:2 - sysfs sysfs rw

Making the sysfs private under the new namespace so the umount won't
trigger the global sysfs umount.

Cc: Jussi Maki <joamaki@gmail.com>
Reported-by: Hangbin Liu <haliu@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tc_redirect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index 4b18b73df10b..c2426df58e17 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -105,6 +105,13 @@ static int setns_by_fd(int nsfd)
 	if (!ASSERT_OK(err, "unshare"))
 		return err;
 
+	/* Make our /sys mount private, so the following umount won't
+	 * trigger the global umount in case it's shared.
+	 */
+	err = mount("none", "/sys", NULL, MS_PRIVATE, NULL);
+	if (!ASSERT_OK(err, "remount private /sys"))
+		return err;
+
 	err = umount2("/sys", MNT_DETACH);
 	if (!ASSERT_OK(err, "umount2 /sys"))
 		return err;
-- 
2.33.1

