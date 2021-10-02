Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDD841FAB1
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 11:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhJBJpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 05:45:51 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:17949 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhJBJpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 05:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1633167846; x=1664703846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y68N53y8IC+/QcDQNl6rEfrdpjYU+xi2+w3DT+gV8+E=;
  b=YQiYTDYfjA+kRw97GI2SaLf7hswFhHJsnqrwyvtZznuhTulOxJfu2l7B
   WEn75iy3kPhBTrFkyX5K1k9s+oVTd9G22wV6Zr7VAt/pyHuuadwMl+ILB
   t33BqEDSgVqcfkBob64d2M3dWikAKYqbIuevBrXC/8snnOudqMRs5J4nP
   M=;
X-IronPort-AV: E=Sophos;i="5.85,341,1624320000"; 
   d="scan'208";a="146335299"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 02 Oct 2021 09:44:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id E32F541F29;
        Sat,  2 Oct 2021 09:44:02 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 2 Oct 2021 09:44:02 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 2 Oct 2021 09:43:56 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuba@kernel.org>
CC:     <Rao.Shoaib@oracle.com>, <andrii@kernel.org>, <ast@kernel.org>,
        <cong.wang@bytedance.com>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>,
        <jbi.octave@gmail.com>, <jiang.wang@bytedance.com>,
        <john.fastabend@gmail.com>, <kafai@fb.com>, <kpsingh@kernel.org>,
        <kuniyu@amazon.co.jp>, <songliubraving@fb.com>,
        <viro@zeniv.linux.org.uk>, <yhs@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] af_unix: add missing annotation at bpf_iter_unix_seq_stop()
Date:   Sat, 2 Oct 2021 18:43:17 +0900
Message-ID: <20211002094317.8623-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001180439.55bdc79f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211001180439.55bdc79f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.146]
X-ClientProxiedBy: EX13D31UWA004.ant.amazon.com (10.43.160.217) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Date:   Fri, 1 Oct 2021 18:04:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
> On Sat,  2 Oct 2021 00:49:37 +0100 Jules Irenge wrote:
> > Sparse reports a warning at bpf_iter_unix_seq_stop()
> > The root cause is a missing annotation at bpf_iter_unix_seq_stop()
> > 
> > Add the missing __releases(unix_table_lock) annotation
> > 
> > Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

I completely missed that...
Thanks!


> > ---
> >  net/unix/af_unix.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > index efac5989edb5..9838d4d855e0 100644
> > --- a/net/unix/af_unix.c
> > +++ b/net/unix/af_unix.c
> > @@ -3291,6 +3291,7 @@ static int bpf_iter_unix_seq_show(struct seq_file *seq, void *v)
> >  }
> >  
> >  static void bpf_iter_unix_seq_stop(struct seq_file *seq, void *v)
> > +	__releases(unix_table_lock)
> >  {
> >  	struct bpf_iter_meta meta;
> >  	struct bpf_prog *prog;
> 
> You need to CC bpf@vger... and netdev@vger...
> 
> You can drop the CC for linux-kernel@, approximately nobody reads that.

Added bpf and netdev, and dropped linux-kernel.

Thank you.
