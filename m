Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F60E2D2B8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfE2APW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:15:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54284 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfE2APW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:15:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDB9713FD09E7;
        Tue, 28 May 2019 17:15:21 -0700 (PDT)
Date:   Tue, 28 May 2019 17:15:21 -0700 (PDT)
Message-Id: <20190528.171521.516563262658055908.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     xmu@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] selftests: pmtu: Fix encapsulating device in
 pmtu_vti6_link_change_mtu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a53ca7bdf29b2b265d812adf51168f7c5f4e4e26.1558978791.git.sbrivio@redhat.com>
References: <a53ca7bdf29b2b265d812adf51168f7c5f4e4e26.1558978791.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 17:15:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Mon, 27 May 2019 19:42:23 +0200

> In the pmtu_vti6_link_change_mtu test, both local and remote addresses
> for the vti6 tunnel are assigned to the same address given to the dummy
> interface that we use as encapsulating device with a known MTU.
> 
> This works as long as the dummy interface is actually selected, via
> rt6_lookup(), as encapsulating device. But if the remote address of the
> tunnel is a local address too, the loopback interface could also be
> selected, and there's nothing wrong with it.
> 
> This is what some older -stable kernels do (3.18.z, at least), and
> nothing prevents us from subtly changing FIB implementation to revert
> back to that behaviour in the future.
> 
> Define an IPv6 prefix instead, and use two separate addresses as local
> and remote for vti6, so that the encapsulating device can't be a
> loopback interface.
> 
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Fixes: 1fad59ea1c34 ("selftests: pmtu: Add pmtu_vti6_link_change_mtu test")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Applied.
