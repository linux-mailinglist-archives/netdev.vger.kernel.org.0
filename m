Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CF54D5A4E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 06:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241464AbiCKFOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 00:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240951AbiCKFOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 00:14:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41CCC484C
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 21:13:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A54F61A40
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 05:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782F2C340EC;
        Fri, 11 Mar 2022 05:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646975582;
        bh=/81d1fAKngWMcXAdWIbn/X6O/ofBp7xH7xglrBw9d1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TUrNM6IMpzG8Ixq2n/JrIKXTwjWzxkxSlKu52y0vRd75rwPOyQL2xXTRtBS8ROG7c
         koGC1WoT6PYYnuoAtXaK0tuCELQMMY5VPJFSQNaKMC+4deaoH/SV0nfADxUd/M2jxC
         3vKIxBaL7d53yZ6zvCpZs34j5+QMUz+6vXwZiX2R2u/VqtXbrdNw5lG6ngiUjcfIUP
         4OB1IYihc2cf74uHrvg31tGQmIysb5DkYGWfd9V67bciFuKsohR5LPQ6zrWZxPZPld
         p80KfCws43MkCcWAz5S6Ik9iIeRaKMI6psrkzPQRdmlMYSXr697S7bEU8E2EoB3aQe
         vzgC4ph5Z6O0w==
Date:   Thu, 10 Mar 2022 21:13:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/3] netdevsim: Introduce support for L3
 offload xstats
Message-ID: <20220310211301.477e323c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <288b325ace94f327b3d3149e2ee61c3d43cf6870.1646928340.git.petrm@nvidia.com>
References: <cover.1646928340.git.petrm@nvidia.com>
        <288b325ace94f327b3d3149e2ee61c3d43cf6870.1646928340.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 17:12:22 +0100 Petr Machata wrote:
> +static ssize_t nsim_dev_hwstats_l3_enable_write(struct file *file,
> +						const char __user *data,
> +						size_t count, loff_t *ppos)
> +{
> +	return nsim_dev_hwstats_do_write(file, data, count, ppos,
> +					 NSIM_DEV_HWSTATS_DO_ENABLE,
> +					 NETDEV_OFFLOAD_XSTATS_TYPE_L3);
> +}

I think you could avoid having the three wrappers if you kept 
separate fops and added a switch to the write function keying 
on debugfs_real_fops().

With that:

Acked-by: Jakub Kicinski <kuba@kernel.org>
