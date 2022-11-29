Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AF263C756
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiK2Sph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiK2Spe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:45:34 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB810220D2;
        Tue, 29 Nov 2022 10:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eBWuh73tk9XJat2zMB8IWchuBJYyyUZAlX9rylZctiU=; b=dZIH6KeddKTB+s6/ptXQkZ+1ya
        krekgr2RMH5VD/WsdYE/RYOmu4T6co1rOLxOxprHx534rnuBzwtoCOydat60bBILyJDffmSwycgmn
        2h7xmPMIGc8UB5JopdK3YkoKG9JQEtSd6D7/Gac/N9nFTeVlklqyC7dUob6KoSipmrXU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p05bm-003u3h-EF; Tue, 29 Nov 2022 19:45:30 +0100
Date:   Tue, 29 Nov 2022 19:45:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com
Subject: Re: [net-next PATCH V2 3/4] octeontx2-pf: ethtool: Implement
 get_fec_stats
Message-ID: <Y4ZTSh7/xCJVosyW@lunn.ch>
References: <20221129051409.20034-1-hkelam@marvell.com>
 <20221129051409.20034-4-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129051409.20034-4-hkelam@marvell.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 10:44:08AM +0530, Hariprasad Kelam wrote:
> The current implementation is such that FEC statistics are reported as
> part of ethtool statistics that is the user can fetch them from the
> below command
> 
> "ethtool -S eth0"
> 
> Fec Corrected Errors:
> Fec Uncorrected Errors:
> 
> This patch removes this logic

What might break the ABI, if anybody is using these statistics, or has
a dumb parser and just looks at entry 42 which is now a different
entry.

So i think you need to keep these two, and additionally report them
the correct way via get_fec_stats.

    Andrew
