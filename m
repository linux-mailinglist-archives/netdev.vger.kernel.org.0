Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCEC217AFA
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgGGW2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgGGW2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:28:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7DCC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 15:28:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54B55120F19F2;
        Tue,  7 Jul 2020 15:28:22 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:28:21 -0700 (PDT)
Message-Id: <20200707.152821.167533135677461439.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: fix DSS map generation on fin retransmission
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1fa7663816c25b247db50501cf3d9df01729dc28.1593792286.git.pabeni@redhat.com>
References: <1fa7663816c25b247db50501cf3d9df01729dc28.1593792286.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:28:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri,  3 Jul 2020 18:06:04 +0200

> The RFC 8684 mandates that no-data DATA FIN packets should carry
> a DSS with 0 sequence number and data len equal to 1. Currently,
> on FIN retransmission we re-use the existing mapping; if the previous
> fin transmission was part of a partially acked data packet, we could
> end-up writing in the egress packet a non-compliant DSS.
> 
> The above will be detected by a "Bad mapping" warning on the receiver
> side.
> 
> This change addresses the issue explicitly checking for 0 len packet
> when adding the DATA_FIN option.
> 
> Fixes: 6d0060f600ad ("mptcp: Write MPTCP DSS headers to outgoing data packets")
> Reported-by: syzbot+42a07faa5923cfaeb9c9@syzkaller.appspotmail.com
> Tested-by: Christoph Paasch <cpaasch@apple.com>
> Reviewed-by: Christoph Paasch <cpaasch@apple.com>
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for -stable, thank you.
