Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468D7651AAB
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 07:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbiLTG3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 01:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiLTG3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 01:29:05 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3AE13E14;
        Mon, 19 Dec 2022 22:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1671517744; x=1703053744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ki+hB2kj/NC03L3ayooeoNqDLhtrZe9AVFgwn/fjUEE=;
  b=g/nEolEHCHXpMw4Y+BkhI0TYtj3ygkGLAosjI2D3EOf5hj3Ui1EvNMg2
   3YjlgmQuAo7zyOukXAVVrmswkuDM4WBfobUZl04jP6seH+TpHYQ08dWMG
   dGz1vzkG+4FhR4/PFgyRLwB6LAPWrvpmh3/LDn3AlXp/VUNLHmVsbu99A
   I=;
X-IronPort-AV: E=Sophos;i="5.96,258,1665446400"; 
   d="scan'208";a="1085153343"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 06:28:58 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id A7B0582248;
        Tue, 20 Dec 2022 06:28:57 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 20 Dec 2022 06:28:57 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.114) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Tue, 20 Dec 2022 06:28:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <jirislaby@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <joannelkoong@gmail.com>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PULL] Networking for next-6.1
Date:   Tue, 20 Dec 2022 15:28:44 +0900
Message-ID: <20221220062844.26368-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <5bb57ae6-c2a7-e6ea-3fe8-62b8b61bc7c5@kernel.org>
References: <5bb57ae6-c2a7-e6ea-3fe8-62b8b61bc7c5@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.114]
X-ClientProxiedBy: EX13D39UWA004.ant.amazon.com (10.43.160.73) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jiri Slaby <jirislaby@kernel.org>
Date:   Tue, 20 Dec 2022 07:22:56 +0100
> On 19. 12. 22, 0:25, Kuniyuki Iwashima wrote:
> > From:   Jiri Slaby <jirislaby@kernel.org>
> > Date:   Fri, 16 Dec 2022 11:49:01 +0100
> >> Hi,
> >>
> >> On 04. 10. 22, 7:20, Jakub Kicinski wrote:
> >>> Joanne Koong (7):
> >>
> >>>         net: Add a bhash2 table hashed by port and address
> >>
> >> This makes regression tests of python-ephemeral-port-reserve to fail.
> >>
> >> I'm not sure if the issue is in the commit or in the test.
> > 
> > Hi Jiri,
> > 
> > Thanks for reporting the issue.
> > 
> > It seems we forgot to add TIME_WAIT sockets into bhash2 in
> > inet_twsk_hashdance(), therefore inet_bhash2_conflict() misses
> > TIME_WAIT sockets when validating bind() requests if the address
> > is not a wildcard one.
> > 
> > I'll fix it.
> 
> Hi,
> 
> is there a fix for this available somewhere yet?

Not yet, but I'll CC you when posting a patch.

Thank you.
