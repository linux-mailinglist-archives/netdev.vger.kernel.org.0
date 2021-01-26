Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF45304D94
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732602AbhAZXLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:11:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388761AbhAZUgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 15:36:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E9A221FC;
        Tue, 26 Jan 2021 20:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611693361;
        bh=3VkdR2ztfnDJiazl5+Pnuwv9d9urcEqKhxtg8qavKyY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tjYftICQkCr6Xtnf3Y8F+VoXLIQRI1M4WZOqaLoiiLk3dPi1kYF9j5nMNvMt9U32v
         OtUalOJPT6z8DTXPtRJ5gyqjoR7AEDA59mOM+JhecCJQaWbdVmUaMpRX1XDR/+rdyx
         f3uFZtnWEpk/Jt744moGBwoN+SmZZwv8eKzP5qDv1YbO3Hwxh9TH5MEkjiPZy1go4N
         ZJGdDb+H3JV+XWxHVk698JHwMGMPH0djxgk3bgOsXvyJ+BRTB1CC0TSyEH10Ndv6e9
         jTMyHESQ6HYnkXPbV+usmCtb0HRUjJzugdpq1arUOBCVolxAI+kdq9YFVX2bhJlD1F
         ha98L7nphE/sQ==
Date:   Tue, 26 Jan 2021 12:36:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev@vger.kernel.org,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v2 1/1] rtnetlink: extend
 RTEXT_FILTER_SKIP_STATS to IFLA_VF_INFO
Message-ID: <20210126123600.3def019b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126174024.185001-2-edwin.peer@broadcom.com>
References: <20210126174024.185001-1-edwin.peer@broadcom.com>
        <20210126174024.185001-2-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 09:40:24 -0800 Edwin Peer wrote:
> This filter already exists for excluding IPv6 SNMP stats. Extend its
> definition to also exclude IFLA_VF_INFO stats in RTM_GETLINK.
> 
> This patch constitutes a partial fix for a netlink attribute nesting
> overflow bug in IFLA_VFINFO_LIST. By excluding the stats when the
> requester doesn't need them, the truncation of the VF list is avoided.
> 
> While it was technically only the stats added in commit c5a9f6f0ab40
> ("net/core: Add drop counters to VF statistics") breaking the camel's
> back, the appreciable size of the stats data should never have been
> included without due consideration for the maximum number of VFs
> supported by PCI.
> 
> Fixes: 3b766cd83232 ("net/core: Add reading VF statistics through the PF netdevice")
> Fixes: c5a9f6f0ab40 ("net/core: Add drop counters to VF statistics")
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>

You don't seem to have addressed or as little as responded to all 
the feedback on v1.
