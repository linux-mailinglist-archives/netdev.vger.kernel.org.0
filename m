Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F663BB483
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 02:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhGEAiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 20:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhGEAiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 20:38:17 -0400
Received: from mxout017.mail.hostpoint.ch (mxout017.mail.hostpoint.ch [IPv6:2a00:d70:0:e::317])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CDBC061574;
        Sun,  4 Jul 2021 17:35:40 -0700 (PDT)
Received: from [10.0.2.44] (helo=asmtp014.mail.hostpoint.ch)
        by mxout017.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1m0CaG-000ILa-D6; Mon, 05 Jul 2021 02:35:36 +0200
Received: from [2a02:168:6182:1:4826:4d5:dcc6:d0b0]
        by asmtp014.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1m0CaG-000G3n-BG; Mon, 05 Jul 2021 02:35:36 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
Subject: Re: [PATCH] rtl8xxxu: disable interrupt_in transfer for 8188cu and
 8192cu
To:     chris.chiu@canonical.com, Jes.Sorensen@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210701163354.118403-1-chris.chiu@canonical.com>
From:   Reto Schneider <code@reto-schneider.ch>
Message-ID: <876caa77-702c-eb29-bfd1-c2ebcc4fb641@reto-schneider.ch>
Date:   Mon, 5 Jul 2021 02:35:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701163354.118403-1-chris.chiu@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.07.21 18:33, chris.chiu@canonical.com wrote:
> There will be crazy numbers of interrupts triggered by 8188cu and
> 8192cu module, around 8000~10000 interrupts per second, on the usb
> host controller. Compare with the vendor driver source code, it's
> mapping to the configuration CONFIG_USB_INTERRUPT_IN_PIPE and it is
> disabled by default.
> 
> Since the interrupt transfer is neither used for TX/RX nor H2C
> commands. Disable it to avoid the confusing interrupts for the
> 8188cu and 8192cu module which I only have for verification.

I tested the new code on the GARDENA smart gateway and it works as 
expected. Interrupts are greatly reduced while the same level of TX/RX 
performance could be measured as before the change: A (too) high 
percentage of retransmissions, but otherwise fine.

Tested-by: reto.schneider@husqvarnagroup.com

Kind regards,
Reto
