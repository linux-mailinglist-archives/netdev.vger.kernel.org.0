Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B0010A10
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 17:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfEAPbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 11:31:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEAPbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 11:31:03 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E8B81473AE49;
        Wed,  1 May 2019 08:31:02 -0700 (PDT)
Date:   Wed, 01 May 2019 11:31:01 -0400 (EDT)
Message-Id: <20190501.113101.1983014622975636535.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, David.Laight@aculab.com,
        ebiederm@xmission.com, willemb@google.com
Subject: Re: [PATCH net v2] packet: in recvmsg msg_name return at least
 sizeof sockaddr_ll
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190429154655.9141-1-willemdebruijn.kernel@gmail.com>
References: <20190429154655.9141-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 08:31:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 29 Apr 2019 11:46:55 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Packet send checks that msg_name is at least sizeof sockaddr_ll.
> Packet recv must return at least this length, so that its output
> can be passed unmodified to packet send.
> 
> This ceased to be true since adding support for lladdr longer than
> sll_addr. Since, the return value uses true address length.
> 
> Always return at least sizeof sockaddr_ll, even if address length
> is shorter. Zero the padding bytes.
> 
> Change v1->v2: do not overwrite zeroed padding again. use copy_len.
> 
> Fixes: 0fb375fb9b93 ("[AF_PACKET]: Allow for > 8 byte hardware addresses.")
> Suggested-by: David Laight <David.Laight@aculab.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable.
