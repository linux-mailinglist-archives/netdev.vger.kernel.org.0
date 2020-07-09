Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92B421ABC6
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 01:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgGIXp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 19:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgGIXp6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 19:45:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04DF72070E;
        Thu,  9 Jul 2020 23:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594338358;
        bh=7fTLSevMH3QOHKBO+40Tu6VJxm1d2rjJtTvX5ceS550=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qpZBfPS7lB781TorLKh1L0+kPrlSDWEEW5Up0pxwMBLWHs/Mx4Mvs7AU4SeGDB9BW
         CjJiUGCPdtp/j7ugwXs9pZrvkLgfUPbXJiPVFfdrqTaKu3wSBRw+UYrAeasyjVQHOJ
         sn8zFFpa1BWPJBGQ23ET5jdxFeQHlo1xVS01yYvA=
Date:   Thu, 9 Jul 2020 16:45:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, emil.s.tantilov@intel.com,
        alexander.h.duyck@linux.intel.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, mkubecek@suse.cz
Subject: Re: [PATCH net-next v3 00/10] udp_tunnel: add NIC RX port offload
 infrastructure
Message-ID: <20200709164556.470e8ba1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709232900.105163-1-kuba@kernel.org>
References: <20200709232900.105163-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 16:28:50 -0700 Jakub Kicinski wrote:
> v3:
>  - fix build issue;

Ugh. The drivers need access to the stubs as well. Maybe:

+#ifdef CONFIG_INET
 extern const struct udp_tunnel_nic_ops *udp_tunnel_nic_ops;
+#else
+#define udp_tunnel_nic_ops     NULL
+#endif
