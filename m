Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE60D3B5F93
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 16:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhF1OI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 10:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhF1OI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 10:08:27 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87B5C061574;
        Mon, 28 Jun 2021 07:06:00 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id k8so25881436lja.4;
        Mon, 28 Jun 2021 07:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=1R0iH+DWaUknOCEjRDNGWia7J9lYBcVhqVAgEOlMaNg=;
        b=GcGrlpvy5yF9fsY4YxegiUwYF+38oGxhgYU5mtnIdoHsQq/KpDgtXl9jUogcBfNKcH
         krtoUNXYrGKumjVU3XCO9C3ifwRX2xdkrpPScOAiCN6GU35qTOb2bbaOb+t31IN/xyX0
         i1FcK7djGng+NoF5DO/c0I6xQqIulU/ykl2pRQG5rN85N4+K38uepEtyJPlYfsDTutrc
         tX1SJAysW+LPOYLLqyvydhgjBYEnGmWjYSF9UIDXM42yZ3C4RBhYxf+6zelnS+LDZA63
         EGYIJoWZvc+1TLGqQxygmqV4pWnkKEBssfkvp8GlSUuqw/VQrAPlzBB/offaEngnOAgq
         AiKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=1R0iH+DWaUknOCEjRDNGWia7J9lYBcVhqVAgEOlMaNg=;
        b=IQzxrffXYUTZx1vpBUDPYc3Rw64URscFGhmafMmbgICcVVvUEaCTZY8hlG0vtXZBN/
         s9+cCbdLdsmDwQT0d2VBXh7YGWVC9G/wO2PcwhRIOicfj41+XRAvchtzXr4xZlydR9B0
         7cKKOAWgv+v8nCq9Ts9nXlFStxO06lbUoDIgpv0bmecf2zCOe3boGHSS8EPYQ5EW2tQS
         ERTOI20yJngQyBqZzwXqEFQYpU15RNFmLdogSMZQG4Ns1G9pDscuMXDUPuRd0nSPdObV
         lN4AWHFqVWcA+d3jYgC31uwPpeRzRNO8YoE0MQAsvO5VkyGietm0wk/EFkuZNO1sDjk+
         Po6w==
X-Gm-Message-State: AOAM530yBDGM6tHsKfns0Pwotzm5sB6Nj1h6TXQ/W5KBK5FIdwqkh6nI
        rLg26WI6thZnLck4bFQs/rJJY0ZBymSc7w==
X-Google-Smtp-Source: ABdhPJzbc9uuPKdCa17OwWSdgQGREWE9z4SHVIBe4YdZ/BPD0trRDMyNsw9uxMp9tuIreRSKTdRoqQ==
X-Received: by 2002:a2e:a7cd:: with SMTP id x13mr19940525ljp.218.1624889157571;
        Mon, 28 Jun 2021 07:05:57 -0700 (PDT)
Received: from razdolb ([62.176.30.88])
        by smtp.gmail.com with ESMTPSA id bu21sm1440090lfb.180.2021.06.28.07.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 07:05:56 -0700 (PDT)
References: <20210509233010.2477973-1-mike.rudenko@gmail.com>
 <c63f85b6-dbca-7f89-a015-70f5821df96d@broadcom.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
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
Subject: Re: [PATCH] brcmfmac: use separate firmware for 43430 revision 2
In-reply-to: <c63f85b6-dbca-7f89-a015-70f5821df96d@broadcom.com>
Date:   Mon, 28 Jun 2021 17:05:55 +0300
Message-ID: <87k0mem6d8.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-06-28 at 15:16 MSK, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:

> On 5/10/2021 1:30 AM, Mikhail Rudenko wrote:
>> A separate firmware is needed for Broadcom 43430 revision 2.  This
>> chip can be found in e.g. certain revisions of Ampak AP6212 wireless
>> IC. Original firmware file from IC vendor is named
>> 'fw_bcm43436b0.bin', but brcmfmac and also btbcm drivers report chip
>> id 43430, so requested firmware file name is
>> 'brcmfmac43430b0-sdio.bin' in line with other 43430 revisions.
>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> index 16ed325795a8..f0c22b5bb57c 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> @@ -617,6 +617,7 @@ BRCMF_FW_DEF(4339, "brcmfmac4339-sdio");
>>   BRCMF_FW_DEF(43430A0, "brcmfmac43430a0-sdio");
>>   /* Note the names are not postfixed with a1 for backward compatibility */
>>   BRCMF_FW_DEF(43430A1, "brcmfmac43430-sdio");
>> +BRCMF_FW_DEF(43430B0, "brcmfmac43430b0-sdio");
>>   BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
>>   BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
>>   BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
>> @@ -643,7 +644,8 @@ static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>>   	BRCMF_FW_ENTRY(BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, 43362),
>>   	BRCMF_FW_ENTRY(BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, 4339),
>>   	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000001, 43430A0),
>> -	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0xFFFFFFFE, 43430A1),
>> +	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000002, 43430A1),
>> +	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000004, 43430B0),
>
> Please follow the existing strategy, ie. support higher chip revisions
> unless proven otherwise. So 0xFFFFFFFC iso 0x00000004.

Will fix in v2, thanks.

>>   	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0x00000200, 43456),
>>   	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFDC0, 43455),
>>   	BRCMF_FW_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
>>

--
Regards,
Mikhail
