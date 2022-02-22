Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18F44BF1A3
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 06:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiBVFnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 00:43:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiBVFnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 00:43:13 -0500
Received: from mailserv1.kapsi.fi (mailserv1.kapsi.fi [IPv6:2001:67c:1be8::25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF4EDEAB;
        Mon, 21 Feb 2022 21:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ext.kapsi.fi; s=20161220; h=Subject:Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
        :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GmHGvFlMERYoctqrhlXNA24je+le5xDzuYUVLipVXiQ=; b=HXKbeB87PoAiP5/i0Tiq7WLqNR
        xhurak0NO3Du3ZAg3Xy+YxnAQyxIuV4VnW0EEkUWVdQ4nh5bkKVW9vt+TechfdA9c7aw2LRgS4xIe
        YlwfCssgeJ9YC+Ey2wFFVrlgz2tBOXx26+JAxgoWu9dupU8YqdNMvHtCO5XNkgjeweDIE0MEG1Mpq
        yg1Up+ua9gv+ZTQuK6s/YTyoar3/GBvED+x57araH6sQS6B87YmDVmKzG+i2xtwqT8I3Onr/O0AoI
        e6Qu+KbwyBpmJ6lBRUzd0eP9KTUPY+fo2NpMetRD3eqO7W5++2LCAtZuVvY0tcAaH0/5er5nG6s+Z
        sJwkzcrw==;
Received: from 20e7-cd64-ca8f-bce1-aa00-87c4-07d0-2001.dyn.estpak.ee ([2001:7d0:87c4:aa00:bce1:ca8f:cd64:20e7]:62077)
        by mailserv1.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <maukka@ext.kapsi.fi>)
        id 1nMNwW-0000BI-5o; Tue, 22 Feb 2022 07:42:32 +0200
Message-ID: <91729285-67f9-8fdb-4f97-f0e958cff8dd@ext.kapsi.fi>
Date:   Tue, 22 Feb 2022 07:42:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, maukka@ext.kapsi.fi
References: <20220221062441.2685-1-maukka@ext.kapsi.fi>
 <YhOD3eCm8mYHJ1HF@lunn.ch>
 <72041ee7-a618-85d0-4687-76dae2b04bbc@ext.kapsi.fi>
 <YhQO52cvzIo8prKi@lunn.ch>
From:   Mauri Sandberg <maukka@ext.kapsi.fi>
In-Reply-To: <YhQO52cvzIo8prKi@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:7d0:87c4:aa00:bce1:ca8f:cd64:20e7
X-SA-Exim-Mail-From: maukka@ext.kapsi.fi
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: [PATCH] net: mv643xx_eth: handle EPROBE_DEFER
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mailserv1.kapsi.fi)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22.2.2022 0.15, Andrew Lunn wrote:
>>> Please can you add code to remove the platform device when the probe
>>> fails.
>>
>> I am looking at the vector 'port_platdev' that holds pointers to already
>> initialised ports. There is this mv643xx_eth_shared_of_remove(), which
>> probably could be utilised to remove them. Should I remove the platform
>> devices only in case of probe defer or always if probe fails?
>   
> In general, a failing probe should always undo anything it has done so
> far. Sometimes you can call the release function, or its
> helpers. Other times you do a goto out: and then release stuff in the
> reverse order it was taken.
> 
> It looks like platform_device_del() can take a NULL pointer, so it is
> probably O.K. to call mv643xx_eth_shared_of_remove().

While I am on it, should I call of_node_put() to all port nodes as is
being done to the current child node if probe fails in function
mv643xx_eth_shared_of_probe() [1]?

[1] 
https://elixir.bootlin.com/linux/v5.16/source/drivers/net/ethernet/marvell/mv643xx_eth.c#L2800

-- Mauri
