Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6794BAE00
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 01:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiBRAFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 19:05:31 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiBRAF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 19:05:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F264161B;
        Thu, 17 Feb 2022 16:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7897B61A55;
        Fri, 18 Feb 2022 00:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A5EC340E8;
        Fri, 18 Feb 2022 00:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645142708;
        bh=/E0vQpyQrzLPQg8mdsH5R57H9ioPtrWTrdq/i8BUvVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A8KBW0fFTFK0Qd2vGoc8H91Xk4kLW/hBFFbI9t895SQ+fV7j0gvFYuGmVEdrMVl7O
         12I0YeBrKmH0JZ2M6IXrTgpSyk+53tzlxqW2ZzhpF9OFPQG1Dwd68ukHFWpl1S7Akc
         LZrn4J4deQe0hPYa8pOJbT5yaLPXreAlGgEc+SvMMEus3FPQQHID/QiJyySdEi263i
         4LtmCWBevZo4YvJbulOT8l+lxNg4hwpN6s4qw4as4PLLUGLzRU83xo9UlIfca3jtbR
         M35UAaJprYEQkjgq8AY9uiMSrEtB3EeBLSqyhoJ7edXFc4D52N1eTUONKSAZ0Zzlnx
         AeHDEV/wpBJ2g==
Date:   Thu, 17 Feb 2022 16:05:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rakesh Babu Saladi <rsaladi2@marvell.com>
Cc:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Harman Kalra <hkalra@marvell.com>
Subject: Re: [net-next PATCH 1/3] octeontx2-af: Sending tsc value to the
 userspace
Message-ID: <20220217160507.05ae03fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217180450.21721-2-rsaladi2@marvell.com>
References: <20220217180450.21721-1-rsaladi2@marvell.com>
        <20220217180450.21721-2-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 23:34:48 +0530 Rakesh Babu Saladi wrote:
> +#if defined(CONFIG_ARM64)
> +	return is_pmu ? read_sysreg(pmccntr_el0) : read_sysreg(cntvct_el0);
> +#else
> +	return 0;
> +#endif

And this bit probably calls for a CC to linux-arm
