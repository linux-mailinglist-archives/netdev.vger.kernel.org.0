Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6551CEE80B
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfKDTPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:15:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbfKDTPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:15:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECEEF151D3D66;
        Mon,  4 Nov 2019 11:15:39 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:15:39 -0800 (PST)
Message-Id: <20191104.111539.1483994068865626222.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next] net: bridge: fdb: eliminate extra port state
 tests from fast-path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104093651.16754-1-nikolay@cumulusnetworks.com>
References: <20191104093651.16754-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:15:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Mon,  4 Nov 2019 11:36:51 +0200

> When commit df1c0b8468b3 ("[BRIDGE]: Packets leaking out of
> disabled/blocked ports.") introduced the port state tests in
> br_fdb_update() it was to avoid learning/refreshing from STP BPDUs, it was
> also used to avoid learning/refreshing from user-space with NTF_USE. Those
> two tests are done for every packet entering the bridge if it's learning,
> but for the fast-path we already have them checked in br_handle_frame() and
> is unnecessary to do it again. Thus push the checks to the unlikely cases
> and drop them from br_fdb_update(), the new nbp_state_should_learn() helper
> is used to determine if the port state allows br_fdb_update() to be called.
> The two places which need to do it manually are:
>  - user-space add call with NTF_USE set
>  - link-local packet learning done in __br_handle_local_finish()
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied, thank you.
