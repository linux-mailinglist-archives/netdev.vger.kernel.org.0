Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58770305D4C
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbhA0NdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:33:15 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:52029 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238423AbhA0Nat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 08:30:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1611754249; x=1643290249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=hMDIUrtSgDyNN38BObbiWgDkPYmz8L7X/oKmht5reJ4=;
  b=u4piFbLZlLNLZIlUkEYOkAgmOlG4ky33YW3gUe/uvic43Y+5ABMZvDgC
   HofDEM5ip2WEF2vfAYCOEtWJmseooHsdhZkBO5VgqXmeZ9vyUeUZYGalW
   Sew7jvSclypabkk8ud2Tv+Zhg+FmnHVJDiFX42KJkWmYzV4I5qPnrRoZp
   U=;
X-IronPort-AV: E=Sophos;i="5.79,379,1602547200"; 
   d="scan'208";a="115119220"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 27 Jan 2021 13:30:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id 87687100F80;
        Wed, 27 Jan 2021 13:30:05 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 27 Jan 2021 13:30:03 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.244) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 27 Jan 2021 13:29:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <aams@amazon.de>, <borisp@mellanox.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <tariqt@mellanox.com>
Subject: RE: [PATCH net] net: Remove redundant calls of sk_tx_queue_clear().
Date:   Wed, 27 Jan 2021 22:29:54 +0900
Message-ID: <20210127132954.13465-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20210127125018.7059-1-kuniyu@amazon.co.jp>
References: <20210127125018.7059-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D05UWB003.ant.amazon.com (10.43.161.26) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date:   Wed, 27 Jan 2021 21:50:18 +0900
> The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
> sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
> it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
> the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). However,
> the original commit had already put sk_tx_queue_clear() in sk_prot_alloc():
> the callee of sk_alloc() and sk_clone_lock(). Thus sk_tx_queue_clear() is
> called twice in each path currently.
> 
> This patch removes the redundant calls of sk_tx_queue_clear() in sk_alloc()
> and sk_clone_lock().
> 
> Fixes: 41b14fb8724d ("net: Do not clear the sock TX queue in sk_set_socket()")
> CC: Tariq Toukan <tariqt@mellanox.com>
> CC: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Reviewed-by: Amit Shah <aams@amazon.de>

I'm sorry, I have respun the v2 patch.
So, please ignore v1.

v2: https://lore.kernel.org/netdev/20210127132215.10842-1-kuniyu@amazon.co.jp/

Best regards,
Kuniyuki
