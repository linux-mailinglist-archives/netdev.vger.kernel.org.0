Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30F61C951B
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgEGPch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:32:37 -0400
Received: from correo.us.es ([193.147.175.20]:53002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgEGPcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 11:32:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0CA6E04D1
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 17:32:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9854D1158E5
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 17:32:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9690711540B; Thu,  7 May 2020 17:32:34 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53CB7DA7B2;
        Thu,  7 May 2020 17:32:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 May 2020 17:32:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 34C1942EF4E2;
        Thu,  7 May 2020 17:32:32 +0200 (CEST)
Date:   Thu, 7 May 2020 17:32:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, jiri@resnulli.us, kuba@kernel.org
Subject: Re: [RFC PATCH net] net: flow_offload: simplify hw stats check
 handling
Message-ID: <20200507153231.GA10250@salvia>
References: <49176c41-3696-86d9-f0eb-c20207cd6d23@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49176c41-3696-86d9-f0eb-c20207cd6d23@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 03:59:09PM +0100, Edward Cree wrote:
> Make FLOW_ACTION_HW_STATS_DONT_CARE be all bits, rather than none, so that
>  drivers and __flow_action_hw_stats_check can use simple bitwise checks.

You have have to explain why this makes sense in terms of semantics.

_DISABLED and _ANY are contradicting each other.

> In mlxsw we check for DISABLED first, because we'd rather save the counter
>  resources in the DONT_CARE case.

And this also is breaking netfilter again.

> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
> Compile tested only.
> 
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 8 ++++----
>  include/net/flow_offload.h                            | 8 ++++----

Turning DONT_CARE gives us nothing back at all.
