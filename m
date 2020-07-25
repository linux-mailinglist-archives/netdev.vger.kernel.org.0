Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39AD22D6EF
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 12:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgGYK6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 06:58:54 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:5637 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYK6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 06:58:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1595674733; x=1627210733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8yCuQp1jTum4mRZYjvOuHgeSPvfethR7PN2wJdJXAZk=;
  b=OW0ef4y+6sprVMnbpkwaw4CpVz2qhrTv0mi19rK6bW9nB5uNUSf8jDws
   sFpuaUvELflN8c0BGVvcQI1BskhQxO574K12zQEmi4IBbC4DJW9PKlVVL
   gistspJ9QaPpzi8GFzrntsI1o9bLjo4Sfy8DSD78hxDjCs1J6LJ+mdgCi
   A=;
IronPort-SDR: uAxbuuyURjQ6k6z1cAtU4ogVYIh2Jf46Y2MFwTGvFlwmo+7hEz6HCilG/A9TfWU3OCLyaipd7l
 ryAcnwGlbcZQ==
X-IronPort-AV: E=Sophos;i="5.75,394,1589241600"; 
   d="scan'208";a="61470209"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 25 Jul 2020 10:58:52 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 49F06A1D5E;
        Sat, 25 Jul 2020 10:58:51 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 25 Jul 2020 10:58:49 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.203) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 25 Jul 2020 10:58:45 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <willemdebruijn.kernel@gmail.com>
CC:     <ast@kernel.org>, <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <jakub@cloudflare.com>, <kuba@kernel.org>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <willemb@google.com>
Subject: Re: [PATCH bpf-next] udp: reduce merge conflict on udp[46]_lib_lookup2
Date:   Sat, 25 Jul 2020 19:58:41 +0900
Message-ID: <20200725105841.19507-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200725025457.1004164-1-willemdebruijn.kernel@gmail.com>
References: <20200725025457.1004164-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13D17UWC004.ant.amazon.com (10.43.162.195) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 24 Jul 2020 22:54:57 -0400
> From: Willem de Bruijn <willemb@google.com>
> 
> Commit efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> 
> in net conflicts with
> 
> Commit 72f7e9440e9b ("udp: Run SK_LOOKUP BPF program on socket lookup")
> 
> in bpf-next.
> 
> Commit 4a0e87bb1836 ("udp: Don't discard reuseport selection when group
> has connections")
> 
> also in bpf-next reduces the conflict.
> 
> Further simplify by applying the main change of the first commit to
> bpf-next. After this a conflict remains, but the bpf-next side can be
> taken as is.
> 
> Now unused variable reuseport_result added in net must also be
> removed. That applies without a conflict, so is harder to spot.
> 
> Link: http://patchwork.ozlabs.org/project/netdev/patch/20200722165227.51046-1-kuniyu@amazon.co.jp/
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Thank you for the follow up patch!

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Best Regards,
Kuniyuki
