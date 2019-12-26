Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4A412AD15
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 15:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfLZOiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 09:38:03 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44513 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfLZOiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 09:38:02 -0500
Received: by mail-lf1-f68.google.com with SMTP id v201so18618597lfa.11;
        Thu, 26 Dec 2019 06:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2uXdMyHtTWWc+0rTxfP2Cz8myNyuUa0oqAF7KA6mwz8=;
        b=aTqAifniw/x+mvTlGZRNdXxg/Vacd5KTNENcr9w65x/UftLQ9pMULKiwyt2FQGeqeK
         VmHla6phspDVELC8vVU++gzau8vt7YIQuGFMqArlYykoOQdACIOGKvTmN27G3MfOVw3Q
         yCSSTKiJpMwy4hBO4Q2oR6/4AQc3vM0rnzcwh4OBron/Kw7FXjTkUOdrvMnVXBtQ5blL
         UP4IAWa95snDlFHnFnnq0qCg1LWzTqwmom+yJ1LOFviv3BLdVlUK97R/k43C4lzE+RHR
         jWn5k4EONVlXswHz5NECuLs27/ZvpESjC3YcuBtWcmRvdB9ifsLGHffPnwNwNh4HQubo
         T8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2uXdMyHtTWWc+0rTxfP2Cz8myNyuUa0oqAF7KA6mwz8=;
        b=tf4KlLKo0tig6skL6VT4QiaTTAPBMXXYQgwXsLNb1uRmJnpebpoN+E0PetpWkZfvfX
         e6Vw+gPSpz8DvOEwbRBfbT8/O4/ypbNpRZImTqX4+US6hgwihaFKHPCq7tAZL5/to0pv
         qZcC68u91aHbW7y6KPqe6qh3c2Uy3rBwxPfo1uM0vGyOr6GiVOaagUs1/XMm1FM8KpJV
         HxZsaJ0z+bja1vVEsNSQB5eFYg3j5OU4s3zxnANAsM0ZlrFKHZPgBcskRR5j4XoDEmmY
         fXOXCccwSiHi020lO1FnOzFnFhYrx7prWoRxR7ebvKOJeDt0gtcMMTFbqLYTb6Gt2ao3
         X4SQ==
X-Gm-Message-State: APjAAAVbGjVo5uHbgBT4q4z8k1nCOSdM7l747GNN2+PS2WLkG3iA6pZU
        kRBrDnmpcfFH/xVmqzEnO1o=
X-Google-Smtp-Source: APXvYqzLvmX9xvbqZfqMciYkfmu7gE48D+i9eKKISYQS/PqPPyLoOU2sGnLVgxk5uWIe+ygP+3nFCQ==
X-Received: by 2002:ac2:5582:: with SMTP id v2mr27328339lfg.183.1577371080463;
        Thu, 26 Dec 2019 06:38:00 -0800 (PST)
Received: from [192.168.2.145] (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.googlemail.com with ESMTPSA id u13sm13033823lfq.19.2019.12.26.06.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 06:37:59 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: sdio: Fix OOB interrupt initialization on
 brcm43362
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        hdegoede@redhat.com
Cc:     franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        kvalo@codeaurora.org, davem@davemloft.net
References: <20191226092033.12600-1-jean-philippe@linaro.org>
 <16f419a7070.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <141f055a-cd1d-66cb-7052-007cda629d3a@gmail.com>
Date:   Thu, 26 Dec 2019 17:37:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <16f419a7070.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

26.12.2019 12:47, Arend Van Spriel пишет:
> On December 26, 2019 10:23:41 AM Jean-Philippe Brucker
> <jean-philippe@linaro.org> wrote:
> 
>> Commit 262f2b53f679 ("brcmfmac: call brcmf_attach() just before calling
>> brcmf_bus_started()") changed the initialization order of the brcmfmac
>> SDIO driver. Unfortunately since brcmf_sdiod_intr_register() is now
>> called before the sdiodev->bus_if initialization, it reads the wrong
>> chip ID and fails to initialize the GPIO on brcm43362. Thus the chip
>> cannot send interrupts and fails to probe:
>>
>> [   12.517023] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
>> [   12.531214] ieee80211 phy0: brcmf_bus_started: failed: -110
>> [   12.536976] ieee80211 phy0: brcmf_attach: dongle is not responding:
>> err=-110
>> [   12.566467] brcmfmac: brcmf_sdio_firmware_callback: brcmf_attach
>> failed
>>
>> Initialize the bus interface earlier to ensure that
>> brcmf_sdiod_intr_register() properly sets up the OOB interrupt.
>>
>> BugLink: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908438
>> Fixes: 262f2b53f679 ("brcmfmac: call brcmf_attach() just before
>> calling brcmf_bus_started()")
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> ---
>> A workaround [1] disabling the OOB interrupt is being discussed. It
>> works for me, but this patch fixes the wifi problem on my cubietruck.
> 
> I missed that one. Too bad it was not sent to linux-wireless as well.
> Good find here. I did see another patch dealing with the OOB interrupt
> on Nvidia Tegra. Now I wonder if this is the same issue.
> 
> Regards,
> Arend
> 
>> [1]
>> https://lore.kernel.org/linux-arm-kernel/20180930150927.12076-1-hdegoede@redhat.com/
>>
>> ---
>> .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 12 ++++++------
>> 1 file changed, 6 insertions(+), 6 deletions(-)

I haven't seen any driver probe failures due to OOB on NVIDIA Tegra,
only suspend-resume was problematic due to the unbalanced OOB
interrupt-wake enabling.

But maybe checking whether OOB interrupt-wake works by invoking
enable_irq_wake() during brcmf_sdiod_intr_register() causes trouble for
the cubietruck board.

@Jean-Philippe, could you please try this change (on top of recent
linux-next):

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index b684a5b6d904..80d7106b10a9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -115,13 +115,6 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev
*sdiodev)
                }
                sdiodev->oob_irq_requested = true;

-               ret = enable_irq_wake(pdata->oob_irq_nr);
-               if (ret != 0) {
-                       brcmf_err("enable_irq_wake failed %d\n", ret);
-                       return ret;
-               }
-               disable_irq_wake(pdata->oob_irq_nr);
-
                sdio_claim_host(sdiodev->func1);

                if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {
