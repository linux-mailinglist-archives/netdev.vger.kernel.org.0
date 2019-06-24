Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 038B450DF8
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfFXO3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:29:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54754 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfFXO3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:29:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94D6215041421;
        Mon, 24 Jun 2019 07:29:18 -0700 (PDT)
Date:   Mon, 24 Jun 2019 07:29:18 -0700 (PDT)
Message-Id: <20190624.072918.1626161455453937687.davem@davemloft.net>
To:     john.rutherford@dektech.com.au
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next v2] tipc: add loopback device tracking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624064435.22357-1-john.rutherford@dektech.com.au>
References: <20190624064435.22357-1-john.rutherford@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 07:29:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: john.rutherford@dektech.com.au
Date: Mon, 24 Jun 2019 16:44:35 +1000

> Since node internal messages are passed directly to socket it is not
> possible to observe this message exchange via tcpdump or wireshark.
> 
> We now remedy this by making it possible to clone such messages and send
> the clones to the loopback interface.  The clones are dropped at reception
> and have no functional role except making the traffic visible.
> 
> The feature is turned on/off by enabling/disabling the loopback "bearer"
> "eth:lo".
> 
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>

What a waste, just clone the packet, attach loopback to it, and go:

	if (dev_nit_active(loopback_dev))
		dev_queue_xmit_nit(skb, loopback_dev);
