Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2322B16B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgGWOeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgGWOeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:34:04 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B673CC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:34:04 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d27so4523804qtg.4
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QZ6OfSVhQYp7m+z607Xbp7gqVtmOkbC+x/W10V76rN0=;
        b=hMBmpa/NZSYOrWspBLZ2U1elMnqtFpeH0nkw+Cjs3YZb0Gpt5PY1GjxigH5YSPMH2e
         b9/5WnJCRu/xoC3yvD+K44yeWWonLMjMupFCQP3kMbJXaPssX61vJTck1jfYuQovUkl+
         AhrwJz5yxBcCX1rt7FVkccoq9gX38S3ASI1TYSzOR0SA8ROMiGvhxmnUlxA8AK3vSTYf
         ilYEgzD4HtON+0afIhUeECT9khnRRDzRP5YTyaaWk15yZcwP9p8ZO/PvUK7gUyFI7v0n
         4sY7DFusRNS0MdP3RdNP0b8mhd/lQwgxDqSEI37lJhxZyRU7AzwY+LON8Nl84AsP0qCV
         cKPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QZ6OfSVhQYp7m+z607Xbp7gqVtmOkbC+x/W10V76rN0=;
        b=R/ymndYaYQO4Xoq1YtEpdxJjCsLHOpCq3iWAR60lrpdh8UqOF1BusnX4Ha/oZsqB/I
         r8sVFu/zppPPs7JLyHCmeB2TBhTqnJ69Jxxpf4czFfkzez0FMHV/Sjsg8NvvCfzMEWku
         9M4f2H9Qg9KyOizOUtdvnz6uZYMBvL/BAYpHcKngXDr+PomhJqSa48ttW5q8XMPK/qAC
         p61gdikIpSBl2ga95a90q24DL53F9VzM5mvlSMRqTfRG0WE+RP/AekkwJSV8X3wsLcWX
         +YIoi6p586YWUB8scgZGinYoRdDzIwAkXEAcTpfvAlg6AsO2ubLfs/pePXvaEHD6VqTb
         gWzQ==
X-Gm-Message-State: AOAM531p1fh5CwtlPGIw5JZ6MubCi871qpSB2B5jwqAFKTxZ23an5cio
        1xleiRY67wByJBJxVwLSvtGRV24K
X-Google-Smtp-Source: ABdhPJz55aVsgBuyrViDPyoxqVqeCyHu2OMR5QJmudjxJ3ZKDUb0BPL5uddAwLwu/i1CFOHHvUiLSg==
X-Received: by 2002:ac8:24c6:: with SMTP id t6mr4703575qtt.39.1595514843488;
        Thu, 23 Jul 2020 07:34:03 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id w27sm2488114qtv.68.2020.07.23.07.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 07:34:02 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next 0/3] icmp6: support rfc 4884
Date:   Thu, 23 Jul 2020 10:33:54 -0400
Message-Id: <20200723143357.451069-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Extend the feature merged earlier this week for IPv4 to IPv6.

I expected this to be a single patch, but patch 1 seemed better to be
stand-alone

patch 1: small fix in length calculation
patch 2: factor out ipv4-specific
patch 3: add ipv6

Willem de Bruijn (3):
  icmp: revise rfc4884 tests
  icmp: prepare rfc 4884 for ipv6
  icmp6: support rfc 4884

 include/linux/icmp.h        |  3 ++-
 include/linux/ipv6.h        |  1 +
 include/uapi/linux/icmpv6.h |  1 +
 include/uapi/linux/in6.h    |  1 +
 net/ipv4/icmp.c             | 26 +++++++-------------------
 net/ipv4/ip_sockglue.c      | 14 +++++++++++++-
 net/ipv6/datagram.c         | 16 ++++++++++++++++
 net/ipv6/ipv6_sockglue.c    | 12 ++++++++++++
 8 files changed, 53 insertions(+), 21 deletions(-)

-- 
2.28.0.rc0.105.gf9edc3c819-goog

