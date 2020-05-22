Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41851DEEBF
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbgEVR67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730750AbgEVR67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 13:58:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB5CC206D5;
        Fri, 22 May 2020 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590170338;
        bh=EVdbRbXJ1zmCu+CbpWNQp6WFx/2esvUH/DkQOxAnqqs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zSZpA4YlG5KXRM3JsB1sVntmZaoVUIhnzsw3nfN1Tg10b+zjSgH67h/4LCX3+7y0M
         Wn+gKOIOTSBPV0xFVoudWKhvx9DS3fELMXubbqYlv4xV7dQJO14Wz0REQAYQdcTSFX
         au6uqKtRLDCPvwZEduKs48OkWnszfS2X76t90neM=
Date:   Fri, 22 May 2020 10:58:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 00/12] net: atlantic: QoS implementation
Message-ID: <20200522105857.759e7589@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200522081948.167-1-irusskikh@marvell.com>
References: <20200522081948.167-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 11:19:36 +0300 Igor Russkikh wrote:
> This patch series adds support for mqprio rate limiters and multi-TC:
>  * max_rate is supported on both A1 and A2;
>  * min_rate is supported on A2 only;
> 
> This is a joint work of Mark and Dmitry.
> 
> To implement this feature, a couple of rearrangements and code
> improvements were done, in areas of TC/ring management, allocation
> control, etc.
> 
> One of the problems we faced is conflicting ptp functionality, which
> consumes a whole traffic class due to hardware limitations.
> Patches below have a more detailed description on how PTP and multi-TC
> co-exist right now.
> 
> v2:
>  * accommodated review comments (-Wmissing-prototypes and
>    -Wunused-but-set-variable findings);
>  * added user notification in case of conflicting multi-TC<->PTP
>    configuration;
>  * added automatic PTP disabling, if a conflicting configuration is
>    detected;
>  * removed module param, which was used for PTP disabling in v1;
> 
> v1: https://patchwork.ozlabs.org/cover/1294380/

Acked-by: Jakub Kicinski <kuba@kernel.org>
