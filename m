Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EB14870F4
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345026AbiAGDFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344999AbiAGDFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 22:05:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12492C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 19:05:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9520C61EE0
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 03:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA42C36AE3;
        Fri,  7 Jan 2022 03:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641524718;
        bh=39qBzthUmdDg+1l2wMyEZa+QuR68D2AGN1FKSX8o7x0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=njHCaT9X4+DZt2CA1GgTo0r6Fgl5Ci8HsklynOQmzaFVwuMzFnRw+dw8CE22hkq75
         zrt6u7s+R6xRwyD6/m1olEzLrhcqF0bq+JGAmN6i524Gqwzwo6suPX/CulwGaSia9o
         BDikVxNlruPlN6JQefEEYF4qLzie5tz0vFXvjujzrD6gVnfmfgY/p+hBQMwLdDOeSg
         OQSsCy1bqgMBg63wu7V2WuxOUZ56Q1QbOwQ/8y9PIvtNtE2ERHvl7mEnF9/KUHxPRb
         5tkrRlnD6wmuggf0ym3oL03DOUbWQ2tiXwkfIrCeY/ps3kHqmpFGjYJ4LySqpahqF2
         XIv4oHBoAUFKA==
Date:   Thu, 6 Jan 2022 19:05:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Thompson <davthompson@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <chenhao288@hisilicon.com>, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v1] mlxbf_gige: add interrupt counts to
 "ethtool -S"
Message-ID: <20220106190516.147e9e32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220106172910.26431-1-davthompson@nvidia.com>
References: <20220106172910.26431-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jan 2022 12:29:10 -0500 David Thompson wrote:
> This patch extends the output of "ethtool -S", adding
> interrupt counts for the three mlxbf_gige interrupt types.

Why? These count separate, non-shared interrupts. You get the same
stats from /proc/interrupts with per-cpu break down.

Since core already has this information rather than reporting those
via ethtool you should remove the counters from the driver.
