Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB2B86ED7
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 02:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404550AbfHIA36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 20:29:58 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38727 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHIA36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 20:29:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id m12so5618556plt.5
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 17:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nwc+/eulLtW+0PxrVdtpTBuhicTvT8IdNuzaicrktfs=;
        b=JVJ1vUJCzCs7vNTK22zkJ8pOK/fKd41O90s8BNDxUlOqG72+tlKOoYwGZt4TIhXm5G
         uQ1psO7g2tE1jUgWf2MNxDVB0iqXmQiLVDNOl25ZGclv6WWmPxRtykRppBT0Q9JrPV+9
         K4bLH1vCr+MG/T+nrbZ162ULnIwH6kZOTpVwRIczmozP85LPF/Uus0PIJNGyTMZTWmL/
         Hba2+E2i1lF8LA5BInkYWslDWyO83bv2qKoNqLet0FTLmFyZyso2Asr3Fq0VlSTNkp64
         J8yTdDhGA7r3ABf5gJC1TDzGEWdBYUfe8E3ED8wKGKV3Tqd3fqeV4GNhoReQFwME9IPk
         yEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nwc+/eulLtW+0PxrVdtpTBuhicTvT8IdNuzaicrktfs=;
        b=gBYW7Uu55q2qEWgDQ9TRDiMuSVsuM1OfmcINFwLE9MmQHVkgV0m34sPXHU+22reofI
         y+b/S2As0qhX9JsOvX9rEhYJu0LJK9r/A6qMNhAIWxvYib/VZ4bb/AuW1n+Bsws1aIPH
         EQju3IFMxSyH2jF6j295cwQ3wVMiHknl5yX+itDaUWK05e7K0c+7vNskfMl1k6mpYzMY
         wIIvnGYqe5hznKtdVK/i72i4dEFBqyUDG9zB+GpLfmhvqRIbDTMTeduIXM4BxQmmytp1
         2v5cKVuBaEZSQK9pXU3fvGJFrmlNbsS2M60ElNaTvRSDQOwQx86rFjrJ3EDJIc48L/vN
         kAaQ==
X-Gm-Message-State: APjAAAUcg7WyPjjwXcFLVj2LS8RR7cJzMxdJq5PG+F7p21umi9HVyehI
        AeQV96R+JzW+fJNPJAoe4y1rhK2iDRgG+A==
X-Google-Smtp-Source: APXvYqxq+MhcaRthmzHe6t1h3wfk0Yvi46I+5JKof4ItnFurUtbFRDl4RVdRm+bL1VU2mfHV6+Hm7A==
X-Received: by 2002:a17:902:7686:: with SMTP id m6mr16384284pll.239.1565310597102;
        Thu, 08 Aug 2019 17:29:57 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 196sm103991808pfy.167.2019.08.08.17.29.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 17:29:56 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 0/2] Add netdev_level_ratelimited to avoid netdev msg flush
Date:   Fri,  9 Aug 2019 08:29:39 +0800
Message-Id: <20190809002941.15341-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190801090347.8258-1-liuhangbin@gmail.com>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set add netdev_level_ratelimited to avoid netdev msg flush.
The second patch fixed ibmveth msg flush when add lots of(e.g. 2000) group
memberships in one group at the same time.

In my testing, there will be the

ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table

error when add more thann 256 memberships in one multicast group. I haven't
found this issue on other driver. It looks like an ibm driver issue and need
to be fixed separately.

v2: add netdev_level_ratelimited as Joe Perches suggested

Hangbin Liu (2):
  netdevice.h: add netdev_level_ratelimited for netdevice
  ibmveth: use net_err_ratelimited when set_multicast_list

 drivers/net/ethernet/ibm/ibmveth.c |  5 ++-
 include/linux/netdevice.h          | 53 ++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 3 deletions(-)

-- 
2.19.2

