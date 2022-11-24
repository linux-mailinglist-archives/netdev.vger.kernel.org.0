Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7F363710D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 04:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKXDaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 22:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiKXDaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 22:30:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47813D1C1D
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 19:30:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D732761FAF
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 03:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70C2C433C1;
        Thu, 24 Nov 2022 03:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669260650;
        bh=XjSgqMJjJwdCyxQo77pd5a0WkWo9aZiWlnQ9PFcpDTA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HOIhtT5mh09vX+19yo3az7S1OTAqONdC5+YWieY+K+asaPTzIi+yHIdnwe/+gDWZ3
         lr+QDTUGsFNFdjx+zbkMXWlLpRhESAbwG2v3TasrMNb/9XdqdPPlu5851jmdEZBxkr
         3LcpqOF9y8HtS8wJO0zTT7/3X5452s2mWYlm38pSRZOS/JcPTglHwxaMqiMO2AizHV
         2b9dZhXHoshTS2UUWZb/AYtce6yd3ANqmf1r/Hxt+CbwIw93V3ibfAl4qSso5Rgeq8
         XHmLSLWpKEIbp0CvkFQ2UXYl0EFx4h/tgm5tlLfvjaZhkheEXRRhmWf4UQ4d3G/iL9
         a6RxW2g8727qg==
Date:   Wed, 23 Nov 2022 19:30:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v5] ethtool: add netlink based get rss support
Message-ID: <20221123193048.7a19d246@kernel.org>
In-Reply-To: <20221123184846.161964-1-sudheer.mogilappagari@intel.com>
References: <20221123184846.161964-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Nov 2022 10:48:46 -0800 Sudheer Mogilappagari wrote:
> +  ``ETHTOOL_A_RSS_RINGS``              u32     Ring count

Let's not put the number of rings in RSS.

I keep having to explain to people how to calculate the correct number
of active RX rings. If the field is in the channels API hopefully
they'll just use it.

The max ring being in RXFH seems like a purely historic / legacy thing.
