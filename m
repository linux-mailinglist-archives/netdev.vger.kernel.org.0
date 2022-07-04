Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCF3565DD5
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 21:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiGDTLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 15:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiGDTLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 15:11:17 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EDA1E4
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:11:15 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id o4so14663029wrh.3
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 12:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:message-id:date:mime-version:user-agent:content-language:to:cc
         :references:subject:in-reply-to:content-transfer-encoding;
        bh=qJIlytN/QcTsbPfybqHa6iRT4Jp0Fcepg0LwkcQfAGc=;
        b=RGCv8X1siogvZpI44Gx4o0jGtw18bdnxpO25OPCPsnplDO0bAJ/ARqIsRr49s8Lzli
         e/NU0ZYh7xXAwVQD6Xm8+oE9g9qqoT5tNOmdxGoVEFiFTnJgc09rk6UHqcOblO7Tj+tZ
         oKyyPvVABLQcC826LNGjZXPSRebYFA+xRxjkNiZC+bf1I1gM8Tr2YqcJf64tzjtPVS2E
         bg2jea6fSz81tiGKMrI/TofiST/ZHUYu4SC0ZJl1ZrnWD96uTFHaLdPsQ6qHNAj6tfEs
         IcuoZvSeaUI/ZceRVpWgA61MT0usKVeJHMTGXbwXeL3ZKiRyYw8a1Fb1Ev0+inT3LBgT
         sF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:subject:in-reply-to
         :content-transfer-encoding;
        bh=qJIlytN/QcTsbPfybqHa6iRT4Jp0Fcepg0LwkcQfAGc=;
        b=tc62SeWJFJ5qypJ0ArOhyEM/+BqF3li2+hnUT0GWUlcrlGopl0Z+3ilBOiqawxHsYa
         2B8phoZPJhRhYiSp2HXcL8CTpmM4QevtcDBocL4tGnM+MIrfCAmpp6sHN8ci4hbzz5tG
         kK3CtSrxCQtcV7b+AwEKFySEbKq0GXuqWmPIqMzbbg2k/crxkqDa8dJAVh8eOz5OaU5S
         B0mAHAYKhg4waVp9ECfDMDU9VwxTN+hx45GXZym74sWMrEvgnoHEr7zpQrIKFRy5QkfK
         q1r3alCXME/xIs5t6jZny6FCREt4o6JgmcMJLmd4y78KSjp1KTcdewnchUHznnMkmG/M
         dY4w==
X-Gm-Message-State: AJIora/HN38ay8XRvQKLf8nRw+EkK8ahJM9iqESozAKRozTZE8aqGAcG
        SDkPrZdf4nyP5x60iPbXWQA=
X-Google-Smtp-Source: AGRyM1vOQ8mmPQxNZ6BSDGrTTr5++obcugtONpVHEMhCiLSvaMJ27wvjFHntt1cCuS/ODBRE1o9wEA==
X-Received: by 2002:a5d:55cd:0:b0:21d:6d9d:2c4e with SMTP id i13-20020a5d55cd000000b0021d6d9d2c4emr3647037wrw.544.1656961873783;
        Mon, 04 Jul 2022 12:11:13 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bd68:6b00:d1d3:12d2:dd53:88a9? (dynamic-2a01-0c23-bd68-6b00-d1d3-12d2-dd53-88a9.c23.pool.telefonica.de. [2a01:c23:bd68:6b00:d1d3:12d2:dd53:88a9])
        by smtp.googlemail.com with ESMTPSA id r5-20020a05600c320500b0039db500714fsm19424704wmp.6.2022.07.04.12.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 12:11:13 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
X-Google-Original-From: Heiner Kallweit <hkallweit1@googlemail.com>
Message-ID: <0c3da9d8-20fb-81ef-23a6-ab88921cf0d2@googlemail.com>
Date:   Mon, 4 Jul 2022 21:10:56 +0200
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
 <26745304-2c23-ae26-9cb9-2cf1fa5422ac@googlemail.com>
 <YsMJ3foj4v57xPF0@electric-eye.fr.zoreil.com>
Subject: Re: [PATCH net] r8169: fix accessing unset transport header
In-Reply-To: <YsMJ3foj4v57xPF0@electric-eye.fr.zoreil.com>
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

