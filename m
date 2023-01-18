Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E66F6714A9
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjARHJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjARHJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:09:16 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7176D37B
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 22:36:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b10so3302831pjo.1
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 22:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kRFp5AWJPMrNjS6WWcHZS4kh0nZgqucYWR/EWiO9Wh0=;
        b=dL+3n0TZ/oAOepMJegas1wcTtlGhlfRuWvHdye+0OS8jENy8+eKbElpr8eBYm+pcuO
         VzT+xNQnmpxCdRS8oWTyOBL5qzjGxNiDApKwXSaTw7XYMtLEzhPOew+7YyHYJpQMs029
         vqWJMSdeSG8V8xUKbIemfm8US4H8IlW87L5Oo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kRFp5AWJPMrNjS6WWcHZS4kh0nZgqucYWR/EWiO9Wh0=;
        b=cnEvn9aaE1EVrfTv0FCMRgj8rtxRvwAuHzYSl0GHs0wx1gLoxXz5MCssEIdv9htuW5
         YY5ClKLdJUkadi7gYXfByl+JyDXICFj9dRXKilMvfNQu+e8jIFeTe7CMwdxvc5xt2Mgq
         n/sUI22uWXzyYcG1wdVz/awKEkhGaQKEu3KcmEEpVRgIt60eEdI7TfUEtf8CEZ6N74mP
         rNxIsYzw7B2vW7R4HWlTISpB09FutOrdllj3kf36ECI4hhTltzMEB1uRXhNhrqQje9g+
         MUKcpNKO04TGM5nxp46p8qCgzk1vaoA+1Nbml4C+TSvURxvn6CnQP++uOBmKeA2xsrLN
         a61Q==
X-Gm-Message-State: AFqh2koKXA6L85gX8hG4BIeGM/kIAEDuvYdJWu7KjcyfNwpxD+0QK2zP
        5T8VqwmqlhvdGKohCe8f079Osg==
X-Google-Smtp-Source: AMrXdXsdueiAmTD0urcSR+ukTZh40RICRsXLVimA/SjoNgKzkkcC88YfqCVfgX8BMgmBEMk/5ofxjw==
X-Received: by 2002:a17:903:25c4:b0:194:5a6f:75b6 with SMTP id jc4-20020a17090325c400b001945a6f75b6mr6713097plb.59.1674023759059;
        Tue, 17 Jan 2023 22:35:59 -0800 (PST)
Received: from [192.168.1.33] ([192.183.212.197])
        by smtp.googlemail.com with ESMTPSA id j14-20020a170903024e00b00189667acf19sm22263420plh.95.2023.01.17.22.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 22:35:57 -0800 (PST)
Message-ID: <85128345-4924-c1c9-85f0-7aebc4e40f93@schmorgal.com>
Date:   Tue, 17 Jan 2023 22:35:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dan Williams <dcbw@redhat.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230116202126.50400-1-doug@schmorgal.com>
 <20230116202126.50400-3-doug@schmorgal.com> <Y8ZjeKeNx0eHxt7f@corigine.com>
From:   Doug Brown <doug@schmorgal.com>
Subject: Re: [PATCH v3 2/4] wifi: libertas: only add RSN/WPA IE in
 lbs_add_wpa_tlv
In-Reply-To: <Y8ZjeKeNx0eHxt7f@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/2023 12:59 AM, Simon Horman wrote:
> On Mon, Jan 16, 2023 at 12:21:24PM -0800, Doug Brown wrote:
>> [You don't often get email from doug@schmorgal.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>
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
>> index 3e065cbb0af9..3f35dc7a1d7d 100644
>> --- a/drivers/net/wireless/marvell/libertas/cfg.c
>> +++ b/drivers/net/wireless/marvell/libertas/cfg.c
> 
> ...
> 
>> @@ -428,14 +438,12 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
>>           *   __le16  len
>>           *   u8[]    data
>>           */
>> -       *tlv++ = *ie++;
>> -       *tlv++ = 0;
>> -       tlv_len = *tlv++ = *ie++;
>> -       *tlv++ = 0;
>> -       while (tlv_len--)
>> -               *tlv++ = *ie++;
>> -       /* the TLV is two bytes larger than the IE */
>> -       return ie_len + 2;
>> +       wpatlv->header.type = cpu_to_le16(wpaie->id);
>> +       wpatlv->header.len = cpu_to_le16(wpaie->datalen);
>> +       memcpy(wpatlv->data, wpaie->data, wpaie->datalen);
> 
> Hi Doug,
> 
> Thanks for fixing the endiness issues with cpu_to_le16()
> This part looks good to me now. Likewise for patch 4/4.
> 
> One suggestion I have, which is probably taking things to far,
> is a helper for what seems to be repeated code-pattern.
> But I don't feel strongly about that.

Thanks Simon. Is this basically what you're suggesting for a helper?

static int lbs_add_ie_tlv(u8 *tlvbuf, const struct element *ie, u16 tlvtype)
{
	struct mrvl_ie_data *tlv = (struct mrvl_ie_data *)tlvbuf;
	tlv->header.type = cpu_to_le16(tlvtype);
	tlv->header.len = cpu_to_le16(ie->datalen);
	memcpy(tlv->data, ie->data, ie->datalen);
	return sizeof(struct mrvl_ie_header) + ie->datalen;
}

And then in the two functions where I'm doing that, at the bottom:

return lbs_add_ie_tlv(tlv, wpaie, wpaie->id);
return lbs_add_ie_tlv(tlv, wpsie, TLV_TYPE_WPS_ENROLLEE);

I could definitely do that to avoid repeating the chunk of code that
fills out the struct in the two functions. A lot of the other
lbs_add_*_tlv functions follow a similar pattern of setting up a struct
pointer and filling out the header, so I don't think it's too crazy to
just repeat the code twice. On the other hand, the example above does
look pretty darn clean. I don't feel strongly either way myself.

> 
>> +
>> +       /* Return the total number of bytes added to the TLV buffer */
>> +       return sizeof(struct mrvl_ie_header) + wpaie->datalen;
>>   }
>>
>>   /*
>> --
>> 2.34.1
>>
