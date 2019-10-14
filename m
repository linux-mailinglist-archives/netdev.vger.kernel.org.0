Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E020D69A5
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 20:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbfJNSna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 14:43:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfJNSna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 14:43:30 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA52A145AE05D;
        Mon, 14 Oct 2019 11:43:29 -0700 (PDT)
Date:   Mon, 14 Oct 2019 14:43:27 -0400 (EDT)
Message-Id: <20191014.144327.888902765137276425.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     netdev@vger.kernel.org, herbert@gondor.apana.org.au,
        steffen.klassert@secunet.com
Subject: Re: [PATCH net-next v4 0/6] ipsec: add TCP encapsulation support
 (RFC 8229)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1570787286.git.sd@queasysnail.net>
References: <cover.1570787286.git.sd@queasysnail.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Oct 2019 11:43:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Fri, 11 Oct 2019 16:57:23 +0200

> This patchset introduces support for TCP encapsulation of IKE and ESP
> messages, as defined by RFC 8229 [0]. It is an evolution of what
> Herbert Xu proposed in January 2018 [1] that addresses the main
> criticism against it, by not interfering with the TCP implementation
> at all. The networking stack now has infrastructure for this: TCP ULPs
> and Stream Parsers.

So this will bring up a re-occurring nightmare in that now we have another
situation where stacking ULPs would be necessary (kTLS over TCP encap) and
the ULP mechanism simply can't do this.

Last time this came up, it had to do with sock_map.  No way could be found
to stack ULPs properly, so instead sock_map was implemented via something
other than ULPs.

I fear we have the same situation here again and this issue must be
addressed before these patches are included.

Thanks.
