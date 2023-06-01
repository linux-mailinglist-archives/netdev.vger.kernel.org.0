Return-Path: <netdev+bounces-7189-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DE7471F08F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:22:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 403FB28185F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EADB46FEB;
	Thu,  1 Jun 2023 17:22:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7361D4252C
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:22:01 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E44319B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:21:55 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b0424c5137so9705985ad.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685640114; x=1688232114;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vrEG1IIbwr19AZr+77mQEe861eSiCK0wTJKPiFGwI5E=;
        b=E8M+eE2AwpGB6oyPJthBkSKE6BPrvr2a+RQ88JFTrPvDZx8tTzSQIGcFiRXnO7jICm
         s+E+LTR/F4neFnHGpad9ruAsQVT414kGRrP8ycnwR/dyYfK+vHLXe2Zc0u1aouMuaii/
         Wg9dGk63bFKY766R7obst/0qp8Iy0tguVNQdPbXveMELKBP125q507KFH8E58GhLAzEg
         t8JC+RHxDqIqrVNA11KH+ZFKA4V2thgM9EPcLw7hCK7N3pWPnCehdYz84nWYgnseI6op
         n9wLr3JxIjnf9sbDDIdia8tpT9UTOewT71DHh26hoUWEyK5gDXLw4tMDCSjSV1VGRC/Z
         TyTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685640114; x=1688232114;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vrEG1IIbwr19AZr+77mQEe861eSiCK0wTJKPiFGwI5E=;
        b=dffg1XZsrSVloih3h2OQb011vCaqX4HcAtFVtC2xGLDLvtsHyN1K1eQL1pNrHonyoo
         6IwAhCFMCbQEHCQbssV8pVQL+gfP0jQ6oOGNxBQvXXd2TITp6jVsvI+GgJu1pYKvmLMF
         qcofWOmJUqcXgOuIMhWkH432sOHmDe8uWgv6tPrcpJHdoHjbsy/wPNlPJMqVxJ4CrS6z
         1qp29rMPgTkT/5bxQUM1l4uwqzJ3asCngcxvD+jdp7VhF7/ppVxhx5+HtPxI0CrGjhh9
         3dfhTeUQAHfPmPP6pmtG8rzLvG1b6aRX7jQLoVOmGZEEdPYQ3apmIyD0AUpzgbpB7IT/
         hBQA==
X-Gm-Message-State: AC+VfDw+nRKE66Po/HqwwclBzUe/yYpKE3D1MIsRrGXsMl7iImeQJTI5
	8AL+Nb//wsTS1AL+rCTKM4S1uFrV2+CBkSpRO1xhDg==
X-Google-Smtp-Source: ACHHUZ4qlDnQasblAqBx/I3qHRrQ9Jojc20JwbmRQXoroHJ7S/TCP2nPimu/CUCxbTohyAc/bQIYiQ==
X-Received: by 2002:a17:903:110e:b0:1af:bfb0:e7e4 with SMTP id n14-20020a170903110e00b001afbfb0e7e4mr4585plh.36.1685640114528;
        Thu, 01 Jun 2023 10:21:54 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902760600b001b1920cffdasm2378945pll.204.2023.06.01.10.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 10:21:54 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 0/7] localize functions where possible
Date: Thu,  1 Jun 2023 10:21:38 -0700
Message-Id: <20230601172145.51357-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is the result of using a script to examine where functions
are defined in one file but not used in any other file.
Found some dead code in process.

Stephen Hemminger (7):
  utils: make local cmdline functions static
  libnetlink: drop unused rtnl_talk_iov
  bridge: make print_vlan_info static
  rt_names: drop unused rtnl_addrprot_a2n
  ip: make print_rta_gateway static
  xfrm: make xfrm_stat_print_nokeys static
  rdma: make rd_attr_check static

 bridge/br_common.h   |  1 -
 bridge/vlan.c        |  3 ++-
 include/libnetlink.h |  3 ---
 include/rt_names.h   |  1 -
 include/utils.h      |  3 ---
 ip/ip_common.h       |  2 --
 ip/iproute.c         |  2 +-
 ip/xfrm.h            |  1 -
 ip/xfrm_state.c      |  2 +-
 lib/libnetlink.c     |  6 ------
 lib/rt_names.c       | 33 ---------------------------------
 lib/utils.c          |  6 +++---
 rdma/rdma.h          |  1 -
 rdma/utils.c         |  2 +-
 14 files changed, 8 insertions(+), 58 deletions(-)

-- 
2.39.2


