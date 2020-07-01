Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC48210F75
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732016AbgGAPie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:38:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24298 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731803AbgGAPid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593617911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Py/4SXH4WezveNFYu/+AP+Bhfed8tqRk59vhVofy0v8=;
        b=LmBQU4KppqXekRt9X1jkQ4GHSIcVKCv3VWP18LJeCRfiaR6t1UoivGSXb13BTWCU/jpxO8
        dgpZVRKHWv28lZXh+Q/4M1LFCqWtW1814TI7tnGMOZU0Zy1ip4slk3NnvYqKsesKKrbfuf
        2D0VStaJIeI3vt68tqMAd+L7VnXRzLE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-5eTBrKpQMdGd5Bi0ngFmFA-1; Wed, 01 Jul 2020 11:38:29 -0400
X-MC-Unique: 5eTBrKpQMdGd5Bi0ngFmFA-1
Received: by mail-ed1-f72.google.com with SMTP id y66so14205849ede.19
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 08:38:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Py/4SXH4WezveNFYu/+AP+Bhfed8tqRk59vhVofy0v8=;
        b=DnhJVFwuLOPLzUaGlin/P65VxpXVhTA9Id1lkqGY+C3cE3l7oTfG+nYIfE4f4/kwIs
         oAO9GXzbPR0Z45837vJXdlgDbwRcdvGdToyq9JX6NsowxyyF6bZJ0uvIFY+neV6gzItM
         NqgVizRr98p0WbQA+ytwLEobiH/F5enjMWPmntFm5hO9E4aFrf8TaGR5gB9x7XBTKGDX
         cSl1T8BB82sJOoxi+LE0htcvZZ9qkD5OzjkU8XTJhABjeOwFEtPO7Y1+r6Spxc2ILxaT
         /QgCQF76bpv/p0cBtJNMyqog8OQjX9Opaff2GIzhlN93jPrYC1eufqIIy2Yt7xSExCTo
         9bbg==
X-Gm-Message-State: AOAM532Eq7V+5xQOGIg2M+ydxlFm9H/NGx6zL1Oo8E6fXejMT4EX7kRz
        e3B8K9kHnwZGxfRLzPVC3+oUmx0FdeLLQ4ZoeHL2Hl15VobECGc1Yeg5DK8HyPTy23vtqmyW/TR
        2IhzM7Kt3Km0LLG4A
X-Received: by 2002:a17:906:a081:: with SMTP id q1mr18682461ejy.499.1593617908049;
        Wed, 01 Jul 2020 08:38:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy54o6ziuAtiZt1wxVzc00dbD4erN4UwBHRUGEg3DjhuOuIzpxwfUP54vl+2dn0vnK85F/E9Q==
X-Received: by 2002:a17:906:a081:: with SMTP id q1mr18682427ejy.499.1593617907763;
        Wed, 01 Jul 2020 08:38:27 -0700 (PDT)
Received: from x1.localdomain ([2a0e:5700:4:11:334c:7e36:8d57:40cb])
        by smtp.gmail.com with ESMTPSA id d12sm6806675edx.80.2020.07.01.08.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 08:38:27 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: expose firmware config files through modinfo
To:     matthias.bgg@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Double Lo <double.lo@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Soeren Moch <smoch@web.de>
References: <20200701153123.25602-1-matthias.bgg@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <338e3cff-dfa0-c588-cf53-a160d75af2ee@redhat.com>
Date:   Wed, 1 Jul 2020 17:38:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701153123.25602-1-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/1/20 5:31 PM, matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
> 
> Apart from a firmware binary the chip needs a config file used by the
> FW. Add the config files to modinfo so that they can be read by
> userspace.

The configfile firmware filename is dynamically generated, just adding the list
of all currently shipped ones is not really helpful and this is going to get
out of sync with what we actually have in linux-firmware.

I must honestly say that I'm not a fan of this, I guess you are trying to
get some tool which builds a minimal image, such as an initrd generator
to add these files to the image ?

I do not immediately have a better idea, but IMHO the solution
this patch proposes is not a good one, so nack from me for this change.

Regards,

Hans



> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> 
> ---
> 
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 310d8075f5d7..ba18df6d8d94 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -624,6 +624,22 @@ BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
>   BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>   BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>   
> +/* firmware config files */
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac4330-sdio.Prowise-PT301.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43340-sdio.meegopad-t08.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43340-sdio.pov-tab-p1006w-data.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43362-sdio.cubietech,cubietruck.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430a0-sdio.jumper-ezpad-mini3.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430a0-sdio.ONDA-V80 PLUS.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.AP6212.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.Hampoo-D2D3_Vi8A1.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.MUR1DX.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.MINIX-NEO Z83-4.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac4356-pcie.gpd-win-pocket.txt");
> +
>   static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>   	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
>   	BRCMF_FW_ENTRY(BRCM_CC_43241_CHIP_ID, 0x0000001F, 43241B0),
> 

