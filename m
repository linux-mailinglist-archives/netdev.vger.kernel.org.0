Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83BC207EB4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404443AbgFXVhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403996AbgFXVhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 17:37:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BC8C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 14:37:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDF6A1272FA24;
        Wed, 24 Jun 2020 14:37:09 -0700 (PDT)
Date:   Wed, 24 Jun 2020 14:37:08 -0700 (PDT)
Message-Id: <20200624.143708.1919481157205194723.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        anuradhak@cumulusnetworks.com, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 0/4] net: bridge: fdb activity tracking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623204718.1057508-1-nikolay@cumulusnetworks.com>
References: <20200623204718.1057508-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 14:37:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Tue, 23 Jun 2020 23:47:14 +0300

> This set adds extensions needed for EVPN multi-homing proper and
> efficient mac sync. User-space (e.g. FRR) needs to be able to track
> non-dynamic entry activity on per-fdb basis depending if a tracked fdb is
> currently peer active or locally active and needs to be able to add new
> peer active fdb (static + track + inactive) without refreshing it to get
> real activity tracking. Patch 02 adds a new NDA attribute - NDA_FDB_EXT_ATTRS
> to avoid future pollution of NDA attributes by bridge or vxlan. New
> bridge/vxlan specific fdb attributes are embedded in NDA_FDB_EXT_ATTRS,
> which is used in patch 03 to pass the new NFEA_ACTIVITY_NOTIFY attribute
> which controls if an fdb should be tracked and also reflects its current
> state when dumping. It is treated as a bitfield, current valid bits are:
>  1 - mark an entry for activity tracking
>  2 - mark an entry as inactive to avoid multiple notifications and
>      reflect state properly
> 
> Patch 04 adds the ability to avoid refreshing an entry when changing it
> via the NFEA_DONT_REFRESH flag. That allows user-space to mark a static
> entry for tracking and keep its real activity unchanged.
> The set has been extensively tested with FRR and those changes will
> be upstreamed if/after it gets accepted.

Series applied, thanks.
