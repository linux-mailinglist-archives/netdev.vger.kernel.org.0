Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272E45FA162
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 17:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiJJPty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 11:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiJJPtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 11:49:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F486B4B1;
        Mon, 10 Oct 2022 08:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C74360F98;
        Mon, 10 Oct 2022 15:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872CCC433C1;
        Mon, 10 Oct 2022 15:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665416988;
        bh=UGDgGegtJjnKbmhoE4P2UtEsFRje51IdIWm22s4C4TA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d1bZqiV2Tu6H8mxgT+dt42VjS2eMUlx5s5xJ0xJYGUafxKiXXMqWyUMUOk1l1N3xp
         FeYm/W18GexXWjXxxt5tQGQux3dhNDVk2FRJ49YLaZCYd3pz/lqCSBC/dKrDbFX0rg
         6JaDgTtky3z0XOUYhcSRffGaoQAGj6UQ1VfltBYYRqcrcYCyJGlVqMMlhPWyMrPJbA
         dMuuiv9G5MRDSAk17QFj3BTpK9JmGCk2aKggz9j/mtKGz2Z9ZoIM0giKY6KPVUoQD6
         8FFwElf5bR1C8spnAarIw5ks3qR2dA+ud0gbGb/z7h8lybcFFE9LFMG8658ORsX6sH
         gaJvjRgTmk9ng==
Date:   Mon, 10 Oct 2022 08:49:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nicolas.dichtel@6wind.com,
        gnault@redhat.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 17/77] genetlink: hold read cb_lock during
 iteration of genl_fam_idr in genl_bind()
Message-ID: <20221010084946.5d32cd60@kernel.org>
In-Reply-To: <20221009220754.1214186-17-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
        <20221009220754.1214186-17-sashal@kernel.org>
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

On Sun,  9 Oct 2022 18:06:54 -0400 Sasha Levin wrote:
> In genl_bind(), currently genl_lock and write cb_lock are taken
> for iteration of genl_fam_idr and processing of static values
> stored in struct genl_family. Take just read cb_lock for this task
> as it is sufficient to guard the idr and the struct against
> concurrent genl_register/unregister_family() calls.
> 
> This will allow to run genl command processing in genl_rcv() and
> mnl_socket_setsockopt(.., NETLINK_ADD_MEMBERSHIP, ..) in parallel.

Not stable material, please drop.
