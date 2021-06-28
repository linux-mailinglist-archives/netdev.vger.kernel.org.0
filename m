Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A963B5DCC
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 14:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhF1MTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 08:19:21 -0400
Received: from lpdvsmtp10.broadcom.com ([192.19.11.229]:39206 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232802AbhF1MTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 08:19:19 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 21B96827D;
        Mon, 28 Jun 2021 05:16:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 21B96827D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1624882613;
        bh=G9cr5vNy9UFNI35mUQl46GB0uW3+EP/3puSIRnjeyp4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=U1jRlZVKx1wXrH8FSiAFwg6aqKXtWJSfvsgGqAUCYzHM81Z07U35VkS04qRwDSSMp
         KNTgHOumsVgq//zh1fVXY4fwjvLrTcEVB0yfNLPgyClvK5Pj7D5lKsWkHF84Q07reU
         eHS3OiPcbQWCZFHy3nstIR3ASIs8CY+OQuo4GH2w=
Received: from [10.176.68.80] (39y1yf2.dhcp.broadcom.net [10.176.68.80])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 7692B1874BE;
        Mon, 28 Jun 2021 05:16:49 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: use separate firmware for 43430 revision 2
To:     Mikhail Rudenko <mike.rudenko@gmail.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Double Lo <double.lo@cypress.com>,
        Remi Depommier <rde@setrix.com>,
        Amar Shankar <amsr@cypress.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210509233010.2477973-1-mike.rudenko@gmail.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c63f85b6-dbca-7f89-a015-70f5821df96d@broadcom.com>
Date:   Mon, 28 Jun 2021 14:16:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210509233010.2477973-1-mike.rudenko@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/2021 1:30 AM, Mikhail Rudenko wrote:
> A separate firmware is needed for Broadcom 43430 revision 2.  This
> chip can be found in e.g. certain revisions of Ampak AP6212 wireless
> IC. Original firmware file from IC vendor is named
> 'fw_bcm43436b0.bin', but brcmfmac and also btbcm drivers report chip
> id 43430, so requested firmware file name is
> 'brcmfmac43430b0-sdio.bin' in line with other 43430 revisions.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 16ed325795a8..f0c22b5bb57c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -617,6 +617,7 @@ BRCMF_FW_DEF(4339, "brcmfmac4339-sdio");
>   BRCMF_FW_DEF(43430A0, "brcmfmac43430a0-sdio");
>   /* Note the names are not postfixed with a1 for backward compatibility */
>   BRCMF_FW_DEF(43430A1, "brcmfmac43430-sdio");
> +BRCMF_FW_DEF(43430B0, "brcmfmac43430b0-sdio");
>   BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
>   BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
>   BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
> @@ -643,7 +644,8 @@ static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>   	BRCMF_FW_ENTRY(BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, 43362),
>   	BRCMF_FW_ENTRY(BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, 4339),
>   	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000001, 43430A0),
> -	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0xFFFFFFFE, 43430A1),
> +	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000002, 43430A1),
> +	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000004, 43430B0),

Please follow the existing strategy, ie. support higher chip revisions 
unless proven otherwise. So 0xFFFFFFFC iso 0x00000004.

>   	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0x00000200, 43456),
>   	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFDC0, 43455),
>   	BRCMF_FW_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
> 
