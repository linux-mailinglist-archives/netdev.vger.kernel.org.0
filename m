Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7579194DB3
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfHSTR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:17:56 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:55788 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbfHSTR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 15:17:56 -0400
Received: by mail-vk1-f201.google.com with SMTP id x128so1612594vkb.22
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 12:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WY76z6d6LzfXIWyRVMRCt1MQ9lLGs/hOrzblL370r2g=;
        b=KDZutR5ru85AygNjM3Epaoooty3iJqSOQCCIBMIvBpmArOd+IeImQBb4ZFE69BtEw+
         d1VTRi1rbsxb8QBXSfb5M5QWanqMfV/DlAz0K7U7n6c64NBLrT4yIbjPNjQSHDbafYjm
         5pawekj28Kbfu62mi7eJfqa4jrtFTPJ7AZq+JWv014xQurP7mWvhKNiHLK+4EdoD2Hxg
         PT7GAd3kqnTE9h4HZch3K9efbbB1Vwj0I5alr6p7wibDwYz4S4NsizPLeh1ILDuKSpxa
         F+CCKZiO6oc9NDszNvWMhEI8OiNnx3sl6OaOxYEYnnmpu5PPYXYakKw02FFe7UqZBjvu
         740Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WY76z6d6LzfXIWyRVMRCt1MQ9lLGs/hOrzblL370r2g=;
        b=CD3CLalEDFNC+N2J6ctvXQKv0d/V9ucm8lE8eR2Sa9EKhZgPjzcSYB+S03pQpvKEft
         9rMd3vt9K084EveJnnSWrmzW5VUZWN5hIALwkR1e4pRP7BawhogEN4eYr47X5S5qlrI5
         kUz80PFwwaAUBy3WcMvSnNoShhiAJ9rD+XEYpceFDyILd70Yn6ISZMwUSwo2bCay21Gh
         iScxtZDXDe8Khp4BWfseR0OmmVitcPVXcv0Dc4x4Z7EttwV6PyvKJumAQOfOFvVDKJdG
         YGE4XFMTqaWWMWKO4OUZiN3RxaaptDeq9Sw68sQLryTuZTTkwoCSwuHAWHLorop8wypy
         8+pA==
X-Gm-Message-State: APjAAAVfTk1R0hKBPqpScH5BLL6b/1uKU+mQcVpYKFUdWI7xB//5XhCT
        Ezqemg3mcfb1EurTdljj7JdO02Uu7p8QTiRgnLco2wJifT8qLe9uKh9eklZT8RrfsgFniAssDHq
        DyZzKhvrHas176HC2wVRKx9VxkGyVNPxIIvMekmZ1zgcK1VGmb8VpVA==
X-Google-Smtp-Source: APXvYqwbkPus3Yyw3D5MKkF13ZrsV4mF5TIlsBZC5AK093kJuSzqMnosy2SCysS96WXjwDK5EQj3z5M=
X-Received: by 2002:a1f:dec7:: with SMTP id v190mr8901238vkg.39.1566242274749;
 Mon, 19 Aug 2019 12:17:54 -0700 (PDT)
Date:   Mon, 19 Aug 2019 12:17:48 -0700
Message-Id: <20190819191752.241637-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v2 0/4] selftests/bpf: test_progs: misc fixes
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* add test__skip to indicate skipped tests
* remove global success/error counts (use environment)
* remove asserts from the tests
* remove unused ret from send_signal test

v2:
* drop patch that changes output to keep consistent with test_verifier
  (Alexei Starovoitov)
* QCHECK instead of test__fail (Andrii Nakryiko)
* test__skip count number of subtests (Andrii Nakryiko)

Cc: Andrii Nakryiko <andriin@fb.com>

Stanislav Fomichev (4):
  selftests/bpf: test_progs: test__skip
  selftests/bpf: test_progs: remove global fail/success counts
  selftests/bpf: test_progs: remove asserts from subtests
  selftests/bpf: test_progs: remove unused ret

 .../selftests/bpf/prog_tests/bpf_obj_id.c     | 20 +++++----
 .../bpf/prog_tests/bpf_verif_scale.c          |  9 +---
 .../selftests/bpf/prog_tests/flow_dissector.c |  4 +-
 .../bpf/prog_tests/get_stack_raw_tp.c         |  3 --
 .../selftests/bpf/prog_tests/global_data.c    | 20 +++------
 .../selftests/bpf/prog_tests/l4lb_all.c       |  8 +---
 .../selftests/bpf/prog_tests/map_lock.c       | 37 ++++++++--------
 .../selftests/bpf/prog_tests/pkt_access.c     |  4 +-
 .../selftests/bpf/prog_tests/pkt_md_access.c  |  4 +-
 .../bpf/prog_tests/queue_stack_map.c          |  8 +---
 .../bpf/prog_tests/reference_tracking.c       |  4 +-
 .../selftests/bpf/prog_tests/send_signal.c    | 43 +++++++++----------
 .../selftests/bpf/prog_tests/spinlock.c       | 16 +++----
 .../bpf/prog_tests/stacktrace_build_id.c      |  7 +--
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  7 +--
 .../selftests/bpf/prog_tests/stacktrace_map.c | 17 +++-----
 .../bpf/prog_tests/stacktrace_map_raw_tp.c    |  9 ++--
 .../bpf/prog_tests/task_fd_query_rawtp.c      |  3 --
 .../bpf/prog_tests/task_fd_query_tp.c         |  5 ---
 .../selftests/bpf/prog_tests/tcp_estats.c     |  4 +-
 tools/testing/selftests/bpf/prog_tests/xdp.c  |  4 +-
 .../bpf/prog_tests/xdp_adjust_tail.c          |  4 +-
 .../selftests/bpf/prog_tests/xdp_noinline.c   |  7 +--
 tools/testing/selftests/bpf/test_progs.c      | 41 ++++++++++++------
 tools/testing/selftests/bpf/test_progs.h      | 19 +++++---
 25 files changed, 135 insertions(+), 172 deletions(-)

-- 
2.23.0.rc1.153.gdeed80330f-goog
