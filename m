Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2046E694D90
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjBMRBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjBMRBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:01:06 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0737B1ABD4;
        Mon, 13 Feb 2023 09:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=vmAw0L7I/WG89S4zN3RmZFE4Cij83+VkFvaonpV1zDw=; b=JsRWjAO+u54m/5S9ay/Ca/8vVb
        i8iQpMPlZRId2Tp+Dh+QCaXx4vEXS0VHaN7adz7ks1V4tFnLD9fvPa02GYvxS6JtTQn8QXKBji7jf
        jJJvlZIRIf9MJlJHTg5FNhFXoDctRNZUo9yvstPcHNX/TocqgHqhLMNwSevIPLQeFbke53QSUA5WW
        qL0953pWHyRTnLwwkYRgKQoU34jh//YULdd/thr5OCdtQ2JIbKt6IILnLqY6qOHifr29jC0jpLSED
        1eJlCJujc30GrFphPXayys5eI65Iy4Q2UrwWsgFZVWTkADCTL4Kb1s+5etJgNDTr5QL7e6/d4xxP1
        zQLUEzQw==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pRcC9-000DYD-EG; Mon, 13 Feb 2023 18:00:49 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pRcC8-000J2O-Ey; Mon, 13 Feb 2023 18:00:49 +0100
Subject: Re: [PATCH bpf-next] net: lan966x: set xdp_features flag
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, andrii@kernel.org, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com
References: <01f4412f28899d97b0054c9c1a63694201301b42.1676055718.git.lorenzo@kernel.org>
 <Y+isP2HNYKTHtHjf@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cfcc4936-086c-62f6-142f-1db1c42fb9d3@iogearbox.net>
Date:   Mon, 13 Feb 2023 18:00:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <Y+isP2HNYKTHtHjf@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26811/Mon Feb 13 09:46:22 2023)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/23 10:07 AM, Lorenzo Bianconi wrote:
>> Set xdp_features netdevice flag if lan966x nic supports xdp mode.
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> ---
>>   drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
>> index 580c91d24a52..b24e55e61dc5 100644
>> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
>> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
>> @@ -823,6 +823,11 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
>>   
>>   	port->phylink = phylink;
>>   
>> +	if (lan966x->fdma)
>> +		dev->xdp_features = NETDEV_XDP_ACT_BASIC |
>> +				    NETDEV_XDP_ACT_REDIRECT |
>> +				    NETDEV_XDP_ACT_NDO_XMIT;
>> +
>>   	err = register_netdev(dev);
>>   	if (err) {
>>   		dev_err(lan966x->dev, "register_netdev failed\n");
> 
> Since the xdp-features series is now merged in net-next, do you think it is
> better to target this patch to net-next?

Yes, that would be better given it's a pure driver change. I moved delegate
to netdev.

Thanks,
Daniel
