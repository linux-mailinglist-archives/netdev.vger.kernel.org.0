Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 246BC12579C
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfLRXRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:17:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57656 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfLRXRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:17:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 971AD1540021E;
        Wed, 18 Dec 2019 15:17:32 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:17:32 -0800 (PST)
Message-Id: <20191218.151732.2019141834931247672.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [MPTCP] Re: [PATCH net-next v3 07/11] tcp: Prevent
 coalesce/collapse when skb has MPTCP extensions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5e6ae66a8adea061388919fe0ce5b766feab4c31.camel@redhat.com>
References: <5fc0d4bd-5172-298d-6bbb-00f75c7c0dc9@gmail.com>
        <20191218.124510.1971632024371398726.davem@davemloft.net>
        <5e6ae66a8adea061388919fe0ce5b766feab4c31.camel@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 15:17:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 18 Dec 2019 23:15:46 +0100

> Just to clarify, with the code we have currently posted TSO trains of
> MPTCP packets can be aggregated by the GRO engine almost exactly as
> currently happens for plain TCP packets.
> 
> We still have chances to aggregate packets belonging to a MPTCP stream,
> as not all of them carry a DSS option.
> 
> We opted to not coalesce at the TCP level for the moment to avoid
> adding additional hook code inside the coalescing code.
> 
> If you are ok without such hooks in the initial version, we can handle
> MPTCP coalescing, too. The real work will likely land in part 2.
> 
> Would that fit you?

Can't you someone encode the MPTCP metadata so that it will only apply
to a range or something like that?  Would that help?
