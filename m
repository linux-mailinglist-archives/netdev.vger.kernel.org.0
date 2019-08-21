Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69F59755E
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 10:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfHUIw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 04:52:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40759 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfHUIw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 04:52:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id c5so1065786wmb.5
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 01:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=Mh1QkTp/8kRIpEYY+6mzm9fBLUWPKfIMrbMeRlFQ5Vk=;
        b=dCuuw8qazVWlJrR5QGVGraJSUvizOCICo20mvjsZtxziMRpea2sPZ3lPOgrR1pl6iT
         FIiKElVsJsv4Mtn3mtGr8bR+nA9iAJvadPvjKrcuc5Bw6ImY5PAE2y8pg/Ez4oPVuKrp
         zrvFGzPrPBYIgCX/SnQyfHoxWdbFMCOEB5LOuA9RwLRFJJ39vuuQGRSHtT4R3/pdS7bk
         Ipb/eiqOM9RBoPAknsz/BdV2t18/uFiRa3OZdtBskR5fo5i212nIQKLkmg/OtPW+5aPZ
         iOMnB31ZQ26QHiqwBQMrSCQkudeibvjfb230A/RFbc56oLvegpf+jcWts6DrfB44WYtu
         9P5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Mh1QkTp/8kRIpEYY+6mzm9fBLUWPKfIMrbMeRlFQ5Vk=;
        b=Ae6QSWpGNFcQvj3aTAu9DKBY6JYedaXo9siAbxczsG7Ta9Nh2oplrhVaxNWgVB10wg
         aZw/myVPkyCRPQYtXYDN6zTlUPdlELcI5Cwe9Q398fPc+CBcoKSGSpGxInjOGMss4nYX
         hccCfsW63IYbZwtg8ZT3/djWepuasVBnDOf8wqTWupOa1gDJ85q4J/MVbGzFTerWPQHF
         TrAXklrWA6Wh3J2+KM52j0ctCIQzkN+m3jwKn8nJ+t++lwEGqwpSIkho8AyKpijtJ1d7
         UwhNkCTS8iM1iZyJgBHvO3MQz4kVL4xliBlJKOSIrRCzFmBBv2uSGxDM52M7QeiODZfj
         X6kg==
X-Gm-Message-State: APjAAAWLgCFDgSIPajWc9G0S6HLh1BzQiRzHVSrC9l39ay84/8mZee4D
        HS6xQSUfUoIKlvT02E+ZDWtQ0g==
X-Google-Smtp-Source: APXvYqxOpEYX6XapHM3cLUdsfVg2aAOhgFYN/HV7FoUtDTjc2rhCPmJk4cuQMmxBS4vTJcNC0M/wgA==
X-Received: by 2002:a1c:61d4:: with SMTP id v203mr4914481wmb.164.1566377546397;
        Wed, 21 Aug 2019 01:52:26 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id p7sm2040165wmh.38.2019.08.21.01.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 01:52:25 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 0/2] tools: bpftool: work with frozen maps
Date:   Wed, 21 Aug 2019 09:52:17 +0100
Message-Id: <20190821085219.30387-1-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This is a simple set to add support for BPF map freezing to bpftool. First
patch makes bpftool indicate if a map is frozen when listing BPF maps.
Second patch adds a command to freeze a map loaded on the system.

Quentin Monnet (2):
  tools: bpftool: show frozen status for maps
  tools: bpftool: add "bpftool map freeze" subcommand

 .../bpf/bpftool/Documentation/bpftool-map.rst |  9 +++
 tools/bpf/bpftool/bash-completion/bpftool     |  4 +-
 tools/bpf/bpftool/map.c                       | 64 +++++++++++++++++--
 3 files changed, 71 insertions(+), 6 deletions(-)

-- 
2.17.1

