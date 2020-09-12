Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2784C267AC7
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 16:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgILOPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 10:15:25 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:37446 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgILOPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 10:15:05 -0400
Received: from [10.0.2.15] ([93.22.150.101])
        by mwinf5d61 with ME
        id T2F2230012BWSNM032F25a; Sat, 12 Sep 2020 16:15:03 +0200
X-ME-Helo: [10.0.2.15]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 12 Sep 2020 16:15:03 +0200
X-ME-IP: 93.22.150.101
Subject: Re: [PATCH] tlan: switch from 'pci_' to 'dma_' API
To:     davem@davemloft.net, kuba@kernel.org, andy@greyhouse.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200912102519.337303-1-christophe.jaillet@wanadoo.fr>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <840e5434-1bbf-51c5-e1ba-6a26e0b4e49c@wanadoo.fr>
Date:   Sat, 12 Sep 2020 16:15:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200912102519.337303-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/09/2020 à 12:25, Christophe JAILLET a écrit :
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'tlan_init()' GFP_KERNEL can be used because
> it is only called from a probe function or a module_init function and no
> lock is taken in the between.
> The call chain is:
>    tlan_probe                        (module_init function)
>      --> tlan_eisa_probe
> or
>    tlan_init_one                     (probe function)
> 
> then in both cases:
>      --> tlan_probe1
>        --> tlan_init
> 
> [...]
> ---
>   drivers/net/ethernet/ti/tlan.c | 61 ++++++++++++++++------------------
>   1 file changed, 28 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
> index 76a342ea3797..1203a3c0febb 100644
> --- a/drivers/net/ethernet/ti/tlan.c
> +++ b/drivers/net/ethernet/ti/tlan.c
> [...]

This patch has been sent twice.
This one is the 2nd copy with the wrong person in To:.

Apologizes for the noise.

CJ
