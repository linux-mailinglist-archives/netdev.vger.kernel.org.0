Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC75E4A5127
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 22:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiAaVL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 16:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiAaVLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 16:11:54 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA067C06173D
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 13:11:53 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id p15so46962773ejc.7
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 13:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MdCZbv14Z5XAFJctoKNC66b5ZahRctJW82gWnIDWamc=;
        b=r/d/Y9rmQJxcKXCD/yTdCc3NTTLycDAMEM7xO/SFin+VVgZee5pNX2IIM6oJS9IvWA
         QA/mb20m6xJqXN9PivqEOLKLr6/IN7iCkIyIVdYnLnEzhOscRg/yL5WkMDwtm1PCCv4A
         uUmvXaf+o4KcRlsEcG+TS2l2lme8i0SqVgJ9KP5PwDaLESahYwanp8OSuALlWJSlk/u4
         ORzFwHq9/rpEplrDuYPaY5Lb9xRzV7skgXHOfssqhoSYAFWZgtP5jRuaHbbHBj/8AcDF
         oR7AplFDJ7i5Mfw0k9WRKHLz3yD1QtW04RmEgkl+pWCzMuPv5wShPvJeB6cY6oI6BYyk
         VdSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MdCZbv14Z5XAFJctoKNC66b5ZahRctJW82gWnIDWamc=;
        b=Ocfq62gGtX8KIibwdELOl9L/LlwOIIJc8MP0qeYeAKWV+DMU+/17bPkHNxXoG0MM90
         Hw9IM89E3FGuq5y0JQ1AmKUwrbRH91noeB8NX51ICZHjnLcaAJIhynQl03R4Vb9GwJIk
         NAf+ziqvB48GmQ1Vddex3tR/sTz8GD964w2n/D50gCpcKaj0XYx4qP6+dFquAbCmmaps
         ouvUM3A/+GnxleswL228H0AtZVR3L0bvSC4fonwDzTX8OxFNgafMIPwHTuXps8SiULh/
         wDs4vtRFU3SRFLcuBLIDCmT4Z2LUA7OeuNlXTYPnfzyQcS+SOskBLNQqaTzhxyV2Ie9L
         FFlg==
X-Gm-Message-State: AOAM5319KElEnTSH0IgbcjgBzjfMOiotmUEdeQ6PxvDtBoyJHTVmS2Js
        P8W4qRDCavEi+pB27d5E6Subew==
X-Google-Smtp-Source: ABdhPJw11DUBE5iuw3BvYGBoIK/5vPYE6RZ4MU4jwoa7TI8BdKRuViLL6bw7mP+i3mzi0orlMo3M/w==
X-Received: by 2002:a17:906:cc54:: with SMTP id mm20mr17787957ejb.313.1643663512531;
        Mon, 31 Jan 2022 13:11:52 -0800 (PST)
Received: from localhost.localdomain ([149.86.79.138])
        by smtp.gmail.com with ESMTPSA id v5sm13763947ejc.40.2022.01.31.13.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 13:11:51 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/3] bpftool: Switch to independent versioning scheme
Date:   Mon, 31 Jan 2022 21:11:33 +0000
Message-Id: <20220131211136.71010-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this set aims at updating the way bpftool versions are numbered.
Instead of copying the version from the kernel (given that the sources for
the kernel and bpftool are shipped together), introduce an independent
versioning scheme. We start at v6.0.0 - incrementing the major version
number - and the idea is to update this number from time to time, as new
features or bug fixes make their way into bpftool. Please refer to the
description of the third commit for details on the motivations.

The patchset also adds the number of the version of libbpf that was used to
compile to the output of "bpftool version".

Quentin Monnet (3):
  libbpf: Add "libbpversion" make target to print version
  bpftool: Add libbpf's version number to "bpftool version" output
  bpftool: Update versioning scheme

 tools/bpf/bpftool/Documentation/common_options.rst | 3 ++-
 tools/bpf/bpftool/Makefile                         | 7 ++++---
 tools/bpf/bpftool/main.c                           | 3 +++
 tools/lib/bpf/Makefile                             | 3 +++
 4 files changed, 12 insertions(+), 4 deletions(-)

-- 
2.32.0

