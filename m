Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E13E66A77A
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 01:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjANAZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 19:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjANAZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 19:25:14 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE607C3BC
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:25:13 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so25968940pjj.4
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=73NRCJrLD416/Hi20U2Q4TjapbewKZUuWd9n2Q1rdXo=;
        b=J+pc8BWI++mjIkGf9+Ufg4UetjhEkq6RJDj7NAgmsx6bqLqKsU9dzLJpPEGyR1cAPT
         8X1ttEZyOwdX126X9LfSk2NhDYEQghA06o+a3x0qXzC7Lv04CbtXhBPeWh3VXm5/LB6F
         Dp4qDsSSLsnIaiKeJR9NcZvDiCdZLccZ8zlyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73NRCJrLD416/Hi20U2Q4TjapbewKZUuWd9n2Q1rdXo=;
        b=gviBc949/NwMv2W/SB5ZF99hXpxZ0KWgt9atorAcCN63/NPpxry1j3SHLKe7bqxrf+
         q/HAd79hRzO5DGUGqIOZuZuLLpFvkIlFHrpdTq0tuFja0Hn7Aa/KnJD75vBKCZv7x7a4
         ukcntRDyJpAeap1S7tBj6iwB5HEiuPO1wCdhYKHXzmotST0o8vvmSkNbcd1cuxG0ZRVd
         fs4J3+GxSxZEkKXuhlc/fWHStzRzXLo8ZlnkPk+zFqz+EC/sAzVfuLL5gJ0BmUwWdkBV
         Zd8Dq3VqAesHEbdiQyXyQPX5Lb33glBG740gE7cSEbwVCyrkjoAIRjZu3j/AhN2b0EYo
         FSSQ==
X-Gm-Message-State: AFqh2krHilPPeuKv3ADxR02bkrhLM75AH3Fa/JWoIm1UU/KlOTUvlHXJ
        lipUgZbPjZ8kmJX1LODrx8MbCw==
X-Google-Smtp-Source: AMrXdXv+eskL5UGF7aUYBOE7CjneSuw8PDPKPtUoppz0e4clDGq3+5K7tfp+KxBNLCIzpt5zGyIVcg==
X-Received: by 2002:a05:6a20:a887:b0:b8:2e75:c973 with SMTP id ca7-20020a056a20a88700b000b82e75c973mr1324301pzb.49.1673655912701;
        Fri, 13 Jan 2023 16:25:12 -0800 (PST)
Received: from [192.168.1.33] ([192.183.212.197])
        by smtp.googlemail.com with ESMTPSA id u13-20020a63f64d000000b00499bc49fb9csm12195367pgj.41.2023.01.13.16.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 16:25:11 -0800 (PST)
Message-ID: <1d917ac3-4bc7-2f1d-a0af-1148417c0565@schmorgal.com>
Date:   Fri, 13 Jan 2023 16:25:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230108013016.222494-1-doug@schmorgal.com>
 <20230108013016.222494-3-doug@schmorgal.com> <Y8Ep3yTp61h0GD2A@corigine.com>
From:   Doug Brown <doug@schmorgal.com>
Subject: Re: [PATCH v2 2/4] wifi: libertas: only add RSN/WPA IE in
 lbs_add_wpa_tlv
In-Reply-To: <Y8Ep3yTp61h0GD2A@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

On 1/13/2023 1:52 AM, Simon Horman wrote:
> On Sat, Jan 07, 2023 at 05:30:14PM -0800, Doug Brown wrote:
>> The existing code only converts the first IE to a TLV, but it returns a
>> value that takes the length of all IEs into account. When there is more
>> than one IE (which happens with modern wpa_supplicant versions for
>> example), the returned length is too long and extra junk TLVs get sent
>> to the firmware, resulting in an association failure.
>>
>> Fix this by finding the first RSN or WPA IE and only adding that. This
>> has the extra benefit of working properly if the RSN/WPA IE isn't the
>> first one in the IE buffer.
>>
>> While we're at it, clean up the code to use the available structs like
>> the other lbs_add_* functions instead of directly manipulating the TLV
>> buffer.
>>
>> Signed-off-by: Doug Brown <doug@schmorgal.com>
>> ---
>>   drivers/net/wireless/marvell/libertas/cfg.c | 28 +++++++++++++--------
>>   1 file changed, 18 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
>> index 3e065cbb0af9..5cd78fefbe4c 100644
>> --- a/drivers/net/wireless/marvell/libertas/cfg.c
>> +++ b/drivers/net/wireless/marvell/libertas/cfg.c
>> @@ -416,10 +416,20 @@ static int lbs_add_cf_param_tlv(u8 *tlv)
>>   
>>   static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
>>   {
>> -	size_t tlv_len;
>> +	struct mrvl_ie_data *wpatlv = (struct mrvl_ie_data *)tlv;
>> +	const struct element *wpaie;
>> +
>> +	/* Find the first RSN or WPA IE to use */
>> +	wpaie = cfg80211_find_elem(WLAN_EID_RSN, ie, ie_len);
>> +	if (!wpaie)
>> +		wpaie = cfg80211_find_vendor_elem(WLAN_OUI_MICROSOFT,
>> +						  WLAN_OUI_TYPE_MICROSOFT_WPA,
>> +						  ie, ie_len);
>> +	if (!wpaie || wpaie->datalen > 128)
>> +		return 0;
>>   
>>   	/*
>> -	 * We need just convert an IE to an TLV. IEs use u8 for the header,
>> +	 * Convert the found IE to a TLV. IEs use u8 for the header,
>>   	 *   u8      type
>>   	 *   u8      len
>>   	 *   u8[]    data
>> @@ -428,14 +438,12 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
>>   	 *   __le16  len
>>   	 *   u8[]    data
>>   	 */
>> -	*tlv++ = *ie++;
>> -	*tlv++ = 0;
>> -	tlv_len = *tlv++ = *ie++;
>> -	*tlv++ = 0;
>> -	while (tlv_len--)
>> -		*tlv++ = *ie++;
>> -	/* the TLV is two bytes larger than the IE */
>> -	return ie_len + 2;
>> +	wpatlv->header.type = wpaie->id;
>> +	wpatlv->header.len = wpaie->datalen;
> 
> Hi Doug,
> 
> For correctness should type and len be converted to little endian,
> f.e. using cpu_to_le16() ?
> 
> Likewise in patch 4/4.

Thank you for reviewing my changes. You are absolutely right -- this
would be broken on big-endian systems. That was a major oversight on my
part. Not sure how I missed it because all of the other functions do it
correctly. Nice catch! I'll fix it in the next version of the series.

> 
>> +	memcpy(wpatlv->data, wpaie->data, wpaie->datalen);
>> +
>> +	/* Return the total number of bytes added to the TLV buffer */
>> +	return sizeof(struct mrvl_ie_header) + wpaie->datalen;
>>   }
>>   
>>   /*
>> -- 
>> 2.34.1
>>
