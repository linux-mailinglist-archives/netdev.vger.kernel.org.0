Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C055B3E9AE9
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhHKW2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbhHKW2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 18:28:14 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3027C0613D3
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 15:27:50 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id m8-20020a05622a0548b029028e6910f18aso2116551qtx.4
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 15:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=T/zDbxkizYMaFYSagVMiz86ET9qDxbiyDwudgzB17JI=;
        b=ZuRir7xPIa1eDVH4747rhfAbcaZttoo9mryALOswFfi/L/ETkuij4QjRwdGsmdQhTv
         9iVsU4MaG3uh0w4mhwxpq5GJ/3lt5nxNnqAOauIhpo8rlcmviItNxqTjFgPz/gdzsOGy
         YV42JOoRXKeNltY6voxtyvXNxa5UYSbeoaSqFvqja68pnh9Mr/FLnC/YXyIwdUZiaAaf
         D6/HhIZi73Ey+VENfNUoypi17Y7GI+igIutyYCBBong2EjPPhoFKvVNI4fr1pwLf/Agn
         SeM9gs9UNiCbPCmjOWN4plJmQ1OtOAsT+p7ONSfjSQA8FUR90htwbi95XlhzQi/clyje
         lmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=T/zDbxkizYMaFYSagVMiz86ET9qDxbiyDwudgzB17JI=;
        b=YQJN480fbcxmZrmw1aLcMmLcDUDqe0cGVrV1iNM2jhyOP6SPHDjtEU9HGCggdJ+0un
         +5Omf5h0Ze/mFcyw1MqF01pSF7q12mWxV85fvSGTrdXBtSlTJsa1KcCXNscVq6MXY/4/
         4/QV6KgCO7K5yZREaiz1c3+JaErdfv/G0AtqJPZcKrJ/GsDMO0xITmUXrbLpPaiM5KGV
         MPYGVGFTDRB1nmfWWUfs+R9LczNyagxian3oe0xsLFj+0pkCUM0tCh8pXjdFULKqyRT+
         JNZcSzLSzqEU1eO5pXs6MFo2vFQXv8cFoV+Y3l0ce2zL2iyf6wlc4tzcLb477TAhBF3l
         sXOQ==
X-Gm-Message-State: AOAM531ZHchALPzbGXzxPJStE9D0hGoEbZkfP8VZG1Fiu9PlKVb1fAx7
        85fS3h6zSeTFgwQ7YYgfH2tG6X3ofFPSYti/Wyk+1IXgeSxNEuFHmN821ZFLmbtTpfjZ/MXr2lu
        M+wqp5JNIaf2sn8gAu/RIqdj4QGoXzGTSmiWlqu1dgBNZkUcn9DYEDg==
X-Google-Smtp-Source: ABdhPJzbp6uTTndiEpBYjv3NhMbVIb1u3yzCXR+vRiChsnL6B3p8a8/RAk8a6IYeJAZrYJiyj8TjHC8=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:c78e:f5dc:8780:ed29])
 (user=sdf job=sendgmr) by 2002:ad4:4e50:: with SMTP id eb16mr921979qvb.14.1628720869706;
 Wed, 11 Aug 2021 15:27:49 -0700 (PDT)
Date:   Wed, 11 Aug 2021 15:27:45 -0700
Message-Id: <20210811222747.3041445-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH bpf-next 0/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'd like to be able to identify netns from setsockopt hooks
to be able to do the enforcement of some options only in the
"initial" netns (to give users the ability to create clear/isolated
sandboxes if needed without any enforcement by doing unshare(net)).

Stanislav Fomichev (2):
  bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
  selftests/bpf: verify bpf_get_netns_cookie in
    BPF_PROG_TYPE_CGROUP_SOCKOPT

 kernel/bpf/cgroup.c                        | 17 +++++++++++++++
 tools/testing/selftests/bpf/verifier/ctx.c | 25 ++++++++++++++++++++++
 2 files changed, 42 insertions(+)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

