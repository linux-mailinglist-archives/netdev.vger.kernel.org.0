Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E555960DB
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiHPRPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiHPRPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:15:34 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FD67A747
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660670135; x=1692206135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/p/9I+7L0ipMCSsok5ii2lVdkoCYflBryht9SzRNOqI=;
  b=eM1n8KsNChG2vA1xpzMf+GbNNUfyvUTvvQeUs/c2enev2YOSE0v5qTku
   kMkIVtSPUKHBO6+GQ+aOgSrq1HzW+8N0628SGXCx86LsAA/mg7s4gqEYf
   rutgHOLcN13IMHuMkB9zFTRcgx0aaJcpWDofFXVpFvJAfUFrNmkSVbcsL
   g=;
X-IronPort-AV: E=Sophos;i="5.93,241,1654560000"; 
   d="scan'208";a="233714242"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 17:15:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com (Postfix) with ESMTPS id 5A6A344D7B;
        Tue, 16 Aug 2022 17:15:20 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 17:15:19 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.201) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 17:15:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <david.laight@aculab.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <tkhai@ya.ru>, <viro@zeniv.linux.org.uk>
Subject: RE: [PATCH v2 1/2] fs: Export __receive_fd()
Date:   Tue, 16 Aug 2022 10:15:09 -0700
Message-ID: <20220816171509.98183-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <e3e2fe6a2b8f4a65a4e28d9d7fddd558@AcuMS.aculab.com>
References: <e3e2fe6a2b8f4a65a4e28d9d7fddd558@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.201]
X-ClientProxiedBy: EX13D29UWC003.ant.amazon.com (10.43.162.80) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   David Laight <David.Laight@ACULAB.COM>
Date:   Tue, 16 Aug 2022 08:03:14 +0000
> From: Kirill Tkhai
> > Sent: 15 August 2022 22:15
> > 
> > This is needed to make receive_fd_user() available in modules, and it will be used in next patch.
> > 
> > Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> > ---
> > v2: New
> >  fs/file.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/file.c b/fs/file.c
> > index 3bcc1ecc314a..e45d45f1dd45 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -1181,6 +1181,7 @@ int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
> >  	__receive_sock(file);
> >  	return new_fd;
> >  }
> > +EXPORT_SYMBOL_GPL(__receive_fd);
> 
> It doesn't seem right (to me) to be exporting a function
> with a __ prefix.

+1.
Now receive_fd() has inline and it's the problem.
Can we avoid this by moving receive_fd() in fs/file.c without inline and
exporting it?
