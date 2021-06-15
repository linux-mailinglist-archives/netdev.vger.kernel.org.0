Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6B03A85FF
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 18:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhFOQFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 12:05:51 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:42848 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhFOQFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 12:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623773026; x=1655309026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iV9WUO9bpC1sEDTFFmhoeZilgX+XDKsRGLJhRYd3N+Q=;
  b=jCV3UZvm9SekqRFkR4rvMtm7IjrZykxmej0ufs/icsFgKWcAFPNad+w1
   0rx32BqueLfq6EUIpSb/awKv7HBmn9P+Z9PV4iehFBdpAge+VaOa6vXeO
   pOM1d8XKE9R/HQ8AG1twYLUHVCbcZ8LZUF600hIbFLqZlYDiLeDjJLWq0
   M=;
X-IronPort-AV: E=Sophos;i="5.83,275,1616457600"; 
   d="scan'208";a="140260970"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 15 Jun 2021 16:03:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 32DA8240BA9;
        Tue, 15 Jun 2021 16:03:39 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 15 Jun 2021 16:03:38 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.137) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 15 Jun 2021 16:03:33 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <kafai@fb.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <ncardwell@google.com>,
        <netdev@vger.kernel.org>, <ycheng@google.com>
Subject: Re: [PATCH v8 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Wed, 16 Jun 2021 01:03:30 +0900
Message-ID: <20210615160330.19729-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iLxZxGXaVxLkxTkmNPF7XZdb8DKGMBFuMJLBdtrJRbrsA@mail.gmail.com>
References: <CANn89iLxZxGXaVxLkxTkmNPF7XZdb8DKGMBFuMJLBdtrJRbrsA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D16UWC004.ant.amazon.com (10.43.162.72) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Jun 2021 17:35:10 +0200
> On Sat, Jun 12, 2021 at 2:32 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> 
> >
> >
> > Changelog:
> >  v8:
> >   * Make reuse const in reuseport_sock_index()
> >   * Don't use __reuseport_add_sock() in reuseport_alloc()
> >   * Change the arg of the second memcpy() in reuseport_grow()
> >   * Fix coding style to use goto in reuseport_alloc()
> >   * Keep sk_refcnt uninitialized in inet_reqsk_clone()
> >   * Initialize ireq_opt and ipv6_opt separately in reqsk_migrate_reset()
> >
> >   [ This series does not include a stats patch suggested by Yuchung Cheng
> >     not to drop Acked-by/Reviewed-by tags and save reviewer's time. I will
> >     post the patch as a follow up after this series is merged. ]
> >
> 
> For the whole series.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

I greatly appreciate your review.
Thank you!!
