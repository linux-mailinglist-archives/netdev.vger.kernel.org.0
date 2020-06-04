Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA741EDB89
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 05:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgFDDGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 23:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgFDDGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 23:06:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3978206E6;
        Thu,  4 Jun 2020 03:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591239983;
        bh=YBYlP4b/eSJlaiamK5glgD4cox7LLH41b7ehnWoalMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ORe/TH3z/ALtUPzTVEiQJD1TpU+cVnj6qKuVaetDjVBGSMIfpNnGNXmQR8Y9Lmrfh
         b70mdZ5FGyhXA8SF12nY2ORH6G7C+zLLPMysJQ7eARsKhHl7wpYjQbwYZySaBTZ0zR
         j2Mqo9KxGVLBg0GLFeJqwl9rl1o5FSyx7dLg9PCc=
Date:   Wed, 3 Jun 2020 20:06:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miao-chen Chou <mcchou@chromium.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Manish Mandlik <mmandlik@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Yoni Shavit <yshavit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/7] Bluetooth: Add handler of
 MGMT_OP_ADD_ADV_PATTERNS_MONITOR
Message-ID: <20200603200621.52c24ee1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200603160058.v2.3.Iea5d308a1936ac26177316c977977cdf7de42de8@changeid>
References: <20200603160058.v2.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
        <20200603160058.v2.3.Iea5d308a1936ac26177316c977977cdf7de42de8@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Jun 2020 16:01:46 -0700 Miao-chen Chou wrote:
> This adds the request handler of MGMT_OP_ADD_ADV_PATTERNS_MONITOR command.
> Note that the controller-based monitoring is not yet in place. This tracks
> the content of the monitor without sending HCI traffic, so the request
> returns immediately.
> 
> The following manual test was performed.
> - Issue btmgmt advmon-add with valid and invalid inputs.
> - Issue btmgmt advmon-add more the allowed number of monitors.
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>

Looks like this adds new sparse warnings:

net/bluetooth/mgmt.c:3886:32: warning: incorrect type in assignment (different base types)
net/bluetooth/mgmt.c:3886:32:    expected unsigned int [usertype] supported_features
net/bluetooth/mgmt.c:3886:32:    got restricted __le32 [usertype]
net/bluetooth/mgmt.c:3888:29: warning: incorrect type in assignment (different base types)
net/bluetooth/mgmt.c:3888:29:    expected unsigned short [usertype] max_num_handles
net/bluetooth/mgmt.c:3888:29:    got restricted __le16 [usertype]
net/bluetooth/mgmt.c:3890:25: warning: incorrect type in assignment (different base types)
net/bluetooth/mgmt.c:3890:25:    expected unsigned short [usertype] num_handles
net/bluetooth/mgmt.c:3890:25:    got restricted __le16 [usertype]

Please make sure patches build cleanly with W=1 C=1 flags.
