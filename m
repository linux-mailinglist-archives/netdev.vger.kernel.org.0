Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3ED3A3740
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFJWl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:41:58 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:10363 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJWl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:41:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623364802; x=1654900802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4CA8z+dDu7d9proABF9lM5G9ph/TFB0T/NCi5liIvic=;
  b=fPAWlycNgUIN1O5AaRfDUGDhDOJf6nYcuFL3dcFoLvrkHjqhkDQedK8y
   3qPcDVokP0y0s1vIjSZwFD1jvSDs7u16dGsckNSD9WXNwvFqqPYMLXlDs
   oG4efk+0/BSWGntadZnWE4ZFKDmzuVy+cTk0SdFmvo4uIffzGnKwChs/F
   w=;
X-IronPort-AV: E=Sophos;i="5.83,264,1616457600"; 
   d="scan'208";a="119476266"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 10 Jun 2021 22:40:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 2783CA231F;
        Thu, 10 Jun 2021 22:39:58 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:39:57 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.183) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:39:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v7 bpf-next 04/11] tcp: Add reuseport_migrate_sock() to select a new listener.
Date:   Fri, 11 Jun 2021 07:39:49 +0900
Message-ID: <20210610223949.98599-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <fb9a3615-4ce3-f676-abfc-4a5a641a9e58@gmail.com>
References: <fb9a3615-4ce3-f676-abfc-4a5a641a9e58@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.183]
X-ClientProxiedBy: EX13D42UWB001.ant.amazon.com (10.43.161.35) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu, 10 Jun 2021 20:09:32 +0200
> On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> > reuseport_migrate_sock() does the same check done in
> > reuseport_listen_stop_sock(). If the reuseport group is capable of
> > migration, reuseport_migrate_sock() selects a new listener by the child
> > socket hash and increments the listener's sk_refcnt beforehand. Thus, if we
> > fail in the migration, we have to decrement it later.
> > 
> > We will support migration by eBPF in the later commits.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/net/sock_reuseport.h |  3 ++
> >  net/core/sock_reuseport.c    | 78 +++++++++++++++++++++++++++++-------
> >  2 files changed, 67 insertions(+), 14 deletions(-)
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thank you again!
