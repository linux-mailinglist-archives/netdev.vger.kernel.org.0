Return-Path: <netdev+bounces-6944-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB53718EE2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 01:00:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDC2D281650
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 23:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014F140770;
	Wed, 31 May 2023 23:00:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E082A20697
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 23:00:10 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC52D95;
	Wed, 31 May 2023 16:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685574009; x=1717110009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kv6oDM7pdpfWVnMiBJrhAcDvjz6rDRlBwOYN5Exzd1E=;
  b=O+YFIlbAoRtRrPy14biOmFNsFZcWK7YLW2FAMj4AmDWX+pwsNq834tmu
   UXwho7p74ox+35qYanlCvYiMVmj3iPVvDlqbRshMLRTxE0nKEW02N3/SD
   WzkhnmahokeaDC11YW0XTOUCgXg1Qq9UtOdr92GUuvj6NiSB+rXCIQ+mY
   Q=;
X-IronPort-AV: E=Sophos;i="6.00,207,1681171200"; 
   d="scan'208";a="330836147"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 23:00:05 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com (Postfix) with ESMTPS id 3B46C804D5;
	Wed, 31 May 2023 23:00:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 31 May 2023 22:59:58 +0000
Received: from 88665a182662.ant.amazon.com (10.95.246.21) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 31 May 2023 22:59:55 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <akihiro.suda.cz@hco.ntt.co.jp>, <akihirosuda@git.sr.ht>,
	<davem@davemloft.net>, <kuba@kernel.org>, <kuniyu@amazon.com>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <segoon@openwall.com>, <suda.kyoto@gmail.com>
Subject: Re: [PATCH linux] net/ipv4: ping_group_range: allow GID from 2147483648 to 4294967294
Date: Wed, 31 May 2023 15:59:47 -0700
Message-ID: <20230531225947.38239-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iK13jkbKXv-rKiUbTqMrk3KjVPGYH_Vv7FtJJ5pTdUAYQ@mail.gmail.com>
References: <CANn89iK13jkbKXv-rKiUbTqMrk3KjVPGYH_Vv7FtJJ5pTdUAYQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.95.246.21]
X-ClientProxiedBy: EX19D046UWA003.ant.amazon.com (10.13.139.18) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 May 2023 23:09:02 +0200
> On Wed, May 31, 2023 at 9:19 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From: ~akihirosuda <akihirosuda@git.sr.ht>
> > Date: Wed, 31 May 2023 19:42:49 +0900
> > > From: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>
> > >
> > > With this commit, all the GIDs ("0 4294967294") can be written to the
> > > "net.ipv4.ping_group_range" sysctl.
> > >
> > > Note that 4294967295 (0xffffffff) is an invalid GID (see gid_valid() in
> > > include/linux/uidgid.h), and an attempt to register this number will cause
> > > -EINVAL.
> > >
> > > Prior to this commit, only up to GID 2147483647 could be covered.
> > > Documentation/networking/ip-sysctl.rst had "0 4294967295" as an example
> > > value, but this example was wrong and causing -EINVAL.
> > >
> > > In the implementation, proc_dointvec_minmax is no longer used because it
> > > does not support numbers from 2147483648 to 4294967294.
> >
> > Good catch.
> >
> > I think we can use proc_doulongvec_minmax() instead of open coding.
> >
> > With the diff below:
> >
> > ---8<---
> > # sysctl -a | grep ping
> > net.ipv4.ping_group_range = 0   2147483647
> > # sysctl -w net.ipv4.ping_group_range="0 4294967295"
> > sysctl: setting key "net.ipv4.ping_group_range": Invalid argument
> > # sysctl -w net.ipv4.ping_group_range="0 4294967294"
> > net.ipv4.ping_group_range = 0 4294967294
> > # sysctl -a | grep ping
> > net.ipv4.ping_group_range = 0   4294967294
> > ---8<---
> >
> > ---8<---
> > diff --git a/include/net/ping.h b/include/net/ping.h
> > index 9233ad3de0ad..9b401b9a9d35 100644
> > --- a/include/net/ping.h
> > +++ b/include/net/ping.h
> > @@ -20,7 +20,7 @@
> >   * gid_t is either uint or ushort.  We want to pass it to
> >   * proc_dointvec_minmax(), so it must not be larger than MAX_INT
> >   */
> > -#define GID_T_MAX (((gid_t)~0U) >> 1)
> > +#define GID_T_MAX ((gid_t)~0U)
> >
> >  /* Compatibility glue so we can support IPv6 when it's compiled as a module */
> >  struct pingv6_ops {
> > diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> > index 6ae3345a3bdf..11d401958673 100644
> > --- a/net/ipv4/sysctl_net_ipv4.c
> > +++ b/net/ipv4/sysctl_net_ipv4.c
> > @@ -35,8 +35,8 @@ static int ip_ttl_max = 255;
> >  static int tcp_syn_retries_min = 1;
> >  static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
> >  static int tcp_syn_linear_timeouts_max = MAX_TCP_SYNCNT;
> > -static int ip_ping_group_range_min[] = { 0, 0 };
> > -static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
> > +static unsigned long ip_ping_group_range_min[] = { 0, 0 };
> > +static unsigned long ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
> >  static u32 u32_max_div_HZ = UINT_MAX / HZ;
> >  static int one_day_secs = 24 * 3600;
> >  static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
> > @@ -165,8 +165,8 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
> >                                  void *buffer, size_t *lenp, loff_t *ppos)
> >  {
> >         struct user_namespace *user_ns = current_user_ns();
> > +       unsigned long urange[2];
> >         int ret;
> > -       gid_t urange[2];
> >         kgid_t low, high;
> >         struct ctl_table tmp = {
> >                 .data = &urange,
> > @@ -179,7 +179,7 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
> >         inet_get_ping_group_range_table(table, &low, &high);
> >         urange[0] = from_kgid_munged(user_ns, low);
> >         urange[1] = from_kgid_munged(user_ns, high);
> > -       ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> > +       ret = proc_doulongvec_minmax(&tmp, write, buffer, lenp, ppos);
> >
> >         if (write && ret == 0) {
> >                 low = make_kgid(user_ns, urange[0]);
> > ---8<---
> 
> 
> Will this work on 32bit build ?

It worked at least on my i686 build and qemu.

---8<---
# uname -a
Linux (none) 6.4.0-rc3-00648-g75455b906d82-dirty #76 SMP PREEMPT_DYNAMIC Wed May 31 21:30:31 UTC 2023 i686 GNU/Linux
# sysctl -a | grep ping
net.ipv4.ping_group_range = 1	0
# sysctl -w net.ipv4.ping_group_range="0 4294967295"
sysctl: setting key "net.ipv4.ping_group_range": Invalid argument
# sysctl -w net.ipv4.ping_group_range="0 4294967294"
net.ipv4.ping_group_range = 0 4294967294
# sysctl -a | grep ping
net.ipv4.ping_group_range = 0	4294967294
---8<---

