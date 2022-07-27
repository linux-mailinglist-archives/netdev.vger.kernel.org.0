Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98F5581E75
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240080AbiG0D6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiG0D6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:58:45 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021F7108
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:58:44 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id o1so12477249qkg.9
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=71rX20FP4G5nlL1yOuKhTD1XIHulz38D6gFBUoA+IgI=;
        b=i2vP06Kz0PaFprvY1urViUzFq/7z26kXA7rf1R2900TmqhUFJyp5RBIUhFWab9arNa
         5OfIm/Jumum40FswKg2QrmjhcqHhQURzH0GgooPLItPySq5nC5Bu8jrJnRNQ/HlEnBZj
         houFcjHPwyOBG1c8eZY/QOYZOY86QD/pKXRbXr+7NkNrVzfOmH9FeAShyEzYwZd0G+NF
         HQlVeUA8pz4Rg0NDr9VtOPee5uQk5n2R1S68t8Z+8/LAaCBcGcu2dIvk9zYwxGAtoZDR
         t1YmByoV2U3i853uQcxiQ6PGJ5YkgnhWa8+ZSMWq0trRty4TXQOt8mIfEPrBcJM6DGfx
         E8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=71rX20FP4G5nlL1yOuKhTD1XIHulz38D6gFBUoA+IgI=;
        b=f7GXgFB6rFrefnePix67yydMVvaDK9l7UUaqXix03DPnYwG7Jzf785YJHlJAJYi91E
         O4G9tXlLcZcD3QeCM2VWzvMvXAiOP5FDLJr0FUAk7CoRdfXEl85/OJzuAfqyWRXoqbAg
         jUCwIlpQc6lR04yx/dxycQfrKonpVL1DNfAHLo/TaWqsPDLKDNDz/FLSreqWuSTRGG9X
         RsuGNJDSQhI7QkL4L0p7nl1hitMPt4WK+Q1Tfm8vdXPqIN7dPi1eY1p7DrXGms49p2PC
         4JN+j7NQvA7f+NvRzWATIWc+tqpKrPnA2gOQ1cuEf6sfyCx48SLqsBV77rq7RVZPTdJX
         tWJw==
X-Gm-Message-State: AJIora+36fjSGZEngrFT6blwhMlM/dqBvfHotX559mlRPcNhwm1AcTCh
        FYfKI306z8YyPImRDUDjLLtGNHEsQ1M=
X-Google-Smtp-Source: AGRyM1vK6f9QtAKZbJcxIoPmjAtLhgvL22/BctSgVt6JZW/qOTsU2JJ1luiinvuBQuny7A1kBNLsGA==
X-Received: by 2002:a37:b147:0:b0:6b5:fa14:ac00 with SMTP id a68-20020a37b147000000b006b5fa14ac00mr15469012qkf.606.1658894322903;
        Tue, 26 Jul 2022 20:58:42 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id o17-20020ac841d1000000b0031bf484079esm10298832qtm.18.2022.07.26.20.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 20:58:42 -0700 (PDT)
Subject: Re: [PATCH 4/x] sunhme: switch to devres
From:   Sean Anderson <seanga2@gmail.com>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>, netdev@vger.kernel.org
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
 <11922663.O9o76ZdvQC@eto.sf-tec.de>
 <00f00bdf-1a76-693f-5c8f-9b4ceaf76b91@gmail.com>
