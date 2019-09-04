Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559FDA8D13
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731587AbfIDQZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:25:13 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:39365 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729890AbfIDQZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 12:25:12 -0400
Received: by mail-qk1-f201.google.com with SMTP id p6so8508725qkk.6
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 09:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YkX5xIFZm8dKIo6Aaw0z72OCwLMrJLrAmP5FOc86WyY=;
        b=GZl2stlJ5Zpb52zpjdFc4qTpbqt56GTzBoAEfjU9VzeB7RfR5sBNdJtdG8NJLxmAZD
         0njeHZyIWngTVMIaus8VeCtdCg7s2FVx29Lh1GSvh8pYjrdLdinnNahmCdyo3wwlEDEq
         tnGSpGdqXu2QNAS6uuefvYOtwI2gC3PnZLSZtFMk2mfhz5YJpUXHoyJ2229Zi18R+evZ
         uCaCRQODds9hkf17ZN3tZZVRpy3DIgPjpvvxsTxF36VpF5kEwp+Q3AA3hcWbCODfnHrq
         xfmYkwZOtDMg3ByaUjuccAZb021FQlqecooCCx8ELh1sVTK5LR32//lsQh6drwcWo9bN
         2M4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YkX5xIFZm8dKIo6Aaw0z72OCwLMrJLrAmP5FOc86WyY=;
        b=F//Jlwf3nhHjQ4u5PMIjfJlWwrDCuoWQWZZMhBPUihlI9AY3e6q4X8EZlqutOXVpYo
         RfBHl79Jl/DcHGP5pSfDm08tkN+840J/qZJej1IYmCVFbSQd4YV7NFNFuVtFL2T1fZbd
         TuK4MRebeCvpokmiOlfcpNSxc5prTtZ4xj0mvEa7CQ6nPAUfQ3xN1MWZCpCvkviIjx1B
         s/2rO/5U07kbXlPuBlIZSRJOy3DbpmyDYVrYiWFCxM+JmqXHENKApI4Np1YomJw9zop/
         CEw5j4S5nOAJJSXa88ZU9+1e0sfgh4FEaFEHv1s1/de1CRDv1J4Fjr+NR/zug6If9Y4D
         bs7A==
X-Gm-Message-State: APjAAAX+Fwpa1S406ABpLfMeKoc95lz31nuV7Sd4jRXS/qm7gP7L9hQg
        nCaFy+SB4/tmrq6qmsBwVOQnN+pKV8yCUS7qk06Lafm+aSZQxAZAcxhoyIKpMO1o36OcgKVWnxo
        Vafj4VBd79VKTzdd8iUvIdbBbiUtJjcW2n7l+c10PXkm4eeeYLQWhUw==
X-Google-Smtp-Source: APXvYqyArNXsaVHaGpvDehnryrWUZe0zRTisNwOPaBj9m14d7MTwlTYtnmRgQRkRwzJ9z0AYKcwD7po=
X-Received: by 2002:ae9:c00d:: with SMTP id u13mr37979383qkk.300.1567614311627;
 Wed, 04 Sep 2019 09:25:11 -0700 (PDT)
Date:   Wed,  4 Sep 2019 09:25:03 -0700
Message-Id: <20190904162509.199561-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH bpf-next 0/6] selftests/bpf: move sockopt tests under test_progs
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that test_progs is shaping into more generic test framework,
let's convert sockopt tests to it. This requires adding
a helper to create and join a cgroup first (test__join_cgroup).
Since we already hijack stdout/stderr that shouldn't be
a problem (cgroup helpers log to stderr).

The rest of the patches just move sockopt tests files under prog_tests/
and do the required small adjustments.

Stanislav Fomichev (6):
  selftests/bpf: test_progs: add test__join_cgroup helper
  selftests/bpf: test_progs: convert test_sockopt
  selftests/bpf: test_progs: convert test_sockopt_sk
  selftests/bpf: test_progs: convert test_sockopt_multi
  selftests/bpf: test_progs: convert test_sockopt_inherit
  selftests/bpf: test_progs: convert test_tcp_rtt

 tools/testing/selftests/bpf/.gitignore        |   5 -
 tools/testing/selftests/bpf/Makefile          |  12 +--
 .../{test_sockopt.c => prog_tests/sockopt.c}  |  50 ++-------
 .../sockopt_inherit.c}                        | 102 ++++++++----------
 .../sockopt_multi.c}                          |  62 ++---------
 .../sockopt_sk.c}                             |  60 +++--------
 .../{test_tcp_rtt.c => prog_tests/tcp_rtt.c}  |  83 +++++---------
 tools/testing/selftests/bpf/test_progs.c      |  38 +++++++
 tools/testing/selftests/bpf/test_progs.h      |   4 +-
 9 files changed, 142 insertions(+), 274 deletions(-)
 rename tools/testing/selftests/bpf/{test_sockopt.c => prog_tests/sockopt.c} (96%)
 rename tools/testing/selftests/bpf/{test_sockopt_inherit.c => prog_tests/sockopt_inherit.c} (72%)
 rename tools/testing/selftests/bpf/{test_sockopt_multi.c => prog_tests/sockopt_multi.c} (83%)
 rename tools/testing/selftests/bpf/{test_sockopt_sk.c => prog_tests/sockopt_sk.c} (79%)
 rename tools/testing/selftests/bpf/{test_tcp_rtt.c => prog_tests/tcp_rtt.c} (76%)

-- 
2.23.0.187.g17f5b7556c-goog
