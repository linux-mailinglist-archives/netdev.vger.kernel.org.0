Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6444316232D
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 10:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgBRJQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 04:16:07 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53227 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgBRJQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 04:16:07 -0500
Received: by mail-pj1-f66.google.com with SMTP id ep11so741681pjb.2;
        Tue, 18 Feb 2020 01:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qRNGDEmelSQozeh3us/5sKCRwYIHWUucXyEfNoy+2NI=;
        b=t6HXTR6h40ojKDk6zYa5tI2W9qaRdhtM5VpFHADwR34Qiqrkyk6Uqpn46pmfGU7cxM
         ScGOWx/osOi3YiqgiAWCbn7eJBhxVF7iID7/ot2+duTx8kETRbTuxPg5cL3OAUNNzUlF
         KruNVcCshDufSKZP8w3CABwrfn3ch8oZo+3MYcSUHK+u91RSxWPmhZgfR8YUWsoC3tYt
         EprWvYm8ogvqKBJZiNkvRqGMA4YAgF5GeGthQLshaiLvEiIY1eHaLvnoXkktAQfIzfVi
         ALTqPWcmXfjYSRfZAGw2ZWFpNaMo8GBhvl8PHxzXeMcX0Me4FKw69GGN8RFPSuT/3Va1
         2uBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qRNGDEmelSQozeh3us/5sKCRwYIHWUucXyEfNoy+2NI=;
        b=A+eOwqFM4tFALpneO4waxgNRGmEe9XvVTHH/zYrWCRAEq+LvweRThlEcQBY6djf2kV
         3rVBfMnz6kOqEL9nd/DtOXQ3BOy0dEw9E5XvAhCYrOAAYMEgRsY19NDHRNf/YiWIbG6H
         W5KpdnSykKShHUXYtPcrkMs/07f36rQ+MPbkKfLJIdsNDqiLW70TzAE5Yj+OjnwBo8QB
         Y9F0v054+t7Ukt+S3nn5Jqdjl/4KQBIHWJa9wrX/Tmeha58st9S9Pl9w6GRo4ltphFCq
         ZOR8mdShKYmWkUhkemGO8aZa1+LY1kPQsCyYPhcGkb+/jcnPouAnqKACHSBgySpdO3Mr
         eCPw==
X-Gm-Message-State: APjAAAXxrvYTX16/xX4GejwnxQGNfx24Mup4MrpNY9JdVvA0KVYczAg/
        z0RUhYD0Q2tJDZOOZgq6JDkdbjnplirzDw==
X-Google-Smtp-Source: APXvYqzg67Vy5jN1HHip86z4nDMoK9WgO1MQsjAQL1zYmqdK4SjB39+OHZaqrdvohO4RGIxl4bWDDQ==
X-Received: by 2002:a17:902:9a08:: with SMTP id v8mr18634698plp.251.1582017366249;
        Tue, 18 Feb 2020 01:16:06 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id h191sm1992110pge.85.2020.02.18.01.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 01:16:05 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH v2 bpf-next 0/3] bpf: Add sock_ops_get_netns helpers
Date:   Tue, 18 Feb 2020 09:15:38 +0000
Message-Id: <20200218091541.107371-1-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200206083515.10334-1-forrest0579@gmail.com>
References: <20200206083515.10334-1-forrest0579@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently 5-tuple(sip+dip+sport+dport+proto) can't identify a
uniq connection because there may be multi net namespace.
For example, there may be a chance that netns a and netns b all
listen on 127.0.0.1:8080 and the client with same port 40782
connect to them. Without netns number, sock ops program
can't distinguish them.
Using bpf_sock_ops_get_netns helpers to get current connection
netns number to distinguish connections.

Changes in v2:
- Return u64 instead of u32 for sock_ops_get_netns
- Fix build bug when CONFIG_NET_NS not set
- Add selftest for sock_ops_get_netns

Lingpeng Chen (3):
  bpf: Add sock ops get netns helpers
  bpf: Sync uapi bpf.h to tools/
  selftests/bpf: add selftest for sock_ops_get_netns helper

 include/uapi/linux/bpf.h                      |  8 +++-
 net/core/filter.c                             | 19 ++++++++
 tools/include/uapi/linux/bpf.h                |  8 +++-
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 11 +++++
 .../testing/selftests/bpf/test_tcpbpf_user.c  | 46 ++++++++++++++++++-
 5 files changed, 89 insertions(+), 3 deletions(-)


base-commit bb6d3fb354c5 ("Linux 5.6-rc1")
-- 
2.20.1

