Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54995D3C35
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfJKJZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 05:25:09 -0400
Received: from fd.dlink.ru ([178.170.168.18]:33774 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfJKJZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 05:25:09 -0400
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id EF5BC1B219DF; Fri, 11 Oct 2019 12:25:06 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru EF5BC1B219DF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1570785907; bh=2zbqnAAuO645gpFzhhwvyF+3tN85Ck5znV40ghXMwBs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=D0YMuiUtay0eLi/niPZrXHdGMio2Bm8Kl7iWmcxTX3uq/ONSHV5W4TJujS0M+0Uy+
         898QX9pJ8YvsCl9jOEvxvAbnK/b00AAjoxyehaeg9pSqVBMeL4EKi27Js5qW4Bv9LZ
         ne9WFd5NPHZWXd+4YZrSBpEkcd2pfTbDwcTSQ0d8=
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id E03B11B20208;
        Fri, 11 Oct 2019 12:25:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru E03B11B20208
Received: by mail.rzn.dlink.ru (Postfix, from userid 5000)
        id C62771B218D8; Fri, 11 Oct 2019 12:25:03 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA id 4994D1B218D8;
        Fri, 11 Oct 2019 12:24:56 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 11 Oct 2019 12:24:56 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Edward Cree <ecree@solarflare.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next1/2] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
In-Reply-To: <b6d30f87-88b4-f009-bc7f-dcf2ed9a9d67@solarflare.com>
References: <20191010144226.4115-1-alobakin@dlink.ru>
 <20191010144226.4115-2-alobakin@dlink.ru>
 <bb454c3c-1d86-f81e-a03e-86f8de3e9822@solarflare.com>
 <e7eaf0a1d236dda43f5cd73887ecfb9d@dlink.ru>
 <b6d30f87-88b4-f009-bc7f-dcf2ed9a9d67@solarflare.com>
Message-ID: <6404af326e37c0f34c3dbc9f33a1009a@dlink.ru>
X-Sender: alobakin@dlink.ru
User-Agent: Roundcube Webmail/1.3.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote 11.10.2019 12:20:
>>> On 10/10/2019 15:42, Alexander Lobakin wrote:
>>>> Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
>>>> skbs") made use of listified skb processing for the users of
>>>> napi_gro_frags().
>>>> The same technique can be used in a way more common 
>>>> napi_gro_receive()
>>>> to speed up non-merged (GRO_NORMAL) skbs for a wide range of 
>>>> drivers,
>>>> including gro_cells and mac80211 users.
>>>> 
>>>> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> Acked-by: Edward Cree <ecree@solarflare.com>
> but I think this needs review from the socionext folks as well.

Thanks!
Sure, I'm waiting for any other possible comments.

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
