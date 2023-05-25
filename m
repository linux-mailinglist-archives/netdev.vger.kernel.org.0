Return-Path: <netdev+bounces-5407-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A0F7112F2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EC5A1C20EC4
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C8A1F95B;
	Thu, 25 May 2023 17:56:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707A4101DA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 17:56:46 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736C31B4
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685037400; x=1716573400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1LYgDvT0fSvDyy3lYTUPTiqUJWO2kR0Nms3jypk5t/g=;
  b=tLE1a5SeoXsoimvLQYtha43C8Wdiy0sDi11gvbKuA0ynvTc0H775RGRn
   RIeBDudBv8dxsAK4LN+8rKIMnLBmkH70zTUbvPlzkIsrugblKEJk7MbY8
   uJHN/4zoJJzCUHLzAcfiRdyUpYhhyfFu1zusmZBFqsBq7pi7UJiMBGi3U
   0=;
X-IronPort-AV: E=Sophos;i="6.00,191,1681171200"; 
   d="scan'208";a="328855151"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 17:56:38 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 81EE9A0876;
	Thu, 25 May 2023 17:56:36 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 25 May 2023 17:56:35 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.54) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 25 May 2023 17:56:33 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <stephen@networkplumber.org>
CC: <bugzilla-daemon@kernel.org>, <netdev@vger.kernel.org>,
	<kuniyu@amazon.com>
Subject: Re: [Bug 217486] New: 'doubel fault' in if_nlmsg_size func by syz-executor fuzz
Date: Thu, 25 May 2023 10:56:25 -0700
Message-ID: <20230525175625.6900-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230525081558.38ee5cde@hermes.local>
References: <20230525081558.38ee5cde@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.54]
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Thu, 25 May 2023 08:15:58 -0700
> Not much info in this bug report.
> Blaming if_nlmsg_size() is not right, something is passing bogus data.
> 
> 
> On Thu, 25 May 2023 12:40:12 +0000
> bugzilla-daemon@kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=217486
> > 
> >             Bug ID: 217486
> >            Summary: 'doubel fault' in if_nlmsg_size func by syz-executor
> >                     fuzz
> >            Product: Networking
> >            Version: 2.5
> >           Hardware: All
> >                 OS: Linux
> >             Status: NEW
> >           Severity: normal
> >           Priority: P3
> >          Component: IPV4
> >           Assignee: stephen@networkplumber.org
> >           Reporter: 13151562558@163.com
> >         Regression: No
> > 
> > in syz-executor fuzz test, system panic in "double fault" err.
> > by the kernel log, only get one dump stack info, "if_nlmsg_size+0x4ea/0x7c0".
> > I have vmcore, but don't know how to debug "double fault"? what't first fault ?
> > 
> > if_nlmsg_size+0x4ea/0x7c0 code:
> > ```
> > static noinline size_t if_nlmsg_size(const struct net_device *dev,
> >                                      u32 ext_filter_mask)
> > {
> >         return NLMSG_ALIGN(sizeof(struct ifinfomsg))
> >                + nla_total_size(IFNAMSIZ) /* IFLA_IFNAME */
> >                + nla_total_size(IFALIASZ) /* IFLA_IFALIAS */
> > 
> >                + nla_total_size(4)  /* IFLA_MIN_MTU */
> >                + nla_total_size(4)  /* IFLA_MAX_MTU */
> >                + rtnl_prop_list_size(dev) // this
> > line;if_nlmsg_size+0x4ea/0x7c0
> >                + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
> >                + 0;
> > }
> > ```
> > 
> > dis the code of dump stack, like this:
> > /include/linux/list.h: 
> >  <if_nlmsg_size+1325>:        mov    %rbp,%rdx
> >  <if_nlmsg_size+1328>:        shr    $0x3,%rdx
> >  <if_nlmsg_size+1332>:        cmpb   $0x0,(%rdx,%rax,1)
> >  <if_nlmsg_size+1336>:        jne    0xffffffff8a5b86a6 <if_nlmsg_size+1766>
> >  <if_nlmsg_size+1342>:        mov    0x10(%r15),%rax
> >  <if_nlmsg_size+1346>:        cmp    %rax,%rbp
> >  <if_nlmsg_size+1349>:        je     0xffffffff8a5b8659 <if_nlmsg_size+1689>
> > 
> > 
> > kernel log:
> > [ 3213.317259] CPU: 1 PID: 1830 Comm: syz-executor.6 Tainted: G      D

I'd salvage a repro candidate in the syzkaller's log like

  HH:MM:SS executing program 6:
  ....

with syz-prog2c.  Even if it does not reproduce the issue,
the syz sequences will give much more hints.


> >  5.10.0 #1
> > [ 3213.317404] RIP: 0010:if_nlmsg_size+0x53e/0x7c0
> > [ 3213.317415] Code: 00 0f 85 2e 02 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b
> > 7b 10 49 8d 6f 10 48 89 ea 48 c1 ea 03 80 3c 02 00 0f 85 a8 01 00 00 <49> 8b 47
> > 10 48 39 c5 0f 84 4e 01 00 00 e8 90 ff 1a f7 48 89 ea 48
> > [ 3213.317420] RSP: 0018:ffff88809f4ca570 EFLAGS: 00010246
> > [ 3213.317428] RAX: dffffc0000000000 RBX: ffff88803767c000 RCX:
> > ffffc90006714000
> > [ 3213.317433] RDX: 1ffff11008037c92 RSI: ffffffff8a5b84aa RDI:
> > ffff88803767c010
> > [ 3213.317439] RBP: ffff8880401be490 R08: 0000000000000cc0 R09:
> > 0000000000000000
> > [ 3213.317445] R10: ffffffff9287d2e7 R11: fffffbfff250fa5c R12:
> > 0000000000000640
> > [ 3213.317450] R13: 0000000000000950 R14: 0000000000000008 R15:
> > ffff8880401be480
> > [ 3213.317454]  ? if_nlmsg_size+0x4ea/0x7c0
> > [ 3213.317457]  </#DF>


