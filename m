Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED3011C1CC
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfLLBCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:02:48 -0500
Received: from mout.web.de ([212.227.17.11]:44437 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbfLLBCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 20:02:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576112550;
        bh=jn+uo4Cqpx1ozQR3B2KC5B3J+RoGsXHD7RZoPdcq0nU=;
        h=X-UI-Sender-Class:Subject:Cc:References:To:From:Date:In-Reply-To;
        b=L9ydTcdnRJrw9gBXCFSp39/6F4PqkOI1mV5NtJlDVgKwnuD7uf7ZhBPUrHV+eEVs7
         8rlfbWcscTZHp8s6Bybzh1921thpQkMbsT8iyrwukvHuRpmJNLzPk5UaQExBkMvSgP
         aYxoNlWI1onySK1XhCQ9PVUaahHlQEY/JDbRvq2c=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.204.139.166]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Ldn6l-1hxNjC2bPH-00izDK; Thu, 12
 Dec 2019 02:02:29 +0100
Subject: Re: [PATCH v2 5/9] brcmfmac: add support for BCM4359 SDIO chipset
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
References: <20191211235253.2539-1-smoch@web.de>
 <20191211235253.2539-6-smoch@web.de>
To:     Ulf Hansson <ulf.hansson@linaro.org>
From:   Soeren Moch <smoch@web.de>
Message-ID: <56de6321-bfc5-a66c-23c0-8928221c2a7f@web.de>
Date:   Thu, 12 Dec 2019 02:02:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191211235253.2539-6-smoch@web.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Provags-ID: V03:K1:Qvea2KHNf/g2y1Ioev+CHDSFFOxPHdl3xf9+z6TwJCNrGKeu3DC
 N5JpsCsR16tn96j9rG5iSRCPi5IzfAIwr8q8n237lCSdFK9bcCs8pIVHxkP72scLzpIh4s8
 QLzbpBz2pnIO/Dfkwqax6PEfK+4psyx9Opexgc52ANnihUeQLz83ik/KTC1HqPH7ITwkTKK
 ESRdXx9zbmH8XtthjV1Ig==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LJbS0jdVLI8=:ATWbHxULlQjn6MOGYVh1va
 k8DOWElK6UqGaBsIs04vtExB6xn8PWwJfJjjLs8HFwGLLuYzwSOhytFFDxGnC6b5qfItgr2qR
 2m3O2kjZJ9kWRkIjfNaqyA/eUwKGVoKyWwbLIoIBpWDlWX1KcFlnKQLm/MpM5Vm6DTwIRLW1p
 cz9YcX0qrKY62ABDP4bJoW8UxGqOgfgsDg53OlyyHikmruCLxfPPOn1qYfV/xoxONcjJYZGKu
 SN+QowbsuqAAefygQgl+nXv5qiFDs70bnISUGQa2/aGiAJt3ynZ7edeoyZqbevvzVy/FvX2c8
 wP0HqPca3/cAthgB6aCJDy6ds1CbK+Sn/6cJZtE26dUgDSpPB4X6llqqYRwq5D64+/emgGM3b
 tlYUgqZyGDYAjGVHPMth5r7frtzJ0UWM7LWl//N/hlyDW9aRL/49jrew/He9aowsQpIp9XAcI
 9+nK5EdVNpIexu5hpgKz9KeOHv7WELHDo+qIuDmrX0KWcGdl9thhxcjMCx28wMDc+j50rN5yB
 AKk7zlr6p7nqH195717o9gXvNGw3KMdY4ywsHGi8+0qr0op6DFdMOV+zJdK1NS/EQQQsZVDfA
 cUZzYsvO6zkQGxbUbDlLK3v+LYvtQuZ9zARAgY+VMqcSAWw0aLKin8x3EKSRCLnf9nWlwQPhm
 48JmWWzP2MMO76v5PDqOv84iVPyvQEgPw1vaH8CrOFix9Gapqe2O3CeQC2KcnE88TI6Uqs/Ix
 oCYef2L1N96qK4ftlg/ZJX5g+2S73iNA9w+9nyCmwEiLag8q0qu/3PMqw9tBHKroZi+KKdLny
 /anTRBANHdpmGPFYpJWS1+L/GTJRx2wMnDB7joX1QZ6XfElOHZCVfNVrl9yDHiJ83wLwjfjYS
 sEBAPcyaB48UFKNFtOfa7g5zLhEYLUTTOOtQZfiWw36gC/cQpQlBGUlWr0+7fGyuqHIHSfknH
 jBPk1IQlPooiiJ+mT5VtpoFFUxafHlwa/6yxcuVII4NN8P/6JZReAPYltNSoUwVMtpGc08tkV
 YH2ijg6zw7B9B6hYlr9OG0xqsY9MxwzQ/HnvgzRpAhwIRRTJmkoYOwhNOirxa4fllGyS/k7AN
 fn40VpMf5a4L8ybR+kzHwR2ziY7fmbmCWUEpMxHXsZ2q3OlNxL+dTdY+u57+DZ4ix8TjI+J0m
 pR7h8rACGdVUxJpJZA91wY05WqF51vVfgOeE4xFMB5IA45ciclxlvg5ZfOh0V34VoN4d4wN87
 sWeffHekji1J7qb+gJSSJesyCznUA8H7XCc3Q+A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ulf,

