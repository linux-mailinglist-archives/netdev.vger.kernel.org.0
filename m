Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF4846CD84
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbhLHGTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:19:05 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:33076 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhLHGTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:19:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1638944134; x=1670480134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4bBNMA4zrzd/r+j2zL5V/dFuqq9hRegHNbwW08julC4=;
  b=mbLUb2tkofYbATIrT6VqKHQ5L1Dbcvaj5CiWjNMS9CviDN9akeSJm3jd
   8I6ECyKS4l6kUsbRQ7DPYC/VvRa33g6pINwGJTLsuJiUJpjdRH6Imwf16
   AeXoTc794KmRp4gquY4eh7zRiD05g+Th6ceTAmPhgW9VlyiScTpOy9uCp
   M=;
X-IronPort-AV: E=Sophos;i="5.87,296,1631577600"; 
   d="scan'208";a="162012690"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-34cb9e7b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 08 Dec 2021 06:15:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-34cb9e7b.us-west-2.amazon.com (Postfix) with ESMTPS id B13714181E;
        Wed,  8 Dec 2021 06:15:32 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 8 Dec 2021 06:15:31 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.159) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 8 Dec 2021 06:15:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuba@kernel.org>
CC:     <benh@amazon.com>, <davem@davemloft.net>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] sock: Use sock_owned_by_user_nocheck() instead of sk_lock.owned.
Date:   Wed, 8 Dec 2021 15:15:25 +0900
Message-ID: <20211208061525.53519-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211207220531.48a78cc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211207220531.48a78cc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.159]
X-ClientProxiedBy: EX13D04UWA002.ant.amazon.com (10.43.160.31) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 7 Dec 2021 22:05:31 -0800
> On Wed, 8 Dec 2021 14:39:24 +0900 Kuniyuki Iwashima wrote:
> >  static inline void sock_release_ownership(struct sock *sk)
> >  {
> > -	if (sk->sk_lock.owned) {
> > +	if (sock_owned_by_user_nocheck(sk) {
> 
> ENOTBUILT

Oops, will move sock_release_ownership() down in v2.
Thank you!
