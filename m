Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7EE4B864B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 11:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiBPK5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 05:57:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiBPK5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 05:57:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8A413CD4;
        Wed, 16 Feb 2022 02:56:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FB5461981;
        Wed, 16 Feb 2022 10:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170E4C004E1;
        Wed, 16 Feb 2022 10:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645009016;
        bh=xiKkGXt6A5YyFmh0j9sFGYDcn01l6stWZ0ZrxZi3xnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h5zl08o+sRwz7zLT+C/yhueFZ1XZJuJczlZGxiMskGNbC3LiPyuT5xD/AO5dWi+AG
         8eZuqKanClgeUhcMSPtjg8hxEEKuq1eLtdzsAd7q7ukpoNK/XUOI1paJo8/BGLEzVj
         82tsRrznSB/SGRDXNEw31w/ietNkl9hr1LUYPBOw=
Date:   Wed, 16 Feb 2022 11:56:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Garry <john.garry@huawei.com>, kernel-team@android.com
Subject: Re: [PATCH 1/2] genirq: Extract irq_set_affinity_masks() from
 devm_platform_get_irqs_affinity()
Message-ID: <YgzYdYC5GEsCby1M@kroah.com>
References: <20220216090845.1278114-1-maz@kernel.org>
 <20220216090845.1278114-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216090845.1278114-2-maz@kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 09:08:44AM +0000, Marc Zyngier wrote:
> In order to better support drivers that deal with interrupts in a more
> "hands-on" way, extract the core of devm_platform_get_irqs_affinity()
> and expose it as irq_set_affinity_masks().
> 
> This helper allows a driver to provide a set of wired interrupts that
> are to be configured as managed interrupts. As with the original helper,
> this is exported as EXPORT_SYMBOL_GPL.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/base/platform.c   | 20 +++-----------------
>  include/linux/interrupt.h |  8 ++++++++
>  kernel/irq/affinity.c     | 27 +++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+), 17 deletions(-)
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
