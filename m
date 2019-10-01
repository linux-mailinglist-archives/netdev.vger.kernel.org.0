Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A4BC3EBF
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbfJARhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:37:46 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:53955 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731050AbfJARhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:37:46 -0400
Received: by mail-pl1-f201.google.com with SMTP id g13so7655537plq.20
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 10:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3+w4QsZSJoLh853gBsFQX1yVGVE86OfZ0POYrmn9pHU=;
        b=EKLc4BdVvrOA881KZYHEn6ikBQGKo5TVuNhmnxKpZVyWpOn45UQ6LoQyiOxOx7L3hC
         mS3/3bAje8xM3gD1wCAsNpKY5mjWKNa/VF3Qz1Bo8Ds0b7JImYv9gPI1wlbKmTMvRO+D
         ZOOOMgU9Oxd/GpCEXArPBkf0RpH8/sef+NwED+gM8hTMZjtfLkPqU+AJ5jK6GwGQlksn
         2GoKJ8aD5hc1j3KTNEpy8xco2s657h+8msI8UttOH5kixwSEtJongK3rMLvzD7Bi2Hv1
         UKNLkTc9jNHtufNJdVoQbvS/KncrjsHzpTe/cFiSCYGEtTsz7GXG1ktsrtxbWC6kIT/8
         mAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3+w4QsZSJoLh853gBsFQX1yVGVE86OfZ0POYrmn9pHU=;
        b=SyyY8jg7DVt+HywmlRFzSZNFBMKhrvgg6qxkrB4vzC+mQYFxFabYfkd8aqT0dUAr1m
         lYXvrLvQb/gRMpQz2vA/Zx9xeYDRoJT6uutOoZ/yGlzUV4tjVgmcoR9M/R1tuFQTUEE/
         19lFpJlHGVFT/H76rDZ3rZJXzGFRGok8ovsl1JCVcbGZVMUcZuUcI7UoNhD8in3K34VW
         MU5nWsrt/yTBO6R6fPg+o+MOGL+6N0z/mX5H9vQbtTJSZs/FENW+ztRMEUUxlMevdAYd
         k2gHvGP7u7QKc2+eaG/ActhCpSih7194oX4/DUsSD4lOI/tw+C3We5XqvceLFI7q00hj
         +RMw==
X-Gm-Message-State: APjAAAW2+P1eqPmaUN8xk+v1XuvVCYJozCRvocYOkLRuwKlrIdGAarD/
        OOXvqJGMNLpxyy3ISvivZF+lfa2ChD38
X-Google-Smtp-Source: APXvYqzh7leVxFKHdDQPmZYu3Us5x9qMqvVeWemq0AVPn1urC7cQbYSuTPtSo0OyKCw3z1h198Q2hecUAQG9
X-Received: by 2002:a63:4924:: with SMTP id w36mr15608050pga.113.1569951463622;
 Tue, 01 Oct 2019 10:37:43 -0700 (PDT)
Date:   Tue,  1 Oct 2019 10:37:26 -0700
Message-Id: <20191001173728.149786-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH bpf 0/2] selftests/bpf: test_progs: don't leak fd in bpf
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes some fd leaks in tcp_rtt and
test_sockopt_inherit bpf prof_tests.

Brian Vazquez (2):
  selftests/bpf: test_progs: don't leak server_fd in tcp_rtt
  selftests/bpf: test_progs: don't leak server_fd in
    test_sockopt_inherit

 tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 2 +-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c         | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.23.0.444.g18eeb5a265-goog

