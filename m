Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7D147759E
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbhLPPRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbhLPPRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 10:17:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0397FC061574;
        Thu, 16 Dec 2021 07:17:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63712B8247E;
        Thu, 16 Dec 2021 15:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE855C36AE4;
        Thu, 16 Dec 2021 15:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639667864;
        bh=e7mP1/gjH/BhHvugM3VkQWdiobAWdMElBh+OAKOqYu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cDNKmduyx1KMcGkxYJPkOWVnN1XG7b1aAlcG2ap/KJ7uVnFhoXNFgYeVaekrxPV/E
         3lfTHExlipPBic/l3Ce5Y8Kax/eYevsLdtMnWwsm7IsP7aFL7Hz+Hx9xsK/NmKQg/C
         2Uq0paX8TgGGIDpf7dmLug7EXVBYNceRVHt+R/NfCoKZGa57psM0WWg4n3m8VQFxO2
         Xv2XSfwDiRnL+duOJFUhGttIG5pBC0DVEVuVo/QsW28CjY9/mKJKYru3dLHEIBa1VF
         GpMdoVrp0k4N5qLxJXvun25P1xm0wrj7as/Rgj1ac5qRC71aYfPauhhYkQBQdp82kt
         RswdaHuDlhlmA==
Date:   Thu, 16 Dec 2021 07:17:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6, 2/2] net: Add dm9051 driver
Message-ID: <20211216071743.1de51554@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211216093246.23738-3-josright123@gmail.com>
References: <20211216093246.23738-1-josright123@gmail.com>
        <20211216093246.23738-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 17:32:46 +0800 Joseph CHAMG wrote:
> Add davicom dm9051 spi ethernet driver, The driver work with the
> device platform's spi master
> 
> remove the redundant code that phylib has support,
> adjust to be the reasonable sequence,
> fine tune comments, add comments for pause function support
> 
> Tested with raspberry pi 4. Test for netwroking function, CAT5
> cable unplug/plug and also ethtool detect for link state, and
> all are ok.

Please install sparse and make sure the driver builds cleanly with W=1
C=1 flags.

drivers/net/ethernet/davicom/dm9051.c:349:26: warning: symbol 'dm9051_ethtool_ops' was not declared. Should it be static?
drivers/net/ethernet/davicom/dm9051.c:381:31: warning: incorrect type in initializer (different base types)
drivers/net/ethernet/davicom/dm9051.c:381:31:    expected int rxlen
drivers/net/ethernet/davicom/dm9051.c:381:31:    got restricted __le16 [usertype] rxlen
drivers/net/ethernet/davicom/dm9051.c:421:31: warning: restricted __le16 degrades to integer
drivers/net/ethernet/davicom/dm9051.c:426:23: warning: incorrect type in assignment (different base types)
drivers/net/ethernet/davicom/dm9051.c:426:23:    expected int rxlen
drivers/net/ethernet/davicom/dm9051.c:426:23:    got restricted __le16 [usertype] rxlen
