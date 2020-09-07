Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDAD260508
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 21:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbgIGTKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 15:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728879AbgIGTKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 15:10:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4492220C09;
        Mon,  7 Sep 2020 19:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599505816;
        bh=rL+OTY79ZPxYIkgLoV6LOP1yYXoGFhs+iXjHhUWbaTI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jrvPTZ3VLRFv6fLbMXFxi1tD+Vz1z3uKMGbeWwdA3fruQBu566hglkkoOpg2NLJbB
         qFDAPYh88tJZcctUSDqBSaXa0Oqlxg+qQEgbTM2XdYtneJwDJHW/u7YJ0jIrXNxfT9
         V3uYeVMrK91hvmUn/m3L5f3cMX4n7AehjwtakmGU=
Date:   Mon, 7 Sep 2020 12:10:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     ying.xue@windriver.com, netdev@vger.kernel.org, jmaloy@redhat.com,
        maloy@donjonn.com,
        syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
Subject: Re: [net-next v2] tipc: fix a deadlock when flushing scheduled work
Message-ID: <20200907121014.033a183c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907060007.43750-1-hoang.h.le@dektech.com.au>
References: <20200907060007.43750-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Sep 2020 13:00:07 +0700 Hoang Huu Le wrote:
> In the commit fdeba99b1e58
> ("tipc: fix use-after-free in tipc_bcast_get_mode"), we're trying
> to make sure the tipc_net_finalize_work work item finished if it
> enqueued. But calling flush_scheduled_work() is not just affecting
> above work item but either any scheduled work. This has turned out
> to be overkill and caused to deadlock as syzbot reported:

Applied, thanks.
