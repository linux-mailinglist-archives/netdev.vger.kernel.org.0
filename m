Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FB32EC2F1
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbhAFSFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:05:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhAFSFL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 13:05:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B841216C4;
        Wed,  6 Jan 2021 18:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609956271;
        bh=QyzlEeyzOKBJYplkZEm1KjD0/rovQ4zA0UbRSdI2Bzk=;
        h=From:To:Cc:Subject:Date:From;
        b=B6ryxblwWHy8tuyYKGRPEau54jY0cRCa3PcfMLwy7vgwYdCeQXtGCutBXfgl6ny1V
         WPvLu2p/qB9eStReXtHpnutEV213JmmY8hRvnA1VZY25OiGtrgjd7bG53i1shQIo6e
         GSfYYbfS+ecIGRBJj+H0GE8L4JWSCvJ9OJNlYsjMYKb8AdYKXNm9X1fqiU2TAoKw8k
         xoz/Irk4L+mb0389HK/zcdMm13LVEWgUaucf6YnkaMYRWG8OtmFRfetoi0Apyr60dv
         pHhhLnsRw0oGZfKnJdoSz6+rBLvKSfPqa+5xZ3J8f3Ntt0b9qjEKsllkj3+Drqhubu
         7wZAuYgn/q0nA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net 0/3] net-sysfs: move the xps cpus/rxqs retrieval in a common function
Date:   Wed,  6 Jan 2021 19:04:25 +0100
Message-Id: <20210106180428.722521-1-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

In net-sysfs, the xps_cpus_show and xps_rxqs_show functions share the
same logic. To improve readability and maintenance, as discussed
here[1], this series moves their common logic to a new function.

Patches 1/3 and 2/3 are prerequisites for the factorization to happen,
so that patch 3/3 looks better and is easier to review.

Thanks!
Antoine

[1] https://lore.kernel.org/netdev/160875219353.1783433.8066935261216141538@kwain.local/

Antoine Tenart (3):
  net-sysfs: convert xps_cpus_show to bitmap_zalloc
  net-sysfs: store the return of get_netdev_queue_index in an unsigned
    int
  net-sysfs: move the xps cpus/rxqs retrieval in a common function

 net/core/net-sysfs.c | 179 +++++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 93 deletions(-)

-- 
2.29.2

