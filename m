Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B593255DC
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 19:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhBYSwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 13:52:45 -0500
Received: from mx4.wp.pl ([212.77.101.12]:19422 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233580AbhBYSwl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 13:52:41 -0500
Received: (wp-smtpd smtp.wp.pl 5472 invoked from network); 25 Feb 2021 19:51:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1614279103; bh=Jlr0mJspKRZ4zpFrq4Z9+nbzOH2E12NSX79EmButAiQ=;
          h=From:To:Cc:Subject;
          b=kW6vYXIBFSAG+UNmM40pyfcMd0GNROJzyfDRCJZx3VjGw8H8Hnza6CRyMKf4RThtJ
           DV2fJPgev3NYaR6XY/p3WLY0FmUk06psLEDvnB0pEUgQbUkEdyK00fn9zVKVjZCaTX
           iwFioTDs7sUP1Rnpz37mK644REXZOBAC0O4b34n4=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.7])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <colin.king@canonical.com>; 25 Feb 2021 19:51:42 +0100
Date:   Thu, 25 Feb 2021 10:51:35 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Colin King <colin.king@canonical.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7601u: fix always true expression
Message-ID: <20210225105135.6a2e6953@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210225183241.1002129-1-colin.king@canonical.com>
References: <20210225183241.1002129-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: d4752f3dadd47f61a803e18d0663a885
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [0TIT]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 18:32:41 +0000 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the expression ~nic_conf1 is always true because nic_conf1
> is a u16 and according to 6.5.3.3 of the C standard the ~ operator
> promotes the u16 to an integer before flipping all the bits. Thus
> the top 16 bits of the integer result are all set so the expression
> is always true.  If the intention was to flip all the bits of nic_conf1
> then casting the integer result back to a u16 is a suitabel fix.
> 
> Interestingly static analyzers seem to thing a bitwise ! should be
> used instead of ~ for this scenario

In what way? The condition is nic_conf1 != 0xffff AFAICT, how would we
do that with !?

> so I think the original intent
> of the expression may need some extra consideration.
> 
> Addresses-Coverity: ("Logical vs. bitwise operator")
> Fixes: c869f77d6abb ("add mt7601u driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thanks for the fix!

