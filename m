Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BE42C2528
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733203AbgKXMBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:01:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729172AbgKXMBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:01:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606219290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jFWhLFtfwd2p3lUKJ8drhblrE5r73sVZPJsFgL8VlxM=;
        b=WKnNoTu8i12M+Dx2lwrYJD07jDGkuE2YbwytEX14J8yugubn2P/wcHpzs/7p0c9BB2ett7
        B/S4/+yR0hGjTUB54PaOE+I/6hvLS+TnCKLGecCfCYO3u2eS3XM8IT4MhS4Vyyg1WhtnM9
        VKnuUqJi8c/9A5FhPn7cTTiqKgSEcqs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-1bjxmXYpPXOQI6ZRXTdJoQ-1; Tue, 24 Nov 2020 07:01:25 -0500
X-MC-Unique: 1bjxmXYpPXOQI6ZRXTdJoQ-1
Received: by mail-ej1-f69.google.com with SMTP id g18so2183205eje.1
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 04:01:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jFWhLFtfwd2p3lUKJ8drhblrE5r73sVZPJsFgL8VlxM=;
        b=ZKqAXar5T5yKikro5M/DSr4gDagKenEzc8bUqXr3jyRc8R1hlIjiJMGN9j5f73ckhr
         miafKbSf9+1gE1QzY77lBkR6TytuC5S+0a8Yx/kqAZ5UhKQd3tOiiB4F3UccS8OGjVV6
         LeNFvFXciqiaDYl36e8q6kwP6Wh0fRWM9kYMCgHSmafHREX3d2KoSNhy4NOrUQgHZU9L
         7FlW8dYEAi+cTyDfPsTLOH0Bl5sIjkK7YgooSOYHTq51lCDGU4GkJw3dL1recXlfySc6
         eW35tq9TkY8ywgyEDeMoFA65R0InT+80G2yil9Q4xFMa8RPnOVOcXBuVhiHvBxKaAHZn
         DQBg==
X-Gm-Message-State: AOAM532bzPuhOXHGNvcsm60iT0QjvhdCN7YML8uGuXDHBkdUA6RrBNvN
        U2DbATUMBp8cQCHaqcG9kP5IcCGWNDy5iO/De9jCZ3Zmtqo3LOGyk2xne+w5hCZHevZlvDm0SSm
        Xolw69XrnQlKmDJTk
X-Received: by 2002:a17:906:ce41:: with SMTP id se1mr4122824ejb.155.1606219284625;
        Tue, 24 Nov 2020 04:01:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzPxYpjkY9DnFSI+JjDHn1CBMwNDM8Ugsx2KlZwnL8pg+jjxVjOWB3NL4jvgFnDJm7qNiaSUQ==
X-Received: by 2002:a17:906:ce41:: with SMTP id se1mr4122772ejb.155.1606219284409;
        Tue, 24 Nov 2020 04:01:24 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-6c10-fbf3-14c4-884c.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:6c10:fbf3:14c4:884c])
        by smtp.gmail.com with ESMTPSA id c30sm6748650edd.68.2020.11.24.04.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 04:01:23 -0800 (PST)
Subject: Re: [PATCH v3] brcmfmac: expose firmware config files through modinfo
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
        Matthias Brugger <mbrugger@suse.com>, digetx@gmail.com,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Amar Shankar <amsr@cypress.com>, brcm80211-dev-list@cypress.com
References: <20201124120018.31358-1-matthias.bgg@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <83cdf5c7-bc07-f5c9-1165-821aa3b11ba2@redhat.com>
Date:   Tue, 24 Nov 2020 13:01:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201124120018.31358-1-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/24/20 1:00 PM, matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
> 
> Apart from a firmware binary the chip needs a config file used by the
> FW. Add the config files to modinfo so that they can be read by
> userspace.
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> 
> ---
> 
> Changes in v3:
> Use only two more generic wildcards.

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> 
> Changes in v2:
> In comparison to first version [0] we use wildcards to enumerate the
> firmware configuration files. Wildcard support was added to dracut
> recently [1].
> [0] https://lore.kernel.org/linux-wireless/20200701153123.25602-1-matthias.bgg@kernel.org/
> [1] https://github.com/dracutdevs/dracut/pull/860
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 99987a789e7e..6fe91c537adf 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -625,6 +625,10 @@ BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
>  BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>  BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>  
> +/* firmware config files */
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac*-sdio.*.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac*-pcie.*.txt");
> +
>  static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>  	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
>  	BRCMF_FW_ENTRY(BRCM_CC_43241_CHIP_ID, 0x0000001F, 43241B0),
> 

