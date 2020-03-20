Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CC818C5AD
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 04:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgCTDWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 23:22:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46268 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCTDWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 23:22:17 -0400
Received: from localhost (c-73-193-106-77.hsd1.wa.comcast.net [73.193.106.77])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7DDF158E851E;
        Thu, 19 Mar 2020 20:22:16 -0700 (PDT)
Date:   Thu, 19 Mar 2020 20:22:06 -0700 (PDT)
Message-Id: <20200319.202206.1844889598253272050.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2] net: bridge: vlan: include stats in dumps
 if requested
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319101414.201391-1-nikolay@cumulusnetworks.com>
References: <20200319101414.201391-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 20:22:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Thu, 19 Mar 2020 12:14:14 +0200

> This patch adds support for vlan stats to be included when dumping vlan
> information. We have to dump them only when explicitly requested (thus the
> flag below) because that disables the vlan range compression and will make
> the dump significantly larger. In order to request the stats to be
> included we add a new dump attribute called BRIDGE_VLANDB_DUMP_FLAGS which
> can affect dumps with the following first flag:
>   - BRIDGE_VLANDB_DUMPF_STATS
> The stats are intentionally nested and put into separate attributes to make
> it easier for extending later since we plan to add per-vlan mcast stats,
> drop stats and possibly STP stats. This is the last missing piece from the
> new vlan API which makes the dumped vlan information complete.
> 
> A dump request which should include stats looks like:
>  [BRIDGE_VLANDB_DUMP_FLAGS] |= BRIDGE_VLANDB_DUMPF_STATS
> 
> A vlandb entry attribute with stats looks like:
>  [BRIDGE_VLANDB_ENTRY] = {
>      [BRIDGE_VLANDB_ENTRY_STATS] = {
>          [BRIDGE_VLANDB_STATS_RX_BYTES]
>          [BRIDGE_VLANDB_STATS_RX_PACKETS]
>          ...
>      }
>  }
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
> v2: Use a separate dump attribute for the flags instead of a reserved
>     field to avoid uapi breakage as noted by DaveM.
>     Rebased and retested on the latest net-next.

Thanks for reworking UAPI.

Applied, thanks.
