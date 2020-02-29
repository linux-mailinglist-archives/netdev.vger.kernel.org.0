Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC611748B4
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 19:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbgB2Sh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 13:37:27 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:9959 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbgB2Sh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 13:37:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583001447; x=1614537447;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=a4XpAiRW79efX2H16U6R7uBPzIU8Gf3VZ+6fOrT8S+k=;
  b=wC4FH/ZQkIV1mg4d6rTwHZ25p/+WeUzJevkVJcRb2a3dOMZp1BRFwhWF
   1VkZMTxgCjEawH0yga49tkTuBARI6MpEUjLXZ/IZFwBsAEV9aB62pS5W8
   I2PdJxVS8CyMVWpdr1hutp07WDCbUypASVgG1gZbsLHMQ4qouZjgOG2Ye
   0=;
IronPort-SDR: krO5D5pTU43OFz2wfENgD0XLbIev71adhQW3UI6rXMKUMQrsZd7pjZc++MBrCoWZ8iSrv88zME
 AjUKmIeI6cBA==
X-IronPort-AV: E=Sophos;i="5.70,500,1574121600"; 
   d="scan'208";a="28311009"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 29 Feb 2020 18:37:26 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 3D3A1A17C5;
        Sat, 29 Feb 2020 18:37:25 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 18:37:24 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.173) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 29 Feb 2020 18:37:20 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>,
        <osa-contribution-log@amazon.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 net-next 3/3] tcp: Prevent port hijacking when ports are exhausted.
Date:   Sun, 1 Mar 2020 03:37:17 +0900
Message-ID: <20200229183717.14616-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <CANn89i+m9yKkaVLUm9P8+gTSOMtvrJgsvHfKAjXCZ5_9Wf0-9w@mail.gmail.com>
References: <CANn89i+m9yKkaVLUm9P8+gTSOMtvrJgsvHfKAjXCZ5_9Wf0-9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.173]
X-ClientProxiedBy: EX13D34UWA001.ant.amazon.com (10.43.160.173) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 Feb 2020 09:47:26 -0800
> This changelog is rather confusing, and your patch does not solve this
> precise problem.
> Patch titles are important, you are claiming something, but I fail to
> see how the patch solves the problem stated in the title.
> 
> Please be more specific, and add tests officially, in tools/testing/selftests/
> 
> 
> > If both of SO_REUSEADDR and SO_REUSEPORT are enabled, the restriction of
> > SO_REUSEPORT should be taken into account so that can only one socket be in
> > TCP_LISTEN.
> 
> Sorry, I do not understand this. If I do not understand the sentence,
> I do not read the patch
> changing one piece of code that has been very often broken in the past.
> 
> Please spend time on the changelog to give the exact outcome and goals.

I am so sorry that I wrote the changelog roughly. I appreciate for your
kind advice. I could rewrite more precise description of this issue and
respin these patches with tests.

  [PATCH v3 net-next 0/4] Improve bind(addr, 0) behaviour.
  https://lore.kernel.org/netdev/20200229113554.78338-1-kuniyu@amazon.co.jp/

Thank you so much!
