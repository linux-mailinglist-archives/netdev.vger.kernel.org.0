Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD202B72F1
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgKRARq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgKRARq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 19:17:46 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D088CC0617A6
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 16:17:44 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c9so59392ybs.8
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 16:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=KSzntMlQutgORfFcLQlCCoRzBQW8Wn75jurvpaJoF8E=;
        b=Rm+nB6H2KrMsrAYrIv1Yg2A06B3tgtEHgKHUzMvuyI+kLnMZMsu9QHqGc3XFv8WgJY
         58ZX6vEaYkGLbxljUUcXKyV7MfsHqHFYhOW63JjMi1l4W4RGB5Lfjf9jYnwcsTeCSAL9
         lgGJlHKKt6nMH7XNwQ4C6h41KC1C9A/ueuaEvu9IMN67oA8iKpF7NWMKlfHB2T16k43E
         neINuSczClnUb7Zm0OBzQesPUbJO9lAcktccRDEAKE0NS6l1f7P4ccUMV1eXqsvnTTYd
         eC22NGtQALgiiUksx2qaA6A/p0ASaaB1mSHwDhBErlGevq6lq+/ylB04drLQEmFT6047
         SvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=KSzntMlQutgORfFcLQlCCoRzBQW8Wn75jurvpaJoF8E=;
        b=aB5Ni6HHuEf04BpXddsPYZaEq/m/ZjnRiz1K36LHGXuBQuLNk9fPlluC9QLB1f81B3
         LtdcI/P1jVAnNrB41vnmj9mQJK92308aLVIQMh2eIcmKaE33v/EzqmjXn6LO294k8dT1
         pQDGXqIT9zETn8q0bgi06/v+vRVMcLavHYgJs/Ne0jV7aJFJVH2jqkHF5pSsxuCNP05W
         ncE+slP1eAPbUzmuiMb/NeWyOHVrjBAQRGVMEyxkQlGjBOpb5o5v6CID7wrZKYCl9M6q
         mISx5ON6kVPGArQD3jViXXXQKMkwkVyJUV+S6beSMCBQE/h9bUL+EZ1NAJ38dmIblavy
         tOVg==
X-Gm-Message-State: AOAM532JkA9s2C602Ft4Tc9LolhmCvmIbIVUp0cP3rkLPc93kUfxSH1Q
        DAS6By/mwjHDWsSrDOQhfoWXBqTX5OyWs5GPSNcRTUrsRsjFvuSFeW68m7VAWekrYmVZhKbUxRE
        J5rXIFOLwP913tTDRU/Ss15QUYFdoPeQVBUoqH4PL+NFEGmc8JueYmw==
X-Google-Smtp-Source: ABdhPJw4kRiwpjmqN9x2bFVjJhPOCp5kFZFnwAYaQT7Ly2H4YvEb+aTyLkBaH0FZuaaOtqs6Y0wP2uk=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a5b:10:: with SMTP id a16mr3748622ybp.242.1605658664033;
 Tue, 17 Nov 2020 16:17:44 -0800 (PST)
Date:   Tue, 17 Nov 2020 16:17:39 -0800
Message-Id: <20201118001742.85005-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH bpf-next 0/3] bpf: expose bpf_{s,g}etsockopt helpers to
 bind{4,6} hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This might be useful for the listener sockets to pre-populate
some options. Since those helpers require locked sockets,
I'm changing bind hooks to lock/unlock the sockets. This
should not cause any performance overhead because at this
point there shouldn't be any socket lock contention and the
locking/unlocking should be cheap.

Also, as part of the series, I convert test_sock_addr bpf
assembly into C (and preserve the narrow load tests) to
make it easier to extend with th bpf_setsockopt later on.

Stanislav Fomichev (3):
  selftests/bpf: rewrite test_sock_addr bind bpf into C
  bpf: allow bpf_{s,g}etsockopt from cgroup bind{4,6} hooks
  selftests/bpf: extend bind{4,6} programs with a call to bpf_setsockopt

 include/linux/bpf-cgroup.h                    |  12 +-
 net/core/filter.c                             |   4 +
 net/ipv4/af_inet.c                            |   2 +-
 net/ipv6/af_inet6.c                           |   2 +-
 .../testing/selftests/bpf/progs/bind4_prog.c  | 104 ++++++++++
 .../testing/selftests/bpf/progs/bind6_prog.c  | 121 +++++++++++
 tools/testing/selftests/bpf/test_sock_addr.c  | 196 ++----------------
 7 files changed, 249 insertions(+), 192 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bind4_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind6_prog.c

-- 
2.29.2.299.gdc1121823c-goog

