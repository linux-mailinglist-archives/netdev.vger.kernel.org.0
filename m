Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C5625FFB2
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbgIGQgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730902AbgIGQgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:36:42 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7293EC061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:36:42 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j2so16415826wrx.7
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QWC8ABqOj9tnGBywTcIQeelbRdA8/0ZzqwQDNhLengM=;
        b=WuomelGJnWurYaBUF2nmtrnHY+KjbPYEBfz8tqpfeXDstSfVNlxEc5pAGGDjiEx4p8
         rwuIr/MS02JMRmUkl4w5HgrXGYTQoeyGlD4Yw7ipAtlTsE9vyiZ42bfQYdrbaC3NR1Xx
         pAS+fsQVBsrk0OkitURXQt2DlKp0z/P19z3OcLPh24lqpXmavlp6SnLpJBRrlUIxKfcY
         eOrPdEKgrPROdEz5mcoTcmUWRV56iAWx1o62pKATZsbqYEugPH0DWnZZRAVAkoYSsyTU
         ao5vMa7Fz4B/VggMIK3+pOvcNC/bWqmYCRyJzyWsaCbBeyLVsmJIX3nM9pVLtGfFLlG/
         MVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QWC8ABqOj9tnGBywTcIQeelbRdA8/0ZzqwQDNhLengM=;
        b=nmlmIlg5BlZAxwf4h4WjJNZ7h64P7zvlmaiNuDh2fx7hl+aLoeSHR5clkhp2yFyqWT
         dj36D0TnCNmozRu3oOuiWKKkoghUnDcc9T2qIIxeEkLLC+w+oo7JCFCxvROAGnWip7Mj
         FQi9JiPDxHtxUd7YKwrv9WND2gA83L5fakfo/aFjwi7RQqYhTFwMgC4hEfXKXVKMiHtz
         c+FOdQXagawOHXcETp74BA64xW5c+z8uo/MpleD5SCyBYJGOpTnirpy081bctXlPgCGe
         CpPgK9weMIA1IEhOl1R4WDMDzlv0QVpcy9RkpyY8pR2jc+cQX/xEfM02JhpC/TvUVCtE
         pOFA==
X-Gm-Message-State: AOAM531Ag+9lku4qaa1WXGvAlsoj/vBIua1DKRXorjoi+4YKzLSDIgm4
        mD17jPvl3MO0h/Q17qdlgK07kg==
X-Google-Smtp-Source: ABdhPJx7ybduonsODy8DQshJzntV5ZBDwmr061Tj42v2kmVoMKExLWWqKRntYKJq9qFKJwAKVTJyGQ==
X-Received: by 2002:a5d:60cc:: with SMTP id x12mr21913343wrt.84.1599496600562;
        Mon, 07 Sep 2020 09:36:40 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.17])
        by smtp.gmail.com with ESMTPSA id p11sm26443677wma.11.2020.09.07.09.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 09:36:40 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 0/2] tools: bpftool: support creating outer maps
Date:   Mon,  7 Sep 2020 17:36:32 +0100
Message-Id: <20200907163634.27469-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series makes bpftool able to create outer maps (maps of types
array-of-maps and hash-of-maps). This is done by passing the relevant
inner_map_fd, which we do through a new command-line keyword.

A first patch also cleans up the function related to dumping map elements.

v2:
- v1 was wrongly expected to allow bpftool to dump the content of outer
  maps (already supported). v2 skipped that patch, and instead replaced it
  with a clean-up for the dump_map_elem() function.

Quentin Monnet (2):
  tools: bpftool: clean up function to dump map entry
  tools: bpftool: add "inner_map" to "bpftool map create" outer maps

 .../bpf/bpftool/Documentation/bpftool-map.rst |  10 +-
 tools/bpf/bpftool/bash-completion/bpftool     |  22 ++-
 tools/bpf/bpftool/map.c                       | 149 ++++++++++--------
 3 files changed, 114 insertions(+), 67 deletions(-)

-- 
2.25.1

