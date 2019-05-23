Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E43328238
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbfEWQLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:11:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48160 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730782AbfEWQLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:11:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D9D21509A0F5;
        Thu, 23 May 2019 09:11:07 -0700 (PDT)
Date:   Thu, 23 May 2019 09:11:06 -0700 (PDT)
Message-Id: <20190523.091106.645519899189717299.davem@davemloft.net>
To:     ast@domdv.de
Cc:     netdev@vger.kernel.org
Subject: Re: [RESEND][PATCH] Fix MACsec kernel panics, oopses and bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <32eb738a0a0f3ed5880911e4ac4ceedca76e3f52.camel@domdv.de>
References: <32eb738a0a0f3ed5880911e4ac4ceedca76e3f52.camel@domdv.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:11:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Steinmetz <ast@domdv.de>
Date: Thu, 23 May 2019 09:46:15 +0200

> MACsec causes oopses followed by a kernel panic when attached directly or indirectly to a bridge. It causes erroneous
> checksum messages when attached to vxlan. When I did investigate I did find skb leaks, apparent skb mis-handling and
> superfluous code. The attached patch fixes all MACsec misbehaviour I could find. As I am no kernel developer somebody
> with sufficient kernel network knowledge should verify and correct the patch where necessary.
> 
> Signed-off-by: Andreas Steinmetz <ast@domdv.de>

Subject lines should be of the form:

[PATCH $DST_TREE] $subsystem_prefix: Description.

Where $DST_TREE here would be "net" and $subsystem_prefix would be "macsec".

> +	/* FIXME: any better way to prevent calls to netdev_rx_csum_fault? */
> +	skb->csum_complete_sw = 1;

Create a helper for this in linux/skbuff.h with very clear and clean comments
explaining what is going on.
