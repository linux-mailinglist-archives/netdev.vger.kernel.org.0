Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB65B34915F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhCYMBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhCYMBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:01:01 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7EAC06174A;
        Thu, 25 Mar 2021 05:01:01 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id v186so1546478pgv.7;
        Thu, 25 Mar 2021 05:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WvEHsPjKIq/P2TsSWLeMiXHZ4cDxRks9I5jtQKX/b+k=;
        b=K1e2lO9tvzR3LDoDU86xEEwPisR7tDiX4AfI2nUBu4Tih6W4ixNZVdMKEC4pFWWKlN
         3XItzPX5i57JZwLYtQsvyc9kXwIuQY+foL7hGmS7hkDxS1a+UKn+uQ104knm7rAUdmQo
         hVNYRxupAJNKI9wpBYdBxOL2BArNd5xTZpjVYK+iizoiiwU/dDWqikMuDNnQGUUNbTM6
         OmIVDwRzIhJ50RlK4gUYw2ntSkopWnbEwccie3iysM3ZYOEHF52txgEbFmZh/UHw9l1O
         dKfJm76W6aEMBHnE/2pvESO+qOfoAckGift3RWJZGmoC+6M7IoeysQH2WYkUUA9bRf8p
         9NLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WvEHsPjKIq/P2TsSWLeMiXHZ4cDxRks9I5jtQKX/b+k=;
        b=T4Je16WVV6rrFZR4btG070SW9zoZWi69GEKFYC7PWpVZhDxcD0XwoBVopxq1VaixVl
         T/mDwc26E0iEuwXrBesipgRiVOWy9UpDyq7WWdw18XVxJVoTByysLuwO0e8k4iZX5wtX
         DsL2jtSFJw5vQ6iFzyymFgRT5MDpaXibcKzpDx6FXFyMYfsOIBwYQmE4nBJmI6D6AWsb
         2bV+ZhJY+utwjNn2D0Hpco/V/cQdzc8fwop8m5Xa/fTblvv78wag7LI9dWd4I+cD5za+
         Qff3kq6qmLsBrfDPTOK5fy0yECXe/aCWxlC+sIHtiO9iHkpIAGEc386lZSxZ1gbHGXXj
         Ahmw==
X-Gm-Message-State: AOAM532Anx3GzP7gip537+HaGV2H09yLsz0OLxt75ksO3QJYvpjhODqP
        Yuq2f+xTKGRCy8sKrbmGwFjcpGlSvxKnvg==
X-Google-Smtp-Source: ABdhPJx6IyzPnrKatQsltGUIvl65Am97UCYB/waM6Rn+FvzgXWCyfijbgZs6aY45zuiZKviepT2ypw==
X-Received: by 2002:a62:5f83:0:b029:20e:70c3:c3e3 with SMTP id t125-20020a625f830000b029020e70c3c3e3mr7225214pfb.60.1616673660425;
        Thu, 25 Mar 2021 05:01:00 -0700 (PDT)
Received: from localhost ([112.79.237.176])
        by smtp.gmail.com with ESMTPSA id a15sm5545035pju.34.2021.03.25.05.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:01:00 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     brouer@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 0/5] libbpf: Add TC-BPF API
Date:   Thu, 25 Mar 2021 17:29:58 +0530
Message-Id: <20210325120020.236504-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support to libbpf for attaching SCHED_CLS and SCHED_ACT bpf
programs to their respective tc attach points.

Currently, a user needs to shell out to the tc command line for add, change,
replace, and del operations, which is not ideal.

Some of the features that have been omitted for the CLS API:

* TCA_BPF_POLICE
  Support for adding police actions to filter has been omitted for now.
* TCA_RATE
  Support for packet rate estimator has been omitted for now.
* Attaching actions directly to the classifier
  This allows the attached actions to be bound to classifier and get auto detached
  when it is deleted. It translates to 'bind' refcount in the kernel internally.
  They run after a successful classification from the SCHED_CLS prog.
  Support for this can be added later, but has been omitted for now, primarily
  because direct-action mode provides a better alternative.

A high level TC-BPF API is also provided, and currently only supports attach and
destroy operations. These functions return a pointer to a bpf_link object. When
falling back to the low level API, the link must be disconnected to take over
its ownership. It can be released using bpf_link__destroy, which will also cause
the filter/action to be detached if not disconnected.

The individual commits contain a general API summary and examples.

Kumar Kartikeya Dwivedi (5):
  tools pkt_cls.h: sync with kernel sources
  libbpf: add helpers for preparing netlink attributes
  libbpf: add low level TC-BPF API
  libbpf: add high level TC-BPF API
  libbpf: add selftests for TC-BPF API

 tools/include/uapi/linux/pkt_cls.h            | 174 +++-
 tools/lib/bpf/libbpf.c                        | 110 ++-
 tools/lib/bpf/libbpf.h                        | 133 ++++
 tools/lib/bpf/libbpf.map                      |  17 +
 tools/lib/bpf/netlink.c                       | 752 +++++++++++++++++-
 tools/lib/bpf/nlattr.h                        |  43 +
 .../selftests/bpf/prog_tests/test_tc_bpf.c    | 261 ++++++
 .../selftests/bpf/progs/test_tc_bpf_kern.c    |  18 +
 8 files changed, 1476 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c

--
2.30.2