On 04.07.2022 17:40, Francois Romieu wrote:
> Heiner Kallweit <hkallweit1@gmail.com> :
>> On 04.07.2022 02:55, Francois Romieu wrote:
>>> Heiner Kallweit <hkallweit1@gmail.com> :
>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> [...]
>>>> @@ -4420,7 +4418,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>>>>  		if (rtl_quirk_packet_padto(tp, skb))
>>>>  			features &= ~NETIF_F_CSUM_MASK;
>>>>  
>>>> -		if (transport_offset > TCPHO_MAX &&
>>>> +		if (skb_transport_offset(skb) > TCPHO_MAX &&
>>>>  		    rtl_chip_supports_csum_v2(tp))
>>>>  			features &= ~NETIF_F_CSUM_MASK;
>>>>  	}
>>>
>>> Neither skb_is_gso nor CHECKSUM_PARTIAL implies a transport header so the
>>> warning may still trigger, right ?
>>
>> I'm not an expert here, and due to missing chip documentation I can't say
>> whether the chip could handle hw csumming correctly w/o transport header.
>> I'd see whether we get more reports of this warning. If yes, then maybe
>> we should use skb_transport_header_was_set() explicitly and disable
>> hw csumming if there's no transport header.
> 
> (some sleep later)
> 
> I had forgotten the NETIF_F_* stuff in the r8169 driver. :o/
> 
> So, yes, ignore this point.
> 
>>> Btw it's a bit unexpected to see a "Fixes" tag related to a RTL8125 bug as
>>> well as a "Tested-by" by the bugzilla submitter when the dmesg included in
>>> bz216157 exibits a RTL8168e/8111e.
>>>
>> The Fixes tag refers to the latest change to the affected code, therefore
>> it comes a little unexpected, right.
> 
> ?
> 
> 8d520b4de3ed does not change the affected code.
> 

This chunk of 8d520b4de3ed 

@@ -4128,9 +4183,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 
 		opts[1] |= transport_offset << TCPHO_SHIFT;
 	} else {
-		if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
-			/* eth_skb_pad would free the skb on error */
-			return !__skb_put_padto(skb, ETH_ZLEN, false);
+		unsigned int padto = rtl_quirk_packet_padto(tp, skb);
+
+		/* skb_padto would free the skb on error */
+		return !__skb_put_padto(skb, padto, false);
 	}
 
 	return true;

changes the context for this part of the patch. Therefore the patch wouldn't
apply cleanly.


@@ -4235,7 +4234,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 		else
 			WARN_ON_ONCE(1);
 
-		opts[1] |= transport_offset << TCPHO_SHIFT;
+		opts[1] |= skb_transport_offset(skb) << TCPHO_SHIFT;
 	} else {
 		unsigned int padto = rtl_quirk_packet_padto(tp, skb);
 


> Eric's unset transport offset detection debug code would have produced the
> same output with the parent of the "Fixes" commit id:
> 

I know, but due to the fact that the warnings are harmless and the new check
doesn't exist in earlier versions, I think we can omit these kernel versions.

> $ git cat-file -p 8d520b4de3ed^:drivers/net/ethernet/realtek/r8169_main.c | grep -A4 -B1 -E 'rtl8169_features_check'
> 
> static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
> 						struct net_device *dev,
> 						netdev_features_t features)
> {
> 	int transport_offset = skb_transport_offset(skb);
> --
> 	.ndo_start_xmit		= rtl8169_start_xmit,
> 	.ndo_features_check	= rtl8169_features_check,
> 	.ndo_tx_timeout		= rtl8169_tx_timeout,
> 	.ndo_validate_addr	= eth_validate_addr,
> 	.ndo_change_mtu		= rtl8169_change_mtu,
> 	.ndo_fix_features	= rtl8169_fix_features,
> 
> 
> -> 8d520b4de3ed does not modify the first
> 'int transport_offset = skb_transport_offset(skb);' statement and neither
> does it modify the code path to rtl8169_features_check 
> 
> 8d520b4de3ed actually removes some logical path towards rtl8169_tso_csum_v2
> but it does not change (nor does it break) the relevant code:
> 
> $ git cat-file -p 8d520b4de3ed^:drivers/net/ethernet/realtek/r8169_main.c | grep -A3 -B1 -E 'bool rtl8169_tso_csum_v2'
> 
> static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
> 				struct sk_buff *skb, u32 *opts)
> {
> 	u32 transport_offset = (u32)skb_transport_offset(skb);
> 
> 

