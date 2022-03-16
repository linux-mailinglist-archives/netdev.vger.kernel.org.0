Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCFD4DB7D7
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346245AbiCPSTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344986AbiCPSTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:19:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59381E01F
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:17:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F266B81A76
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 18:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EE3C340E9;
        Wed, 16 Mar 2022 18:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647454676;
        bh=ty9fvidTblGxeLPSwUlqHqYfuHutWabBH5Zz8wkNXLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qVEYGKYGGO4BM45uQ9udLJ8IPF7bPv56c0a+MYMQIBujOuB1YObzev6L/4CPhIeb9
         DArNEKl94nlSAvom7vVJsntVJTxguxyReefSjRCb9IlCOkHwzFJpE3vBIlXcYuNSGV
         kMJB7nAdSFwauBIX3rC6sA+opf8vt3WIG2O8uBQefJRTNICExBfzD2iWPrDbo71qCM
         0rqZndnIyT/WEL1lAchK2OBYR1en4OeA/E0UAlU1VK70RxI21Xuq4XZBy3u5a/Q5LS
         m45Z3kAEEvMQmd++h1iLqkEhZHbl/5h/aqBtL91NTl202fRszYj+wkhC2OC8vR/Qi7
         9nKZeSRnfagPA==
Date:   Wed, 16 Mar 2022 11:17:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Michal Kubecek <mkubecek@suse.cz>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>
Subject: Re: [EXT] Re: bnx2x: ppc64le: Unable to set message level greater
 than 0x7fff
Message-ID: <20220316111754.5316bfb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY3PR18MB4612AD5E7F7D59233990A21DAB119@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <0497a560-8c7b-7cf8-84ee-bde1470ae360@molgen.mpg.de>
        <20220315183529.255f2795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <db796473-69cf-122e-ec40-de62659517b0@molgen.mpg.de>
        <ade0ed87-be4f-e3c7-5e01-4bfdb78fae07@molgen.mpg.de>
        <BY3PR18MB4612AD5E7F7D59233990A21DAB119@BY3PR18MB4612.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 11:49:39 +0000 Manish Chopra wrote:
> As ethtool over netlink has some limitations of the size,
> I believe you can configure ethtool with "--disable-netlink" and set those message levels fine

Yup, IIUC it works for Paul on a 5.17 system, that system likely has
old ethtool user space tool which uses ioctls instead of netlink.

What makes the netlink path somewhat non-trivial is that there is 
an expectation that the communication can be based on names (strings)
as well as bit positions. I think we'd need a complete parallel
attribute to carry vendor specific bits :S