This patch is part of a series [1] to add support for the BCM4359
chipset with SDIO interface to the brcmfmac wireless network driver.

I just realized that this patch touches
include/linux/mmc/sdio_ids.h
and therefore I need an Ack from MMC folks. Can you please look at this?

Thanks and sorry for not including you in the original patch series
submission,
Soeren

[1] https://lkml.org/lkml/2019/12/11/1958

On 12.12.19 00:52, Soeren Moch wrote:
> BCM4359 is a 2x2 802.11 abgn+ac Dual-Band HT80 combo chip and it
> supports Real Simultaneous Dual Band feature.
>
> Based on a similar patch by: Wright Feng <wright.feng@cypress.com>
>
> Signed-off-by: Soeren Moch <smoch@web.de>
> ---
> changes in v2:
> - add SDIO_DEVICE_ID_CYPRESS_89359 as requested
>   by Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> Cc: Wright Feng <wright.feng@cypress.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: brcm80211-dev-list@cypress.com
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-rockchip@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 1 +
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 2 ++
>  include/linux/mmc/sdio_ids.h                              | 2 ++
>  4 files changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 68baf0189305..f4c53ab46058 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -973,8 +973,10 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
> +	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_4373),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_43012),
> +	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_89359),
>  	{ /* end: all zeroes */ }
>  };
>  MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> index baf72e3984fc..282d0bc14e8e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> @@ -1408,6 +1408,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
>  		addr = CORE_CC_REG(base, sr_control0);
>  		reg = chip->ops->read32(chip->ctx, addr);
>  		return (reg & CC_SR_CTL0_ENABLE_MASK) != 0;
> +	case BRCM_CC_4359_CHIP_ID:
>  	case CY_CC_43012_CHIP_ID:
>  		addr = CORE_CC_REG(pmu->base, retention_ctl);
>  		reg = chip->ops->read32(chip->ctx, addr);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 21e535072f3f..c4012ed58b9c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -616,6 +616,7 @@ BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
>  BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
>  BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
>  BRCMF_FW_DEF(4356, "brcmfmac4356-sdio");
> +BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
>  BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>  BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>
> @@ -638,6 +639,7 @@ static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>  	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFDC0, 43455),
>  	BRCMF_FW_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
>  	BRCMF_FW_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356),
> +	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
>  	BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373),
>  	BRCMF_FW_ENTRY(CY_CC_43012_CHIP_ID, 0xFFFFFFFF, 43012)
>  };
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index 08b25c02b5a1..2e9a6e4634eb 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -41,8 +41,10 @@
>  #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
>  #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
>  #define SDIO_DEVICE_ID_BROADCOM_4356		0x4356
> +#define SDIO_DEVICE_ID_BROADCOM_4359		0x4359
>  #define SDIO_DEVICE_ID_CYPRESS_4373		0x4373
>  #define SDIO_DEVICE_ID_CYPRESS_43012		43012
> +#define SDIO_DEVICE_ID_CYPRESS_89359		0x4355
>
>  #define SDIO_VENDOR_ID_INTEL			0x0089
>  #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
> --
> 2.17.1
>

