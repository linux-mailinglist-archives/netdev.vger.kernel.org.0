Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9415411001
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 09:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhITHYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 03:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbhITHYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 03:24:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0DBC061574;
        Mon, 20 Sep 2021 00:23:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mSDdp-0005mR-Mn; Mon, 20 Sep 2021 09:23:05 +0200
Date:   Mon, 20 Sep 2021 09:23:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH net v5 2/2] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
Message-ID: <20210920072305.GI15906@breakpoint.cc>
References: <20210920005905.9583-1-Cole.Dishington@alliedtelesis.co.nz>
 <20210920005905.9583-3-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920005905.9583-3-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> FTP port selection ignores specified port ranges (with iptables
> masquerade --to-ports) when creating an expectation, based on
> FTP commands PORT or PASV, for the data connection.
> 
> For masquerading, this issue allows an FTP client to use unassigned
> source ports for their data connection (in both the PORT and PASV
> cases). This can cause problems in setups that allocate different
> masquerade port ranges for each client.
> 
> The proposed fix involves storing a port range (on nf_conn_nat) to:
> - Fix FTP PORT data connections using the stored port range to select a
>   port number in nf_conntrack_ftp.
> - Fix FTP PASV data connections using the stored port range to specify a
>   port range on source port in nf_nat_helper if the FTP PORT/PASV packet
>   comes from the client.

Looks much simpler now, thanks.

Acked-by: Florian Westphal <fw@strlen.de>
