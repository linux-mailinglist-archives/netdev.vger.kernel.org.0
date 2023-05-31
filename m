Return-Path: <netdev+bounces-6915-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DBFD718A55
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 452C92815C7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D13134CD5;
	Wed, 31 May 2023 19:38:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39CD34CCB;
	Wed, 31 May 2023 19:38:54 +0000 (UTC)
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4857135;
	Wed, 31 May 2023 12:38:52 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 6a1803df08f44-6260bb94363so980176d6.0;
        Wed, 31 May 2023 12:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685561932; x=1688153932;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k1XSVlPtoJ0u6hQGs40U8nTzNUoPpxs4wdnpz7Kdnpk=;
        b=TqgaTpYHg/uY2I+uLZfTPg1zY4XxWzEmEdDuoWTmj5Gpd85qLFXNZF53sRVFB4CkId
         UIl6bXbdH6X3NCfwUKJIM/v/+3s6/hDpEUVLDSci5pa5x7WOkUZW0BmdgXMg59fHFBJH
         0UdN1h907eJ1lCid4jkCBrOrIoPzxyp5PA1xcZNbTOC2S3SiB0BumrfUWv+bJoLCy0za
         qnGovWsaZsSsKdTS9DwFwTHoSqvzCegvDDs4OesMzNcQuivV5aDBdMX+nfViBAeAgEp2
         7cTQHmTCGz7PByXLdQkVcUIbx4HcPiDnBhEXhzf1oHCfZdm/aPMTuSJBQnCzkm801r8E
         sqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685561932; x=1688153932;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k1XSVlPtoJ0u6hQGs40U8nTzNUoPpxs4wdnpz7Kdnpk=;
        b=L9ptfXK8OtK0V+Jmcnb+E0X/sHqgtfxNJriCDFxr5nVwEZdtzVfrkryckerbkkJjho
         g/O32t8bNdFYfl3fSvKL+rS1yWWd9nML1mdbYVc46Yw9GdbqfA8gQqMc3FMDKvMimETn
         UjysHnaAG7a+VAMze1T902D9H5U/XjUpG+B6iYKgz9/kzY2i7fXJCyCDQ5YCsGOwL6IH
         FD+dleYEdKztXLAPBpKEm1ANkg2S9RWNYGCWt3ousNgaQdWddEO1Y3yROR3eLYT5DAZA
         A9xrUdyKYCvDKQMcJemqB4JNQGpLihYhO9D3UvJq8D11trD9g05jqwliEOu9A0dY1w0j
         WKRg==
X-Gm-Message-State: AC+VfDwaVEtF58Y/9wq8Tn0aYtv1nKR/X2rrmSJZiY/ACM1c0Gtwvbsp
	gKQdWu7jfR6vmtHBzuwROLU=
X-Google-Smtp-Source: ACHHUZ5COr7USqAsPU85CZfk9cJIfiJ3l2KoKPYfkJWMNYJyyG9yyGWNfbUscxjnZOGQNklOUtzImA==
X-Received: by 2002:a05:6214:5016:b0:623:8494:9945 with SMTP id jo22-20020a056214501600b0062384949945mr16657457qvb.26.1685561931764;
        Wed, 31 May 2023 12:38:51 -0700 (PDT)
Received: from localhost (ool-944b8b4f.dyn.optonline.net. [148.75.139.79])
        by smtp.gmail.com with ESMTPSA id x15-20020a0cfe0f000000b006238f82cde4sm6225439qvr.108.2023.05.31.12.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 12:38:51 -0700 (PDT)
From: Louis DeLosSantos <louis.delos.devel@gmail.com>
Subject: [PATCH v2 0/2] bpf: utilize table ID in bpf_fib_lookup helper
Date: Wed, 31 May 2023 15:38:47 -0400
Message-Id: <20230505-bpf-add-tbid-fib-lookup-v2-0-0a31c22c748c@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEeid2QC/4WOQQ6CMBBFr0K6dkwpUsSV9zAspnQKE4WSFomGc
 HcLF3D5/s/L/6uIFJiiuGWrCLRwZD8mUKdMtD2OHQHbxEJJVchSlmAmB2gtzIYtODbw8v75ngD
 xoh3K+qplIZJtMBKYgGPb7/6AcaawF1Mgx59j8tEk7jnOPnyPB0u+p//HlhwkOFvXrsq1okrfu
 wH5dW79IJpt236my1qT1wAAAA==
To: bpf@vger.kernel.org, netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, 
 Stanislav Fomichev <sdf@google.com>, razor@blackwall.org, 
 John Fastabend <john.fastabend@gmail.com>, Yonghong Song <yhs@meta.com>, 
 Louis DeLosSantos <louis.delos.devel@gmail.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patchset adds the ability to specify a table ID to the
`bpf_fib_lookup` BPF helper. 

A new `tbid` field is added to `struct fib_bpf_lookup`.
When the `fib_bpf_lookup` helper is called with the `BPF_FIB_LOOKUP_DIRECT` and 
`BPF_FIB_LOOKUP_TBID' flag the `tbid` field will be interpreted as the table ID 
to use for the fib lookup.

If the `tbid` specifies a table that does not exist the lookup fails
with `BPF_FIB_LKUP_RET_NOT_FWDED`

This functionality is useful in containerized environments. 

For instance, if a CNI wants to dictate the next-hop for traffic leaving
a container it can create a container-specific routing table and perform
a fib lookup against this table in a "host-net-namespace-side" TC program.

This functionality also allows `ip rule` like functionality at the TC
layer, allowing an eBPF program to pick a routing table based on some
aspect of the sk_buff.

As a concrete use case, this feature will be used in Cilium's SRv6 L3VPN
datapath. 
When egress traffic leaves a Pod an eBPF program attached by Cilium will
determine which VRF the egress traffic should target, and then perform a
FIB lookup in a specific table representing this VRF's FIB.

The existing `fib_lookup.c` bpf selftest was appended several test cases
to ensure this feature works as expected. 

```
$ sudo ./test_progs -a "*fib*"

Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
```

Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
---
Changes in v2:
- Utilize a new flag `BPF_FIB_LOOKUP_TBID` for performing table ID fib
  lookups.
- Update fib lookup selftest to reflect new flag usage.
- Change second commit message subject to `selftests/bpf`.
- Link to v1: https://lore.kernel.org/r/20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com

---
Louis DeLosSantos (2):
      bpf: add table ID to bpf_fib_lookup BPF helper
      selftests/bpf: test table ID fib lookup BPF helper

 include/uapi/linux/bpf.h                           | 21 ++++++--
 net/core/filter.c                                  | 14 ++++-
 tools/include/uapi/linux/bpf.h                     | 21 ++++++--
 .../testing/selftests/bpf/prog_tests/fib_lookup.c  | 61 +++++++++++++++++++---
 4 files changed, 102 insertions(+), 15 deletions(-)
---
base-commit: fbc0b0253001c397a481d258a88ce5f08996574f
change-id: 20230505-bpf-add-tbid-fib-lookup-aa46fa098603

Best regards,
-- 
Louis DeLosSantos <louis.delos.devel@gmail.com>


