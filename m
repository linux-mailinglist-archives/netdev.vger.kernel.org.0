Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728524B3232
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354485AbiBLAyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:54:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240377AbiBLAyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:54:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E25CD44;
        Fri, 11 Feb 2022 16:53:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFA1961D6F;
        Sat, 12 Feb 2022 00:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A26C340E9;
        Sat, 12 Feb 2022 00:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644627238;
        bh=c5QTto3nIipjljAfBREqA9bPfy3ZjC7JQ20nTi6pERA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uZyH84KAwrqX3N5sIeyjEwwI37yTCbu3uaA2vkZ3BcoPYrMA3FQ0uwRyLqlaXj15u
         9krCb4veUck5vgSVCiCqn+GbzSs3cXlgQJAF7nLNw5sXYnZt1OQz17V1/CIHMSyhOo
         b5wsLKY7MhGCcEyvI2Iuwje5Zu2ve7yT/ZI82QxqaY3LFtBH9ZmagYtCx8vlHaXq17
         7evFnt8DzalOmceAksbIw7oiXRICWfebwBHCfQCbb0w9bAumGXiy3AO357l7iwOFdj
         5QGWZTR+Rjg121HVrj/PJ6UQvPHANu9gN/5NSxY4wkvlqoJLfOVQWiz6RQdDU7aqEQ
         n1RrWIAcINHmA==
Date:   Fri, 11 Feb 2022 16:53:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] nfp: flower: Fix a potential leak in
 nfp_tunnel_add_shared_mac()
Message-ID: <20220211165356.1927a81b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
References: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 23:34:52 +0100 Christophe JAILLET wrote:
> ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
> inclusive.
> So NFP_MAX_MAC_INDEX (0xff) is a valid id.
> 
> In order for the error handling path to work correctly, the 'invalid'
> value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
> inclusive.
> 
> So set it to -1.
> 
> Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

This patch is a fix and the other one is refactoring. They can't be
in the same series because they need to go to different trees. Please
repost the former with [PATCH net] and ~one week later the latter with
[PATCH net-next].
