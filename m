Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871F56440FA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiLFKIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbiLFKIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:08:13 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA2A2937F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:59:02 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id x22so4846252ejs.11
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 01:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ObSGnf9o+JBOrO24j+Gk0huIO7QPMmLGGqtlO6dyj7I=;
        b=Lc7UhSMh16u8AyhYkdN+5jg2/9vylzRaknggcWtyusEwBLCu/xB+mnu7z/Lm+MwHrf
         yGqPQMAdARhI17GQ3z/3eA0NoTs87x0j6eNM+y2NacS4+oIM9em3Pw/VW7KSq9JWageG
         bZYRKOqkh5lD9YpM8kL6zGqGY1IKr5f6zmH7sYpC/FVkpjByRi5DzMFHQNORM7IWz4VH
         GMrt0rMAOerMqjdd8X8otXM2ZA9UZlnydKmxSes57OIEWm4dXVmxc4ZgvfKzhb6R3B11
         QgBgjtXAt7YlFkty7GHWD86TlnodAe5rt2oVdT4gjgEmoqLiUaYnUzJOTSpj4BQ0foyn
         75XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ObSGnf9o+JBOrO24j+Gk0huIO7QPMmLGGqtlO6dyj7I=;
        b=h3BsbtzeAjve5P1yd7V474q0ji6LdI2k79/FM2dVmFjyOdK3nwd4aiqAfpFOjdAgEh
         UaY0+0vq4SBH66H2pt26sFnTLKQapYaGEw/MXa0Qy6jPdiFi/WSCuxEW9mmJT7uvozoI
         NVRO7EvgBEH41lNFZdVWdqqcEfNuAGWGpVR4SQ2hHFnbeCvWMm62T2720xUBfjtI5uJH
         6uaBOOm5nRNkxMFIgZQgXqURTvWsaMntcxUExehntIr4ghdVoHosXF68bDWwchIav2xt
         +iEHsjmA3JDSHg08xA/KoyNY9Ni/N2uDXIzM71Sv/SbwKj4MAu3XAdir2zlZLWAA4D5q
         8yXw==
X-Gm-Message-State: ANoB5pmwVJE+O8ELGs5IgkGfeKxEr+rbDoZWwizR3ldjr+wir5GooZAQ
        VqMpl2t4iaH9YwDWcbMOSHPcmw==
X-Google-Smtp-Source: AA0mqf75au80dyhfWglEg+fGa0WKlLKPgIrQySZGW10iHbKqSj3ssqBbSnp8xkQWQ7152J40GkCfQg==
X-Received: by 2002:a17:906:38cd:b0:7be:4d3c:1a44 with SMTP id r13-20020a17090638cd00b007be4d3c1a44mr38089638ejd.543.1670320740517;
        Tue, 06 Dec 2022 01:59:00 -0800 (PST)
Received: from [192.168.31.208] ([194.29.137.22])
        by smtp.gmail.com with ESMTPSA id b11-20020a17090630cb00b00781dbdb292asm7168474ejb.155.2022.12.06.01.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:58:59 -0800 (PST)
Message-ID: <21fc5c0e-f880-7a14-7007-2d28d5e66c7d@linaro.org>
Date:   Tue, 6 Dec 2022 10:58:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Arend Van Spriel <aspriel@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
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
 <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
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
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <62566987-6bd2-eed3-7c2f-ec13c5d34d1b@gmail.com>
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



