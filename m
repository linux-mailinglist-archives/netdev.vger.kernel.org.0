Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1F64B41F5
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 07:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbiBNG0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 01:26:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiBNG0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 01:26:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEA744E389
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644819972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MocfuCgXeofqqVmmusI1NLVP1hEoCkLeL//irsNDbNI=;
        b=cRX08Ovg/kk5GJxn95tNkrXnJFhuCRd1o8GxTasGaqoZd+nFTXJJ+kDzZ3YtmcKFQfVrMO
        x6cjGJV4kVxhqVeARvB+p34CqBDuO2PQyYYsTpgHC4WQ2Ov/ozzywwlaZ0zQ0Y29KqQ+gM
        AsDtyAfQRAJmnOXxLoxco3UwVbKo2G8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-nByDiYyeO2WKuybjbqrEwA-1; Mon, 14 Feb 2022 01:26:11 -0500
X-MC-Unique: nByDiYyeO2WKuybjbqrEwA-1
Received: by mail-pf1-f198.google.com with SMTP id t24-20020aa79398000000b004e025989ac7so11014434pfe.18
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:26:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MocfuCgXeofqqVmmusI1NLVP1hEoCkLeL//irsNDbNI=;
        b=x3tEcMGVJHogKs/SxyTR/2Pgs3JwugFjKseN89ypBY5iiOZLVhxeK846WcBexShdvL
         BDqRB2s+mT0j4xLYkT6yZ15x4d108sWwAztUs35hGRzT/Mz+2R4m4VHGlg5z0HA8T3eZ
         ovGXMQp7Tk4Tb0LHI6yc+lyvFXBtLEdIpxHSkSn//XUJD9/xFxmkAaeiS49RvbqyQjho
         HhGjmxOfzWBqiUKXAK3tdEX7SziCpu5uEB5WjiYKJdG4TR7B819lWzins9A8ptfelnpE
         RlyNUKJdsU/rYJMbRoVrfNKAAl2FISKtBBknnXgTQmUOulJNcWuLRc0rlc1STEDjbWRa
         O5/A==
X-Gm-Message-State: AOAM532hi7gkflsYVZsxM2rLqmg5bF35erSYs53FQuns1glSdEBm1rzQ
        XVnO+LAH5T/+HDsW7LPfHGm6pZKgl43hhk5y8ngKIUYDXEXdxZT31p5BJD2RxyvfryuuR5oOPuU
        Mqyl2Q1lYfDIUkGob
X-Received: by 2002:a17:90a:5a:: with SMTP id 26mr13047546pjb.240.1644819970457;
        Sun, 13 Feb 2022 22:26:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxYCTIWIbAB3vhnD6sWKrSxihCfIRX4lvpLj+0epxRwz2O4+hNT+QkBupvVNAFGSmpLC8y3GA==
X-Received: by 2002:a17:90a:5a:: with SMTP id 26mr13047534pjb.240.1644819970221;
        Sun, 13 Feb 2022 22:26:10 -0800 (PST)
Received: from [10.72.12.239] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q26sm1702931pgt.67.2022.02.13.22.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 22:26:09 -0800 (PST)
Message-ID: <8dc502ae-848d-565e-bdef-88bdd6b8053f@redhat.com>
Date:   Mon, 14 Feb 2022 14:26:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH V4 2/4] vDPA/ifcvf: implement device MSIX vector allocator
Content-Language: en-US
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
 <20220203072735.189716-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220203072735.189716-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/3 下午3:27, Zhu Lingshan 写道:
> This commit implements a MSIX vector allocation helper
> for vqs and config interrupts.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 35 +++++++++++++++++++++++++++++++--
>   1 file changed, 33 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index d1a6b5ab543c..44c89ab0b6da 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -58,14 +58,45 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>   	ifcvf_free_irq_vectors(pdev);
>   }
>   
> +/* ifcvf MSIX vectors allocator, this helper tries to allocate
> + * vectors for all virtqueues and the config interrupt.
> + * It returns the number of allocated vectors, negative
> + * return value when fails.
> + */
> +static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct ifcvf_hw *vf = &adapter->vf;
> +	int max_intr, ret;
> +
> +	/* all queues and config interrupt  */
> +	max_intr = vf->nr_vring + 1;
> +	ret = pci_alloc_irq_vectors(pdev, 1, max_intr, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
> +
> +	if (ret < 0) {
> +		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
> +		return ret;
> +	}
> +
> +	if (ret < max_intr)
> +		IFCVF_INFO(pdev,
> +			   "Requested %u vectors, however only %u allocated, lower performance\n",
> +			   max_intr, ret);
> +
> +	return ret;
> +}
> +
>   static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>   {
>   	struct pci_dev *pdev = adapter->pdev;
>   	struct ifcvf_hw *vf = &adapter->vf;
> -	int vector, i, ret, irq;
> +	int vector, nvectors, i, ret, irq;
>   	u16 max_intr;
>   
> -	/* all queues and config interrupt  */
> +	nvectors = ifcvf_alloc_vectors(adapter);
> +	if (!(nvectors > 0))
> +		return nvectors;


Why not simply checking by using nvectors <= 0? If ifcvf_alloc_vectors 
can return 0 this breaks the ifcvf_request_irq() caller's assumption.


> +
>   	max_intr = vf->nr_vring + 1;
>   
>   	ret = pci_alloc_irq_vectors(pdev, max_intr,


So irq is allocated twice here?

Thanks