Message-ID: <7685c7df-83ed-a3a0-6e61-42bd48713dc9@gmail.com>
Date:   Tue, 26 Jul 2022 23:58:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <00f00bdf-1a76-693f-5c8f-9b4ceaf76b91@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/22 11:49 PM, Sean Anderson wrote:
> On 2/14/22 1:31 PM, Rolf Eike Beer wrote:
>> This not only removes a lot of code, it also fixes the memleak of the =
DMA
>> memory when register_netdev() fails.
>>
>> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
>> ---
>> =C2=A0 drivers/net/ethernet/sun/sunhme.c | 55 +++++++++---------------=
-------
>> =C2=A0 1 file changed, 16 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/=
sun/sunhme.c
>> index 980a936ce8d1..ec78f43f75c9 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -2952,7 +2952,6 @@ static int happy_meal_pci_probe(struct pci_dev *=
pdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct happy_meal *hp;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct net_device *dev;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void __iomem *hpreg_base;
>> -=C2=A0=C2=A0=C2=A0 unsigned long hpreg_res;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int i, qfe_slot =3D -1;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char prom_name[64];
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 addr[ETH_ALEN];
>> @@ -2969,7 +2968,7 @@ static int happy_meal_pci_probe(struct pci_dev *=
pdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strcpy(prom_nam=
e, "SUNW,hme");
>> =C2=A0 #endif
>> -=C2=A0=C2=A0=C2=A0 err =3D pci_enable_device(pdev);
>> +=C2=A0=C2=A0=C2=A0 err =3D pcim_enable_device(pdev);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out;
>> @@ -2987,10 +2986,11 @@ static int happy_meal_pci_probe(struct pci_dev=
 *pdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto err_out;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 dev =3D alloc_etherdev(sizeof(struct happy_meal));=

>> -=C2=A0=C2=A0=C2=A0 err =3D -ENOMEM;
>> -=C2=A0=C2=A0=C2=A0 if (!dev)
>> +=C2=A0=C2=A0=C2=A0 dev =3D devm_alloc_etherdev(&pdev->dev, sizeof(str=
uct happy_meal));
>> +=C2=A0=C2=A0=C2=A0 if (!dev) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D -ENOMEM;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out;
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SET_NETDEV_DEV(dev, &pdev->dev);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (hme_version_printed++ =3D=3D 0)
>> @@ -3009,21 +3009,23 @@ static int happy_meal_pci_probe(struct pci_dev=
 *pdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qp->happy_meals=
[qfe_slot] =3D dev;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 hpreg_res =3D pci_resource_start(pdev, 0);
>> -=C2=A0=C2=A0=C2=A0 err =3D -ENODEV;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((pci_resource_flags(pdev, 0) & IORE=
SOURCE_IO) !=3D 0) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk(KERN_ERR=
 "happymeal(PCI): Cannot find proper PCI device base address.\n");
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_cl=
ear_quattro;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 if (pci_request_regions(pdev, DRV_NAME)) {
>> +
>> +=C2=A0=C2=A0=C2=A0 if (!devm_request_region(&pdev->dev, pci_resource_=
start(pdev, 0),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pci_resource_len(pdev, 0),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DRV_NAME)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk(KERN_ERR=
 "happymeal(PCI): Cannot obtain PCI resources, "
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 "aborting.\n");
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_cl=
ear_quattro;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 if ((hpreg_base =3D ioremap(hpreg_res, 0x8000)) =3D=
=3D NULL) {
>> +=C2=A0=C2=A0=C2=A0 hpreg_base =3D pcim_iomap(pdev, 0, 0x8000);
>> +=C2=A0=C2=A0=C2=A0 if (!hpreg_base) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk(KERN_ERR=
 "happymeal(PCI): Unable to remap card memory.\n");
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_free_res;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_clear_quattro=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < 6; i++) {
>> @@ -3089,11 +3091,10 @@ static int happy_meal_pci_probe(struct pci_dev=
 *pdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hp->happy_bursts =3D DMA_BURSTBITS;
>> =C2=A0 #endif
>> -=C2=A0=C2=A0=C2=A0 hp->happy_block =3D dma_alloc_coherent(&pdev->dev,=
 PAGE_SIZE,
>> +=C2=A0=C2=A0=C2=A0 hp->happy_block =3D dmam_alloc_coherent(&pdev->dev=
, PAGE_SIZE,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 &hp->hblock_dvma, GFP_KERNEL);
>> -=C2=A0=C2=A0=C2=A0 err =3D -ENODEV;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!hp->happy_block)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_iounmap;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_clear_quattro=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hp->linkcheck =3D 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hp->timer_state =3D asleep;
>> @@ -3127,11 +3128,11 @@ static int happy_meal_pci_probe(struct pci_dev=
 *pdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 happy_meal_set_initial_advertisement(hp=
);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irq(&hp->happy_lock);
>> -=C2=A0=C2=A0=C2=A0 err =3D register_netdev(hp->dev);
>> +=C2=A0=C2=A0=C2=A0 err =3D devm_register_netdev(&pdev->dev, dev);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk(KERN_ERR=
 "happymeal(PCI): Cannot register net device, "
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 "aborting.\n");
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_iounmap;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_clear_quattro=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pci_set_drvdata(pdev, hp);
>> @@ -3164,37 +3165,14 @@ static int happy_meal_pci_probe(struct pci_dev=
 *pdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> -err_out_iounmap:
>> -=C2=A0=C2=A0=C2=A0 iounmap(hp->gregs);
>> -
>> -err_out_free_res:
>> -=C2=A0=C2=A0=C2=A0 pci_release_regions(pdev);
>> -
>> =C2=A0 err_out_clear_quattro:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (qp !=3D NULL)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qp->happy_meals=
[qfe_slot] =3D NULL;
>> -=C2=A0=C2=A0=C2=A0 free_netdev(dev);
>> -
>> =C2=A0 err_out:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
>> =C2=A0 }
>> -static void happy_meal_pci_remove(struct pci_dev *pdev)
>> -{
>> -=C2=A0=C2=A0=C2=A0 struct happy_meal *hp =3D pci_get_drvdata(pdev);
>> -=C2=A0=C2=A0=C2=A0 struct net_device *net_dev =3D hp->dev;
>> -
>> -=C2=A0=C2=A0=C2=A0 unregister_netdev(net_dev);
>> -
>> -=C2=A0=C2=A0=C2=A0 dma_free_coherent(hp->dma_dev, PAGE_SIZE,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 hp->happy_block, hp->hblock_dvma);
>> -=C2=A0=C2=A0=C2=A0 iounmap(hp->gregs);
>> -=C2=A0=C2=A0=C2=A0 pci_release_regions(hp->happy_dev);
>> -
>> -=C2=A0=C2=A0=C2=A0 free_netdev(net_dev);
>> -}
>> -
>> =C2=A0 static const struct pci_device_id happymeal_pci_ids[] =3D {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 { PCI_DEVICE(PCI_VENDOR_ID_SUN, PCI_DEV=
ICE_ID_SUN_HAPPYMEAL) },
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 { }=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Terminating entry */
>> @@ -3206,7 +3184,6 @@ static struct pci_driver hme_pci_driver =3D {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .name=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 =3D "hme",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .id_table=C2=A0=C2=A0=C2=A0 =3D happyme=
al_pci_ids,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .probe=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 =3D happy_meal_pci_probe,
>> -=C2=A0=C2=A0=C2=A0 .remove=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
=3D happy_meal_pci_remove,
>> =C2=A0 };
>> =C2=A0 static int __init happy_meal_pci_init(void)
>>
>=20
> This looks good, but doesn't apply cleanly. I rebased it as follows:
>=20
>  From 5acfa13935277e312361c5630b49aea02399b8b8 Mon Sep 17 00:00:00 2001=

> From: Rolf Eike Beer <eike-kernel@sf-tec.de>
> Date: Mon, 14 Feb 2022 19:31:09 +0100
> Subject: [PATCH] sunhme: switch to devres
>=20
> This not only removes a lot of code, it also fixes the memleak of the D=
MA
> memory when register_netdev() fails.
>=20
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> [ rebased onto net-next/master ]
> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> Reviewed-by: Sean Anderson <seanga2@gmail.com>
> ---
>  =C2=A0drivers/net/ethernet/sun/sunhme.c | 59 +++++++++----------------=
------
>  =C2=A01 file changed, 16 insertions(+), 43 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/s=
un/sunhme.c
> index eebe8c5f480c..e83774ffaa7a 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2933,7 +2933,6 @@ static int happy_meal_pci_probe(struct pci_dev *p=
dev,
>  =C2=A0=C2=A0=C2=A0=C2=A0 struct happy_meal *hp;
>  =C2=A0=C2=A0=C2=A0=C2=A0 struct net_device *dev;
>  =C2=A0=C2=A0=C2=A0=C2=A0 void __iomem *hpreg_base;
> -=C2=A0=C2=A0=C2=A0 unsigned long hpreg_res;
>  =C2=A0=C2=A0=C2=A0=C2=A0 int i, qfe_slot =3D -1;
>  =C2=A0=C2=A0=C2=A0=C2=A0 char prom_name[64];
>  =C2=A0=C2=A0=C2=A0=C2=A0 u8 addr[ETH_ALEN];
> @@ -2950,7 +2949,7 @@ static int happy_meal_pci_probe(struct pci_dev *p=
dev,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strcpy(prom_name, "SU=
NW,hme");
>  =C2=A0#endif
>=20
> -=C2=A0=C2=A0=C2=A0 err =3D pci_enable_device(pdev);
> +=C2=A0=C2=A0=C2=A0 err =3D pcim_enable_device(pdev);
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 if (err)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out;
> @@ -2968,10 +2967,11 @@ static int happy_meal_pci_probe(struct pci_dev =
*pdev,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 goto err_out;
>  =C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> -=C2=A0=C2=A0=C2=A0 dev =3D alloc_etherdev(sizeof(struct happy_meal));
> -=C2=A0=C2=A0=C2=A0 err =3D -ENOMEM;
> -=C2=A0=C2=A0=C2=A0 if (!dev)
> +=C2=A0=C2=A0=C2=A0 dev =3D devm_alloc_etherdev(&pdev->dev, sizeof(stru=
ct happy_meal));
> +=C2=A0=C2=A0=C2=A0 if (!dev) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D -ENOMEM;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out;
> +=C2=A0=C2=A0=C2=A0 }
>  =C2=A0=C2=A0=C2=A0=C2=A0 SET_NETDEV_DEV(dev, &pdev->dev);
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 if (hme_version_printed++ =3D=3D 0)
> @@ -2990,21 +2990,23 @@ static int happy_meal_pci_probe(struct pci_dev =
*pdev,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qp->happy_meals[qfe_s=
lot] =3D dev;
>  =C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> -=C2=A0=C2=A0=C2=A0 hpreg_res =3D pci_resource_start(pdev, 0);
> -=C2=A0=C2=A0=C2=A0 err =3D -ENODEV;
>  =C2=A0=C2=A0=C2=A0=C2=A0 if ((pci_resource_flags(pdev, 0) & IORESOURCE=
_IO) !=3D 0) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk(KERN_ERR "happ=
ymeal(PCI): Cannot find proper PCI device base address.\n");
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_clear_qu=
attro;
>  =C2=A0=C2=A0=C2=A0=C2=A0 }
> -=C2=A0=C2=A0=C2=A0 if (pci_request_regions(pdev, DRV_NAME)) {
> +
> +=C2=A0=C2=A0=C2=A0 if (!devm_request_region(&pdev->dev, pci_resource_s=
tart(pdev, 0),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pci_resource_len(pdev, 0),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DRV_NAME)) {

Actually, it looks like you are failing to set err from these *m calls, l=
ike what
you fixed in patch 3. Can you address this for v2?

>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk(KERN_ERR "happ=
ymeal(PCI): Cannot obtain PCI resources, "
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 "aborting.\n");
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_clear_qu=
attro;
>  =C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> -=C2=A0=C2=A0=C2=A0 if ((hpreg_base =3D ioremap(hpreg_res, 0x8000)) =3D=
=3D NULL) {
> +=C2=A0=C2=A0=C2=A0 hpreg_base =3D pcim_iomap(pdev, 0, 0x8000);
> +=C2=A0=C2=A0=C2=A0 if (!hpreg_base) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk(KERN_ERR "happ=
ymeal(PCI): Unable to remap card memory.\n");
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_free_res;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_clear_quattro;=

>  =C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < 6; i++) {
> @@ -3070,11 +3072,10 @@ static int happy_meal_pci_probe(struct pci_dev =
*pdev,
>  =C2=A0=C2=A0=C2=A0=C2=A0 hp->happy_bursts =3D DMA_BURSTBITS;
>  =C2=A0#endif
>=20
> -=C2=A0=C2=A0=C2=A0 hp->happy_block =3D dma_alloc_coherent(&pdev->dev, =
PAGE_SIZE,
> +=C2=A0=C2=A0=C2=A0 hp->happy_block =3D dmam_alloc_coherent(&pdev->dev,=
 PAGE_SIZE,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 &hp->hblock_dvma, GFP_KERNEL);
> -=C2=A0=C2=A0=C2=A0 err =3D -ENODEV;
>  =C2=A0=C2=A0=C2=A0=C2=A0 if (!hp->happy_block)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_iounmap;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_clear_quattro;=

>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 hp->linkcheck =3D 0;
>  =C2=A0=C2=A0=C2=A0=C2=A0 hp->timer_state =3D asleep;
> @@ -3108,11 +3109,11 @@ static int happy_meal_pci_probe(struct pci_dev =
*pdev,
>  =C2=A0=C2=A0=C2=A0=C2=A0 happy_meal_set_initial_advertisement(hp);
>  =C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irq(&hp->happy_lock);
>=20
> -=C2=A0=C2=A0=C2=A0 err =3D register_netdev(hp->dev);
> +=C2=A0=C2=A0=C2=A0 err =3D devm_register_netdev(&pdev->dev, dev);
>  =C2=A0=C2=A0=C2=A0=C2=A0 if (err) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk(KERN_ERR "happ=
ymeal(PCI): Cannot register net device, "
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 "aborting.\n");
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_free_coherent;=

> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_clear_quattro;=

>  =C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 pci_set_drvdata(pdev, hp);
> @@ -3145,41 +3146,14 @@ static int happy_meal_pci_probe(struct pci_dev =
*pdev,
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>=20
> -err_out_free_coherent:
> -=C2=A0=C2=A0=C2=A0 dma_free_coherent(hp->dma_dev, PAGE_SIZE,
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 hp->happy_block, hp->hblock_dvma);
> -
> -err_out_iounmap:
> -=C2=A0=C2=A0=C2=A0 iounmap(hp->gregs);
> -
> -err_out_free_res:
> -=C2=A0=C2=A0=C2=A0 pci_release_regions(pdev);
> -
>  =C2=A0err_out_clear_quattro:
>  =C2=A0=C2=A0=C2=A0=C2=A0 if (qp !=3D NULL)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qp->happy_meals[qfe_s=
lot] =3D NULL;
>=20
> -=C2=A0=C2=A0=C2=A0 free_netdev(dev);
> -
>  =C2=A0err_out:
>  =C2=A0=C2=A0=C2=A0=C2=A0 return err;
>  =C2=A0}
>=20
> -static void happy_meal_pci_remove(struct pci_dev *pdev)
> -{
> -=C2=A0=C2=A0=C2=A0 struct happy_meal *hp =3D pci_get_drvdata(pdev);
> -=C2=A0=C2=A0=C2=A0 struct net_device *net_dev =3D hp->dev;
> -
> -=C2=A0=C2=A0=C2=A0 unregister_netdev(net_dev);
> -
> -=C2=A0=C2=A0=C2=A0 dma_free_coherent(hp->dma_dev, PAGE_SIZE,
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 hp->happy_block, hp->hblock_dvma);
> -=C2=A0=C2=A0=C2=A0 iounmap(hp->gregs);
> -=C2=A0=C2=A0=C2=A0 pci_release_regions(hp->happy_dev);
> -
> -=C2=A0=C2=A0=C2=A0 free_netdev(net_dev);
> -}
> -
>  =C2=A0static const struct pci_device_id happymeal_pci_ids[] =3D {
>  =C2=A0=C2=A0=C2=A0=C2=A0 { PCI_DEVICE(PCI_VENDOR_ID_SUN, PCI_DEVICE_ID=
_SUN_HAPPYMEAL) },
>  =C2=A0=C2=A0=C2=A0=C2=A0 { }=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 /* Terminating entry */
> @@ -3191,7 +3165,6 @@ static struct pci_driver hme_pci_driver =3D {
>  =C2=A0=C2=A0=C2=A0=C2=A0 .name=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =3D "hme",
>  =C2=A0=C2=A0=C2=A0=C2=A0 .id_table=C2=A0=C2=A0=C2=A0 =3D happymeal_pci=
_ids,
>  =C2=A0=C2=A0=C2=A0=C2=A0 .probe=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 =3D happy_meal_pci_probe,
> -=C2=A0=C2=A0=C2=A0 .remove=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=
 happy_meal_pci_remove,
>  =C2=A0};
>=20
>  =C2=A0static int __init happy_meal_pci_init(void)