On 02/12/2022 20:28, Arend Van Spriel wrote:
> 
> 
> On 12/2/2022 4:26 PM, Arend van Spriel wrote:
>> On 12/2/2022 11:33 AM, Konrad Dybcio wrote:
>>>
>>>
>>> On 1.12.2022 12:31, Arend van Spriel wrote:
>>>> On 11/28/2022 3:40 PM, Konrad Dybcio wrote:
>>>>>
>>>>>
>>>>> On 26.11.2022 22:45, Linus Walleij wrote:
>>>>>> On Fri, Nov 25, 2022 at 1:25 PM Kalle Valo <kvalo@kernel.org> wrote:
>>>>>>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>>>>>>>
>>>>>>>> On 25.11.2022 12:53, Kalle Valo wrote:
>>>>>>>>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>>>>>>>>>
>>>>>>>>>> On 21.11.2022 14:56, Linus Walleij wrote:
>>>>>>>>>>> On Fri, Nov 18, 2022 at 5:47 PM Konrad Dybcio 
>>>>>>>>>>> <konrad.dybcio@linaro.org> wrote:
>>>>>>>>>>>
>>>>>>>>>>>> I can think of a couple of hacky ways to force use of 43596 
>>>>>>>>>>>> fw, but I
>>>>>>>>>>>> don't think any would be really upstreamable..
>>>>>>>>>>>
>>>>>>>>>>> If it is only known to affect the Sony Xperias mentioned then
>>>>>>>>>>> a thing such as:
>>>>>>>>>>>
>>>>>>>>>>> if (of_machine_is_compatible("sony,xyz") ||
>>>>>>>>>>>       of_machine_is_compatible("sony,zzz")... ) {
>>>>>>>>>>>      // Enforce FW version
>>>>>>>>>>> }
>>>>>>>>>>>
>>>>>>>>>>> would be completely acceptable in my book. It hammers the
>>>>>>>>>>> problem from the top instead of trying to figure out itsy witsy
>>>>>>>>>>> details about firmware revisions.
>>>>>>>>>>>
>>>>>>>>>>> Yours,
>>>>>>>>>>> Linus Walleij
>>>>>>>>>>
>>>>>>>>>> Actually, I think I came up with a better approach by pulling 
>>>>>>>>>> a page
>>>>>>>>>> out of Asahi folks' book - please take a look and tell me what 
>>>>>>>>>> you
>>>>>>>>>> think about this:
>>>>>>>>>>
>>>>>>>>>> [1]
>>>>>>>>>> https://github.com/SoMainline/linux/commit/4b6fccc995cd79109b0dae4e4ab2e48db97695e7
>>>>>>>>>> [2]
>>>>>>>>>> https://github.com/SoMainline/linux/commit/e3ea1dc739634f734104f37fdbed046873921af7
>>>>>>
>>>>>> Something in this direction works too.
>>>>>>
>>>>>> The upside is that it tells all operating systems how to deal
>>>>>> with the firmware for this hardware.
>>>>>>
>>>>>>>>> Instead of a directory path ("brcm/brcmfmac43596-pcie") why not 
>>>>>>>>> provide
>>>>>>>>> just the chipset name ("brcmfmac43596-pcie")? IMHO it's 
>>>>>>>>> unnecessary to
>>>>>>>>> have directory names in Device Tree.
>>>>>>>>
>>>>>>>> I think it's common practice to include a full 
>>>>>>>> $FIRMWARE_DIR-relative
>>>>>>>> path when specifying firmware in DT, though here I left out the 
>>>>>>>> board
>>>>>>>> name bit as that's assigned dynamically anyway. That said, if 
>>>>>>>> you don't
>>>>>>>> like it, I can change it.
>>>>>>>
>>>>>>> It's just that I have understood that Device Tree is supposed to
>>>>>>> describe hardware and to me a firmware directory "brcm/" is a 
>>>>>>> software
>>>>>>> property, not a hardware property. But this is really for the Device
>>>>>>> Tree maintainers to decide, they know this best :)
>>>>>>
>>>>>> I would personally just minimize the amount of information
>>>>>> put into the device tree to be exactly what is needed to find
>>>>>> the right firmware.
>>>>>>
>>>>>> brcm,firmware-compatible = "43596";
>>>>>>
>>>>>> since the code already knows how to conjure the rest of the string.
>>>>>>
>>>>>> But check with Rob/Krzysztof.
>>>>>>
>>>>>> Yours,
>>>>>> Linus Walleij
>>>>>
>>>>> Krzysztof, Rob [added to CC] - can I have your opinions?
>>>>
>>>> I tried catching up on this thread. Reading it I am not sure what 
>>>> the issue is, but I am happy to dive in. If you can provide a boot 
>>>> log with brcmfmac loaded with module parameter 'debug=0x1416' I can 
>>>> try and make sense of the chipid/devid confusion.
>>>
>>> Hope this helps, thanks! https://hastebin.com/xidagekuge.yaml
>>
>> It does to some extent. It is basically a 4359 revision 9:
>>
>> [   25.898782] brcmfmac: brcmf_chip_recognition found AXI chip: BCM4359/9
>>
>> The 4359 entry in pcie.c is applicable for revision 0 and higher 
>> (doubtful but that is in the code):
>>
>>      BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
>>
>> We need to change the mask above to 0x000001FF and add a new entry 
>> with mask 0xFFFFFE00. All we need is come up with a reasonable 
>> firmware filename. So can you run the strings command on the firmware 
>> you use:
>>
>> $ strings fw.bin | tail -1
>>
>> and let me know the output.
> 
> Actually realized you already provided a URL to the repo containing the 
> firmware you used. So I had a look and it shows:
> 
> 43596a0-roml/pcie-ag-apcs-pktctx-proptxstatus-ampduhostreorder-lpc-die3-olpc-pspretend-mfp-ltecx-clm_43xx_somc_mimo-phyflags-txpwrctrls-dpo Version: 9.75.119.15 (r691661) CRC: a6cf427b Date: Fri 2017-03-24 13:24:25 KST Ucode Ver: 1060.20542 FWID: 01-e4abc35c
> 
> However, from firmware perspective this is equivalent to 4359c0 so I 
> would suggest the change below.
> 
> Let me know if that works.
Sorry for the late reply.

Yes, it does seem to work just fine! The kernel now looks for 
brcm/brcmfmac4359c-pcie.sony,kagura-row.bin as we would expect.

Could you submit this patch below to supersede my one?

Konrad
> 
> Regards,
> Arend
> ---
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c 
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index cf564adc612a..b59cf0f2939c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -55,6 +55,7 @@ BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-pcie");
>   BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
>   BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
>   BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
> +BCRMF_FW_DEF(4359C, "brcmfmac4359c-pcie");
>   BRCMF_FW_DEF(4364, "brcmfmac4364-pcie");
>   BRCMF_FW_DEF(4365B, "brcmfmac4365b-pcie");
>   BRCMF_FW_DEF(4365C, "brcmfmac4365c-pcie");
> @@ -83,7 +84,8 @@ static const struct brcmf_firmware_mapping 
> brcmf_pcie_fwnames[] = {
>       BRCMF_FW_ENTRY(BRCM_CC_43569_CHIP_ID, 0xFFFFFFFF, 43570),
>       BRCMF_FW_ENTRY(BRCM_CC_43570_CHIP_ID, 0xFFFFFFFF, 43570),
>       BRCMF_FW_ENTRY(BRCM_CC_4358_CHIP_ID, 0xFFFFFFFF, 4358),
> -    BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
> +    BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0x000001FF, 4359),
> +    BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFE00, 4359C),
>       BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFFF, 4364),
>       BRCMF_FW_ENTRY(BRCM_CC_4365_CHIP_ID, 0x0000000F, 4365B),
>       BRCMF_FW_ENTRY(BRCM_CC_4365_CHIP_ID, 0xFFFFFFF0, 4365C),
> 
