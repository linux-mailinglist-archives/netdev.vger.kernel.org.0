Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236F734836C
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbhCXVJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbhCXVJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:09:06 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B3CC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 14:09:05 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w8so134408pjf.4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 14:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PQbDHXjXaqlAFHMDY7A7uM49NjRsJ5cIjIXV7sJv99Q=;
        b=gIuj3uOiPj/PNlW9fwm/9ByUMQ5cUWkFuXzXpc1zStJXRr0pVh3ipBEgv3e7z0Ntrq
         qQ3UXKGA4W70Z0/6rDLvbEyY0mzbJ0d7YRTaYN68GlciuuL9mNR1MHHPdqQp/4ZT4o5c
         9rNPNVESA0J/gPEOlgYlk/domTOB4rGmWXPHXA9a1lI4DOvltU/Ncfum1F/rwR9I1oA6
         wvoj8H1WML7o9oXo8rrBUeTI6fcTVSPyttsgnbjas7fWq6m0WBPlr7s16Ow29+ES8IP8
         U1HJE0V9GFniXWSTd2z1sjgmsp/0BfNfNbH5+fg37P6fsuOtrIBDv0L21p5+4ueIGGj/
         sd0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PQbDHXjXaqlAFHMDY7A7uM49NjRsJ5cIjIXV7sJv99Q=;
        b=j54s22Bf3zTrI4jnBR3lCf7AWXBvwbdFJcVZkysMyf2cQwEdpBRUEK6gSBBB8UiUpl
         fq/16udZW9kskZYxpy3KCb7YEzXSo0+s1x6Eelu6HUOUlOKSOXhZRRvoHzl7TqD0vxyz
         RppMiOtoR3Y43v+azMbBh2qN7FhQCkixECgPyl7QHcjnBVBrhsHM0IUyHeIDoJisVrSs
         O0+x85tDgAJShfg0/5eC3//agak4cpVGvvv1tzeyRdrGZBYZzaIpnaNVtLc49ZPdVfXW
         GlYoRv+YsR3GMjayJkmtFziQE+HESOr6Zvpx7H6tCeRq/ic8kJj0GkwEessf1AiCQfFg
         j6SA==
X-Gm-Message-State: AOAM533zKifs99TPYSzAgEU69um7HSCkZ0qVsMFMfU6rSxOVWfwyP0qq
        qgK0mUkfJnjYsC/9QIar2ms=
X-Google-Smtp-Source: ABdhPJyroMe01qc+a8lTzCFbJbRYXsnEjTIa3PXiDiApl9RXtY818DxGoCFLA8RAx+bMbXIDtvYZxA==
X-Received: by 2002:a17:90a:c81:: with SMTP id v1mr5234080pja.23.1616620145247;
        Wed, 24 Mar 2021 14:09:05 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x2sm3196327pgb.89.2021.03.24.14.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 14:09:04 -0700 (PDT)
Subject: Re: lantiq_xrx200: Ethernet MAC with multiple TX queues
To:     Vladimir Oltean <olteanv@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org
References: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
 <20210324201331.camqijtggfbz7c3f@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <874dd389-dd67-65a6-8ccc-cc1d9fa904a2@gmail.com>
Date:   Wed, 24 Mar 2021 14:09:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210324201331.camqijtggfbz7c3f@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/2021 1:13 PM, Vladimir Oltean wrote:
> Hi Martin,
> 
> On Wed, Mar 24, 2021 at 09:04:16PM +0100, Martin Blumenstingl wrote:
>> Hello,
>>
>> the PMAC (Ethernet MAC) IP built into the Lantiq xRX200 SoCs has
>> support for multiple (TX) queues.
>> This MAC is connected to the SoC's built-in switch IP (called GSWIP).
>>
>> Right now the lantiq_xrx200 driver only uses one TX and one RX queue.
>> The vendor driver (which mixes DSA/switch and MAC functionality in one
>> driver) uses the following approach:
>> - eth0 ("lan") uses the first TX queue
>> - eth1 ("wan") uses the second TX queue
>>
>> With the current (mainline) lantiq_xrx200 driver some users are able
>> to fill up the first (and only) queue.
>> This is why I am thinking about adding support for the second queue to
>> the lantiq_xrx200 driver.
>>
>> My main question is: how do I do it properly?
>> Initializing the second TX queue seems simple (calling
>> netif_tx_napi_add for a second time).
>> But how do I choose the "right" TX queue in xrx200_start_xmit then?

If you use DSA you will have a DSA slave network device which will be
calling into dev_queue_xmit() into the DSA master which will be the
xrx200 driver, so it's fairly simple for you to implement a queue
selection within the xrx200 tagger for instance.

You can take a look at how net/dsa/tag_brcm.c and
drivers/net/ethernet/broadcom/bcmsysport.c work as far as mapping queues
from the DSA slave network device queue/port number into a queue number
for the DSA master.
-- 
Florian
