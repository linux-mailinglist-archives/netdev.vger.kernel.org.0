Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EC549BAE7
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359161AbiAYSEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:04:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35502 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356732AbiAYSC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:02:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12C106152D
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 18:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55058C340E6;
        Tue, 25 Jan 2022 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643133742;
        bh=dQggk/57oopN0PZubI3ChuOsSZAJGps75/p96YAxvo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kxdW76xxCYWB0+EnL+iqb7fUlp8OjoXO/exV+W239Gl5A9EkUE8xv0n7nhCvdQXrD
         SQE3Wgs20hLlRHyHaksVj1TdOIr1t9d1cSh8pYBLWNR3H5Shi+alOdlUT2gNfrpD57
         faUADkSUwBnYQtIiHjuiImaHjFkQHqizP4gFgW8nBUfe2QVUFpvUYhBADGZyec9JP0
         RwCA8zuPIcCMLU5kNeBb3529xeZC0VLGjsEp8t9M4ON+i4BLg/+OUYTz7j8IawEyT1
         BBdA5k3i+duLadBb6+5T8RBZTpf8L3njpIpAg+5ZLbselou/YmTba6Whr6i7oqepfq
         VGRp2VuqM6Qow==
Date:   Tue, 25 Jan 2022 10:02:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 0/6] netns: speedup netns dismantles
Message-ID: <20220125100221.3ee4be37@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124202457.3450198-1-eric.dumazet@gmail.com>
References: <20220124202457.3450198-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 12:24:51 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> netns are dismantled by a single thread, from cleanup_net()
> 
> On hosts with many TCP sockets, and/or many cpus, this thread
> is spending too many cpu cycles, and can not keep up with some
> workloads.
> 
> - Removing 3*num_possible_cpus() sockets per netns, for icmp and tcp protocols.
> - Iterating over all TCP sockets to remove stale timewait sockets.
> 
> This patch series removes ~50% of cleanup_net() cpu costs on
> hosts with 256 cpus. It also reduces per netns memory footprint.

Applied, thanks, 51d555cfdcc6 ("Merge branch
'netns-speedup-dismantle'") in net-next.
