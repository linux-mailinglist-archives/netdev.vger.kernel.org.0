Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A9F42C85E
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 20:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhJMSLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 14:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhJMSLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 14:11:13 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6794C061570;
        Wed, 13 Oct 2021 11:09:09 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id m22so11360631wrb.0;
        Wed, 13 Oct 2021 11:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/ytiN9XGDbiiKGkMOwESD33uHgZwCopfsh4LpOW+5PE=;
        b=OEuwdOW4DwKh1KYjwdUaRVNIQlco8GFcy8Z2mXSJinApGVhVSjTY2yfgag4fh4Jfzl
         8MFkfxLEtKDGPY88Cupdl1uDqG3DJFL3aYv87umbNRjXsEezPTZ2gRQFHLMaEKVLajxv
         3S2YJbF7Aia2irgHTYKRbpe69bSM7XQJIbw+wzGOcmTHE6k+7+bKLsk5fYY8fWR9EXyz
         n/g+SuqXRRWLYIXpBPlNxVlEIdFxHEbGqgaYErg62kzsPruJMXm6icltn7+w82R4dyr3
         45BQeh7vB7WHJTyafovlaAViRQqEaa/yS11cbWBe2O246/VtbslIQtxyItsOsw4zL+05
         vJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/ytiN9XGDbiiKGkMOwESD33uHgZwCopfsh4LpOW+5PE=;
        b=mbXy5oVclGfnrE2pX7howdQQRxEJvDFNjUYp0ukFhPv6LIBTo4SZEWEecMg9i17IZk
         linuqhHZ93/kdmdfOD6L4E/FI1cOJURv3UW2yaPfvbiYeHF7PJTm0cmBMEg6J3n4sFgI
         ETo+Dl90qcIx9Ut5thcWV/ZLtv2aNFgt4vUncfa9M0zc5NoJIuKYwUAXNI90nsUSy55N
         WtJ82VwEEGWE8TUmBEa49bks52ECCA65ed3ONF3fqlDWJaiIKSH9DsqopxQ369NYl6f6
         bI8fe45o822yLh5TPxyx9td5TYweVHtuFCvRuFWyTwaxwtMDOcW+zznWpk7kZzg6+mSo
         3EtQ==
X-Gm-Message-State: AOAM5300lylDOuGP16rhvvjRdpUo34rdB7kydT4t2Qzp6uxvvo0eCjTM
        5hxq9VFsflVVMSd75z5pFxI1AwwSs5E=
X-Google-Smtp-Source: ABdhPJwfCFerKAXMGvYUzZCWIM7MdT/r+zanRxobT3iuW1uJSYPY/ZAgJnuIMt1aOsL+85yk+qjVZw==
X-Received: by 2002:a1c:4302:: with SMTP id q2mr14754298wma.133.1634148548500;
        Wed, 13 Oct 2021 11:09:08 -0700 (PDT)
Received: from ?IPV6:2003:ea:8f22:fa00:49bd:5329:15d2:9218? (p200300ea8f22fa0049bd532915d29218.dip0.t-ipconnect.de. [2003:ea:8f22:fa00:49bd:5329:15d2:9218])
        by smtp.googlemail.com with ESMTPSA id g188sm143892wmg.46.2021.10.13.11.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 11:09:08 -0700 (PDT)
Message-ID: <0c141713-c8d9-c910-e083-5dab67929c51@gmail.com>
Date:   Wed, 13 Oct 2021 20:08:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/5] PCI/VPD: Add pci_read/write_vpd_any()
Content-Language: en-US
To:     Qian Cai <quic_qiancai@quicinc.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
 <93ecce28-a158-f02a-d134-8afcaced8efe@gmail.com>
 <e89087c5-c495-c5ca-feb1-54cf3a8775c5@quicinc.com>
 <ca805454-6ec5-303b-d39f-d505cad6b338@gmail.com>
 <64b87f6b-5db9-721f-1bb8-6ae29742bf96@quicinc.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <64b87f6b-5db9-721f-1bb8-6ae29742bf96@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.10.2021 16:22, Qian Cai wrote:
> 
> 
> On 10/12/2021 4:26 PM, Heiner Kallweit wrote:
>> Thanks for the report! I could reproduce the issue, the following fixes
>> it for me. Could you please test whether it fixes the issue for you as well?
> 
> Yes, it works fine. BTW, in the original patch here:
> 
Thanks for testing!

> --- a/drivers/pci/vpd.c
> +++ b/drivers/pci/vpd.c
> @@ -138,9 +138,10 @@ static int pci_vpd_wait(struct pci_dev *dev, bool set)
>  }
>  
>  static ssize_t pci_vpd_read(struct pci_dev *dev, loff_t pos, size_t count,
> -			    void *arg)
> +			    void *arg, bool check_size)
>  {
>  	struct pci_vpd *vpd = &dev->vpd;
> +	unsigned int max_len = check_size ? vpd->len : PCI_VPD_MAX_SIZE;
>  	int ret = 0;
>  	loff_t end = pos + count;
>  	u8 *buf = arg;
> @@ -151,11 +152,11 @@ static ssize_t pci_vpd_read(struct pci_dev *dev, loff_t pos, size_t count,
>  	if (pos < 0)
>  		return -EINVAL;
>  
> -	if (pos > vpd->len)
> +	if (pos >= max_len)
>  		return 0;
> 
> I am not sure if "pos >= max_len" is correct there, so just want to give you
> a chance to double-check.
> 
This is intentional, but good catch.
