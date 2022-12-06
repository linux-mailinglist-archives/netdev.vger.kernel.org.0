Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAFF644909
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbiLFQSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbiLFQSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:18:01 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAB432B8B
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:14:43 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E340321C5B;
        Tue,  6 Dec 2022 16:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670343281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=30clpMwUd2ErtsgU5kfdGbrPoVbhI8HnG5CqHNibHIU=;
        b=JjBVcta/PFKFibpYSP6be5ewwRCkIRhZ48m7qbBhorSvckCT+7s3AhMDJypcXbloUHy4gl
        uy7/qvfZnBHLz9ublgL+UHU+wjmfmR0WqTptechJX4VguejiRlGfv//odJKHa/E88zyJHa
        yzXrNx5Edib286e5ptKHWcYb08l+Sbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670343281;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=30clpMwUd2ErtsgU5kfdGbrPoVbhI8HnG5CqHNibHIU=;
        b=ZqySS7seeWY33x6Ba0nAF3z6/7hF/Y6W0JE2Q14+G0ryuXvFS9z3uUvFPr+ZXECsOS28Cb
        ToWEZH5zx4UsxVAg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C208B2C142;
        Tue,  6 Dec 2022 16:14:41 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6FA256030C; Tue,  6 Dec 2022 17:14:41 +0100 (CET)
Date:   Tue, 6 Dec 2022 17:14:41 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org, andrew@lunn.ch, corbet@lwn.net,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v7] ethtool: add netlink based get rss support
Message-ID: <20221206161441.ziprba72sfydmjrk@lion.mk-sys.cz>
References: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
 <Y4yPwR2vBSepDNE+@unreal>
 <20221204153850.42640ac2@kernel.org>
 <Y42hg4MsATH/07ED@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y42hg4MsATH/07ED@unreal>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 09:45:07AM +0200, Leon Romanovsky wrote:
> On Sun, Dec 04, 2022 at 03:38:50PM -0800, Jakub Kicinski wrote:
> > Conversion to netlink stands on its own.
> 
> It doesn't answer on my question. The answer is "we do, just because
> we can" is nice but doesn't remove my worries that such "future"
> extension will work with real future feature. From my experience, many
> UAPI designs without real use case in hand will require adaptions and
> won't work out-of-box.
> 
> IMHO, it is the same sin as premature optimization.

Extensibility is likely the most obvious benefit of the netlink
interface but it's not the only one, even without an immediate need to
add a new feature, there are other benefits, e.g.

  - avoiding the inherently racy get/modify/set cycle
  - more detailed error reporting thanks to extack
  - notifications (ethtool --monitor)

And I'm pretty sure the list is not complete. Thus I believe converting
the ioctl UAPI to netlink is useful even without waiting until we need
to add new features that would require it.

Michal
