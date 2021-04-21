Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EAE366A0D
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 13:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbhDULmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 07:42:33 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:7016 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbhDULmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 07:42:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1619005319; x=1650541319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HAbpXiHOTn8VbO8LnCD0k8e/I+DV0ko6FknwV384kbM=;
  b=BUIuRvKOqLqmS+ED+eWoOcMbTtvfJMfe3B6a8lsD1SQnpDtnmjc/qLup
   FlE8WGWIe2jK0IrfYVnIOa8+SWlGFx9LZgTV4RKL5iqnhXDejyRBJbBGH
   8O+R4E/f3AjvdiP2wvzXn50ZvBa55EEVLu/wbDHp0nNsy73avf+elw5Jp
   E=;
X-IronPort-AV: E=Sophos;i="5.82,238,1613433600"; 
   d="scan'208";a="103118711"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 Apr 2021 11:34:55 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 01D7BA18D8;
        Wed, 21 Apr 2021 11:34:49 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 11:34:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.85) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 11:34:38 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <andrii.nakryiko@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 11/11] bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
Date:   Wed, 21 Apr 2021 20:34:33 +0900
Message-ID: <20210421113433.88881-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAEf4BzZ_=K6Yfg5VfCXAY9mA=+xArgBbtMW+31f8dwtc7QjP5w@mail.gmail.com>
References: <CAEf4BzZ_=K6Yfg5VfCXAY9mA=+xArgBbtMW+31f8dwtc7QjP5w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D30UWC003.ant.amazon.com (10.43.162.122) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 20 Apr 2021 15:57:54 -0700
> On Tue, Apr 20, 2021 at 8:45 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > This patch adds a test for BPF_SK_REUSEPORT_SELECT_OR_MIGRATE and
> > removes 'static' from settimeo() in network_helpers.c.
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> 
> Almost everything in prog_tests/migrate_reuseport.c should be static,
> functions and variables. Except the test_migrate_reuseport, of course.
> 
> But thank you for using ASSERT_xxx()! :)

Ah, I'll fix them in the next spin :)
Thank you!


> 
> >  tools/testing/selftests/bpf/network_helpers.c |   2 +-
> >  tools/testing/selftests/bpf/network_helpers.h |   1 +
> >  .../bpf/prog_tests/migrate_reuseport.c        | 483 ++++++++++++++++++
> >  .../bpf/progs/test_migrate_reuseport.c        |  51 ++
> >  4 files changed, 536 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
> >
> 
> [...]
