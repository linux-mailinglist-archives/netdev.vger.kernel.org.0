Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C62465E5AF
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 07:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjAEGnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 01:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjAEGnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 01:43:21 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CC542E2D
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 22:43:19 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z4-20020a17090a170400b00226d331390cso7886pjd.5
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 22:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDxCcqax0xnf4UFr4XDeJpIoQrkiJ0zbStINLGfQnog=;
        b=e8KizvwoMwGgYfbYAHlE+AVGp+HbmuE21APAJ0h1zNDmgQWjqoLLIYuNkIdnLUmOFj
         3Igk0kj47y9y1ocoDrVqiYzRPYZUFWtQtWguxw2GvDJik9AgDW6D0JE8n/HdeaijZ5y8
         jQp37WWMjOo/UjB+s6RUVTvaL0zrXJ0xsaaCQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MDxCcqax0xnf4UFr4XDeJpIoQrkiJ0zbStINLGfQnog=;
        b=j11FNNO2qllvCpNNL3m0ucmDXew/ZH+HDEkJJ4/vOPF6Whv4rGByNeC4OmqNMEvuWq
         DXzuLLxgPghxH4z+MkNm+FBAzfPADTmhvxiXYFlZzb/3cCSCbDWFaNbfCTTlQILLQcjw
         ft7+gSRMFrFc/JrLV/YkgwNnhGtVF/Hi9WbbzddbwezdaSsUmN6vlop9/9HA6wKHce4N
         r4WcO4tiN4ZR04+H8dfNq0Nl7VCJAGqKmCQa/Nb4mIiT+B8rOOAo6DI939U2m6H+o1Ic
         hIYfYWeaOFwK1zlPFM2lcsk/UiiHXrm9JssnvgisS2+TB76yTZaAJy6NXJAhqjjPi4Vk
         1Y8Q==
X-Gm-Message-State: AFqh2kpWTCasDGuPsWrnHpk8tulDgaflc7AEBhtIUa4bqAxjEldzcCTF
        PuF2R1vetTTD3ZPzKiLT+vyi1Lg0wCP/4DTWKrAywQ==
X-Google-Smtp-Source: AMrXdXvNhGYFRds/un7BkybHtFwfoyj7h4xGVsCepWM/P6fPcbc8V8DoD36E3r7yHM16DXDcaHJi2A==
X-Received: by 2002:a17:902:a601:b0:192:910e:6083 with SMTP id u1-20020a170902a60100b00192910e6083mr33210445plq.15.1672900999087;
        Wed, 04 Jan 2023 22:43:19 -0800 (PST)
Received: from [192.168.1.33] ([192.183.212.197])
        by smtp.googlemail.com with ESMTPSA id jd6-20020a170903260600b00192a8d795f3sm12265930plb.192.2023.01.04.22.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 22:43:18 -0800 (PST)
Message-ID: <133a4655-bafa-a4f1-b9f4-df43cf443e83@schmorgal.com>
Date:   Wed, 4 Jan 2023 22:43:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230102234714.169831-1-doug@schmorgal.com>
 <657adc8e514d4486853ef90cdf97bd75f55b44fa.camel@redhat.com>
 <cc785f92-587c-c260-6369-c2dde9a392ca@schmorgal.com>
 <9d9b16079503d64096b5d16e4552698ccecb9c7f.camel@redhat.com>
From:   Doug Brown <doug@schmorgal.com>
Subject: Re: [PATCH] wifi: libertas: return consistent length in
 lbs_add_wpa_tlv()
In-Reply-To: <9d9b16079503d64096b5d16e4552698ccecb9c7f.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/2023 6:47 AM, Dan Williams wrote:
> On Tue, 2023-01-03 at 17:13 -0800, Doug Brown wrote:
>> Hi Dan,
>>
>> Thanks for reviewing my patch! Comments below:
>>
>> On 1/3/2023 9:47 AM, Dan Williams wrote:
>>> On Mon, 2023-01-02 at 15:47 -0800, Doug Brown wrote:
>>>> The existing code only converts the first IE to a TLV, but it
>>>> returns
>>>> a
>>>> value that takes the length of all IEs into account. When there
>>>> is
>>>> more
>>>> than one IE (which happens with modern wpa_supplicant versions
>>>> for
>>>> example), the returned length is too long and extra junk TLVs get
>>>> sent
>>>> to the firmware, resulting in an association failure.
>>>>
>>>> Fix this by returning a length that only factors in the single IE
>>>> that
>>>> was converted. The firmware doesn't seem to support the
>>>> additional
>>>> IEs,
>>>> so there is no value in trying to convert them to additional
>>>> TLVs.
>>>>
>>>> Fixes: e86dc1ca4676 ("Libertas: cfg80211 support")
>>>> Signed-off-by: Doug Brown <doug@schmorgal.com>
>>>> ---
>>>>    drivers/net/wireless/marvell/libertas/cfg.c | 7 +++----
>>>>    1 file changed, 3 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/marvell/libertas/cfg.c
>>>> b/drivers/net/wireless/marvell/libertas/cfg.c
>>>> index 3e065cbb0af9..fcc5420ec7ea 100644
>>>> --- a/drivers/net/wireless/marvell/libertas/cfg.c
>>>> +++ b/drivers/net/wireless/marvell/libertas/cfg.c
>>>> @@ -432,10 +432,9 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8
>>>> *ie, u8 ie_len)
>>>>           *tlv++ = 0;
>>>>           tlv_len = *tlv++ = *ie++;
>>>>           *tlv++ = 0;
>>>> -       while (tlv_len--)
>>>> -               *tlv++ = *ie++;
>>>> -       /* the TLV is two bytes larger than the IE */
>>>> -       return ie_len + 2;
>>>> +       memcpy(tlv, ie, tlv_len);
>>>> +       /* the TLV has a four-byte header */
>>>> +       return tlv_len + 4;
>>>
>>> Since you're removing ie_len usage in the function, you might as
>>> well
>>> remove it from the function's arguments.
>>
>> That's an excellent point. Thinking about it further after your
>> questions below, maybe we should keep it around and use it to
>> validate
>> how far we are allowed to go into "ie" though...technically the
>> existing
>> code could overflow the buffer with a malformed IE.
> 
> Yeah, that's a good point, though I'd hope cfg80211 had already
> validated the IE structure that gets put into sme->ie. If not, I'd
> expect bigger problems. But doesn't hurt.

