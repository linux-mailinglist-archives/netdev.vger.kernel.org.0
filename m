Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27BFB4B156B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiBJSjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:39:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbiBJSje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:39:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A85ECE9;
        Thu, 10 Feb 2022 10:39:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 061CE61E6F;
        Thu, 10 Feb 2022 18:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DB0C340EB;
        Thu, 10 Feb 2022 18:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644518374;
        bh=b07f1GxdoOuKuMvv3zNN3biyiCkI8Pzd46OTnjrluY4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qJuk7Fk5WK3HPpPorIkUtt4+QQkXBOO++n/ChrBykPUXkF8Xu53anA5naKAXUOUnu
         Z5W1sm5sv5tqNCua16WlbRHqFd6H8W/LEaMYqlsmA+sIES6aRZRSX4PrF0xs2YOxYf
         y2JIwQeyT3bV+pqkDVWFk4ZDmuCAuYFX4tS1fIOlTI5n2tVQkh4zVFtOBEq1ooYnaU
         k0cAS+Ga7Xz4RrZ90dK1WNCe3Vt3AV3xqfQYbx/LdPLzLnFmVpf2I8CMgrYoarlNmy
         nFJgcM1MPyMUc6StncQ4XToyIs7llHWPvRj1jTrRXw0kIGHfempq/Ta4O0JQ8ENMki
         5++5Jd9WJE1Ow==
Date:   Thu, 10 Feb 2022 10:39:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: Re: [net-next PATCH] octeontx2-af: fix array bound error
Message-ID: <20220210103932.17c656e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220210163557.7256-1-hkelam@marvell.com>
References: <20220210163557.7256-1-hkelam@marvell.com>
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

On Thu, 10 Feb 2022 22:05:57 +0530 Hariprasad Kelam wrote:
> This patch fixes below error by using proper data type.
> 
> drivers/net/ethernet/marvell/octeontx2/af/rpm.c: In function
> 'rpm_cfg_pfc_quanta_thresh':
> include/linux/find.h:40:23: error: array subscript 'long unsigned
> int[0]' is partly outside array bounds of 'u16[1]' {aka 'short unsigned
> int[1]'} [-Werror=array-bounds]
>    40 |                 val = *addr & GENMASK(size - 1, offset);
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

Could you send the Reported-by: tag? Was it repored by the kernel
build bot? 
