Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D602A7017
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbgKDWCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729913AbgKDWBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 17:01:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C21862063A;
        Wed,  4 Nov 2020 22:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604527272;
        bh=EUZ4dHh2Zaj8dpFVStSy893BGuwxTShodSLcYrUqElI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HC40hXCilgDdKPzwaHkin0JjJPfds3x+2gJMGSOEJQBX4QYBKov51BZftSB1CITzd
         QlCYyP/VELzIEC3QM9swh9FAp+M2K4EAUj3xgdO4XpYIoxD4EGqlXq72XQ5kswj9vt
         hlF8uc6iw6f9zdWYLeB3j7105jv2CLwuUIDnUq+w=
Date:   Wed, 4 Nov 2020 14:01:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     marcelo.leitner@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net/sched: act_frag: add implict packet
 fragment support.
Message-ID: <20201104140111.5a105039@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604480192-25035-2-git-send-email-wenxu@ucloud.cn>
References: <1604480192-25035-1-git-send-email-wenxu@ucloud.cn>
        <1604480192-25035-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 16:56:32 +0800 wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently kernel tc subsystem can do conntrack in cat_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
> 
> This patch add support for a xmit hook to mirred, that gets executed before
> xmiting the packet. Then, when act_ct gets loaded, it configs that hook. 
> The frag xmit hook maybe reused by other modules.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

net/sched/act_api.c:27:1: warning: symbol 'tcf_xmit_hook_in_use' was not declared. Should it be static?
