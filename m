Return-Path: <netdev+bounces-5340-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4866B710E52
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA64A1C20EE5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5B1156C6;
	Thu, 25 May 2023 14:28:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3882D512;
	Thu, 25 May 2023 14:28:05 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2760E189;
	Thu, 25 May 2023 07:28:04 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-75b0f2ce4b7so53392985a.2;
        Thu, 25 May 2023 07:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685024883; x=1687616883;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jne64K9Gy2C9dAFtlMtkjmLtZ1d50tnHNJuf743mfXA=;
        b=X1k2VFciEC+7UnEJw9BdieHOpB9YeNtKvQDJo74quhLg63MEyFF0nOZwzp1cuOYTHY
         OuSBx5c42Y/sXWBzJcdmEscdofg6Qny38235Oe/6q1z7xH+sEwihVNjOUHTiTetlnH0P
         KCBRnWn71bgf21iUll6TkbiuhInHBGbVngIMwhRRzyS3cxPBsAsa/bwQg0gYOsOtS13+
         uAPXWXqjE0YcGxI3u+BhcpsAGFwmRKPi//7LeFfUMk4Wgh0urkk63LeKOnuN7hjXmyVM
         WRRwoPdsULmVeuumZXWfX0hqaLQPChmkJkzh+zSAJzvw6M/gUYhe+DX2RQOhHcveITR6
         5CbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685024883; x=1687616883;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jne64K9Gy2C9dAFtlMtkjmLtZ1d50tnHNJuf743mfXA=;
        b=IdiVsC01GcjYRsQY91+ick0Q5ObogFPtDY+8hCeTLV6lOxlb95l7uF+6LKUNzRD0rr
         Pgag4KELlCl/dLrMFXZN4QDRCBOjJjnoNqal0chEfrIOBo4QLSvpzaVz6qZBD6tHPadu
         7SAc/lbVx6FM8jv2BASN42S4z7SZaF1IGOCKQiRnoiUyVNvwrM+uVrYKWqgoO1oQal1+
         bN7kh9up42toGlRUK0WKa2LQDUZGZ6MX1+gdH1NGH210debqR8M/+iWY5q6mIjLKt8YV
         BSOsBnbl0WTNLyKT2HRquYn0Z8WMPgvta2ipCOBkINkAIJyzy3T5k2CLgP4CVFTpwlTR
         RtSw==
X-Gm-Message-State: AC+VfDz0SyJvRiWq9+NC64rEOifg/57tLm+JyrOtJd3HMNjvCqaVhnv/
	cysuU2lisNnFeEmImIoVDeFbKDxyT8A=
X-Google-Smtp-Source: ACHHUZ6HMh7p94BI9Qc8NJIJDdD8bHTj27DCRDbIuCG/l/XItZuTwMHZz03EtjdVx372eT2tz/XbOg==
X-Received: by 2002:a05:620a:a1a:b0:75b:23a0:d9d1 with SMTP id i26-20020a05620a0a1a00b0075b23a0d9d1mr9964449qka.39.1685024883258;
        Thu, 25 May 2023 07:28:03 -0700 (PDT)
Received: from localhost (ool-944b8b4f.dyn.optonline.net. [148.75.139.79])
        by smtp.gmail.com with ESMTPSA id a13-20020a05620a124d00b0075936b3026fsm429398qkl.38.2023.05.25.07.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:28:02 -0700 (PDT)
From: Louis DeLosSantos <louis.delos.devel@gmail.com>
Subject: [PATCH 0/2] bpf: utilize table ID in bpf_fib_lookup helper
Date: Thu, 25 May 2023 10:27:58 -0400
Message-Id: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG5wb2QC/x2N0QrCMAwAf2Xk2UDd3FB/RfaQrKkLalvSKcLYv
 9v5eBzHrVDEVApcmxVMPlo0xQrHQwPTTPEuqL4ytK7tXO965ByQvMeF1WNQxmdKj3dGotMQyF3
 Og+ug1kxFkI3iNO/9i8oitotsEvT7X97GbfsBlLhLYIIAAAA=
To: bpf@vger.kernel.org, netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, 
 Stanislav Fomichev <sdf@google.com>, razor@blackwall.org, 
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
When the `fib_bpf_lookup` helper is called with the
`BPF_FIB_LOOKUP_DIRECT` flag and the `tbid` is set to an integer greater
then 0, the `tbid` field will be interpreted as the table ID to use for
the fib lookup.

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
Louis DeLosSantos (2):
      bpf: add table ID to bpf_fib_lookup BPF helper
      bpf: test table ID fib lookup BPF helper

 include/uapi/linux/bpf.h                           | 17 +++++--
 net/core/filter.c                                  | 12 +++++
 tools/include/uapi/linux/bpf.h                     | 17 +++++--
 .../testing/selftests/bpf/prog_tests/fib_lookup.c  | 58 +++++++++++++++++++---
 4 files changed, 90 insertions(+), 14 deletions(-)
---
base-commit: fbc0b0253001c397a481d258a88ce5f08996574f
change-id: 20230505-bpf-add-tbid-fib-lookup-aa46fa098603

Best regards,
-- 
Louis DeLosSantos <louis.delos.devel@gmail.com>


