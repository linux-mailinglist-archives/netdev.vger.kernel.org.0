Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C678F1DBB84
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgETRbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:31:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:46730 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726436AbgETRbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:31:15 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E60F96010A;
        Wed, 20 May 2020 17:31:14 +0000 (UTC)
Received: from us4-mdac16-59.ut7.mdlocal (unknown [10.7.66.50])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E350F200A4;
        Wed, 20 May 2020 17:31:14 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.198])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 63BAB22004D;
        Wed, 20 May 2020 17:31:14 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AAAB280083;
        Wed, 20 May 2020 17:31:13 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 20 May
 2020 18:31:07 +0100
Subject: Re: [PATCH v3 net-next] net: flow_offload: simplify hw stats check
 handling
From:   Edward Cree <ecree@solarflare.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jiri@resnulli.us>, <kuba@kernel.org>, <pablo@netfilter.org>
References: <2cf9024d-1568-4594-5763-6c4e4e8fe47b@solarflare.com>
Message-ID: <f2586a0e-fce1-cee9-e2dc-f3dc73500515@solarflare.com>
Date:   Wed, 20 May 2020 18:31:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <2cf9024d-1568-4594-5763-6c4e4e8fe47b@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25430.003
X-TM-AS-Result: No-1.506300-8.000000-10
X-TMASE-MatchedRID: fgYTp5Xatxa8rRvefcjeTfZvT2zYoYOwC/ExpXrHizwd0WOKRkwsh343
        HV+1jEvwHWJA3KtH9MFfQt5fdNpZ2kxtwZS3cxlMqjZ865FPtppKP8x7LsjXi5soi2XrUn/JIq9
        5DjCZh0zCLNfu05PakAtuKBGekqUpbGVEmIfjf3tKXWykORtq3KVFSYbNs/V8rA/g7nJ/y9hRbk
        ZxhjLG8mNuHHn2cNyf0IElP6gQQdeIe7p1bNVGNIVt/luADAcfu8YlVHIDt5A=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.506300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25430.003
X-MDID: 1589995874-sWBN5KS6mRhL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2020 18:21, Edward Cree wrote:
> @@ -582,7 +590,7 @@ nf_flow_offload_rule_alloc(struct net *net,
>  	const struct flow_offload_tuple *tuple;
>  	struct nf_flow_rule *flow_rule;
>  	struct dst_entry *other_dst;
> -	int err = -ENOMEM;
> +	int err = -ENOMEM, i;
>  
>  	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
>  	if (!flow_rule)
Whoops, this changebar isn't meant to be there.  Somehow I missed
 the unused var warning when I built it, too.
Drop this, I'll spin v4.
