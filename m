Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCEE626B13
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 19:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbiKLSfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 13:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiKLSfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 13:35:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D832514D1D;
        Sat, 12 Nov 2022 10:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uIThvLw3JbBnQNmg7e0j7p8PgKlHw7oUIj3GN/sgoK8=; b=kfz+qtB1vsX/fRRLUqEJMDFR5g
        LKZyKkwxvhCfqDLnpdmkdbnRxNZUtfZPy01BBRTUflI4/ksU7nVJHb5UE48KfQdljAlOrgMpfnHyd
        x8NaPCHYYzylOQucfdW8w9Nyo8uUcPyyAyYRzszec1tWLk1DKjZg7xX5MZl1G8KYJdYw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otvM6-002CSt-Qy; Sat, 12 Nov 2022 19:35:50 +0100
Date:   Sat, 12 Nov 2022 19:35:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com
Subject: Re: [net-next PATCH 0/9] CN10KB MAC block support
Message-ID: <Y2/nhhi2jGUSk7L/@lunn.ch>
References: <20221112043141.13291-1-hkelam@marvell.com>
 <20221111211235.2e8f03c0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111211235.2e8f03c0@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 09:12:35PM -0800, Jakub Kicinski wrote:
> On Sat, 12 Nov 2022 10:01:32 +0530 Hariprasad Kelam wrote:
> > The nextgen silicon CN10KB supports new MAC block RPM2
> > and has a variable number of LMACS. This series of patches
> > defines new mac_ops and configures csrs specific to new
> > MAC.
> > 
> > Defines new mailbox support to Reset LMAC stats, read
> > FEC stats and set Physical state such that PF netdev
> > can use mailbox support to use the features.
> > 
> > Extends debugfs support for MAC block to show dropped
> > packets by DMAC filters and show FEC stats
> 
> I personally see no reason for us to keep merging your AF patches.
> Upstream is for working together and there is no synergy between
> your code, other drivers and the user APIs we build. Why not just 
> keep it out of tree?

Yes, see my comment about the ethtool .get_fec_stats. Maybe it is
there, hidden amongst all the code, but it is not obvious.

If you do want to stay in tree, may i suggest you move all your
statistics in your debugfs to official kernel APIs, and then remove
them from debugfs. This might require you work with the community to
extend the current APIs, which is the synergy thing Jakub is taking
about.

	Andrew
