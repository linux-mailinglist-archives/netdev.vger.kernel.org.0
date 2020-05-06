Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A995B1C68DC
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgEFGZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:25:00 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:21786 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgEFGZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588746299; x=1620282299;
  h=from:to:cc:subject:date:message-id:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=uP/BhJmSmX3L3+P3MYiFUKs9vkkg39y9yHhc2FQC2CE=;
  b=AWpURNSlT6NY+dMJNU7IbbIjkpxAHKe2yVEyddxuvV6/ef8KyVNnuFf+
   OUYTrLLGHNw6CKmVgQNgp8BtpqRm1g6P5CclrZ6ttJcyh+M0gXHxTGlzw
   xK5e2xOaLjz1GDPZQuvHF2vW28bSNZ4PEt/bh0cgq9pkcCkT2cqqQmRkq
   w=;
IronPort-SDR: qhyU6KFoz/1V89gyCJYv+kd3k1uEGCYFRYrs/Ix3poJbo/3VkCLYcuvefjU+v8VD2IW0xCvhJK
 Ty9ZARoFU/og==
X-IronPort-AV: E=Sophos;i="5.73,358,1583193600"; 
   d="scan'208";a="28845370"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 06 May 2020 06:24:47 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id B1839A218C;
        Wed,  6 May 2020 06:24:45 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 6 May 2020 06:24:44 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.180) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 6 May 2020 06:24:39 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     David Miller <davem@davemloft.net>
CC:     <sjpark@amazon.com>, <viro@zeniv.linux.org.uk>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <edumazet@google.com>,
        <sj38.park@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sjpark@amazon.de>
Subject: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Wed, 6 May 2020 08:24:23 +0200
Message-ID: <20200506062423.28873-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
In-Reply-To: <20200505.120049.635223866062154775.davem@davemloft.net> (raw)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D02UWC003.ant.amazon.com (10.43.162.199) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 05 May 2020 12:00:49 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Tue, 05 May 2020 11:48:25 -0700 (PDT)
> 
> > Series applied and queued up for -stable, thanks.
> 
> Nevermind, this doesn't even compile.
> 
> net/smc/af_smc.c: In function ‘smc_switch_to_fallback’:
> net/smc/af_smc.c:473:19: error: ‘smc->clcsock->wq’ is a pointer; did you mean to use ‘->’?
>   473 |   smc->clcsock->wq.fasync_list =
>       |                   ^
>       |                   ->
> net/smc/af_smc.c:474:25: error: ‘smc->sk.sk_socket->wq’ is a pointer; did you mean to use ‘->’?
>   474 |    smc->sk.sk_socket->wq.fasync_list;
>       |                         ^
>       |                         ->
> 
> So I had to revert these changes.
> 
> When you make a change of this magnitude and scope you must do an
> allmodconfig build.

Definitely my fault.  I will fix this in next spin.


Thanks,
SeongJae Park

> 
> Thank you.
