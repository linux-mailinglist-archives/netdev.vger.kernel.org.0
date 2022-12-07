Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B00645743
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiLGKMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiLGKMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:12:38 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFE763DF
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:12:37 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id b9so20336568ljr.5
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 02:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMUNzqhAnnvDs85XBuzQ2f64t9UBq6YMWGPKZzHFgcw=;
        b=SLvX03J5WdISnHIMvtIx1HVcT+B8/t3o3nJmUYOr3lA6Tca/+sxNljXVDctfMjlOuC
         ebZhuaXiLhnY0DxZQjS8aLOzcju3gPnc6Xexw1tw3OqvUKl1dFZq3SycXAB+byp9/sGk
         n2lB/aqUJbwxXU3rZ4KrmYvfIjK1/H+2sn1wsEkB0QN7jqp/B3h3E9d7/xMlkD+IKU7Z
         GVSkcG10uaHgfv49iQMFdOVDXm0mEFQS1TE0V5N3oWAOmP+4QwNRFdWWNfZBJr9/UpVT
         wRzu4ShrzW1ot7PccW2u4l5sdZWBR5tk7325jvDdbrrlUdlJ/v1msKvPlu05URpxNgrR
         OoNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hMUNzqhAnnvDs85XBuzQ2f64t9UBq6YMWGPKZzHFgcw=;
        b=hJBiCoXoXwILpp/QlsAhJJfPb7TDI6d7xEI4u5NsXdT/o1bFoBGNL+npRkoMBOiqvq
         RPATWIWjldSCxbA2sDHNxHgC4gN+hw+Hf2WK+9lqgoe01eoJY0aTYLm3xZJho9JXl17J
         Kg3U44zr/RCnxBQUE2VWTIyq+usnWfei7WKhxIcbQJMiX3PpsFpvwxKWTBQWK74HMTHc
         5U8DHC77fukWWbtEHcxA70bHN1rIYcVenECG3dXYAEm0XkdQtEAtXXHCDB/EluONZfVC
         iNgCf7QxHybcNwex/+k2dy15QqJN2i9xUsUkvnI7v4++pCZNkKceSxUTkqJU8HS81Tjz
         NfTw==
X-Gm-Message-State: ANoB5pmiEDgkGH3T+mDH212uf/kG83TOCgmGwh2FNA++iAjhBLIBPo+y
        V2qXfylJC5hVNB831t/BFw6raA==
X-Google-Smtp-Source: AA0mqf7i9szVyRckELGdNbXxF10CEd39TdER5Ft7k5E/kf8jhKd/QtGNMY0vAL51LCYjzrx+wlpHXQ==
X-Received: by 2002:a2e:8186:0:b0:279:e618:445d with SMTP id e6-20020a2e8186000000b00279e618445dmr5637835ljg.182.1670407955725;
        Wed, 07 Dec 2022 02:12:35 -0800 (PST)
Received: from [192.168.31.208] ([194.29.137.22])
        by smtp.gmail.com with ESMTPSA id i11-20020a196d0b000000b004a03d5c2140sm2800989lfc.136.2022.12.07.02.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 02:12:34 -0800 (PST)
Message-ID: <f9889aa3-65cc-49b3-ef51-8b098d052de1@linaro.org>
Date:   Wed, 7 Dec 2022 11:12:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend Van Spriel <aspriel@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kalle Valo <kvalo@kernel.org>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Hector Martin <marcan@marcan.st>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <87sfke32pc.fsf@kernel.org>
 <4592f87a-bb61-1c28-13f0-d041a6e7d3bf@linaro.org>
 <CACRpkdax-3VVDd29iH51mfumakqM7jyEc8Pbb=AQwAgp2WsqFQ@mail.gmail.com>
 <d03bd4d4-e4ef-681b-b4a5-02822e1eee75@linaro.org> <87fse76yig.fsf@kernel.org>
 <fc2812b1-db96-caa6-2ecb-c5bb2c33246a@linaro.org> <87bkov6x1q.fsf@kernel.org>
 <CACRpkdbpJ8fw0UsuHXGX43JRyPy6j8P41_5gesXOmitHvyoRwQ@mail.gmail.com>
 <28991d2d-d917-af47-4f5f-4e8183569bb1@linaro.org>
 <c83d7496-7547-2ab4-571a-60e16aa2aa3d@broadcom.com>
 <6e4f1795-08b5-7644-d1fa-102d6d6b47fb@linaro.org>
 <af489711-6849-6f87-8ea3-6c8216f0007b@broadcom.com>
 <62566987-6bd2-eed3-7c2f-ec13c5d34d1b@gmail.com>
 <21fc5c0e-f880-7a14-7007-2d28d5e66c7d@linaro.org>
 <86aefe08-9f78-4afa-7d50-5c5a4ef87499@broadcom.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <86aefe08-9f78-4afa-7d50-5c5a4ef87499@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/12/2022 12:22, Arend van Spriel wrote:
