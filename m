Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978C712D617
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfLaEQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:16:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50424 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfLaEQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:16:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C61313EF098F;
        Mon, 30 Dec 2019 20:16:02 -0800 (PST)
Date:   Mon, 30 Dec 2019 20:16:01 -0800 (PST)
Message-Id: <20191230.201601.251701453443736395.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: sja1105: Reconcile the meaning of TPID
 and TPID2 for E/T and P/Q/R/S
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227011113.29349-1-olteanv@gmail.com>
References: <20191227011113.29349-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 20:16:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 27 Dec 2019 03:11:13 +0200

> For first-generation switches (SJA1105E and SJA1105T):
> - TPID means C-Tag (typically 0x8100)
> - TPID2 means S-Tag (typically 0x88A8)
> 
> While for the second generation switches (SJA1105P, SJA1105Q, SJA1105R,
> SJA1105S) it is the other way around:
> - TPID means S-Tag (typically 0x88A8)
> - TPID2 means C-Tag (typically 0x8100)
> 
> In other words, E/T tags untagged traffic with TPID, and P/Q/R/S with
> TPID2.
> 
> So the patch mentioned below fixed VLAN filtering for P/Q/R/S, but broke
> it for E/T.
> 
> We strive for a common code path for all switches in the family, so just
> lie in the static config packing functions that TPID and TPID2 are at
> swapped bit offsets than they actually are, for P/Q/R/S. This will make
> both switches understand TPID to be ETH_P_8021Q and TPID2 to be
> ETH_P_8021AD. The meaning from the original E/T was chosen over P/Q/R/S
> because E/T is actually the one with public documentation available
> (UM10944.pdf).
> 
> Fixes: f9a1a7646c0d ("net: dsa: sja1105: Reverse TPID and TPID2")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied and queued up for -stable, thanks.
