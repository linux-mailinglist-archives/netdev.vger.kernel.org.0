Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8180A8046A
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 06:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfHCEnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 00:43:43 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43383 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfHCEnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 00:43:43 -0400
Received: by mail-ot1-f65.google.com with SMTP id j11so22943496otp.10;
        Fri, 02 Aug 2019 21:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TZIujp0eg8gIntMJPdV1QMipwEtEZxdPv3IkUafKemQ=;
        b=fK/smf7VFVzS3KEwNW7UG5OAOCVwGq6EEqoaXfr70b1Ve5i1D3KYhivtFalGVOW3Df
         Popq1fzMEisWzHAPCBnMmPPDNGbawyrx8Ao6iZNQUUArZX9bvM3QmiLDxoCEFqRW+Kzk
         If3Oj0NCHLcTi1owd/aIMMOlUqPTWZYjV/q2m8mey1otGC29ugMq0g/gX8hAz5CwCiFw
         Po/Sw7gX664/5MjWLgx5kJQF9r0az5gVhVn4ngem28NjWjqmbc69MqFzEFTJHaTuSyQv
         k/0FxDtcXXiY0Z1de8VMpCTfdHran76H7TXVPctl2gyfx6jEECv7ekY1ZrCVTBmyAEyX
         +jMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TZIujp0eg8gIntMJPdV1QMipwEtEZxdPv3IkUafKemQ=;
        b=b+lsRbjC2JBc4ZtzNZ0VhMv8xF7EDL0CoH8mtzjq2KnVJ/pHZ12XItN/dsmtFcbCB7
         jWNAocnbDcYAIGRQ3jR1skNqvRScUZ1zP7nE55oDlQx4e3TxqEUS0iAM5C6vbSUTcebW
         B6iR3kffj6n8EQr0OINZSrZzD3XAkAU+IcdMhNOCRE19PaKn7gdVqb9bEjpYFVmW/7v2
         2UuenSNiXaa13ZO92d10Kuua+LR1jqIxASCtX9sypcIDMyeQf5vP01atG51Twj9t8zuq
         qoRtThDNiD6bWUr0fHaGpOLquHv6SqeBEocTRP23+WUqCMQTjJWapY4iaFykkGK2H/WZ
         2c1g==
X-Gm-Message-State: APjAAAVeiuJp97pZPHGVPoM/L/Qlt3RaRJU9TRuRYKw+XeXU7XE7GyM2
        xPNdapkj0WkV+DdrQJuumPE=
X-Google-Smtp-Source: APXvYqwa7EB6i2qSa4VXxaUqUtHei+IUIOZwbZvvYCOH9xSAL2R+M/KClo5wsrySeD9528S4yOYubQ==
X-Received: by 2002:a9d:5a91:: with SMTP id w17mr73145467oth.32.1564807421995;
        Fri, 02 Aug 2019 21:43:41 -0700 (PDT)
Received: from fmzakari-linux.localdomain (76-242-91-200.lightspeed.sntcca.sbcglobal.net. [76.242.91.200])
        by smtp.gmail.com with ESMTPSA id 93sm26540379ota.77.2019.08.02.21.43.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 21:43:41 -0700 (PDT)
From:   Farid Zakaria <farid.m.zakaria@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: [PATCH 0/1] bpf: introduce new helper udp_flow_src_port
Date:   Fri,  2 Aug 2019 21:43:19 -0700
Message-Id: <20190803044320.5530-1-farid.m.zakaria@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a submission to expose a new eBPF helper method
to allow access to udp_flow_src_port -- which is useful
when doing any Foo Over UDP network tunneling.

I hope this change adheres to the submission guidelines.
I've included a test and verified it passes:

./test_progs -t udp_flow_src_port
#31 udp_flow_src_port:OK
Summary: 1/0 PASSED, 0 FAILED

* shoutout to https://github.com/g2p/vido/blob/master/vido
which made testing the kernel + change super easy *
(This is my first contribution)

Farid Zakaria (1):
  bpf: introduce new helper udp_flow_src_port

 include/uapi/linux/bpf.h                      | 21 +++++++--
 net/core/filter.c                             | 20 ++++++++
 tools/include/uapi/linux/bpf.h                | 21 +++++++--
 tools/testing/selftests/bpf/bpf_helpers.h     |  2 +
 .../bpf/prog_tests/udp_flow_src_port.c        | 28 +++++++++++
 .../bpf/progs/test_udp_flow_src_port_kern.c   | 47 +++++++++++++++++++
 6 files changed, 131 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_flow_src_port.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_udp_flow_src_port_kern.c

-- 
2.21.0

