Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2DE525671
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 22:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357126AbiELUiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 16:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354353AbiELUiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 16:38:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2CC483A5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 13:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=S/UI/eN4HwCCiWLOZ1UqE0EVsAjwaLVp/H45PVQBemM=; b=iz0EavQxhypRm4Zsnq7107JJrz
        tvZaMj0jceqW8uPxBqWzA/GCljz7vWfRAWorUuOYwQsPkF01lPm2Cgqm8VGvS0CbOKZWFdea6Tth3
        l3XIJ91Hv327qn1J5kFTumo78GwXSpcDX74djDySbpqZoFWoUNx+c1WNS2GesReapZ8E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1npFZT-002VEf-27; Thu, 12 May 2022 22:38:03 +0200
Date:   Thu, 12 May 2022 22:38:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH RFC] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Message-ID: <Yn1wK78zKzcgzg15@lunn.ch>
References: <20220505225904.342388-1-andrew@lunn.ch>
 <20220506143644.mzfffht44t3glwci@skbuf>
 <Ynd213m/0uXfjArm@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynd213m/0uXfjArm@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I like Andrew's patch because it is the Rx equivalent of
> br_switchdev_frame_unmark() in br_dev_xmit(). However, if we go with the
> second option, it should allow us to remove the clearing of the mark in
> the Tx path as the control block is cleared in the Tx path since commit
> fd65e5a95d08 ("net: bridge: clear bridge's private skb space on xmit").
> 
> I don't know how far back Nik's patch was backported and I don't know
> how far back Andrew's patch will be backported, so it might be best to
> submit Andrew's patch to net as-is and then in net-next change
> nbp_switchdev_allowed_egress() and remove br_switchdev_frame_unmark()
> from both the Rx and Tx paths.
> 
> Anyway, I have applied this patch to our tree for testing. Will report
> tomorrow in case there are any regressions.

Hi Ido

Did your testing find any issues?

Thanks
	Andrew
