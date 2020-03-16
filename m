Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBD1187623
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 00:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732880AbgCPXQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 19:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732855AbgCPXQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 19:16:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46B8820663;
        Mon, 16 Mar 2020 23:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584400597;
        bh=NEcKMBw7ToCWsqlP75FDelY6EPVZ9TAZJYYMXw7HhEI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IoOu/v8YQQIB/ZYBOeNFAUKSIpxpvZxG+k5ZbKlCLYvMWafMzFFue+p1Nq27TwiQd
         yH6uvy/103JpMYmyZfbDGIc+9ImUldFErKv+2Au13zHb9JUiXw03BeHkDP56mJsGk5
         eUIWbGVmUWfnTL77Lbivsa1TFZ4JDR9qpN7pTSGY=
Date:   Mon, 16 Mar 2020 16:16:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next 3/3] net_sched: sch_fq: enable use of hrtimer
 slack
Message-ID: <20200316161635.5b2710d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200316230223.242532-4-edumazet@google.com>
References: <20200316230223.242532-1-edumazet@google.com>
        <20200316230223.242532-4-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 16:02:23 -0700 Eric Dumazet wrote:
> @@ -747,6 +750,7 @@ static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {

nit: since nothing has been added to fq_policy since we introduced
     strict netlink checking please consider adding:

	[TCA_FQ_UNSPEC] = { .strict_start_type = TCA_FQ_TIMER_SLACK },

>  	[TCA_FQ_ORPHAN_MASK]		= { .type = NLA_U32 },
>  	[TCA_FQ_LOW_RATE_THRESHOLD]	= { .type = NLA_U32 },
>  	[TCA_FQ_CE_THRESHOLD]		= { .type = NLA_U32 },
> +	[TCA_FQ_TIMER_SLACK]		= { .type = NLA_U32 },