Ah, I didn't even consider that cfg80211 might be validating it ahead of
time, but that would make a lot of sense. I'll do some more digging and
figure out if that much validation is really needed in this driver.

>>
>>> Can you also update the comments to say something like "only copy
>>> the
>>> first IE into the command buffer".
>>
>> Will do.
>>
>>> Lastly, should you check the IE to make sure you're copying the WPA
>>> or
>>> WMM IE that the firmware expects? What other IEs does
>>> wpa_supplicant/cfg80211 add these days?
>>
>> I was wondering about that too. I wasn't sure exactly which potential
>> IEs are the ones I should be looking for during this check. I've seen
>> "RSN Information" = 48 during my testing with WPA2, and assume based
>> on
>> the old Marvell driver code that "Vendor Specific" = 221 would be
>> used
>> with WPA. Going through the entire IE list and finding a match seems
>> safer than just blindly grabbing the first one. This would also be a
>> good time to add some bounds checking to make sure not to overrun
>> "ie"
>> as well...
> 
> Everything after CMD_802_11_ASSOCIATE's DTIM Period field is just a
> bunch of IEs; the command only accepts certain IEs (at least it was
> documented to do that, no idea what the actual firmware does). So I
> wouldn't be surprised if it ignores some.
> 
> So I guess ignore the reasoning I had above, but there's one more good
> reason to filter IEs passed to the firmware: space. We're probably not
> close to overrunning the buffer, but we really don't want to do that
> for security reasons.


I like that idea a lot. I'll filter and only allow through 48 and 221
IEs in lbs_add_wpa_tlv() in the next version of the patch.

>>
>> The other two IEs that are being added by modern wpa_supplicant are
>> "Extended Capabilities" (127) with SCS and mirrored SCS set:
>>
>> 7f 0b 00 00 00 00 00 00 40 00 00 00 20
>>
>> ...and "Supported Operating Classes" (59) with current = 81 and
>> supported = 81 and 82:
>>
>> 3b 03 51 51 52
>>
>> I tried converting these additional IEs to TLVs. It resulted in a
>> successful connection, but the firmware didn't pass on these two IEs
>> in
>> the association request -- I verified by sniffing packets. So I was
>> concerned about passing them onto the firmware if it's not making use
>> of
>> them, in case it's interpreting them in some other unexpected way.
> 
> Yeah, it might.
> 
>>
>> Do you have any guidance on which possible IEs I should be looking
>> for
>> other than 48 and 221, or where I could find that out?
> 
> Only those two. The rest that are required get added specifically in
> the driver. There is a way to push unrecognized IEs through
> ("passthrough IEs" ID 0x010A) but we never implemented that in the
> driver because we never needed it.


Thanks. Good to know that passthrough is possible if any additional IEs
need to be supported in the future. I see that in the old Marvell source
code now, thanks.

>>
>> BTW, modern wpa_supplicant also doesn't work with libertas for one
>> additional reason: it violates NL80211_ATTR_MAX_SCAN_IE_LEN on some
>> older drivers including this one. But I believe that's a
>> wpa_supplicant
>> problem that I can't really address in the kernel...
> 
> That's lame... but Jouni's response was that not allowing extra IEs
> would break some WPS stuff; CMD_802_11_SCAN does allow adding a TLV
> (0x011B) for WPS Enrollee IE contents, so maybe you could just set
> max_scan_ie_len to something larger than zero and ignore IEs that are
> not valid in WPS Enrollee Probe Request frames, while adding the WPS
> TLVs?


I love this idea, and I'm definitely interested in attempting it in
another patch in order to fully restore this driver's compatibility with
wpa_supplicant. I'll play around with it a bit.

Do you happen to have any more info on how to use this TLV? It isn't
documented in the old Marvell driver or this driver. Based on what I'm
seeing in wpa_supplicant, it looks like the WPS stuff is encapsulated in
Vendor Specific (221) IEs with special OUI/type values for WPS. There's
another OUI/type for P2P info that can potentially be added for WPS too.
Would I just need to directly convert these IEs into 0x011B TLVs
(obviously with a new TLV_TYPE_ #define added for it)?

Thanks,
Doug

> 
> Dan
> 
>>
>> http://lists.infradead.org/pipermail/hostap/2022-January/040185.html
>>
>> Thanks!
>> Doug
>>
> 
