Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA316567793
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiGETOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiGETMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:12:15 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19EE21E0C
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 12:11:57 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ay16so23300040ejb.6
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 12:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ptcWii6D/+h80TBNw9ZGY7pt9npADm9+QFIIgqaUFA4=;
        b=eih3ppoprP6sGWooYPd79A4RB+QblaRLGWokVZQj57r7P7SjC5wx7XpBIf6cm9YMzb
         tMTufFhtQ7gYWDqgkex4YiN1I88B4/CFenu2k/n1xG7KqkMygQbI0oS0AcTH2YBqoBnc
         8L/+XhJllFfXMyhRdWTMZqjtKVxi4G/EMYDE6JEAAMhkwKGd5AO7hLBbFHuzrC68LqTe
         dvFajEliiHulbKf+5TuDgoGxauKUK236gaJrtmPkhhu0nHtHRdtnckcWdDsOCjJktAOs
         qg27FCDZ0WsfFopOSG7Tg1asTKtK0vt8mvOm1LbFi1Lag6ksOjhOxBzElVsX9To6uZ4a
         xxCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ptcWii6D/+h80TBNw9ZGY7pt9npADm9+QFIIgqaUFA4=;
        b=FnvKuxmW7xrJF3t3t8v28SatX1HUuuYYrsOYDCxv98qBufvuBy7YEpDFHsmQuEaE3/
         fHzEaLukPFpgo501hHC0w0iUikesk1LrbDaiid8YvZOdVqvRlks8q1t4Vy5Grb6OoZfW
         nuFm6pdRmm7uONn6Km0aWU03v8OSaF/2qEMkBYD0VJlt/nIuJjLPRCcCj/5uoq7cut6v
         5QDUvr7/6m+n/mI1sOOEdBKS8H2MkYhVmJOKnB0IWVgSBLCoO/FgWsJ8DN5mIMWy5NiU
         LqSR9lr45Nwj8fIYiCMW0HIUTUHEJ5JnilieJhCen8G8qP2GWI6VrexoiFGsR5VB0/f3
         PE9A==
X-Gm-Message-State: AJIora+0e086J82KUgpd+3idk90NYAbIO1kD5P7sp6XR78xcLZdKy7Ic
        lZ5l9hg488y8zsPDiPp4zYnpiwtEuTo=
X-Google-Smtp-Source: AGRyM1tKlJmVtrwM0XaIiEWOCdSThUh0F1GM53UDdaTRlBJPBaiQZNFxe0Bj8DBrFXCkrUBCEO6VuA==
X-Received: by 2002:a17:906:77c8:b0:722:e753:fbbe with SMTP id m8-20020a17090677c800b00722e753fbbemr34119742ejn.692.1657048316207;
        Tue, 05 Jul 2022 12:11:56 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b67:e500:f0a2:195e:b254:a6a7? (dynamic-2a01-0c22-7b67-e500-f0a2-195e-b254-a6a7.c22.pool.telefonica.de. [2a01:c22:7b67:e500:f0a2:195e:b254:a6a7])
        by smtp.googlemail.com with ESMTPSA id t23-20020a170906609700b006fed062c68esm16168114ejj.182.2022.07.05.12.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 12:11:55 -0700 (PDT)
Message-ID: <5a11a710-2de6-a6ed-b4f6-0c6016cf05c1@gmail.com>
Date:   Tue, 5 Jul 2022 21:11:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] r8169: fix accessing unset transport header
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Erhard F." <erhard_f@mailbox.org>
References: <ee150b21-7415-dd3f-6785-0163fd150493@googlemail.com>
 <1670430b92ef3cbda6647ce249a6bafb9d243432.camel@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <1670430b92ef3cbda6647ce249a6bafb9d243432.camel@redhat.com>
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

On 05.07.2022 14:46, Paolo Abeni wrote:
> On Mon, 2022-07-04 at 00:12 +0200, Heiner Kallweit wrote:
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
> The patch LGTM, but I think you could mention in the commit message
> that the bug was [likely] introduced with commit bdfa4ed68187 ("r8169:
> use Giant Send"), but this change applies only on top of the commit
> specified by the fixes tag - just to help stable teams.
> 
Right, I'll submit a v2 with more details in the commit message.

> Thanks!
> 
> Paolo
> 
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 3098d6672..1b7fdb4f0 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -4190,7 +4190,6 @@ static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
>>  static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>>  				struct sk_buff *skb, u32 *opts)
>>  {
>> -	u32 transport_offset = (u32)skb_transport_offset(skb);
>>  	struct skb_shared_info *shinfo = skb_shinfo(skb);
>>  	u32 mss = shinfo->gso_size;
>>  
>> @@ -4207,7 +4206,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>>  			WARN_ON_ONCE(1);
>>  		}
>>  
>> -		opts[0] |= transport_offset << GTTCPHO_SHIFT;
>> +		opts[0] |= skb_transport_offset(skb) << GTTCPHO_SHIFT;
>>  		opts[1] |= mss << TD1_MSS_SHIFT;
>>  	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
>>  		u8 ip_protocol;
>> @@ -4235,7 +4234,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>>  		else
>>  			WARN_ON_ONCE(1);
>>  
>> -		opts[1] |= transport_offset << TCPHO_SHIFT;
>> +		opts[1] |= skb_transport_offset(skb) << TCPHO_SHIFT;
>>  	} else {
>>  		unsigned int padto = rtl_quirk_packet_padto(tp, skb);
>>  
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

