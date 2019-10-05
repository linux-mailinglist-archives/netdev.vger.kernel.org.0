Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED07CC8BE
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 10:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfJEIZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 04:25:19 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:36570 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJEIZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 04:25:18 -0400
Received: by mail-pl1-f179.google.com with SMTP id j11so4272320plk.3
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 01:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mE4UYQ2Gp4sWl0Zmz6q0lZkQgHGi5X9cZvr5ZyNMlhw=;
        b=ej8Q0sCBhILEqW8GHB7Flw7zlA5yHAUNWnHmAasEqYEq0i45evjsLc1ie4/FvS5D02
         OUg0pdGi3NoKFMXc4qS3O/G49JR4FjyFQt7eHaWmGgrN4vzJS8E8K2w2Plnk6TcC7zFH
         gARpnssxpdThjQXHN7H6+Y8X0x137F5fCwhm/0RUwPkQpZrFO9aKbzRwlDkQLKwxmjjh
         mi91UE0JoVHqGUnDn1N/TenaZmsArg93mfpghczCT/xQYFuH1HKV8n7sye6/OE9RmrFZ
         L6BRwbqSwFsy8Ej9vPebckgwtW10tMPWfZYu/G5rhXDZ8CUT7GqZOu5XkhLzKUAqhAhF
         C4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mE4UYQ2Gp4sWl0Zmz6q0lZkQgHGi5X9cZvr5ZyNMlhw=;
        b=olc8Pea8nEj+EPL7ncAEaM+NhAl0sIaprf7PdZnSOy2fgeByKSHl63Bs2FdyVoXSSF
         LaKPuivye14TFnD5WNSogQfu1GbD7/ToI5kPppO5h9rX08JMTf4Dfy3LroonoL2sr3ZI
         j6OkZh9dNB8Vgn4qiD/EVGfcjzQSnWXH/wAD6vgUOeIX9rp4xNPP+Z/+6WumWxj8yNjq
         PTU3Yr8ifGluXlNYm1+nzcAnZF17JzTlAZtwki/sWsq55NGMzXqVohwWVQTWL+HrSqOa
         3OFqcJ0Sl+8Cn59qNOX7B0pDNIPq7fkvjOKq3/jbKX7rq7io9QG2LF5IVwgX4xhoG19O
         Y4Mg==
X-Gm-Message-State: APjAAAVcrRwCucvabBU1+61CkU1nCQXFcNgyk7BwrTNkXeFVhko5ybm6
        t74cWfQCGkE+w9XZrYUYrUANeMRt3dBD
X-Google-Smtp-Source: APXvYqx10v+AviRlD0te3dndbw7n2SusBeT/XzQHo5sQWk7Vjb7FZfa8wksBC9s1mIsKOoISE4q5mQ==
X-Received: by 2002:a17:902:a515:: with SMTP id s21mr20041424plq.259.1570263917605;
        Sat, 05 Oct 2019 01:25:17 -0700 (PDT)
Received: from localhost.localdomain ([106.254.212.20])
        by smtp.gmail.com with ESMTPSA id dw19sm7161838pjb.27.2019.10.05.01.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 01:25:17 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v5 0/4] samples: pktgen: allow to specify destination IP range
Date:   Sat,  5 Oct 2019 17:25:05 +0900
Message-Id: <20191005082509.16137-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, pktgen script supports specify destination port range.

To further extend the capabilities, this commit allows to specify destination
IP range with CIDR when running pktgen script.

Specifying destination IP range will be useful on various situation such as 
testing RSS/RPS with randomizing n-tuple.

This patchset fixes the problem with checking the command result on proc_cmd,
and add feature to allow destination IP range.

Daniel T. Lee (4):
  samples: pktgen: make variable consistent with option
  samples: pktgen: fix proc_cmd command result check logic
  samples: pktgen: add helper functions for IP(v4/v6) CIDR parsing
  samples: pktgen: allow to specify destination IP range (CIDR)

 samples/pktgen/README.rst                     |   2 +-
 samples/pktgen/functions.sh                   | 154 +++++++++++++++++-
 samples/pktgen/parameters.sh                  |   2 +-
 .../pktgen_bench_xmit_mode_netif_receive.sh   |  15 +-
 .../pktgen_bench_xmit_mode_queue_xmit.sh      |  15 +-
 samples/pktgen/pktgen_sample01_simple.sh      |  23 ++-
 samples/pktgen/pktgen_sample02_multiqueue.sh  |  23 ++-
 .../pktgen_sample03_burst_single_flow.sh      |  15 +-
 samples/pktgen/pktgen_sample04_many_flows.sh  |  22 ++-
 .../pktgen/pktgen_sample05_flow_per_thread.sh |  15 +-
 ...sample06_numa_awared_queue_irq_affinity.sh |  23 ++-
 11 files changed, 244 insertions(+), 65 deletions(-)

-- 
2.20.1