> On 12/6/2022 10:58 AM, Konrad Dybcio wrote:
>>
>>
>> On 02/12/2022 20:28, Arend Van Spriel wrote:
>>>
>>>
>>> On 12/2/2022 4:26 PM, Arend van Spriel wrote:
>>>> On 12/2/2022 11:33 AM, Konrad Dybcio wrote:
>>>>>
>>>>>
>>>>> On 1.12.2022 12:31, Arend van Spriel wrote:
>>>>>> On 11/28/2022 3:40 PM, Konrad Dybcio wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 26.11.2022 22:45, Linus Walleij wrote:
>>>>>>>> On Fri, Nov 25, 2022 at 1:25 PM Kalle Valo <kvalo@kernel.org> 
>>>>>>>> wrote:
>>>>>>>>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>>>>>>>>>
>>>>>>>>>> On 25.11.2022 12:53, Kalle Valo wrote:
>>>>>>>>>>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>>>>>>>>>>>
>>>>>>>>>>>> On 21.11.2022 14:56, Linus Walleij wrote:
>>>>>>>>>>>>> On Fri, Nov 18, 2022 at 5:47 PM Konrad Dybcio 
>>>>>>>>>>>>> <konrad.dybcio@linaro.org> wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>> I can think of a couple of hacky ways to force use of 
>>>>>>>>>>>>>> 43596 fw, but I
>>>>>>>>>>>>>> don't think any would be really upstreamable..
>>>>>>>>>>>>>
>>>>>>>>>>>>> If it is only known to affect the Sony Xperias mentioned then
>>>>>>>>>>>>> a thing such as:
>>>>>>>>>>>>>
>>>>>>>>>>>>> if (of_machine_is_compatible("sony,xyz") ||
>>>>>>>>>>>>>       of_machine_is_compatible("sony,zzz")... ) {
>>>>>>>>>>>>>      // Enforce FW version
>>>>>>>>>>>>> }
>>>>>>>>>>>>>
>>>>>>>>>>>>> would be completely acceptable in my book. It hammers the
>>>>>>>>>>>>> problem from the top instead of trying to figure out itsy 
>>>>>>>>>>>>> witsy
>>>>>>>>>>>>> details about firmware revisions.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Yours,
>>>>>>>>>>>>> Linus Walleij
>>>>>>>>>>>>
>>>>>>>>>>>> Actually, I think I came up with a better approach by 
>>>>>>>>>>>> pulling a page
>>>>>>>>>>>> out of Asahi folks' book - please take a look and tell me 
>>>>>>>>>>>> what you
>>>>>>>>>>>> think about this:
>>>>>>>>>>>>
>>>>>>>>>>>> [1]
>>>>>>>>>>>> https://github.com/SoMainline/linux/commit/4b6fccc995cd79109b0dae4e4ab2e48db97695e7
>>>>>>>>>>>> [2]
>>>>>>>>>>>> https://github.com/SoMainline/linux/commit/e3ea1dc739634f734104f37fdbed046873921af7
>>>>>>>>
>>>>>>>> Something in this direction works too.
>>>>>>>>
>>>>>>>> The upside is that it tells all operating systems how to deal
>>>>>>>> with the firmware for this hardware.
>>>>>>>>
>>>>>>>>>>> Instead of a directory path ("brcm/brcmfmac43596-pcie") why 
>>>>>>>>>>> not provide
>>>>>>>>>>> just the chipset name ("brcmfmac43596-pcie")? IMHO it's 
>>>>>>>>>>> unnecessary to
>>>>>>>>>>> have directory names in Device Tree.
>>>>>>>>>>
>>>>>>>>>> I think it's common practice to include a full 
>>>>>>>>>> $FIRMWARE_DIR-relative
>>>>>>>>>> path when specifying firmware in DT, though here I left out 
>>>>>>>>>> the board
>>>>>>>>>> name bit as that's assigned dynamically anyway. That said, if 
>>>>>>>>>> you don't
>>>>>>>>>> like it, I can change it.
>>>>>>>>>
>>>>>>>>> It's just that I have understood that Device Tree is supposed to
>>>>>>>>> describe hardware and to me a firmware directory "brcm/" is a 
>>>>>>>>> software
>>>>>>>>> property, not a hardware property. But this is really for the 
>>>>>>>>> Device
>>>>>>>>> Tree maintainers to decide, they know this best :)
>>>>>>>>
>>>>>>>> I would personally just minimize the amount of information
>>>>>>>> put into the device tree to be exactly what is needed to find
>>>>>>>> the right firmware.
>>>>>>>>
>>>>>>>> brcm,firmware-compatible = "43596";
>>>>>>>>
>>>>>>>> since the code already knows how to conjure the rest of the string.
>>>>>>>>
>>>>>>>> But check with Rob/Krzysztof.
>>>>>>>>
>>>>>>>> Yours,
>>>>>>>> Linus Walleij
>>>>>>>
>>>>>>> Krzysztof, Rob [added to CC] - can I have your opinions?
>>>>>>
>>>>>> I tried catching up on this thread. Reading it I am not sure what 
>>>>>> the issue is, but I am happy to dive in. If you can provide a boot 
>>>>>> log with brcmfmac loaded with module parameter 'debug=0x1416' I 
>>>>>> can try and make sense of the chipid/devid confusion.
>>>>>
>>>>> Hope this helps, thanks! https://hastebin.com/xidagekuge.yaml
>>>>
>>>> It does to some extent. It is basically a 4359 revision 9:
>>>>
>>>> [   25.898782] brcmfmac: brcmf_chip_recognition found AXI chip: 
>>>> BCM4359/9
>>>>
>>>> The 4359 entry in pcie.c is applicable for revision 0 and higher 
>>>> (doubtful but that is in the code):
>>>>
>>>>      BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
>>>>
>>>> We need to change the mask above to 0x000001FF and add a new entry 
>>>> with mask 0xFFFFFE00. All we need is come up with a reasonable 
>>>> firmware filename. So can you run the strings command on the 
>>>> firmware you use:
>>>>
>>>> $ strings fw.bin | tail -1
>>>>
>>>> and let me know the output.
>>>
>>> Actually realized you already provided a URL to the repo containing 
>>> the firmware you used. So I had a look and it shows:
>>>
>>> 43596a0-roml/pcie-ag-apcs-pktctx-proptxstatus-ampduhostreorder-lpc-die3-olpc-pspretend-mfp-ltecx-clm_43xx_somc_mimo-phyflags-txpwrctrls-dpo Version: 9.75.119.15 (r691661) CRC: a6cf427b Date: Fri 2017-03-24 13:24:25 KST Ucode Ver: 1060.20542 FWID: 01-e4abc35c
>>>
>>> However, from firmware perspective this is equivalent to 4359c0 so I 
>>> would suggest the change below.
>>>
>>> Let me know if that works.
>> Sorry for the late reply.
>>
>> Yes, it does seem to work just fine! The kernel now looks for 
>> brcm/brcmfmac4359c-pcie.sony,kagura-row.bin as we would expect.
>>
>> Could you submit this patch below to supersede my one?
> 
> I have no problem when you include this patch in yours and submit it to 
> the linux-wireless list.
Thanks, I'll do that soon!

Konrad
> 
> Regards,
> Arend
