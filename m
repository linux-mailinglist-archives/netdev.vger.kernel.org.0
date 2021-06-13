Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8923A58E4
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 15:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhFMN4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 09:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhFMN4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 09:56:00 -0400
Received: from mxout017.mail.hostpoint.ch (mxout017.mail.hostpoint.ch [IPv6:2a00:d70:0:e::317])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33C5C061574;
        Sun, 13 Jun 2021 06:53:58 -0700 (PDT)
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
        by mxout017.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lsQYh-000NnB-6r; Sun, 13 Jun 2021 15:53:51 +0200
Received: from [2a02:168:6182:1:d747:8127:5b7a:4266]
        by asmtp012.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lsQYh-000JXF-4H; Sun, 13 Jun 2021 15:53:51 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
Subject: Re: [PATCH v1 2/2] net: ethernet: mtk_eth_soc: Support custom ifname
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        netdev@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210613115820.1525478-1-code@reto-schneider.ch>
 <20210613115820.1525478-2-code@reto-schneider.ch>
 <20210613122043.GP22278@shell.armlinux.org.uk>
From:   Reto Schneider <code@reto-schneider.ch>
Message-ID: <aa7a15cc-761f-00b0-5582-a8045d8f30ed@reto-schneider.ch>
Date:   Sun, 13 Jun 2021 15:53:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210613122043.GP22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 13.06.21 14:20, Russell King (Oracle) wrote:
> Please don't use strncpy() - this is a good example why strncpy() is bad
> news.
> 
>   * strncpy - Copy a length-limited, C-string
>   * @dest: Where to copy the string to
>   * @src: Where to copy the string from
>   * @count: The maximum number of bytes to copy
>   *
>   * The result is not %NUL-terminated if the source exceeds
>   * @count bytes.
> 
> Consequently, if "name" is IFNAMSIZ bytes or longer,
> eth->netdev[id]->name will not be NUL terminated, and subsequent use
> will run off the end of the string. strscpy() is safer to use here.

Thanks a lot for finding this (embarrassing mistake) and pointing me in 
the right direction (did dot know about strscpy).

Will send v2 soon.

Kind regards,
Reto
