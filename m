Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CEB5BF564
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 06:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiIUEh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 00:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiIUEhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 00:37:55 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F007C761;
        Tue, 20 Sep 2022 21:37:53 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id CA8AD4206F;
        Wed, 21 Sep 2022 04:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1663735071; bh=odQVd1tz7cJZ7KRyVvcKpxukOPb4ofRNobcy12I03uI=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=esOYtEqyc0O5Qs2GCHG1rYcUTA+PvDAuhfTrdmr2th5ghJiV0jH+q/Gb82b7hEUSa
         +scLzSx4OdD11b55lm4ud4emBQzwskuuF4a/yptW/hdvnqQ8jTuIxdtYVPk5x1YbJ4
         3fb1uVe1TRDpnyX/f+cyCs0TA/bpZ3wEIgv9xdjwS7rze6n9J1qVtum8Pt+qeyRwDT
         5AyWkz0Xrg8Nf5d6EFn2k4t8hV6yMfpFUgPfYpX8jHIa8ylJ4VYs8n7PNH1LqXWUt4
         9nahI8vUmSHqK9B4PcK+g84qGUM5tMJGE4JIDO9MYJRrRG4WBSBsbyVS3nimOG4ogr
         UT0ZDHUwVstqQ==
Message-ID: <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
Date:   Wed, 21 Sep 2022 13:37:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: es-ES
To:     Konrad Dybcio <konrad.dybcio@somainline.org>,
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
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
In-Reply-To: <20220921001630.56765-1-konrad.dybcio@somainline.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/09/2022 09.16, Konrad Dybcio wrote:
> Add support for BCM43596 dual-band AC chip, found in
> SONY Xperia X Performance, XZ and XZs smartphones (and
> *possibly* other devices from other manufacturers).
> The chip doesn't require any special handling and seems to work
> just fine OOTB.
> 
> PCIe IDs taken from: https://github.com/sonyxperiadev/kernel/commit/9e43fefbac8e43c3d7792e73ca52a052dd86d7e3.patch
> 
> Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> ---
> Changes since v1:
> - rebased the patch against -next
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 4 ++++
>  drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 4 ++++
>  3 files changed, 10 insertions(+)
> 
[...]
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index f98641bb1528..2e7fc66adf31 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -81,6 +81,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>  	BRCMF_FW_ENTRY(BRCM_CC_43570_CHIP_ID, 0xFFFFFFFF, 43570),
>  	BRCMF_FW_ENTRY(BRCM_CC_4358_CHIP_ID, 0xFFFFFFFF, 4358),
>  	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
> +	BRCMF_FW_ENTRY(BRCM_CC_43596_CHIP_ID, 0xFFFFFFFF, 4359),

So this works with the same firmware as 4359? That sounds a bit off. Is
that really the case?

brcmfmac4359-pcie isn't in linux-firmware, but presumably there is
*some* semi-canonical firmware you can find for that chip that other
people are already using. If that works on 43596 *and* you plan on using
that firmware or some other firmware marked 4359, then this is fine. If
you are using separate firmware that shipped with a 43596 device and
isn't itself marked 4359, please make it a separate firmware entry. We
can always symlink the firmwares if it later turns out there is no
reason to have different ones for each chip.

- Hector
