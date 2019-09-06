Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091C2ABF70
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 20:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436576AbfIFSbZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Sep 2019 14:31:25 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:45080 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730881AbfIFSbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 14:31:25 -0400
Received: from marcel-macpro.fritz.box (p4FEFC197.dip0.t-ipconnect.de [79.239.193.151])
        by mail.holtmann.org (Postfix) with ESMTPSA id F033FCECE4;
        Fri,  6 Sep 2019 20:40:09 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] net: enable wireless core features with
 WIRELESS_ALLCONFIG
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190906180551.163714-1-salyzyn@android.com>
Date:   Fri, 6 Sep 2019 20:31:21 +0200
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8BE8F117-CFB7-4FFA-B6B3-389A28C2ADCE@holtmann.org>
References: <20190906180551.163714-1-salyzyn@android.com>
To:     Mark Salyzyn <salyzyn@android.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

> In embedded environments the requirements are to be able to pick and
> chose which features one requires built into the kernel.  If an
> embedded environment wants to supports loading modules that have been
> kbuilt out of tree, there is a need to enable hidden configurations
> for core features to provide the API surface for them to load.
> 
> Introduce CONFIG_WIRELESS_ALLCONFIG to select all wireless core
> features by activating all the hidden configuration options, without
> having to specifically select any wireless module(s).
> 
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> Cc: kernel-team@android.com
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org # 4.19
> ---
> net/wireless/Kconfig | 14 ++++++++++++++
> 1 file changed, 14 insertions(+)
> 
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 67f8360dfcee..0d32350e1729 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -17,6 +17,20 @@ config WEXT_SPY
> config WEXT_PRIV
> 	bool
> 
> +config WIRELESS_ALLCONFIG
> +	bool "allconfig for wireless core"
> +	select WIRELESS_EXT
> +	select WEXT_CORE
> +	select WEXT_PROC
> +	select WEXT_SPY
> +	select WEXT_PRIV
> +	help
> +	  Config option used to enable all the wireless core functionality
> +	  used by modules.
> +
> +	  If you are not building a kernel to be used for a variety of
> +	  out-of-kernel built wireless modules, say N here.
> +

this looks rather legacy Wireless Extension (wext) specific. So it might be better to clearly name the option “legacy” and “wext” to not confuse anybody running an actual modern driver and userspace.

Regards

Marcel

