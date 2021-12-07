Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D516E46BDFA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbhLGOoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:44:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44040 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbhLGOoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:44:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CF75B817EC
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 14:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29C8C341C1;
        Tue,  7 Dec 2021 14:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638888050;
        bh=LBcpkO4darT6CUC6id3955z+gtHxBOCI6hwwpvaWfXs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MNVrRBpnb09wiG5C0/UP4g87LyR/N8O58v/3RV5eZSLySBApy4f8ZbQjnT/rzoy1X
         zbqUxiqd1tq0RKnSx7un1Z5QRqhH4ishE2nnb+6dvbLrTBjnX9+vWucwwZ5zP2AbVA
         dAXBH1kWV8fUodMcr/uva9W+71qOSqvlhl7B9aPwbBXVM5DdQZnyjYxVVgACaZkky9
         bqk5LDYusffo2AZ4XajQ9kFDXbUmHcb912DOBmjUU6vDcn7UU8Sv0uCjHw2CqCs5Hj
         l7dDAAESONvD0smpLXtPrrPmlOfdCIpKh9fhc+3i5Rd51r27AVd0wfP7YS004yZdOo
         3zeK8VRXpjYdA==
Date:   Tue, 7 Dec 2021 06:40:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 15/17] audit: add netns refcount tracker to
 struct audit_net
Message-ID: <20211207064048.363f22ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207005142.1688204-16-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
        <20211207005142.1688204-16-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Dec 2021 16:51:40 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  kernel/audit.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 121d37e700a62b53854c06199d9a89850ec39dd4..27013414847678af4283484feab2461e3d9c67ed 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -96,6 +96,7 @@ struct audit_net {
>   * @pid: auditd PID
>   * @portid: netlink portid
>   * @net: the associated network namespace
> + * ns_tracker: tracker for @net reference

You need the '@' sign. I'll add it when applying.

>   * @rcu: RCU head
>   *
>   * Description:
> @@ -106,6 +107,7 @@ struct auditd_connection {
>  	struct pid *pid;
>  	u32 portid;
>  	struct net *net;
> +	netns_tracker ns_tracker;
>  	struct rcu_head rcu;
>  };
>  static struct auditd_connection __rcu *auditd_conn;
