Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B9130D3E0
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhBCHIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbhBCHIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:08:50 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF20C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 23:08:09 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id i187so31792498lfd.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 23:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pBNwye1ZzNGbo2gbwaiwc2i9Z/W+Go8mYjLFfkSwhFQ=;
        b=JquohwMMnFIo9kQ8MhQrtGzpzrSJCV1QrNfBSZd20vs7uYnBNSDw5JA4ZXtc/oTMXb
         Bx/t3wNqQVXK4BQC6rj3ZRy4jB/q8hO0QHVs25t3b7mv/1raMpJpPPh0TUXEzhcODnk0
         jRyZzVFmmJjt4GqgQopTUpuJyIzHyvsLlpapp3Wc+3I53W3UUG/aXC5ewqrNUa1BT31t
         Same/0g7M2JPlS/bMPO3PuyueRUaGIHBowYUu76KGeGOc7ZE3MOU/QS2IDFDXAdwthBi
         lnz9/Vrnjfnpo9A3ntAS/uzRMhEpKJUrmGhQfBW82balJGczaKf/qvfaB39UN8IkTkRi
         hu4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pBNwye1ZzNGbo2gbwaiwc2i9Z/W+Go8mYjLFfkSwhFQ=;
        b=YipdGPfCZDvjACxcF3WlF2j7FHjrYHiaHd8Y/yDP6/rdgTjjsQ7zw+FR4SM9nadQmc
         lYVVd817pWPt0zsml4xQL//3Yq/8BQXnTcXEeZOQbrm8Z3IsjWoEeaPPazqKStBpnqBJ
         I/z0ve/4f0j47pHd9l3rckUXMlTUFetiYUeX9rCjoO99RZf7GCfhusdA+N/RTmVgyg4w
         o8isIn+C78FK4PfgCZqmv+p42gPbg4R+KGVfDZ6kIgauzj9k5Lydn9XJrxKy8LSbJAjq
         gOcisg+YS3J5XXf0nGb8wCqZ34zQ6kkljnbjcGR3/Cknq76necyGsDYescvVOgByX95A
         CEtA==
X-Gm-Message-State: AOAM530dbKz6/Du3KhpSV9wQtHYDhHrsnc0+i1t1/Gtke3s24jt5xp1p
        riKIhVhCo5NIFuKwPnp6i9UM6Hk09o8Uug==
X-Google-Smtp-Source: ABdhPJyV5oAM36P3RllRRhb+R/MheaPZkkHDm36nlx0o44N9bsYdbuXqo8p79gBjNEs6ZUM0PNJPTQ==
X-Received: by 2002:ac2:4a6d:: with SMTP id q13mr767957lfp.485.1612336088179;
        Tue, 02 Feb 2021 23:08:08 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id d3sm147367lfg.122.2021.02.02.23.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 23:08:07 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 0/7] GTP
Date:   Wed,  3 Feb 2021 08:07:58 +0100
Message-Id: <20210203070805.281321-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202065159.227049-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's ongoing work in this driver to provide support for IPv6, GRO,
GSO, and "collect metadata" mode operation.  In order to facilitate this
work going forward, this short series accumulates already ACK:ed patches
that are ready for the next merge window.

All of these patches should be uncontroversial at this point, including
the first one in the series that reverts a recently added change to
introduce "collect metadata" mode.  As that patch produces 'broken'
packets when common GTP headers are in place, it seems better to revert
it and rethink things a bit before inclusion.

Changes in v2:
- fix fallout from "one rebase too many"

/Jonas


Jonas Bonn (7):
  Revert "GTP: add support for flow based tunneling API"
  gtp: set initial MTU
  gtp: include role in link info
  gtp: really check namespaces before xmit
  gtp: drop unnecessary call to skb_dst_drop
  gtp: set device type
  gtp: update rx_length_errors for abnormally short packets

 drivers/net/gtp.c                  | 544 +++++++++--------------------
 include/uapi/linux/gtp.h           |  12 -
 include/uapi/linux/if_link.h       |   1 -
 include/uapi/linux/if_tunnel.h     |   1 -
 tools/include/uapi/linux/if_link.h |   1 -
 5 files changed, 160 insertions(+), 399 deletions(-)

-- 
2.27.0

