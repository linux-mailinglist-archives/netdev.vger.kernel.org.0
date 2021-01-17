Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F202F9034
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbhAQC0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 21:26:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbhAQC0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 21:26:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07F10223E8;
        Sun, 17 Jan 2021 02:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610850368;
        bh=OuU20mZMmyaPPJvgMYmx609RDPo40Y6wWDv8an6cmO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SLpm34yfnnKahbo0jHlkwwkvYKUl/xf29PFU6Ocx8az/EE96ckD+x1c4B1pSlU0pX
         +2rCo9BuFTq7nlmCLvdfYQm19WLAncq0Xi1wUe6Ryr9lRKsGYgcHaLnD8teDhpMExe
         zN3//PnzO8OIugbf1WyChoynP2Y0PjU0AWOSmOCKCbhvgKH255k9faD1N8CpbMUsra
         63Ad8UAGcSyzxSymZore3K/zIt7YE/A0ROk9T8l0D7bZJbsASBIiQvOpRQU0ZNBZq2
         sMkfXYSsFeFt+HT25vuLdejYx7boAKMas0NUTKhR52g5dtzQGt2oqLtL3HfcIG+Ux3
         sTXvOQbb7LqyA==
Date:   Sat, 16 Jan 2021 18:26:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bhaskar Upadhaya <bupadhaya@marvell.com>
Cc:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
Subject: Re: [PATCH  net-next 1/3] qede: add netpoll support for qede driver
Message-ID: <20210116182607.01f26f15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610701570-29496-2-git-send-email-bupadhaya@marvell.com>
References: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
        <1610701570-29496-2-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 01:06:08 -0800 Bhaskar Upadhaya wrote:
> Add net poll controller support to transmit kernel printks
> over UDP

Why do you need this patch? Couple years back netpoll was taught 
how to pull NAPIs by itself, and all you do is schedule NAPIs.

All the driver should do is to make sure that when napi is called 
with budget of 0 it only processes Tx completions, not Rx traffic.
