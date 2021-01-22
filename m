Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DB73007CB
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbhAVPuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729117AbhAVPsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:48:11 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39F4C0613D6;
        Fri, 22 Jan 2021 07:47:30 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id l12so4490682ljc.3;
        Fri, 22 Jan 2021 07:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9yOdGiSyAKRI4yhC6YNbu6P24qOwaii8uVvkwHJBwqk=;
        b=jR4rX9PQ7tH8aLb3fb4hBZ80siQswC3DPbeSXhpH8vXi9cBVcAv6u2WLNJIW5IZT/u
         20NsR/ixi5y+mebRw1clgxxwQFxFoRYbdhY8gQUGahpvMPXhrqyX9EKSNXqfSKXZWbD9
         9WsNgUbKR6Qco4CN0fx0Yb6qi20dB7ktpJdr7C4D4t20BeBfH6FMFbyoAHr2Z5eFNYev
         0E+Sv0RM33CwGvyBMO6bWkC2SCIcg9AEJgVGIjfnrfmwc7nYm2BeI7yvylS7UYP/9uGj
         LyoHmMDyXuD1HTnK38CbcfBHFbD87AWfuq+st8YNcdBpcGa0dfVL+ARKE1GJ8d5KwWDI
         MKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9yOdGiSyAKRI4yhC6YNbu6P24qOwaii8uVvkwHJBwqk=;
        b=OltFUs7I9+xhLwbXX6/njpHHCdGHR56nbayQK57qZDtWd9BbSyf037hvSRqmIEF+/D
         3E0aTsKklMWlszIbwH22b/U1BylfWVyAV7wox8ROqGxZleqjJM7HZQfH5KEowSMGRY3m
         Ob+QHcR6pcBSTYKVtjotI1rtWfJckotr2OACP1H/ddwYaa8h1jB4VE8S41z0nd1AaSyU
         vlQ8YfV6TEgPWMCTbb8+K9XM/ucFUH0K37I3O5CsA2GOzDFU72XQSEl8EMNIqcBODP0U
         GUPqPxbnkEOY2BrMPY3qcBD6RrtoW8QiE77ItDL+8qck3tJudIq1DbvDQhpf1EB5qwOi
         VURg==
X-Gm-Message-State: AOAM532DoxlU6nxtKlxlkVG4xc83AoGOU9EiqCIBx2GYzNWLhJan6dfh
        +cTs8Rl1JX6TaG/1t6FkoEiOpD+Oso2dLw==
X-Google-Smtp-Source: ABdhPJx0nuNzic/yAKnqJDW976DZKyzkjhXu/EY03E/192iVgtzBnMKdegTM/kBiXocCJ8lGN551+A==
X-Received: by 2002:a05:651c:30d:: with SMTP id a13mr435064ljp.238.1611330449484;
        Fri, 22 Jan 2021 07:47:29 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:28 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 00/12] Various cleanups/fixes for AF_XDP selftests
Date:   Fri, 22 Jan 2021 16:47:13 +0100
Message-Id: <20210122154725.22140-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is a number of fixes/cleanups, mainly to improve the
readability of the xdpxceiver selftest application.

Details in each commit!


Cheers,
Björn

Björn Töpel (12):
  selftests/bpf: remove a lot of ifobject casting
  selftests/bpf: remove unused enums
  selftests/bpf: fix style warnings
  selftests/bpf: remove memory leak
  selftests/bpf: improve readability of xdpxceiver/worker_pkt_validate()
  selftests/bpf: remove casting by introduce local variable
  selftests/bpf: change type from void * to struct ifaceconfigobj *
  selftests/bpf: change type from void * to struct generic_data *
  selftests/bpf: define local variables at the beginning of a block
  selftests/bpf: avoid heap allocation
  selftests/bpf: consistent malloc/calloc usage
  selftests/bpf: avoid useless void *-casts

 tools/testing/selftests/bpf/xdpxceiver.c | 219 +++++++++++------------
 tools/testing/selftests/bpf/xdpxceiver.h |   2 -
 2 files changed, 105 insertions(+), 116 deletions(-)


base-commit: 443edcefb8213155c0da22c4a999f4a49858fa39
-- 
2.27.0

