Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3250738A047
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 10:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhETI4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 04:56:08 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:1114 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhETI4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 04:56:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621500886; x=1653036886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=00YqfMRgZNskF3qk2sbk+H/Ar30K7s92E161jGs1MNw=;
  b=vmjCw5glsisImGnHpQ27q8aguEdTmM6rXjH1xdX+67UJ1ru6w0KYVcET
   HY0PpWdS3BksqE6PoZpeaf8kvEjTN/qf3ASFTANZ08kKQQlcMem1a9x41
   Tvy6q5rzo/tZOlM+ZBc/fJvO32IbgePs+/U5KwocYFwo38lPayWEMGJ1S
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="110463401"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 20 May 2021 08:54:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 355C7A071F;
        Thu, 20 May 2021 08:54:45 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 20 May 2021 08:54:44 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.200) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 20 May 2021 08:54:39 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 bpf-next 09/11] bpf: Support socket migration by eBPF.
Date:   Thu, 20 May 2021 17:54:35 +0900
Message-ID: <20210520085435.48836-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520062723.nora2kagi46b47lr@kafai-mbp.dhcp.thefacebook.com>
References: <20210520062723.nora2kagi46b47lr@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.200]
X-ClientProxiedBy: EX13D28UWB002.ant.amazon.com (10.43.161.140) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Wed, 19 May 2021 23:27:23 -0700
> On Mon, May 17, 2021 at 09:22:56AM +0900, Kuniyuki Iwashima wrote:
> > This patch introduces a new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT
> > to check if the attached eBPF program is capable of migrating sockets. When
> > the eBPF program is attached, we run it for socket migration if the
> > expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE or
> > net.ipv4.tcp_migrate_req is enabled.
> > 
> > Ccurrently, the expected_attach_type is not enforced for the
> nit. 'Currenctly,'

Thank you, I'll fix it to 'Currently' :)
