Return-Path: <netdev+bounces-1268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D60EC6FD171
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A988B2811EC
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55FD219939;
	Tue,  9 May 2023 21:30:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488821990D
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:30:43 +0000 (UTC)
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1BD7EF7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:30:14 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-55af4277904so98941057b3.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667724; x=1686259724;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WIZ4sUcXRVUtvrinFS4f+gOFripHVIhMPbqIDwh9EAY=;
        b=H+/KBo2dcN5yLJi0vA0uAhS30bF20x4qvXTACF2j//D6gmgz7ZTkooe0OumWX9yIFU
         QkbC87C/0yVpfiYmJKfHtNQz4eXY6GBlrGIjtZbC3lrv+QNbv32s3I1BJG4Dj2IjkvSX
         pUIsZBokxXxnDruxDAyjnCSAd0jYgzIUVwbhzY3+Kov4t+pUSYKnVVYT1I3WFnwzAmpl
         Zju6gGZHyE9e5P04W26d8YwsTZKknqULnm0Eal22BX2BkOFZtKDOSEq9EAN2whfiBEwp
         sEd7nvwAleMSpJdvN6eJ47T7/1ZdNOL0+HcxeKfn9NfKkth0dqNi66A70y1Y6AP6gGkr
         uG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667724; x=1686259724;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WIZ4sUcXRVUtvrinFS4f+gOFripHVIhMPbqIDwh9EAY=;
        b=RqNTbB6eL71Nm7E0cq8pONclbrt892W5u7PDD8SdL5CcgiuxZsryfM6DWKFXTfNe9Q
         5sjt0eZw4Spl8WdQV0L9wtMo/TJmwtzntsqBMPQMccOvIrHczESwOCiDhqk82Sl5kJ6M
         7bLIFuGHCsHPRCc5n55lFXv4c9C0sVEyvVlXIwLsX72OCvaQVpBvtnWNoehsedDlLObv
         hSoSdZIG9xil/BytO8Wn2YP/IhKjN0Q2vI0fK5rRCNyK0NcGhIRnBVBkq9iY505zsNRL
         ia5Nr4DVkocUPYlU8DLbVl7jcGNkzt42tIy97REXzeXENz05bVFBD13u2l3rdAQhESAZ
         T7WQ==
X-Gm-Message-State: AC+VfDyksZ8uJUh/D2GDKzlvMo6YXj9yKTbJM8HAPOe5jzTxNVAXSVic
	L0YV+cz39vQBoujBNEAu97CC0ZlePvF80gQ8IddGBA==
X-Google-Smtp-Source: ACHHUZ61jE5ikjecXBduPMXfT1Jw6jsiunMWI6HNkNNXrt1gTq3RoixxMGjm/dSek1cUN+LdcOgFkA==
X-Received: by 2002:a05:6a21:6d9a:b0:100:607:b997 with SMTP id wl26-20020a056a216d9a00b001000607b997mr12779642pzb.49.1683667288320;
        Tue, 09 May 2023 14:21:28 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:27 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 00/11] fix analyzer warnings
Date: Tue,  9 May 2023 14:21:14 -0700
Message-Id: <20230509212125.15880-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Address some (but not all) of the issues reported by gcc 13
new analyzer.  These are mostly just issues like not checking
for malloc() failure.

Stephen Hemminger (11):
  lib/fs: fix file leak in task_get_name
  ipmaddr: fix dereference of NULL on malloc() failure
  iproute_lwtunnel: fix possible use of NULL when malloc() fails
  tc_filter: fix unitialized warning
  tc_util fix unitialized warning
  tc_exec: don't dereference NULL on calloc failure
  m_action: fix warning of overwrite of const string
  netem: fix NULL deref on allocation failure
  nstat: fix potential NULL deref
  rdma/utils: fix some analyzer warnings
  tc/prio: handle possible truncated kernel response

 ip/ipmaddr.c          |  9 ++++++++-
 ip/iproute_lwtunnel.c | 18 +++++++++++++-----
 lib/fs.c              |  4 +++-
 misc/nstat.c          |  6 ++++++
 rdma/utils.c          | 10 ++++++++++
 tc/m_action.c         |  4 ++--
 tc/q_netem.c          |  3 +++
 tc/q_prio.c           |  2 ++
 tc/tc_exec.c          |  4 ++++
 tc/tc_filter.c        |  7 ++++---
 tc/tc_util.c          |  2 +-
 11 files changed, 56 insertions(+), 13 deletions(-)

-- 
2.39.2


