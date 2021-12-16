Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F76747763F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhLPPpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhLPPpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 10:45:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5B8C06173E
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 07:45:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D5643CE21C4
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 15:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CF5C36AE0;
        Thu, 16 Dec 2021 15:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639669547;
        bh=swrQv+Dg77aT1ZBQsKFX507kKA/X+/gI+NK/C8bHL3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iVqlQ79AOtCwa3CxXCdxHAOhfc/mxg6x15+hQuigsraTaU2ED2cCGv2vEdNvfG3HG
         HXjfa51ECAlnxqaPaOreh8AzwkmW7GcqPDjDW3s7p9MXgcu6cCvTDy81QS7cAlhtLi
         jr52vQ/sNgp3LCZ/+AGesQbaY6SbkKDyv4HwP7uiy6WTLcUwGZay4y03RBQZJTo3VO
         ykBu6Cj/WegJdIkAs2As2waMGMwIYeABQUIKR3DnmntjL0v/VYlKaLuA0oTDQx/eK0
         hOUXc4oKw9rP1Yg47CrwFe6UesW/fOagqU/Cziuc8mPtTDrEhhp9+R3IgiMJVm744+
         ArLUw87rFD0nA==
Date:   Thu, 16 Dec 2021 07:45:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     intel-wired-lan@lists.osuosl.org, davem@davemloft.net,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [net-queue PATCH 1/5] i40e: Remove rx page reuse double count.
Message-ID: <20211216074545.036ab8e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1639521730-57226-2-git-send-email-jdamato@fastly.com>
References: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
        <1639521730-57226-2-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 14:42:06 -0800 Joe Damato wrote:
> Page reuse was being tracked from two locations:
>   - i40e_reuse_rx_page (via 40e_clean_rx_irq), and
>   - i40e_alloc_mapped_page
> 
> Remove the double count and only count reuse from i40e_alloc_mapped_page
> when the page is about to be reused.
> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>

Possibly a fix, this one?
