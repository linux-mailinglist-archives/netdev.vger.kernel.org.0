Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572671CD650
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 12:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgEKKSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 06:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725983AbgEKKSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 06:18:33 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E622C061A0C;
        Mon, 11 May 2020 03:18:33 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so10212315wra.7;
        Mon, 11 May 2020 03:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t71zh83koaUlMEdc7vfVoBfDMjb5NGvXpFftlY+VFEU=;
        b=GzmoexfentuFiJhpxa0AY3I29IYA4NPCLrltTQHXNc773O58YyH10MAd7DpCgHRha/
         m5OoZXIqKWYswiwlCKjxP3BMEnE09rnweSZZ3GHbQCuV1W48QfP7mmNinlnmBmFApsGF
         J3a/jZ3n0ldXcD2CWNo/LI0YKVDH0qHDDuCnc19hE13R/bdyBNF5A8koDDZltnKAJWxy
         uBq5yQtt58gn/XOHOzx9OXxB12cXxocyAmHVHynvHBjqv0RaATgLyMZOYEf4JgkSywHL
         te/llctpmZBlgMten/xYkhH8KOBRsj5t172THUo4UiG+RiK+UPjTFZFIHmtBb8jYMyTj
         czdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t71zh83koaUlMEdc7vfVoBfDMjb5NGvXpFftlY+VFEU=;
        b=aa9c4cu6Jr6z3fAJ9406mGX/v5eozdLiaJFG0lW9/Cwcol2HS6xyqJPinKA/4kebFm
         mXLipP6XGJKrxRNx6Y9buBgTys0lCm4i8b+JrPLk5BTnzCyAsI9IG9gZaibM28XUdD2W
         tsPVFto+MevkWrWyBNFB9FEDFNch0F92rfqX+bJYlNY8118ENu6eUxlerYGoeFFjGoGS
         iY7mqWudN/W4PtQ7p1mJELYNFCWcrAu6J7wpHt+6bPeZ6zyRBhx3TXhYwzENxx+NB3S0
         NJRZ71SDvl03N+TbR8RfPOKXsVKeHdJzpGPeZC6QH8GyoktlUNKQMRU1j3bUtUI38S8Q
         VMYA==
X-Gm-Message-State: AGi0PuaX1nNMTzMfYxkaaS4pxJ3IQL3q7R3sHiOnUR6bGMiVqJ1Jaj2W
        cCtHTuGe+L8Zgny+ytrDd9FisCTtKfM=
X-Google-Smtp-Source: APiQypIboAu9feHJkwkFIZ2bcGWSedLd1dnr/EpITbayJXobdaCRSvrm4FPmdCITJOCvVweGNUu/5Q==
X-Received: by 2002:adf:fd46:: with SMTP id h6mr18866359wrs.90.1589192311855;
        Mon, 11 May 2020 03:18:31 -0700 (PDT)
Received: from [192.168.1.94] (93-41-244-45.ip84.fastwebnet.it. [93.41.244.45])
        by smtp.gmail.com with ESMTPSA id d126sm6449472wmd.32.2020.05.11.03.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 03:18:31 -0700 (PDT)
Subject: Re: [PATCH] ifcvf: move IRQ request/free to status change handlers
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1589181563-38400-1-git-send-email-lingshan.zhu@intel.com>
 <22d9dcdb-e790-0a68-ba41-b9530b2bf9fd@redhat.com>
From:   Francesco Lavra <francescolavra.fl@gmail.com>
Message-ID: <c1da2054-eb4c-d7dd-ca83-29e85e5cfe90@gmail.com>
Date:   Mon, 11 May 2020 12:18:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <22d9dcdb-e790-0a68-ba41-b9530b2bf9fd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/20 11:26 AM, Jason Wang wrote:
> 
> On 2020/5/11 下午3:19, Zhu Lingshan wrote:
>> This commit move IRQ request and free operations from probe()
>> to VIRTIO status change handler to comply with VIRTIO spec.
>>
>> VIRTIO spec 1.1, section 2.1.2 Device Requirements: Device Status Field
>> The device MUST NOT consume buffers or send any used buffer
>> notifications to the driver before DRIVER_OK.
> 
> 
> My previous explanation might be wrong here. It depends on how you 
> implement your hardware, if you hardware guarantee that no interrupt 
> will be triggered before DRIVER_OK, then it's fine.
> 
> And the main goal for this patch is to allocate the interrupt on demand.
> 
> 
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 119 
>> ++++++++++++++++++++++++----------------
>>   1 file changed, 73 insertions(+), 46 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index abf6a061..4d58bf2 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -28,6 +28,60 @@ static irqreturn_t ifcvf_intr_handler(int irq, void 
>> *arg)
>>       return IRQ_HANDLED;
>>   }
>> +static void ifcvf_free_irq_vectors(void *data)
>> +{
>> +    pci_free_irq_vectors(data);
>> +}
>> +
>> +static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>> +{
>> +    struct pci_dev *pdev = adapter->pdev;
>> +    struct ifcvf_hw *vf = &adapter->vf;
>> +    int i;
>> +
>> +
>> +    for (i = 0; i < queues; i++)
>> +        devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
>> +
>> +    ifcvf_free_irq_vectors(pdev);
>> +}
>> +
>> +static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>> +{
>> +    struct pci_dev *pdev = adapter->pdev;
>> +    struct ifcvf_hw *vf = &adapter->vf;
>> +    int vector, i, ret, irq;
>> +
>> +    ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
>> +                    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
>> +    if (ret < 0) {
>> +        IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
>> +        return ret;
>> +    }
>> +
>> +    for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>> +        snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
>> +             pci_name(pdev), i);
>> +        vector = i + IFCVF_MSI_QUEUE_OFF;
>> +        irq = pci_irq_vector(pdev, vector);
>> +        ret = devm_request_irq(&pdev->dev, irq,
>> +                       ifcvf_intr_handler, 0,
>> +                       vf->vring[i].msix_name,
>> +                       &vf->vring[i]);
>> +        if (ret) {
>> +            IFCVF_ERR(pdev,
>> +                  "Failed to request irq for vq %d\n", i);
>> +            ifcvf_free_irq(adapter, i);
> 
> 
> I'm not sure this unwind is correct. It looks like we should loop and 
> call devm_free_irq() for virtqueue [0, i);

That's exactly what the code does: ifcvf_free_irq() contains a (i = 0; i 
< queues; i++) loop, and here the function is called with the `queues` 
argument set to `i`.
