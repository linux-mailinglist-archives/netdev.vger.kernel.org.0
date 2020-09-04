Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A26D25DF7D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgIDQNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIDQNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:13:32 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10CBC061245
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 09:13:31 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id s13so6549122wmh.4
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 09:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5XwKJJOulBS/JAQ5qjXcGoOA/EcC/1Cru3JfpZwCM8U=;
        b=B3kUqCvQoH9U1ob0b6+LpDyQVAUts8lGfQL5uJk6M4kWxxSqUmULquNpEUJ/bDEg4w
         woPVuoh7kefsdaZsiIXqgrLccCmjLkOzwGVuXVzw2qVPrkKztuWLSbwlLn40D9R+xbmc
         LOSrM3i+ok4MQZohzYtthpPW1EnH+davEwmrA0RXUvuhwaKRQcsZTYmx7sCk6xDEmSgk
         lMiE6gmaENa+ob7l8rMsfXjoQ78yVVs1M33SbOJt2KDijqAFAWPk5UVP7FRT8Bkwgk5e
         +h0fwjvgQbQHuJHqIKNTH0woAv5dWgrSJ5uj6EhqToHEL4ZWj430Memy8E6TAVmay60X
         KjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5XwKJJOulBS/JAQ5qjXcGoOA/EcC/1Cru3JfpZwCM8U=;
        b=RumcJfjVrEMLdfef106zBZhgUgyGlZs7utOlNoYvxsDzHNogdGoSTHL2g4K/GUv/HU
         T5mryweAy5UadCYESehSiG99qUstB5uDSwVE/YLQBdDQwEzcZFyjfZCNRuTgE27CBZ/K
         O+C2Iq2tVoWV0bi67jAFH5ulihk4gHFpJ8rTwahY/ww8GtaZDR0sl8uoBDHci5uAxGir
         O7oP8asKYeUCY3h0NIWo2mM7C50k32U5fKMsLlTgmt4hc9+y4+kyTgrFQBd7B0RuWSUx
         EV6C13Ox80UbLBbLtlA9h2sFoQVoxlclORWP2vGkUcsRlkEs9JBVkB5+o5Xf0UBzaV8J
         rjTA==
X-Gm-Message-State: AOAM533d052PMVu/CDZYYVwOGIsrABp8kQXFQun06kIcuXFWVzXl1hjq
        VPEKHXXKCPNL4pLQcTO4566yjA==
X-Google-Smtp-Source: ABdhPJynph/2MaDoBgxX8x5WrKlgpTKOTsczn63kHdmbh9hEfGNMNxjE9RFqSLDhDp9w92mBDQNnog==
X-Received: by 2002:a1c:7d55:: with SMTP id y82mr8399491wmc.100.1599236010376;
        Fri, 04 Sep 2020 09:13:30 -0700 (PDT)
Received: from localhost.localdomain ([194.35.117.134])
        by smtp.gmail.com with ESMTPSA id a83sm11909611wmh.48.2020.09.04.09.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 09:13:29 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martynas Pumputis <m@lambda.lt>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/2] tools: bpftool: support creating and dumping outer maps
Date:   Fri,  4 Sep 2020 17:13:11 +0100
Message-Id: <20200904161313.29535-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series makes bpftool able to create and dump the content for outer
maps (maps of types array-of-maps and hash-of-maps). The modifications are
rather succinct: dumping works if we remove the related restriction in
bpftool's code, and creation is just a matter of passing the relevant
inner_map_fd, which we do through a new command-line keyword.

Quentin Monnet (2):
  tools: bpftool: dump outer maps content
  tools: bpftool: add "inner_map" to "bpftool map create" outer maps

 .../bpf/bpftool/Documentation/bpftool-map.rst | 10 +++-
 tools/bpf/bpftool/bash-completion/bpftool     | 22 +++++++-
 tools/bpf/bpftool/map.c                       | 52 ++++++++++++-------
 3 files changed, 62 insertions(+), 22 deletions(-)

-- 
2.25.1

