Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE65711A55A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 08:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbfLKHsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 02:48:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfLKHsn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 02:48:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8893420637;
        Wed, 11 Dec 2019 07:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576050523;
        bh=4JZ8e8dgIBsEwHJUXH82+M2U3AS11Z7JV21zGuOxey4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WvN9ujTG/rkSPBA5i7NrgPvxm87aTaJM2wrtcgGLTFab2somSSD3B4Z+GZU8Ms6QA
         zOQO35JhqqwFaL/g+IQb5DBi6vgBbtOlvQPR97Ec+9DRQta/7N8go6pYKwjnu4M+mz
         xRVtBveDUoLfGaCLOGRA5d2h0eCuUQDA74LOjyYI=
Date:   Wed, 11 Dec 2019 08:48:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 077/130] rfkill: allocate static minor
Message-ID: <20191211074840.GH398293@kroah.com>
References: <20191210220301.13262-1-sashal@kernel.org>
 <20191210220301.13262-77-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210220301.13262-77-sashal@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 05:02:08PM -0500, Sasha Levin wrote:
> From: Marcel Holtmann <marcel@holtmann.org>
> 
> [ Upstream commit 8670b2b8b029a6650d133486be9d2ace146fd29a ]
> 
> udev has a feature of creating /dev/<node> device-nodes if it finds
> a devnode:<node> modalias. This allows for auto-loading of modules that
> provide the node. This requires to use a statically allocated minor
> number for misc character devices.
> 
> However, rfkill uses dynamic minor numbers and prevents auto-loading
> of the module. So allocate the next static misc minor number and use
> it for rfkill.
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> Link: https://lore.kernel.org/r/20191024174042.19851-1-marcel@holtmann.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/miscdevice.h | 1 +
>  net/rfkill/core.c          | 9 +++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)

This is not needed in older kernels, please do not backport it unless
the networking developers _REALLY_ think it is necessary.

thanks,

greg k-h
