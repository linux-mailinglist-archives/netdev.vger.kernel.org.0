Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652365E5FC0
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiIVKWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiIVKWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:22:02 -0400
Received: from relay05.th.seeweb.it (relay05.th.seeweb.it [5.144.164.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0A7D824E;
        Thu, 22 Sep 2022 03:21:59 -0700 (PDT)
Received: from [192.168.1.101] (95.49.29.188.neoplus.adsl.tpnet.pl [95.49.29.188])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by m-r2.th.seeweb.it (Postfix) with ESMTPSA id 9E44F4018D;
        Thu, 22 Sep 2022 12:21:55 +0200 (CEST)
Message-ID: <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
Date:   Thu, 22 Sep 2022 12:21:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
Content-Language: en-US
To:     Hector Martin <marcan@marcan.st>,
        ~postmarketos/upstreaming@lists.sr.ht
Cc:     martin.botka@somainline.org,
        angelogioacchino.delregno@somainline.org,
        marijn.suijten@somainline.org, jamipkettunen@somainline.org,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Soontak Lee <soontak.lee@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
 <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
From:   Konrad Dybcio <konrad.dybcio@somainline.org>
In-Reply-To: <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.09.2022 08:40, Hector Martin wrote:
> On 22/09/2022 06.26, Konrad Dybcio wrote:
>>
>>
>> On 21.09.2022 06:37, Hector Martin wrote:
>>> On 21/09/2022 09.16, Konrad Dybcio wrote:
>>>> Add support for BCM43596 dual-band AC chip, found in
>>>> SONY Xperia X Performance, XZ and XZs smartphones (and
>>>> *possibly* other devices from other manufacturers).
>>>> The chip doesn't require any special handling and seems to work
>>>> just fine OOTB.
>>>>
>>>> PCIe IDs taken from: https://github.com/sonyxperiadev/kernel/commit/9e43fefbac8e43c3d7792e73ca52a052dd86d7e3.patch
>>>>
>>>> Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
>>>> ---
>>>> Changes since v1:
>>>> - rebased the patch against -next
>>>>
>>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 2 ++
>>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 4 ++++
>>>>  drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 4 ++++
>>>>  3 files changed, 10 insertions(+)
>>>>
>>> [...]
>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>>> index f98641bb1528..2e7fc66adf31 100644
>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>>> @@ -81,6 +81,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>>>>  	BRCMF_FW_ENTRY(BRCM_CC_43570_CHIP_ID, 0xFFFFFFFF, 43570),
>>>>  	BRCMF_FW_ENTRY(BRCM_CC_4358_CHIP_ID, 0xFFFFFFFF, 4358),
>>>>  	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
>>>> +	BRCMF_FW_ENTRY(BRCM_CC_43596_CHIP_ID, 0xFFFFFFFF, 4359),
>>>
>>> So this works with the same firmware as 4359? That sounds a bit off. Is
>>> that really the case?
>>>
>>> brcmfmac4359-pcie isn't in linux-firmware, but presumably there is
>>> *some* semi-canonical firmware you can find for that chip that other
>>> people are already using. If that works on 43596 *and* you plan on using
>>> that firmware or some other firmware marked 4359, then this is fine. If
>>> you are using separate firmware that shipped with a 43596 device and
>>> isn't itself marked 4359, please make it a separate firmware entry. We
>>> can always symlink the firmwares if it later turns out there is no
>>> reason to have different ones for each chip.
>> The firmware that SONY originally gave us for the devices that we know use
>> this chip seems to be marked 4359 [1]. That said, I have no other info
>> about the relation between the two models.
>>
>> [1] https://github.com/sonyxperiadev/device-sony-kagura/tree/q-mr1/rootdir/vendor/firmware
> 
> That link seems to have the nvram file and Bluetooth firmware, but not
> WLAN firmware. I think if you run `strings` on the WLAN firmware you'll
> get a build ID with the chip name in it, that might be a good indication
> of what the firmware name should be.
Riight, sorry about that.. This is the correct link [1]

Running strings on fw_bcmdhd.bin (which I renamed to brcmfmac4359-pcie.bin for
mainline firwmare name matching purposes) outputs:

43596a0-roml/pcie-wl11u-ve-mfp-tdls-sr-die3-wepso-wnm-pfn-olpc-mobfd-rcc-ccx-noccxaka-clm_43xx_somc_mimo-fmc-phyflags-rscanf-murx-ltecx-rpi-txpwrctrls-dpo-proxd-hs20sta-linkstat-gscan-rmon-pfnanqpo-dpm Version: 9.75.119.15 (r691661) CRC: 46ae3900 Date: Fri 2017-03-24 13:22:28 KST Ucode Ver: 1060.20542 FWID: 01-a0d2ee7a

However, as you can see, the directory is named bcm4359 and not bcm43596, so my
best guess is that it's probably part of the same chip family with minor
differences.

Also worth noting is the 'somc' bit, meaning there are probably *some* SONY
customizations, but that's also just a guess.


I did also find this [2] fw for 4359 which contains:

4359b1-roml/pcie-wl11u-mfp-nvramadj-sr-die3-pwrofs-wnm-pfn-pwrstats-olpc-mobfd-txbf-mimopscan-slna-wapi-nsslimit-lpc-wepso-pspretend-apbs-apcs-spurcan-clm_min-obss-fbt-idsup-idauth Version: 9.40.109 (r710128 CY) CRC: e4b3d019 Date: Wed 2019-02-20 18:09:51 PST Ucode Ver: 1043.20426 FWID 01-848095d2

So I suppose I will respin this series to make 43596 use its own fw, since - while
probably similar - the two are in fact distinct.

Konrad

[1] https://github.com/sonyxperiadev/vendor-broadcom-wlan/tree/master/bcmdhd/firmware/bcm4359
[2] https://github.com/NXP/imx-firmware/tree/master/cyw-wifi-bt/1FD_CYW4359
> 
> I would suggest trying to find some other 4359 firmware and testing your
> device with it. If it works, then it's definitely fine to use the same
> firmware name. If it doesn't, then you might need different firmware
> names, or it might just be a case for board-specific firmwares.
> 
> - Hector
