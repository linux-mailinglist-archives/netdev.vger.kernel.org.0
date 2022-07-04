Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0DE56508E
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiGDJP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbiGDJPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:15:24 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426C8BF47
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 02:15:23 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id dn9so10329972ejc.7
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 02:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:message-id:date:mime-version:user-agent:content-language:to:cc
         :references:subject:in-reply-to:content-transfer-encoding;
        bh=AB3t+ekJ3pBs6U2toAhBKi00RANfOFepTROE1N+GqPg=;
        b=EpJgKn0FSWWRzsQt8bGSva03q3cwN0eWhO1ppGXLtW2V7+1NkRzsSfVSlFQGvp30QR
         27EfAa/EgKFbPHhkM6xSXniUnGwPXegAqkKk9IOakeZ3fm3XJHQLSkJ81ILYos54uL/S
         h65aZx+yubjrMymMgV8h6VP9dRmlT6KMGLE6Hbbr03RTJBKLBExZsPlXFOc9BwI6Opuu
         TFtoN+rPBuBpftEPxTIn20zHjzVc415mikV36h7dzNmwZWs8vqfFuggO5oIlP5VUkv2e
         g0cXXb8f9R0ll59xr3R4vF+x9z3USmAEzsPLWcuLicqOqEu0fc0q96D26qIGfgghPuUb
         jKpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:subject:in-reply-to
         :content-transfer-encoding;
        bh=AB3t+ekJ3pBs6U2toAhBKi00RANfOFepTROE1N+GqPg=;
        b=I24p4grMG67d4cc4NxhIqtQb53k2hcRzXFS8h6c/4Z3YR211S4aXyMdw4q8l2f8Wgx
         phF/YPZ05dUgYAcuiFpripjkS6+mBkivNZmVU6ObRTQ1zNar065y3UGHUFtIcZK+Z7Cn
         TRAUQjTvHkYy8OCsLgnIfErbTuTqT9YnR6QmQNIzfBedU1golNhtFIB/X7AMKJOVUH50
         NOwcUPi6grK0sGf2tZncCGyuJfwCacM25NgcUN4fOzyTXM86OHU2UTEbIOzIl1GmhWMr
         BMvsXrjjEOtAUMxqU3vrSAQ5kI03Ds2PrG83awv33mZWoSt6sivWdE22zs7URtscT7vV
         r4ow==
X-Gm-Message-State: AJIora/5y3VdcHqMgYOFbJ8XRQxAIRNDmtyz8PnY1+GCR+UyijKsAA1f
        qedoHOZLF9ICciW3xRfvvnUy4u1YDavlw98o
X-Google-Smtp-Source: AGRyM1s3MhmYQ+iswFOlUQfyRJLMlBoe6EsDSBRdpF/ItqcglT4yb0locaXG/4c9eHd7FZYIFPTbxw==
X-Received: by 2002:a17:906:4ccc:b0:6fe:9155:47ae with SMTP id q12-20020a1709064ccc00b006fe915547aemr26977640ejt.246.1656926121536;
        Mon, 04 Jul 2022 02:15:21 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c593:4a00:757b:3889:a69a:fae4? (dynamic-2a01-0c23-c593-4a00-757b-3889-a69a-fae4.c23.pool.telefonica.de. [2a01:c23:c593:4a00:757b:3889:a69a:fae4])
        by smtp.googlemail.com with ESMTPSA id s27-20020a170906355b00b00702d8b37a03sm13986381eja.17.2022.07.04.02.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 02:15:21 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
X-Google-Original-From: Heiner Kallweit <hkallweit1@googlemail.com>
Message-ID: <26745304-2c23-ae26-9cb9-2cf1fa5422ac@googlemail.com>
Date:   Mon, 4 Jul 2022 11:15:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Erhard F." <erhard_f@mailbox.org>
References: <ee150b21-7415-dd3f-6785-0163fd150493@googlemail.com>
 <YsI6bEFtM+2uK492@electric-eye.fr.zoreil.com>
Subject: Re: [PATCH net] r8169: fix accessing unset transport header
In-Reply-To: <YsI6bEFtM+2uK492@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.07.2022 02:55, Francois Romieu wrote:
> Heiner Kallweit <hkallweit1@gmail.com> :
>> 66e4c8d95008 ("net: warn if transport header was not set") added
>> a check that triggers a warning in r8169, see [0].
>>
>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=216157
>>
>> Fixes: 8d520b4de3ed ("r8169: work around RTL8125 UDP hw bug")
>> Reported-by: Erhard F. <erhard_f@mailbox.org>
>> Tested-by: Erhard F. <erhard_f@mailbox.org>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> /me wonders...
> 
> - bz216157 experiences a (2nd) warning because the rtl8169_tso_csum_v2
>   ARP path shares the factored read of the (unset) transport offset
>   but said ARP path does not use the transport offset.
>   -> ok, the warning is mostly harmless. 
> 
> - rtl8169_tso_csum_v2 non-ARP paths own WARN_ON_ONCE will always
>   complain before Eric's transport specific warning triggers.
>   -> ok, the warning is redundant.
> 
> - rtl8169_features_check
> 
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 3098d6672..1b7fdb4f0 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> [...]
>> @@ -4402,14 +4401,13 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>>  						struct net_device *dev,
>>  						netdev_features_t features)
>>  {
>> -	int transport_offset = skb_transport_offset(skb);
>>  	struct rtl8169_private *tp = netdev_priv(dev);
>>  
>>  	if (skb_is_gso(skb)) {
>>  		if (tp->mac_version == RTL_GIGA_MAC_VER_34)
>>  			features = rtl8168evl_fix_tso(skb, features);
>>  
>> -		if (transport_offset > GTTCPHO_MAX &&
>> +		if (skb_transport_offset(skb) > GTTCPHO_MAX &&
>>  		    rtl_chip_supports_csum_v2(tp))
>>  			features &= ~NETIF_F_ALL_TSO;
>>  	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
>> @@ -4420,7 +4418,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>>  		if (rtl_quirk_packet_padto(tp, skb))
>>  			features &= ~NETIF_F_CSUM_MASK;
>>  
>> -		if (transport_offset > TCPHO_MAX &&
>> +		if (skb_transport_offset(skb) > TCPHO_MAX &&
>>  		    rtl_chip_supports_csum_v2(tp))
>>  			features &= ~NETIF_F_CSUM_MASK;
>>  	}
> 
> Neither skb_is_gso nor CHECKSUM_PARTIAL implies a transport header so the
> warning may still trigger, right ?
>

I'm not an expert here, and due to missing chip documentation I can't say
whether the chip could handle hw csumming correctly w/o transport header.
I'd see whether we get more reports of this warning. If yes, then maybe
we should use skb_transport_header_was_set() explicitly and disable
hw csumming if there's no transport header.

> Btw it's a bit unexpected to see a "Fixes" tag related to a RTL8125 bug as
> well as a "Tested-by" by the bugzilla submitter when the dmesg included in
> bz216157 exibits a RTL8168e/8111e.
> 
The Fixes tag refers to the latest change to the affected code, therefore
it comes a little unexpected, right.
