Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F712A25C2
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 09:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgKBIBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 03:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbgKBIBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 03:01:08 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341FCC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 00:01:08 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id i16so7977433wrv.1
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 00:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8jUzqNep3OOoL2CEWY8ZxqHAkvSVk/SVo9IUG892wjs=;
        b=gV/iGOAprbstD1QCMnMo1p60YfmfXkF2GVunKiNC4WNi1RmswetqeNIQ+7ca9rmRwa
         A7R+15PVEJfYOEBXJ/OmYrMH25u0fSTbX8Jd6Q0538r3CeQmVwXB0WGRSMd5rEFJLURl
         n2Dr9ZuLTmRTU6Qrzu0J/NFi71mG+PdxtoIQEfsTIDOJWQhSMPeFjfqjKrzBEMwigqR5
         ugAW7IcsGj8CPlnMQeOqbWwh1h537IQK/v/XkKzbU4gyJ9Kt/Gg/n6FpwArmggJRo/CK
         IstUa7OJGm1d7+3Jd5J4MPKAk091QPyhr5xgwu+bDdJFJ6CN+dP64TPgMfx+73mucYAo
         8e7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8jUzqNep3OOoL2CEWY8ZxqHAkvSVk/SVo9IUG892wjs=;
        b=Tk7YhIL34/nNLh4Ngqp1t+SaBVKAcMrtcdyRMO/Ps8Vvp2RzN7WorK2EoMrBWdwfn1
         fXiHYMinP9HtzrX8FFTlwRYJxPukjZlVP+d3z6RiINFap3i47Vqr821DaLnF6peQr047
         KdPEqXWgA1If0NTleeQinBSAlj6YibqwT+euHanBFlEFA1gKzUALn9A5Ajgus2+QIEOg
         TnPOpiQ6x/IYlmuZcer0NyK8BnRtLuu11nWSOmne5ApAo79iQYcEJ1iQGYTJJ7XA6BWz
         8wSnDWGifPAJD5P3IbtoU0i4rv/S63bwSppCSUnswHDQ0oP4XZkgCHsn0whZFTf3bboO
         KgnQ==
X-Gm-Message-State: AOAM5327HFfe8eJahROD4ocf7PNcaGibsuPR2K/GkNhml5LY5+MB56mb
        vRR92VI+on8uhW6kX1HAGOpw6Kos+io=
X-Google-Smtp-Source: ABdhPJx8czcR1I6PxkLyNKziWed6vnjn25qe8f10PtAhio3OwXJl8qqfwDLRvynSNtIKJimVNn0nyQ==
X-Received: by 2002:adf:f54c:: with SMTP id j12mr18683606wrp.413.1604304066571;
        Mon, 02 Nov 2020 00:01:06 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7ce1:60e1:9597:1002? (p200300ea8f2328007ce160e195971002.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7ce1:60e1:9597:1002])
        by smtp.googlemail.com with ESMTPSA id h62sm22349330wrh.82.2020.11.02.00.01.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 00:01:06 -0800 (PST)
Subject: Re: [PATCH net-next] r8169: set IRQF_NO_THREAD if MSI(X) is enabled
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <446cf5b8-dddd-197f-cb96-66783141ade4@gmail.com>
 <20201102000652.5i5o7ig56lymcjsv@skbuf>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b8d6e0ec-7ccb-3d11-db0a-8f60676a6f8d@gmail.com>
Date:   Mon, 2 Nov 2020 09:01:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201102000652.5i5o7ig56lymcjsv@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.11.2020 01:06, Vladimir Oltean wrote:
> On Sun, Nov 01, 2020 at 11:30:44PM +0100, Heiner Kallweit wrote:
>> We had to remove flag IRQF_NO_THREAD because it conflicts with shared
>> interrupts in case legacy interrupts are used. Following up on the
>> linked discussion set IRQF_NO_THREAD if MSI or MSI-X is used, because
>> both guarantee that interrupt won't be shared.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> Link: https://www.spinics.net/lists/netdev/msg695341.html
> 
> I am not sure if this utilization of the Link: tag is valid. I think it
> has a well-defined meaning and maintainers use it to provide a link to
> the email where the patch was picked from:
> https://lkml.org/lkml/2011/4/6/421
> 

Thanks for the link. There have been discussions whether to have the
change log of patches as part of the commit message or not, and as part
of this discussion how the Link tag can help. IIRC outcome was:
- Link tag can be used to point to a discussion elaborating on the
  evolution of a patch series
- Link tag can be used to point to a discussion explaining the motivation
  for a change

Having said that it's my understanding that this tag isn't to be used by
the maintainers only. However maintainers may see this differently.

>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 319399a03..4d6afaf7c 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -4690,6 +4690,7 @@ static int rtl_open(struct net_device *dev)
>>  {
>>  	struct rtl8169_private *tp = netdev_priv(dev);
>>  	struct pci_dev *pdev = tp->pci_dev;
>> +	unsigned long irqflags;
>>  	int retval = -ENOMEM;
>>  
>>  	pm_runtime_get_sync(&pdev->dev);
>> @@ -4714,8 +4715,9 @@ static int rtl_open(struct net_device *dev)
>>  
>>  	rtl_request_firmware(tp);
>>  
>> +	irqflags = pci_dev_msi_enabled(pdev) ? IRQF_NO_THREAD : IRQF_SHARED;
>>  	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
>> -			     IRQF_SHARED, dev->name, tp);
>> +			     irqflags, dev->name, tp);
>>  	if (retval < 0)
>>  		goto err_release_fw_2;
>>  
>> -- 
>> 2.29.2
>>
> 
> So all things considered, what do you want to achieve with this change?
> Is there other benefit with disabling force threading of the
> rtl8169_interrupt, or are you still looking to add back the
> napi_schedule_irqoff call?
> 

As mentioned by Eric it doesn't make sense to make the minimal hard irq
handlers used with NAPI a thread. This more contributes to the problem
than to the solution. The change here reflects this. The actual discussion
would be how to make the NAPI processing a thread (instead softirq).

For using napi_schedule_irqoff we most likely need something like
if (pci_dev_msi_enabled(pdev))
	napi_schedule_irqoff(napi);
else
	napi_schedule(napi);
and I doubt that's worth it.
