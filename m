Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CFD11DFF0
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 09:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfLMIxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 03:53:19 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:33878 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfLMIxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 03:53:18 -0500
Received: by mail-pj1-f66.google.com with SMTP id j11so927119pjs.1;
        Fri, 13 Dec 2019 00:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5oY1rqk+s+7aBLz/dZvUHs7HYCiQ4df/073CxfwEJWw=;
        b=FYkW1EelULsxFhSYPgkyEZmE1OY/idDcWxrT/GnV35Ln+egQzRnQgNwS9XbgIqpYXs
         ofQsc+ecmN1Ayvn24hXdA+Amw4rHw4L5OzRrrPeBIyUBYjeg3Ai/04xKfsuqczXCMmSv
         0AlBSsf1n2QWmG0YI6yeytYDf9x7n0u9yMyidkJXQjTX3xCFyPVH5AQHPIYdPcr7FE3Y
         bxVeFbYbcblkxkuOfOb/BfAuudtym9rG3WEEaSg3W5YkMTOXAtFEHJkIFrgbZi6bPPW2
         dQ00r5YGUaDz6bzBegDVuMpzAskT/+0jF+t0hRsh+aIj0CIVaq5C4vvFrjkb4APIAPrt
         LjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5oY1rqk+s+7aBLz/dZvUHs7HYCiQ4df/073CxfwEJWw=;
        b=cM9MyG5scuQx7X2+Czk7mI6u2HrWXGfsDsZRddgLoPxXTGjj14nUVin+Hf29xieauk
         JKk0moBZKQPy9Q5ETXoqKQeXk2Uf1ma4YfXcvSh4yR1/Y22KMlQcqCMgFdSpaYeNmEKU
         +cD4NH38Hbts2t5m7Pf+Il4jZJPnVKGDQeeiX4s3a4b50bxFit39T61j3lUmlFUOUOOZ
         lhvPn9P4M9LRCssFnnqDXtH9sfpbN/XgPEe/Br+JghYrx5LCf7y1SePMBf/5ODVRTnWB
         m441JVtqZ2GIcbaaT/4rezJZT0guPBkQksGLgJn7UHmb7wjIopNd5H+Gcce4YFUoGHzF
         XGag==
X-Gm-Message-State: APjAAAXYcmOfUsO4SQadySsTpx1VxTUbBjWyUyvVV8S2LR9hDTte99DU
        8nxomrYJxIH8AoJfL9AxJGf8DyK9
X-Google-Smtp-Source: APXvYqzkYHS24F1L3QIce2xHnRyrdVX5+gYQNkza1eMkBHejdjinzx7P8P3wlNhTdKuzZRSR/lVTWg==
X-Received: by 2002:a17:902:b788:: with SMTP id e8mr15082896pls.1.1576227197796;
        Fri, 13 Dec 2019 00:53:17 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q22sm10516829pfg.170.2019.12.13.00.53.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 00:53:17 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCHv2 nf-next 0/5] netfilter: nft_tunnel: a bunch of fixes and improvements
Date:   Fri, 13 Dec 2019 16:53:04 +0800
Message-Id: <cover.1576226965.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds some fixes and improvements for nft_tunnel.

Note the patch for adding support for geneve opts in nft_tunnel
will be posted in another patch after this one.

Xin Long (5):
  netfilter: nft_tunnel: no need to call htons() when dumping ports
  netfilter: nft_tunnel: add the missing ERSPAN_VERSION nla_policy
  netfilter: nft_tunnel: also dump ERSPAN_VERSION
  netfilter: nft_tunnel: also dump OPTS_ERSPAN/VXLAN
  netfilter: nft_tunnel: add the missing nla_nest_cancel()

 net/netfilter/nft_tunnel.c | 52 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 13 deletions(-)

-- 
2.1.0

